Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BFED22F084
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732392AbgG0OZP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731498AbgG0OZO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jul 2020 10:25:14 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9041C0619D4;
        Mon, 27 Jul 2020 07:25:13 -0700 (PDT)
Date:   Mon, 27 Jul 2020 14:25:11 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1595859912;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iNHHAvCNnLUuxWvSYqKOaxmpHY2i9DCarZbKtpAKXAE=;
        b=p6auQxlkFo4Nrp/HxTF6KYtTHKtaoKz/f+Ozh/NgzUfS/EBnfDFVGtOaryDFNrpoYTDsB/
        B13OTnp8ixmOnHi9vc+EVIYoecuBQzmFBvsdgUKNIBSyBuSIgFEuUh6YsNq9QoJ9Vd3efu
        Cs4M64quOi797jg9+PNN7XhnV+PcJmIN+RDBjFT1K1tNmxmHhiUTrtAxP0gIQrrsw2KWKI
        O6JkLIzSI0LVKmzuihtGyg5skU0CqNXOV0Nn+Sn89J5B19tMy3EozwM9NNZ+Vn2AmvhZjr
        /iJPkxscl8uRPRwbZPuRdguvT2KyCxic9zGc6wSoWupE1wasJexKUe8+LS8gDw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1595859912;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iNHHAvCNnLUuxWvSYqKOaxmpHY2i9DCarZbKtpAKXAE=;
        b=CdPHNua/1YtOaZp7f2T04HRI8qV8kmOPQmpmiZUtqAFHywYpxlYzPzDGFE+8oDSUo+NsVN
        Xc+3Iz719kN0RtBw==
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: irq/urgent] genirq/affinity: Make affinity setting if activated opt-in
Cc:     John Keeping <john@metanate.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>, stable@vger.kernel.org,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <87blk4tzgm.fsf@nanos.tec.linutronix.de>
References: <87blk4tzgm.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Message-ID: <159585991142.4006.928637752238313572.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the irq/urgent branch of tip:

Commit-ID:     f0c7baca180046824e07fc5f1326e83a8fd150c7
Gitweb:        https://git.kernel.org/tip/f0c7baca180046824e07fc5f1326e83a8fd150c7
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Fri, 24 Jul 2020 22:44:41 +02:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Mon, 27 Jul 2020 16:20:40 +02:00

genirq/affinity: Make affinity setting if activated opt-in

John reported that on a RK3288 system the perf per CPU interrupts are all
affine to CPU0 and provided the analysis:

 "It looks like what happens is that because the interrupts are not per-CPU
  in the hardware, armpmu_request_irq() calls irq_force_affinity() while
  the interrupt is deactivated and then request_irq() with IRQF_PERCPU |
  IRQF_NOBALANCING.  

  Now when irq_startup() runs with IRQ_STARTUP_NORMAL, it calls
  irq_setup_affinity() which returns early because IRQF_PERCPU and
  IRQF_NOBALANCING are set, leaving the interrupt on its original CPU."

This was broken by the recent commit which blocked interrupt affinity
setting in hardware before activation of the interrupt. While this works in
general, it does not work for this particular case. As contrary to the
initial analysis not all interrupt chip drivers implement an activate
callback, the safe cure is to make the deferred interrupt affinity setting
at activation time opt-in.

Implement the necessary core logic and make the two irqchip implementations
for which this is required opt-in. In hindsight this would have been the
right thing to do, but ...

