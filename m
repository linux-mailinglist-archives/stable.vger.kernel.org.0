Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22E9C27C5DE
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730498AbgI2Ljp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:39:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:34380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730480AbgI2Ljf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:39:35 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7739E21D46;
        Tue, 29 Sep 2020 11:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379567;
        bh=RTJk9hBI4RcxE1I2kbo4EjbpjPPJC4PrxNSUdeehlG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gBB0QN1B8TNSSgXKQ6pTTCawz0NkFe2k9qGm2Kb4fMCR2CfWd+Cw59B6igUoflpQK
         kMl8ciHDHJ6SBBhGY+qwJ0KeyJsptaJTvGbVuIDdg8Qz5gIpvnPSw7HddQQIHJT3ZC
         A14uqivDexCw2YMD1mgxtIg/lvQg1z47ydQ06B9w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kirill Tkhai <ktkhai@virtuozzo.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Bernd Edlinger <bernd.edlinger@hotmail.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 192/388] exec: Add exec_update_mutex to replace cred_guard_mutex
Date:   Tue, 29 Sep 2020 12:58:43 +0200
Message-Id: <20200929110019.770041334@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

[ Upstream commit eea9673250db4e854e9998ef9da6d4584857f0ea ]

The cred_guard_mutex is problematic as it is held over possibly
indefinite waits for userspace.  The possible indefinite waits for
userspace that I have identified are: The cred_guard_mutex is held in
PTRACE_EVENT_EXIT waiting for the tracer.  The cred_guard_mutex is
held over "put_user(0, tsk->clear_child_tid)" in exit_mm().  The
cred_guard_mutex is held over "get_user(futex_offset, ...")  in
exit_robust_list.  The cred_guard_mutex held over copy_strings.

The functions get_user and put_user can trigger a page fault which can
potentially wait indefinitely in the case of userfaultfd or if
userspace implements part of the page fault path.

In any of those cases the userspace process that the kernel is waiting
for might make a different system call that winds up taking the
cred_guard_mutex and result in deadlock.

Holding a mutex over any of those possibly indefinite waits for
userspace does not appear necessary.  Add exec_update_mutex that will
just cover updating the process during exec where the permissions and
the objects pointed to by the task struct may be out of sync.

The plan is to switch the users of cred_guard_mutex to
exec_update_mutex one by one.  This lets us move forward while still
being careful and not introducing any regressions.

Link: https://lore.kernel.org/lkml/20160921152946.GA24210@dhcp22.suse.cz/
Link: https://lore.kernel.org/lkml/AM6PR03MB5170B06F3A2B75EFB98D071AE4E60@AM6PR03MB5170.eurprd03.prod.outlook.com/
Link: https://lore.kernel.org/linux-fsdevel/20161102181806.GB1112@redhat.com/
Link: https://lore.kernel.org/lkml/20160923095031.GA14923@redhat.com/
Link: https://lore.kernel.org/lkml/20170213141452.GA30203@redhat.com/
Ref: 45c1a159b85b ("Add PTRACE_O_TRACEVFORKDONE and PTRACE_O_TRACEEXIT facilities.")
Ref: 456f17cd1a28 ("[PATCH] user-vm-unlock-2.5.31-A2")
Reviewed-by: Kirill Tkhai <ktkhai@virtuozzo.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exec.c                    | 22 +++++++++++++++++++---
 include/linux/binfmts.h      |  8 +++++++-
 include/linux/sched/signal.h |  9 ++++++++-
 init/init_task.c             |  1 +
 kernel/fork.c                |  1 +
 5 files changed, 36 insertions(+), 5 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index d62cd1d71098f..de833553ae27d 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1007,16 +1007,26 @@ ssize_t read_code(struct file *file, unsigned long addr, loff_t pos, size_t len)
 }
 EXPORT_SYMBOL(read_code);
 
