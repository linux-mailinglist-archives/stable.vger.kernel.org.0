Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF2E36B770D
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 12:59:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbjCML7f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 07:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbjCML7e (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 07:59:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 505953526E;
        Mon, 13 Mar 2023 04:59:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1A8461214;
        Mon, 13 Mar 2023 11:59:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19667C433D2;
        Mon, 13 Mar 2023 11:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678708768;
        bh=O9Sj409rearfAyt0r5sDA9sRoEWJ/F3gUbbjo5CTXg4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t9AUnUi+NhgJgbj6rbGQ0xJT7SNBRXcNjsznrjqYb9/+B/5w7HfqWs6oURGWnemZT
         jt5/goKVA7DOJEyKArM6F/i7R13mKC7rWacqn4MYQURnvQ3crB6wRZRk0Di47zXzgX
         nyGupzD7Yk7qyS986AzhkksvcRILPisgva1sygXHF8FtCOofx7i8zU/FMoFJAquF1T
         FzxCpMwx3OtmBIp7TwRG8OCUaUl+OPHE/39Ml/1BR6qqs6/zXZ2si6YLY3OOCoYQKD
         /648g5iZBgB9jgxkdyDcSXmSmFZGR5TwqBPBUf247QXaKCRO7LhfRj+HN2FmjAG8gb
         LC7cEof00oBGg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1pbgqr-0006kp-6a; Mon, 13 Mar 2023 13:00:29 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Marc Zyngier <maz@kernel.org>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>,
        Hsin-Yi Wang <hsinyi@chromium.org>,
        Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Subject: [PATCH stable-5.15 1/2] irqdomain: Refactor __irq_domain_alloc_irqs()
Date:   Mon, 13 Mar 2023 13:00:06 +0100
Message-Id: <20230313120007.25938-2-johan@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230313120007.25938-1-johan@kernel.org>
References: <20230313120007.25938-1-johan@kernel.org>
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

From: Johan Hovold <johan+linaro@kernel.org>

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
[ johan: backport to 5.15; adjust context ]
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 kernel/irq/irqdomain.c | 88 +++++++++++++++++++++++-------------------
 1 file changed, 48 insertions(+), 40 deletions(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 298f9c12023c..f95196063884 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -1464,40 +1464,12 @@ int irq_domain_alloc_irqs_hierarchy(struct irq_domain *domain,
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
@@ -1516,24 +1488,18 @@ int __irq_domain_alloc_irqs(struct irq_domain *domain, int irq_base,
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
 
@@ -1544,6 +1510,48 @@ int __irq_domain_alloc_irqs(struct irq_domain *domain, int irq_base,
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

