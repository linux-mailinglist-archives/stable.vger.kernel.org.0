Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 990816AF21E
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:50:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233314AbjCGSug (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:50:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233313AbjCGSuJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:50:09 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C4D29F077
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:38:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3CBD0CE1C93
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:37:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB5EDC433D2;
        Tue,  7 Mar 2023 18:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214269;
        bh=Yb4KOOaeUasvjjAxR5OmJBqzmUwcYCO78lISU59jhCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xYNclkeWvKw1RK2rbsiQRLnZyF0fxWGwCHrx7fEuLCCCWTXykjsfgVy0MYNdJ9YLO
         CeJuVaWnr7yo2C0cUdReN+oQw+vzHZQ3RMUWvmkv1dWJyXbbHW/hpLuUIBMGBcMRId
         CEhkLwlLgYGBNObT5Ye+eyD1OsfyMxq/9FQND5pE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hsin-Yi Wang <hsinyi@chromium.org>,
        Mark-PK Tsai <mark-pk.tsai@mediatek.com>,
        Johan Hovold <johan+linaro@kernel.org>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.1 776/885] irqdomain: Look for existing mapping only once
Date:   Tue,  7 Mar 2023 18:01:50 +0100
Message-Id: <20230307170035.650246296@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan+linaro@kernel.org>

commit 6e6f75c9c98d2d246d90411ff2b6f0cd271f4cba upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/irq/irqdomain.c |   60 ++++++++++++++++++++++++++-----------------------
 1 file changed, 33 insertions(+), 27 deletions(-)

--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -682,6 +682,34 @@ unsigned int irq_create_direct_mapping(s
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
@@ -694,14 +722,11 @@ EXPORT_SYMBOL_GPL(irq_create_direct_mapp
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
@@ -709,34 +734,15 @@ unsigned int irq_create_mapping_affinity
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
 
@@ -841,7 +847,7 @@ unsigned int irq_create_fwspec_mapping(s
 			return 0;
 	} else {
 		/* Create mapping */
-		virq = irq_create_mapping(domain, hwirq);
+		virq = __irq_create_mapping_affinity(domain, hwirq, NULL);
 		if (!virq)
 			return virq;
 	}


