Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D46D44CF87C
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:55:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238811AbiCGJyi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:54:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238656AbiCGJxA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:53:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F200775E78;
        Mon,  7 Mar 2022 01:45:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A37B6128D;
        Mon,  7 Mar 2022 09:45:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79EFFC36AE9;
        Mon,  7 Mar 2022 09:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646314;
        bh=SBHf2a7yUd4WUNercWNRH7elJmG5bff6672ToURpKNY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KHCqr+XGDZBRuhnhGHdkaRL6is3bvdvO9809Conve2iLRxV3TOXrSCYMelfxPP39e
         cKD/G3D8qAjvjNIHFC0H08wqs2jLceZf6oZCR22pE0w8jDma+VtMGfILuydRN13wDb
         LZkmp47XIDUdOXfGcJTpXm0zT/dwe2ro/VavO4tE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Tadeusz Struk <tadeusz.struk@linaro.org>,
        Zhang Qiao <zhangqiao22@huawei.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>
Subject: [PATCH 5.15 202/262] sched: Fix yet more sched_fork() races
Date:   Mon,  7 Mar 2022 10:19:06 +0100
Message-Id: <20220307091708.413231876@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit b1e8206582f9d680cff7d04828708c8b6ab32957 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/sched/task.h |    4 ++--
 kernel/fork.c              |   13 ++++++++++++-
 kernel/sched/core.c        |   34 +++++++++++++++++++++-------------
 3 files changed, 35 insertions(+), 16 deletions(-)

--- a/include/linux/sched/task.h
+++ b/include/linux/sched/task.h
@@ -54,8 +54,8 @@ extern asmlinkage void schedule_tail(str
 extern void init_idle(struct task_struct *idle, int cpu);
 
 extern int sched_fork(unsigned long clone_flags, struct task_struct *p);
-extern void sched_post_fork(struct task_struct *p,
-			    struct kernel_clone_args *kargs);
+extern void sched_cgroup_fork(struct task_struct *p, struct kernel_clone_args *kargs);
+extern void sched_post_fork(struct task_struct *p);
 extern void sched_dead(struct task_struct *p);
 
 void __noreturn do_task_dead(void);
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2297,6 +2297,17 @@ static __latent_entropy struct task_stru
 		goto bad_fork_put_pidfd;
 
 	/*
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
+	/*
 	 * From this point on we must avoid any synchronous user-space
 	 * communication until we take the tasklist-lock. In particular, we do
 	 * not want user-space to be able to predict the process start-time by
@@ -2405,7 +2416,7 @@ static __latent_entropy struct task_stru
 		fd_install(pidfd, pidfile);
 
 	proc_fork_connector(p);
-	sched_post_fork(p, args);
+	sched_post_fork(p);
 	cgroup_post_fork(p, args);
 	perf_event_fork(p);
 
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1199,9 +1199,8 @@ int tg_nop(struct task_group *tg, void *
 }
 #endif
 
-static void set_load_weight(struct task_struct *p)
+static void set_load_weight(struct task_struct *p, bool update_load)
 {
-	bool update_load = !(READ_ONCE(p->__state) & TASK_NEW);
 	int prio = p->static_prio - MAX_RT_PRIO;
 	struct load_weight *load = &p->se.load;
 
@@ -4359,7 +4358,7 @@ int sched_fork(unsigned long clone_flags
 			p->static_prio = NICE_TO_PRIO(0);
 
 		p->prio = p->normal_prio = p->static_prio;
-		set_load_weight(p);
+		set_load_weight(p, false);
 
 		/*
 		 * We don't need the reset flag anymore after the fork. It has
@@ -4377,6 +4376,7 @@ int sched_fork(unsigned long clone_flags
 
 	init_entity_runnable_average(&p->se);
 
+
 #ifdef CONFIG_SCHED_INFO
 	if (likely(sched_info_on()))
 		memset(&p->sched_info, 0, sizeof(p->sched_info));
@@ -4392,18 +4392,23 @@ int sched_fork(unsigned long clone_flags
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
@@ -4414,7 +4419,10 @@ void sched_post_fork(struct task_struct
 	if (p->sched_class->task_fork)
 		p->sched_class->task_fork(p);
 	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
+}
 
+void sched_post_fork(struct task_struct *p)
+{
 	uclamp_post_fork(p);
 }
 
@@ -6903,7 +6911,7 @@ void set_user_nice(struct task_struct *p
 		put_prev_task(rq, p);
 
 	p->static_prio = NICE_TO_PRIO(nice);
-	set_load_weight(p);
+	set_load_weight(p, true);
 	old_prio = p->prio;
 	p->prio = effective_prio(p);
 
@@ -7194,7 +7202,7 @@ static void __setscheduler_params(struct
 	 */
 	p->rt_priority = attr->sched_priority;
 	p->normal_prio = normal_prio(p);
-	set_load_weight(p);
+	set_load_weight(p, true);
 }
 
 /*
@@ -9432,7 +9440,7 @@ void __init sched_init(void)
 #endif
 	}
 
-	set_load_weight(&init_task);
+	set_load_weight(&init_task, false);
 
 	/*
 	 * The boot idle thread does lazy MMU switching as well:


