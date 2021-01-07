Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32D0C2ECB45
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 08:55:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbhAGHyQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 02:54:16 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:49973 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727418AbhAGHyG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 02:54:06 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=wenyang@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0UKysbUW_1610005996;
Received: from localhost(mailfrom:wenyang@linux.alibaba.com fp:SMTPD_---0UKysbUW_1610005996)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 07 Jan 2021 15:53:16 +0800
From:   Wen Yang <wenyang@linux.alibaba.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Xunlei Pang <xlpang@linux.alibaba.com>,
        linux-kernel@vger.kernel.org,
        Christian Brauner <christian@brauner.io>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jann Horn <jannh@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Howells <dhowells@redhat.com>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Andy Lutomirsky <luto@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Al Viro <viro@zeniv.linux.org.uk>, stable@vger.kernel.org,
        Wen Yang <wenyang@linux.alibaba.com>
Subject: [PATCH 4.19 1/7] clone: add CLONE_PIDFD
Date:   Thu,  7 Jan 2021 15:53:08 +0800
Message-Id: <20210107075314.62683-2-wenyang@linux.alibaba.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210107075314.62683-1-wenyang@linux.alibaba.com>
References: <20210107075314.62683-1-wenyang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Brauner <christian@brauner.io>

[ Upstream commit b3e5838252665ee4cfa76b82bdf1198dca81e5be ]

This patchset makes it possible to retrieve pid file descriptors at
process creation time by introducing the new flag CLONE_PIDFD to the
clone() system call.  Linus originally suggested to implement this as a
new flag to clone() instead of making it a separate system call.  As
spotted by Linus, there is exactly one bit for clone() left.

CLONE_PIDFD creates file descriptors based on the anonymous inode
implementation in the kernel that will also be used to implement the new
mount api.  They serve as a simple opaque handle on pids.  Logically,
this makes it possible to interpret a pidfd differently, narrowing or
widening the scope of various operations (e.g. signal sending).  Thus, a
pidfd cannot just refer to a tgid, but also a tid, or in theory - given
appropriate flag arguments in relevant syscalls - a process group or
session. A pidfd does not represent a privilege.  This does not imply it
cannot ever be that way but for now this is not the case.

A pidfd comes with additional information in fdinfo if the kernel supports
procfs.  The fdinfo file contains the pid of the process in the callers
pid namespace in the same format as the procfs status file, i.e. "Pid:\t%d".

As suggested by Oleg, with CLONE_PIDFD the pidfd is returned in the
parent_tidptr argument of clone.  This has the advantage that we can
give back the associated pid and the pidfd at the same time.

To remove worries about missing metadata access this patchset comes with
a sample program that illustrates how a combination of CLONE_PIDFD, and
pidfd_send_signal() can be used to gain race-free access to process
metadata through /proc/<pid>.  The sample program can easily be
translated into a helper that would be suitable for inclusion in libc so
that users don't have to worry about writing it themselves.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Christian Brauner <christian@brauner.io>
Co-developed-by: Jann Horn <jannh@google.com>
Signed-off-by: Jann Horn <jannh@google.com>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: David Howells <dhowells@redhat.com>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Andy Lutomirsky <luto@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Aleksa Sarai <cyphar@cyphar.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <stable@vger.kernel.org> # 4.19.x
(clone: fix up cherry-pick conflicts for b3e583825266)
Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
---
 include/linux/pid.h        |   2 +
 include/uapi/linux/sched.h |   1 +
 kernel/fork.c              | 107 +++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 106 insertions(+), 4 deletions(-)

diff --git a/include/linux/pid.h b/include/linux/pid.h
index 14a9a39..29c0a99 100644
--- a/include/linux/pid.h
+++ b/include/linux/pid.h
@@ -66,6 +66,8 @@ struct pid
 
 extern struct pid init_struct_pid;
 
