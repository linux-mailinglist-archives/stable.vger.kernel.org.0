Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 703374523D0
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:28:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240295AbhKPBbC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:31:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:59666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243227AbhKOSzp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:55:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D55E463246;
        Mon, 15 Nov 2021 18:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999892;
        bh=ojyKTAtCH96SPrNgtMGR/mNA+MTA7yb3m3VvJCYly0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K9KKaQE/NCxU3DR9UAi+YbMfOicUP15HYDud4CMwZPC6MlJ6YTQwimnmv4eBTheI5
         X35gQK47ygmuZJ/1bBD8sPAlnG1JUucMB4c97eHNWdgTOcz2zPD/KCZtKw/5v/HG1h
         y9zpWL26rK7DYzB/KdyoGF+ZBzxSQ2WvDnTzM2wg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qiao <zhangqiao22@huawei.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Tejun Heo <tj@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 428/849] kernel/sched: Fix sched_fork() access an invalid sched_task_group
Date:   Mon, 15 Nov 2021 17:58:31 +0100
Message-Id: <20211115165434.750077300@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qiao <zhangqiao22@huawei.com>

[ Upstream commit 4ef0c5c6b5ba1f38f0ea1cedad0cad722f00c14a ]

There is a small race between copy_process() and sched_fork()
where child->sched_task_group point to an already freed pointer.

	parent doing fork()      | someone moving the parent
				 | to another cgroup
  -------------------------------+-------------------------------
  copy_process()
      + dup_task_struct()<1>
				  parent move to another cgroup,
				  and free the old cgroup. <2>
      + sched_fork()
	+ __set_task_cpu()<3>
	+ task_fork_fair()
	  + sched_slice()<4>

In the worst case, this bug can lead to "use-after-free" and
cause panic as shown above:

  (1) parent copy its sched_task_group to child at <1>;

  (2) someone move the parent to another cgroup and free the old
      cgroup at <2>;

  (3) the sched_task_group and cfs_rq that belong to the old cgroup
      will be accessed at <3> and <4>, which cause a panic:

  [] BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
  [] PGD 8000001fa0a86067 P4D 8000001fa0a86067 PUD 2029955067 PMD 0
  [] Oops: 0000 [#1] SMP PTI
  [] CPU: 7 PID: 648398 Comm: ebizzy Kdump: loaded Tainted: G           OE    --------- -  - 4.18.0.x86_64+ #1
  [] RIP: 0010:sched_slice+0x84/0xc0

  [] Call Trace:
  []  task_fork_fair+0x81/0x120
  []  sched_fork+0x132/0x240
  []  copy_process.part.5+0x675/0x20e0
  []  ? __handle_mm_fault+0x63f/0x690
  []  _do_fork+0xcd/0x3b0
  []  do_syscall_64+0x5d/0x1d0
  []  entry_SYSCALL_64_after_hwframe+0x65/0xca
  [] RIP: 0033:0x7f04418cd7e1

Between cgroup_can_fork() and cgroup_post_fork(), the cgroup
membership and thus sched_task_group can't change. So update child's
sched_task_group at sched_post_fork() and move task_fork() and
__set_task_cpu() (where accees the sched_task_group) from sched_fork()
to sched_post_fork().

Fixes: 8323f26ce342 ("sched: Fix race in task_group")
Signed-off-by: Zhang Qiao <zhangqiao22@huawei.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://lkml.kernel.org/r/20210915064030.2231-1-zhangqiao22@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched/task.h |  3 ++-
 kernel/fork.c              |  2 +-
 kernel/sched/core.c        | 43 +++++++++++++++++++-------------------
 3 files changed, 25 insertions(+), 23 deletions(-)

diff --git a/include/linux/sched/task.h b/include/linux/sched/task.h
index ef02be869cf28..ba88a69874004 100644
--- a/include/linux/sched/task.h
+++ b/include/linux/sched/task.h
@@ -54,7 +54,8 @@ extern asmlinkage void schedule_tail(struct task_struct *prev);
 extern void init_idle(struct task_struct *idle, int cpu);
 
 extern int sched_fork(unsigned long clone_flags, struct task_struct *p);
-extern void sched_post_fork(struct task_struct *p);
+extern void sched_post_fork(struct task_struct *p,
+			    struct kernel_clone_args *kargs);
 extern void sched_dead(struct task_struct *p);
 
 void __noreturn do_task_dead(void);
diff --git a/kernel/fork.c b/kernel/fork.c
index cbba21e3a58df..286c9d43163da 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2331,7 +2331,7 @@ static __latent_entropy struct task_struct *copy_process(
 	write_unlock_irq(&tasklist_lock);
 
 	proc_fork_connector(p);
-	sched_post_fork(p);
+	sched_post_fork(p, args);
 	cgroup_post_fork(p, args);
 	perf_event_fork(p);
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e165d28cf73be..9289da7f0ac4a 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4096,8 +4096,6 @@ int sysctl_schedstats(struct ctl_table *table, int write, void *buffer,
  */
 int sched_fork(unsigned long clone_flags, struct task_struct *p)
 {
-	unsigned long flags;
-
 	__sched_fork(clone_flags, p);
 	/*
 	 * We mark the process as NEW here. This guarantees that
@@ -4143,24 +4141,6 @@ int sched_fork(unsigned long clone_flags, struct task_struct *p)
 
 	init_entity_runnable_average(&p->se);
 
-	/*
-	 * The child is not yet in the pid-hash so no cgroup attach races,
-	 * and the cgroup is pinned to this child due to cgroup_fork()
-	 * is ran before sched_fork().
-	 *
-	 * Silence PROVE_RCU.
-	 */
-	raw_spin_lock_irqsave(&p->pi_lock, flags);
-	rseq_migrate(p);
-	/*
-	 * We're setting the CPU for the first time, we don't migrate,
-	 * so use __set_task_cpu().
-	 */
-	__set_task_cpu(p, smp_processor_id());
-	if (p->sched_class->task_fork)
-		p->sched_class->task_fork(p);
-	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
-
 #ifdef CONFIG_SCHED_INFO
 	if (likely(sched_info_on()))
 		memset(&p->sched_info, 0, sizeof(p->sched_info));
@@ -4176,8 +4156,29 @@ int sched_fork(unsigned long clone_flags, struct task_struct *p)
 	return 0;
 }
 
-void sched_post_fork(struct task_struct *p)
+void sched_post_fork(struct task_struct *p, struct kernel_clone_args *kargs)
 {
+	unsigned long flags;
+#ifdef CONFIG_CGROUP_SCHED
+	struct task_group *tg;
+#endif
+
+	raw_spin_lock_irqsave(&p->pi_lock, flags);
+#ifdef CONFIG_CGROUP_SCHED
+	tg = container_of(kargs->cset->subsys[cpu_cgrp_id],
+			  struct task_group, css);
+	p->sched_task_group = autogroup_task_group(p, tg);
+#endif
+	rseq_migrate(p);
+	/*
+	 * We're setting the CPU for the first time, we don't migrate,
+	 * so use __set_task_cpu().
+	 */
+	__set_task_cpu(p, smp_processor_id());
+	if (p->sched_class->task_fork)
+		p->sched_class->task_fork(p);
+	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
+
 	uclamp_post_fork(p);
 }
 
-- 
2.33.0



