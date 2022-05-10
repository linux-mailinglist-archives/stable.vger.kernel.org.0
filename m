Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5A15521813
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237431AbiEJNdI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:33:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243562AbiEJNbY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:31:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56E9F2CC13C;
        Tue, 10 May 2022 06:21:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 85F4661764;
        Tue, 10 May 2022 13:21:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FB79C385C6;
        Tue, 10 May 2022 13:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652188911;
        bh=r0qu1SHTTBix2UxhC42n8aLxidZuhHFHggYUCqVygQo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WSaTGmyVoLlIzgD20DKvp80dv7LTUJlThF7LIeZ3zranhcwn6EyMfLFa4zmI32M0C
         6lSCIsI8odzOoxjPD1kBszdQ4HM3Eyo484V1mXGhXww2RDq9xOtjEevwN0xu0Z+XIQ
         94BiPPAKZTZvdadR52S97apq98cluUKikluae014=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Pfaff <tpfaff@pcs.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 4.19 66/88] genirq: Synchronize interrupt thread startup
Date:   Tue, 10 May 2022 15:07:51 +0200
Message-Id: <20220510130735.655568199@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130733.735278074@linuxfoundation.org>
References: <20220510130733.735278074@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Pfaff <tpfaff@pcs.com>

commit 8707898e22fd665bc1d7b18b809be4b56ce25bdd upstream.

A kernel hang can be observed when running setserial in a loop on a kernel
with force threaded interrupts. The sequence of events is:

   setserial
     open("/dev/ttyXXX")
       request_irq()
     do_stuff()
      -> serial interrupt
         -> wake(irq_thread)
	      desc->threads_active++;
     close()
       free_irq()
         kthread_stop(irq_thread)
     synchronize_irq() <- hangs because desc->threads_active != 0

The thread is created in request_irq() and woken up, but does not get on a
CPU to reach the actual thread function, which would handle the pending
wake-up. kthread_stop() sets the should stop condition which makes the
thread immediately exit, which in turn leaves the stale threads_active
count around.

This problem was introduced with commit 519cc8652b3a, which addressed a
interrupt sharing issue in the PCIe code.

Before that commit free_irq() invoked synchronize_irq(), which waits for
the hard interrupt handler and also for associated threads to complete.

To address the PCIe issue synchronize_irq() was replaced with
__synchronize_hardirq(), which only waits for the hard interrupt handler to
complete, but not for threaded handlers.

This was done under the assumption, that the interrupt thread already
reached the thread function and waits for a wake-up, which is guaranteed to
be handled before acting on the stop condition. The problematic case, that
the thread would not reach the thread function, was obviously overlooked.

Make sure that the interrupt thread is really started and reaches
thread_fn() before returning from __setup_irq().

This utilizes the existing wait queue in the interrupt descriptor. The
wait queue is unused for non-shared interrupts. For shared interrupts the
usage might cause a spurious wake-up of a waiter in synchronize_irq() or the
completion of a threaded handler might cause a spurious wake-up of the
waiter for the ready flag. Both are harmless and have no functional impact.

[ tglx: Amended changelog ]

Fixes: 519cc8652b3a ("genirq: Synchronize only with single thread on free_irq()")
Signed-off-by: Thomas Pfaff <tpfaff@pcs.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/552fe7b4-9224-b183-bb87-a8f36d335690@pcs.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/irq/internals.h |    2 ++
 kernel/irq/irqdesc.c   |    2 ++
 kernel/irq/manage.c    |   39 +++++++++++++++++++++++++++++----------
 3 files changed, 33 insertions(+), 10 deletions(-)

--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -29,12 +29,14 @@ extern struct irqaction chained_action;
  * IRQTF_WARNED    - warning "IRQ_WAKE_THREAD w/o thread_fn" has been printed
  * IRQTF_AFFINITY  - irq thread is requested to adjust affinity
  * IRQTF_FORCED_THREAD  - irq action is force threaded
+ * IRQTF_READY     - signals that irq thread is ready
  */
 enum {
 	IRQTF_RUNTHREAD,
 	IRQTF_WARNED,
 	IRQTF_AFFINITY,
 	IRQTF_FORCED_THREAD,
+	IRQTF_READY,
 };
 
 /*
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -404,6 +404,7 @@ static struct irq_desc *alloc_desc(int i
 	lockdep_set_class(&desc->lock, &irq_desc_lock_class);
 	mutex_init(&desc->request_mutex);
 	init_rcu_head(&desc->rcu);
+	init_waitqueue_head(&desc->wait_for_threads);
 
 	desc_set_defaults(irq, desc, node, affinity, owner);
 	irqd_set(&desc->irq_data, flags);
@@ -568,6 +569,7 @@ int __init early_irq_init(void)
 		raw_spin_lock_init(&desc[i].lock);
 		lockdep_set_class(&desc[i].lock, &irq_desc_lock_class);
 		mutex_init(&desc[i].request_mutex);
+		init_waitqueue_head(&desc[i].wait_for_threads);
 		desc_set_defaults(i, &desc[i], node, NULL, NULL);
 	}
 	return arch_early_irq_init();
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1064,6 +1064,31 @@ static void irq_wake_secondary(struct ir
 }
 
 /*
+ * Internal function to notify that a interrupt thread is ready.
+ */
+static void irq_thread_set_ready(struct irq_desc *desc,
+				 struct irqaction *action)
+{
+	set_bit(IRQTF_READY, &action->thread_flags);
+	wake_up(&desc->wait_for_threads);
+}
+
+/*
+ * Internal function to wake up a interrupt thread and wait until it is
+ * ready.
+ */
+static void wake_up_and_wait_for_irq_thread_ready(struct irq_desc *desc,
+						  struct irqaction *action)
+{
+	if (!action || !action->thread)
+		return;
+
+	wake_up_process(action->thread);
+	wait_event(desc->wait_for_threads,
+		   test_bit(IRQTF_READY, &action->thread_flags));
+}
+
+/*
  * Interrupt handler thread
  */
 static int irq_thread(void *data)
@@ -1074,6 +1099,8 @@ static int irq_thread(void *data)
 	irqreturn_t (*handler_fn)(struct irq_desc *desc,
 			struct irqaction *action);
 
+	irq_thread_set_ready(desc, action);
+
 	if (force_irqthreads && test_bit(IRQTF_FORCED_THREAD,
 					&action->thread_flags))
 		handler_fn = irq_forced_thread_fn;
@@ -1462,8 +1489,6 @@ __setup_irq(unsigned int irq, struct irq
 	}
 
 	if (!shared) {
-		init_waitqueue_head(&desc->wait_for_threads);
-
 		/* Setup the type (level, edge polarity) if configured: */
 		if (new->flags & IRQF_TRIGGER_MASK) {
 			ret = __irq_set_trigger(desc,
@@ -1553,14 +1578,8 @@ __setup_irq(unsigned int irq, struct irq
 
 	irq_setup_timings(desc, new);
 
-	/*
-	 * Strictly no need to wake it up, but hung_task complains
-	 * when no hard interrupt wakes the thread up.
-	 */
-	if (new->thread)
-		wake_up_process(new->thread);
-	if (new->secondary)
-		wake_up_process(new->secondary->thread);
+	wake_up_and_wait_for_irq_thread_ready(desc, new);
+	wake_up_and_wait_for_irq_thread_ready(desc, new->secondary);
 
 	register_irq_proc(irq, desc);
 	new->dir = NULL;


