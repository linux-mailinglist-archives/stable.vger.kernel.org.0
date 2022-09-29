Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F38775EFF09
	for <lists+stable@lfdr.de>; Thu, 29 Sep 2022 23:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbiI2VIB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Sep 2022 17:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbiI2VH7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Sep 2022 17:07:59 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 549F01B95C4;
        Thu, 29 Sep 2022 14:07:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1664485679; x=1696021679;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+xWwBanwVShjsaHkvZuwGS01as3TXVaEah4Q/Xkq/s4=;
  b=EgHSp669o8ooWwtm5x0dFWSGMAV8a3uryrp5QssVwY0zctLJVIDfuUcL
   eXPSV1ddl6rhHgIRMJ5zYYsSLp5w+dhhstVX4Kbh/eK7XTsCoWnUvpEMh
   J6mgo2pdzYrN5o6MAsjvtaEYQyCXV0jBrRQ67Qmji92OCRT/o2fPoAbn7
   U=;
X-IronPort-AV: E=Sophos;i="5.93,356,1654560000"; 
   d="scan'208";a="135465336"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-b09d0114.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2022 21:07:58 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-b09d0114.us-east-1.amazon.com (Postfix) with ESMTPS id 1BEE981462;
        Thu, 29 Sep 2022 21:07:54 +0000 (UTC)
Received: from EX19D002UWC004.ant.amazon.com (10.13.138.186) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Thu, 29 Sep 2022 21:07:54 +0000
Received: from EX13MTAUEE002.ant.amazon.com (10.43.62.24) by
 EX19D002UWC004.ant.amazon.com (10.13.138.186) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Thu, 29 Sep 2022 21:07:54 +0000
Received: from dev-dsk-risbhat-2b-8bdc64cd.us-west-2.amazon.com
 (10.189.73.169) by mail-relay.amazon.com (10.43.62.224) with Microsoft SMTP
 Server id 15.0.1497.38 via Frontend Transport; Thu, 29 Sep 2022 21:07:53
 +0000
Received: by dev-dsk-risbhat-2b-8bdc64cd.us-west-2.amazon.com (Postfix, from userid 22673075)
        id 26ED3286E; Thu, 29 Sep 2022 21:07:52 +0000 (UTC)
From:   Rishabh Bhatnagar <risbhat@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <gregkh@linuxfoundation.org>, <sashal@kernel.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>,
        <linux-kernel@vger.kernel.org>, <benh@amazon.com>,
        <mbacco@amazon.com>, Robert Hodaszi <Robert.Hodaszi@digi.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Rishabh Bhatnagar <risbhat@amazon.com>
Subject: [PATCH 5/6] genirq: Add optional hardware synchronization for shutdown
Date:   Thu, 29 Sep 2022 21:06:50 +0000
Message-ID: <20220929210651.12308-6-risbhat@amazon.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220929210651.12308-1-risbhat@amazon.com>
References: <20220929210651.12308-1-risbhat@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-12.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
Signed-off-by: Rishabh Bhatnagar <risbhat@amazon.com>
---
 kernel/irq/internals.h |  4 ++++
 kernel/irq/manage.c    | 53 +++++++++++++++++++++++++++---------------
 2 files changed, 38 insertions(+), 19 deletions(-)

diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index 3de3821ab5fe..a3d7150bb295 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -93,6 +93,10 @@ static inline void irq_mark_irq(unsigned int irq) { }
 extern void irq_mark_irq(unsigned int irq);
 #endif
 
+extern int __irq_get_irqchip_state(struct irq_data *data,
+				   enum irqchip_irq_state which,
+				   bool *state);
+
 extern void init_kstat_irqs(struct irq_desc *desc, int node, int nr);
 
 irqreturn_t __handle_irq_event_percpu(struct irq_desc *desc, unsigned int *flags);
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index a72d7ae0418b..fb3ea75cc0fb 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -35,8 +35,9 @@ static int __init setup_forced_irqthreads(char *arg)
 early_param("threadirqs", setup_forced_irqthreads);
 #endif
 
-static void __synchronize_hardirq(struct irq_desc *desc)
+static void __synchronize_hardirq(struct irq_desc *desc, bool sync_chip)
 {
+	struct irq_data *irqd = irq_desc_get_irq_data(desc);
 	bool inprogress;
 
 	do {
@@ -52,6 +53,20 @@ static void __synchronize_hardirq(struct irq_desc *desc)
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
@@ -74,13 +89,18 @@ static void __synchronize_hardirq(struct irq_desc *desc)
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
@@ -1635,8 +1659,12 @@ static struct irqaction *__free_irq(unsigned int irq, void *dev_id)
 
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
@@ -2187,7 +2215,6 @@ int irq_get_irqchip_state(unsigned int irq, enum irqchip_irq_state which,
 {
 	struct irq_desc *desc;
 	struct irq_data *data;
-	struct irq_chip *chip;
 	unsigned long flags;
 	int err = -EINVAL;
 
@@ -2197,19 +2224,7 @@ int irq_get_irqchip_state(unsigned int irq, enum irqchip_irq_state which,
 
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
-- 
2.37.1

