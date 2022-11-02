Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2DA61583D
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:47:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230398AbiKBCrs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:47:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230434AbiKBCrr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:47:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F36821818
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:47:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C3269601C6
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:47:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 082C8C433D6;
        Wed,  2 Nov 2022 02:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357265;
        bh=HSBicCw+85MbQH16+nzlmuM4aLOUBglXtCI625D+gNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jtS0C/IProdiqdkeAMZL07J5+wE9i8Z75r0guPJFzrhaCa1QMQ8ZdaXopi0KKiPkb
         FtgNBh/b+woiW4aMA9sAeBMJdZOd1aKiHsvGVSD0JvRz8DpowzbG3D+ilN+3INE4dv
         +pP48jQQxHwt29bE1QtSn9kw+5gg8uwIR/DzpG3k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dmitry Vyukov <dvyukov@google.com>,
        Marco Elver <elver@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 140/240] perf: Fix missing SIGTRAPs
Date:   Wed,  2 Nov 2022 03:31:55 +0100
Message-Id: <20221102022114.543705309@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit ca6c21327c6af02b7eec31ce4b9a740a18c6c13f ]

Marco reported:

Due to the implementation of how SIGTRAP are delivered if
perf_event_attr::sigtrap is set, we've noticed 3 issues:

  1. Missing SIGTRAP due to a race with event_sched_out() (more
     details below).

  2. Hardware PMU events being disabled due to returning 1 from
     perf_event_overflow(). The only way to re-enable the event is
     for user space to first "properly" disable the event and then
     re-enable it.

  3. The inability to automatically disable an event after a
     specified number of overflows via PERF_EVENT_IOC_REFRESH.

The worst of the 3 issues is problem (1), which occurs when a
pending_disable is "consumed" by a racing event_sched_out(), observed
as follows:

		CPU0			|	CPU1
	--------------------------------+---------------------------
	__perf_event_overflow()		|
	 perf_event_disable_inatomic()	|
	  pending_disable = CPU0	| ...
					| _perf_event_enable()
					|  event_function_call()
					|   task_function_call()
					|    /* sends IPI to CPU0 */
	<IPI>				| ...
	 __perf_event_enable()		+---------------------------
	  ctx_resched()
	   task_ctx_sched_out()
	    ctx_sched_out()
	     group_sched_out()
	      event_sched_out()
	       pending_disable = -1
	</IPI>
	<IRQ-work>
	 perf_pending_event()
	  perf_pending_event_disable()
	   /* Fails to send SIGTRAP because no pending_disable! */
	</IRQ-work>

In the above case, not only is that particular SIGTRAP missed, but also
all future SIGTRAPs because 'event_limit' is not reset back to 1.

To fix, rework pending delivery of SIGTRAP via IRQ-work by introduction
of a separate 'pending_sigtrap', no longer using 'event_limit' and
'pending_disable' for its delivery.

Additionally; and different to Marco's proposed patch:

 - recognise that pending_disable effectively duplicates oncpu for
   the case where it is set. As such, change the irq_work handler to
   use ->oncpu to target the event and use pending_* as boolean toggles.

 - observe that SIGTRAP targets the ctx->task, so the context switch
   optimization that carries contexts between tasks is invalid. If
   the irq_work were delayed enough to hit after a context switch the
   SIGTRAP would be delivered to the wrong task.

 - observe that if the event gets scheduled out
   (rotation/migration/context-switch/...) the irq-work would be
   insufficient to deliver the SIGTRAP when the event gets scheduled
   back in (the irq-work might still be pending on the old CPU).

   Therefore have event_sched_out() convert the pending sigtrap into a
   task_work which will deliver the signal at return_to_user.

