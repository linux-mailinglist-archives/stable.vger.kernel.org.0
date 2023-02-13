Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0DA16950DD
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 20:41:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231410AbjBMTlM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 14:41:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231361AbjBMTlF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 14:41:05 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FD8E1B312;
        Mon, 13 Feb 2023 11:40:48 -0800 (PST)
Date:   Mon, 13 Feb 2023 19:40:46 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1676317247;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eIfJbsPv/dve0KhKoFX7LXZbkAtcbgWM+riGxkn1gAE=;
        b=ucp86TbM5lyY7T/cDglo77EgQmAVB9vdw3R5BEagJLZi2nDS+hD8hWrPA3RqVc9BWkawyx
        mQs5nkpRyCq7DjwSGNjFW2wYz2IEU1Z6ZNf0EuZTwzSi1/UoBizVYDcNSg1FUVcF8o2IDO
        CBvLCHH1BWgpPrTdeKjCumRDHHhUPQ66TnVtTx/9USGibN+IFCEhLgnBOQXIrTLR+1nF57
        SXLxY4dH9B2AxzOqP+6eC+nLgrTWhSXci1o36U8+DyaXu+L54WEr2UCxHwHp0iDP1eyQuW
        wD31hTJfj+cYTHd7Id6PyyewNLJNbwagcdS47wCmSwzLr+w9NMDSqN1gOfJHeg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1676317247;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eIfJbsPv/dve0KhKoFX7LXZbkAtcbgWM+riGxkn1gAE=;
        b=nHeieAiHwo4/jvirJ2BVGpWow60CmJ7myY0IO6eGvfxZVNuLq4z2ZHAzLjj+QbFBA7mqSj
        qpELBvtmYkmPcNAg==
From:   "irqchip-bot for Johan Hovold" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-kernel@vger.kernel.org
Subject: [irqchip: irq/irqchip-next] irqdomain: Look for existing mapping only once
Cc:     stable@vger.kernel.org, #@tip-bot2.tec.linutronix.de,
        4.8@tip-bot2.tec.linutronix.de,
        "Hsin-Yi Wang" <hsinyi@chromium.org>,
        "Mark-PK Tsai" <mark-pk.tsai@mediatek.com>,
        Johan Hovold <johan+linaro@kernel.org>,
        Marc Zyngier <maz@kernel.org>, tglx@linutronix.de
In-Reply-To: <20230213104302.17307-5-johan+linaro@kernel.org>
References: <20230213104302.17307-5-johan+linaro@kernel.org>
MIME-Version: 1.0
Message-ID: <167631724661.4906.1811820486082904866.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the irq/irqchip-next branch of irqchip:

Commit-ID:     6e6f75c9c98d2d246d90411ff2b6f0cd271f4cba
Gitweb:        https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms/6e6f75c9c98d2d246d90411ff2b6f0cd271f4cba
Author:        Johan Hovold <johan+linaro@kernel.org>
AuthorDate:    Mon, 13 Feb 2023 11:42:46 +01:00
Committer:     Marc Zyngier <maz@kernel.org>
CommitterDate: Mon, 13 Feb 2023 19:31:24 

irqdomain: Look for existing mapping only once

Avoid looking for an existing mapping twice when creating a new mapping
using irq_create_fwspec_mapping() by factoring out the actual allocation
which is shared with irq_create_mapping_affinity().

The new helper function will also be used to fix a shared-interrupt
mapping race, hence the Fixes tag.

