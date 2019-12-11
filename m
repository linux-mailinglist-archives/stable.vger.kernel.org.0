Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1D1511B0E2
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732884AbfLKP0x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:26:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:60306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732720AbfLKP0w (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:26:52 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 748F422B48;
        Wed, 11 Dec 2019 15:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576078012;
        bh=dAvEyrdOLPuy69abLBwLiuLHza6QgT3/miqzjjbp3oE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oCZkrgaf1vwUj/GKrLsb+40dLV+61nOZT58IpjYT08qD8qmDOwCMym1Dhhv9y1R2U
         Ee8b9q/KD2hxd6f8yjZo7X6lSt7ZPmXDMuqgonULtrhoYkI5hA+DXfMQAWJh2Bbxrg
         hy5BS4hSJ6NDpBCFl9D2aAlGgIc6xZNDryMRoZmU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thierry Reding <treding@nvidia.com>,
        Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>,
        iommu@lists.linux-foundation.org, linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 07/79] iommu/tegra-smmu: Fix page tables in > 4 GiB memory
Date:   Wed, 11 Dec 2019 10:25:31 -0500
Message-Id: <20191211152643.23056-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211152643.23056-1-sashal@kernel.org>
References: <20191211152643.23056-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 121d3cb7ddd1d..fa0ecb5e63809 100644
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

