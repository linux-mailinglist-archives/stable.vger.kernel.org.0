Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C429C3BB0BB
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231512AbhGDXJV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:09:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:46340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231301AbhGDXIz (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:08:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 102EC6135A;
        Sun,  4 Jul 2021 23:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625439979;
        bh=MsmU/akBDyMblJhOEdQ9PaI3/QHHaB01jR2V5BrFC9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qi+s1TPlifRgrB91atvrjXK/ZZnDgrzFvxDNDwrQ/DtURuNsi37w88gvKlNfZh9Rj
         Hh4VyHyedf7r+BlQIldXqJtsWNxXxIAc950X8ARTdieDl/bgazJI0EALimX9PZEah9
         DHz3OPPsu0wF4yfEH8XIEVRRQVO5X5EbBQhY3n2Qb6k67DFASGfe6qe9jlqp2cg2Mh
         lLK298ZmBgJj1ubUrjVDuBV8Brir8XPX31GNWicBP55/7XkJqnl0/NqzSsGKekrXlp
         U7hssOK2yaxF31YfJ2y/yaVM0AbpIN4qNlkgzv3KGqDZqhId/W8dhmLrhPhj/910YF
         HDNxb9USgs1eg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexey Gladkov <legion@kernel.org>,
        kernel test robot <oliver.sang@intel.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 02/80] Add a reference to ucounts for each cred
Date:   Sun,  4 Jul 2021 19:04:58 -0400
Message-Id: <20210704230616.1489200-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230616.1489200-1-sashal@kernel.org>
References: <20210704230616.1489200-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Gladkov <legion@kernel.org>

[ Upstream commit 905ae01c4ae2ae3df05bb141801b1db4b7d83c61 ]

For RLIMIT_NPROC and some other rlimits the user_struct that holds the
global limit is kept alive for the lifetime of a process by keeping it
in struct cred. Adding a pointer to ucounts in the struct cred will
allow to track RLIMIT_NPROC not only for user in the system, but for
user in the user_namespace.

Updating ucounts may require memory allocation which may fail. So, we
cannot change cred.ucounts in the commit_creds() because this function
cannot fail and it should always return 0. For this reason, we modify
cred.ucounts before calling the commit_creds().

Changelog

v6:
* Fix null-ptr-deref in is_ucounts_overlimit() detected by trinity. This
  error was caused by the fact that cred_alloc_blank() left the ucounts
  pointer empty.

Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Alexey Gladkov <legion@kernel.org>
Link: https://lkml.kernel.org/r/b37aaef28d8b9b0d757e07ba6dd27281bbe39259.1619094428.git.legion@kernel.org
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exec.c                      |  4 ++++
 include/linux/cred.h           |  2 ++
 include/linux/user_namespace.h |  4 ++++
 kernel/cred.c                  | 40 ++++++++++++++++++++++++++++++++++
 kernel/fork.c                  |  6 +++++
 kernel/sys.c                   | 12 ++++++++++
 kernel/ucount.c                | 40 +++++++++++++++++++++++++++++++---
 kernel/user_namespace.c        |  3 +++
 8 files changed, 108 insertions(+), 3 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 18594f11c31f..d7c4187ca023 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1360,6 +1360,10 @@ int begin_new_exec(struct linux_binprm * bprm)
 	WRITE_ONCE(me->self_exec_id, me->self_exec_id + 1);
 	flush_signal_handlers(me, 0);
 
+	retval = set_cred_ucounts(bprm->cred);
+	if (retval < 0)
+		goto out_unlock;
+
 	/*
 	 * install the new credentials for this executable
 	 */
