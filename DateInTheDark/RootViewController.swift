//
//  RootViewController.swift
//  DateInTheDark
//
//  Created by Matan Cohen on 9/8/16.
//  Copyright © 2016 MC. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class RootViewController :UIViewController {
    let loginViewController: UIViewController
    let mainNavigationController: UIViewController
    let viewModel: RootViewModelType
    let disposeBag = DisposeBag()
    var didBind = false
    
    init(_ loginViewController: UIViewController, mainNavigationController: UIViewController, viewModel: RootViewModelType) {
        self.loginViewController = loginViewController
        self.mainNavigationController = mainNavigationController
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
     
        if self.didBind == false {
            self.self.bindViewModel()
        }
        self.didBind = true
    }
    
    func bindViewModel() {
        let disponse = self.viewModel.showLogin.subscribeNext { [weak self] (show) in
            if show == true {
                self?.showLoginScreen()
            } else {
                self?.showMainApplication()
            }
        }
        disponse.addDisposableTo(self.disposeBag)
    }
    
    //MARK: Show screens
    
    func showLoginScreen() {
        self.dissmissLastController{
          self.presentViewController(self.loginViewController, animated: true, completion: nil)
        }
    }
    
    func showMainApplication() {
        self.dissmissLastController { 
         self.presentViewController(self.mainNavigationController, animated: true, completion: nil)
        }
    }
    

    func dissmissLastController(finsihedBlock:()->Void) {
        let animated = false
        if self.presentedViewController != nil {
            self.dismissViewControllerAnimated(animated, completion: { 
                finsihedBlock()
            })
        } else {
                finsihedBlock()
        }
    }
}