Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7281D126D58
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728254AbfLSSjk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:39:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:57994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727956AbfLSSjj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:39:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AEEB0206D7;
        Thu, 19 Dec 2019 18:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576780778;
        bh=J6bDJs5K6fQHfb3h+kE6+fpwnQBs18l9Kc6dZMXqGB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sOtEe77+jz63LJ7dO8V98s0f9yf0hS9MUrosXRkpOOJh1r/GlMSYOvs13mCQ6LGtT
         LjB4R9tRqEG+isbw+NlKRqGFjV55sBPOA/Wc0k0NBQOJuP2lY1jIOye0jXy8AQP+jz
         /WbMu7mk8rIApwfg7bDHPTNEoudmh9FE+LfEd9zc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Brian Gerst <brgerst@gmail.com>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jann Horn <jann@thejh.net>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [PATCH 4.4 075/162] sched/core: Allow putting thread_info into task_struct
Date:   Thu, 19 Dec 2019 19:33:03 +0100
Message-Id: <20191219183212.365902632@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183150.477687052@linuxfoundation.org>
References: <20191219183150.477687052@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Lutomirski <luto@kernel.org>

commit c65eacbe290b8141554c71b2c94489e73ade8c8d upstream.

If an arch opts in by setting CONFIG_THREAD_INFO_IN_TASK_STRUCT,
then thread_info is defined as a single 'u32 flags' and is the first
entry of task_struct.  thread_info::task is removed (it serves no
purpose if thread_info is embedded in task_struct), and
thread_info::cpu gets its own slot in task_struct.

This is heavily based on a patch written by Linus.

Originally-from: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Jann Horn <jann@thejh.net>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/a0898196f0476195ca02713691a5037a14f2aac5.1473801993.git.luto@kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/init_task.h   |    9 +++++++++
 include/linux/sched.h       |   36 ++++++++++++++++++++++++++++++++++--
 include/linux/thread_info.h |   15 +++++++++++++++
 init/Kconfig                |    7 +++++++
 init/init_task.c            |    7 +++++--
 kernel/sched/sched.h        |    4 ++++
 6 files changed, 74 insertions(+), 4 deletions(-)

--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -15,6 +15,8 @@
 #include <net/net_namespace.h>
 #include <linux/sched/rt.h>
 
+#include <asm/thread_info.h>
+
 #ifdef CONFIG_SMP
 # define INIT_PUSHABLE_TASKS(tsk)					\
 	.pushable_tasks = PLIST_NODE_INIT(tsk.pushable_tasks, MAX_PRIO),
@@ -183,12 +185,19 @@ extern struct task_group root_task_group
 # define INIT_KASAN(tsk)
 #endif
 