+/*
+ * Maps the mm_struct mm into the current task struct.
+ * On success, this function returns with the mutex
+ * exec_update_mutex locked.
+ */
 static int exec_mmap(struct mm_struct *mm)
 {
 	struct task_struct *tsk;
 	struct mm_struct *old_mm, *active_mm;
+	int ret;
 
 	/* Notify parent that we're no longer interested in the old VM */
 	tsk = current;
 	old_mm = current->mm;
 	exec_mm_release(tsk, old_mm);
 
+	ret = mutex_lock_killable(&tsk->signal->exec_update_mutex);
+	if (ret)
+		return ret;
+
 	if (old_mm) {
 		sync_mm_rss(old_mm);
 		/*
@@ -1028,9 +1038,11 @@ static int exec_mmap(struct mm_struct *mm)
 		down_read(&old_mm->mmap_sem);
 		if (unlikely(old_mm->core_state)) {
 			up_read(&old_mm->mmap_sem);
+			mutex_unlock(&tsk->signal->exec_update_mutex);
 			return -EINTR;
 		}
 	}
+
 	task_lock(tsk);
 	active_mm = tsk->active_mm;
 	membarrier_exec_mmap(mm);
@@ -1285,11 +1297,12 @@ int flush_old_exec(struct linux_binprm * bprm)
 		goto out;
 
 	/*
-	 * After clearing bprm->mm (to mark that current is using the
-	 * prepared mm now), we have nothing left of the original
+	 * After setting bprm->called_exec_mmap (to mark that current is
+	 * using the prepared mm now), we have nothing left of the original
 	 * process. If anything from here on returns an error, the check
 	 * in search_binary_handler() will SEGV current.
 	 */
+	bprm->called_exec_mmap = 1;
 	bprm->mm = NULL;
 
 	set_fs(USER_DS);
@@ -1423,6 +1436,8 @@ static void free_bprm(struct linux_binprm *bprm)
 {
 	free_arg_pages(bprm);
 	if (bprm->cred) {
+		if (bprm->called_exec_mmap)
+			mutex_unlock(&current->signal->exec_update_mutex);
 		mutex_unlock(&current->signal->cred_guard_mutex);
 		abort_creds(bprm->cred);
 	}
@@ -1472,6 +1487,7 @@ void install_exec_creds(struct linux_binprm *bprm)
 	 * credentials; any time after this it may be unlocked.
 	 */
 	security_bprm_committed_creds(bprm);
+	mutex_unlock(&current->signal->exec_update_mutex);
 	mutex_unlock(&current->signal->cred_guard_mutex);
 }
 EXPORT_SYMBOL(install_exec_creds);
@@ -1663,7 +1679,7 @@ int search_binary_handler(struct linux_binprm *bprm)
 
 		read_lock(&binfmt_lock);
 		put_binfmt(fmt);
-		if (retval < 0 && !bprm->mm) {
+		if (retval < 0 && bprm->called_exec_mmap) {
 			/* we got to flush_old_exec() and failed after it */
 			read_unlock(&binfmt_lock);
 			force_sigsegv(SIGSEGV);
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index b40fc633f3be6..a345d9fed3d8d 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -44,7 +44,13 @@ struct linux_binprm {
 		 * exec has happened. Used to sanitize execution environment
 		 * and to set AT_SECURE auxv for glibc.
 		 */
-		secureexec:1;
+		secureexec:1,
+		/*
+		 * Set by flush_old_exec, when exec_mmap has been called.
+		 * This is past the point of no return, when the
+		 * exec_update_mutex has been taken.
+		 */
+		called_exec_mmap:1;
 #ifdef __alpha__
 	unsigned int taso:1;
 #endif
diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
index 88050259c466e..a29df79540ce6 100644
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -224,7 +224,14 @@ struct signal_struct {
 
 	struct mutex cred_guard_mutex;	/* guard against foreign influences on
 					 * credential calculations
-					 * (notably. ptrace) */
+					 * (notably. ptrace)
+					 * Deprecated do not use in new code.
+					 * Use exec_update_mutex instead.
+					 */
+	struct mutex exec_update_mutex;	/* Held while task_struct is being
+					 * updated during exec, and may have
+					 * inconsistent permissions.
+					 */
 } __randomize_layout;
 
 /*
diff --git a/init/init_task.c b/init/init_task.c
index 9e5cbe5eab7b1..bd403ed3e4184 100644
--- a/init/init_task.c
+++ b/init/init_task.c
@@ -26,6 +26,7 @@ static struct signal_struct init_signals = {
 	.multiprocess	= HLIST_HEAD_INIT,
 	.rlim		= INIT_RLIMITS,
 	.cred_guard_mutex = __MUTEX_INITIALIZER(init_signals.cred_guard_mutex),
+	.exec_update_mutex = __MUTEX_INITIALIZER(init_signals.exec_update_mutex),
 #ifdef CONFIG_POSIX_TIMERS
 	.posix_timers = LIST_HEAD_INIT(init_signals.posix_timers),
 	.cputimer	= {
diff --git a/kernel/fork.c b/kernel/fork.c
index 9180f4416dbab..cfdc57658ad88 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1586,6 +1586,7 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 	sig->oom_score_adj_min = current->signal->oom_score_adj_min;
 
 	mutex_init(&sig->cred_guard_mutex);
+	mutex_init(&sig->exec_update_mutex);
 
 	return 0;
 }
-- 
2.25.1



