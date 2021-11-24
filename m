Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3843745B9A0
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:01:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231724AbhKXMDd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:03:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:58478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241909AbhKXMDa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:03:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB7D160F90;
        Wed, 24 Nov 2021 12:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755220;
        bh=s+IUBjLfu/aZ5tVxHmV/EqbpkKXRFJTzNIRBhzkdWME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=brBGWtQ04k6CmMrmxC/gPEzoAvDn+T6skw6rgcLjqnA5Q1sbtucxS5lX196PiRofC
         +BXtIk+sHPE9ff2qi3Z8i4/dpLGTxnZtEkrHjwipKglVRWjmad85HdRuxMwSjLA64T
         7xfIeeB8v88iT50rcoY5w+zqnaktatIVHs2X8ycc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Todd Kjos <tkjos@google.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Paul Moore <paul@paul-moore.com>
Subject: [PATCH 4.4 002/162] binder: use cred instead of task for selinux checks
Date:   Wed, 24 Nov 2021 12:55:05 +0100
Message-Id: <20211124115658.411427709@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115658.328640564@linuxfoundation.org>
References: <20211124115658.328640564@linuxfoundation.org>
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
 drivers/android/binder.c  |   18 +++++++++---------
 include/linux/lsm_hooks.h |   32 ++++++++++++++++----------------
 include/linux/security.h  |   28 ++++++++++++++--------------
 security/security.c       |   14 +++++++-------
 security/selinux/hooks.c  |   31 +++++++++++++------------------
 5 files changed, 59 insertions(+), 64 deletions(-)

--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -1420,8 +1420,8 @@ static void binder_transaction(struct bi
 			return_error = BR_FAILED_REPLY;
 			goto err_invalid_target_handle;
 		}
