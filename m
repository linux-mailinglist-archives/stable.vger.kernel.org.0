Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8D22ED2A0
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 15:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728911AbhAGOfD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 09:35:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:47050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729629AbhAGOdh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 09:33:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BD332336D;
        Thu,  7 Jan 2021 14:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610030001;
        bh=NdJ32clCe+bSuZmbXIiGTZHFrMGJBi3OpNyH85Umlps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tfjQV2XIJi/KfzNg4j8Xfu43MqHl1EcuATOpVg1N/PWtUk2qWXNBys0W7mLJXH5G3
         /zPzy1C/tRre0hftu0CR9CxMvU0jVs4cJ4kG1q5j2nTHGpQj1axVs3kSnPkklKPC1v
         Tuf2nTGDNxyD4ZtuS7lwJW1uFKtwEowW3u4QUbfA=
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
Subject: [PATCH 5.10 19/20] exec: Transform exec_update_mutex into a rw_semaphore
Date:   Thu,  7 Jan 2021 15:34:14 +0100
Message-Id: <20210107143055.079346105@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210107143052.392839477@linuxfoundation.org>
References: <20210107143052.392839477@linuxfoundation.org>
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
 kernel/pid.c                 |  4 ++--
 8 files changed, 44 insertions(+), 43 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 547a2390baf54..ca89e0e3ef10f 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -965,8 +965,8 @@ EXPORT_SYMBOL(read_code);
 
 /*
  * Maps the mm_struct mm into the current task struct.
- * On success, this function returns with the mutex
- * exec_update_mutex locked.
+ * On success, this function returns with exec_update_lock
+ * held for writing.
  */
 static int exec_mmap(struct mm_struct *mm)
 {
@@ -981,7 +981,7 @@ static int exec_mmap(struct mm_struct *mm)
 	if (old_mm)
 		sync_mm_rss(old_mm);
 
-	ret = mutex_lock_killable(&tsk->signal->exec_update_mutex);
+	ret = down_write_killable(&tsk->signal->exec_update_lock);
 	if (ret)
 		return ret;
 
@@ -995,7 +995,7 @@ static int exec_mmap(struct mm_struct *mm)
 		mmap_read_lock(old_mm);
 		if (unlikely(old_mm->core_state)) {
 			mmap_read_unlock(old_mm);
-			mutex_unlock(&tsk->signal->exec_update_mutex);
+			up_write(&tsk->signal->exec_update_lock);
 			return -EINTR;
 		}
 	}
@@ -1382,7 +1382,7 @@ int begin_new_exec(struct linux_binprm * bprm)
 	return 0;
 
 out_unlock:
-	mutex_unlock(&me->signal->exec_update_mutex);
+	up_write(&me->signal->exec_update_lock);
 out:
 	return retval;
 }
@@ -1423,7 +1423,7 @@ void setup_new_exec(struct linux_binprm * bprm)
 	 * some architectures like powerpc
 	 */
 	me->mm->task_size = TASK_SIZE;
-	mutex_unlock(&me->signal->exec_update_mutex);
+	up_write(&me->signal->exec_update_lock);
 	mutex_unlock(&me->signal->cred_guard_mutex);
 }
 EXPORT_SYMBOL(setup_new_exec);
diff --git a/fs/proc/base.c b/fs/proc/base.c
index b362523a9829a..55ce0ee9c5c73 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -405,11 +405,11 @@ print0:
 
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
@@ -417,7 +417,7 @@ static int lock_trace(struct task_struct *task)
 
 static void unlock_trace(struct task_struct *task)
 {
-	mutex_unlock(&task->signal->exec_update_mutex);
+	up_read(&task->signal->exec_update_lock);
 }
 
 #ifdef CONFIG_STACKTRACE
