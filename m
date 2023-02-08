Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1773B68F6B8
	for <lists+stable@lfdr.de>; Wed,  8 Feb 2023 19:15:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231588AbjBHSPD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Feb 2023 13:15:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbjBHSPC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Feb 2023 13:15:02 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B20822016;
        Wed,  8 Feb 2023 10:15:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675880102; x=1707416102;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=As20+I70osPLt7xJAYqyaX04fxh8ItmR/mRaZGCCZAw=;
  b=aJ4v9YL/LGaqDNaHQIEP/q3eSC8vOxcNRxtEfc7E7N5DqTdXr2wpF+xR
   k9fW+3DpmFEWeaqwLSa1FSMUoVWO+AasegrBKKJ0YU39KeFMAW64IEmLP
   wieFU0JlGH0wq1seRGrcOJB6IPz4Jocf2Q/POkSHayk1vBS/9Ip4W9hM5
   drOAvrWYOgAw7jx77TJNl7TC+Rydwx55R4i6cxhKb4KMJQodSkLpxJQAc
   z1V3Bis9Ctugl8DqLtNwAia6fEcNT8otMY20KFE6epgzKuSNtLRtVh0fg
   QZDs05NF2yWEcDXYWzQlIPs/Nk1nruhLev5jPcgrP4GdE8L5LoykDBKWm
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="392273348"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="392273348"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2023 10:15:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="810028905"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="810028905"
Received: from srinivas-otcpl-7600.jf.intel.com (HELO jacob-builder.jf.intel.com) ([10.54.39.106])
  by fmsmga001.fm.intel.com with ESMTP; 08 Feb 2023 10:15:00 -0800
From:   Jacob Pan <jacob.jun.pan@linux.intel.com>
To:     LKML <linux-kernel@vger.kernel.org>, iommu@lists.linux.dev,
        "Lu Baolu" <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     David Woodhouse <dwmw2@infradead.org>,
        Raj Ashok <ashok.raj@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>, Yi Liu <yi.l.liu@intel.com>,
        sukumar.ghorai@intel.com,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        stable@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
        Sanjay Kumar <sanjay.k.kumar@intel.com>
Subject: [PATCH v2] iommu/vt-d: Avoid superfluous IOTLB tracking in lazy mode
Date:   Wed,  8 Feb 2023 10:18:34 -0800
Message-Id: <20230208181834.1601211-1-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
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
Tested-by: Sanjay Kumar <sanjay.k.kumar@intel.com>
Signed-off-by: Sanjay Kumar <sanjay.k.kumar@intel.com>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
v2: use helper function iommu_iotlb_gather_queued() instead of open
coding
---
 drivers/iommu/intel/iommu.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 161342e7149d..18265fa07828 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4348,7 +4348,13 @@ static size_t intel_iommu_unmap(struct iommu_domain *domain,
 	if (dmar_domain->max_addr == iova + size)
 		dmar_domain->max_addr = iova;
 
-	iommu_iotlb_gather_add_page(domain, gather, iova, size);
+	/*
+	 * We do not use page-selective IOTLB invalidation in flush queue,
+	 * There is no need to track page and sync iotlb. Domain-selective or
+	 * PASID-selective validation are used in the flush queue.
+	 */
+	if (!iommu_iotlb_gather_queued(gather))
+		iommu_iotlb_gather_add_page(domain, gather, iova, size);
 
 	return size;
 }
-- 
2.25.1

