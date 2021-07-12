Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6A63C4F37
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241505AbhGLHXh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:23:37 -0400
Received: from mga11.intel.com ([192.55.52.93]:22116 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242256AbhGLHWK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:22:10 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10042"; a="206920443"
X-IronPort-AV: E=Sophos;i="5.84,232,1620716400"; 
   d="scan'208";a="206920443"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2021 00:19:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,232,1620716400"; 
   d="scan'208";a="491924237"
Received: from allen-box.sh.intel.com ([10.239.159.118])
  by FMSMGA003.fm.intel.com with ESMTP; 12 Jul 2021 00:19:18 -0700
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Sanjay Kumar <sanjay.k.kumar@intel.com>,
        Jon Derrick <jonathan.derrick@intel.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Lu Baolu <baolu.lu@linux.intel.com>, stable@vger.kernel.org
Subject: [PATCH 1/1] iommu/vt-d: Fix clearing real DMA device's scalable-mode context entries
Date:   Mon, 12 Jul 2021 15:17:12 +0800
Message-Id: <20210712071712.3416949-1-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The commit 2b0140c69637e ("iommu/vt-d: Use pci_real_dma_dev() for mapping")
fixes an issue of "sub-device is removed where the context entry is cleared
for all aliases". But this commit didn't consider the PASID entry and PASID
table in VT-d scalable mode. This fix increases the coverage of scalable
mode.

Suggested-by: Sanjay Kumar <sanjay.k.kumar@intel.com>
Fixes: 8038bdb855331 ("iommu/vt-d: Only clear real DMA device's context entries")
Fixes: 2b0140c69637e ("iommu/vt-d: Use pci_real_dma_dev() for mapping")
Cc: stable@vger.kernel.org # v5.6+
Cc: Jon Derrick <jonathan.derrick@intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/iommu/intel/iommu.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 57270290d62b..dd22fc7d5176 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4472,14 +4472,13 @@ static void __dmar_remove_one_dev_info(struct device_domain_info *info)
 	iommu = info->iommu;
 	domain = info->domain;
 
-	if (info->dev) {
+	if (info->dev && !dev_is_real_dma_subdevice(info->dev)) {
 		if (dev_is_pci(info->dev) && sm_supported(iommu))
 			intel_pasid_tear_down_entry(iommu, info->dev,
 					PASID_RID2PASID, false);
 
 		iommu_disable_dev_iotlb(info);
-		if (!dev_is_real_dma_subdevice(info->dev))
-			domain_context_clear(info);
+		domain_context_clear(info);
 		intel_pasid_free_table(info->dev);
 	}
 
-- 
2.25.1

