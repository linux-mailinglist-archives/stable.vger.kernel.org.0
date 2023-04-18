Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3616E6215
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231567AbjDRMaO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231613AbjDRMaI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:30:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 881B2BB96
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:29:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30774631D9
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:29:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E652C433D2;
        Tue, 18 Apr 2023 12:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681820969;
        bh=BWvdJm+mq3k7W9Xeu1eyS9XZW6krFPAPaK8DVroV3wY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tOmruXbh/bEUE6DxRVApMQPD0mhPiFNQ+/THB/wP3QBchftlF4HVIZS2Danxl49zW
         r6MnvK+TjtD4fNsCRC5w9n9uk5O9GRkFtb7pCQKtspFdHSC63N9tDFTIIxFJzDdBuX
         yY06Y3u7SGp+WExx0o+wtf3UYwMJeV+W9Yp9tIew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hsin-Yi Wang <hsinyi@chromium.org>,
        Mark-PK Tsai <mark-pk.tsai@mediatek.com>,
        Johan Hovold <johan+linaro@kernel.org>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 42/92] irqdomain: Refactor __irq_domain_alloc_irqs()
Date:   Tue, 18 Apr 2023 14:21:17 +0200
Message-Id: <20230418120306.313115869@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120304.658273364@linuxfoundation.org>
References: <20230418120304.658273364@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/irq/irqdomain.c |   74 +++++++++++++++++++++++++++----------------------
 1 file changed, 42 insertions(+), 32 deletions(-)

--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -1350,6 +1350,45 @@ int irq_domain_alloc_irqs_hierarchy(stru
 	return domain->ops->alloc(domain, irq_base, nr_irqs, arg);
 }
 
+static int irq_domain_alloc_irqs_locked(struct irq_domain *domain, int irq_base,
+					unsigned int nr_irqs, int node, void *arg,
+					bool realloc, const struct irq_affinity_desc *affinity)
+{
+	int i, ret, virq;
+
+	if (realloc && irq_base >= 0) {
+		virq = irq_base;
+	} else {
+		virq = irq_domain_alloc_descs(irq_base, nr_irqs, 0, node,
+					      affinity);
+		if (virq < 0) {
+			pr_debug("cannot allocate IRQ(base %d, count %d)\n",
+				 irq_base, nr_irqs);
+			return virq;
+		}
+	}
+
+	if (irq_domain_alloc_irq_data(domain, virq, nr_irqs)) {
+		pr_debug("cannot allocate memory for IRQ%d\n", virq);
+		ret = -ENOMEM;
+		goto out_free_desc;
+	}
+
+	ret = irq_domain_alloc_irqs_hierarchy(domain, virq, nr_irqs, arg);
+	if (ret < 0)
+		goto out_free_irq_data;
+	for (i = 0; i < nr_irqs; i++)
+		irq_domain_insert_irq(virq + i);
+
+	return virq;
+
+out_free_irq_data:
+	irq_domain_free_irq_data(virq, nr_irqs);
+out_free_desc:
+	irq_free_descs(virq, nr_irqs);
+	return ret;
+}
+
 /**
  * __irq_domain_alloc_irqs - Allocate IRQs from domain
  * @domain:	domain to allocate from
@@ -1376,7 +1415,7 @@ int __irq_domain_alloc_irqs(struct irq_d
 			    unsigned int nr_irqs, int node, void *arg,
 			    bool realloc, const struct irq_affinity_desc *affinity)
 {
-	int i, ret, virq;
+	int ret;
 
 	if (domain == NULL) {
 		domain = irq_default_domain;
@@ -1384,40 +1423,11 @@ int __irq_domain_alloc_irqs(struct irq_d
 			return -EINVAL;
 	}
 
-	if (realloc && irq_base >= 0) {
-		virq = irq_base;
-	} else {
-		virq = irq_domain_alloc_descs(irq_base, nr_irqs, 0, node,
-					      affinity);
-		if (virq < 0) {
-			pr_debug("cannot allocate IRQ(base %d, count %d)\n",
-				 irq_base, nr_irqs);
-			return virq;
-		}
-	}
-
-	if (irq_domain_alloc_irq_data(domain, virq, nr_irqs)) {
-		pr_debug("cannot allocate memory for IRQ%d\n", virq);
-		ret = -ENOMEM;
-		goto out_free_desc;
-	}
-
 	mutex_lock(&irq_domain_mutex);
-	ret = irq_domain_alloc_irqs_hierarchy(domain, virq, nr_irqs, arg);
-	if (ret < 0) {
-		mutex_unlock(&irq_domain_mutex);
-		goto out_free_irq_data;
-	}
-	for (i = 0; i < nr_irqs; i++)
-		irq_domain_insert_irq(virq + i);
+	ret = irq_domain_alloc_irqs_locked(domain, irq_base, nr_irqs, node, arg,
+					   realloc, affinity);
 	mutex_unlock(&irq_domain_mutex);
 
-	return virq;
-
-out_free_irq_data:
-	irq_domain_free_irq_data(virq, nr_irqs);
-out_free_desc:
-	irq_free_descs(virq, nr_irqs);
 	return ret;
 }
 


