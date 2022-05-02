Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF04517749
	for <lists+stable@lfdr.de>; Mon,  2 May 2022 21:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231523AbiEBTYk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 May 2022 15:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbiEBTYj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 May 2022 15:24:39 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB70AF7C;
        Mon,  2 May 2022 12:21:08 -0700 (PDT)
Date:   Mon, 02 May 2022 19:21:04 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1651519266;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GZ2mroGP6Bg+3i/bOO1qNgtfZ8g35cOMZd4acdEbKlY=;
        b=MqKeKhSGVM0sQy54jzkeq0SU21POJtvATnScHoDeqxtJ1w49hIFFy81MuEEbY7+5TcUPcD
        uZcRakoovGxBGG43FUqvX04/pTRJn21nBqrsai1girFV2xPCSv3QJTjRQ8LkaEQXv7HUDu
        ojwJRsr2x07Qk4WsTSIM/VN4Mu6JEkOfUKx5BhFQ5+NtkUTYmw0G8dy3yiI/p0k3yuKDfN
        t4ppdNXYZufjpcsKq2sco0OeZ/vM6v1ag3pVSn6KWJYbsqkIR/UEqcN8WDlG48UKcVBgCJ
        pG2LvywQdfwOYleOw65hf1o699D+h2t6FrjOMdmgy/XqasrUMFX3yNqrxe1jWg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1651519266;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GZ2mroGP6Bg+3i/bOO1qNgtfZ8g35cOMZd4acdEbKlY=;
        b=VC1sCOAUnMg9dNVCmZyOtr/pMNDttgDf399eRU6lOT+ElHPTqIpQkNuo1NMy3GpwZIp7Or
        mP/VqdLzZkuHAMAg==
From:   "tip-bot2 for Thomas Pfaff" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: irq/urgent] genirq: Synchronize interrupt thread startup
Cc:     Thomas Pfaff <tpfaff@pcs.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <552fe7b4-9224-b183-bb87-a8f36d335690@pcs.com>
References: <552fe7b4-9224-b183-bb87-a8f36d335690@pcs.com>
MIME-Version: 1.0
Message-ID: <165151926436.4207.197248127226253903.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the irq/urgent branch of tip:

Commit-ID:     9b83d81acad9d29234b336dc57c84d87a617d358
Gitweb:        https://git.kernel.org/tip/9b83d81acad9d29234b336dc57c84d87a617d358
Author:        Thomas Pfaff <tpfaff@pcs.com>
AuthorDate:    Mon, 02 May 2022 13:28:29 +02:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Mon, 02 May 2022 21:17:55 +02:00

genirq: Synchronize interrupt thread startup

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
---
 kernel/irq/internals.h |  2 ++
 kernel/irq/irqdesc.c   |  2 ++
 kernel/irq/manage.c    | 39 +++++++++++++++++++++++++++++----------
 3 files changed, 33 insertions(+), 10 deletions(-)

diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index 99cbdf5..f09c603 100644
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
diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index 939d21c..02f3b5b 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -407,6 +407,7 @@ static struct irq_desc *alloc_desc(int irq, int node, unsigned int flags,
 	lockdep_set_class(&desc->lock, &irq_desc_lock_class);
 	mutex_init(&desc->request_mutex);
 	init_rcu_head(&desc->rcu);
+	init_waitqueue_head(&desc->wait_for_threads);
 
 	desc_set_defaults(irq, desc, node, affinity, owner);
 	irqd_set(&desc->irq_data, flags);
@@ -575,6 +576,7 @@ int __init early_irq_init(void)
 		raw_spin_lock_init(&desc[i].lock);
 		lockdep_set_class(&desc[i].lock, &irq_desc_lock_class);
 		mutex_init(&desc[i].request_mutex);
+		init_waitqueue_head(&desc->wait_for_threads);
 		desc_set_defaults(i, &desc[i], node, NULL, NULL);
 	}
 	return arch_early_irq_init();
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index c03f71d..e3e245a 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1249,6 +1249,31 @@ static void irq_wake_secondary(struct irq_desc *desc, struct irqaction *action)
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
@@ -1259,6 +1284,8 @@ static int irq_thread(void *data)
 	irqreturn_t (*handler_fn)(struct irq_desc *desc,
 			struct irqaction *action);
 
+	irq_thread_set_ready(desc, action);
+
 	sched_set_fifo(current);
 
 	if (force_irqthreads() && test_bit(IRQTF_FORCED_THREAD,
@@ -1683,8 +1710,6 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 	}
 
 	if (!shared) {
-		init_waitqueue_head(&desc->wait_for_threads);
-
 		/* Setup the type (level, edge polarity) if configured: */
 		if (new->flags & IRQF_TRIGGER_MASK) {
 			ret = __irq_set_trigger(desc,
@@ -1780,14 +1805,8 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 
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
