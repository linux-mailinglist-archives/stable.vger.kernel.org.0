Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFD892411AC
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 22:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbgHJUZK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 16:25:10 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:41792 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbgHJUZJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Aug 2020 16:25:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1597091109; x=1628627109;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=MWdkqs6e+BzOeVCwuOJoUnoLGVkp8F5Pva2KxDiCN8M=;
  b=vQc3XCsN2IFRgBnNlE0bWE1qWKO6ebwWwVt4BS0EuFiHGGg7lznE/K17
   OnZVbHjUHeMis+xBz9BTs8ow29l6qhnH9W+IFEvgpjIXNF1MLrfr3dA7R
   WWGFcPyOofYcS0AINqRsAGA8KO/AocTOLzfZkYvQB+78MTYVfwZAOdE0r
   c=;
IronPort-SDR: l36PoT/P34qNOLHL7o3nOL025gV3/x+gMVel4Se9U535PxRQyBZR9zor+zyjWD/CqDeJbZZS7G
 PuwuA5Sn0DuQ==
X-IronPort-AV: E=Sophos;i="5.75,458,1589241600"; 
   d="scan'208";a="46987154"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 10 Aug 2020 20:25:07 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com (Postfix) with ESMTPS id F13BD28219C;
        Mon, 10 Aug 2020 20:25:03 +0000 (UTC)
Received: from EX13D13UWB002.ant.amazon.com (10.43.161.21) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 10 Aug 2020 20:25:03 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13D13UWB002.ant.amazon.com (10.43.161.21) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 10 Aug 2020 20:25:03 +0000
Received: from dev-dsk-fllinden-2c-c1893d73.us-west-2.amazon.com
 (172.23.141.97) by mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Mon, 10 Aug 2020 20:25:03 +0000
Received: by dev-dsk-fllinden-2c-c1893d73.us-west-2.amazon.com (Postfix, from userid 6262777)
        id 24F6EC13FC; Mon, 10 Aug 2020 20:25:03 +0000 (UTC)
From:   Frank van der Linden <fllinden@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <fllinden@amazon.com>, <tglx@linutronix.de>
Subject: [PATCH 5.4] genirq/affinity: Make affinity setting if activated opt-in
Date:   Mon, 10 Aug 2020 20:25:03 +0000
Message-ID: <20200810202503.22317-1-fllinden@amazon.com>
X-Mailer: git-send-email 2.16.6
MIME-Version: 1.0
Content-Type: text/plain
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
---
 arch/x86/kernel/apic/vector.c    |  4 ++++
 drivers/irqchip/irq-gic-v3-its.c |  5 ++++-
 include/linux/irq.h              | 13 +++++++++++++
 kernel/irq/manage.c              |  6 +++++-
 4 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index 18c0dca08163..557b153c9ee6 100644
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -554,6 +554,10 @@ static int x86_vector_alloc_irqs(struct irq_domain *domain, unsigned int virq,
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
diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 263cf9240b16..7966b19ceba7 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -2581,6 +2581,7 @@ static int its_irq_domain_alloc(struct irq_domain *domain, unsigned int virq,
 	msi_alloc_info_t *info = args;
 	struct its_device *its_dev = info->scratchpad[0].ptr;
 	struct its_node *its = its_dev->its;
+	struct irq_data *irqd;
 	irq_hw_number_t hwirq;
 	int err;
 	int i;
@@ -2600,7 +2601,9 @@ static int its_irq_domain_alloc(struct irq_domain *domain, unsigned int virq,
 
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
index ab9d956e21b3..be00e0ae5e31 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -211,6 +211,8 @@ struct irq_data {
  * IRQD_CAN_RESERVE		- Can use reservation mode
  * IRQD_MSI_NOMASK_QUIRK	- Non-maskable MSI quirk for affinity change
  *				  required
+ * IRQD_AFFINITY_ON_ACTIVATE	- Affinity is set on activation. Don't call
+ *				  irq_chip::irq_set_affinity() when deactivated.
  */
 enum {
 	IRQD_TRIGGER_MASK		= 0xf,
@@ -234,6 +236,7 @@ enum {
 	IRQD_DEFAULT_TRIGGER_SET	= (1 << 25),
 	IRQD_CAN_RESERVE		= (1 << 26),
 	IRQD_MSI_NOMASK_QUIRK		= (1 << 27),
+	IRQD_AFFINITY_ON_ACTIVATE	= (1 << 29),
 };
 
 #define __irqd_to_state(d) ACCESS_PRIVATE((d)->common, state_use_accessors)
@@ -408,6 +411,16 @@ static inline bool irqd_msi_nomask_quirk(struct irq_data *d)
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
index df73685de114..3b1d0a4725a4 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -281,12 +281,16 @@ static bool irq_set_affinity_deactivated(struct irq_data *data,
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
-- 
2.17.2

