Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 901F1694329
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 11:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbjBMKn1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 05:43:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbjBMKnW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 05:43:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05C7C166D4;
        Mon, 13 Feb 2023 02:43:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BCB79B8109A;
        Mon, 13 Feb 2023 10:43:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F7EFC4339B;
        Mon, 13 Feb 2023 10:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676284996;
        bh=9Zp9hoAQoVOaXXCM6Fs7+H3M4bdWA3fEKLViYqGRNG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SXMhpjz3jtwwzHT/G3LXz7Pqj4GbPHLxNmKD4xfOd/S7ZIfPybjmq5jAnMH90Yynz
         0w1SkWaBZYCXpp+oaMEr8MfB7+dGhoCyGVLKWH0VdscfBv56t0ULYWD7kSv5MMWv2i
         cPic/Yg8PrmeGzsRW1XQwlV/KUqv0kfU/KvU/fNYvBJgPHw6SauvKVH/3FupAilDc7
         SgISXGzOoExgcXpxtdjPfDvl1VBoH3/py24Go1WLpux4GWv/dDax9FndXevZreHHqg
         3nd/SK8sw5uODyk3XL0NGLm2BaXXkgFg6hs4sl7GWqQWalZxm+N1aT2dvj3KynriEV
         ayI/3M5wgrb0g==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1pRWJb-0004WT-Dx; Mon, 13 Feb 2023 11:44:07 +0100
From:   Johan Hovold <johan+linaro@kernel.org>
To:     Marc Zyngier <maz@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc:     x86@kernel.org, platform-driver-x86@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>, stable@vger.kernel.org,
        Dmitry Torokhov <dtor@chromium.org>,
        Jon Hunter <jonathanh@nvidia.com>,
        Hsin-Yi Wang <hsinyi@chromium.org>,
        Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Subject: [PATCH v6 06/20] irqdomain: Fix mapping-creation race
Date:   Mon, 13 Feb 2023 11:42:48 +0100
Message-Id: <20230213104302.17307-7-johan+linaro@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213104302.17307-1-johan+linaro@kernel.org>
References: <20230213104302.17307-1-johan+linaro@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Parallel probing of devices that share interrupts (e.g. when a driver
uses asynchronous probing) can currently result in two mappings for the
same hardware interrupt to be created due to missing serialisation.

Make sure to hold the irq_domain_mutex when creating mappings so that
looking for an existing mapping before creating a new one is done
atomically.

