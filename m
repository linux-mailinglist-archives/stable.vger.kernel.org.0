Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29A9D24B3C2
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 11:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729852AbgHTJwG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:52:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:33162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729661AbgHTJwA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:52:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86166207FB;
        Thu, 20 Aug 2020 09:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917120;
        bh=J54xSCntPSaWHZxpEYggTZx+DXeSiCJF8unRn8cZZio=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qwu9JS3wvvQ5GJx3vy5GNSsIbhVbbXfBJ/I9qvUryP+amQxSeuLChSyq3mXrPlRX1
         KLGB+yc+Kiwtg1Ua+ppZ5zYFVm8bIQokqPguYRZ96bV68EO5qtTmOHhThUiy4vW2W/
         e/QuzZF8JHh+pTToulHLTm3s5+pPapkS6RqMflGo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Keeping <john@metanate.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 4.19 02/92] genirq/affinity: Make affinity setting if activated opt-in
Date:   Thu, 20 Aug 2020 11:20:47 +0200
Message-Id: <20200820091537.624101245@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091537.490965042@linuxfoundation.org>
References: <20200820091537.490965042@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit f0c7baca180046824e07fc5f1326e83a8fd150c7 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/apic/vector.c    |    4 ++++
 drivers/irqchip/irq-gic-v3-its.c |    5 ++++-
 include/linux/irq.h              |   13 +++++++++++++
 kernel/irq/manage.c              |    6 +++++-
 4 files changed, 26 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -556,6 +556,10 @@ static int x86_vector_alloc_irqs(struct
 		irqd->chip_data = apicd;
 		irqd->hwirq = virq + i;
 		irqd_set_single_target(irqd);
+
+		/* Don't invoke affinity setter on deactivated interrupts */
+		irqd_set_affinity_on_activate(irqd);
+
 		/*
 		 * Legacy vectors are already assigned when the IOAPIC
 		 * takes them over. They stay on the same vector. This is
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -2458,6 +2458,7 @@ static int its_irq_domain_alloc(struct i
 {
 	msi_alloc_info_t *info = args;
 	struct its_device *its_dev = info->scratchpad[0].ptr;
+	struct irq_data *irqd;
 	irq_hw_number_t hwirq;
 	int err;
 	int i;
@@ -2473,7 +2474,9 @@ static int its_irq_domain_alloc(struct i
 
 		irq_domain_set_hwirq_and_chip(domain, virq + i,
 					      hwirq + i, &its_irq_chip, its_dev);
-		irqd_set_single_target(irq_desc_get_irq_data(irq_to_desc(virq + i)));
+		irqd = irq_get_irq_data(virq + i);
+		irqd_set_single_target(irqd);
+		irqd_set_affinity_on_activate(irqd);
 		pr_debug("ID:%d pID:%d vID:%d\n",
 			 (int)(hwirq + i - its_dev->event_map.lpi_base),
 			 (int)(hwirq + i), virq + i);
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -210,6 +210,8 @@ struct irq_data {
  * IRQD_CAN_RESERVE		- Can use reservation mode
  * IRQD_MSI_NOMASK_QUIRK	- Non-maskable MSI quirk for affinity change
  *				  required
+ * IRQD_AFFINITY_ON_ACTIVATE	- Affinity is set on activation. Don't call
+ *				  irq_chip::irq_set_affinity() when deactivated.
  */
 enum {
 	IRQD_TRIGGER_MASK		= 0xf,
@@ -233,6 +235,7 @@ enum {
 	IRQD_DEFAULT_TRIGGER_SET	= (1 << 25),
 	IRQD_CAN_RESERVE		= (1 << 26),
 	IRQD_MSI_NOMASK_QUIRK		= (1 << 27),
+	IRQD_AFFINITY_ON_ACTIVATE	= (1 << 29),
 };
 
 #define __irqd_to_state(d) ACCESS_PRIVATE((d)->common, state_use_accessors)
@@ -407,6 +410,16 @@ static inline bool irqd_msi_nomask_quirk
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
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -280,12 +280,16 @@ static bool irq_set_affinity_deactivated
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


