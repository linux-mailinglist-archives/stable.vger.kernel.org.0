Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A00C2ED27A
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 15:37:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729598AbhAGOdc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 09:33:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:47284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729578AbhAGOdY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 09:33:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D47023370;
        Thu,  7 Jan 2021 14:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610029962;
        bh=MxepKIbV3v/tLogSbRFhu4LNwyFSFByYYFI2HhCjmAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yLG2Cyh1wW1SxJexC1wTcowPyCKHh730u9oMXB1LWEnqP6ujHetdp42jRsdTKnnOU
         CXljalfiv5j4+Ro0C1rs+/E512zJX7qs6eEnPTyjrnek4v7vlDS1BSFR1iynYfptJT
         STwQzwzn7+kTRksC6KfZQcheJixOKP8DFWYKOmbY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Bernd Edlinger <bernd.edlinger@hotmail.de>,
        Oleg Nesterov <oleg@redhat.com>,
        Christopher Yeoh <cyeoh@au1.ibm.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        Sargun Dhillon <sargun@sargun.me>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        syzbot+db9cdf3dd1f64252c6ef@syzkaller.appspotmail.com,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 12/13] exec: Transform exec_update_mutex into a rw_semaphore
Date:   Thu,  7 Jan 2021 15:33:31 +0100
Message-Id: <20210107143051.609313023@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210107143049.929352526@linuxfoundation.org>
References: <20210107143049.929352526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

[ Upstream commit f7cfd871ae0c5008d94b6f66834e7845caa93c15 ]

Recently syzbot reported[0] that there is a deadlock amongst the users
of exec_update_mutex.  The problematic lock ordering found by lockdep
was:

   perf_event_open  (exec_update_mutex -> ovl_i_mutex)
   chown            (ovl_i_mutex       -> sb_writes)
   sendfile         (sb_writes         -> p->lock)
     by reading from a proc file and writing to overlayfs
   proc_pid_syscall (p->lock           -> exec_update_mutex)

While looking at possible solutions it occured to me that all of the
users and possible users involved only wanted to state of the given
process to remain the same.  They are all readers.  The only writer is
exec.

There is no reason for readers to block on each other.  So fix
this deadlock by transforming exec_update_mutex into a rw_semaphore
named exec_update_lock that only exec takes for writing.

Cc: Jann Horn <jannh@google.com>
Cc: Vasiliy Kulikov <segoon@openwall.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Bernd Edlinger <bernd.edlinger@hotmail.de>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Christopher Yeoh <cyeoh@au1.ibm.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Sargun Dhillon <sargun@sargun.me>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Fixes: eea9673250db ("exec: Add exec_update_mutex to replace cred_guard_mutex")
[0] https://lkml.kernel.org/r/00000000000063640c05ade8e3de@google.com
Reported-by: syzbot+db9cdf3dd1f64252c6ef@syzkaller.appspotmail.com
Link: https://lkml.kernel.org/r/87ft4mbqen.fsf@x220.int.ebiederm.org
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exec.c                    | 12 ++++++------
 fs/proc/base.c               | 10 +++++-----
 include/linux/sched/signal.h | 11 ++++++-----
 init/init_task.c             |  2 +-
 kernel/events/core.c         | 12 ++++++------
 kernel/fork.c                |  6 +++---
 kernel/kcmp.c                | 30 +++++++++++++++---------------
 kernel/locking/rwsem.c       |  4 ++--
 8 files changed, 44 insertions(+), 43 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 2441eb1a1e2d0..1b4d2206d53a1 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1009,8 +1009,8 @@ EXPORT_SYMBOL(read_code);
 
 /*
  * Maps the mm_struct mm into the current task struct.
- * On success, this function returns with the mutex
- * exec_update_mutex locked.
+ * On success, this function returns with exec_update_lock
+ * held for writing.
  */
 static int exec_mmap(struct mm_struct *mm)
 {
@@ -1023,7 +1023,7 @@ static int exec_mmap(struct mm_struct *mm)
 	old_mm = current->mm;
 	exec_mm_release(tsk, old_mm);
 
-	ret = mutex_lock_killable(&tsk->signal->exec_update_mutex);
+	ret = down_write_killable(&tsk->signal->exec_update_lock);
 	if (ret)
 		return ret;
 
@@ -1038,7 +1038,7 @@ static int exec_mmap(struct mm_struct *mm)
 		down_read(&old_mm->mmap_sem);
 		if (unlikely(old_mm->core_state)) {
 			up_read(&old_mm->mmap_sem);
-			mutex_unlock(&tsk->signal->exec_update_mutex);
+			up_write(&tsk->signal->exec_update_lock);
 			return -EINTR;
 		}
 	}