Fixes: 765230b5f084 ("driver-core: add asynchronous probing support for drivers")
Fixes: b62b2cf5759b ("irqdomain: Fix handling of type settings for existing mappings")
Link: https://lore.kernel.org/r/YuJXMHoT4ijUxnRb@hovoldconsulting.com
Cc: stable@vger.kernel.org      # 4.8
Cc: Dmitry Torokhov <dtor@chromium.org>
Cc: Jon Hunter <jonathanh@nvidia.com>
Tested-by: Hsin-Yi Wang <hsinyi@chromium.org>
Tested-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 kernel/irq/irqdomain.c | 64 ++++++++++++++++++++++++++++++------------
 1 file changed, 46 insertions(+), 18 deletions(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 7b57949bc79c..bfda4adc05c0 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -25,6 +25,9 @@ static DEFINE_MUTEX(irq_domain_mutex);
 
 static struct irq_domain *irq_default_domain;
 
+static int irq_domain_alloc_irqs_locked(struct irq_domain *domain, int irq_base,
+					unsigned int nr_irqs, int node, void *arg,
+					bool realloc, const struct irq_affinity_desc *affinity);
 static void irq_domain_check_hierarchy(struct irq_domain *domain);
 
 struct irqchip_fwid {
@@ -682,9 +685,9 @@ unsigned int irq_create_direct_mapping(struct irq_domain *domain)
 EXPORT_SYMBOL_GPL(irq_create_direct_mapping);
 #endif
 
-static unsigned int __irq_create_mapping_affinity(struct irq_domain *domain,
-						  irq_hw_number_t hwirq,
-						  const struct irq_affinity_desc *affinity)
+static unsigned int irq_create_mapping_affinity_locked(struct irq_domain *domain,
+						       irq_hw_number_t hwirq,
+						       const struct irq_affinity_desc *affinity)
 {
 	struct device_node *of_node = irq_domain_get_of_node(domain);
 	int virq;
@@ -699,7 +702,7 @@ static unsigned int __irq_create_mapping_affinity(struct irq_domain *domain,
 		return 0;
 	}
 
-	if (irq_domain_associate(domain, virq, hwirq)) {
+	if (irq_domain_associate_locked(domain, virq, hwirq)) {
 		irq_free_desc(virq);
 		return 0;
 	}
@@ -735,14 +738,20 @@ unsigned int irq_create_mapping_affinity(struct irq_domain *domain,
 		return 0;
 	}
 
+	mutex_lock(&irq_domain_mutex);
+
 	/* Check if mapping already exists */
 	virq = irq_find_mapping(domain, hwirq);
 	if (virq) {
 		pr_debug("existing mapping on virq %d\n", virq);
-		return virq;
+		goto out;
 	}
 
-	return __irq_create_mapping_affinity(domain, hwirq, affinity);
+	virq = irq_create_mapping_affinity_locked(domain, hwirq, affinity);
+out:
+	mutex_unlock(&irq_domain_mutex);
+
+	return virq;
 }
 EXPORT_SYMBOL_GPL(irq_create_mapping_affinity);
 
@@ -809,6 +818,8 @@ unsigned int irq_create_fwspec_mapping(struct irq_fwspec *fwspec)
 	if (WARN_ON(type & ~IRQ_TYPE_SENSE_MASK))
 		type &= IRQ_TYPE_SENSE_MASK;
 
+	mutex_lock(&irq_domain_mutex);
+
 	/*
 	 * If we've already configured this interrupt,
 	 * don't do it again, or hell will break loose.
@@ -821,7 +832,7 @@ unsigned int irq_create_fwspec_mapping(struct irq_fwspec *fwspec)
 		 * interrupt number.
 		 */
 		if (type == IRQ_TYPE_NONE || type == irq_get_trigger_type(virq))
-			return virq;
+			goto out;
 
 		/*
 		 * If the trigger type has not been set yet, then set
@@ -829,35 +840,45 @@ unsigned int irq_create_fwspec_mapping(struct irq_fwspec *fwspec)
 		 */
 		if (irq_get_trigger_type(virq) == IRQ_TYPE_NONE) {
 			irq_data = irq_get_irq_data(virq);
-			if (!irq_data)
-				return 0;
+			if (!irq_data) {
+				virq = 0;
+				goto out;
+			}
 
 			irqd_set_trigger_type(irq_data, type);
-			return virq;
+			goto out;
 		}
 
 		pr_warn("type mismatch, failed to map hwirq-%lu for %s!\n",
 			hwirq, of_node_full_name(to_of_node(fwspec->fwnode)));
-		return 0;
+		virq = 0;
+		goto out;
 	}
 
 	if (irq_domain_is_hierarchy(domain)) {
-		virq = irq_domain_alloc_irqs(domain, 1, NUMA_NO_NODE, fwspec);
-		if (virq <= 0)
-			return 0;
+		virq = irq_domain_alloc_irqs_locked(domain, -1, 1, NUMA_NO_NODE,
+						    fwspec, false, NULL);
+		if (virq <= 0) {
+			virq = 0;
+			goto out;
+		}
 	} else {
 		/* Create mapping */
-		virq = __irq_create_mapping_affinity(domain, hwirq, NULL);
+		virq = irq_create_mapping_affinity_locked(domain, hwirq, NULL);
 		if (!virq)
-			return virq;
+			goto out;
 	}
 
 	irq_data = irq_get_irq_data(virq);
-	if (WARN_ON(!irq_data))
-		return 0;
+	if (WARN_ON(!irq_data)) {
+		virq = 0;
+		goto out;
+	}
 
 	/* Store trigger type */
 	irqd_set_trigger_type(irq_data, type);
+out:
+	mutex_unlock(&irq_domain_mutex);
 
 	return virq;
 }
@@ -1888,6 +1909,13 @@ void irq_domain_set_info(struct irq_domain *domain, unsigned int virq,
 	irq_set_handler_data(virq, handler_data);
 }
 
+static int irq_domain_alloc_irqs_locked(struct irq_domain *domain, int irq_base,
+					unsigned int nr_irqs, int node, void *arg,
+					bool realloc, const struct irq_affinity_desc *affinity)
+{
+	return -EINVAL;
+}
+
 static void irq_domain_check_hierarchy(struct irq_domain *domain)
 {
 }
-- 
2.39.1

