Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E34C5599FA3
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350671AbiHSP4q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 11:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350916AbiHSP4B (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 11:56:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76B10105F15;
        Fri, 19 Aug 2022 08:50:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC058615E7;
        Fri, 19 Aug 2022 15:50:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAC97C433C1;
        Fri, 19 Aug 2022 15:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924228;
        bh=c96wVxhjuXEFbuZKo7V9S27x5DzfULYn05ZX5jnuSLE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EangkHCjT3ngyv77OCovrBo5yWrE5UC7LiPYKeQjXJUQlT95hbzG8kngN7hN7ymPt
         y38K0F9XqkzN241uILfK06/ETbt/u1Cu8rRjhJKJwTLfZ9mekAaV7QLMUXFZobhpX8
         NxGtS4xG5pWZukSKb7WFHmMnZojWoA4PNkC/Gch0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Samuel Holland <samuel@sholland.org>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 082/545] irqchip/mips-gic: Only register IPI domain when SMP is enabled
Date:   Fri, 19 Aug 2022 17:37:32 +0200
Message-Id: <20220819153832.931966407@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Samuel Holland <samuel@sholland.org>

[ Upstream commit 8190cc572981f2f13b6ffc26c7cfa7899e5d3ccc ]

The MIPS GIC irqchip driver may be selected in a uniprocessor
configuration, but it unconditionally registers an IPI domain.

Limit the part of the driver dealing with IPIs to only be compiled when
GENERIC_IRQ_IPI is enabled, which corresponds to an SMP configuration.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Samuel Holland <samuel@sholland.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220701200056.46555-2-samuel@sholland.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/Kconfig        |  3 +-
 drivers/irqchip/irq-mips-gic.c | 80 +++++++++++++++++++++++-----------
 2 files changed, 56 insertions(+), 27 deletions(-)

diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
index dc062e8c2caf..c4b971cd239d 100644
--- a/drivers/irqchip/Kconfig
+++ b/drivers/irqchip/Kconfig
@@ -313,7 +313,8 @@ config KEYSTONE_IRQ
 
 config MIPS_GIC
 	bool
-	select GENERIC_IRQ_IPI
+	select GENERIC_IRQ_IPI if SMP
+	select IRQ_DOMAIN_HIERARCHY
 	select MIPS_CM
 
 config INGENIC_IRQ
diff --git a/drivers/irqchip/irq-mips-gic.c b/drivers/irqchip/irq-mips-gic.c
index 215885962bb0..8b08b31ea2ba 100644
--- a/drivers/irqchip/irq-mips-gic.c
+++ b/drivers/irqchip/irq-mips-gic.c
@@ -50,13 +50,15 @@ static DEFINE_PER_CPU_READ_MOSTLY(unsigned long[GIC_MAX_LONGS], pcpu_masks);
 
 static DEFINE_SPINLOCK(gic_lock);
 static struct irq_domain *gic_irq_domain;
-static struct irq_domain *gic_ipi_domain;
 static int gic_shared_intrs;
 static unsigned int gic_cpu_pin;
 static unsigned int timer_cpu_pin;
 static struct irq_chip gic_level_irq_controller, gic_edge_irq_controller;
+
+#ifdef CONFIG_GENERIC_IRQ_IPI
 static DECLARE_BITMAP(ipi_resrv, GIC_MAX_INTRS);
 static DECLARE_BITMAP(ipi_available, GIC_MAX_INTRS);
