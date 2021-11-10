Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D33844CD66
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 00:00:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234046AbhKJXCu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 18:02:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234026AbhKJXCr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Nov 2021 18:02:47 -0500
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90AFCC0613F5
        for <stable@vger.kernel.org>; Wed, 10 Nov 2021 14:59:59 -0800 (PST)
Received: by mail-qk1-x749.google.com with SMTP id j6-20020a05620a288600b0045e5d85ca17so2892287qkp.16
        for <stable@vger.kernel.org>; Wed, 10 Nov 2021 14:59:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=yodXsB/LC9/xyYOOGuFO8Hn+kQvyNwNQ7uyTGLE9MZA=;
        b=ev6RRXUSECo8qqAULAD80rfRkd1JKL2BgQtesd8rGdAGOYDmMQPQBi9NuwFmQ9LPYQ
         cvtkw6RlcAZoK8GZm0FTkzexktlIuArkY9rZyx2JkoeKQ7txzChBKtIaPIJY9N2ixZiH
         BR8JRT/hDKa6DrtumfrKvAZpM+7OeUBnhWNMJ1k/Lb55a/vEPuVfJR5V4NrJM+Tm3o/b
         8eLeYAPx1er2rLaahnHXrjcv9WukwxuIDaIUVPUEShnX3sSLsQPneGO8viY61P08ENOX
         gD4jNt41lTwqIiSc0kSFSBAmJHp7TvtoosZCjmHn0t/sx5Z2SzmZgmnXpz+u1x4M/cpb
         gNRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=yodXsB/LC9/xyYOOGuFO8Hn+kQvyNwNQ7uyTGLE9MZA=;
        b=5gte0KXYvW4srbI7FDFmBMg2rEg0cj1XlXdRT3yz+B2fLNHaic/k8cBQsblIBLX8XQ
         REm4W7ZEJVja32zdSi6MV4WA/Um1aUHQMLkSdgbyLaCH2Jpq6q1/jfFD/wgI2uN9cA6d
         qZj4HFygrEEMxOJPrTXMwbNr5qDFQKZq4XHGJ8XT2fsfCTIQTBiD0npn2CiQFmV51YHS
         3gKytCp36GxGiL62Bf9NLfqcQ8w5ESWd6bLXOpvHeNYMctadeOy30/+Si97YeGSGpQ4k
         IdwnbpaV1yIemxSXBaKkSc+heYyu4bxAMXY565K3G38p6SJzmkKnK+NHilnkLVJFfNzd
         U+sw==
X-Gm-Message-State: AOAM531bjyrpw6WE1Xdoyc0ByXjZTsgdIzb1qPD8xRnzeVNiXYrp8ypD
        B6/f7a7KLQ4AzD+pz2Yh/staOPNGcORW5Ff14hJFjZ0dG/LqiQ6Y4vomdAbj0BEZGKLWM9YAymp
        oc//Q8x74FdvaY1kYIqIopWDwgsffoHmShOAj57ISMBdobiY/bN+5MrfPGUM=
X-Google-Smtp-Source: ABdhPJyi+JC2s71s8UL5BfZS5Ozc1yT5ysi7QQWnRWtwi2AcwzaYiZL2Bem8MWGZgIcp+63+Gp3tVlGqKw==
X-Received: from tkjos-desktop.mtv.corp.google.com ([2620:15c:211:200:4a73:99b6:9694:8c4d])
 (user=tkjos job=sendgmr) by 2002:ac8:56f8:: with SMTP id 24mr2903380qtu.352.1636585198657;
 Wed, 10 Nov 2021 14:59:58 -0800 (PST)
Date:   Wed, 10 Nov 2021 14:59:53 -0800
In-Reply-To: <20211110225953.3269439-1-tkjos@google.com>
Message-Id: <20211110225953.3269439-2-tkjos@google.com>
Mime-Version: 1.0
References: <20211110225953.3269439-1-tkjos@google.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [PATCH 4.9 2/2] binder: use cred instead of task for selinux checks
From:   Todd Kjos <tkjos@google.com>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        arve@android.com, tkjos@android.com, maco@android.com,
        christian@brauner.io, jmorris@namei.org, serge@hallyn.com,
        paul@paul-moore.com, stephen.smalley.work@gmail.com,
        eparis@parisplace.org, keescook@chromium.org, jannh@google.com,
        jeffv@google.com, zohar@linux.ibm.com,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        devel@driverdev.osuosl.org
Cc:     joel@joelfernandes.org, kernel-team@android.com,
        Todd Kjos <tkjos@google.com>,
        Casey Schaufler <casey@schaufler-ca.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Change-Id: Id7157515d2b08f11683aeb8ad9b8f1da075d34e7
---
 drivers/android/binder.c  | 18 +++++++++---------
 include/linux/lsm_hooks.h | 32 ++++++++++++++++----------------
 include/linux/security.h  | 28 ++++++++++++++--------------
 security/security.c       | 14 +++++++-------
 security/selinux/hooks.c  | 31 +++++++++++++------------------
 5 files changed, 59 insertions(+), 64 deletions(-)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index fe1a70447c1e..f78f7d06ad9f 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -1432,8 +1432,8 @@ static void binder_transaction(struct binder_proc *proc,
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
@@ -1594,8 +1594,8 @@ static void binder_transaction(struct binder_proc *proc,
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
@@ -1634,8 +1634,8 @@ static void binder_transaction(struct binder_proc *proc,
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
@@ -1698,8 +1698,8 @@ static void binder_transaction(struct binder_proc *proc,
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
@@ -2781,7 +2781,7 @@ static int binder_ioctl_set_ctx_mgr(struct file *filp)
 		ret = -EBUSY;
 		goto out;
 	}
-	ret = security_binder_set_context_mgr(proc->tsk);
+	ret = security_binder_set_context_mgr(proc->cred);
 	if (ret < 0)
 		goto out;
 	if (uid_valid(binder_context_mgr_uid)) {
diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index 558adfa5c8a8..53ac461f342b 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -1147,22 +1147,22 @@
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
@@ -1332,13 +1332,13 @@
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
diff --git a/include/linux/security.h b/include/linux/security.h
index c2125e9093e8..2f5d282bd3ec 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -184,13 +184,13 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
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
@@ -394,25 +394,25 @@ static inline int security_init(void)
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
index 112df16be770..9a13d72a6446 100644
--- a/security/security.c
+++ b/security/security.c
@@ -131,25 +131,25 @@ int __init security_module_enable(const char *module)
 
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
index a2b63a6a33c7..607c7fc4f24d 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2065,21 +2065,18 @@ static inline u32 open_file_to_av(struct file *file)
 
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
@@ -2093,21 +2090,19 @@ static int selinux_binder_transaction(struct task_struct *from,
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
 	struct dentry *dentry = file->f_path.dentry;
 	struct inode_security_struct *isec;
-- 
2.34.0.rc0.344.g81b53c2807-goog