+extern const struct file_operations pidfd_fops;
+
 static inline struct pid *get_pid(struct pid *pid)
 {
 	if (pid)
diff --git a/include/uapi/linux/sched.h b/include/uapi/linux/sched.h
index 22627f8..ed4ee17 100644
--- a/include/uapi/linux/sched.h
+++ b/include/uapi/linux/sched.h
@@ -10,6 +10,7 @@
 #define CLONE_FS	0x00000200	/* set if fs info shared between processes */
 #define CLONE_FILES	0x00000400	/* set if open files shared between processes */
 #define CLONE_SIGHAND	0x00000800	/* set if signal handlers and blocked signals shared */
+#define CLONE_PIDFD	0x00001000	/* set if a pidfd should be placed in parent */
 #define CLONE_PTRACE	0x00002000	/* set if we want to let tracing continue on the child too */
 #define CLONE_VFORK	0x00004000	/* set if the parent wants the child to wake it up on mm_release */
 #define CLONE_PARENT	0x00008000	/* set if we want to have the same parent as the cloner */
diff --git a/kernel/fork.c b/kernel/fork.c
index f2c92c1..e419891 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -11,6 +11,7 @@
  * management can be a bitch. See 'mm/memory.c': 'copy_page_range()'
  */
 
+#include <linux/anon_inodes.h>
 #include <linux/slab.h>
 #include <linux/sched/autogroup.h>
 #include <linux/sched/mm.h>
@@ -21,6 +22,7 @@
 #include <linux/sched/task.h>
 #include <linux/sched/task_stack.h>
 #include <linux/sched/cputime.h>
+#include <linux/seq_file.h>
 #include <linux/rtmutex.h>
 #include <linux/init.h>
 #include <linux/unistd.h>
@@ -1666,6 +1668,58 @@ static void copy_oom_score_adj(u64 clone_flags, struct task_struct *tsk)
 	mutex_unlock(&oom_adj_mutex);
 }
 
