Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC6C65828C
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:38:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231680AbiL1QiK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:38:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234810AbiL1QhH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:37:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D881B16
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:33:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE05261541
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:33:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0C2DC433EF;
        Wed, 28 Dec 2022 16:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245194;
        bh=FTfFEAqRyYqCK5F9fTmFa+b+MvSP0d1BLJiJKPPu/zs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HAIczoC4rcnINX5DlP92OrLdoINNWojo04+BqcnMvuLC1igQ0exDGpdoRlCLcm6ls
         vq/qBazPzWNRRzeLkm9pXoH2j4DQtT2rJ9Mm0Ynu/0DFVJRjM2IMRyBMCs5c1JAtmN
         tZOkCp+ceEXWon9vdVOQxlwo2VRJvTcBvKI2RVCw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jernej Skrabec <jernej.skrabec@gmail.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0813/1146] iommu/sun50i: Implement .iotlb_sync_map
Date:   Wed, 28 Dec 2022 15:39:12 +0100
Message-Id: <20221228144352.236097833@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jernej Skrabec <jernej.skrabec@gmail.com>

[ Upstream commit e563cc0c787c85a4d9def0a77078dc5d3f445e3d ]

Allocated iova ranges need to be invalidated immediately or otherwise
they might or might not work when used by master or CPU. This was
discovered when running video decoder conformity test with Cedrus. Some
videos were now and then decoded incorrectly and generated page faults.

According to vendor driver, it's enough to invalidate just start and end
TLB and PTW cache lines. Documentation says that neighbouring lines must
be invalidated too. Finally, when page fault occurs, that iova must be
invalidated the same way, according to documentation.

Fixes: 4100b8c229b3 ("iommu: Add Allwinner H6 IOMMU driver")
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://lore.kernel.org/r/20221025165415.307591-6-jernej.skrabec@gmail.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/sun50i-iommu.c | 73 ++++++++++++++++++++++++++++++++++++
 1 file changed, 73 insertions(+)

diff --git a/drivers/iommu/sun50i-iommu.c b/drivers/iommu/sun50i-iommu.c
index e62e245060ac..5cb2d44dfb92 100644
--- a/drivers/iommu/sun50i-iommu.c
+++ b/drivers/iommu/sun50i-iommu.c
@@ -93,6 +93,8 @@
 #define NUM_PT_ENTRIES			256
 #define PT_SIZE				(NUM_PT_ENTRIES * PT_ENTRY_SIZE)
 
