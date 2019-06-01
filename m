Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A19EB31D82
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729150AbfFAN3P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:29:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:57534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729884AbfFAN1B (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 09:27:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B2D8273D1;
        Sat,  1 Jun 2019 13:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395620;
        bh=WiKANmaMlD3Gbk6YfVehwxHNLtkVsP/TGQIBMtp9hHM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hhJN/2yDRlJ1qOdAIyyRp1YQk7JDG9NPoXJ3Ps9mTXNVww/WPDBulonK0HryJ9ff3
         3sjdX3XRGy9wOA64lTrKlGbshb3iyGzEluPzS/xQexsjLZXl67tJvBch1bxdLRK0vH
         gzodJO7gnnFfCUUy6Yah8Csx6bJNmYXTl3fV7BlI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Osipenko <digetx@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>, linux-tegra@vger.kernel.org,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 4.4 34/56] iommu/tegra-smmu: Fix invalid ASID bits on Tegra30/114
Date:   Sat,  1 Jun 2019 09:25:38 -0400
Message-Id: <20190601132600.27427-34-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601132600.27427-1-sashal@kernel.org>
References: <20190601132600.27427-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

[ Upstream commit 43a0541e312f7136e081e6bf58f6c8a2e9672688 ]

Both Tegra30 and Tegra114 have 4 ASID's and the corresponding bitfield of
the TLB_FLUSH register differs from later Tegra generations that have 128
ASID's.

In a result the PTE's are now flushed correctly from TLB and this fixes
problems with graphics (randomly failing tests) on Tegra30.

Cc: stable <stable@vger.kernel.org>
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/tegra-smmu.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
index 9305964250aca..c4eb293b15242 100644
--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@ -91,7 +91,6 @@ static inline u32 smmu_readl(struct tegra_smmu *smmu, unsigned long offset)
 #define  SMMU_TLB_FLUSH_VA_MATCH_ALL     (0 << 0)
 #define  SMMU_TLB_FLUSH_VA_MATCH_SECTION (2 << 0)
 #define  SMMU_TLB_FLUSH_VA_MATCH_GROUP   (3 << 0)
-#define  SMMU_TLB_FLUSH_ASID(x)          (((x) & 0x7f) << 24)
 #define  SMMU_TLB_FLUSH_VA_SECTION(addr) ((((addr) & 0xffc00000) >> 12) | \
 					  SMMU_TLB_FLUSH_VA_MATCH_SECTION)
 #define  SMMU_TLB_FLUSH_VA_GROUP(addr)   ((((addr) & 0xffffc000) >> 12) | \
@@ -194,8 +193,12 @@ static inline void smmu_flush_tlb_asid(struct tegra_smmu *smmu,
 {
 	u32 value;
 
-	value = SMMU_TLB_FLUSH_ASID_MATCH | SMMU_TLB_FLUSH_ASID(asid) |
-		SMMU_TLB_FLUSH_VA_MATCH_ALL;
+	if (smmu->soc->num_asids == 4)
+		value = (asid & 0x3) << 29;
+	else
+		value = (asid & 0x7f) << 24;
+
+	value |= SMMU_TLB_FLUSH_ASID_MATCH | SMMU_TLB_FLUSH_VA_MATCH_ALL;
 	smmu_writel(smmu, value, SMMU_TLB_FLUSH);
 }
 
@@ -205,8 +208,12 @@ static inline void smmu_flush_tlb_section(struct tegra_smmu *smmu,
 {
 	u32 value;
 
-	value = SMMU_TLB_FLUSH_ASID_MATCH | SMMU_TLB_FLUSH_ASID(asid) |
-		SMMU_TLB_FLUSH_VA_SECTION(iova);
+	if (smmu->soc->num_asids == 4)
+		value = (asid & 0x3) << 29;
+	else
+		value = (asid & 0x7f) << 24;
+
+	value |= SMMU_TLB_FLUSH_ASID_MATCH | SMMU_TLB_FLUSH_VA_SECTION(iova);
 	smmu_writel(smmu, value, SMMU_TLB_FLUSH);
 }
 
@@ -216,8 +223,12 @@ static inline void smmu_flush_tlb_group(struct tegra_smmu *smmu,
 {
 	u32 value;
 
-	value = SMMU_TLB_FLUSH_ASID_MATCH | SMMU_TLB_FLUSH_ASID(asid) |
-		SMMU_TLB_FLUSH_VA_GROUP(iova);
+	if (smmu->soc->num_asids == 4)
+		value = (asid & 0x3) << 29;
+	else
+		value = (asid & 0x7f) << 24;
+
+	value |= SMMU_TLB_FLUSH_ASID_MATCH | SMMU_TLB_FLUSH_VA_GROUP(iova);
 	smmu_writel(smmu, value, SMMU_TLB_FLUSH);
 }
 
-- 
2.20.1

