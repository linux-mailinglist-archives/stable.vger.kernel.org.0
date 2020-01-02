Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2A712F0C3
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:55:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728574AbgABWT0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:19:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:35568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728177AbgABWTZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:19:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DA3A227BF;
        Thu,  2 Jan 2020 22:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003565;
        bh=nNRpDmLVOlsxrpWf8bBYPJj4c6rbcEi2jILm3nqp3FM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MGGFrhZWNo53L3fMtpvVhEZL6XZlSZUS8hU5jPW+prLLJ206xvecr4IsSJXlH8pjb
         j8NYdKDMEpkn+vxaifxOdhFoGyuJXiOn6lmclLK7wSq9Wq5IiBIQ25dsa5Tj9C1XHl
         xc9cGhDrtNLchFvswU/WwpuSH44rzJ2T8fNhnR+Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thierry Reding <treding@nvidia.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 007/114] iommu/tegra-smmu: Fix page tables in > 4 GiB memory
Date:   Thu,  2 Jan 2020 23:06:19 +0100
Message-Id: <20200102220029.908670741@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220029.183913184@linuxfoundation.org>
References: <20200102220029.183913184@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

[ Upstream commit 96d3ab802e4930a29a33934373157d6dff1b2c7e ]

Page tables that reside in physical memory beyond the 4 GiB boundary are
currently not working properly. The reason is that when the physical
address for page directory entries is read, it gets truncated at 32 bits
and can cause crashes when passing that address to the DMA API.

Fix this by first casting the PDE value to a dma_addr_t and then using
the page frame number mask for the SMMU instance to mask out the invalid
bits, which are typically used for mapping attributes, etc.

Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/tegra-smmu.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
index 121d3cb7ddd1..fa0ecb5e6380 100644
--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@ -164,9 +164,9 @@ static bool smmu_dma_addr_valid(struct tegra_smmu *smmu, dma_addr_t addr)
 	return (addr & smmu->pfn_mask) == addr;
 }
 
-static dma_addr_t smmu_pde_to_dma(u32 pde)
+static dma_addr_t smmu_pde_to_dma(struct tegra_smmu *smmu, u32 pde)
 {
-	return pde << 12;
+	return (dma_addr_t)(pde & smmu->pfn_mask) << 12;
 }
 
 static void smmu_flush_ptc_all(struct tegra_smmu *smmu)
@@ -551,6 +551,7 @@ static u32 *tegra_smmu_pte_lookup(struct tegra_smmu_as *as, unsigned long iova,
 				  dma_addr_t *dmap)
 {
 	unsigned int pd_index = iova_pd_index(iova);
+	struct tegra_smmu *smmu = as->smmu;
 	struct page *pt_page;
 	u32 *pd;
 
@@ -559,7 +560,7 @@ static u32 *tegra_smmu_pte_lookup(struct tegra_smmu_as *as, unsigned long iova,
 		return NULL;
 
 	pd = page_address(as->pd);
-	*dmap = smmu_pde_to_dma(pd[pd_index]);
+	*dmap = smmu_pde_to_dma(smmu, pd[pd_index]);
 
 	return tegra_smmu_pte_offset(pt_page, iova);
 }
@@ -601,7 +602,7 @@ static u32 *as_get_pte(struct tegra_smmu_as *as, dma_addr_t iova,
 	} else {
 		u32 *pd = page_address(as->pd);
 
-		*dmap = smmu_pde_to_dma(pd[pde]);
+		*dmap = smmu_pde_to_dma(smmu, pd[pde]);
 	}
 
 	return tegra_smmu_pte_offset(as->pts[pde], iova);
@@ -626,7 +627,7 @@ static void tegra_smmu_pte_put_use(struct tegra_smmu_as *as, unsigned long iova)
 	if (--as->count[pde] == 0) {
 		struct tegra_smmu *smmu = as->smmu;
 		u32 *pd = page_address(as->pd);
-		dma_addr_t pte_dma = smmu_pde_to_dma(pd[pde]);
+		dma_addr_t pte_dma = smmu_pde_to_dma(smmu, pd[pde]);
 
 		tegra_smmu_set_pde(as, iova, 0);
 
-- 
2.20.1



