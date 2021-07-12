Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E07693C4F00
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244285AbhGLHWo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:22:44 -0400
Received: from mga03.intel.com ([134.134.136.65]:27677 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244466AbhGLHSY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:18:24 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10042"; a="209976150"
X-IronPort-AV: E=Sophos;i="5.84,232,1620716400"; 
   d="scan'208";a="209976150"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2021 00:15:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,232,1620716400"; 
   d="scan'208";a="491923307"
Received: from allen-box.sh.intel.com ([10.239.159.118])
  by FMSMGA003.fm.intel.com with ESMTP; 12 Jul 2021 00:15:20 -0700
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Sanjay Kumar <sanjay.k.kumar@intel.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH 1/1] iommu/vt-d: Global devTLB flush when present context entry changed
Date:   Mon, 12 Jul 2021 15:13:15 +0800
Message-Id: <20210712071315.3416543-1-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sanjay Kumar <sanjay.k.kumar@intel.com>

This fixes a bug in context cache clear operation. The code was not
following the correct invalidation flow. A global device TLB invalidation
should be added after the IOTLB invalidation. At the same time, it
uses the domain ID from the context entry. But in scalable mode, the
domain ID is in PASID table entry, not context entry.

Fixes: 7373a8cc38197 ("iommu/vt-d: Setup context and enable RID2PASID support")
Cc: stable@vger.kernel.org # v5.0+
Signed-off-by: Sanjay Kumar <sanjay.k.kumar@intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/iommu/intel/iommu.c | 31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index a6a07d985709..57270290d62b 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -2429,10 +2429,11 @@ __domain_mapping(struct dmar_domain *domain, unsigned long iov_pfn,
 	return 0;
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
@@ -2444,7 +2445,16 @@ static void domain_context_clear_one(struct intel_iommu *iommu, u8 bus, u8 devfn
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
@@ -2462,6 +2472,8 @@ static void domain_context_clear_one(struct intel_iommu *iommu, u8 bus, u8 devfn
 				 0,
 				 0,
 				 DMA_TLB_DSI_FLUSH);
+
+	__iommu_flush_dev_iotlb(info, 0, MAX_AGAW_PFN_WIDTH);
 }
 
 static inline void unlink_domain_info(struct device_domain_info *info)
@@ -4425,9 +4437,9 @@ int __init intel_iommu_init(void)
 
 static int domain_context_clear_one_cb(struct pci_dev *pdev, u16 alias, void *opaque)
 {
-	struct intel_iommu *iommu = opaque;
+	struct device_domain_info *info = opaque;
 
-	domain_context_clear_one(iommu, PCI_BUS_NUM(alias), alias & 0xff);
+	domain_context_clear_one(info, PCI_BUS_NUM(alias), alias & 0xff);
 	return 0;
 }
 
@@ -4437,12 +4449,13 @@ static int domain_context_clear_one_cb(struct pci_dev *pdev, u16 alias, void *op
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
@@ -4466,7 +4479,7 @@ static void __dmar_remove_one_dev_info(struct device_domain_info *info)
 
 		iommu_disable_dev_iotlb(info);
 		if (!dev_is_real_dma_subdevice(info->dev))
-			domain_context_clear(iommu, info->dev);
+			domain_context_clear(info);
 		intel_pasid_free_table(info->dev);
 	}
 
-- 
2.25.1

