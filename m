Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3066E6ACCF5
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 19:48:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbjCFSsU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 13:48:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbjCFSsT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 13:48:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A5DE1ADCF
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 10:48:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2A4AB8107E
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 18:48:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C000C433EF;
        Mon,  6 Mar 2023 18:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678128493;
        bh=s0rkhVQ021XnBMCwv79eP972ZtRa9SNX75llsQVyBeQ=;
        h=Subject:To:Cc:From:Date:From;
        b=Qoq4Q3+weIEHYVrRgzJwvKSvOocxJY/uxiD++q99ZDs0xw3VD/ZnTEi+B+xP7vV/r
         vYTUlBSNu+cY8YeUPdwjS6oBiQC9kqDZFQI3c9htWkcxLSgJLqidHFZVapq56Q/Ih8
         4ihF3M8mm9j3GkeoE8clgzbTjtO474XINMUd0JV8=
Subject: FAILED: patch "[PATCH] irqdomain: Look for existing mapping only once" failed to apply to 4.14-stable tree
To:     johan+linaro@kernel.org, hsinyi@chromium.org,
        mark-pk.tsai@mediatek.com, maz@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Mar 2023 19:48:02 +0100
Message-ID: <167812848218480@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-4.14.y
git checkout FETCH_HEAD
git cherry-pick -x 6e6f75c9c98d2d246d90411ff2b6f0cd271f4cba
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167812848218480@kroah.com' --subject-prefix 'PATCH 4.14.y' HEAD^..

Possible dependencies:

6e6f75c9c98d ("irqdomain: Look for existing mapping only once")
a359f757965a ("irq: Fix typos in comments")
bb4c6910c8b4 ("genirq/irqdomain: Add an irq_create_mapping_affinity() function")
baedb87d1b53 ("genirq/affinity: Handle affinity setting on inactive interrupts correctly")
ef8c01eb64ca ("irqchip: Add Loongson PCH PIC controller")
818e915fbac5 ("irqchip: Add Loongson HyperTransport Vector support")
d71e064449a7 ("Merge tag 'mips_5.7' of git://git.kernel.org/pub/scm/linux/kernel/git/mips/linux")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6e6f75c9c98d2d246d90411ff2b6f0cd271f4cba Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan+linaro@kernel.org>
Date: Mon, 13 Feb 2023 11:42:46 +0100
Subject: [PATCH] irqdomain: Look for existing mapping only once

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

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 9f5b96cf6c5c..9f95047e4bc7 100644
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

