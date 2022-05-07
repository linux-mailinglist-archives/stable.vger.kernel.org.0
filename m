Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 836D451E5C4
	for <lists+stable@lfdr.de>; Sat,  7 May 2022 10:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231486AbiEGJCf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 May 2022 05:02:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbiEGJCe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 May 2022 05:02:34 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A67F24BC3;
        Sat,  7 May 2022 01:58:43 -0700 (PDT)
X-UUID: ded7c836f5874ba3ac180d82108dc4dd-20220507
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.4,REQID:0020efbe-81ad-4a91-9245-e6a6010afc93,OB:0,LO
        B:0,IP:0,URL:8,TC:0,Content:-20,EDM:0,RT:0,SF:0,FILE:0,RULE:Release_Ham,AC
        TION:release,TS:-12
X-CID-META: VersionHash:faefae9,CLOUDID:c82cebb2-56b5-4c9e-8d83-0070b288eb6a,C
        OID:IGNORED,Recheck:0,SF:nil,TC:nil,Content:0,EDM:-3,File:nil,QS:0,BEC:nil
X-UUID: ded7c836f5874ba3ac180d82108dc4dd-20220507
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw01.mediatek.com
        (envelope-from <yf.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 620380499; Sat, 07 May 2022 16:58:38 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Sat, 7 May 2022 16:58:37 +0800
Received: from mbjsdccf07.mediatek.inc (10.15.20.246) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sat, 7 May 2022 16:58:35 +0800
From:   <yf.wang@mediatek.com>
To:     Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        "Matthias Brugger" <matthias.bgg@gmail.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        "open list:IOMMU DRIVERS" <iommu@lists.linux-foundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
CC:     <wsd_upstream@mediatek.com>, Libo Kang <Libo.Kang@mediatek.com>,
        Yong Wu <yong.wu@mediatek.com>, Ning Li <Ning.Li@mediatek.com>,
        Yunfei Wang <yf.wang@mediatek.com>, <stable@vger.kernel.org>
Subject: [PATCH] iommu/dma: Fix iova map result check bug
Date:   Sat, 7 May 2022 16:52:03 +0800
Message-ID: <20220507085204.16914-1-yf.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,MAY_BE_FORGED,
        SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR,UNPARSEABLE_RELAY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yunfei Wang <yf.wang@mediatek.com>

The data type of the return value of the iommu_map_sg_atomic
is ssize_t, but the data type of iova size is size_t,
e.g. one is int while the other is unsigned int.

When iommu_map_sg_atomic return value is compared with iova size,
it will force the signed int to be converted to unsigned int, if
iova map fails and iommu_map_sg_atomic return error code is less
than 0, then (ret < iova_len) is false, which will to cause not
do free iova, and the master can still successfully get the iova
of map fail, which is not expected.

Therefore, we need to check the return value of iommu_map_sg_atomic
in two cases according to whether it is less than 0.

Fixes: ad8f36e4b6b1 ("iommu: return full error code from iommu_map_sg[_atomic]()")
Signed-off-by: Yunfei Wang <yf.wang@mediatek.com>
Cc: <stable@vger.kernel.org> # 5.15.*
---
 drivers/iommu/dma-iommu.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 09f6e1c0f9c0..2932281e93fc 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -776,6 +776,7 @@ static struct page **__iommu_dma_alloc_noncontiguous(struct device *dev,
 	unsigned int count, min_size, alloc_sizes = domain->pgsize_bitmap;
 	struct page **pages;
 	dma_addr_t iova;
+	ssize_t ret;
 
 	if (static_branch_unlikely(&iommu_deferred_attach_enabled) &&
 	    iommu_deferred_attach(dev, domain))
@@ -813,8 +814,8 @@ static struct page **__iommu_dma_alloc_noncontiguous(struct device *dev,
 			arch_dma_prep_coherent(sg_page(sg), sg->length);
 	}
 
-	if (iommu_map_sg_atomic(domain, iova, sgt->sgl, sgt->orig_nents, ioprot)
-			< size)
+	ret = iommu_map_sg_atomic(domain, iova, sgt->sgl, sgt->orig_nents, ioprot);
+	if (ret < 0 || ret < size)
 		goto out_free_sg;
 
 	sgt->sgl->dma_address = iova;
@@ -1209,7 +1210,7 @@ static int iommu_dma_map_sg(struct device *dev, struct scatterlist *sg,
 	 * implementation - it knows better than we do.
 	 */
 	ret = iommu_map_sg_atomic(domain, iova, sg, nents, prot);
-	if (ret < iova_len)
+	if (ret < 0 || ret < iova_len)
 		goto out_free_iova;
 
 	return __finalise_sg(dev, sg, nents, iova);
-- 
2.18.0

