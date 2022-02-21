Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 369204BD734
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 08:43:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbiBUHRG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 02:17:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345935AbiBUHRF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 02:17:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67EDC25D4
        for <stable@vger.kernel.org>; Sun, 20 Feb 2022 23:16:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B87D60F21
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 07:16:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 107E0C340E9;
        Mon, 21 Feb 2022 07:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645427801;
        bh=nS8JowOoCo3crduJOJOkoX0YclmqjEVC8TF3blW1hUA=;
        h=Subject:To:Cc:From:Date:From;
        b=ZKSjtVe5aJx8dzXD1nG2/IvB95CwRCM5wNU03/BEGrEm57jEmYm19LcTKTjugU8Lf
         qhpNCzrzPw0vNnEkJdlhBLS999VJH3prEblYwmIlVCPit/gQSYiDiLF/iGRcXecC0s
         7zhQ7C00ghzZM4n/sYiTFEkz/NZfWzzSCbMPN2Os=
Subject: FAILED: patch "[PATCH] sched: Fix yet more sched_fork() races" failed to apply to 5.15-stable tree
To:     peterz@infradead.org, dietmar.eggemann@arm.com,
        tadeusz.struk@linaro.org, torvalds@linux-foundation.org,
        zhangqiao22@huawei.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 21 Feb 2022 08:16:30 +0100
Message-ID: <164542779054199@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b1e8206582f9d680cff7d04828708c8b6ab32957 Mon Sep 17 00:00:00 2001
From: Peter Zijlstra <peterz@infradead.org>
Date: Mon, 14 Feb 2022 10:16:57 +0100
Subject: [PATCH] sched: Fix yet more sched_fork() races

