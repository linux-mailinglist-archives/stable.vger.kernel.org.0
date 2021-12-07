Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9BB46BA30
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 12:38:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231238AbhLGLl7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 06:41:59 -0500
Received: from mailgw01.mediatek.com ([60.244.123.138]:59212 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S235776AbhLGLl6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 06:41:58 -0500
X-UUID: c1d2d3faf55548ef827f6e6e2d90f71d-20211207
X-UUID: c1d2d3faf55548ef827f6e6e2d90f71d-20211207
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw01.mediatek.com
        (envelope-from <yf.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 686929266; Tue, 07 Dec 2021 19:38:24 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Tue, 7 Dec 2021 19:38:22 +0800
Received: from mbjsdccf07.mediatek.inc (10.15.20.246) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 7 Dec 2021 19:38:21 +0800
From:   <yf.wang@mediatek.com>
To:     <will@kernel.org>
CC:     <Guangming.Cao@mediatek.com>, <Libo.Kang@mediatek.com>,
        <iommu@lists.linux-foundation.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <matthias.bgg@gmail.com>,
        <robin.murphy@arm.com>, <wsd_upstream@mediatek.com>,
        <yf.wang@mediatek.com>, <stable@vger.kernel.org>
Subject: [PATCH v3] iommu/io-pgtable-arm-v7s: Add error handle for page table allocation failure
Date:   Tue, 7 Dec 2021 19:33:15 +0800
Message-ID: <20211207113315.29109-1-yf.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20211207094817.GA31382@willie-the-truck>
References: <20211207094817.GA31382@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yunfei Wang <yf.wang@mediatek.com>

In __arm_v7s_alloc_table function:
iommu call kmem_cache_alloc to allocate page table, this function
allocate memory may fail, when kmem_cache_alloc fails to allocate
table, call virt_to_phys will be abnomal and return unexpected phys
and goto out_free, then call kmem_cache_free to release table will
trigger KE, __get_free_pages and free_pages have similar problem,
so add error handle for page table allocation failure.

Fixes: 29859aeb8a6ea ("iommu/io-pgtable-arm-v7s: Abort allocation when table address overflows the PTE")
Signed-off-by: Yunfei Wang <yf.wang@mediatek.com>
Cc: <stable@vger.kernel.org> # 5.10.*
---
v3: Update patch
    1. Remove unnecessary log print as suggested by Will.
    2. Remove unnecessary condition check.
v2: Cc stable@vger.kernel.org
    1. This patch needs to be merged stable branch, add stable@vger.kernel.org
       in mail list.
    2. There is No new code change in v2.

---
 drivers/iommu/io-pgtable-arm-v7s.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/io-pgtable-arm-v7s.c b/drivers/iommu/io-pgtable-arm-v7s.c
index bfb6acb651e5..be066c1503d3 100644
--- a/drivers/iommu/io-pgtable-arm-v7s.c
+++ b/drivers/iommu/io-pgtable-arm-v7s.c
@@ -246,13 +246,17 @@ static void *__arm_v7s_alloc_table(int lvl, gfp_t gfp,
 			__GFP_ZERO | ARM_V7S_TABLE_GFP_DMA, get_order(size));
 	else if (lvl == 2)
 		table = kmem_cache_zalloc(data->l2_tables, gfp);
+
+	if (!table)
+		return NULL;
+
 	phys = virt_to_phys(table);
 	if (phys != (arm_v7s_iopte)phys) {
 		/* Doesn't fit in PTE */
 		dev_err(dev, "Page table does not fit in PTE: %pa", &phys);
 		goto out_free;
 	}
-	if (table && !cfg->coherent_walk) {
+	if (!cfg->coherent_walk) {
 		dma = dma_map_single(dev, table, size, DMA_TO_DEVICE);
 		if (dma_mapping_error(dev, dma))
 			goto out_free;
-- 
2.18.0

