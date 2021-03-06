;; -*- mode: elisp -*-

;; Disable the splash screen (to enable it agin, replace the t with 0)
(setq inhibit-splash-screen t)

;; Enable transient mark mode
(transient-mark-mode 1)

;; Username
(setq user-full-name "Taylan Dogan"
      user-mail-address "ttaylan.dogann@gmail.com")

;; Enable org-mode
(require 'org)
;; Make org-mode work with files ending in .org
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))

;; Load your ./load folder and .emacs.d/el-get
;; Load your load directory
;; A function to load every .el file under a directory

(defun my-load-all-in-directory (dir)
  "`load' all elisp libraries in directory DIR which are not already loaded."
  (interactive "D")
  (let ((libraries-loaded (mapcar #'file-name-sans-extension
                                  (delq nil (mapcar #'car load-history)))))
    (dolist (file (directory-files dir t ".+\\.elc?$"))
      (let ((library (file-name-sans-extension file)))
        (unless (member library libraries-loaded)
          (load library nil t)
          (push library libraries-loaded))))))

;;(my-load-all-in-directory "~/local/emacs-org/load")

;; To-do workflow
;; Changing task state is done with C-c C-t KEY
;; Or you can cycle through states by pressing S-left or S-right
(setq org-use-fast-todo-selection t)
(setq org-todo-keywords '((sequence "TODO(t)" "IN-PROGRESS(p)" "WAITING(w)" "|" "DONE(d)" "DELEGATED(g)" "CANCELLED(c)" "LATER(l)")))

;; Tags for to-do elements
(setq org-tag-alist '(("@work" . ?w)("@home" . ?h)("@programming" . ?p)("@drawing" . ?d)("@projects" . ?r)("@personal" . ?t)))

;; Agenda file directory
(setq org-agenda-files '("~/local/emacs-org/agendas"))

;; Agenda settings - it might be useful in the future
;;(setq org-agenda-custom-commands '(("h" "Home" tags-todo "home")  ("w" "Work" tags-todo "work")))
(setq org-agenda-custom-commands
      '(("d" "Daily agenda" ((agenda "" ((org-agenda-ndays 1)) (alltodo))))))

;; My key bindings
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb) ;; I'm not sure what this does

;;(global-set-key "\C-xp" 'pop-to-mark-command) ;; I don't think this one works, I couldn't debug it lol
;;(setq set-mark-command-repeat-pop t) ;; Google it -> "emacs mark ring"

;; Stash backup files to here
(setq backup-directory-alist '(("." . "~/local/emacs-org/backups")))

;; Change "yes or no" to "y or n"
(fset 'yes-or-no-p 'y-or-n-p)

;; Insert time stamp on done
(setq org-log-done 'time)

;; Setting up capture (its purpose is to quickly take notes and put them in Notes.org (customizable))
;; Enter capture by pressing C-c n (customizable)
(setq org-default-notes-file (concat org-directory "/agendas/Notes.org"))
(define-key global-map "\C-cn" 'org-capture)

;; Archive settings
(setq org-archive-location (concat org-directory "/archive/Archive.org::"))

(defun my/org-archive-done-tasks ()
  "Archive finished or cancelled tasks."
  (interactive)
  (org-map-entries
   (lambda ()
     (org-archive-subtree)
     (setq org-map-continue-from (outline-previous-heading)))
   "TODO=\"DONE\"|TODO=\"CANCELLED\"" (if (org-before-first-heading-p) 'file 'tree)))

;;Refile settings
(setq org-refile-targets (quote ((nil :maxlevel . 1)
                                 (org-agenda-files :maxlevel . 1))))

;; Setting some variables
(custom-set-variables
	'(org-deadline-warning-days 4)
	'(org-agenda-skip-deadline-if-done t)
	'(org-agenda-skip-scheduled-if-done t))


;; Settings for Mobile-org-mode, if you do not want to use mobile-org comment out the lines below

;; Set the location of your Org files on your local system
(setq org-directory "~/local/emacs-org")
;; Set the name of the file where new notes will be stored
(setq org-mobile-inbox-for-pull (concat org-directory "/agendas/Mobile.org"))
;; Set <your Dropbox root directory>/MobileOrg.
(setq org-mobile-directory "~/Dropbox/Apps/MobileOrg")