+#endif /* CONFIG_GENERIC_IRQ_IPI */
 
 static struct gic_all_vpes_chip_data {
 	u32	map;
@@ -459,9 +461,11 @@ static int gic_irq_domain_map(struct irq_domain *d, unsigned int virq,
 	u32 map;
 
 	if (hwirq >= GIC_SHARED_HWIRQ_BASE) {
+#ifdef CONFIG_GENERIC_IRQ_IPI
 		/* verify that shared irqs don't conflict with an IPI irq */
 		if (test_bit(GIC_HWIRQ_TO_SHARED(hwirq), ipi_resrv))
 			return -EBUSY;
+#endif /* CONFIG_GENERIC_IRQ_IPI */
 
 		err = irq_domain_set_hwirq_and_chip(d, virq, hwirq,
 						    &gic_level_irq_controller,
@@ -550,6 +554,8 @@ static const struct irq_domain_ops gic_irq_domain_ops = {
 	.map = gic_irq_domain_map,
 };
 
+#ifdef CONFIG_GENERIC_IRQ_IPI
+
 static int gic_ipi_domain_xlate(struct irq_domain *d, struct device_node *ctrlr,
 				const u32 *intspec, unsigned int intsize,
 				irq_hw_number_t *out_hwirq,
@@ -653,6 +659,48 @@ static const struct irq_domain_ops gic_ipi_domain_ops = {
 	.match = gic_ipi_domain_match,
 };
 
+static int gic_register_ipi_domain(struct device_node *node)
+{
+	struct irq_domain *gic_ipi_domain;
+	unsigned int v[2], num_ipis;
+
+	gic_ipi_domain = irq_domain_add_hierarchy(gic_irq_domain,
+						  IRQ_DOMAIN_FLAG_IPI_PER_CPU,
+						  GIC_NUM_LOCAL_INTRS + gic_shared_intrs,
+						  node, &gic_ipi_domain_ops, NULL);
+	if (!gic_ipi_domain) {
+		pr_err("Failed to add IPI domain");
+		return -ENXIO;
+	}
+
+	irq_domain_update_bus_token(gic_ipi_domain, DOMAIN_BUS_IPI);
+
+	if (node &&
+	    !of_property_read_u32_array(node, "mti,reserved-ipi-vectors", v, 2)) {
+		bitmap_set(ipi_resrv, v[0], v[1]);
+	} else {
+		/*
+		 * Reserve 2 interrupts per possible CPU/VP for use as IPIs,
+		 * meeting the requirements of arch/mips SMP.
+		 */
+		num_ipis = 2 * num_possible_cpus();
+		bitmap_set(ipi_resrv, gic_shared_intrs - num_ipis, num_ipis);
+	}
+
+	bitmap_copy(ipi_available, ipi_resrv, GIC_MAX_INTRS);
+
+	return 0;
+}
+
+#else /* !CONFIG_GENERIC_IRQ_IPI */
+
+static inline int gic_register_ipi_domain(struct device_node *node)
+{
+	return 0;
+}
+
+#endif /* !CONFIG_GENERIC_IRQ_IPI */
+
 static int gic_cpu_startup(unsigned int cpu)
 {
 	/* Enable or disable EIC */
@@ -671,11 +719,12 @@ static int gic_cpu_startup(unsigned int cpu)
 static int __init gic_of_init(struct device_node *node,
 			      struct device_node *parent)
 {
-	unsigned int cpu_vec, i, gicconfig, v[2], num_ipis;
+	unsigned int cpu_vec, i, gicconfig;
 	unsigned long reserved;
 	phys_addr_t gic_base;
 	struct resource res;
 	size_t gic_len;
+	int ret;
 
 	/* Find the first available CPU vector. */
 	i = 0;
@@ -764,30 +813,9 @@ static int __init gic_of_init(struct device_node *node,
 		return -ENXIO;
 	}
 
-	gic_ipi_domain = irq_domain_add_hierarchy(gic_irq_domain,
-						  IRQ_DOMAIN_FLAG_IPI_PER_CPU,
-						  GIC_NUM_LOCAL_INTRS + gic_shared_intrs,
-						  node, &gic_ipi_domain_ops, NULL);
-	if (!gic_ipi_domain) {
-		pr_err("Failed to add IPI domain");
-		return -ENXIO;
-	}
-
-	irq_domain_update_bus_token(gic_ipi_domain, DOMAIN_BUS_IPI);
-
-	if (node &&
-	    !of_property_read_u32_array(node, "mti,reserved-ipi-vectors", v, 2)) {
-		bitmap_set(ipi_resrv, v[0], v[1]);
-	} else {
-		/*
-		 * Reserve 2 interrupts per possible CPU/VP for use as IPIs,
-		 * meeting the requirements of arch/mips SMP.
-		 */
-		num_ipis = 2 * num_possible_cpus();
-		bitmap_set(ipi_resrv, gic_shared_intrs - num_ipis, num_ipis);
-	}
-
-	bitmap_copy(ipi_available, ipi_resrv, GIC_MAX_INTRS);
+	ret = gic_register_ipi_domain(node);
+	if (ret)
+		return ret;
 
 	board_bind_eic_interrupt = &gic_bind_eic_interrupt;
 
-- 
2.35.1



