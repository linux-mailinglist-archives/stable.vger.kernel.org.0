Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBD314C80BA
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 03:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbiCACGL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 21:06:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230378AbiCACGK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 21:06:10 -0500
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2D6B265;
        Mon, 28 Feb 2022 18:05:24 -0800 (PST)
X-UUID: a86095ea6c7f416fbb5dcb9564fb2e7c-20220301
X-UUID: a86095ea6c7f416fbb5dcb9564fb2e7c-20220301
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw02.mediatek.com
        (envelope-from <yf.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 741999193; Tue, 01 Mar 2022 10:05:21 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Tue, 1 Mar 2022 10:05:19 +0800
Received: from mbjsdccf07.mediatek.inc (10.15.20.246) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 1 Mar 2022 10:05:19 +0800
From:   <yf.wang@mediatek.com>
To:     <yf.wang@mediatek.com>
CC:     <Libo.Kang@mediatek.com>, <Ning.Li@mediatek.com>,
        <Yong.Wu@mediatek.com>, <iommu@lists.linux-foundation.org>,
        <joro@8bytes.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <matthias.bgg@gmail.com>,
        <will@kernel.org>, <wsd_upstream@mediatek.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v2] iommu/iova: Reset max32_alloc_size after cleaning rcache in the fail path
Date:   Tue, 1 Mar 2022 09:59:19 +0800
Message-ID: <20220301015919.5116-1-yf.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20220301014246.5011-1-yf.wang@mediatek.com>
References: <20220301014246.5011-1-yf.wang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yunfei Wang <yf.wang@mediatek.com>

In alloc_iova_fast function, if __alloc_and_insert_iova_range fail,
alloc_iova_fast will try flushing rcache and retry alloc iova, but
this has an issue:

Since __alloc_and_insert_iova_range fail will set the current alloc
iova size to max32_alloc_size (iovad->max32_alloc_size = size),
when the retry is executed into the __alloc_and_insert_iova_range
function, the retry action will be blocked by the check condition
(size >= iovad->max32_alloc_size) and goto iova32_full directly,
causes the action of retry regular alloc iova in
__alloc_and_insert_iova_range to not actually be executed.

Based on the above, so need reset max32_alloc_size before retry alloc
iova when alloc iova fail, that is set the initial dma_32bit_pfn value
of iovad to max32_alloc_size, so that the action of retry alloc iova
in __alloc_and_insert_iova_range can be executed.

Signed-off-by: Yunfei Wang <yf.wang@mediatek.com>
Cc: <stable@vger.kernel.org> # 5.10.*
---
v2: Cc stable@vger.kernel.org
    1. This patch needs to be merged stable branch, add stable@vger.kernel.org
       in mail list.

---
 drivers/iommu/iova.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/iommu/iova.c b/drivers/iommu/iova.c
index b28c9435b898..0c085ae8293f 100644
--- a/drivers/iommu/iova.c
+++ b/drivers/iommu/iova.c
@@ -453,6 +453,7 @@ alloc_iova_fast(struct iova_domain *iovad, unsigned long size,
 retry:
 	new_iova = alloc_iova(iovad, size, limit_pfn, true);
 	if (!new_iova) {
+		unsigned long flags;
 		unsigned int cpu;
 
 		if (!flush_rcache)
@@ -463,6 +464,12 @@ alloc_iova_fast(struct iova_domain *iovad, unsigned long size,
 		for_each_online_cpu(cpu)
 			free_cpu_cached_iovas(cpu, iovad);
 		free_global_cached_iovas(iovad);
+
+		/* Reset max32_alloc_size after flushing rcache for retry */
+		spin_lock_irqsave(&iovad->iova_rbtree_lock, flags);
+		iovad->max32_alloc_size = iovad->dma_32bit_pfn;
+		spin_unlock_irqrestore(&iovad->iova_rbtree_lock, flags);
+
 		goto retry;
 	}
 
-- 
2.18.0

