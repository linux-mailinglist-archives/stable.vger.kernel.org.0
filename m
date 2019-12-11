Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 157C611A09A
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 02:41:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbfLKBlQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 20:41:16 -0500
Received: from mga05.intel.com ([192.55.52.43]:31308 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726417AbfLKBlQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 20:41:16 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Dec 2019 17:41:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,301,1571727600"; 
   d="scan'208";a="238371606"
Received: from allen-box.sh.intel.com ([10.239.159.136])
  by fmsmga004.fm.intel.com with ESMTP; 10 Dec 2019 17:41:14 -0800
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>
Cc:     ashok.raj@intel.com, jacob.jun.pan@intel.com, kevin.tian@intel.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Jerry Snitselaar <jsnitsel@redhat.com>, stable@vger.kernel.org
Subject: [PATCH 1/1] iommu/vt-d: Fix dmar pte read access not set error
Date:   Wed, 11 Dec 2019 09:40:15 +0800
Message-Id: <20191211014015.7898-1-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If the default DMA domain of a group doesn't fit a device, it
will still sit in the group but use a private identity domain.
When map/unmap/iova_to_phys come through iommu API, the driver
should still serve them, otherwise, other devices in the same
group will be impacted. Since identity domain has been mapped
with the whole available memory space and RMRRs, we don't need
to worry about the impact on it.

Link: https://www.spinics.net/lists/iommu/msg40416.html
Cc: Jerry Snitselaar <jsnitsel@redhat.com>
Reported-by: Jerry Snitselaar <jsnitsel@redhat.com>
Fixes: 942067f1b6b97 ("iommu/vt-d: Identify default domains replaced with private")
Cc: stable@vger.kernel.org # v5.3+
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/iommu/intel-iommu.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 0c8d81f56a30..b73bebea9148 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -5478,9 +5478,6 @@ static int intel_iommu_map(struct iommu_domain *domain,
 	int prot = 0;
 	int ret;
 
-	if (dmar_domain->flags & DOMAIN_FLAG_LOSE_CHILDREN)
-		return -EINVAL;
-
 	if (iommu_prot & IOMMU_READ)
 		prot |= DMA_PTE_READ;
 	if (iommu_prot & IOMMU_WRITE)
@@ -5523,8 +5520,6 @@ static size_t intel_iommu_unmap(struct iommu_domain *domain,
 	/* Cope with horrid API which requires us to unmap more than the
 	   size argument if it happens to be a large-page mapping. */
 	BUG_ON(!pfn_to_dma_pte(dmar_domain, iova >> VTD_PAGE_SHIFT, &level));
-	if (dmar_domain->flags & DOMAIN_FLAG_LOSE_CHILDREN)
-		return 0;
 
 	if (size < VTD_PAGE_SIZE << level_to_offset_bits(level))
 		size = VTD_PAGE_SIZE << level_to_offset_bits(level);
@@ -5556,9 +5551,6 @@ static phys_addr_t intel_iommu_iova_to_phys(struct iommu_domain *domain,
 	int level = 0;
 	u64 phys = 0;
 
-	if (dmar_domain->flags & DOMAIN_FLAG_LOSE_CHILDREN)
-		return 0;
-
 	pte = pfn_to_dma_pte(dmar_domain, iova >> VTD_PAGE_SHIFT, &level);
 	if (pte)
 		phys = dma_pte_addr(pte);
-- 
2.17.1

