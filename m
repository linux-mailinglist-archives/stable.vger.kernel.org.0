Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1A813CE44C
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235034AbhGSPnI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:43:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:37058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347441AbhGSPj3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:39:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4385613CC;
        Mon, 19 Jul 2021 16:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711548;
        bh=UNMGh7BrjFdAfggxkP1YPKCyMjYNDNniAFMx7BtSO6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zJsiniLCg8ecxZLAEpa9eTj8VbtORdEMh9q0zvYo4JC+Iv8FwMRp+Cj/e+LMEQFWD
         1LpI2jd82QGoWkRQ5DYer1DuvqAEotYMtcgshHj7DGlg6g10tCUQ6OMgVfFqePKYUI
         8zaz/86a+CeU4MxEPz11XKHNWep0nWh0byuBQQUA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sanjay Kumar <sanjay.k.kumar@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.12 011/292] iommu/vt-d: Global devTLB flush when present context entry changed
Date:   Mon, 19 Jul 2021 16:51:13 +0200
Message-Id: <20210719144942.902758713@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sanjay Kumar <sanjay.k.kumar@intel.com>

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
Link: https://lore.kernel.org/r/20210712071315.3416543-1-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/intel/iommu.c |   31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -2434,10 +2434,11 @@ __domain_mapping(struct dmar_domain *dom
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
@@ -2449,7 +2450,16 @@ static void domain_context_clear_one(str
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
@@ -2467,6 +2477,8 @@ static void domain_context_clear_one(str
 				 0,
 				 0,
 				 DMA_TLB_DSI_FLUSH);
+
+	__iommu_flush_dev_iotlb(info, 0, MAX_AGAW_PFN_WIDTH);
 }
 
 static inline void unlink_domain_info(struct device_domain_info *info)
@@ -4456,9 +4468,9 @@ out_free_dmar:
 
 static int domain_context_clear_one_cb(struct pci_dev *pdev, u16 alias, void *opaque)
 {
-	struct intel_iommu *iommu = opaque;
+	struct device_domain_info *info = opaque;
 
-	domain_context_clear_one(iommu, PCI_BUS_NUM(alias), alias & 0xff);
+	domain_context_clear_one(info, PCI_BUS_NUM(alias), alias & 0xff);
 	return 0;
 }
 
@@ -4468,12 +4480,13 @@ static int domain_context_clear_one_cb(s
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
@@ -4497,7 +4510,7 @@ static void __dmar_remove_one_dev_info(s
 
 		iommu_disable_dev_iotlb(info);
 		if (!dev_is_real_dma_subdevice(info->dev))
-			domain_context_clear(iommu, info->dev);
+			domain_context_clear(info);
 		intel_pasid_free_table(info->dev);
 	}
 


