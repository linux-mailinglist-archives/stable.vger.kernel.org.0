Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C7BC3CD07A
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 11:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235235AbhGSIik (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 04:38:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:47228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234826AbhGSIik (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 04:38:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6B576023B;
        Mon, 19 Jul 2021 09:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626686359;
        bh=1SvdO3a/uYISyIszGzvuYxmwv6TuxmV0Pmc2p9VWywQ=;
        h=Subject:To:Cc:From:Date:From;
        b=TKRoEQbSkGBB7EmZFGT68i2lAFNByl2S/j+669IqgpzD7OdIyuBD69fDC5jQ3gY53
         fWh4tAZCHLaBEgjM0YKtsLuXW53SG0bzcmZa2YXQWYcIJEZwJqRt0R6ZCYowz8gXSQ
         Fy6lKShB5NSjrCbiLWKzPTNFwfk3RwQrnXfW5SaQ=
Subject: FAILED: patch "[PATCH] iommu/vt-d: Global devTLB flush when present context entry" failed to apply to 5.4-stable tree
To:     sanjay.k.kumar@intel.com, baolu.lu@linux.intel.com, jroedel@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 19 Jul 2021 11:19:16 +0200
Message-ID: <162668635611645@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 37764b952e1b39053defc7ebe5dcd8c4e3e78de9 Mon Sep 17 00:00:00 2001
From: Sanjay Kumar <sanjay.k.kumar@intel.com>
Date: Mon, 12 Jul 2021 15:13:15 +0800
Subject: [PATCH] iommu/vt-d: Global devTLB flush when present context entry
 changed

This fixes a bug in context cache clear operation. The code was not
following the correct invalidation flow. A global device TLB invalidation
should be added after the IOTLB invalidation. At the same time, it
uses the domain ID from the context entry. But in scalable mode, the
domain ID is in PASID table entry, not context entry.

Fixes: 7373a8cc38197 ("iommu/vt-d: Setup context and enable RID2PASID support")
Cc: stable@vger.kernel.org # v5.0+
Signed-off-by: Sanjay Kumar <sanjay.k.kumar@intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20210712071315.3416543-1-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>

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
 

