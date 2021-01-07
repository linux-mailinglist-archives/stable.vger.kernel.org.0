Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 930DD2ECB3D
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 08:55:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727459AbhAGHyD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 02:54:03 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:52721 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727415AbhAGHyD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 02:54:03 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R261e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=wenyang@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0UKzE3SA_1610005997;
Received: from localhost(mailfrom:wenyang@linux.alibaba.com fp:SMTPD_---0UKzE3SA_1610005997)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 07 Jan 2021 15:53:17 +0800
From:   Wen Yang <wenyang@linux.alibaba.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Xunlei Pang <xlpang@linux.alibaba.com>,
        linux-kernel@vger.kernel.org,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Colascione <dancol@google.com>,
        Jann Horn <jannh@google.com>,
        Tim Murray <timmurray@google.com>,
        Jonathan Kowalski <bl0pbl33p@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Kees Cook <keescook@chromium.org>,
        David Howells <dhowells@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, kernel-team@android.com,
        Christian Brauner <christian@brauner.io>,
        stable@vger.kernel.org, Wen Yang <wenyang@linux.alibaba.com>
Subject: [PATCH 4.19 2/7] pidfd: add polling support
Date:   Thu,  7 Jan 2021 15:53:09 +0800
Message-Id: <20210107075314.62683-3-wenyang@linux.alibaba.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210107075314.62683-1-wenyang@linux.alibaba.com>
References: <20210107075314.62683-1-wenyang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Joel Fernandes (Google)" <joel@joelfernandes.org>

[ Upstream commit b53b0b9d9a613c418057f6cb921c2f40a6f78c24 ]

This patch adds polling support to pidfd.

Android low memory killer (LMK) needs to know when a process dies once
it is sent the kill signal. It does so by checking for the existence of
/proc/pid which is both racy and slow. For example, if a PID is reused
between when LMK sends a kill signal and checks for existence of the
PID, since the wrong PID is now possibly checked for existence.
Using the polling support, LMK will be able to get notified when a process
exists in race-free and fast way, and allows the LMK to do other things
(such as by polling on other fds) while awaiting the process being killed
to die.

For notification to polling processes, we follow the same existing
mechanism in the kernel used when the parent of the task group is to be
notified of a child's death (do_notify_parent). This is precisely when the
tasks waiting on a poll of pidfd are also awakened in this patch.

We have decided to include the waitqueue in struct pid for the following
reasons:
1. The wait queue has to survive for the lifetime of the poll. Including
   it in task_struct would not be option in this case because the task can
   be reaped and destroyed before the poll returns.

2. By including the struct pid for the waitqueue means that during
   de_thread(), the new thread group leader automatically gets the new
   waitqueue/pid even though its task_struct is different.

Appropriate test cases are added in the second patch to provide coverage of
all the cases the patch is handling.

Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Daniel Colascione <dancol@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Tim Murray <timmurray@google.com>
Cc: Jonathan Kowalski <bl0pbl33p@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: kernel-team@android.com
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Co-developed-by: Daniel Colascione <dancol@google.com>
Signed-off-by: Daniel Colascione <dancol@google.com>
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Signed-off-by: Christian Brauner <christian@brauner.io>
Cc: <stable@vger.kernel.org> # 4.19.x
Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
---
 include/linux/pid.h |  3 +++
 kernel/fork.c       | 26 ++++++++++++++++++++++++++
 kernel/pid.c        |  2 ++
 kernel/signal.c     | 11 +++++++++++
 4 files changed, 42 insertions(+)

diff --git a/include/linux/pid.h b/include/linux/pid.h
index 29c0a99..a82d2f7 100644
--- a/include/linux/pid.h
+++ b/include/linux/pid.h
@@ -3,6 +3,7 @@
 #define _LINUX_PID_H
 
 #include <linux/rculist.h>
+#include <linux/wait.h>
 
 enum pid_type
 {
@@ -60,6 +61,8 @@ struct pid
 	unsigned int level;
 	/* lists of tasks that use this pid */
 	struct hlist_head tasks[PIDTYPE_MAX];
+	/* wait queue for pidfd notifications */
+	wait_queue_head_t wait_pidfd;
 	struct rcu_head rcu;
 	struct upid numbers[1];
 };
diff --git a/kernel/fork.c b/kernel/fork.c
index e419891..33dc746 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1688,8 +1688,34 @@ static void pidfd_show_fdinfo(struct seq_file *m, struct file *f)
 }
 #endif
 
+/*
+ * Poll support for process exit notification.
+ */
+static unsigned int pidfd_poll(struct file *file, struct poll_table_struct *pts)
+{
+	struct task_struct *task;
+	struct pid *pid = file->private_data;
+	int poll_flags = 0;
+
+	poll_wait(file, &pid->wait_pidfd, pts);
+
+	rcu_read_lock();
+	task = pid_task(pid, PIDTYPE_PID);
+	/*
+	 * Inform pollers only when the whole thread group exits.
+	 * If the thread group leader exits before all other threads in the
+	 * group, then poll(2) should block, similar to the wait(2) family.
+	 */
+	if (!task || (task->exit_state && thread_group_empty(task)))
+		poll_flags = POLLIN | POLLRDNORM;
+	rcu_read_unlock();
+
+	return poll_flags;
+}
+
 const struct file_operations pidfd_fops = {
 	.release = pidfd_release,
+	.poll = pidfd_poll,
 #ifdef CONFIG_PROC_FS
 	.show_fdinfo = pidfd_show_fdinfo,
 #endif
diff --git a/kernel/pid.c b/kernel/pid.c
index b88fe5e..3ba6fcb 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -214,6 +214,8 @@ struct pid *alloc_pid(struct pid_namespace *ns)
 	for (type = 0; type < PIDTYPE_MAX; ++type)
 		INIT_HLIST_HEAD(&pid->tasks[type]);
 
+	init_waitqueue_head(&pid->wait_pidfd);
+
 	upid = pid->numbers + ns->level;
 	spin_lock_irq(&pidmap_lock);
 	if (!(ns->pid_allocated & PIDNS_ADDING))
diff --git a/kernel/signal.c b/kernel/signal.c
index a02a25a..22a04795 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1810,6 +1810,14 @@ int send_sigqueue(struct sigqueue *q, struct pid *pid, enum pid_type type)
 	return ret;
 }
 
+static void do_notify_pidfd(struct task_struct *task)
+{
+	struct pid *pid;
+
+	pid = task_pid(task);
+	wake_up_all(&pid->wait_pidfd);
+}
+
 /*
  * Let a parent know about the death of a child.
  * For a stopped/continued status change, use do_notify_parent_cldstop instead.
@@ -1833,6 +1841,9 @@ bool do_notify_parent(struct task_struct *tsk, int sig)
 	BUG_ON(!tsk->ptrace &&
 	       (tsk->group_leader != tsk || !thread_group_empty(tsk)));
 
+	/* Wake up all pidfd waiters */
+	do_notify_pidfd(tsk);
+
 	if (sig != SIGCHLD) {
 		/*
 		 * This is only possible if parent == real_parent.
-- 
1.8.3.1

