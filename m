Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B52AA501CD4
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 22:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346627AbiDNUg0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 16:36:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346698AbiDNUgQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 16:36:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BF89EEA65;
        Thu, 14 Apr 2022 13:33:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B991AB82984;
        Thu, 14 Apr 2022 20:33:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65C3FC385A1;
        Thu, 14 Apr 2022 20:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649968412;
        bh=pQSHrTF+SzjyiVo/ESOMPCyqnHce07pb7b+kaP1zc7I=;
        h=Date:To:From:Subject:From;
        b=cpE5ZE3Zpmt8lD/TqftRJATp09ltu3BrStPZK7/nG7VBT7VgdIK6KCpsl307IN3al
         RxJ2POqe3EGbjwNB6VYJJAieWDfIFhJE8uvhH5djyCQIVxShSf8oVytJzXXcVmqIMW
         r7SzfA735Gr2DskJJBwI85BsXEr3GLqpnCaYNaO8=
Date:   Thu, 14 Apr 2022 13:33:31 -0700
To:     mm-commits@vger.kernel.org, vincent.guittot@linaro.org,
        tglx@linutronix.de, stable@vger.kernel.org, rostedt@goodmis.org,
        rientjes@google.com, peterz@infradead.org, mingo@redhat.com,
        mhocko@suse.com, mgorman@suse.de, longman@redhat.com,
        juri.lelli@redhat.com, jsavitz@redhat.com, herton@redhat.com,
        dvhart@infradead.org, dietmar.eggemann@arm.com, dave@stgolabs.net,
        bsegall@google.com, bristot@redhat.com, aquini@redhat.com,
        aarcange@redhat.com, npache@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + oom_killc-futex-delay-the-oom-reaper-to-allow-time-for-proper-futex-cleanup.patch added to -mm tree
Message-Id: <20220414203332.65C3FC385A1@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: oom_kill.c: futex: delay the OOM reaper to allow time for proper futex cleanup
has been added to the -mm tree.  Its filename is
     oom_killc-futex-delay-the-oom-reaper-to-allow-time-for-proper-futex-cleanup.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/oom_killc-futex-delay-the-oom-reaper-to-allow-time-for-proper-futex-cleanup.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/oom_killc-futex-delay-the-oom-reaper-to-allow-time-for-proper-futex-cleanup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nico Pache <npache@redhat.com>
Subject: oom_kill.c: futex: delay the OOM reaper to allow time for proper futex cleanup

The pthread struct is allocated on PRIVATE|ANONYMOUS memory [1] which can
be targeted by the oom reaper.  This mapping is used to store the futex
robust list head; the kernel does not keep a copy of the robust list and
instead references a userspace address to maintain the robustness during a
process death.  A race can occur between exit_mm and the oom reaper that
allows the oom reaper to free the memory of the futex robust list before
the exit path has handled the futex death:

    CPU1                               CPU2
------------------------------------------------------------------------
    page_fault
    do_exit "signal"
    wake_oom_reaper
                                        oom_reaper
                                        oom_reap_task_mm (invalidates mm)
    exit_mm
    exit_mm_release
    futex_exit_release
    futex_cleanup
    exit_robust_list
    get_user (EFAULT- can't access memory)

If the get_user EFAULT's, the kernel will be unable to recover the waiters
on the robust_list, leaving userspace mutexes hung indefinitely.

Delay the OOM reaper, allowing more time for the exit path to perform the
futex cleanup.

Reproducer: https://gitlab.com/jsavitz/oom_futex_reproducer

Based on a patch by Michal Hocko.

[1] https://elixir.bootlin.com/glibc/latest/source/nptl/allocatestack.c#L370

Link: https://lkml.kernel.org/r/20220414144042.677008-1-npache@redhat.com
Fixes: 212925802454 ("mm: oom: let oom_reap_task and exit_mmap run concurrently")
Signed-off-by: Joel Savitz <jsavitz@redhat.com>
Signed-off-by: Nico Pache <npache@redhat.com>
Co-developed-by: Joel Savitz <jsavitz@redhat.com>
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Rafael Aquini <aquini@redhat.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Herton R. Krzesinski <herton@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ben Segall <bsegall@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Daniel Bristot de Oliveira <bristot@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joel Savitz <jsavitz@redhat.com>
Cc: Darren Hart <dvhart@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/sched.h~oom_killc-futex-delay-the-oom-reaper-to-allow-time-for-proper-futex-cleanup
+++ a/include/linux/sched.h
@@ -1443,6 +1443,7 @@ struct task_struct {
 	int				pagefault_disabled;
 #ifdef CONFIG_MMU
 	struct task_struct		*oom_reaper_list;
+	struct timer_list		oom_reaper_timer;
 #endif
 #ifdef CONFIG_VMAP_STACK
 	struct vm_struct		*stack_vm_area;
--- a/mm/oom_kill.c~oom_killc-futex-delay-the-oom-reaper-to-allow-time-for-proper-futex-cleanup
+++ a/mm/oom_kill.c
@@ -632,7 +632,7 @@ done:
 	 */
 	set_bit(MMF_OOM_SKIP, &mm->flags);
 
-	/* Drop a reference taken by wake_oom_reaper */
+	/* Drop a reference taken by queue_oom_reaper */
 	put_task_struct(tsk);
 }
 
@@ -644,12 +644,12 @@ static int oom_reaper(void *unused)
 		struct task_struct *tsk = NULL;
 
 		wait_event_freezable(oom_reaper_wait, oom_reaper_list != NULL);
-		spin_lock(&oom_reaper_lock);
+		spin_lock_irq(&oom_reaper_lock);
 		if (oom_reaper_list != NULL) {
 			tsk = oom_reaper_list;
 			oom_reaper_list = tsk->oom_reaper_list;
 		}
-		spin_unlock(&oom_reaper_lock);
+		spin_unlock_irq(&oom_reaper_lock);
 
 		if (tsk)
 			oom_reap_task(tsk);
@@ -658,22 +658,48 @@ static int oom_reaper(void *unused)
 	return 0;
 }
 
