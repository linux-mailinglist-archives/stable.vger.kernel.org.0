Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF4BE328A84
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:20:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239653AbhCASST (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:18:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:34036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239101AbhCASLp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:11:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B03E64DEE;
        Mon,  1 Mar 2021 17:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619077;
        bh=XpuIIt5tVi/1qFX4GjuPiteoy8HqO4ZifEwwwuaaDCE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SG+QFG1qfDHCtwLAGOXUAaZ065Yz6/rgUE7o0VYsE2ULl7cbajbtTLq1WWxhHQrOA
         ZTYBSy23LrDnVorABUIDs2rwzhrZGlhcs6QRMn8NMoM5ZUudT1fn1u7rl17nR3wuKT
         zYhMNl/cfVazcF4KIehyGoCSsRY9Qsj4pPKQMVoI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yong Wu <yong.wu@mediatek.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 322/663] iommu: Switch gather->end to the inclusive end
Date:   Mon,  1 Mar 2021 17:09:30 +0100
Message-Id: <20210301161157.779898055@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
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
index e634bbe605730..7067b7c116260 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2267,7 +2267,7 @@ static void arm_smmu_iotlb_sync(struct iommu_domain *domain,
 {
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
 
-	arm_smmu_tlb_inv_range(gather->start, gather->end - gather->start,
+	arm_smmu_tlb_inv_range(gather->start, gather->end - gather->start + 1,
 			       gather->pgsize, true, smmu_domain);
 }
 
diff --git a/drivers/iommu/mtk_iommu.c b/drivers/iommu/mtk_iommu.c
index c072cee532c20..19387d2bc4b4f 100644
--- a/drivers/iommu/mtk_iommu.c
+++ b/drivers/iommu/mtk_iommu.c
@@ -445,7 +445,7 @@ static void mtk_iommu_iotlb_sync(struct iommu_domain *domain,
 				 struct iommu_iotlb_gather *gather)
 {
 	struct mtk_iommu_data *data = mtk_iommu_get_m4u_data();
-	size_t length = gather->end - gather->start;
+	size_t length = gather->end - gather->start + 1;
 
 	if (gather->start == ULONG_MAX)
 		return;
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 9bbcfe3b0bb12..f11f5072af5dc 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -169,7 +169,7 @@ enum iommu_dev_features {
  * struct iommu_iotlb_gather - Range information for a pending IOTLB flush
  *
  * @start: IOVA representing the start of the range to be flushed
- * @end: IOVA representing the end of the range to be flushed (exclusive)
+ * @end: IOVA representing the end of the range to be flushed (inclusive)
  * @pgsize: The interval at which to perform the flush
  *
  * This structure is intended to be updated by multiple calls to the
@@ -536,7 +536,7 @@ static inline void iommu_iotlb_gather_add_page(struct iommu_domain *domain,
 					       struct iommu_iotlb_gather *gather,
 					       unsigned long iova, size_t size)
 {
-	unsigned long start = iova, end = start + size;
+	unsigned long start = iova, end = start + size - 1;
 
 	/*
 	 * If the new page is disjoint from the current range or is mapped at
-- 
2.27.0



