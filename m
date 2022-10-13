Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F04825FD03F
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbiJMAZP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231274AbiJMAYM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:24:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BA2A12347F;
        Wed, 12 Oct 2022 17:23:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 68D30616D7;
        Thu, 13 Oct 2022 00:19:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35890C433D6;
        Thu, 13 Oct 2022 00:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620355;
        bh=aZVzA0Fqpt2J+xf2p0wOtv5uyqkIk7yWq6pL5/lVCu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pgd77Yc81eRuHEuv0XQ5Yo3nTY0ApHP5olaxZcK5Y/S4PZJrMYL/jnPdF5eJRueYq
         6P7r7pSJdADBZtdY01llRprSgJxI1Q7kHvdvQ7Cn8yE9fO+9k3Rco2PJcosm/sXp74
         IKhE3af6oGK3apeuBUxd6FAfOEYZ4C6JShBVgWc1Gl+vRhUKg8zOD52g2zlrMykmCD
         bdaa0DN+vyY/hxw5mBz86BsRnFcseFZ8UG5Blbkjs2TPkAtK3tpIUH6hEUS73N2/cD
         QzgzDlRwdmckXZjWLJPXkpn9e1W9b2cW1sx8HbQitJEFwkT/KQcisBh27ufrWFvMc8
         buuNgFQDMtOpA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yicong Yang <yangyicong@hisilicon.com>,
        Will Deacon <will@kernel.org>,
        John Garry <john.garry@huawei.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Sasha Levin <sashal@kernel.org>, joro@8bytes.org,
        robin.murphy@arm.com, baolu.lu@linux.intel.com, jgg@ziepe.ca,
        tglx@linutronix.de, shameerali.kolothum.thodi@huawei.com,
        christophe.jaillet@wanadoo.fr,
        linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev
Subject: [PATCH AUTOSEL 5.19 13/63] iommu/arm-smmu-v3: Make default domain type of HiSilicon PTT device to identity
Date:   Wed, 12 Oct 2022 20:17:47 -0400
Message-Id: <20221013001842.1893243-13-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013001842.1893243-1-sashal@kernel.org>
References: <20221013001842.1893243-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yicong Yang <yangyicong@hisilicon.com>

[ Upstream commit 24b6c7798a0122012ca848ea0d25e973334266b0 ]

The DMA operations of HiSilicon PTT device can only work properly with
identical mappings. So add a quirk for the device to force the domain
as passthrough.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
Reviewed-by: John Garry <john.garry@huawei.com>
Link: https://lore.kernel.org/r/20220816114414.4092-2-yangyicong@huawei.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 88817a3376ef..e119ff8396c9 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2839,6 +2839,26 @@ static int arm_smmu_dev_disable_feature(struct device *dev,
 	}
 }
 
+/*
+ * HiSilicon PCIe tune and trace device can be used to trace TLP headers on the
+ * PCIe link and save the data to memory by DMA. The hardware is restricted to
+ * use identity mapping only.
+ */
+#define IS_HISI_PTT_DEVICE(pdev)	((pdev)->vendor == PCI_VENDOR_ID_HUAWEI && \
+					 (pdev)->device == 0xa12e)
+
+static int arm_smmu_def_domain_type(struct device *dev)
+{
+	if (dev_is_pci(dev)) {
+		struct pci_dev *pdev = to_pci_dev(dev);
+
+		if (IS_HISI_PTT_DEVICE(pdev))
+			return IOMMU_DOMAIN_IDENTITY;
+	}
+
+	return 0;
+}
+
 static struct iommu_ops arm_smmu_ops = {
 	.capable		= arm_smmu_capable,
 	.domain_alloc		= arm_smmu_domain_alloc,
@@ -2856,6 +2876,7 @@ static struct iommu_ops arm_smmu_ops = {
 	.sva_unbind		= arm_smmu_sva_unbind,
 	.sva_get_pasid		= arm_smmu_sva_get_pasid,
 	.page_response		= arm_smmu_page_response,
+	.def_domain_type	= arm_smmu_def_domain_type,
 	.pgsize_bitmap		= -1UL, /* Restricted during device attach */
 	.owner			= THIS_MODULE,
 	.default_domain_ops = &(const struct iommu_domain_ops) {
-- 
2.35.1

