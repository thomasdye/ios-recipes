//
//  MainViewController.swift
//  Recipes
//
//  Created by Casualty on 9/4/19.
//  Copyright © 2019 Lambda Inc. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    var recipesTableViewController:
        RecipesTableViewController? {
        didSet {
            recipesTableViewController?.recipes = filteredRecipes
        }
    }
    let networkClient = RecipesNetworkClient()
    var recipeList: [Recipe] = [] {
        didSet {
            filterRecipes()
        }
    }
    var filteredRecipes: [Recipe] = [] {
        didSet {
            recipesTableViewController?.recipes = filteredRecipes
            recipesTableViewController?.tableView.reloadData()
        }
    }
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var reloadButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //if allRecipes.count == 0 {
        networkClient.fetchRecipes{ (recipes, error) in
            if let error = error {
                NSLog("Error getting recipes: \(error)")
                return
            }
            self.recipeList = recipes ?? []
        }
    }
    
    func filterRecipes () {
        
        DispatchQueue.main.async {
            if let text = self.textField.text, text != "" {
                self.filteredRecipes = self.recipeList.filter{ recipe in recipe.name.contains(text) || recipe.instructions.contains(text) || recipe.difficulty.contains(text) || recipe.mealTime.contains(text)}
            }
            else {
                self.filteredRecipes = self.recipeList
            }
            self.reloadButtonVisibility()
           
        }
    }
    
    @IBAction func sortUserString(_ sender: Any) {
        resignFirstResponder()
        filterRecipes()
    }
    
    @IBAction func textFieldshouldReturn(_ sender: Any) {
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        self.filteredRecipes = self.recipeList
        self.textField.text = nil
        reloadButton.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    func reloadButtonVisibility() {
        
        if self.textField.text == "" {
            reloadButton.isEnabled = false
        } else {
            reloadButton.isEnabled = true
            
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "RecipesViewSegue" {
            let recipesTableVC = segue.destination as! RecipesTableViewController
            recipesTableViewController = recipesTableVC
        }
    }
}