Fixes: 97ba62b27867 ("perf: Add support for SIGTRAP on perf events")
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Debugged-by: Dmitry Vyukov <dvyukov@google.com>
Reported-by: Marco Elver <elver@google.com>
Debugged-by: Marco Elver <elver@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Marco Elver <elver@google.com>
Tested-by: Marco Elver <elver@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/perf_event.h  |  19 ++++-
 kernel/events/core.c        | 151 +++++++++++++++++++++++++++---------
 kernel/events/ring_buffer.c |   2 +-
 3 files changed, 129 insertions(+), 43 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index ee8b9ecdc03b..00df83258447 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -736,11 +736,14 @@ struct perf_event {
 	struct fasync_struct		*fasync;
 
 	/* delayed work for NMIs and such */
-	int				pending_wakeup;
-	int				pending_kill;
-	int				pending_disable;
+	unsigned int			pending_wakeup;
+	unsigned int			pending_kill;
+	unsigned int			pending_disable;
+	unsigned int			pending_sigtrap;
 	unsigned long			pending_addr;	/* SIGTRAP */
-	struct irq_work			pending;
+	struct irq_work			pending_irq;
+	struct callback_head		pending_task;
+	unsigned int			pending_work;
 
 	atomic_t			event_limit;
 
@@ -857,6 +860,14 @@ struct perf_event_context {
 #endif
 	void				*task_ctx_data; /* pmu specific data */
 	struct rcu_head			rcu_head;
+
+	/*
+	 * Sum (event->pending_sigtrap + event->pending_work)
+	 *
+	 * The SIGTRAP is targeted at ctx->task, as such it won't do changing
+	 * that until the signal is delivered.
+	 */
+	local_t				nr_pending;
 };
 
 /*
diff --git a/kernel/events/core.c b/kernel/events/core.c
index ff4bffc502c6..072ab26269c0 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -54,6 +54,7 @@
 #include <linux/highmem.h>
 #include <linux/pgtable.h>
 #include <linux/buildid.h>
+#include <linux/task_work.h>
 
 #include "internal.h"
 
@@ -2268,11 +2269,26 @@ event_sched_out(struct perf_event *event,
 	event->pmu->del(event, 0);
 	event->oncpu = -1;
 
-	if (READ_ONCE(event->pending_disable) >= 0) {
-		WRITE_ONCE(event->pending_disable, -1);
+	if (event->pending_disable) {
+		event->pending_disable = 0;
 		perf_cgroup_event_disable(event, ctx);
 		state = PERF_EVENT_STATE_OFF;
 	}
+
+	if (event->pending_sigtrap) {
+		bool dec = true;
+
+		event->pending_sigtrap = 0;
+		if (state != PERF_EVENT_STATE_OFF &&
+		    !event->pending_work) {
+			event->pending_work = 1;
+			dec = false;
+			task_work_add(current, &event->pending_task, TWA_RESUME);
+		}
+		if (dec)
+			local_dec(&event->ctx->nr_pending);
+	}
+
 	perf_event_set_state(event, state);
 
 	if (!is_software_event(event))
@@ -2424,7 +2440,7 @@ static void __perf_event_disable(struct perf_event *event,
  * hold the top-level event's child_mutex, so any descendant that
  * goes to exit will block in perf_event_exit_event().
  *
- * When called from perf_pending_event it's OK because event->ctx
+ * When called from perf_pending_irq it's OK because event->ctx
  * is the current context on this CPU and preemption is disabled,
  * hence we can't get into perf_event_task_sched_out for this context.
  */
@@ -2463,9 +2479,8 @@ EXPORT_SYMBOL_GPL(perf_event_disable);
 
 void perf_event_disable_inatomic(struct perf_event *event)
 {
-	WRITE_ONCE(event->pending_disable, smp_processor_id());
-	/* can fail, see perf_pending_event_disable() */
-	irq_work_queue(&event->pending);
+	event->pending_disable = 1;
+	irq_work_queue(&event->pending_irq);
 }
 
 #define MAX_INTERRUPTS (~0ULL)
@@ -3420,11 +3435,23 @@ static void perf_event_context_sched_out(struct task_struct *task, int ctxn,
 		raw_spin_lock_nested(&next_ctx->lock, SINGLE_DEPTH_NESTING);
 		if (context_equiv(ctx, next_ctx)) {
 
+			perf_pmu_disable(pmu);
+
+			/* PMIs are disabled; ctx->nr_pending is stable. */
+			if (local_read(&ctx->nr_pending) ||
+			    local_read(&next_ctx->nr_pending)) {
+				/*
+				 * Must not swap out ctx when there's pending
+				 * events that rely on the ctx->task relation.
+				 */
+				raw_spin_unlock(&next_ctx->lock);
+				rcu_read_unlock();
+				goto inside_switch;
+			}
+
 			WRITE_ONCE(ctx->task, next);
 			WRITE_ONCE(next_ctx->task, task);
 
-			perf_pmu_disable(pmu);
-
 			if (cpuctx->sched_cb_usage && pmu->sched_task)
 				pmu->sched_task(ctx, false);
 
@@ -3465,6 +3492,7 @@ static void perf_event_context_sched_out(struct task_struct *task, int ctxn,
 		raw_spin_lock(&ctx->lock);
 		perf_pmu_disable(pmu);
 
+inside_switch:
 		if (cpuctx->sched_cb_usage && pmu->sched_task)
 			pmu->sched_task(ctx, false);
 		task_ctx_sched_out(cpuctx, ctx, EVENT_ALL);
@@ -4931,7 +4959,7 @@ static void perf_addr_filters_splice(struct perf_event *event,
 
 static void _free_event(struct perf_event *event)
 {
-	irq_work_sync(&event->pending);
+	irq_work_sync(&event->pending_irq);
 
 	unaccount_event(event);
 
@@ -6431,7 +6459,8 @@ static void perf_sigtrap(struct perf_event *event)
 		return;
 
 	/*
-	 * perf_pending_event() can race with the task exiting.
+	 * Both perf_pending_task() and perf_pending_irq() can race with the
+	 * task exiting.
 	 */
 	if (current->flags & PF_EXITING)
 		return;
@@ -6440,23 +6469,33 @@ static void perf_sigtrap(struct perf_event *event)
 		      event->attr.type, event->attr.sig_data);
 }
 
-static void perf_pending_event_disable(struct perf_event *event)
+/*
+ * Deliver the pending work in-event-context or follow the context.
+ */
+static void __perf_pending_irq(struct perf_event *event)
 {
-	int cpu = READ_ONCE(event->pending_disable);
+	int cpu = READ_ONCE(event->oncpu);
 
+	/*
+	 * If the event isn't running; we done. event_sched_out() will have
+	 * taken care of things.
+	 */
 	if (cpu < 0)
 		return;
 
+	/*
+	 * Yay, we hit home and are in the context of the event.
+	 */
 	if (cpu == smp_processor_id()) {
-		WRITE_ONCE(event->pending_disable, -1);
-
-		if (event->attr.sigtrap) {
+		if (event->pending_sigtrap) {
+			event->pending_sigtrap = 0;
 			perf_sigtrap(event);
-			atomic_set_release(&event->event_limit, 1); /* rearm event */
-			return;
+			local_dec(&event->ctx->nr_pending);
+		}
+		if (event->pending_disable) {
+			event->pending_disable = 0;
+			perf_event_disable_local(event);
 		}
-
-		perf_event_disable_local(event);
 		return;
 	}
 
@@ -6476,35 +6515,62 @@ static void perf_pending_event_disable(struct perf_event *event)
 	 *				  irq_work_queue(); // FAILS
 	 *
 	 *  irq_work_run()
-	 *    perf_pending_event()
+	 *    perf_pending_irq()
 	 *
 	 * But the event runs on CPU-B and wants disabling there.
 	 */
-	irq_work_queue_on(&event->pending, cpu);
+	irq_work_queue_on(&event->pending_irq, cpu);
 }
 
-static void perf_pending_event(struct irq_work *entry)
+static void perf_pending_irq(struct irq_work *entry)
 {
-	struct perf_event *event = container_of(entry, struct perf_event, pending);
+	struct perf_event *event = container_of(entry, struct perf_event, pending_irq);
 	int rctx;
 
-	rctx = perf_swevent_get_recursion_context();
 	/*
 	 * If we 'fail' here, that's OK, it means recursion is already disabled
 	 * and we won't recurse 'further'.
 	 */
+	rctx = perf_swevent_get_recursion_context();
 
-	perf_pending_event_disable(event);
-
+	/*
+	 * The wakeup isn't bound to the context of the event -- it can happen
+	 * irrespective of where the event is.
+	 */
 	if (event->pending_wakeup) {
 		event->pending_wakeup = 0;
 		perf_event_wakeup(event);
 	}
 
+	__perf_pending_irq(event);
+
 	if (rctx >= 0)
 		perf_swevent_put_recursion_context(rctx);
 }
 
+static void perf_pending_task(struct callback_head *head)
+{
+	struct perf_event *event = container_of(head, struct perf_event, pending_task);
+	int rctx;
+
+	/*
+	 * If we 'fail' here, that's OK, it means recursion is already disabled
+	 * and we won't recurse 'further'.
+	 */
+	preempt_disable_notrace();
+	rctx = perf_swevent_get_recursion_context();
+
+	if (event->pending_work) {
+		event->pending_work = 0;
+		perf_sigtrap(event);
+		local_dec(&event->ctx->nr_pending);
+	}
+
+	if (rctx >= 0)
+		perf_swevent_put_recursion_context(rctx);
+	preempt_enable_notrace();
+}
+
 #ifdef CONFIG_GUEST_PERF_EVENTS
 struct perf_guest_info_callbacks __rcu *perf_guest_cbs;
 
@@ -9188,8 +9254,8 @@ int perf_event_account_interrupt(struct perf_event *event)
  */
 
 static int __perf_event_overflow(struct perf_event *event,
-				   int throttle, struct perf_sample_data *data,
-				   struct pt_regs *regs)
+				 int throttle, struct perf_sample_data *data,
+				 struct pt_regs *regs)
 {
 	int events = atomic_read(&event->event_limit);
 	int ret = 0;
@@ -9212,24 +9278,36 @@ static int __perf_event_overflow(struct perf_event *event,
 	if (events && atomic_dec_and_test(&event->event_limit)) {
 		ret = 1;
 		event->pending_kill = POLL_HUP;
-		event->pending_addr = data->addr;
-
 		perf_event_disable_inatomic(event);
 	}
 
+	if (event->attr.sigtrap) {
+		/*
+		 * Should not be able to return to user space without processing
+		 * pending_sigtrap (kernel events can overflow multiple times).
+		 */
+		WARN_ON_ONCE(event->pending_sigtrap && event->attr.exclude_kernel);
+		if (!event->pending_sigtrap) {
+			event->pending_sigtrap = 1;
+			local_inc(&event->ctx->nr_pending);
+		}
+		event->pending_addr = data->addr;
+		irq_work_queue(&event->pending_irq);
+	}
+
 	READ_ONCE(event->overflow_handler)(event, data, regs);
 
 	if (*perf_event_fasync(event) && event->pending_kill) {
 		event->pending_wakeup = 1;
-		irq_work_queue(&event->pending);
+		irq_work_queue(&event->pending_irq);
 	}
 
 	return ret;
 }
 
 int perf_event_overflow(struct perf_event *event,
-			  struct perf_sample_data *data,
-			  struct pt_regs *regs)
+			struct perf_sample_data *data,
+			struct pt_regs *regs)
 {
 	return __perf_event_overflow(event, 1, data, regs);
 }
@@ -11537,8 +11615,8 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 
 
 	init_waitqueue_head(&event->waitq);
-	event->pending_disable = -1;
-	init_irq_work(&event->pending, perf_pending_event);
+	init_irq_work(&event->pending_irq, perf_pending_irq);
+	init_task_work(&event->pending_task, perf_pending_task);
 
 	mutex_init(&event->mmap_mutex);
 	raw_spin_lock_init(&event->addr_filters.lock);
@@ -11560,9 +11638,6 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 	if (parent_event)
 		event->event_caps = parent_event->event_caps;
 
-	if (event->attr.sigtrap)
-		atomic_set(&event->event_limit, 1);
-
 	if (task) {
 		event->attach_state = PERF_ATTACH_TASK;
 		/*
diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index 726132039c38..273a0fe7910a 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -22,7 +22,7 @@ static void perf_output_wakeup(struct perf_output_handle *handle)
 	atomic_set(&handle->rb->poll, EPOLLIN);
 
 	handle->event->pending_wakeup = 1;
-	irq_work_queue(&handle->event->pending);
+	irq_work_queue(&handle->event->pending_irq);
 }
 
 /*
-- 
2.35.1



