Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA407551290
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 10:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238837AbiFTIVq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 04:21:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238441AbiFTIVm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 04:21:42 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE2101263E;
        Mon, 20 Jun 2022 01:21:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655713301; x=1687249301;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=8E2kEq+GCo7Dhht4sPeokQjW9I35j7HibLiiqhyWzLc=;
  b=XQCRb7LRslUeYyqtC37ZEvv8qINrkxD6+a3bKfKstm+iYXbMk8s8zUyT
   ASMv5PcNIYCSaETcUaoSS4N0Kl5+lEPqSMdFqrd0xrtJbKH9AcVLDFGq+
   62PWcLhXMdimpG22Yoj0TGEBZpCXVDDoFjXGNKU+DplTrtDDyX9m003yY
   Y3wPJaa0zX78hq0MuzrdVZmAXt2AHv9Y/MBmAMdytC/UYnZPbDB6BCMJe
   c0xg9shEgxnLNBC1sYe88d6p+MGHtcSpTy1tZvEa8veJLd+wZccWpbAsU
   vcgEKRxJsg8tJAudl30GOZ6+0VuVrb4NU+g77cgEY6QVEMotR5teNpYDH
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="341518496"
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="341518496"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 01:21:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="584799278"
Received: from allen-box.sh.intel.com ([10.239.159.48])
  by orsmga007.jf.intel.com with ESMTP; 20 Jun 2022 01:21:37 -0700
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Joerg Roedel <joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>
Cc:     Chenyi Qiang <chenyi.qiang@intel.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Lu Baolu <baolu.lu@linux.intel.com>, stable@vger.kernel.org
Subject: [PATCH 1/1] iommu/vt-d: Fix RID2PASID setup failure
Date:   Mon, 20 Jun 2022 16:17:29 +0800
Message-Id: <20220620081729.4610-1-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The IOMMU driver shares the pasid table for PCI alias devices. When the
RID2PASID entry of the shared pasid table has been filled by the first
device, the subsequent devices will encounter the "DMAR: Setup RID2PASID
failed" failure as the pasid entry has already been marke as present. As
the result, the IOMMU probing process will be aborted.

This fixes it by skipping RID2PASID setting if the pasid entry has been
populated. This works because the IOMMU core ensures that only the same
IOMMU domain can be attached to all PCI alias devices at the same time.
Therefore the subsequent devices just try to setup the RID2PASID entry
with the same domain, which is negligible.

Fixes: ef848b7e5a6a0 ("iommu/vt-d: Setup pasid entry for RID2PASID support")
Reported-by: Chenyi Qiang <chenyi.qiang@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/iommu/intel/iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 44016594831d..b9966c01a2a2 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -2564,7 +2564,7 @@ static int domain_add_dev_info(struct dmar_domain *domain, struct device *dev)
 			ret = intel_pasid_setup_second_level(iommu, domain,
 					dev, PASID_RID2PASID);
 		spin_unlock_irqrestore(&iommu->lock, flags);
-		if (ret) {
+		if (ret && ret != -EBUSY) {
 			dev_err(dev, "Setup RID2PASID failed\n");
 			dmar_remove_one_dev_info(dev);
 			return ret;
-- 
2.25.1