+static int pidfd_release(struct inode *inode, struct file *file)
+{
+	struct pid *pid = file->private_data;
+
+	file->private_data = NULL;
+	put_pid(pid);
+	return 0;
+}
+
+#ifdef CONFIG_PROC_FS
+static void pidfd_show_fdinfo(struct seq_file *m, struct file *f)
+{
+	struct pid_namespace *ns = proc_pid_ns(file_inode(m->file));
+	struct pid *pid = f->private_data;
+
+	seq_put_decimal_ull(m, "Pid:\t", pid_nr_ns(pid, ns));
+	seq_putc(m, '\n');
+}
+#endif
+
+const struct file_operations pidfd_fops = {
+	.release = pidfd_release,
+#ifdef CONFIG_PROC_FS
+	.show_fdinfo = pidfd_show_fdinfo,
+#endif
+};
+
+/**
+ * pidfd_create() - Create a new pid file descriptor.
+ *
+ * @pid:  struct pid that the pidfd will reference
+ *
+ * This creates a new pid file descriptor with the O_CLOEXEC flag set.
+ *
+ * Note, that this function can only be called after the fd table has
+ * been unshared to avoid leaking the pidfd to the new process.
+ *
+ * Return: On success, a cloexec pidfd is returned.
+ *         On error, a negative errno number will be returned.
+ */
+static int pidfd_create(struct pid *pid)
+{
+	int fd;
+
+	fd = anon_inode_getfd("[pidfd]", &pidfd_fops, get_pid(pid),
+			      O_RDWR | O_CLOEXEC);
+	if (fd < 0)
+		put_pid(pid);
+
+	return fd;
+}
+
 /*
  * This creates a new process as a copy of the old one,
  * but does not actually start it yet.
@@ -1678,13 +1732,14 @@ static __latent_entropy struct task_struct *copy_process(
 					unsigned long clone_flags,
 					unsigned long stack_start,
 					unsigned long stack_size,
+					int __user *parent_tidptr,
 					int __user *child_tidptr,
 					struct pid *pid,
 					int trace,
 					unsigned long tls,
 					int node)
 {
-	int retval;
+	int pidfd = -1, retval;
 	struct task_struct *p;
 	struct multiprocess_signals delayed;
 
@@ -1734,6 +1789,31 @@ static __latent_entropy struct task_struct *copy_process(
 			return ERR_PTR(-EINVAL);
 	}
 
+	if (clone_flags & CLONE_PIDFD) {
+		int reserved;
+
+		/*
+		 * - CLONE_PARENT_SETTID is useless for pidfds and also
+		 *   parent_tidptr is used to return pidfds.
+		 * - CLONE_DETACHED is blocked so that we can potentially
+		 *   reuse it later for CLONE_PIDFD.
+		 * - CLONE_THREAD is blocked until someone really needs it.
+		 */
+		if (clone_flags &
+		    (CLONE_DETACHED | CLONE_PARENT_SETTID | CLONE_THREAD))
+			return ERR_PTR(-EINVAL);
+
+		/*
+		 * Verify that parent_tidptr is sane so we can potentially
+		 * reuse it later.
+		 */
+		if (get_user(reserved, parent_tidptr))
+			return ERR_PTR(-EFAULT);
+
+		if (reserved != 0)
+			return ERR_PTR(-EINVAL);
+	}
+
 	/*
 	 * Force any signals received before this point to be delivered
 	 * before the fork happens.  Collect up signals sent to multiple
@@ -1934,6 +2014,22 @@ static __latent_entropy struct task_struct *copy_process(
 		}
 	}
 
+	/*
+	 * This has to happen after we've potentially unshared the file
+	 * descriptor table (so that the pidfd doesn't leak into the child
+	 * if the fd table isn't shared).
+	 */
+	if (clone_flags & CLONE_PIDFD) {
+		retval = pidfd_create(pid);
+		if (retval < 0)
+			goto bad_fork_free_pid;
+
+		pidfd = retval;
+		retval = put_user(pidfd, parent_tidptr);
+		if (retval)
+			goto bad_fork_put_pidfd;
+	}
+
 #ifdef CONFIG_BLOCK
 	p->plug = NULL;
 #endif
@@ -1989,7 +2085,7 @@ static __latent_entropy struct task_struct *copy_process(
 	 */
 	retval = cgroup_can_fork(p);
 	if (retval)
-		goto bad_fork_free_pid;
+		goto bad_fork_put_pidfd;
 
 	/*
 	 * From this point on we must avoid any synchronous user-space
@@ -2111,6 +2207,9 @@ static __latent_entropy struct task_struct *copy_process(
 	spin_unlock(&current->sighand->siglock);
 	write_unlock_irq(&tasklist_lock);
 	cgroup_cancel_fork(p);
+bad_fork_put_pidfd:
+	if (clone_flags & CLONE_PIDFD)
+		ksys_close(pidfd);
 bad_fork_free_pid:
 	cgroup_threadgroup_change_end(current);
 	if (pid != &init_struct_pid)
@@ -2178,7 +2277,7 @@ static inline void init_idle_pids(struct task_struct *idle)
 struct task_struct *fork_idle(int cpu)
 {
 	struct task_struct *task;
-	task = copy_process(CLONE_VM, 0, 0, NULL, &init_struct_pid, 0, 0,
+	task = copy_process(CLONE_VM, 0, 0, NULL, NULL, &init_struct_pid, 0, 0,
 			    cpu_to_node(cpu));
 	if (!IS_ERR(task)) {
 		init_idle_pids(task);
@@ -2225,7 +2324,7 @@ long _do_fork(unsigned long clone_flags,
 			trace = 0;
 	}
 
-	p = copy_process(clone_flags, stack_start, stack_size,
+	p = copy_process(clone_flags, stack_start, stack_size, parent_tidptr,
 			 child_tidptr, NULL, trace, tls, NUMA_NO_NODE);
 	add_latent_entropy();
 
-- 
1.8.3.1

