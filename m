Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5191E37C996
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236357AbhELQUD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:20:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:49994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234307AbhELQMs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:12:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD51B61C7C;
        Wed, 12 May 2021 15:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834088;
        bh=xlZDCrVuwIRGk9bmR4x3SXOUr2DedVW93YyQogKMnV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=walgWPWuTZW2nm83yxEaH4Tgi/T9kh2nwJGvMlhgJctQ1rk91Ee9EaUhPZ+LO+W8u
         V4BTEm5Ush7+WrWjU0D7CZ2bIimMfcfJIMxNC9tmuG+sJladH5kNw9LUX+7atjWJqz
         Voo4a6fvPI/LLJ3VHgpIBqplTfC2iaMkSKEabMwk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lianbo Jiang <lijiang@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 402/601] dma-iommu: use static-key to minimize the impact in the fast-path
Date:   Wed, 12 May 2021 16:47:59 +0200
Message-Id: <20210512144841.050590456@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lianbo Jiang <lijiang@redhat.com>

[ Upstream commit a8e8af35c9f4f75f981a95488c7066d31bac4bef ]

Let's move out the is_kdump_kernel() check from iommu_dma_deferred_attach()
to iommu_dma_init(), and use the static-key in the fast-path to minimize
the impact in the normal case.

Co-developed-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Lianbo Jiang <lijiang@redhat.com>
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/20210126115337.20068-2-lijiang@redhat.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/dma-iommu.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 00fbc591a142..07e7b2f3ba27 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -51,6 +51,8 @@ struct iommu_dma_cookie {
 	struct iommu_domain		*fq_domain;
 };
 
+static DEFINE_STATIC_KEY_FALSE(iommu_deferred_attach_enabled);
+
 void iommu_dma_free_cpu_cached_iovas(unsigned int cpu,
 		struct iommu_domain *domain)
 {
@@ -389,9 +391,6 @@ static int iommu_dma_deferred_attach(struct device *dev,
 {
 	const struct iommu_ops *ops = domain->ops;
 
-	if (!is_kdump_kernel())
-		return 0;
-
 	if (unlikely(ops->is_attach_deferred &&
 			ops->is_attach_deferred(domain, dev)))
 		return iommu_attach_device(domain, dev);
@@ -536,7 +535,8 @@ static dma_addr_t __iommu_dma_map(struct device *dev, phys_addr_t phys,
 	size_t iova_off = iova_offset(iovad, phys);
 	dma_addr_t iova;
 
-	if (unlikely(iommu_dma_deferred_attach(dev, domain)))
+	if (static_branch_unlikely(&iommu_deferred_attach_enabled) &&
+	    iommu_dma_deferred_attach(dev, domain))
 		return DMA_MAPPING_ERROR;
 
 	size = iova_align(iovad, size + iova_off);
@@ -694,7 +694,8 @@ static void *iommu_dma_alloc_remap(struct device *dev, size_t size,
 
 	*dma_handle = DMA_MAPPING_ERROR;
 
-	if (unlikely(iommu_dma_deferred_attach(dev, domain)))
+	if (static_branch_unlikely(&iommu_deferred_attach_enabled) &&
+	    iommu_dma_deferred_attach(dev, domain))
 		return NULL;
 
 	min_size = alloc_sizes & -alloc_sizes;
@@ -977,7 +978,8 @@ static int iommu_dma_map_sg(struct device *dev, struct scatterlist *sg,
 	unsigned long mask = dma_get_seg_boundary(dev);
 	int i;
 
-	if (unlikely(iommu_dma_deferred_attach(dev, domain)))
+	if (static_branch_unlikely(&iommu_deferred_attach_enabled) &&
+	    iommu_dma_deferred_attach(dev, domain))
 		return 0;
 
 	if (!(attrs & DMA_ATTR_SKIP_CPU_SYNC))
@@ -1425,6 +1427,9 @@ void iommu_dma_compose_msi_msg(struct msi_desc *desc,
 
 static int iommu_dma_init(void)
 {
+	if (is_kdump_kernel())
+		static_branch_enable(&iommu_deferred_attach_enabled);
+
 	return iova_cache_get();
 }
 arch_initcall(iommu_dma_init);
-- 
2.30.2