@@ -1450,7 +1450,7 @@ static void free_bprm(struct linux_binprm *bprm)
 	free_arg_pages(bprm);
 	if (bprm->cred) {
 		if (bprm->called_exec_mmap)
-			mutex_unlock(&current->signal->exec_update_mutex);
+			up_write(&current->signal->exec_update_lock);
 		mutex_unlock(&current->signal->cred_guard_mutex);
 		abort_creds(bprm->cred);
 	}
@@ -1500,7 +1500,7 @@ void install_exec_creds(struct linux_binprm *bprm)
 	 * credentials; any time after this it may be unlocked.
 	 */
 	security_bprm_committed_creds(bprm);
-	mutex_unlock(&current->signal->exec_update_mutex);
+	up_write(&current->signal->exec_update_lock);
 	mutex_unlock(&current->signal->cred_guard_mutex);
 }
 EXPORT_SYMBOL(install_exec_creds);
diff --git a/fs/proc/base.c b/fs/proc/base.c
index b690074e65ffa..653c2d8aa1cd7 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -403,11 +403,11 @@ print0:
 
 static int lock_trace(struct task_struct *task)
 {
-	int err = mutex_lock_killable(&task->signal->exec_update_mutex);
+	int err = down_read_killable(&task->signal->exec_update_lock);
 	if (err)
 		return err;
 	if (!ptrace_may_access(task, PTRACE_MODE_ATTACH_FSCREDS)) {
-		mutex_unlock(&task->signal->exec_update_mutex);
+		up_read(&task->signal->exec_update_lock);
 		return -EPERM;
 	}
 	return 0;
@@ -415,7 +415,7 @@ static int lock_trace(struct task_struct *task)
 
 static void unlock_trace(struct task_struct *task)
 {
-	mutex_unlock(&task->signal->exec_update_mutex);
+	up_read(&task->signal->exec_update_lock);
 }
 
 #ifdef CONFIG_STACKTRACE
@@ -2769,7 +2769,7 @@ static int do_io_accounting(struct task_struct *task, struct seq_file *m, int wh
 	unsigned long flags;
 	int result;
 
-	result = mutex_lock_killable(&task->signal->exec_update_mutex);
+	result = down_read_killable(&task->signal->exec_update_lock);
 	if (result)
 		return result;
 
@@ -2805,7 +2805,7 @@ static int do_io_accounting(struct task_struct *task, struct seq_file *m, int wh
 	result = 0;
 
 out_unlock:
-	mutex_unlock(&task->signal->exec_update_mutex);
+	up_read(&task->signal->exec_update_lock);
 	return result;
 }
 
diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
index a29df79540ce6..baf58f4cb0578 100644
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -226,12 +226,13 @@ struct signal_struct {
 					 * credential calculations
 					 * (notably. ptrace)
 					 * Deprecated do not use in new code.
-					 * Use exec_update_mutex instead.
-					 */
-	struct mutex exec_update_mutex;	/* Held while task_struct is being
-					 * updated during exec, and may have
-					 * inconsistent permissions.
+					 * Use exec_update_lock instead.
 					 */
+	struct rw_semaphore exec_update_lock;	/* Held while task_struct is
+						 * being updated during exec,
+						 * and may have inconsistent
+						 * permissions.
+						 */
 } __randomize_layout;
 
 /*
diff --git a/init/init_task.c b/init/init_task.c
index bd403ed3e4184..df7041be96fca 100644
--- a/init/init_task.c
+++ b/init/init_task.c
@@ -26,7 +26,7 @@ static struct signal_struct init_signals = {
 	.multiprocess	= HLIST_HEAD_INIT,
 	.rlim		= INIT_RLIMITS,
 	.cred_guard_mutex = __MUTEX_INITIALIZER(init_signals.cred_guard_mutex),
-	.exec_update_mutex = __MUTEX_INITIALIZER(init_signals.exec_update_mutex),
+	.exec_update_lock = __RWSEM_INITIALIZER(init_signals.exec_update_lock),
 #ifdef CONFIG_POSIX_TIMERS
 	.posix_timers = LIST_HEAD_INIT(init_signals.posix_timers),
 	.cputimer	= {
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 18dbdf248ed81..2ef33e9a75910 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1254,7 +1254,7 @@ static void put_ctx(struct perf_event_context *ctx)
  * function.
  *
  * Lock order:
- *    exec_update_mutex
+ *    exec_update_lock
  *	task_struct::perf_event_mutex
  *	  perf_event_context::mutex
  *	    perf_event::child_mutex;
@@ -11128,14 +11128,14 @@ SYSCALL_DEFINE5(perf_event_open,
 	}
 
 	if (task) {
-		err = mutex_lock_interruptible(&task->signal->exec_update_mutex);
+		err = down_read_interruptible(&task->signal->exec_update_lock);
 		if (err)
 			goto err_file;
 
 		/*
 		 * Preserve ptrace permission check for backwards compatibility.
 		 *
-		 * We must hold exec_update_mutex across this and any potential
+		 * We must hold exec_update_lock across this and any potential
 		 * perf_install_in_context() call for this new event to
 		 * serialize against exec() altering our credentials (and the
 		 * perf_event_exit_task() that could imply).
@@ -11298,7 +11298,7 @@ SYSCALL_DEFINE5(perf_event_open,
 	mutex_unlock(&ctx->mutex);
 
 	if (task) {
-		mutex_unlock(&task->signal->exec_update_mutex);
+		up_read(&task->signal->exec_update_lock);
 		put_task_struct(task);
 	}
 
@@ -11322,7 +11322,7 @@ err_locked:
 	mutex_unlock(&ctx->mutex);
 err_cred:
 	if (task)
-		mutex_unlock(&task->signal->exec_update_mutex);
+		up_read(&task->signal->exec_update_lock);
 err_file:
 	fput(event_file);
 err_context:
@@ -11639,7 +11639,7 @@ static void perf_event_exit_task_context(struct task_struct *child, int ctxn)
 /*
  * When a child task exits, feed back event values to parent events.
  *
- * Can be called with exec_update_mutex held when called from
+ * Can be called with exec_update_lock held when called from
  * install_exec_creds().
  */
 void perf_event_exit_task(struct task_struct *child)
diff --git a/kernel/fork.c b/kernel/fork.c
index 419fff8eb9e55..50f37d5afb32b 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1221,7 +1221,7 @@ struct mm_struct *mm_access(struct task_struct *task, unsigned int mode)
 	struct mm_struct *mm;
 	int err;
 
-	err =  mutex_lock_killable(&task->signal->exec_update_mutex);
+	err =  down_read_killable(&task->signal->exec_update_lock);
 	if (err)
 		return ERR_PTR(err);
 
@@ -1231,7 +1231,7 @@ struct mm_struct *mm_access(struct task_struct *task, unsigned int mode)
 		mmput(mm);
 		mm = ERR_PTR(-EACCES);
 	}
-	mutex_unlock(&task->signal->exec_update_mutex);
+	up_read(&task->signal->exec_update_lock);
 
 	return mm;
 }