Fixes: baedb87d1b53 ("genirq/affinity: Handle affinity setting on inactive interrupts correctly")
Reported-by: John Keeping <john@metanate.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Marc Zyngier <maz@kernel.org>
Acked-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/87blk4tzgm.fsf@nanos.tec.linutronix.de
---
 arch/x86/kernel/apic/vector.c    |  4 ++++
 drivers/irqchip/irq-gic-v3-its.c |  5 ++++-
 include/linux/irq.h              | 13 +++++++++++++
 kernel/irq/manage.c              |  6 +++++-
 4 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index 7649da2..dae32d9 100644
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -560,6 +560,10 @@ static int x86_vector_alloc_irqs(struct irq_domain *domain, unsigned int virq,
 		 * as that can corrupt the affinity move state.
 		 */
 		irqd_set_handle_enforce_irqctx(irqd);
+
+		/* Don't invoke affinity setter on deactivated interrupts */
+		irqd_set_affinity_on_activate(irqd);
+
 		/*
 		 * Legacy vectors are already assigned when the IOAPIC
 		 * takes them over. They stay on the same vector. This is
diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index beac4ca..103d850 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -3523,6 +3523,7 @@ static int its_irq_domain_alloc(struct irq_domain *domain, unsigned int virq,
 	msi_alloc_info_t *info = args;
 	struct its_device *its_dev = info->scratchpad[0].ptr;
 	struct its_node *its = its_dev->its;
+	struct irq_data *irqd;
 	irq_hw_number_t hwirq;
 	int err;
 	int i;
@@ -3542,7 +3543,9 @@ static int its_irq_domain_alloc(struct irq_domain *domain, unsigned int virq,
 
 		irq_domain_set_hwirq_and_chip(domain, virq + i,
 					      hwirq + i, &its_irq_chip, its_dev);
-		irqd_set_single_target(irq_desc_get_irq_data(irq_to_desc(virq + i)));
+		irqd = irq_get_irq_data(virq + i);
+		irqd_set_single_target(irqd);
+		irqd_set_affinity_on_activate(irqd);
 		pr_debug("ID:%d pID:%d vID:%d\n",
 			 (int)(hwirq + i - its_dev->event_map.lpi_base),
 			 (int)(hwirq + i), virq + i);
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 8d5bc2c..1b7f4df 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -213,6 +213,8 @@ struct irq_data {
  *				  required
  * IRQD_HANDLE_ENFORCE_IRQCTX	- Enforce that handle_irq_*() is only invoked
  *				  from actual interrupt context.
+ * IRQD_AFFINITY_ON_ACTIVATE	- Affinity is set on activation. Don't call
+ *				  irq_chip::irq_set_affinity() when deactivated.
  */
 enum {
 	IRQD_TRIGGER_MASK		= 0xf,
@@ -237,6 +239,7 @@ enum {
 	IRQD_CAN_RESERVE		= (1 << 26),
 	IRQD_MSI_NOMASK_QUIRK		= (1 << 27),
 	IRQD_HANDLE_ENFORCE_IRQCTX	= (1 << 28),
+	IRQD_AFFINITY_ON_ACTIVATE	= (1 << 29),
 };
 
 #define __irqd_to_state(d) ACCESS_PRIVATE((d)->common, state_use_accessors)
@@ -421,6 +424,16 @@ static inline bool irqd_msi_nomask_quirk(struct irq_data *d)
 	return __irqd_to_state(d) & IRQD_MSI_NOMASK_QUIRK;
 }
 
+static inline void irqd_set_affinity_on_activate(struct irq_data *d)
+{
+	__irqd_to_state(d) |= IRQD_AFFINITY_ON_ACTIVATE;
+}
+
+static inline bool irqd_affinity_on_activate(struct irq_data *d)
+{
+	return __irqd_to_state(d) & IRQD_AFFINITY_ON_ACTIVATE;
+}
+
 #undef __irqd_to_state
 
 static inline irq_hw_number_t irqd_to_hwirq(struct irq_data *d)
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 2a9fec5..48c38e0 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -320,12 +320,16 @@ static bool irq_set_affinity_deactivated(struct irq_data *data,
 	struct irq_desc *desc = irq_data_to_desc(data);
 
 	/*
+	 * Handle irq chips which can handle affinity only in activated
+	 * state correctly
+	 *
 	 * If the interrupt is not yet activated, just store the affinity
 	 * mask and do not call the chip driver at all. On activation the
 	 * driver has to make sure anyway that the interrupt is in a
 	 * useable state so startup works.
 	 */
-	if (!IS_ENABLED(CONFIG_IRQ_DOMAIN_HIERARCHY) || irqd_is_activated(data))
+	if (!IS_ENABLED(CONFIG_IRQ_DOMAIN_HIERARCHY) ||
+	    irqd_is_activated(data) || !irqd_affinity_on_activate(data))
 		return false;
 
 	cpumask_copy(desc->irq_common_data.affinity, mask);
