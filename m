Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF7644C7E0
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 19:53:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233141AbhKJS4c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 13:56:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:52542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232767AbhKJSyc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 13:54:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC89C619E4;
        Wed, 10 Nov 2021 18:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636570143;
        bh=pwMGl9lCryxqnCfHmLnLE5UYyxt6VERK7QOa10kP6g4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PG4q6ZEbXY1X1de4dVWuah1qHIi6OYUuKXVEC1pEOpLUKZeHwvi2LNE9zST7K5EKh
         LqXb/IeQhsNiOT1MVijKeR+ntXSr3G2cWSW3yno9m/Jexv7lMbpnL8mznN3CAMRLkT
         q8O1y/m+HChzIDk9zsQNpoN4ws3khWviAMUhohyA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Todd Kjos <tkjos@google.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.14 11/24] binder: use cred instead of task for selinux checks
Date:   Wed, 10 Nov 2021 19:44:03 +0100
Message-Id: <20211110182003.693550599@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211110182003.342919058@linuxfoundation.org>
References: <20211110182003.342919058@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Todd Kjos <tkjos@google.com>

commit 52f88693378a58094c538662ba652aff0253c4fe upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder.c      |   12 +++++-----
 include/linux/lsm_hook_defs.h |   14 ++++++------
 include/linux/lsm_hooks.h     |   14 ++++++------
 include/linux/security.h      |   28 ++++++++++++------------
 security/security.c           |   14 ++++++------
 security/selinux/hooks.c      |   48 +++++++++++-------------------------------
 6 files changed, 54 insertions(+), 76 deletions(-)

--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2056,7 +2056,7 @@ static int binder_translate_binder(struc
 		ret = -EINVAL;
 		goto done;
 	}
-	if (security_binder_transfer_binder(proc->tsk, target_proc->tsk)) {
+	if (security_binder_transfer_binder(proc->cred, target_proc->cred)) {
 		ret = -EPERM;
 		goto done;
 	}
@@ -2102,7 +2102,7 @@ static int binder_translate_handle(struc
 				  proc->pid, thread->pid, fp->handle);
 		return -EINVAL;
 	}
-	if (security_binder_transfer_binder(proc->tsk, target_proc->tsk)) {
+	if (security_binder_transfer_binder(proc->cred, target_proc->cred)) {
 		ret = -EPERM;
 		goto done;
 	}
@@ -2190,7 +2190,7 @@ static int binder_translate_fd(u32 fd, b
 		ret = -EBADF;
 		goto err_fget;
 	}
-	ret = security_binder_transfer_file(proc->tsk, target_proc->tsk, file);
+	ret = security_binder_transfer_file(proc->cred, target_proc->cred, file);
 	if (ret < 0) {
 		ret = -EPERM;
 		goto err_security;
@@ -2595,8 +2595,8 @@ static void binder_transaction(struct bi
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
@@ -4565,7 +4565,7 @@ static int binder_ioctl_set_ctx_mgr(stru
 		ret = -EBUSY;
 		goto out;
 	}
-	ret = security_binder_set_context_mgr(proc->tsk);
+	ret = security_binder_set_context_mgr(proc->cred);
 	if (ret < 0)
 		goto out;
 	if (uid_valid(context->binder_context_mgr_uid)) {
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
@@ -508,25 +508,25 @@ static inline int early_security_init(vo
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
--- a/security/security.c
+++ b/security/security.c
@@ -747,25 +747,25 @@ static int lsm_superblock_alloc(struct s
 
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
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -255,29 +255,6 @@ static inline u32 task_sid_obj(const str
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
@@ -2064,18 +2041,19 @@ static inline u32 open_file_to_av(struct
 
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
@@ -2086,24 +2064,24 @@ static int selinux_binder_transaction(st
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


