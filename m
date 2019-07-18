Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53D486C778
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389664AbfGRDGI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:06:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:37330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390150AbfGRDGI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:06:08 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E018721848;
        Thu, 18 Jul 2019 03:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419167;
        bh=Igj2EOFhPfwMXj8eeSjGUv4S8Vd09xwlYelW+XL9zxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RRHtnnO3yHn6uBR5OhIekNFIfBGzD6fKd+qpq1Ui/oAJWzs3qlS9JD1R/xziBkWvV
         PrCfd0Y+YEpzZNiy3XoZx6mbXDePnFSfGRa5lenCEhKIvcEoFrTA/vqO9BBWjUgk6J
         e+NXN7QSudi5OsZhB1WlDTUkJr109yIErTPqePHk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Hodaszi <Robert.Hodaszi@digi.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 5.1 43/54] genirq: Add optional hardware synchronization for shutdown
Date:   Thu, 18 Jul 2019 12:01:38 +0900
Message-Id: <20190718030056.475777242@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030053.287374640@linuxfoundation.org>
References: <20190718030053.287374640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 62e0468650c30f0298822c580f382b16328119f6 upstream.

free_irq() ensures that no hardware interrupt handler is executing on a
different CPU before actually releasing resources and deactivating the
interrupt completely in a domain hierarchy.

But that does not catch the case where the interrupt is on flight at the
hardware level but not yet serviced by the target CPU. That creates an
interesing race condition:

   CPU 0                  CPU 1               IRQ CHIP

                                              interrupt is raised
                                              sent to CPU1
			  Unable to handle
			  immediately
			  (interrupts off,
			   deep idle delay)
   mask()
   ...
   free()
     shutdown()
     synchronize_irq()
     release_resources()
                          do_IRQ()
                            -> resources are not available

That might be harmless and just trigger a spurious interrupt warning, but
some interrupt chips might get into a wedged state.

Utilize the existing irq_get_irqchip_state() callback for the
synchronization in free_irq().

synchronize_hardirq() is not using this mechanism as it might actually
deadlock unter certain conditions, e.g. when called with interrupts
disabled and the target CPU is the one on which the synchronization is
invoked. synchronize_irq() uses it because that function cannot be called
from non preemtible contexts as it might sleep.

No functional change intended and according to Marc the existing GIC
implementations where the driver supports the callback should be able
to cope with that core change. Famous last words.

Fixes: 464d12309e1b ("x86/vector: Switch IOAPIC to global reservation mode")
Reported-by: Robert Hodaszi <Robert.Hodaszi@digi.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Tested-by: Marc Zyngier <marc.zyngier@arm.com>
Link: https://lkml.kernel.org/r/20190628111440.279463375@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/irq/internals.h |    4 ++
 kernel/irq/manage.c    |   75 ++++++++++++++++++++++++++++++++++++-------------
 2 files changed, 60 insertions(+), 19 deletions(-)

