//
//  NotesTVC.swift
//  CrashCourse-UIKit
//
//  Created by Tomas Srna on 18/04/16.
//  Copyright © 2016 SRNA. All rights reserved.
//

import UIKit
import CoreData

class NotesTVC : UITableViewController {
    
    enum Constants: String {
        case TaskCellReuseIdentifier = "NoteCell"
    }
    
    var task : Task!
    
    // MARK: View Controller Lifecycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
    }
    
    func refresh() {
        tableView.reloadData()
    }
    
    // MARK: UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return task.notes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.TaskCellReuseIdentifier.rawValue)!
        
        let note = task.notes[indexPath.row]
        cell.textLabel?.text = note.text
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        return [UITableViewRowAction(style: .Destructive, title: "Delete", handler: { action, indexPath in
            tableView.beginUpdates()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            self.task.notes.removeAtIndex(indexPath.row)
            tableView.endUpdates()
        })]
    }
    
    // MARK: Add Action
    
    @IBAction func addAction(sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Note", message: "Add note for \(task.name)", preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Note"
        }
        alert.addAction(UIAlertAction(title: "Save", style: .Default, handler: { (action) in
            if let tfs = alert.textFields {
                let noteTF = tfs[0]
                let newNote = Note(text: noteTF.text!, task: self.task)
                self.tableView.beginUpdates()
                self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.task.notes.count, inSection: 0)], withRowAnimation: .Automatic)
                self.task.notes.append(newNote)
                self.tableView.endUpdates()
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
}

