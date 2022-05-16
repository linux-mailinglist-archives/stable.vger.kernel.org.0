Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82D5F529004
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234923AbiEPUJI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:09:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350586AbiEPUBX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 16:01:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EC9149FAB;
        Mon, 16 May 2022 12:55:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19C4160FE1;
        Mon, 16 May 2022 19:55:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 244CDC34100;
        Mon, 16 May 2022 19:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730934;
        bh=EdXBI+t7Z+CJBmYfgvbfu0giiu3XH2CkqB+Azf5RDVQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r/VEIrEqUznK1kLupwjdiq8pOIBsOQJ7v3ERT/Rfd26O3xPaxQig6h8yS8NSJiQB+
         aKFEsBSfknV/uS4nSwCRHIgrOay1l6hsF6p7orUIYepjQTWkDvaBns8RzMNR+n6ndg
         7CCSPCHVjLegH2HEyqoOqVu931HEmI7AY0c/qBQc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
        Krishna Reddy <vdumpa@nvidia.com>,
        Pritesh Raithatha <praithatha@nvidia.com>,
        Ashish Mhetre <amhetre@nvidia.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 052/114] iommu: arm-smmu: disable large page mappings for Nvidia arm-smmu
Date:   Mon, 16 May 2022 21:36:26 +0200
Message-Id: <20220516193626.988968670@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193625.489108457@linuxfoundation.org>
References: <20220516193625.489108457@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ashish Mhetre <amhetre@nvidia.com>

[ Upstream commit 4a25f2ea0e030b2fc852c4059a50181bfc5b2f57 ]

Tegra194 and Tegra234 SoCs have the erratum that causes walk cache
entries to not be invalidated correctly. The problem is that the walk
cache index generated for IOVA is not same across translation and
invalidation requests. This is leading to page faults when PMD entry is
released during unmap and populated with new PTE table during subsequent
map request. Disabling large page mappings avoids the release of PMD
entry and avoid translations seeing stale PMD entry in walk cache.
Fix this by limiting the page mappings to PAGE_SIZE for Tegra194 and
Tegra234 devices. This is recommended fix from Tegra hardware design
team.

Acked-by: Robin Murphy <robin.murphy@arm.com>
Reviewed-by: Krishna Reddy <vdumpa@nvidia.com>
Co-developed-by: Pritesh Raithatha <praithatha@nvidia.com>
Signed-off-by: Pritesh Raithatha <praithatha@nvidia.com>
Signed-off-by: Ashish Mhetre <amhetre@nvidia.com>
Link: https://lore.kernel.org/r/20220421081504.24678-1-amhetre@nvidia.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu/arm-smmu-nvidia.c | 30 ++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu-nvidia.c b/drivers/iommu/arm/arm-smmu/arm-smmu-nvidia.c
index 01e9b50b10a1..87bf522b9d2e 100644
--- a/drivers/iommu/arm/arm-smmu/arm-smmu-nvidia.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu-nvidia.c
@@ -258,6 +258,34 @@ static void nvidia_smmu_probe_finalize(struct arm_smmu_device *smmu, struct devi
 			dev_name(dev), err);
 }
 
+static int nvidia_smmu_init_context(struct arm_smmu_domain *smmu_domain,
+				    struct io_pgtable_cfg *pgtbl_cfg,
+				    struct device *dev)
+{
+	struct arm_smmu_device *smmu = smmu_domain->smmu;
+	const struct device_node *np = smmu->dev->of_node;
+
+	/*
+	 * Tegra194 and Tegra234 SoCs have the erratum that causes walk cache
+	 * entries to not be invalidated correctly. The problem is that the walk
+	 * cache index generated for IOVA is not same across translation and
+	 * invalidation requests. This is leading to page faults when PMD entry
+	 * is released during unmap and populated with new PTE table during
+	 * subsequent map request. Disabling large page mappings avoids the
+	 * release of PMD entry and avoid translations seeing stale PMD entry in
+	 * walk cache.
+	 * Fix this by limiting the page mappings to PAGE_SIZE on Tegra194 and
+	 * Tegra234.
+	 */
+	if (of_device_is_compatible(np, "nvidia,tegra234-smmu") ||
+	    of_device_is_compatible(np, "nvidia,tegra194-smmu")) {
+		smmu->pgsize_bitmap = PAGE_SIZE;
+		pgtbl_cfg->pgsize_bitmap = smmu->pgsize_bitmap;
+	}
+
+	return 0;
+}
+
 static const struct arm_smmu_impl nvidia_smmu_impl = {
 	.read_reg = nvidia_smmu_read_reg,
 	.write_reg = nvidia_smmu_write_reg,
@@ -268,10 +296,12 @@ static const struct arm_smmu_impl nvidia_smmu_impl = {
 	.global_fault = nvidia_smmu_global_fault,
 	.context_fault = nvidia_smmu_context_fault,
 	.probe_finalize = nvidia_smmu_probe_finalize,
+	.init_context = nvidia_smmu_init_context,
 };
 
 static const struct arm_smmu_impl nvidia_smmu_single_impl = {
 	.probe_finalize = nvidia_smmu_probe_finalize,
+	.init_context = nvidia_smmu_init_context,
 };
 
 struct arm_smmu_device *nvidia_smmu_impl_init(struct arm_smmu_device *smmu)
-- 
2.35.1