@@ -2930,7 +2930,7 @@ static int do_io_accounting(struct task_struct *task, struct seq_file *m, int wh
 	unsigned long flags;
 	int result;
 
-	result = mutex_lock_killable(&task->signal->exec_update_mutex);
+	result = down_read_killable(&task->signal->exec_update_lock);
 	if (result)
 		return result;
 
@@ -2966,7 +2966,7 @@ static int do_io_accounting(struct task_struct *task, struct seq_file *m, int wh
 	result = 0;
 
 out_unlock:
-	mutex_unlock(&task->signal->exec_update_mutex);
+	up_read(&task->signal->exec_update_lock);
 	return result;
 }
 
diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
index 1bad18a1d8ba7..4b6a8234d7fc2 100644
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -228,12 +228,13 @@ struct signal_struct {
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
index a56f0abb63e93..15f6eb93a04fa 100644
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
index 7e9a398fc3cb0..c3ba29d058b73 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1325,7 +1325,7 @@ static void put_ctx(struct perf_event_context *ctx)
  * function.
  *
  * Lock order:
- *    exec_update_mutex
+ *    exec_update_lock
  *	task_struct::perf_event_mutex
  *	  perf_event_context::mutex
  *	    perf_event::child_mutex;
@@ -11847,14 +11847,14 @@ SYSCALL_DEFINE5(perf_event_open,
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
@@ -12017,7 +12017,7 @@ SYSCALL_DEFINE5(perf_event_open,
 	mutex_unlock(&ctx->mutex);
 
 	if (task) {
-		mutex_unlock(&task->signal->exec_update_mutex);
+		up_read(&task->signal->exec_update_lock);
 		put_task_struct(task);
 	}
 
@@ -12041,7 +12041,7 @@ err_locked:
 	mutex_unlock(&ctx->mutex);
 err_cred:
 	if (task)
-		mutex_unlock(&task->signal->exec_update_mutex);
+		up_read(&task->signal->exec_update_lock);
 err_file:
 	fput(event_file);
 err_context:
@@ -12358,7 +12358,7 @@ static void perf_event_exit_task_context(struct task_struct *child, int ctxn)
 /*
  * When a child task exits, feed back event values to parent events.
  *
- * Can be called with exec_update_mutex held when called from
+ * Can be called with exec_update_lock held when called from
  * setup_new_exec().
  */
 void perf_event_exit_task(struct task_struct *child)
diff --git a/kernel/fork.c b/kernel/fork.c
index dc55f68a6ee36..c675fdbd3dce1 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1222,7 +1222,7 @@ struct mm_struct *mm_access(struct task_struct *task, unsigned int mode)
 	struct mm_struct *mm;
 	int err;
 
-	err =  mutex_lock_killable(&task->signal->exec_update_mutex);
+	err =  down_read_killable(&task->signal->exec_update_lock);
 	if (err)
 		return ERR_PTR(err);
 
@@ -1232,7 +1232,7 @@ struct mm_struct *mm_access(struct task_struct *task, unsigned int mode)
 		mmput(mm);
 		mm = ERR_PTR(-EACCES);
 	}
-	mutex_unlock(&task->signal->exec_update_mutex);
+	up_read(&task->signal->exec_update_lock);
 
 	return mm;
 }
@@ -1592,7 +1592,7 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
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
diff --git a/kernel/pid.c b/kernel/pid.c
index a96bc4bf4f869..4856818c9de1a 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -628,7 +628,7 @@ static struct file *__pidfd_fget(struct task_struct *task, int fd)
 	struct file *file;
 	int ret;
 
-	ret = mutex_lock_killable(&task->signal->exec_update_mutex);
+	ret = down_read_killable(&task->signal->exec_update_lock);
 	if (ret)
 		return ERR_PTR(ret);
 
@@ -637,7 +637,7 @@ static struct file *__pidfd_fget(struct task_struct *task, int fd)
 	else
 		file = ERR_PTR(-EPERM);
 
-	mutex_unlock(&task->signal->exec_update_mutex);
+	up_read(&task->signal->exec_update_lock);
 
 	return file ?: ERR_PTR(-EBADF);
 }
-- 
2.27.0



