//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Proporties
    var timer: Timer?
    var counter = 0
    var calculator = LogicCalculation()

    // MARK: - IBOutlets
    @IBOutlet weak var textView: UITextView!
    @IBOutlet var numberButtons: [UIButton]!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var gifImage: UIImageView!

    // MARK: - Life Cycle
    /// Launch Animation on image
    /// - Parameter animated: animation willAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gifImage.loadGif(name: "gifCalculation")
    }

    /// init and start timer
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,
                                     selector: #selector(progressTimer), userInfo: nil, repeats: true)
    }
    
    // MARK: - Action
    /// Timer for presentedImage
    @objc func progressTimer() {
        counter += 1
        if counter == 5 {
            gifImage.isHidden = true
            timer?.invalidate()
            timer = nil
        }
    }

    // MARK: - IBActions
    
    /// erase calculations on going
    /// - Parameter sender: AC button
    @IBAction func resetCalcul(_ sender: UIButton) {
        calculator.resetCalculation()
        resetButton.setTitle("AC", for: .normal)
        textView.text = calculator.formatCalculToText()
    }

    /// add number in calculation
    /// - Parameter sender: numbers buttons
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {
            return
        }
        calculator.resetCalculationIfNeed()
        calculator.addNumber(number: numberText)
        textView.text = calculator.formatCalculToText()
        resetButton.setTitle("C", for: .normal)
    }

    /// add operator on calculation
    /// - Parameter sender: are operators buttons
    @IBAction func tappedOperatorButton(_ sender: UIButton) {
        guard let textOperator = sender.title(for: .normal), calculator.canAddOperator() else {
            presentAlert_Alert(alertMessage: "Veuillez inscrire un nombre avant")
            return
        }
        calculator.addOperator(newOperator: textOperator)
        textView.text = calculator.formatCalculToText()
    }

    /// check calculation is good and make calculation
    /// - Parameter sender: equal button
    @IBAction func tappedEqualButton(_ sender: UIButton) {
        guard !calculator.calculationIsFinish else {
            presentAlert_Alert(alertMessage: "Le calcul est terminé."
                               + "\nPressez un nombre pour commencer un nouveau calcul.")
            return
        }

        if calculator.isCalculationValid() {
            textView.text.append(" = " + calculator.equal())
        } else {
            presentAlert_Alert(alertMessage: "Veuillez entrer une expression correcte")
        }
    }

    // MARK: - Private function
    /// Present alert message to user
    private func presentAlert_Alert (alertTitle title: String = "Erreur",
                                     alertMessage message: String,
                                     buttonTitle titleButton: String = "Ok",
                                     alertStyle style: UIAlertAction.Style = .cancel) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: titleButton, style: style, handler: nil)
        alertVC.addAction(action)
        present(alertVC, animated: true, completion: nil)
    }
}