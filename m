Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0399551D734
	for <lists+stable@lfdr.de>; Fri,  6 May 2022 14:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391600AbiEFMEv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 May 2022 08:04:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383527AbiEFMEs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 May 2022 08:04:48 -0400
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5920E1D30F
        for <stable@vger.kernel.org>; Fri,  6 May 2022 05:01:05 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R381e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=llfl@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0VCRjzom_1651838462;
Received: from localhost(mailfrom:llfl@linux.alibaba.com fp:SMTPD_---0VCRjzom_1651838462)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 06 May 2022 20:01:02 +0800
From:   "Kun(llfl)" <llfl@linux.alibaba.com>
To:     Jiangbo Wu <jiangbo.wu@intel.com>
Cc:     Xu Yu <xuyu@linux.alibaba.com>, Kun <llfl@linux.alibaba.com>,
        Sanjay Kumar <sanjay.k.kumar@intel.com>,
        stable@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH 05/19] iommu/vt-d: Global devTLB flush when present context entry changed
Date:   Fri,  6 May 2022 20:00:43 +0800
Message-Id: <20220506120057.77320-5-llfl@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
In-Reply-To: <20220506120057.77320-1-llfl@linux.alibaba.com>
References: <20220506120057.77320-1-llfl@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sanjay Kumar <sanjay.k.kumar@intel.com>

ANBZ: #1105

commit 37764b952e1b39053defc7ebe5dcd8c4e3e78de9 upstream.

This fixes a bug in context cache clear operation. The code was not
following the correct invalidation flow. A global device TLB invalidation
should be added after the IOTLB invalidation. At the same time, it
uses the domain ID from the context entry. But in scalable mode, the
domain ID is in PASID table entry, not context entry.

Fixes: 7373a8cc38197 ("iommu/vt-d: Setup context and enable RID2PASID support")
Cc: stable@vger.kernel.org # v5.0+
Signed-off-by: Sanjay Kumar <sanjay.k.kumar@intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Kun(llfl) <llfl@linux.alibaba.com>
---
 drivers/iommu/intel/iommu.c | 31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index a5160d350f91..1a0027da6dad 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -2527,10 +2527,11 @@ static inline int domain_pfn_mapping(struct dmar_domain *domain, unsigned long i
 	return domain_mapping(domain, iov_pfn, NULL, phys_pfn, nr_pages, prot);
 }
 
-static void domain_context_clear_one(struct intel_iommu *iommu, u8 bus, u8 devfn)
+static void domain_context_clear_one(struct device_domain_info *info, u8 bus, u8 devfn)
 {
-	unsigned long flags;
+	struct intel_iommu *iommu = info->iommu;
 	struct context_entry *context;
+	unsigned long flags;
 	u16 did_old;
 
 	if (!iommu)
@@ -2542,7 +2543,16 @@ static void domain_context_clear_one(struct intel_iommu *iommu, u8 bus, u8 devfn
 		spin_unlock_irqrestore(&iommu->lock, flags);
 		return;
 	}
-	did_old = context_domain_id(context);
+
+	if (sm_supported(iommu)) {
+		if (hw_pass_through && domain_type_is_si(info->domain))
+			did_old = FLPT_DEFAULT_DID;
+		else
+			did_old = info->domain->iommu_did[iommu->seq_id];
+	} else {
+		did_old = context_domain_id(context);
+	}
+
 	context_clear_entry(context);
 	__iommu_flush_cache(iommu, context, sizeof(*context));
 	spin_unlock_irqrestore(&iommu->lock, flags);
@@ -2560,6 +2570,8 @@ static void domain_context_clear_one(struct intel_iommu *iommu, u8 bus, u8 devfn
 				 0,
 				 0,
 				 DMA_TLB_DSI_FLUSH);
+
+	__iommu_flush_dev_iotlb(info, 0, MAX_AGAW_PFN_WIDTH);
 }
 
 static inline void unlink_domain_info(struct device_domain_info *info)
@@ -5079,9 +5091,9 @@ int __init intel_iommu_init(void)
 
 static int domain_context_clear_one_cb(struct pci_dev *pdev, u16 alias, void *opaque)
 {
-	struct intel_iommu *iommu = opaque;
+	struct device_domain_info *info = opaque;
 
-	domain_context_clear_one(iommu, PCI_BUS_NUM(alias), alias & 0xff);
+	domain_context_clear_one(info, PCI_BUS_NUM(alias), alias & 0xff);
 	return 0;
 }
 
@@ -5091,12 +5103,13 @@ static int domain_context_clear_one_cb(struct pci_dev *pdev, u16 alias, void *op
  * devices, unbinding the driver from any one of them will possibly leave
  * the others unable to operate.
  */
-static void domain_context_clear(struct intel_iommu *iommu, struct device *dev)
+static void domain_context_clear(struct device_domain_info *info)
 {
-	if (!iommu || !dev || !dev_is_pci(dev))
+	if (!info->iommu || !info->dev || !dev_is_pci(info->dev))
 		return;
 
-	pci_for_each_dma_alias(to_pci_dev(dev), &domain_context_clear_one_cb, iommu);
+	pci_for_each_dma_alias(to_pci_dev(info->dev),
+			       &domain_context_clear_one_cb, info);
 }
 
 static void __dmar_remove_one_dev_info(struct device_domain_info *info)
@@ -5120,7 +5133,7 @@ static void __dmar_remove_one_dev_info(struct device_domain_info *info)
 
 		iommu_disable_dev_iotlb(info);
 		if (!dev_is_real_dma_subdevice(info->dev))
-			domain_context_clear(iommu, info->dev);
+			domain_context_clear(info);
 		intel_pasid_free_table(info->dev);
 	}
 
-- 
2.32.0 (Apple Git-132)

