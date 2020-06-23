Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35261205BB3
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 21:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733248AbgFWTWE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 15:22:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:34347 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733220AbgFWTWE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 15:22:04 -0400
IronPort-SDR: kJQ0tppP9lr8wjJoKMUDSgrbtaHdnCmpYlS3A5HXZ/IluBEGOsrO73XjymSQdT4pHkMAceOmwn
 I0St15xsZn/g==
X-IronPort-AV: E=McAfee;i="6000,8403,9661"; a="145686254"
X-IronPort-AV: E=Sophos;i="5.75,272,1589266800"; 
   d="scan'208";a="145686254"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2020 12:22:03 -0700
IronPort-SDR: lCuLdn9rA7mtIMiJxDIHnwvTXqypMEzT5bGyPlv9cNPGKBsilxrZ9hg9Pv5jqkWVQP3WFw816S
 7h1RTmeFuhyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,272,1589266800"; 
   d="scan'208";a="423123618"
Received: from unknown (HELO skalakox.lm.intel.com) ([10.232.116.60])
  by orsmga004.jf.intel.com with ESMTP; 23 Jun 2020 12:22:01 -0700
From:   Sushma Kalakota <sushmax.kalakota@intel.com>
To:     stable@vger.kernel.org
Cc:     Jon Derrick <jonathan.derrick@intel.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sushma Kalakota <sushmax.kalakota@intel.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH] iommu/vt-d: Remove real DMA lookup in find_domain
Date:   Tue, 23 Jun 2020 13:27:33 -0600
Message-Id: <20200623192733.2560-1-sushmax.kalakota@intel.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jon Derrick <jonathan.derrick@intel.com>

commit 	bba9cc2cf82840bd3c9b3f4f7edac2dc8329ci241 upstream

By removing the real DMA indirection in find_domain(), we can allow
sub-devices of a real DMA device to have their own valid
device_domain_info. The dmar lookup and context entry removal paths have
been fixed to account for sub-devices.

Fixes: 2b0140c69637 ("iommu/vt-d: Use pci_real_dma_dev() for mapping")
Signed-off-by: Jon Derrick <jonathan.derrick@intel.com>
Acked-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20200527165617.297470-4-jonathan.derrick@intel.com
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=207575
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sushma Kalakota <sushmax.kalakota@intel.com>
---
Hi,

Please apply this patch to 5.7 (and 5.6 if it's still being maintained).
This patch is part 3 of a 3-patch series, of which [1][2] have been
applied to 5.7. This patch is necessary to prevent kernel panics in
specific configurations.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=8038bdb8553313ad53bfcffcf8294dd0ab44618f
[2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=4fda230ecddc2573ed88632e98b69b0b9b68c0ad

 drivers/iommu/intel-iommu.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 11ed871dd255..fde7aba49b74 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -2518,9 +2518,6 @@ struct dmar_domain *find_domain(struct device *dev)
 	if (unlikely(attach_deferred(dev) || iommu_dummy(dev)))
 		return NULL;
 
-	if (dev_is_pci(dev))
-		dev = &pci_real_dma_dev(to_pci_dev(dev))->dev;
-
 	/* No lock here, assumes no domain exit in normal case */
 	info = dev->archdata.iommu;
 	if (likely(info))
-- 
2.17.1

