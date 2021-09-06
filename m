Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E060D401B99
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 14:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242792AbhIFM6N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 08:58:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:34516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242398AbhIFM54 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Sep 2021 08:57:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43C5B60F43;
        Mon,  6 Sep 2021 12:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630933011;
        bh=FR7WinJgD2pAJSx6FQqL4D8tEQN1MxenJSFDkGwlDDM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dWwuyk8cLQbCjN862rjNqlP0Xy3x8BvgvQ08RFpc7fBPTWfjFRmGkvwOhE/Vsa+Fd
         OiSD35jzqQLpWMDeYQ75zZ6kjN5LMM8FLVVqdNibLPfZ2zshSQT6RmrrQSTSduYrKR
         edcX2kkdHT6lpH0JBisCLGBMQQGQl9qd9uTTltCo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Gladkov <legion@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 08/29] Revert "Add a reference to ucounts for each cred"
Date:   Mon,  6 Sep 2021 14:55:23 +0200
Message-Id: <20210906125450.059929060@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210906125449.756437409@linuxfoundation.org>
References: <20210906125449.756437409@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit b2c4d9a33cc2dec7466f97eba2c4dd571ad798a5 which is
commit 905ae01c4ae2ae3df05bb141801b1db4b7d83c61 upstream.

This commit should not have been applied to the 5.10.y stable tree, so
revert it.

Reported-by: "Eric W. Biederman" <ebiederm@xmission.com>
Link: https://lore.kernel.org/r/87v93k4bl6.fsf@disp2133
Cc: Alexey Gladkov <legion@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exec.c                      |    4 ----
 include/linux/cred.h           |    2 --
 include/linux/user_namespace.h |    4 ----
 kernel/cred.c                  |   40 ----------------------------------------
 kernel/fork.c                  |    6 ------
 kernel/sys.c                   |   12 ------------
 kernel/ucount.c                |   40 +++-------------------------------------
 kernel/user_namespace.c        |    3 ---
 8 files changed, 3 insertions(+), 108 deletions(-)

