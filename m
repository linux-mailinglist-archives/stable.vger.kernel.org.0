Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4E724BDF7
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728638AbgHTNQa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:16:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:48924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728529AbgHTJfZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:35:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9926021775;
        Thu, 20 Aug 2020 09:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916125;
        bh=3TunDrFMbtZQbZlWpMa/IHHG23gMKrYJKQosfX8YNeE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f/UjMwpVz/qhSnITk18sq5GDvsnnbkoS3hO9gMvIHyFb9q1Gqlhb8acYoGv5R+mDp
         xML3jaW21eoVQUwMqsr3WGxFepbEqh7Og9OPFy6iruJHgM/DMrxKTuUfx0VjbX1UVq
         Dh20D9nOxEA5/6uiAseRVDEKcXW/CIBc31X4/mMU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Keeping <john@metanate.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.7 002/204] genirq/affinity: Make affinity setting if activated opt-in
Date:   Thu, 20 Aug 2020 11:18:19 +0200
Message-Id: <20200820091606.325110571@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091606.194320503@linuxfoundation.org>
References: <20200820091606.194320503@linuxfoundation.org>
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
@@ -560,6 +560,10 @@ static int x86_vector_alloc_irqs(struct
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
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -3399,6 +3399,7 @@ static int its_irq_domain_alloc(struct i
 	msi_alloc_info_t *info = args;
 	struct its_device *its_dev = info->scratchpad[0].ptr;
 	struct its_node *its = its_dev->its;
+	struct irq_data *irqd;
 	irq_hw_number_t hwirq;
 	int err;
 	int i;
@@ -3418,7 +3419,9 @@ static int its_irq_domain_alloc(struct i
 
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
@@ -421,6 +424,16 @@ static inline bool irqd_msi_nomask_quirk
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
@@ -320,12 +320,16 @@ static bool irq_set_affinity_deactivated
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