@@ -1586,7 +1586,7 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 	sig->oom_score_adj_min = current->signal->oom_score_adj_min;
 
 	mutex_init(&sig->cred_guard_mutex);
-	mutex_init(&sig->exec_update_mutex);
+	init_rwsem(&sig->exec_update_lock);
 
 	return 0;
 }
diff --git a/kernel/kcmp.c b/kernel/kcmp.c
index b3ff9288c6cc9..c0d2ad9b4705d 100644
--- a/kernel/kcmp.c
+++ b/kernel/kcmp.c
@@ -75,25 +75,25 @@ get_file_raw_ptr(struct task_struct *task, unsigned int idx)
 	return file;
 }
 
-static void kcmp_unlock(struct mutex *m1, struct mutex *m2)
+static void kcmp_unlock(struct rw_semaphore *l1, struct rw_semaphore *l2)
 {
-	if (likely(m2 != m1))
-		mutex_unlock(m2);
-	mutex_unlock(m1);
+	if (likely(l2 != l1))
+		up_read(l2);
+	up_read(l1);
 }
 
-static int kcmp_lock(struct mutex *m1, struct mutex *m2)
+static int kcmp_lock(struct rw_semaphore *l1, struct rw_semaphore *l2)
 {
 	int err;
 
-	if (m2 > m1)
-		swap(m1, m2);
+	if (l2 > l1)
+		swap(l1, l2);
 
-	err = mutex_lock_killable(m1);
-	if (!err && likely(m1 != m2)) {
-		err = mutex_lock_killable_nested(m2, SINGLE_DEPTH_NESTING);
+	err = down_read_killable(l1);
+	if (!err && likely(l1 != l2)) {
+		err = down_read_killable_nested(l2, SINGLE_DEPTH_NESTING);
 		if (err)
-			mutex_unlock(m1);
+			up_read(l1);
 	}
 
 	return err;
@@ -173,8 +173,8 @@ SYSCALL_DEFINE5(kcmp, pid_t, pid1, pid_t, pid2, int, type,
 	/*
 	 * One should have enough rights to inspect task details.
 	 */
-	ret = kcmp_lock(&task1->signal->exec_update_mutex,
-			&task2->signal->exec_update_mutex);
+	ret = kcmp_lock(&task1->signal->exec_update_lock,
+			&task2->signal->exec_update_lock);
 	if (ret)
 		goto err;
 	if (!ptrace_may_access(task1, PTRACE_MODE_READ_REALCREDS) ||
@@ -229,8 +229,8 @@ SYSCALL_DEFINE5(kcmp, pid_t, pid1, pid_t, pid2, int, type,
 	}
 
 err_unlock:
-	kcmp_unlock(&task1->signal->exec_update_mutex,
-		    &task2->signal->exec_update_mutex);
+	kcmp_unlock(&task1->signal->exec_update_lock,
+		    &task2->signal->exec_update_lock);
 err:
 	put_task_struct(task1);
 	put_task_struct(task2);
diff --git a/kernel/locking/rwsem.c b/kernel/locking/rwsem.c
index a5eb87f2c5816..5d54ff3179b80 100644
--- a/kernel/locking/rwsem.c
+++ b/kernel/locking/rwsem.c
@@ -1516,7 +1516,7 @@ int __sched down_read_interruptible(struct rw_semaphore *sem)
 	rwsem_acquire_read(&sem->dep_map, 0, 0, _RET_IP_);
 
 	if (LOCK_CONTENDED_RETURN(sem, __down_read_trylock, __down_read_interruptible)) {
-		rwsem_release(&sem->dep_map, _RET_IP_);
+		rwsem_release(&sem->dep_map, 1, _RET_IP_);
 		return -EINTR;
 	}
 
@@ -1640,7 +1640,7 @@ int down_read_killable_nested(struct rw_semaphore *sem, int subclass)
 	rwsem_acquire_read(&sem->dep_map, subclass, 0, _RET_IP_);
 
 	if (LOCK_CONTENDED_RETURN(sem, __down_read_trylock, __down_read_killable)) {
-		rwsem_release(&sem->dep_map, _RET_IP_);
+		rwsem_release(&sem->dep_map, 1, _RET_IP_);
 		return -EINTR;
 	}
 
-- 
2.27.0