--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1347,10 +1347,6 @@ int begin_new_exec(struct linux_binprm *
 	WRITE_ONCE(me->self_exec_id, me->self_exec_id + 1);
 	flush_signal_handlers(me, 0);
 
-	retval = set_cred_ucounts(bprm->cred);
-	if (retval < 0)
-		goto out_unlock;
-
 	/*
 	 * install the new credentials for this executable
 	 */
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -144,7 +144,6 @@ struct cred {
 #endif
 	struct user_struct *user;	/* real user ID subscription */
 	struct user_namespace *user_ns; /* user_ns the caps and keyrings are relative to. */
-	struct ucounts *ucounts;
 	struct group_info *group_info;	/* supplementary groups for euid/fsgid */
 	/* RCU deletion */
 	union {
@@ -171,7 +170,6 @@ extern int set_security_override_from_ct
 extern int set_create_files_as(struct cred *, struct inode *);
 extern int cred_fscmp(const struct cred *, const struct cred *);
 extern void __init cred_init(void);
-extern int set_cred_ucounts(struct cred *);
 
 /*
  * check for validity of credentials
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -101,15 +101,11 @@ struct ucounts {
 };
 
 extern struct user_namespace init_user_ns;
-extern struct ucounts init_ucounts;
 
 bool setup_userns_sysctls(struct user_namespace *ns);
 void retire_userns_sysctls(struct user_namespace *ns);
 struct ucounts *inc_ucount(struct user_namespace *ns, kuid_t uid, enum ucount_type type);
 void dec_ucount(struct ucounts *ucounts, enum ucount_type type);
-struct ucounts *alloc_ucounts(struct user_namespace *ns, kuid_t uid);
-struct ucounts *get_ucounts(struct ucounts *ucounts);
-void put_ucounts(struct ucounts *ucounts);
 
 #ifdef CONFIG_USER_NS
 
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -60,7 +60,6 @@ struct cred init_cred = {
 	.user			= INIT_USER,
 	.user_ns		= &init_user_ns,
 	.group_info		= &init_groups,
-	.ucounts		= &init_ucounts,
 };
 
 static inline void set_cred_subscribers(struct cred *cred, int n)
@@ -120,8 +119,6 @@ static void put_cred_rcu(struct rcu_head
 	if (cred->group_info)
 		put_group_info(cred->group_info);
 	free_uid(cred->user);
-	if (cred->ucounts)
-		put_ucounts(cred->ucounts);
 	put_user_ns(cred->user_ns);
 	kmem_cache_free(cred_jar, cred);
 }
@@ -225,7 +222,6 @@ struct cred *cred_alloc_blank(void)
 #ifdef CONFIG_DEBUG_CREDENTIALS
 	new->magic = CRED_MAGIC;
 #endif
-	new->ucounts = get_ucounts(&init_ucounts);
 
 	if (security_cred_alloc_blank(new, GFP_KERNEL_ACCOUNT) < 0)
 		goto error;
@@ -288,11 +284,6 @@ struct cred *prepare_creds(void)
 
 	if (security_prepare_creds(new, old, GFP_KERNEL_ACCOUNT) < 0)
 		goto error;
-
-	new->ucounts = get_ucounts(new->ucounts);
-	if (!new->ucounts)
-		goto error;
-
 	validate_creds(new);
 	return new;
 
@@ -372,8 +363,6 @@ int copy_creds(struct task_struct *p, un
 		ret = create_user_ns(new);
 		if (ret < 0)
 			goto error_put;
-		if (set_cred_ucounts(new) < 0)
-			goto error_put;
 	}
 
 #ifdef CONFIG_KEYS
@@ -664,31 +653,6 @@ int cred_fscmp(const struct cred *a, con
 }
 EXPORT_SYMBOL(cred_fscmp);
 
-int set_cred_ucounts(struct cred *new)
-{
-	struct task_struct *task = current;
-	const struct cred *old = task->real_cred;
-	struct ucounts *old_ucounts = new->ucounts;
-
-	if (new->user == old->user && new->user_ns == old->user_ns)
-		return 0;
-
-	/*
-	 * This optimization is needed because alloc_ucounts() uses locks
-	 * for table lookups.
-	 */
-	if (old_ucounts && old_ucounts->ns == new->user_ns && uid_eq(old_ucounts->uid, new->euid))
-		return 0;
-
-	if (!(new->ucounts = alloc_ucounts(new->user_ns, new->euid)))
-		return -EAGAIN;
-
-	if (old_ucounts)
-		put_ucounts(old_ucounts);
-
-	return 0;
-}
-
 /*
  * initialise the credentials stuff
  */
@@ -755,10 +719,6 @@ struct cred *prepare_kernel_cred(struct
 	if (security_prepare_creds(new, old, GFP_KERNEL_ACCOUNT) < 0)
 		goto error;
 
-	new->ucounts = get_ucounts(new->ucounts);
-	if (!new->ucounts)
-		goto error;
-
 	put_cred(old);
 	validate_creds(new);
 	return new;
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2960,12 +2960,6 @@ int ksys_unshare(unsigned long unshare_f
 	if (err)
 		goto bad_unshare_cleanup_cred;
 
-	if (new_cred) {
-		err = set_cred_ucounts(new_cred);
-		if (err)
-			goto bad_unshare_cleanup_cred;
-	}
-
 	if (new_fs || new_fd || do_sysvsem || new_cred || new_nsproxy) {
 		if (do_sysvsem) {
 			/*
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -552,10 +552,6 @@ long __sys_setreuid(uid_t ruid, uid_t eu
 	if (retval < 0)
 		goto error;
 
-	retval = set_cred_ucounts(new);
-	if (retval < 0)
-		goto error;
-
 	return commit_creds(new);
 
 error:
@@ -614,10 +610,6 @@ long __sys_setuid(uid_t uid)
 	if (retval < 0)
 		goto error;
 
-	retval = set_cred_ucounts(new);
-	if (retval < 0)
-		goto error;
-
 	return commit_creds(new);
 
 error:
@@ -693,10 +685,6 @@ long __sys_setresuid(uid_t ruid, uid_t e
 	if (retval < 0)
 		goto error;
 
-	retval = set_cred_ucounts(new);
-	if (retval < 0)
-		goto error;
-
 	return commit_creds(new);
 
 error:
--- a/kernel/ucount.c
+++ b/kernel/ucount.c
@@ -8,12 +8,6 @@
 #include <linux/kmemleak.h>
 #include <linux/user_namespace.h>
 
-struct ucounts init_ucounts = {
-	.ns    = &init_user_ns,
-	.uid   = GLOBAL_ROOT_UID,
-	.count = 1,
-};
-
 #define UCOUNTS_HASHTABLE_BITS 10
 static struct hlist_head ucounts_hashtable[(1 << UCOUNTS_HASHTABLE_BITS)];
 static DEFINE_SPINLOCK(ucounts_lock);
@@ -131,15 +125,7 @@ static struct ucounts *find_ucounts(stru
 	return NULL;
 }
 
-static void hlist_add_ucounts(struct ucounts *ucounts)
-{
-	struct hlist_head *hashent = ucounts_hashentry(ucounts->ns, ucounts->uid);
-	spin_lock_irq(&ucounts_lock);
-	hlist_add_head(&ucounts->node, hashent);
-	spin_unlock_irq(&ucounts_lock);
-}
-
-struct ucounts *alloc_ucounts(struct user_namespace *ns, kuid_t uid)
+static struct ucounts *get_ucounts(struct user_namespace *ns, kuid_t uid)
 {
 	struct hlist_head *hashent = ucounts_hashentry(ns, uid);
 	struct ucounts *ucounts, *new;
@@ -174,26 +160,7 @@ struct ucounts *alloc_ucounts(struct use
 	return ucounts;
 }
 
-struct ucounts *get_ucounts(struct ucounts *ucounts)
-{
-	unsigned long flags;
-
-	if (!ucounts)
-		return NULL;
-
-	spin_lock_irqsave(&ucounts_lock, flags);
-	if (ucounts->count == INT_MAX) {
-		WARN_ONCE(1, "ucounts: counter has reached its maximum value");
-		ucounts = NULL;
-	} else {
-		ucounts->count += 1;
-	}
-	spin_unlock_irqrestore(&ucounts_lock, flags);
-
-	return ucounts;
-}
-
-void put_ucounts(struct ucounts *ucounts)
+static void put_ucounts(struct ucounts *ucounts)
 {
 	unsigned long flags;
 
@@ -227,7 +194,7 @@ struct ucounts *inc_ucount(struct user_n
 {
 	struct ucounts *ucounts, *iter, *bad;
 	struct user_namespace *tns;
-	ucounts = alloc_ucounts(ns, uid);
+	ucounts = get_ucounts(ns, uid);
 	for (iter = ucounts; iter; iter = tns->ucounts) {
 		int max;
 		tns = iter->ns;
@@ -270,7 +237,6 @@ static __init int user_namespace_sysctl_
 	BUG_ON(!user_header);
 	BUG_ON(!setup_userns_sysctls(&init_user_ns));
 #endif
-	hlist_add_ucounts(&init_ucounts);
 	return 0;
 }
 subsys_initcall(user_namespace_sysctl_init);
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -1340,9 +1340,6 @@ static int userns_install(struct nsset *
 	put_user_ns(cred->user_ns);
 	set_cred_user_ns(cred, get_user_ns(user_ns));
 
-	if (set_cred_ucounts(cred) < 0)
-		return -EINVAL;
-
 	return 0;
 }
 