Fixes: b62b2cf5759b ("irqdomain: Fix handling of type settings for existing mappings")
Cc: stable@vger.kernel.org      # 4.8
Tested-by: Hsin-Yi Wang <hsinyi@chromium.org>
Tested-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20230213104302.17307-5-johan+linaro@kernel.org
---
 kernel/irq/irqdomain.c | 60 ++++++++++++++++++++++-------------------
 1 file changed, 33 insertions(+), 27 deletions(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 9f5b96c..9f95047 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -682,6 +682,34 @@ unsigned int irq_create_direct_mapping(struct irq_domain *domain)
 EXPORT_SYMBOL_GPL(irq_create_direct_mapping);
 #endif
 
+static unsigned int __irq_create_mapping_affinity(struct irq_domain *domain,
+						  irq_hw_number_t hwirq,
+						  const struct irq_affinity_desc *affinity)
+{
+	struct device_node *of_node = irq_domain_get_of_node(domain);
+	int virq;
+
+	pr_debug("irq_create_mapping(0x%p, 0x%lx)\n", domain, hwirq);
+
+	/* Allocate a virtual interrupt number */
+	virq = irq_domain_alloc_descs(-1, 1, hwirq, of_node_to_nid(of_node),
+				      affinity);
+	if (virq <= 0) {
+		pr_debug("-> virq allocation failed\n");
+		return 0;
+	}
+
+	if (irq_domain_associate(domain, virq, hwirq)) {
+		irq_free_desc(virq);
+		return 0;
+	}
+
+	pr_debug("irq %lu on domain %s mapped to virtual irq %u\n",
+		hwirq, of_node_full_name(of_node), virq);
+
+	return virq;
+}
+
 /**
  * irq_create_mapping_affinity() - Map a hardware interrupt into linux irq space
  * @domain: domain owning this hardware interrupt or NULL for default domain
@@ -694,14 +722,11 @@ EXPORT_SYMBOL_GPL(irq_create_direct_mapping);
  * on the number returned from that call.
  */
 unsigned int irq_create_mapping_affinity(struct irq_domain *domain,
-				       irq_hw_number_t hwirq,
-				       const struct irq_affinity_desc *affinity)
+					 irq_hw_number_t hwirq,
+					 const struct irq_affinity_desc *affinity)
 {
-	struct device_node *of_node;
 	int virq;
 
-	pr_debug("irq_create_mapping(0x%p, 0x%lx)\n", domain, hwirq);
-
 	/* Look for default domain if necessary */
 	if (domain == NULL)
 		domain = irq_default_domain;
@@ -709,34 +734,15 @@ unsigned int irq_create_mapping_affinity(struct irq_domain *domain,
 		WARN(1, "%s(, %lx) called with NULL domain\n", __func__, hwirq);
 		return 0;
 	}
-	pr_debug("-> using domain @%p\n", domain);
-
-	of_node = irq_domain_get_of_node(domain);
 
 	/* Check if mapping already exists */
 	virq = irq_find_mapping(domain, hwirq);
 	if (virq) {
-		pr_debug("-> existing mapping on virq %d\n", virq);
+		pr_debug("existing mapping on virq %d\n", virq);
 		return virq;
 	}
 
-	/* Allocate a virtual interrupt number */
-	virq = irq_domain_alloc_descs(-1, 1, hwirq, of_node_to_nid(of_node),
-				      affinity);
-	if (virq <= 0) {
-		pr_debug("-> virq allocation failed\n");
-		return 0;
-	}
-
-	if (irq_domain_associate(domain, virq, hwirq)) {
-		irq_free_desc(virq);
-		return 0;
-	}
-
-	pr_debug("irq %lu on domain %s mapped to virtual irq %u\n",
-		hwirq, of_node_full_name(of_node), virq);
-
-	return virq;
+	return __irq_create_mapping_affinity(domain, hwirq, affinity);
 }
 EXPORT_SYMBOL_GPL(irq_create_mapping_affinity);
 
@@ -841,7 +847,7 @@ unsigned int irq_create_fwspec_mapping(struct irq_fwspec *fwspec)
 			return 0;
 	} else {
 		/* Create mapping */
-		virq = irq_create_mapping(domain, hwirq);
+		virq = __irq_create_mapping_affinity(domain, hwirq, NULL);
 		if (!virq)
 			return virq;
 	}
