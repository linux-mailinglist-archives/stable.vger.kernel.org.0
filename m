Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7309E241176
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 22:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbgHJUL7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 16:11:59 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:31563 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726528AbgHJULy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Aug 2020 16:11:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1597090313; x=1628626313;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=NYBbNib/pGrJilIKShD0VJRMdX19mqfuG2keZa/NBqo=;
  b=asopxLdE8TSbmBhdHFdKWbMu0323JZ/qGYfMjpxHZaxpi3zOJ6pxgbPp
   C5AqQivw0T3dMNXPqC4uwDLtrKfpBYbD/XDhJ3oJozo/iztPLZMlEy2YL
   nhcfsZo+eqPmZ326e2ixDIFIcKGzDQG5IcEK4RuBdc3DLGWC6mWrlwHSr
   o=;
IronPort-SDR: 9vqFP2zjdSr9mZ+QW1ZKNTMN4CIqHP7Qzq+FN4aHFJ8bWzhSo76WQLuSgI85mExSNaBRgNdYaU
 /bPYsgLyckxA==
X-IronPort-AV: E=Sophos;i="5.75,458,1589241600"; 
   d="scan'208";a="66955070"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-4e24fd92.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 10 Aug 2020 20:11:46 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-4e24fd92.us-west-2.amazon.com (Postfix) with ESMTPS id ACA24A1DCF
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 20:11:46 +0000 (UTC)
Received: from EX13D13UWB004.ant.amazon.com (10.43.161.218) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 10 Aug 2020 20:11:46 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D13UWB004.ant.amazon.com (10.43.161.218) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 10 Aug 2020 20:11:45 +0000
Received: from dev-dsk-fllinden-2c-c1893d73.us-west-2.amazon.com
 (172.23.141.97) by mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Mon, 10 Aug 2020 20:11:45 +0000
Received: by dev-dsk-fllinden-2c-c1893d73.us-west-2.amazon.com (Postfix, from userid 6262777)
        id C5C4FC1443; Mon, 10 Aug 2020 20:11:44 +0000 (UTC)
From:   Frank van der Linden <fllinden@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <fllinden@amazon.com>
Subject: [PATCH 4.14 2/2] genirq/affinity: Make affinity setting if activated opt-in
Date:   Mon, 10 Aug 2020 20:11:44 +0000
Message-ID: <20200810201144.20618-2-fllinden@amazon.com>
X-Mailer: git-send-email 2.16.6
In-Reply-To: <20200810201144.20618-1-fllinden@amazon.com>
References: <20200810201144.20618-1-fllinden@amazon.com>
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
[fllinden@amazon.com - backported to 4.14]
Signed-off-by: Frank van der Linden <fllinden@amazon.com>
---
 arch/x86/kernel/apic/vector.c    |  4 ++++
 drivers/irqchip/irq-gic-v3-its.c |  5 ++++-
 include/linux/irq.h              | 12 ++++++++++++
 kernel/irq/manage.c              |  6 +++++-
 4 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index b958082c74a7..0e50f8240d41 100644
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -368,6 +368,10 @@ static int x86_vector_alloc_irqs(struct irq_domain *domain, unsigned int virq,
 		irq_data->chip = &lapic_controller;
 		irq_data->chip_data = data;
 		irq_data->hwirq = virq + i;
+
+		/* Don't invoke affinity setter on deactivated interrupts */
+		irqd_set_affinity_on_activate(irq_data);
+
 		err = assign_irq_vector_policy(virq + i, node, data, info,
 					       irq_data);
 		if (err) {
diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index d7963dbdb091..a32714f0af64 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -2435,6 +2435,7 @@ static int its_irq_domain_alloc(struct irq_domain *domain, unsigned int virq,
 {
 	msi_alloc_info_t *info = args;
 	struct its_device *its_dev = info->scratchpad[0].ptr;
+	struct irq_data *irqd;
 	irq_hw_number_t hwirq;
 	int err;
 	int i;
@@ -2450,7 +2451,9 @@ static int its_irq_domain_alloc(struct irq_domain *domain, unsigned int virq,
 
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
index e508bad309b6..881772e948ca 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -212,6 +212,8 @@ struct irq_data {
  *				  mask. Applies only to affinity managed irqs.
  * IRQD_SINGLE_TARGET		- IRQ allows only a single affinity target
  * IRQD_DEFAULT_TRIGGER_SET	- Expected trigger already been set
+ * IRQD_AFFINITY_ON_ACTIVATE	- Affinity is set on activation. Don't call
+ *				  irq_chip::irq_set_affinity() when deactivated.
  */
 enum {
 	IRQD_TRIGGER_MASK		= 0xf,
@@ -233,6 +235,7 @@ enum {
 	IRQD_MANAGED_SHUTDOWN		= (1 << 23),
 	IRQD_SINGLE_TARGET		= (1 << 24),
 	IRQD_DEFAULT_TRIGGER_SET	= (1 << 25),
+	IRQD_AFFINITY_ON_ACTIVATE	= (1 << 29),
 };
 
 #define __irqd_to_state(d) ACCESS_PRIVATE((d)->common, state_use_accessors)
@@ -377,6 +380,15 @@ static inline bool irqd_is_managed_and_shutdown(struct irq_data *d)
 	return __irqd_to_state(d) & IRQD_MANAGED_SHUTDOWN;
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
 #undef __irqd_to_state
 
 static inline irq_hw_number_t irqd_to_hwirq(struct irq_data *d)
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index ce6fba446814..3193be58805c 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -221,12 +221,16 @@ static bool irq_set_affinity_deactivated(struct irq_data *data,
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