-static void wake_oom_reaper(struct task_struct *tsk)
+static void wake_oom_reaper(struct timer_list *timer)
 {
-	/* mm is already queued? */
-	if (test_and_set_bit(MMF_OOM_REAP_QUEUED, &tsk->signal->oom_mm->flags))
+	struct task_struct *tsk = container_of(timer, struct task_struct,
+			oom_reaper_timer);
+	struct mm_struct *mm = tsk->signal->oom_mm;
+	unsigned long flags;
+
+	/* The victim managed to terminate on its own - see exit_mmap */
+	if (test_bit(MMF_OOM_SKIP, &mm->flags)) {
+		put_task_struct(tsk);
 		return;
+	}
 
-	get_task_struct(tsk);
-
-	spin_lock(&oom_reaper_lock);
+	spin_lock_irqsave(&oom_reaper_lock, flags);
 	tsk->oom_reaper_list = oom_reaper_list;
 	oom_reaper_list = tsk;
-	spin_unlock(&oom_reaper_lock);
+	spin_unlock_irqrestore(&oom_reaper_lock, flags);
 	trace_wake_reaper(tsk->pid);
 	wake_up(&oom_reaper_wait);
 }
 
+/*
+ * Give the OOM victim time to exit naturally before invoking the oom_reaping.
+ * The timers timeout is arbitrary... the longer it is, the longer the worst
+ * case scenario for the OOM can take. If it is too small, the oom_reaper can
+ * get in the way and release resources needed by the process exit path.
+ * e.g. The futex robust list can sit in Anon|Private memory that gets reaped
+ * before the exit path is able to wake the futex waiters.
+ */
+#define OOM_REAPER_DELAY (2*HZ)
+static void queue_oom_reaper(struct task_struct *tsk)
+{
+	/* mm is already queued? */
+	if (test_and_set_bit(MMF_OOM_REAP_QUEUED, &tsk->signal->oom_mm->flags))
+		return;
+
+	get_task_struct(tsk);
+	timer_setup(&tsk->oom_reaper_timer, wake_oom_reaper, 0);
+	tsk->oom_reaper_timer.expires = jiffies + OOM_REAPER_DELAY;
+	add_timer(&tsk->oom_reaper_timer);
+}
+
 static int __init oom_init(void)
 {
 	oom_reaper_th = kthread_run(oom_reaper, NULL, "oom_reaper");
@@ -681,7 +707,7 @@ static int __init oom_init(void)
 }
 subsys_initcall(oom_init)
 #else
-static inline void wake_oom_reaper(struct task_struct *tsk)
+static inline void queue_oom_reaper(struct task_struct *tsk)
 {
 }
 #endif /* CONFIG_MMU */
@@ -932,7 +958,7 @@ static void __oom_kill_process(struct ta
 	rcu_read_unlock();
 
 	if (can_oom_reap)
-		wake_oom_reaper(victim);
+		queue_oom_reaper(victim);
 
 	mmdrop(mm);
 	put_task_struct(victim);
@@ -968,7 +994,7 @@ static void oom_kill_process(struct oom_
 	task_lock(victim);
 	if (task_will_free_mem(victim)) {
 		mark_oom_victim(victim);
-		wake_oom_reaper(victim);
+		queue_oom_reaper(victim);
 		task_unlock(victim);
 		put_task_struct(victim);
 		return;
@@ -1067,7 +1093,7 @@ bool out_of_memory(struct oom_control *o
 	 */
 	if (task_will_free_mem(current)) {
 		mark_oom_victim(current);
-		wake_oom_reaper(current);
+		queue_oom_reaper(current);
 		return true;
 	}
 
_

Patches currently in -mm which might be from npache@redhat.com are

oom_killc-futex-delay-the-oom-reaper-to-allow-time-for-proper-futex-cleanup.patch

