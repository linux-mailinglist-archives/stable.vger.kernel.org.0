Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C93A6BB0CE
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232282AbjCOMV1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:21:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232053AbjCOMU7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:20:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA50195E02
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:20:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F74961D54
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:20:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51C31C4339B;
        Wed, 15 Mar 2023 12:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678882824;
        bh=rhHQaTcyklL5xz5D5XfqgQfC9fsohy0FeJHAi4kJ3aM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eHM/SWMszx7P6iadIDc2YCmbGegbn+CVjGn5twApCYOcyvlSwR0FR+jNDb4OYcM5u
         UhJ4uWycycM6O3l5kmyq5okFyuoJaSBXl6Xs/c/HIAck0td00mhHXp29zP77uXrg72
         fbKzKIpLdjLdBnBF+x58avFBU8LpzsglyS/QxU+8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hsin-Yi Wang <hsinyi@chromium.org>,
        Mark-PK Tsai <mark-pk.tsai@mediatek.com>,
        Johan Hovold <johan+linaro@kernel.org>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 016/104] irqdomain: Refactor __irq_domain_alloc_irqs()
Date:   Wed, 15 Mar 2023 13:11:47 +0100
Message-Id: <20230315115732.732908460@linuxfoundation.org>
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

[ Upstream commit d55f7f4c58c07beb5050a834bf57ae2ede599c7e ]

Refactor __irq_domain_alloc_irqs() so that it can be called internally
while holding the irq_domain_mutex.

This will be used to fix a shared-interrupt mapping race, hence the
Fixes tag.

Fixes: b62b2cf5759b ("irqdomain: Fix handling of type settings for existing mappings")
Cc: stable@vger.kernel.org      # 4.8
Tested-by: Hsin-Yi Wang <hsinyi@chromium.org>
Tested-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20230213104302.17307-6-johan+linaro@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/irq/irqdomain.c | 88 +++++++++++++++++++++++-------------------
 1 file changed, 48 insertions(+), 40 deletions(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index d18c25a41673f..a1e1433a07754 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -1411,40 +1411,12 @@ int irq_domain_alloc_irqs_hierarchy(struct irq_domain *domain,
 	return domain->ops->alloc(domain, irq_base, nr_irqs, arg);
 }
 
-/**
- * __irq_domain_alloc_irqs - Allocate IRQs from domain
- * @domain:	domain to allocate from
- * @irq_base:	allocate specified IRQ number if irq_base >= 0
- * @nr_irqs:	number of IRQs to allocate
- * @node:	NUMA node id for memory allocation
- * @arg:	domain specific argument
- * @realloc:	IRQ descriptors have already been allocated if true
- * @affinity:	Optional irq affinity mask for multiqueue devices
- *
- * Allocate IRQ numbers and initialized all data structures to support
- * hierarchy IRQ domains.
- * Parameter @realloc is mainly to support legacy IRQs.
- * Returns error code or allocated IRQ number
- *
- * The whole process to setup an IRQ has been split into two steps.
- * The first step, __irq_domain_alloc_irqs(), is to allocate IRQ
- * descriptor and required hardware resources. The second step,
- * irq_domain_activate_irq(), is to program the hardware with preallocated
- * resources. In this way, it's easier to rollback when failing to
- * allocate resources.
- */
-int __irq_domain_alloc_irqs(struct irq_domain *domain, int irq_base,
-			    unsigned int nr_irqs, int node, void *arg,
-			    bool realloc, const struct irq_affinity_desc *affinity)
+static int irq_domain_alloc_irqs_locked(struct irq_domain *domain, int irq_base,
+					unsigned int nr_irqs, int node, void *arg,
+					bool realloc, const struct irq_affinity_desc *affinity)
 {
 	int i, ret, virq;
 
-	if (domain == NULL) {
-		domain = irq_default_domain;
-		if (WARN(!domain, "domain is NULL; cannot allocate IRQ\n"))
-			return -EINVAL;
-	}
-
 	if (realloc && irq_base >= 0) {
 		virq = irq_base;
 	} else {
@@ -1463,24 +1435,18 @@ int __irq_domain_alloc_irqs(struct irq_domain *domain, int irq_base,
 		goto out_free_desc;
 	}
 
-	mutex_lock(&irq_domain_mutex);
 	ret = irq_domain_alloc_irqs_hierarchy(domain, virq, nr_irqs, arg);
-	if (ret < 0) {
-		mutex_unlock(&irq_domain_mutex);
+	if (ret < 0)
 		goto out_free_irq_data;
-	}
 
 	for (i = 0; i < nr_irqs; i++) {
 		ret = irq_domain_trim_hierarchy(virq + i);
-		if (ret) {
-			mutex_unlock(&irq_domain_mutex);
+		if (ret)
 			goto out_free_irq_data;
-		}
 	}
-	
+
 	for (i = 0; i < nr_irqs; i++)
 		irq_domain_insert_irq(virq + i);
-	mutex_unlock(&irq_domain_mutex);
 
 	return virq;
 
@@ -1491,6 +1457,48 @@ int __irq_domain_alloc_irqs(struct irq_domain *domain, int irq_base,
 	return ret;
 }
 
+/**
+ * __irq_domain_alloc_irqs - Allocate IRQs from domain
+ * @domain:	domain to allocate from
+ * @irq_base:	allocate specified IRQ number if irq_base >= 0
+ * @nr_irqs:	number of IRQs to allocate
+ * @node:	NUMA node id for memory allocation
+ * @arg:	domain specific argument
+ * @realloc:	IRQ descriptors have already been allocated if true
+ * @affinity:	Optional irq affinity mask for multiqueue devices
+ *
+ * Allocate IRQ numbers and initialized all data structures to support
+ * hierarchy IRQ domains.
+ * Parameter @realloc is mainly to support legacy IRQs.
+ * Returns error code or allocated IRQ number
+ *
+ * The whole process to setup an IRQ has been split into two steps.
+ * The first step, __irq_domain_alloc_irqs(), is to allocate IRQ
+ * descriptor and required hardware resources. The second step,
+ * irq_domain_activate_irq(), is to program the hardware with preallocated
+ * resources. In this way, it's easier to rollback when failing to
+ * allocate resources.
+ */
+int __irq_domain_alloc_irqs(struct irq_domain *domain, int irq_base,
+			    unsigned int nr_irqs, int node, void *arg,
+			    bool realloc, const struct irq_affinity_desc *affinity)
+{
+	int ret;
+
+	if (domain == NULL) {
+		domain = irq_default_domain;
+		if (WARN(!domain, "domain is NULL; cannot allocate IRQ\n"))
+			return -EINVAL;
+	}
+
+	mutex_lock(&irq_domain_mutex);
+	ret = irq_domain_alloc_irqs_locked(domain, irq_base, nr_irqs, node, arg,
+					   realloc, affinity);
+	mutex_unlock(&irq_domain_mutex);
+
+	return ret;
+}
+
 /* The irq_data was moved, fix the revmap to refer to the new location */
 static void irq_domain_fix_revmap(struct irq_data *d)
 {
-- 
2.39.2



