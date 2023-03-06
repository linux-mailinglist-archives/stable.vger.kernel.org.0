Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 616E16ACCFE
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 19:49:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbjCFStJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 13:49:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbjCFStF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 13:49:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40A854A1F5
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 10:49:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E0FB61083
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 18:49:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B7FAC433EF;
        Mon,  6 Mar 2023 18:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678128539;
        bh=Y8i5lV62b7Hrur2wXkhoJup+HVx+fHroxOZ4ciOj+mA=;
        h=Subject:To:Cc:From:Date:From;
        b=yzBanR9FtPErp2OWP9GXJ9YEqnKbAvLsuHG+z5o852F9mizeEFv/sDmK8oVxG97/T
         1whTf+9LDaMPJypQAyUh7bbFulhNl3pfDA3haiggj6N666lgLxOZtOKzhikGO0xv4P
         21a5nm9GMdfyc+IMCXcEBR1Hp9f38MKU670E6Z2g=
Subject: FAILED: patch "[PATCH] irqdomain: Fix mapping-creation race" failed to apply to 5.4-stable tree
To:     johan+linaro@kernel.org, dtor@chromium.org, hsinyi@chromium.org,
        jonathanh@nvidia.com, mark-pk.tsai@mediatek.com, maz@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Mar 2023 19:48:55 +0100
Message-ID: <167812853520175@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.4.y
git checkout FETCH_HEAD
git cherry-pick -x 601363cc08da25747feb87c55573dd54de91d66a
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167812853520175@kroah.com' --subject-prefix 'PATCH 5.4.y' HEAD^..

Possible dependencies:

601363cc08da ("irqdomain: Fix mapping-creation race")
6e6f75c9c98d ("irqdomain: Look for existing mapping only once")
e3b7ab025e93 ("irqdomain: Drop bogus fwspec-mapping error handling")
a359f757965a ("irq: Fix typos in comments")
bb4c6910c8b4 ("genirq/irqdomain: Add an irq_create_mapping_affinity() function")
baedb87d1b53 ("genirq/affinity: Handle affinity setting on inactive interrupts correctly")
ef8c01eb64ca ("irqchip: Add Loongson PCH PIC controller")
818e915fbac5 ("irqchip: Add Loongson HyperTransport Vector support")
d71e064449a7 ("Merge tag 'mips_5.7' of git://git.kernel.org/pub/scm/linux/kernel/git/mips/linux")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 601363cc08da25747feb87c55573dd54de91d66a Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan+linaro@kernel.org>
Date: Mon, 13 Feb 2023 11:42:48 +0100
Subject: [PATCH] irqdomain: Fix mapping-creation race

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

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 78fb4800c0d2..df0cbad1b0d7 100644
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

