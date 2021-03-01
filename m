Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69566328DF6
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:22:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241300AbhCATVc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:21:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:43778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241183AbhCATPS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:15:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 684B5650D7;
        Mon,  1 Mar 2021 17:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621075;
        bh=ci08ei5HyH+4qDC5W+RSA4UAYoxmUtuJQLi2txTgwHo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DxNk+EIohUIBhf1QxWjsubNTX419Bv4pw89m0ZLLk4yb2oi7sfvQCX/mqYyrb+Oq0
         kW2bk2Q0p1N0oTyfVAqtNeXWtQPiRRBde2yK6+sPmyQq+7jlJIQpZxQJSlg3CDyn+4
         fFEdawpJgHxRFwjIE3Hg0wiJKxHGydz2KQyO7tUA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yong Wu <yong.wu@mediatek.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 384/775] iommu: Switch gather->end to the inclusive end
Date:   Mon,  1 Mar 2021 17:09:12 +0100
Message-Id: <20210301161220.581538444@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yong Wu <yong.wu@mediatek.com>

[ Upstream commit 862c3715de8f3e5350489240c951d697f04bd8c9 ]

Currently gather->end is "unsigned long" which may be overflow in
arch32 in the corner case: 0xfff00000 + 0x100000(iova + size).
Although it doesn't affect the size(end - start), it affects the checking
"gather->end < end"

This patch changes this "end" to the real end address
(end = start + size - 1). Correspondingly, update the length to
"end - start + 1".

Fixes: a7d20dc19d9e ("iommu: Introduce struct iommu_iotlb_gather for batching TLB flushes")
Signed-off-by: Yong Wu <yong.wu@mediatek.com>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Acked-by: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20210107122909.16317-5-yong.wu@mediatek.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 2 +-
 drivers/iommu/mtk_iommu.c                   | 2 +-
 include/linux/iommu.h                       | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 8ca7415d785d9..c70d6e79f5346 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2280,7 +2280,7 @@ static void arm_smmu_iotlb_sync(struct iommu_domain *domain,
 {
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
 
-	arm_smmu_tlb_inv_range(gather->start, gather->end - gather->start,
+	arm_smmu_tlb_inv_range(gather->start, gather->end - gather->start + 1,
 			       gather->pgsize, true, smmu_domain);
 }
 
diff --git a/drivers/iommu/mtk_iommu.c b/drivers/iommu/mtk_iommu.c
index 8e56cec532e71..bfe6ec329f8d5 100644
--- a/drivers/iommu/mtk_iommu.c
+++ b/drivers/iommu/mtk_iommu.c
@@ -444,7 +444,7 @@ static void mtk_iommu_iotlb_sync(struct iommu_domain *domain,
 				 struct iommu_iotlb_gather *gather)
 {
 	struct mtk_iommu_data *data = mtk_iommu_get_m4u_data();
-	size_t length = gather->end - gather->start;
+	size_t length = gather->end - gather->start + 1;
 
 	if (gather->start == ULONG_MAX)
 		return;
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index efa96263b81b3..d63d3e9cc7b67 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -170,7 +170,7 @@ enum iommu_dev_features {
  * struct iommu_iotlb_gather - Range information for a pending IOTLB flush
  *
  * @start: IOVA representing the start of the range to be flushed
- * @end: IOVA representing the end of the range to be flushed (exclusive)
+ * @end: IOVA representing the end of the range to be flushed (inclusive)
  * @pgsize: The interval at which to perform the flush
  *
  * This structure is intended to be updated by multiple calls to the
@@ -538,7 +538,7 @@ static inline void iommu_iotlb_gather_add_page(struct iommu_domain *domain,
 					       struct iommu_iotlb_gather *gather,
 					       unsigned long iova, size_t size)
 {
-	unsigned long start = iova, end = start + size;
+	unsigned long start = iova, end = start + size - 1;
 
 	/*
 	 * If the new page is disjoint from the current range or is mapped at
-- 
2.27.0



