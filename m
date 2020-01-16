Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE0413F937
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:23:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729367AbgAPTXj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 14:23:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:36730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729764AbgAPQxI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:53:08 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E845B2464B;
        Thu, 16 Jan 2020 16:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193587;
        bh=dM6YCGFR8LGtdDt4WEBiP7jA3Tqp0lBg0x4uum5xhug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ioSCjPDvTZ+QdVQzvVyGaGGLol/zcdjDU5IknKwoNjkuihZ5KpZh873cn6qtHK4d/
         be521BgxxHpxsqfSWjbSx9bffZ2ydVCcEazGbK84r+4GyXiYRLN5TZIvKsf3xwdpsb
         TCxsqPbQWfPD2ciPmZVGL2qvLe+giBlwZWrYb1RY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yong Wu <yong.wu@mediatek.com>, Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>,
        iommu@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 128/205] iommu/mediatek: Add a new tlb_lock for tlb_flush
Date:   Thu, 16 Jan 2020 11:41:43 -0500
Message-Id: <20200116164300.6705-128-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yong Wu <yong.wu@mediatek.com>

[ Upstream commit da3cc91b8db403728cde03c8a95cba268d8cbf1b ]

The commit 4d689b619445 ("iommu/io-pgtable-arm-v7s: Convert to IOMMU API
TLB sync") help move the tlb_sync of unmap from v7s into the iommu
framework. It helps add a new function "mtk_iommu_iotlb_sync", But it
lacked the lock, then it will cause the variable "tlb_flush_active"
may be changed unexpectedly, we could see this warning log randomly:

mtk-iommu 10205000.iommu: Partial TLB flush timed out, falling back to
full flush

The HW requires tlb_flush/tlb_sync in pairs strictly, this patch adds
a new tlb_lock for tlb operations to fix this issue.

Fixes: 4d689b619445 ("iommu/io-pgtable-arm-v7s: Convert to IOMMU API TLB sync")
Signed-off-by: Yong Wu <yong.wu@mediatek.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/mtk_iommu.c | 23 ++++++++++++++++++++++-
 drivers/iommu/mtk_iommu.h |  1 +
 2 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/mtk_iommu.c b/drivers/iommu/mtk_iommu.c
index 76b9388cf689..c2f6c78fee44 100644
--- a/drivers/iommu/mtk_iommu.c
+++ b/drivers/iommu/mtk_iommu.c
@@ -219,22 +219,37 @@ static void mtk_iommu_tlb_sync(void *cookie)
 static void mtk_iommu_tlb_flush_walk(unsigned long iova, size_t size,
 				     size_t granule, void *cookie)
 {
+	struct mtk_iommu_data *data = cookie;
+	unsigned long flags;
+
+	spin_lock_irqsave(&data->tlb_lock, flags);
 	mtk_iommu_tlb_add_flush_nosync(iova, size, granule, false, cookie);
 	mtk_iommu_tlb_sync(cookie);
+	spin_unlock_irqrestore(&data->tlb_lock, flags);
 }
 
 static void mtk_iommu_tlb_flush_leaf(unsigned long iova, size_t size,
 				     size_t granule, void *cookie)
 {
+	struct mtk_iommu_data *data = cookie;
+	unsigned long flags;
+
+	spin_lock_irqsave(&data->tlb_lock, flags);
 	mtk_iommu_tlb_add_flush_nosync(iova, size, granule, true, cookie);
 	mtk_iommu_tlb_sync(cookie);
+	spin_unlock_irqrestore(&data->tlb_lock, flags);
 }
 
 static void mtk_iommu_tlb_flush_page_nosync(struct iommu_iotlb_gather *gather,
 					    unsigned long iova, size_t granule,
 					    void *cookie)
 {
+	struct mtk_iommu_data *data = cookie;
+	unsigned long flags;
+
+	spin_lock_irqsave(&data->tlb_lock, flags);
 	mtk_iommu_tlb_add_flush_nosync(iova, granule, granule, true, cookie);
+	spin_unlock_irqrestore(&data->tlb_lock, flags);
 }
 
 static const struct iommu_flush_ops mtk_iommu_flush_ops = {
@@ -453,7 +468,12 @@ static void mtk_iommu_flush_iotlb_all(struct iommu_domain *domain)
 static void mtk_iommu_iotlb_sync(struct iommu_domain *domain,
 				 struct iommu_iotlb_gather *gather)
 {
-	mtk_iommu_tlb_sync(mtk_iommu_get_m4u_data());
+	struct mtk_iommu_data *data = mtk_iommu_get_m4u_data();
+	unsigned long flags;
+
+	spin_lock_irqsave(&data->tlb_lock, flags);
+	mtk_iommu_tlb_sync(data);
+	spin_unlock_irqrestore(&data->tlb_lock, flags);
 }
 
 static phys_addr_t mtk_iommu_iova_to_phys(struct iommu_domain *domain,
@@ -733,6 +753,7 @@ static int mtk_iommu_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
+	spin_lock_init(&data->tlb_lock);
 	list_add_tail(&data->list, &m4ulist);
 
 	if (!iommu_present(&platform_bus_type))
diff --git a/drivers/iommu/mtk_iommu.h b/drivers/iommu/mtk_iommu.h
index fc0f16eabacd..8cae22de7663 100644
--- a/drivers/iommu/mtk_iommu.h
+++ b/drivers/iommu/mtk_iommu.h
@@ -58,6 +58,7 @@ struct mtk_iommu_data {
 	struct iommu_group		*m4u_group;
 	bool                            enable_4GB;
 	bool				tlb_flush_active;
+	spinlock_t			tlb_lock; /* lock for tlb range flush */
 
 	struct iommu_device		iommu;
 	const struct mtk_iommu_plat_data *plat_data;
-- 
2.20.1