+#ifdef CONFIG_THREAD_INFO_IN_TASK
+# define INIT_TASK_TI(tsk) .thread_info = INIT_THREAD_INFO(tsk),
+#else
+# define INIT_TASK_TI(tsk)
+#endif
+
 /*
  *  INIT_TASK is used to set up the first task table, touch at
  * your own risk!. Base=0, limit=0x1fffff (=2MB)
  */
 #define INIT_TASK(tsk)	\
 {									\
+	INIT_TASK_TI(tsk)						\
 	.state		= 0,						\
 	.stack		= &init_thread_info,				\
 	.usage		= ATOMIC_INIT(2),				\
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1389,6 +1389,13 @@ struct tlbflush_unmap_batch {
 };
 
 struct task_struct {
+#ifdef CONFIG_THREAD_INFO_IN_TASK
+	/*
+	 * For reasons of header soup (see current_thread_info()), this
+	 * must be the first element of task_struct.
+	 */
+	struct thread_info thread_info;
+#endif
 	volatile long state;	/* -1 unrunnable, 0 runnable, >0 stopped */
 	void *stack;
 	atomic_t usage;
@@ -1398,6 +1405,9 @@ struct task_struct {
 #ifdef CONFIG_SMP
 	struct llist_node wake_entry;
 	int on_cpu;
+#ifdef CONFIG_THREAD_INFO_IN_TASK
+	unsigned int cpu;	/* current CPU */
+#endif
 	unsigned int wakee_flips;
 	unsigned long wakee_flip_decay_ts;
 	struct task_struct *last_wakee;
@@ -2440,7 +2450,9 @@ extern void set_curr_task(int cpu, struc
 void yield(void);
 
 union thread_union {
+#ifndef CONFIG_THREAD_INFO_IN_TASK
 	struct thread_info thread_info;
+#endif
 	unsigned long stack[THREAD_SIZE/sizeof(long)];
 };
 
@@ -2840,10 +2852,26 @@ static inline void threadgroup_change_en
 	cgroup_threadgroup_change_end(tsk);
 }
 
-#ifndef __HAVE_THREAD_FUNCTIONS
+#ifdef CONFIG_THREAD_INFO_IN_TASK
+
+static inline struct thread_info *task_thread_info(struct task_struct *task)
+{
+	return &task->thread_info;
+}
+static inline void *task_stack_page(const struct task_struct *task)
+{
+	return task->stack;
+}
+#define setup_thread_stack(new,old)	do { } while(0)
+static inline unsigned long *end_of_stack(const struct task_struct *task)
+{
+	return task->stack;
+}
+
+#elif !defined(__HAVE_THREAD_FUNCTIONS)
 
 #define task_thread_info(task)	((struct thread_info *)(task)->stack)
-#define task_stack_page(task)	((task)->stack)
+#define task_stack_page(task)	((void *)(task)->stack)
 
 static inline void setup_thread_stack(struct task_struct *p, struct task_struct *org)
 {
@@ -3135,7 +3163,11 @@ static inline void ptrace_signal_wake_up
 
 static inline unsigned int task_cpu(const struct task_struct *p)
 {
+#ifdef CONFIG_THREAD_INFO_IN_TASK
+	return p->cpu;
+#else
 	return task_thread_info(p)->cpu;
+#endif
 }
 
 static inline int task_node(const struct task_struct *p)
--- a/include/linux/thread_info.h
+++ b/include/linux/thread_info.h
@@ -13,6 +13,21 @@
 struct timespec;
 struct compat_timespec;
 
+#ifdef CONFIG_THREAD_INFO_IN_TASK
+struct thread_info {
+	u32			flags;		/* low level flags */
+};
+
+#define INIT_THREAD_INFO(tsk)			\
+{						\
+	.flags		= 0,			\
+}
+#endif
+
+#ifdef CONFIG_THREAD_INFO_IN_TASK
+#define current_thread_info() ((struct thread_info *)current)
+#endif
+
 /*
  * System call restart block.
  */
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -26,6 +26,13 @@ config IRQ_WORK
 config BUILDTIME_EXTABLE_SORT
 	bool
 
+config THREAD_INFO_IN_TASK
+	bool
+	help
+	  Select this to move thread_info off the stack into task_struct.  To
+	  make this work, an arch will need to remove all thread_info fields
+	  except flags and fix any runtime bugs.
+
 menu "General setup"
 
 config BROKEN
--- a/init/init_task.c
+++ b/init/init_task.c
@@ -22,5 +22,8 @@ EXPORT_SYMBOL(init_task);
  * Initial thread structure. Alignment of this is handled by a special
  * linker map entry.
  */
-union thread_union init_thread_union __init_task_data =
-	{ INIT_THREAD_INFO(init_task) };
+union thread_union init_thread_union __init_task_data = {
+#ifndef CONFIG_THREAD_INFO_IN_TASK
+	INIT_THREAD_INFO(init_task)
+#endif
+};
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -978,7 +978,11 @@ static inline void __set_task_cpu(struct
 	 * per-task data have been completed by this moment.
 	 */
 	smp_wmb();
+#ifdef CONFIG_THREAD_INFO_IN_TASK
+	p->cpu = cpu;
+#else
 	task_thread_info(p)->cpu = cpu;
+#endif
 	p->wake_cpu = cpu;
 #endif
 }


