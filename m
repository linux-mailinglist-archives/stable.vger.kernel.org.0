Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB3406BB0CF
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232053AbjCOMV2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:21:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232064AbjCOMVA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:21:00 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2910224BE6
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:20:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B2A2ECE1986
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:20:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9490C433D2;
        Wed, 15 Mar 2023 12:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678882822;
        bh=Z988REYkg8SerAdj278z5rsfPVWrHg/WSV0fDC2WsyY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XxcqmxMlu2YvVkwTa9g+kPRXxHehXMYA8QtXT5s6qCdXyViyMArbOfNgdfgTBVixD
         tKBWc9Hs2gZ84iAkcE2d3b9SpLrhhHPqA4MhSNP0arlTglCyzBQyT2gcBbkenmsZpm
         LopoLP5gDTGrMlC9/VXpNH3VKowOYPqG4D/T/PZ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hsin-Yi Wang <hsinyi@chromium.org>,
        Mark-PK Tsai <mark-pk.tsai@mediatek.com>,
        Johan Hovold <johan+linaro@kernel.org>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 015/104] irqdomain: Look for existing mapping only once
Date:   Wed, 15 Mar 2023 13:11:46 +0100
Message-Id: <20230315115732.683738321@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115731.942692602@linuxfoundation.org>
References: <20230315115731.942692602@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit 6e6f75c9c98d2d246d90411ff2b6f0cd271f4cba ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/irq/irqdomain.c | 60 +++++++++++++++++++++++-------------------
 1 file changed, 33 insertions(+), 27 deletions(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index fe07888a7d96a..d18c25a41673f 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -637,6 +637,34 @@ unsigned int irq_create_direct_mapping(struct irq_domain *domain)
 }
 EXPORT_SYMBOL_GPL(irq_create_direct_mapping);
 
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
@@ -649,14 +677,11 @@ EXPORT_SYMBOL_GPL(irq_create_direct_mapping);
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
@@ -664,34 +689,15 @@ unsigned int irq_create_mapping_affinity(struct irq_domain *domain,
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
 
@@ -831,7 +837,7 @@ unsigned int irq_create_fwspec_mapping(struct irq_fwspec *fwspec)
 			return 0;
 	} else {
 		/* Create mapping */
-		virq = irq_create_mapping(domain, hwirq);
+		virq = __irq_create_mapping_affinity(domain, hwirq, NULL);
 		if (!virq)
 			return virq;
 	}
-- 
2.39.2



