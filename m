Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D77F96B7710
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 12:59:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230371AbjCML7p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 07:59:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230320AbjCML7k (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 07:59:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D81FD4AFE2;
        Mon, 13 Mar 2023 04:59:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84962B80FED;
        Mon, 13 Mar 2023 11:59:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2752CC4339B;
        Mon, 13 Mar 2023 11:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678708768;
        bh=1w/aESkin8G8MofLd68GuZos2hdpzyTcWHpQ8GhMALs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J+N3OxaHHUr8iteCIG3O6oe7oXZ7mxv+rg5TJvgWruqACOSVmt/cpJ7ZblovfD6rE
         lQixSEbTdVUpcanSxP042T4lcKv7PMJhIfyYa5Spab/y7YqaN/W++qVAdOD9CGMyZ5
         m22nFcU+EXnmCGBfW9XeLvfsT/w3zgeXl9X9XUYlAAdrWwaKZ7NcnyrYpsFnq4o9P5
         GMARR2irGzLOYBef6S1r7Bup8OzhMYZeLORpmnCmlmMxNBt08s4dLP37cyg3rERpZE
         w59sTPG4r+cr4/REDoj6V5Lvjhb9EYzZwsWu6LzjgtlJ8zvHrn4LH/6tdhlRQMaDca
         BJq6kgUC4uUBw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1pbgqr-0006kr-9s; Mon, 13 Mar 2023 13:00:29 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Marc Zyngier <maz@kernel.org>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>,
        Dmitry Torokhov <dtor@chromium.org>,
        Jon Hunter <jonathanh@nvidia.com>,
        Hsin-Yi Wang <hsinyi@chromium.org>,
        Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Subject: [PATCH stable-5.15 2/2] irqdomain: Fix mapping-creation race
Date:   Mon, 13 Mar 2023 13:00:07 +0100
Message-Id: <20230313120007.25938-3-johan@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230313120007.25938-1-johan@kernel.org>
References: <20230313120007.25938-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan+linaro@kernel.org>

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
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20230213104302.17307-7-johan+linaro@kernel.org
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 kernel/irq/irqdomain.c | 64 ++++++++++++++++++++++++++++++------------
 1 file changed, 46 insertions(+), 18 deletions(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index f95196063884..e0b67784ac1e 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -25,6 +25,9 @@ static DEFINE_MUTEX(irq_domain_mutex);
 
 static struct irq_domain *irq_default_domain;
 
+static int irq_domain_alloc_irqs_locked(struct irq_domain *domain, int irq_base,
+					unsigned int nr_irqs, int node, void *arg,
+					bool realloc, const struct irq_affinity_desc *affinity);
 static void irq_domain_check_hierarchy(struct irq_domain *domain);
 
 struct irqchip_fwid {
@@ -703,9 +706,9 @@ unsigned int irq_create_direct_mapping(struct irq_domain *domain)
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
@@ -720,7 +723,7 @@ static unsigned int __irq_create_mapping_affinity(struct irq_domain *domain,
 		return 0;
 	}
 
-	if (irq_domain_associate(domain, virq, hwirq)) {
+	if (irq_domain_associate_locked(domain, virq, hwirq)) {
 		irq_free_desc(virq);
 		return 0;
 	}
@@ -756,14 +759,20 @@ unsigned int irq_create_mapping_affinity(struct irq_domain *domain,
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
 
@@ -830,6 +839,8 @@ unsigned int irq_create_fwspec_mapping(struct irq_fwspec *fwspec)
 	if (WARN_ON(type & ~IRQ_TYPE_SENSE_MASK))
 		type &= IRQ_TYPE_SENSE_MASK;
 
+	mutex_lock(&irq_domain_mutex);
+
 	/*
 	 * If we've already configured this interrupt,
 	 * don't do it again, or hell will break loose.
@@ -842,7 +853,7 @@ unsigned int irq_create_fwspec_mapping(struct irq_fwspec *fwspec)
 		 * interrupt number.
 		 */
 		if (type == IRQ_TYPE_NONE || type == irq_get_trigger_type(virq))
-			return virq;
+			goto out;
 
 		/*
 		 * If the trigger type has not been set yet, then set
@@ -850,35 +861,45 @@ unsigned int irq_create_fwspec_mapping(struct irq_fwspec *fwspec)
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
@@ -1910,6 +1931,13 @@ void irq_domain_set_info(struct irq_domain *domain, unsigned int virq,
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
2.39.2

