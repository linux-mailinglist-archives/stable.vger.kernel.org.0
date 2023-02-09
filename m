Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E60FC690F8A
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 18:49:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbjBIRt6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 12:49:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjBIRt5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 12:49:57 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D721BE39F;
        Thu,  9 Feb 2023 09:49:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675964996; x=1707500996;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=GwZqwD+2jAddPIK4L4H7lS4Vi9Kqr7gLONerEQg6hm8=;
  b=ETYsttPvPM6Pp0d2x/nEtNpvBQuXWJnLUDo1w31A2gED/Nr2Nb4h+PGM
   c4MVzC0p33M944UFIuhv31dnBoNKL52T2EcVpVN+8pBU8TTQCAD270CgY
   W6aRDgwPRR2GVikpmwUqOUrkP+JIqK5Jxcma3Mb0pqNHeF8U+ca1TvkoV
   yUlbrQwPYIk+RbqXBWPViMNH7xf9Jenqumtp1L2TCinj5kzutEN66IwZS
   jHprny3u2rZAHAAtuG470PP1jfIG+LaZDzwchvVwKg1gahbGAka1rUFoN
   W0Psyzv40B7kH1CoRkVXS19PjgPlWAvQ1ibeXfUOrJRCBMjwEpRNRYUi/
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="416412326"
X-IronPort-AV: E=Sophos;i="5.97,284,1669104000"; 
   d="scan'208";a="416412326"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2023 09:49:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="810466350"
X-IronPort-AV: E=Sophos;i="5.97,284,1669104000"; 
   d="scan'208";a="810466350"
Received: from srinivas-otcpl-7600.jf.intel.com (HELO jacob-builder.jf.intel.com) ([10.54.39.106])
  by fmsmga001.fm.intel.com with ESMTP; 09 Feb 2023 09:49:54 -0800
From:   Jacob Pan <jacob.jun.pan@linux.intel.com>
To:     LKML <linux-kernel@vger.kernel.org>, iommu@lists.linux.dev,
        "Lu Baolu" <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     "Robin Murphy" <robin.murphy@arm.com>,
        "Will Deacon" <will@kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Raj Ashok <ashok.raj@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>, Yi Liu <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        stable@vger.kernel.org, Sanjay Kumar <sanjay.k.kumar@intel.com>
Subject: [PATCH v3] iommu/vt-d: Avoid superfluous IOTLB tracking in lazy mode
Date:   Thu,  9 Feb 2023 09:53:30 -0800
Message-Id: <20230209175330.1783556-1-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.3 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Intel IOMMU driver implements IOTLB flush queue with domain selective
or PASID selective invalidations. In this case there's no need to track
IOVA page range and sync IOTLBs, which may cause significant performance
hit.

This patch adds a check to avoid IOVA gather page and IOTLB sync for
the lazy path.

The performance difference on Sapphire Rapids 100Gb NIC is improved by
the following (as measured by iperf send):

w/o this fix~48 Gbits/s. with this fix ~54 Gbits/s

Cc: <stable@vger.kernel.org>
Fixes: 2a2b8eaa5b25 ("iommu: Handle freelists when using deferred flushing in iommu drivers")
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Tested-by: Sanjay Kumar <sanjay.k.kumar@intel.com>
Signed-off-by: Sanjay Kumar <sanjay.k.kumar@intel.com>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
v3: reword comments, add reviewed by tag. (Kevin)
v2: use helper function iommu_iotlb_gather_queued() instead of open
coding
---
 drivers/iommu/intel/iommu.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 59df7e42fd53..2ee270e4d484 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4346,7 +4346,12 @@ static size_t intel_iommu_unmap(struct iommu_domain *domain,
 	if (dmar_domain->max_addr == iova + size)
 		dmar_domain->max_addr = iova;
 
-	iommu_iotlb_gather_add_page(domain, gather, iova, size);
+	/*
+	 * We do not use page-selective IOTLB invalidation in flush queue,
+	 * so there is no need to track page and sync iotlb.
+	 */
+	if (!iommu_iotlb_gather_queued(gather))
+		iommu_iotlb_gather_add_page(domain, gather, iova, size);
 
 	return size;
 }
-- 
2.25.1

