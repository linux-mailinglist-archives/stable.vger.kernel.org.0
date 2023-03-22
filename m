Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B50E06C4AFA
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 13:46:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbjCVMqG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 08:46:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbjCVMqE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 08:46:04 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D89AD28874;
        Wed, 22 Mar 2023 05:46:01 -0700 (PDT)
X-UUID: 7c7e39bec8af11eda9a90f0bb45854f4-20230322
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=uIkxZI9w7v3VN7h5BVP7NSur8e4gufG83WcXLCeQmhg=;
        b=HHFbIHgaqpJSUyTNnu4tUpsRD3ccujz29fqSstjgmzbSzQRqN21lVUiCtdZBSctgvQADzVTVKrVtoAedEjGCyjt36J99ik24sr2WYLhYKb43f7O6C/UTt9Ix0egqgKFAuiRxrc+Nii6gUvpxD06F1YlYDMbik6/FQ+qO6K53f8s=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.22,REQID:d3ad7e5b-f100-4dda-b8f6-71ddce3523f0,IP:0,U
        RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:95,FILE:0,BULK:0,RULE:Release_Ham,ACTI
        ON:release,TS:70
X-CID-INFO: VERSION:1.1.22,REQID:d3ad7e5b-f100-4dda-b8f6-71ddce3523f0,IP:0,URL
        :0,TC:0,Content:-25,EDM:0,RT:0,SF:95,FILE:0,BULK:0,RULE:Spam_GS981B3D,ACTI
        ON:quarantine,TS:70
X-CID-META: VersionHash:120426c,CLOUDID:69032829-564d-42d9-9875-7c868ee415ec,B
        ulkID:230322204557JQ9QSFXQ,BulkQuantity:0,Recheck:0,SF:38|29|28|17|19|48,T
        C:nil,Content:0,EDM:-3,IP:nil,URL:1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0
        ,OSI:0,OSA:0,AV:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-UUID: 7c7e39bec8af11eda9a90f0bb45854f4-20230322
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
        (envelope-from <mark-pk.tsai@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 585552375; Wed, 22 Mar 2023 20:45:55 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Wed, 22 Mar 2023 20:45:54 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.25 via Frontend Transport; Wed, 22 Mar 2023 20:45:53 +0800
From:   Mark-PK Tsai <mark-pk.tsai@mediatek.com>
To:     Marc Zyngier <maz@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Matthias Brugger <matthias.bgg@gmail.com>
CC:     Johan Hovold <johan+linaro@kernel.org>, <stable@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Mark-PK Tsai <mark-pk.tsai@mediatek.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>
Subject: [PATCH 5.4 2/3] irqdomain: Refactor __irq_domain_alloc_irqs()
Date:   Wed, 22 Mar 2023 20:45:49 +0800
Message-ID: <20230322124550.29812-2-mark-pk.tsai@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20230322124550.29812-1-mark-pk.tsai@mediatek.com>
References: <20230322124550.29812-1-mark-pk.tsai@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
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
Signed-off-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
---
 kernel/irq/irqdomain.c | 74 ++++++++++++++++++++++++------------------
 1 file changed, 42 insertions(+), 32 deletions(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 8d85eeb0f078..1eb34eaeaa94 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -1350,6 +1350,45 @@ int irq_domain_alloc_irqs_hierarchy(struct irq_domain *domain,
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
@@ -1376,7 +1415,7 @@ int __irq_domain_alloc_irqs(struct irq_domain *domain, int irq_base,
 			    unsigned int nr_irqs, int node, void *arg,
 			    bool realloc, const struct irq_affinity_desc *affinity)
 {
-	int i, ret, virq;
+	int ret;
 
 	if (domain == NULL) {
 		domain = irq_default_domain;
@@ -1384,40 +1423,11 @@ int __irq_domain_alloc_irqs(struct irq_domain *domain, int irq_base,
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
 
-- 
2.18.0