diff --git a/include/linux/cred.h b/include/linux/cred.h
index 4c6350503697..66436e655032 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -144,6 +144,7 @@ struct cred {
 #endif
 	struct user_struct *user;	/* real user ID subscription */
 	struct user_namespace *user_ns; /* user_ns the caps and keyrings are relative to. */
+	struct ucounts *ucounts;
 	struct group_info *group_info;	/* supplementary groups for euid/fsgid */
 	/* RCU deletion */
 	union {
@@ -170,6 +171,7 @@ extern int set_security_override_from_ctx(struct cred *, const char *);
 extern int set_create_files_as(struct cred *, struct inode *);
 extern int cred_fscmp(const struct cred *, const struct cred *);
 extern void __init cred_init(void);
+extern int set_cred_ucounts(struct cred *);
 
 /*
  * check for validity of credentials
diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index f6c5f784be5a..604cf6a5dc2d 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -100,11 +100,15 @@ struct ucounts {
 };
 
 extern struct user_namespace init_user_ns;
+extern struct ucounts init_ucounts;
 
 bool setup_userns_sysctls(struct user_namespace *ns);
 void retire_userns_sysctls(struct user_namespace *ns);
 struct ucounts *inc_ucount(struct user_namespace *ns, kuid_t uid, enum ucount_type type);
 void dec_ucount(struct ucounts *ucounts, enum ucount_type type);
+struct ucounts *alloc_ucounts(struct user_namespace *ns, kuid_t uid);
+struct ucounts *get_ucounts(struct ucounts *ucounts);
+void put_ucounts(struct ucounts *ucounts);
 
 #ifdef CONFIG_USER_NS
 
diff --git a/kernel/cred.c b/kernel/cred.c
index 421b1149c651..58a8a9e24347 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -60,6 +60,7 @@ struct cred init_cred = {
 	.user			= INIT_USER,
 	.user_ns		= &init_user_ns,
 	.group_info		= &init_groups,
+	.ucounts		= &init_ucounts,
 };
 
 static inline void set_cred_subscribers(struct cred *cred, int n)
@@ -119,6 +120,8 @@ static void put_cred_rcu(struct rcu_head *rcu)
 	if (cred->group_info)
 		put_group_info(cred->group_info);
 	free_uid(cred->user);
+	if (cred->ucounts)
+		put_ucounts(cred->ucounts);
 	put_user_ns(cred->user_ns);
 	kmem_cache_free(cred_jar, cred);
 }
@@ -222,6 +225,7 @@ struct cred *cred_alloc_blank(void)
 #ifdef CONFIG_DEBUG_CREDENTIALS
 	new->magic = CRED_MAGIC;
 #endif
+	new->ucounts = get_ucounts(&init_ucounts);
 
 	if (security_cred_alloc_blank(new, GFP_KERNEL_ACCOUNT) < 0)
 		goto error;
@@ -284,6 +288,11 @@ struct cred *prepare_creds(void)
 
 	if (security_prepare_creds(new, old, GFP_KERNEL_ACCOUNT) < 0)
 		goto error;
+
+	new->ucounts = get_ucounts(new->ucounts);
+	if (!new->ucounts)
+		goto error;
+
 	validate_creds(new);
 	return new;
 
@@ -363,6 +372,8 @@ int copy_creds(struct task_struct *p, unsigned long clone_flags)
 		ret = create_user_ns(new);
 		if (ret < 0)
 			goto error_put;
+		if (set_cred_ucounts(new) < 0)
+			goto error_put;
 	}
 
 #ifdef CONFIG_KEYS
@@ -653,6 +664,31 @@ int cred_fscmp(const struct cred *a, const struct cred *b)
 }
 EXPORT_SYMBOL(cred_fscmp);
 
+int set_cred_ucounts(struct cred *new)
+{
+	struct task_struct *task = current;
+	const struct cred *old = task->real_cred;
+	struct ucounts *old_ucounts = new->ucounts;
+
+	if (new->user == old->user && new->user_ns == old->user_ns)
+		return 0;
+
+	/*
+	 * This optimization is needed because alloc_ucounts() uses locks
+	 * for table lookups.
+	 */
+	if (old_ucounts && old_ucounts->ns == new->user_ns && uid_eq(old_ucounts->uid, new->euid))
+		return 0;
+
+	if (!(new->ucounts = alloc_ucounts(new->user_ns, new->euid)))
+		return -EAGAIN;
+
+	if (old_ucounts)
+		put_ucounts(old_ucounts);
+
+	return 0;
+}
+
 /*
  * initialise the credentials stuff
  */
@@ -719,6 +755,10 @@ struct cred *prepare_kernel_cred(struct task_struct *daemon)
 	if (security_prepare_creds(new, old, GFP_KERNEL_ACCOUNT) < 0)
 		goto error;
 
+	new->ucounts = get_ucounts(new->ucounts);
+	if (!new->ucounts)
+		goto error;
+
 	put_cred(old);
 	validate_creds(new);
 	return new;
diff --git a/kernel/fork.c b/kernel/fork.c
index 426cd0c51f9e..321a5e31d817 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2995,6 +2995,12 @@ int ksys_unshare(unsigned long unshare_flags)
 	if (err)
 		goto bad_unshare_cleanup_cred;
 
+	if (new_cred) {
+		err = set_cred_ucounts(new_cred);
+		if (err)
+			goto bad_unshare_cleanup_cred;
+	}
+
 	if (new_fs || new_fd || do_sysvsem || new_cred || new_nsproxy) {
 		if (do_sysvsem) {
 			/*
diff --git a/kernel/sys.c b/kernel/sys.c
index 2e2e3f378d97..cabfc5b86175 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -552,6 +552,10 @@ long __sys_setreuid(uid_t ruid, uid_t euid)
 	if (retval < 0)
 		goto error;
 
+	retval = set_cred_ucounts(new);
+	if (retval < 0)
+		goto error;
+
 	return commit_creds(new);
 
 error:
@@ -610,6 +614,10 @@ long __sys_setuid(uid_t uid)
 	if (retval < 0)
 		goto error;
 
+	retval = set_cred_ucounts(new);
+	if (retval < 0)
+		goto error;
+
 	return commit_creds(new);
 
 error:
@@ -685,6 +693,10 @@ long __sys_setresuid(uid_t ruid, uid_t euid, uid_t suid)
 	if (retval < 0)
 		goto error;
 
+	retval = set_cred_ucounts(new);
+	if (retval < 0)
+		goto error;
+
 	return commit_creds(new);
 
 error:
diff --git a/kernel/ucount.c b/kernel/ucount.c
index 11b1596e2542..9894795043c4 100644
--- a/kernel/ucount.c
+++ b/kernel/ucount.c
@@ -8,6 +8,12 @@
 #include <linux/kmemleak.h>
 #include <linux/user_namespace.h>
 
+struct ucounts init_ucounts = {
+	.ns    = &init_user_ns,
+	.uid   = GLOBAL_ROOT_UID,
+	.count = 1,
+};
+
 #define UCOUNTS_HASHTABLE_BITS 10
 static struct hlist_head ucounts_hashtable[(1 << UCOUNTS_HASHTABLE_BITS)];
 static DEFINE_SPINLOCK(ucounts_lock);
@@ -125,7 +131,15 @@ static struct ucounts *find_ucounts(struct user_namespace *ns, kuid_t uid, struc
 	return NULL;
 }
 
-static struct ucounts *get_ucounts(struct user_namespace *ns, kuid_t uid)
+static void hlist_add_ucounts(struct ucounts *ucounts)
+{
+	struct hlist_head *hashent = ucounts_hashentry(ucounts->ns, ucounts->uid);
+	spin_lock_irq(&ucounts_lock);
+	hlist_add_head(&ucounts->node, hashent);
+	spin_unlock_irq(&ucounts_lock);
+}
+
+struct ucounts *alloc_ucounts(struct user_namespace *ns, kuid_t uid)
 {
 	struct hlist_head *hashent = ucounts_hashentry(ns, uid);
 	struct ucounts *ucounts, *new;
@@ -160,7 +174,26 @@ static struct ucounts *get_ucounts(struct user_namespace *ns, kuid_t uid)
 	return ucounts;
 }
 
-static void put_ucounts(struct ucounts *ucounts)
+struct ucounts *get_ucounts(struct ucounts *ucounts)
+{
+	unsigned long flags;
+
+	if (!ucounts)
+		return NULL;
+
+	spin_lock_irqsave(&ucounts_lock, flags);
+	if (ucounts->count == INT_MAX) {
+		WARN_ONCE(1, "ucounts: counter has reached its maximum value");
+		ucounts = NULL;
+	} else {
+		ucounts->count += 1;
+	}
+	spin_unlock_irqrestore(&ucounts_lock, flags);
+
+	return ucounts;
+}
+
+void put_ucounts(struct ucounts *ucounts)
 {
 	unsigned long flags;
 
@@ -194,7 +227,7 @@ struct ucounts *inc_ucount(struct user_namespace *ns, kuid_t uid,
 {
 	struct ucounts *ucounts, *iter, *bad;
 	struct user_namespace *tns;
-	ucounts = get_ucounts(ns, uid);
+	ucounts = alloc_ucounts(ns, uid);
 	for (iter = ucounts; iter; iter = tns->ucounts) {
 		int max;
 		tns = iter->ns;
@@ -237,6 +270,7 @@ static __init int user_namespace_sysctl_init(void)
 	BUG_ON(!user_header);
 	BUG_ON(!setup_userns_sysctls(&init_user_ns));
 #endif
+	hlist_add_ucounts(&init_ucounts);
 	return 0;
 }
 subsys_initcall(user_namespace_sysctl_init);
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 9a4b980d695b..f1b7b4b8ffa2 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -1340,6 +1340,9 @@ static int userns_install(struct nsset *nsset, struct ns_common *ns)
 	put_user_ns(cred->user_ns);
 	set_cred_user_ns(cred, get_user_ns(user_ns));
 
+	if (set_cred_ucounts(cred) < 0)
+		return -EINVAL;
+
 	return 0;
 }
 
-- 
2.30.2