-		if (security_binder_transaction(proc->tsk,
-						target_proc->tsk) < 0) {
+		if (security_binder_transaction(proc->cred,
+						target_proc->cred) < 0) {
 			return_error = BR_FAILED_REPLY;
 			goto err_invalid_target_handle;
 		}
@@ -1576,8 +1576,8 @@ static void binder_transaction(struct bi
 				return_error = BR_FAILED_REPLY;
 				goto err_binder_get_ref_for_node_failed;
 			}
-			if (security_binder_transfer_binder(proc->tsk,
-							    target_proc->tsk)) {
+			if (security_binder_transfer_binder(proc->cred,
+							    target_proc->cred)) {
 				return_error = BR_FAILED_REPLY;
 				goto err_binder_get_ref_for_node_failed;
 			}
@@ -1616,8 +1616,8 @@ static void binder_transaction(struct bi
 				return_error = BR_FAILED_REPLY;
 				goto err_binder_get_ref_failed;
 			}
-			if (security_binder_transfer_binder(proc->tsk,
-							    target_proc->tsk)) {
+			if (security_binder_transfer_binder(proc->cred,
+							    target_proc->cred)) {
 				return_error = BR_FAILED_REPLY;
 				goto err_binder_get_ref_failed;
 			}
@@ -1680,8 +1680,8 @@ static void binder_transaction(struct bi
 				return_error = BR_FAILED_REPLY;
 				goto err_fget_failed;
 			}
-			if (security_binder_transfer_file(proc->tsk,
-							  target_proc->tsk,
+			if (security_binder_transfer_file(proc->cred,
+							  target_proc->cred,
 							  file) < 0) {
 				fput(file);
 				return_error = BR_FAILED_REPLY;
@@ -2763,7 +2763,7 @@ static int binder_ioctl_set_ctx_mgr(stru
 		ret = -EBUSY;
 		goto out;
 	}
-	ret = security_binder_set_context_mgr(proc->tsk);
+	ret = security_binder_set_context_mgr(proc->cred);
 	if (ret < 0)
 		goto out;
 	if (uid_valid(binder_context_mgr_uid)) {
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -1121,22 +1121,22 @@
  *
  * @binder_set_context_mgr
  *	Check whether @mgr is allowed to be the binder context manager.
- *	@mgr contains the task_struct for the task being registered.
+ *	@mgr contains the struct cred for the current binder process.
  *	Return 0 if permission is granted.
  * @binder_transaction
  *	Check whether @from is allowed to invoke a binder transaction call
  *	to @to.
- *	@from contains the task_struct for the sending task.
- *	@to contains the task_struct for the receiving task.
- * @binder_transfer_binder
+ *	@from contains the struct cred for the sending process.
+ *	@to contains the struct cred for the receiving process.
+ * @binder_transfer_binder:
  *	Check whether @from is allowed to transfer a binder reference to @to.
- *	@from contains the task_struct for the sending task.
- *	@to contains the task_struct for the receiving task.
- * @binder_transfer_file
+ *	@from contains the struct cred for the sending process.
+ *	@to contains the struct cred for the receiving process.
+ * @binder_transfer_file:
  *	Check whether @from is allowed to transfer @file to @to.
- *	@from contains the task_struct for the sending task.
+ *	@from contains the struct cred for the sending process.
  *	@file contains the struct file being transferred.
- *	@to contains the task_struct for the receiving task.
+ *	@to contains the struct cred for the receiving process.
  *
  * @ptrace_access_check:
  *	Check permission before allowing the current process to trace the
@@ -1301,13 +1301,13 @@
  */
 
 union security_list_options {
-	int (*binder_set_context_mgr)(struct task_struct *mgr);
-	int (*binder_transaction)(struct task_struct *from,
-					struct task_struct *to);
-	int (*binder_transfer_binder)(struct task_struct *from,
-					struct task_struct *to);
-	int (*binder_transfer_file)(struct task_struct *from,
-					struct task_struct *to,
+	int (*binder_set_context_mgr)(const struct cred *mgr);
+	int (*binder_transaction)(const struct cred *from,
+					const struct cred *to);
+	int (*binder_transfer_binder)(const struct cred *from,
+					const struct cred *to);
+	int (*binder_transfer_file)(const struct cred *from,
+					const struct cred *to,
 					struct file *file);
 
 	int (*ptrace_access_check)(struct task_struct *child,
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -182,13 +182,13 @@ static inline void security_free_mnt_opt
 extern int security_init(void);
 
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
@@ -378,25 +378,25 @@ static inline int security_init(void)
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
@@ -130,25 +130,25 @@ int __init security_module_enable(const
 
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
@@ -1974,21 +1974,18 @@ static inline u32 open_file_to_av(struct
 
 /* Hook functions begin here. */
 
-static int selinux_binder_set_context_mgr(struct task_struct *mgr)
+static int selinux_binder_set_context_mgr(const struct cred *mgr)
 {
-	u32 mysid = current_sid();
-	u32 mgrsid = task_sid(mgr);
-
-	return avc_has_perm(mysid, mgrsid, SECCLASS_BINDER,
+	return avc_has_perm(current_sid(), cred_sid(mgr), SECCLASS_BINDER,
 			    BINDER__SET_CONTEXT_MGR, NULL);
 }
 
-static int selinux_binder_transaction(struct task_struct *from,
-				      struct task_struct *to)
+static int selinux_binder_transaction(const struct cred *from,
+				      const struct cred *to)
 {
 	u32 mysid = current_sid();
-	u32 fromsid = task_sid(from);
-	u32 tosid = task_sid(to);
+	u32 fromsid = cred_sid(from);
+	u32 tosid = cred_sid(to);
 	int rc;
 
 	if (mysid != fromsid) {
@@ -2002,21 +1999,19 @@ static int selinux_binder_transaction(st
 			    NULL);
 }
 
-static int selinux_binder_transfer_binder(struct task_struct *from,
-					  struct task_struct *to)
+static int selinux_binder_transfer_binder(const struct cred *from,
+					  const struct cred *to)
 {
-	u32 fromsid = task_sid(from);
-	u32 tosid = task_sid(to);
-
-	return avc_has_perm(fromsid, tosid, SECCLASS_BINDER, BINDER__TRANSFER,
+	return avc_has_perm(cred_sid(from), cred_sid(to),
+			    SECCLASS_BINDER, BINDER__TRANSFER,
 			    NULL);
 }
 
-static int selinux_binder_transfer_file(struct task_struct *from,
-					struct task_struct *to,
+static int selinux_binder_transfer_file(const struct cred *from,
+					const struct cred *to,
 					struct file *file)
 {
-	u32 sid = task_sid(to);
+	u32 sid = cred_sid(to);
 	struct file_security_struct *fsec = file->f_security;
 	struct inode *inode = d_backing_inode(file->f_path.dentry);
 	struct inode_security_struct *isec = inode->i_security;