Where commit 4ef0c5c6b5ba ("kernel/sched: Fix sched_fork() access an
invalid sched_task_group") fixed a fork race vs cgroup, it opened up a
race vs syscalls by not placing the task on the runqueue before it
gets exposed through the pidhash.

Commit 13765de8148f ("sched/fair: Fix fault in reweight_entity") is
trying to fix a single instance of this, instead fix the whole class
of issues, effectively reverting this commit.

Fixes: 4ef0c5c6b5ba ("kernel/sched: Fix sched_fork() access an invalid sched_task_group")
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Tadeusz Struk <tadeusz.struk@linaro.org>
Tested-by: Zhang Qiao <zhangqiao22@huawei.com>
Tested-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Link: https://lkml.kernel.org/r/YgoeCbwj5mbCR0qA@hirez.programming.kicks-ass.net

diff --git a/include/linux/sched/task.h b/include/linux/sched/task.h
index b9198a1b3a84..e84e54d1b490 100644
--- a/include/linux/sched/task.h
+++ b/include/linux/sched/task.h
@@ -54,8 +54,8 @@ extern asmlinkage void schedule_tail(struct task_struct *prev);
 extern void init_idle(struct task_struct *idle, int cpu);
 
 extern int sched_fork(unsigned long clone_flags, struct task_struct *p);
-extern void sched_post_fork(struct task_struct *p,
-			    struct kernel_clone_args *kargs);
+extern void sched_cgroup_fork(struct task_struct *p, struct kernel_clone_args *kargs);
+extern void sched_post_fork(struct task_struct *p);
 extern void sched_dead(struct task_struct *p);
 
 void __noreturn do_task_dead(void);
diff --git a/kernel/fork.c b/kernel/fork.c
index d75a528f7b21..c607d238fc23 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2266,6 +2266,17 @@ static __latent_entropy struct task_struct *copy_process(
 	if (retval)
 		goto bad_fork_put_pidfd;
 
+	/*
+	 * Now that the cgroups are pinned, re-clone the parent cgroup and put
+	 * the new task on the correct runqueue. All this *before* the task
+	 * becomes visible.
+	 *
+	 * This isn't part of ->can_fork() because while the re-cloning is
+	 * cgroup specific, it unconditionally needs to place the task on a
+	 * runqueue.
+	 */
+	sched_cgroup_fork(p, args);
+
 	/*
 	 * From this point on we must avoid any synchronous user-space
 	 * communication until we take the tasklist-lock. In particular, we do
@@ -2376,7 +2387,7 @@ static __latent_entropy struct task_struct *copy_process(
 	write_unlock_irq(&tasklist_lock);
 
 	proc_fork_connector(p);
-	sched_post_fork(p, args);
+	sched_post_fork(p);
 	cgroup_post_fork(p, args);
 	perf_event_fork(p);
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index fcf0c180617c..9745613d531c 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1214,9 +1214,8 @@ int tg_nop(struct task_group *tg, void *data)
 }
 #endif
 
-static void set_load_weight(struct task_struct *p)
+static void set_load_weight(struct task_struct *p, bool update_load)
 {
-	bool update_load = !(READ_ONCE(p->__state) & TASK_NEW);
 	int prio = p->static_prio - MAX_RT_PRIO;
 	struct load_weight *load = &p->se.load;
 
@@ -4407,7 +4406,7 @@ int sched_fork(unsigned long clone_flags, struct task_struct *p)
 			p->static_prio = NICE_TO_PRIO(0);
 
 		p->prio = p->normal_prio = p->static_prio;
-		set_load_weight(p);
+		set_load_weight(p, false);
 
 		/*
 		 * We don't need the reset flag anymore after the fork. It has
@@ -4425,6 +4424,7 @@ int sched_fork(unsigned long clone_flags, struct task_struct *p)
 
 	init_entity_runnable_average(&p->se);
 
+
 #ifdef CONFIG_SCHED_INFO
 	if (likely(sched_info_on()))
 		memset(&p->sched_info, 0, sizeof(p->sched_info));
@@ -4440,18 +4440,23 @@ int sched_fork(unsigned long clone_flags, struct task_struct *p)
 	return 0;
 }
 
-void sched_post_fork(struct task_struct *p, struct kernel_clone_args *kargs)
+void sched_cgroup_fork(struct task_struct *p, struct kernel_clone_args *kargs)
 {
 	unsigned long flags;
-#ifdef CONFIG_CGROUP_SCHED
-	struct task_group *tg;
-#endif
 
+	/*
+	 * Because we're not yet on the pid-hash, p->pi_lock isn't strictly
+	 * required yet, but lockdep gets upset if rules are violated.
+	 */
 	raw_spin_lock_irqsave(&p->pi_lock, flags);
 #ifdef CONFIG_CGROUP_SCHED
-	tg = container_of(kargs->cset->subsys[cpu_cgrp_id],
-			  struct task_group, css);
-	p->sched_task_group = autogroup_task_group(p, tg);
+	if (1) {
+		struct task_group *tg;
+		tg = container_of(kargs->cset->subsys[cpu_cgrp_id],
+				  struct task_group, css);
+		tg = autogroup_task_group(p, tg);
+		p->sched_task_group = tg;
+	}
 #endif
 	rseq_migrate(p);
 	/*
@@ -4462,7 +4467,10 @@ void sched_post_fork(struct task_struct *p, struct kernel_clone_args *kargs)
 	if (p->sched_class->task_fork)
 		p->sched_class->task_fork(p);
 	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
+}
 
+void sched_post_fork(struct task_struct *p)
+{
 	uclamp_post_fork(p);
 }
 
@@ -6922,7 +6930,7 @@ void set_user_nice(struct task_struct *p, long nice)
 		put_prev_task(rq, p);
 
 	p->static_prio = NICE_TO_PRIO(nice);
-	set_load_weight(p);
+	set_load_weight(p, true);
 	old_prio = p->prio;
 	p->prio = effective_prio(p);
 
@@ -7213,7 +7221,7 @@ static void __setscheduler_params(struct task_struct *p,
 	 */
 	p->rt_priority = attr->sched_priority;
 	p->normal_prio = normal_prio(p);
-	set_load_weight(p);
+	set_load_weight(p, true);
 }
 
 /*
@@ -9446,7 +9454,7 @@ void __init sched_init(void)
 #endif
 	}
 
-	set_load_weight(&init_task);
+	set_load_weight(&init_task, false);
 
 	/*
 	 * The boot idle thread does lazy MMU switching as well:

