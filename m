Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 854C044A784
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 08:23:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243615AbhKIH02 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 02:26:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:41526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243606AbhKIH01 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 02:26:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 64CA26115B;
        Tue,  9 Nov 2021 07:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636442621;
        bh=7WwjLjZjmCjFcNnAJQBW3UrpdiP4txDFYxhl6t3ehSs=;
        h=Subject:To:Cc:From:Date:From;
        b=Cpe3duDFpWpGAWvP1ZHRweZhvqOzFAr1dfprKlQQMx1jRwIU6SSe5Gq3cGRiCNAyM
         o/aSXloYlFlTxR4EgstYOFbQ5Z2+m87ITjlUteh4geszVtLl2RzBif6g9PmN2FVqce
         ZdWgfbKT6y1Svw85k3wvZv2x+MExvha3RduV4t/c=
Subject: FAILED: patch "[PATCH] binder: use cred instead of task for selinux checks" failed to apply to 4.14-stable tree
To:     tkjos@google.com, casey@schaufler-ca.com, jannh@google.com,
        paul@paul-moore.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 09 Nov 2021 08:23:37 +0100
Message-ID: <163644261720110@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 52f88693378a58094c538662ba652aff0253c4fe Mon Sep 17 00:00:00 2001
From: Todd Kjos <tkjos@google.com>
Date: Tue, 12 Oct 2021 09:56:13 -0700
Subject: [PATCH] binder: use cred instead of task for selinux checks

Since binder was integrated with selinux, it has passed
'struct task_struct' associated with the binder_proc
to represent the source and target of transactions.
The conversion of task to SID was then done in the hook
implementations. It turns out that there are race conditions
which can result in an incorrect security context being used.

Fix by using the 'struct cred' saved during binder_open and pass
it to the selinux subsystem.

Cc: stable@vger.kernel.org # 5.14 (need backport for earlier stables)
Fixes: 79af73079d75 ("Add security hooks to binder and implement the hooks for SELinux.")
Suggested-by: Jann Horn <jannh@google.com>
Signed-off-by: Todd Kjos <tkjos@google.com>
Acked-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index 231cff9b3b75..1571e01cfa52 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2047,7 +2047,7 @@ static int binder_translate_binder(struct flat_binder_object *fp,
 		ret = -EINVAL;
 		goto done;
 	}
-	if (security_binder_transfer_binder(proc->tsk, target_proc->tsk)) {
+	if (security_binder_transfer_binder(proc->cred, target_proc->cred)) {
 		ret = -EPERM;
 		goto done;
 	}
@@ -2093,7 +2093,7 @@ static int binder_translate_handle(struct flat_binder_object *fp,
 				  proc->pid, thread->pid, fp->handle);
 		return -EINVAL;
 	}
-	if (security_binder_transfer_binder(proc->tsk, target_proc->tsk)) {
+	if (security_binder_transfer_binder(proc->cred, target_proc->cred)) {
 		ret = -EPERM;
 		goto done;
 	}
@@ -2181,7 +2181,7 @@ static int binder_translate_fd(u32 fd, binder_size_t fd_offset,
 		ret = -EBADF;
 		goto err_fget;
 	}
-	ret = security_binder_transfer_file(proc->tsk, target_proc->tsk, file);
+	ret = security_binder_transfer_file(proc->cred, target_proc->cred, file);
 	if (ret < 0) {
 		ret = -EPERM;
 		goto err_security;
@@ -2586,8 +2586,8 @@ static void binder_transaction(struct binder_proc *proc,
 			return_error_line = __LINE__;
 			goto err_invalid_target_handle;
 		}
-		if (security_binder_transaction(proc->tsk,
-						target_proc->tsk) < 0) {
+		if (security_binder_transaction(proc->cred,
+						target_proc->cred) < 0) {
 			return_error = BR_FAILED_REPLY;
 			return_error_param = -EPERM;
 			return_error_line = __LINE__;
@@ -4555,7 +4555,7 @@ static int binder_ioctl_set_ctx_mgr(struct file *filp,
 		ret = -EBUSY;
 		goto out;
 	}
-	ret = security_binder_set_context_mgr(proc->tsk);
+	ret = security_binder_set_context_mgr(proc->cred);
 	if (ret < 0)
 		goto out;
 	if (uid_valid(context->binder_context_mgr_uid)) {
diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index b3c525353769..4c7ed0268ce3 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -26,13 +26,13 @@
  *   #undef LSM_HOOK
  * };
  */
-LSM_HOOK(int, 0, binder_set_context_mgr, struct task_struct *mgr)
-LSM_HOOK(int, 0, binder_transaction, struct task_struct *from,
-	 struct task_struct *to)
-LSM_HOOK(int, 0, binder_transfer_binder, struct task_struct *from,
-	 struct task_struct *to)
-LSM_HOOK(int, 0, binder_transfer_file, struct task_struct *from,
-	 struct task_struct *to, struct file *file)
+LSM_HOOK(int, 0, binder_set_context_mgr, const struct cred *mgr)
+LSM_HOOK(int, 0, binder_transaction, const struct cred *from,
+	 const struct cred *to)
+LSM_HOOK(int, 0, binder_transfer_binder, const struct cred *from,
+	 const struct cred *to)
+LSM_HOOK(int, 0, binder_transfer_file, const struct cred *from,
+	 const struct cred *to, struct file *file)
 LSM_HOOK(int, 0, ptrace_access_check, struct task_struct *child,
 	 unsigned int mode)
 LSM_HOOK(int, 0, ptrace_traceme, struct task_struct *parent)
diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index 0eb0ae95c4c4..528554e9b90c 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -1313,22 +1313,22 @@
  *
  * @binder_set_context_mgr:
  *	Check whether @mgr is allowed to be the binder context manager.
- *	@mgr contains the task_struct for the task being registered.
+ *	@mgr contains the struct cred for the current binder process.
  *	Return 0 if permission is granted.
  * @binder_transaction:
  *	Check whether @from is allowed to invoke a binder transaction call
  *	to @to.
- *	@from contains the task_struct for the sending task.
- *	@to contains the task_struct for the receiving task.
+ *	@from contains the struct cred for the sending process.
+ *	@to contains the struct cred for the receiving process.
  * @binder_transfer_binder:
  *	Check whether @from is allowed to transfer a binder reference to @to.
- *	@from contains the task_struct for the sending task.
- *	@to contains the task_struct for the receiving task.
+ *	@from contains the struct cred for the sending process.
+ *	@to contains the struct cred for the receiving process.
  * @binder_transfer_file:
  *	Check whether @from is allowed to transfer @file to @to.
- *	@from contains the task_struct for the sending task.
+ *	@from contains the struct cred for the sending process.
  *	@file contains the struct file being transferred.
- *	@to contains the task_struct for the receiving task.
+ *	@to contains the struct cred for the receiving process.
  *
  * @ptrace_access_check:
  *	Check permission before allowing the current process to trace the
diff --git a/include/linux/security.h b/include/linux/security.h
index 7979b9629a42..9be72166e859 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -258,13 +258,13 @@ extern int security_init(void);
 extern int early_security_init(void);
 
 /* Security operations */
-int security_binder_set_context_mgr(struct task_struct *mgr);
-int security_binder_transaction(struct task_struct *from,
-				struct task_struct *to);
-int security_binder_transfer_binder(struct task_struct *from,
-				    struct task_struct *to);
-int security_binder_transfer_file(struct task_struct *from,
-				  struct task_struct *to, struct file *file);
+int security_binder_set_context_mgr(const struct cred *mgr);
+int security_binder_transaction(const struct cred *from,
+				const struct cred *to);
+int security_binder_transfer_binder(const struct cred *from,
+				    const struct cred *to);
+int security_binder_transfer_file(const struct cred *from,
+				  const struct cred *to, struct file *file);
 int security_ptrace_access_check(struct task_struct *child, unsigned int mode);
 int security_ptrace_traceme(struct task_struct *parent);
 int security_capget(struct task_struct *target,
@@ -508,25 +508,25 @@ static inline int early_security_init(void)
 	return 0;
 }
 
-static inline int security_binder_set_context_mgr(struct task_struct *mgr)
+static inline int security_binder_set_context_mgr(const struct cred *mgr)
 {
 	return 0;
 }
 
-static inline int security_binder_transaction(struct task_struct *from,
-					      struct task_struct *to)
+static inline int security_binder_transaction(const struct cred *from,
+					      const struct cred *to)
 {
 	return 0;
 }
 
-static inline int security_binder_transfer_binder(struct task_struct *from,
-						  struct task_struct *to)
+static inline int security_binder_transfer_binder(const struct cred *from,
+						  const struct cred *to)
 {
 	return 0;
 }
 
-static inline int security_binder_transfer_file(struct task_struct *from,
-						struct task_struct *to,
+static inline int security_binder_transfer_file(const struct cred *from,
+						const struct cred *to,
 						struct file *file)
 {
 	return 0;
diff --git a/security/security.c b/security/security.c
index 40518c340571..d9d53c1e466a 100644
--- a/security/security.c
+++ b/security/security.c
@@ -747,25 +747,25 @@ static int lsm_superblock_alloc(struct super_block *sb)
 
 /* Security operations */
 
-int security_binder_set_context_mgr(struct task_struct *mgr)
+int security_binder_set_context_mgr(const struct cred *mgr)
 {
 	return call_int_hook(binder_set_context_mgr, 0, mgr);
 }
 
-int security_binder_transaction(struct task_struct *from,
-				struct task_struct *to)
+int security_binder_transaction(const struct cred *from,
+				const struct cred *to)
 {
 	return call_int_hook(binder_transaction, 0, from, to);
 }
 
-int security_binder_transfer_binder(struct task_struct *from,
-				    struct task_struct *to)
+int security_binder_transfer_binder(const struct cred *from,
+				    const struct cred *to)
 {
 	return call_int_hook(binder_transfer_binder, 0, from, to);
 }
 
-int security_binder_transfer_file(struct task_struct *from,
-				  struct task_struct *to, struct file *file)
+int security_binder_transfer_file(const struct cred *from,
+				  const struct cred *to, struct file *file)
 {
 	return call_int_hook(binder_transfer_file, 0, from, to, file);
 }
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 49d52d7a7714..b4a1bde20261 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -255,29 +255,6 @@ static inline u32 task_sid_obj(const struct task_struct *task)
 	return sid;
 }
 
-/*
- * get the security ID of a task for use with binder
- */
-static inline u32 task_sid_binder(const struct task_struct *task)
-{
-	/*
-	 * In many case where this function is used we should be using the
-	 * task's subjective SID, but we can't reliably access the subjective
-	 * creds of a task other than our own so we must use the objective
-	 * creds/SID, which are safe to access.  The downside is that if a task
-	 * is temporarily overriding it's creds it will not be reflected here;
-	 * however, it isn't clear that binder would handle that case well
-	 * anyway.
-	 *
-	 * If this ever changes and we can safely reference the subjective
-	 * creds/SID of another task, this function will make it easier to
-	 * identify the various places where we make use of the task SIDs in
-	 * the binder code.  It is also likely that we will need to adjust
-	 * the main drivers/android binder code as well.
-	 */
-	return task_sid_obj(task);
-}
-
 static int inode_doinit_with_dentry(struct inode *inode, struct dentry *opt_dentry);
 
 /*
@@ -2067,18 +2044,19 @@ static inline u32 open_file_to_av(struct file *file)
 
 /* Hook functions begin here. */
 
-static int selinux_binder_set_context_mgr(struct task_struct *mgr)
+static int selinux_binder_set_context_mgr(const struct cred *mgr)
 {
 	return avc_has_perm(&selinux_state,
-			    current_sid(), task_sid_binder(mgr), SECCLASS_BINDER,
+			    current_sid(), cred_sid(mgr), SECCLASS_BINDER,
 			    BINDER__SET_CONTEXT_MGR, NULL);
 }
 
-static int selinux_binder_transaction(struct task_struct *from,
-				      struct task_struct *to)
+static int selinux_binder_transaction(const struct cred *from,
+				      const struct cred *to)
 {
 	u32 mysid = current_sid();
-	u32 fromsid = task_sid_binder(from);
+	u32 fromsid = cred_sid(from);
+	u32 tosid = cred_sid(to);
 	int rc;
 
 	if (mysid != fromsid) {
@@ -2089,24 +2067,24 @@ static int selinux_binder_transaction(struct task_struct *from,
 			return rc;
 	}
 
-	return avc_has_perm(&selinux_state, fromsid, task_sid_binder(to),
+	return avc_has_perm(&selinux_state, fromsid, tosid,
 			    SECCLASS_BINDER, BINDER__CALL, NULL);
 }
 
-static int selinux_binder_transfer_binder(struct task_struct *from,
-					  struct task_struct *to)
+static int selinux_binder_transfer_binder(const struct cred *from,
+					  const struct cred *to)
 {
 	return avc_has_perm(&selinux_state,
-			    task_sid_binder(from), task_sid_binder(to),
+			    cred_sid(from), cred_sid(to),
 			    SECCLASS_BINDER, BINDER__TRANSFER,
 			    NULL);
 }
 
-static int selinux_binder_transfer_file(struct task_struct *from,
-					struct task_struct *to,
+static int selinux_binder_transfer_file(const struct cred *from,
+					const struct cred *to,
 					struct file *file)
 {
-	u32 sid = task_sid_binder(to);
+	u32 sid = cred_sid(to);
 	struct file_security_struct *fsec = selinux_file(file);
 	struct dentry *dentry = file->f_path.dentry;
 	struct inode_security_struct *isec;