--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -97,6 +97,10 @@ static inline void irq_mark_irq(unsigned
 extern void irq_mark_irq(unsigned int irq);
 #endif
 
+extern int __irq_get_irqchip_state(struct irq_data *data,
+				   enum irqchip_irq_state which,
+				   bool *state);
+
 extern void init_kstat_irqs(struct irq_desc *desc, int node, int nr);
 
 irqreturn_t __handle_irq_event_percpu(struct irq_desc *desc, unsigned int *flags);
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -35,8 +35,9 @@ static int __init setup_forced_irqthread
 early_param("threadirqs", setup_forced_irqthreads);
 #endif
 
-static void __synchronize_hardirq(struct irq_desc *desc)
+static void __synchronize_hardirq(struct irq_desc *desc, bool sync_chip)
 {
+	struct irq_data *irqd = irq_desc_get_irq_data(desc);
 	bool inprogress;
 
 	do {
@@ -52,6 +53,20 @@ static void __synchronize_hardirq(struct
 		/* Ok, that indicated we're done: double-check carefully. */
 		raw_spin_lock_irqsave(&desc->lock, flags);
 		inprogress = irqd_irq_inprogress(&desc->irq_data);
+
+		/*
+		 * If requested and supported, check at the chip whether it
+		 * is in flight at the hardware level, i.e. already pending
+		 * in a CPU and waiting for service and acknowledge.
+		 */
+		if (!inprogress && sync_chip) {
+			/*
+			 * Ignore the return code. inprogress is only updated
+			 * when the chip supports it.
+			 */
+			__irq_get_irqchip_state(irqd, IRQCHIP_STATE_ACTIVE,
+						&inprogress);
+		}
 		raw_spin_unlock_irqrestore(&desc->lock, flags);
 
 		/* Oops, that failed? */
@@ -74,13 +89,18 @@ static void __synchronize_hardirq(struct
  *	Returns: false if a threaded handler is active.
  *
  *	This function may be called - with care - from IRQ context.
+ *
+ *	It does not check whether there is an interrupt in flight at the
+ *	hardware level, but not serviced yet, as this might deadlock when
+ *	called with interrupts disabled and the target CPU of the interrupt
+ *	is the current CPU.
  */
 bool synchronize_hardirq(unsigned int irq)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 
 	if (desc) {
-		__synchronize_hardirq(desc);
+		__synchronize_hardirq(desc, false);
 		return !atomic_read(&desc->threads_active);
 	}
 
@@ -98,13 +118,17 @@ EXPORT_SYMBOL(synchronize_hardirq);
  *
  *	Can only be called from preemptible code as it might sleep when
  *	an interrupt thread is associated to @irq.
+ *
+ *	It optionally makes sure (when the irq chip supports that method)
+ *	that the interrupt is not pending in any CPU and waiting for
+ *	service.
  */
 void synchronize_irq(unsigned int irq)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 
 	if (desc) {
-		__synchronize_hardirq(desc);
+		__synchronize_hardirq(desc, true);
 		/*
 		 * We made sure that no hardirq handler is
 		 * running. Now verify that no threaded handlers are
@@ -1730,8 +1754,12 @@ static struct irqaction *__free_irq(stru
 
 	unregister_handler_proc(irq, action);
 
-	/* Make sure it's not being used on another CPU: */
-	synchronize_hardirq(irq);
+	/*
+	 * Make sure it's not being used on another CPU and if the chip
+	 * supports it also make sure that there is no (not yet serviced)
+	 * interrupt in flight at the hardware level.
+	 */
+	__synchronize_hardirq(desc, true);
 
 #ifdef CONFIG_DEBUG_SHIRQ
 	/*
@@ -2589,6 +2617,28 @@ out:
 	irq_put_desc_unlock(desc, flags);
 }
 
+int __irq_get_irqchip_state(struct irq_data *data, enum irqchip_irq_state which,
+			    bool *state)
+{
+	struct irq_chip *chip;
+	int err = -EINVAL;
+
+	do {
+		chip = irq_data_get_irq_chip(data);
+		if (chip->irq_get_irqchip_state)
+			break;
+#ifdef CONFIG_IRQ_DOMAIN_HIERARCHY
+		data = data->parent_data;
+#else
+		data = NULL;
+#endif
+	} while (data);
+
+	if (data)
+		err = chip->irq_get_irqchip_state(data, which, state);
+	return err;
+}
+
 /**
  *	irq_get_irqchip_state - returns the irqchip state of a interrupt.
  *	@irq: Interrupt line that is forwarded to a VM
@@ -2607,7 +2657,6 @@ int irq_get_irqchip_state(unsigned int i
 {
 	struct irq_desc *desc;
 	struct irq_data *data;
-	struct irq_chip *chip;
 	unsigned long flags;
 	int err = -EINVAL;
 
@@ -2617,19 +2666,7 @@ int irq_get_irqchip_state(unsigned int i
 
 	data = irq_desc_get_irq_data(desc);
 
-	do {
-		chip = irq_data_get_irq_chip(data);
-		if (chip->irq_get_irqchip_state)
-			break;
-#ifdef CONFIG_IRQ_DOMAIN_HIERARCHY
-		data = data->parent_data;
-#else
-		data = NULL;
-#endif
-	} while (data);
-
-	if (data)
-		err = chip->irq_get_irqchip_state(data, which, state);
+	err = __irq_get_irqchip_state(data, which, state);
 
 	irq_put_desc_busunlock(desc, flags);
 	return err;


