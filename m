Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 846CF50F4BE
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241096AbiDZIkE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:40:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345551AbiDZIjN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:39:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D83613F85;
        Tue, 26 Apr 2022 01:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5BFF9B81CFE;
        Tue, 26 Apr 2022 08:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28E58C385A0;
        Tue, 26 Apr 2022 08:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650961813;
        bh=NDdNXZKnnThCRhYF5OdnBZCBBVtrCFHLKmbP7fMj5fo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T/klOPzRvlsBBQqaFcq9IoIe6tR46HANYFCKrNJlwQLROqnRqrBCKa5V+I+C5zIPA
         TQyefTzWVmJk5owjuNsYkeWb0mU8r3vJiJpQK/PAgb2AmB3Cf6fwj36/SqNZ8UhdMf
         5RDIynLnq6S5QCcrcoC2wnXLYWdfr1Fa4Z9Wsc2k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joel Savitz <jsavitz@redhat.com>,
        Nico Pache <npache@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michal Hocko <mhocko@suse.com>,
        Rafael Aquini <aquini@redhat.com>,
        Waiman Long <longman@redhat.com>,
        "Herton R. Krzesinski" <herton@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Darren Hart <dvhart@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 37/62] oom_kill.c: futex: delay the OOM reaper to allow time for proper futex cleanup
Date:   Tue, 26 Apr 2022 10:21:17 +0200
Message-Id: <20220426081738.286712871@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081737.209637816@linuxfoundation.org>
References: <20220426081737.209637816@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nico Pache <npache@redhat.com>

commit e4a38402c36e42df28eb1a5394be87e6571fb48a upstream.

The pthread struct is allocated on PRIVATE|ANONYMOUS memory [1] which
can be targeted by the oom reaper.  This mapping is used to store the
futex robust list head; the kernel does not keep a copy of the robust
list and instead references a userspace address to maintain the
robustness during a process death.

A race can occur between exit_mm and the oom reaper that allows the oom
reaper to free the memory of the futex robust list before the exit path
has handled the futex death:

    CPU1                               CPU2
    --------------------------------------------------------------------
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

If the get_user EFAULT's, the kernel will be unable to recover the
waiters on the robust_list, leaving userspace mutexes hung indefinitely.

Delay the OOM reaper, allowing more time for the exit path to perform
the futex cleanup.

Reproducer: https://gitlab.com/jsavitz/oom_futex_reproducer

Based on a patch by Michal Hocko.

Link: https://elixir.bootlin.com/glibc/glibc-2.35/source/nptl/allocatestack.c#L370 [1]
Link: https://lkml.kernel.org/r/20220414144042.677008-1-npache@redhat.com
Fixes: 212925802454 ("mm: oom: let oom_reap_task and exit_mmap run concurrently")
Signed-off-by: Joel Savitz <jsavitz@redhat.com>
Signed-off-by: Nico Pache <npache@redhat.com>
Co-developed-by: Joel Savitz <jsavitz@redhat.com>
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Michal Hocko <mhocko@suse.com>
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
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joel Savitz <jsavitz@redhat.com>
Cc: Darren Hart <dvhart@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/sched.h |    1 
 mm/oom_kill.c         |   54 +++++++++++++++++++++++++++++++++++++-------------
 2 files changed, 41 insertions(+), 14 deletions(-)

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1247,6 +1247,7 @@ struct task_struct {
 	int				pagefault_disabled;
 #ifdef CONFIG_MMU
 	struct task_struct		*oom_reaper_list;
+	struct timer_list		oom_reaper_timer;
 #endif
 #ifdef CONFIG_VMAP_STACK
 	struct vm_struct		*stack_vm_area;
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -631,7 +631,7 @@ done:
 	 */
 	set_bit(MMF_OOM_SKIP, &mm->flags);
 
-	/* Drop a reference taken by wake_oom_reaper */
+	/* Drop a reference taken by queue_oom_reaper */
 	put_task_struct(tsk);
 }
 
@@ -641,12 +641,12 @@ static int oom_reaper(void *unused)
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
@@ -655,22 +655,48 @@ static int oom_reaper(void *unused)
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
@@ -678,7 +704,7 @@ static int __init oom_init(void)
 }
 subsys_initcall(oom_init)
 #else
-static inline void wake_oom_reaper(struct task_struct *tsk)
+static inline void queue_oom_reaper(struct task_struct *tsk)
 {
 }
 #endif /* CONFIG_MMU */
@@ -927,7 +953,7 @@ static void __oom_kill_process(struct ta
 	rcu_read_unlock();
 
 	if (can_oom_reap)
-		wake_oom_reaper(victim);
+		queue_oom_reaper(victim);
 
 	mmdrop(mm);
 	put_task_struct(victim);
@@ -963,7 +989,7 @@ static void oom_kill_process(struct oom_
 	task_lock(victim);
 	if (task_will_free_mem(victim)) {
 		mark_oom_victim(victim);
-		wake_oom_reaper(victim);
+		queue_oom_reaper(victim);
 		task_unlock(victim);
 		put_task_struct(victim);
 		return;
@@ -1061,7 +1087,7 @@ bool out_of_memory(struct oom_control *o
 	 */
 	if (task_will_free_mem(current)) {
 		mark_oom_victim(current);
-		wake_oom_reaper(current);
+		queue_oom_reaper(current);
 		return true;
 	}
 