+#define SPAGE_SIZE			4096
+
 struct sun50i_iommu {
 	struct iommu_device iommu;
 
@@ -295,6 +297,62 @@ static void sun50i_table_flush(struct sun50i_iommu_domain *sun50i_domain,
 	dma_sync_single_for_device(iommu->dev, dma, size, DMA_TO_DEVICE);
 }
 
+static void sun50i_iommu_zap_iova(struct sun50i_iommu *iommu,
+				  unsigned long iova)
+{
+	u32 reg;
+	int ret;
+
+	iommu_write(iommu, IOMMU_TLB_IVLD_ADDR_REG, iova);
+	iommu_write(iommu, IOMMU_TLB_IVLD_ADDR_MASK_REG, GENMASK(31, 12));
+	iommu_write(iommu, IOMMU_TLB_IVLD_ENABLE_REG,
+		    IOMMU_TLB_IVLD_ENABLE_ENABLE);
+
+	ret = readl_poll_timeout_atomic(iommu->base + IOMMU_TLB_IVLD_ENABLE_REG,
+					reg, !reg, 1, 2000);
+	if (ret)
+		dev_warn(iommu->dev, "TLB invalidation timed out!\n");
+}
+
+static void sun50i_iommu_zap_ptw_cache(struct sun50i_iommu *iommu,
+				       unsigned long iova)
+{
+	u32 reg;
+	int ret;
+
+	iommu_write(iommu, IOMMU_PC_IVLD_ADDR_REG, iova);
+	iommu_write(iommu, IOMMU_PC_IVLD_ENABLE_REG,
+		    IOMMU_PC_IVLD_ENABLE_ENABLE);
+
+	ret = readl_poll_timeout_atomic(iommu->base + IOMMU_PC_IVLD_ENABLE_REG,
+					reg, !reg, 1, 2000);
+	if (ret)
+		dev_warn(iommu->dev, "PTW cache invalidation timed out!\n");
+}
+
+static void sun50i_iommu_zap_range(struct sun50i_iommu *iommu,
+				   unsigned long iova, size_t size)
+{
+	assert_spin_locked(&iommu->iommu_lock);
+
+	iommu_write(iommu, IOMMU_AUTO_GATING_REG, 0);
+
+	sun50i_iommu_zap_iova(iommu, iova);
+	sun50i_iommu_zap_iova(iommu, iova + SPAGE_SIZE);
+	if (size > SPAGE_SIZE) {
+		sun50i_iommu_zap_iova(iommu, iova + size);
+		sun50i_iommu_zap_iova(iommu, iova + size + SPAGE_SIZE);
+	}
+	sun50i_iommu_zap_ptw_cache(iommu, iova);
+	sun50i_iommu_zap_ptw_cache(iommu, iova + SZ_1M);
+	if (size > SZ_1M) {
+		sun50i_iommu_zap_ptw_cache(iommu, iova + size);
+		sun50i_iommu_zap_ptw_cache(iommu, iova + size + SZ_1M);
+	}
+
+	iommu_write(iommu, IOMMU_AUTO_GATING_REG, IOMMU_AUTO_GATING_ENABLE);
+}
+
 static int sun50i_iommu_flush_all_tlb(struct sun50i_iommu *iommu)
 {
 	u32 reg;
@@ -344,6 +402,18 @@ static void sun50i_iommu_flush_iotlb_all(struct iommu_domain *domain)
 	spin_unlock_irqrestore(&iommu->iommu_lock, flags);
 }
 
+static void sun50i_iommu_iotlb_sync_map(struct iommu_domain *domain,
+					unsigned long iova, size_t size)
+{
+	struct sun50i_iommu_domain *sun50i_domain = to_sun50i_domain(domain);
+	struct sun50i_iommu *iommu = sun50i_domain->iommu;
+	unsigned long flags;
+
+	spin_lock_irqsave(&iommu->iommu_lock, flags);
+	sun50i_iommu_zap_range(iommu, iova, size);
+	spin_unlock_irqrestore(&iommu->iommu_lock, flags);
+}
+
 static void sun50i_iommu_iotlb_sync(struct iommu_domain *domain,
 				    struct iommu_iotlb_gather *gather)
 {
@@ -767,6 +837,7 @@ static const struct iommu_ops sun50i_iommu_ops = {
 		.attach_dev	= sun50i_iommu_attach_device,
 		.detach_dev	= sun50i_iommu_detach_device,
 		.flush_iotlb_all = sun50i_iommu_flush_iotlb_all,
+		.iotlb_sync_map = sun50i_iommu_iotlb_sync_map,
 		.iotlb_sync	= sun50i_iommu_iotlb_sync,
 		.iova_to_phys	= sun50i_iommu_iova_to_phys,
 		.map		= sun50i_iommu_map,
@@ -786,6 +857,8 @@ static void sun50i_iommu_report_fault(struct sun50i_iommu *iommu,
 		report_iommu_fault(iommu->domain, iommu->dev, iova, prot);
 	else
 		dev_err(iommu->dev, "Page fault while iommu not attached to any domain?\n");
+
+	sun50i_iommu_zap_range(iommu, iova, SPAGE_SIZE);
 }
 
 static phys_addr_t sun50i_iommu_handle_pt_irq(struct sun50i_iommu *iommu,
-- 
2.35.1



