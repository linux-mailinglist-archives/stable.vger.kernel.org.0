Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD6D1FE737
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729567AbgFRCje (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:39:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:41966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729032AbgFRBNC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:13:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E4E5214DB;
        Thu, 18 Jun 2020 01:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442782;
        bh=ogNUmHb4ecHAb3xp0gFwbZJRDxgJbUk5Zy0HwUo3QbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iomfH5F2e1MPXSIL4LniY2fzXvlFgV9CjbLYokI+7d0Zle+cUGZMnlbRSgZLYctW5
         gUnNj+Nl1CHvljDckwDNQdZ/1jvYj9C2bTb8UcPmShXG87SGa6TMicPyCUIFXxROYD
         7G9juesyDK2VyOvhvdphGbM6yOod/jUQQa6CTdT8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.7 227/388] iommu/arm-smmu-v3: Don't reserve implementation defined register space
Date:   Wed, 17 Jun 2020 21:05:24 -0400
Message-Id: <20200618010805.600873-227-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jean-Philippe Brucker <jean-philippe@linaro.org>

[ Upstream commit 52f3fab0067d6fa9e99c1b7f63265dd48ca76046 ]

Some SMMUv3 implementation embed the Perf Monitor Group Registers (PMCG)
inside the first 64kB region of the SMMU. Since PMCG are managed by a
separate driver, this layout causes resource reservation conflicts
during boot.

To avoid this conflict, don't reserve the MMIO regions that are
implementation defined. Although devm_ioremap_resource() still works on
full pages under the hood, this way we benefit from resource conflict
checks.

Fixes: 7d839b4b9e00 ("perf/smmuv3: Add arm64 smmuv3 pmu driver")
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/20200513110255.597203-1-jean-philippe@linaro.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm-smmu-v3.c | 35 +++++++++++++++++++++++++++++++----
 1 file changed, 31 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/arm-smmu-v3.c b/drivers/iommu/arm-smmu-v3.c
index 82508730feb7..af21d24a09e8 100644
--- a/drivers/iommu/arm-smmu-v3.c
+++ b/drivers/iommu/arm-smmu-v3.c
@@ -171,6 +171,8 @@
 #define ARM_SMMU_PRIQ_IRQ_CFG1		0xd8
 #define ARM_SMMU_PRIQ_IRQ_CFG2		0xdc
 
+#define ARM_SMMU_REG_SZ			0xe00
+
 /* Common MSI config fields */
 #define MSI_CFG0_ADDR_MASK		GENMASK_ULL(51, 2)
 #define MSI_CFG2_SH			GENMASK(5, 4)
@@ -628,6 +630,7 @@ struct arm_smmu_strtab_cfg {
 struct arm_smmu_device {
 	struct device			*dev;
 	void __iomem			*base;
+	void __iomem			*page1;
 
 #define ARM_SMMU_FEAT_2_LVL_STRTAB	(1 << 0)
 #define ARM_SMMU_FEAT_2_LVL_CDTAB	(1 << 1)
@@ -733,9 +736,8 @@ static struct arm_smmu_option_prop arm_smmu_options[] = {
 static inline void __iomem *arm_smmu_page1_fixup(unsigned long offset,
 						 struct arm_smmu_device *smmu)
 {
-	if ((offset > SZ_64K) &&
-	    (smmu->options & ARM_SMMU_OPT_PAGE0_REGS_ONLY))
-		offset -= SZ_64K;
+	if (offset > SZ_64K)
+		return smmu->page1 + offset - SZ_64K;
 
 	return smmu->base + offset;
 }
@@ -4021,6 +4023,18 @@ err_reset_pci_ops: __maybe_unused;
 	return err;
 }
 
+static void __iomem *arm_smmu_ioremap(struct device *dev, resource_size_t start,
+				      resource_size_t size)
+{
+	struct resource res = {
+		.flags = IORESOURCE_MEM,
+		.start = start,
+		.end = start + size - 1,
+	};
+
+	return devm_ioremap_resource(dev, &res);
+}
+
 static int arm_smmu_device_probe(struct platform_device *pdev)
 {
 	int irq, ret;
@@ -4056,10 +4070,23 @@ static int arm_smmu_device_probe(struct platform_device *pdev)
 	}
 	ioaddr = res->start;
 
-	smmu->base = devm_ioremap_resource(dev, res);
+	/*
+	 * Don't map the IMPLEMENTATION DEFINED regions, since they may contain
+	 * the PMCG registers which are reserved by the PMU driver.
+	 */
+	smmu->base = arm_smmu_ioremap(dev, ioaddr, ARM_SMMU_REG_SZ);
 	if (IS_ERR(smmu->base))
 		return PTR_ERR(smmu->base);
 
+	if (arm_smmu_resource_size(smmu) > SZ_64K) {
+		smmu->page1 = arm_smmu_ioremap(dev, ioaddr + SZ_64K,
+					       ARM_SMMU_REG_SZ);
+		if (IS_ERR(smmu->page1))
+			return PTR_ERR(smmu->page1);
+	} else {
+		smmu->page1 = smmu->base;
+	}
+
 	/* Interrupt lines */
 
 	irq = platform_get_irq_byname_optional(pdev, "combined");
-- 
2.25.1

