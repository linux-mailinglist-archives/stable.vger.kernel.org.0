Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 180F55541D7
	for <lists+stable@lfdr.de>; Wed, 22 Jun 2022 06:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356963AbiFVEpc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jun 2022 00:45:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbiFVEpb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jun 2022 00:45:31 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32D1633E17;
        Tue, 21 Jun 2022 21:45:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655873131; x=1687409131;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=CMoUcpPlVSjI5v0iYxRqec/ZANBG5N/XfEwKajaEL7s=;
  b=as/lceldjPvQp6YwREXLnBwWv4B1SFfv6oGHKcgDWvruBDFIYcYHv+e5
   upRxJ0j4+4FnHEX0uGMYltAZ37F3BBjsyN5J1LzxR3mAKgeJlfdM4YstD
   pAwaQ5WSPuTM4BtyQsgoGGDqmDTIIFGMHrl20OxfuwZqHIeDs59IN4k+c
   C12k/M/aBuCxfDTpWq+gj8m+vls3cQicN4bSeHfwbiJ1t60/AHK0W4Alz
   ryQgNQXzJwBpLqQphQqIdNRBcTd98HWqYjYqlxLSZ9qPZnud2UyUZpfpn
   ZUuu/mYLM7IduQ+6RNo7ZvDptw1r/xnenKaKSQ4THqlaahz0XV+3REo4T
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10385"; a="366635091"
X-IronPort-AV: E=Sophos;i="5.92,211,1650956400"; 
   d="scan'208";a="366635091"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2022 21:45:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,211,1650956400"; 
   d="scan'208";a="833907396"
Received: from allen-box.sh.intel.com ([10.239.159.48])
  by fmsmga006.fm.intel.com with ESMTP; 21 Jun 2022 21:45:28 -0700
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Joerg Roedel <joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>
Cc:     Chenyi Qiang <chenyi.qiang@intel.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        iommu@lists.linux-foundation.org, iommu@lists.linux.dev,
        linux-kernel@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 1/1] iommu/vt-d: Fix RID2PASID setup failure
Date:   Wed, 22 Jun 2022 12:41:20 +0800
Message-Id: <20220622044120.21813-1-baolu.lu@linux.intel.com>
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
failed" failure as the pasid entry has already been marked as present. As
the result, the IOMMU probing process will be aborted.

This fixes it by skipping RID2PASID setting if the pasid entry has been
populated. This works because the IOMMU core ensures that only the same
IOMMU domain can be attached to all PCI alias devices at the same time.
Therefore the subsequent devices just try to setup the RID2PASID entry
with the same domain, which is negligible. This also adds domain validity
checks for more confidence anyway.

Fixes: ef848b7e5a6a0 ("iommu/vt-d: Setup pasid entry for RID2PASID support")
Reported-by: Chenyi Qiang <chenyi.qiang@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/iommu/intel/pasid.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

Change log:
v2:
 - Add domain validity check in RID2PASID entry setup.

diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index cb4c1d0cf25c..4f3525f3346f 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -575,6 +575,19 @@ static inline int pasid_enable_wpe(struct pasid_entry *pte)
 	return 0;
 };
 
+/*
+ * Return true if @pasid is RID2PASID and the domain @did has already
+ * been setup to the @pte. Otherwise, return false. PCI alias devices
+ * probably share the single RID2PASID pasid entry in the shared pasid
+ * table. It's reasonable that those devices try to set a share domain
+ * in their probe paths.
+ */
+static inline bool
+rid2pasid_domain_valid(struct pasid_entry *pte, u32 pasid, u16 did)
+{
+	return pasid == PASID_RID2PASID && pasid_get_domain_id(pte) == did;
+}
+
 /*
  * Set up the scalable mode pasid table entry for first only
  * translation type.
@@ -595,9 +608,8 @@ int intel_pasid_setup_first_level(struct intel_iommu *iommu,
 	if (WARN_ON(!pte))
 		return -EINVAL;
 
-	/* Caller must ensure PASID entry is not in use. */
 	if (pasid_pte_is_present(pte))
-		return -EBUSY;
+		return rid2pasid_domain_valid(pte, pasid, did) ? 0 : -EBUSY;
 
 	pasid_clear_entry(pte);
 
@@ -698,9 +710,8 @@ int intel_pasid_setup_second_level(struct intel_iommu *iommu,
 		return -ENODEV;
 	}
 
-	/* Caller must ensure PASID entry is not in use. */
 	if (pasid_pte_is_present(pte))
-		return -EBUSY;
+		return rid2pasid_domain_valid(pte, pasid, did) ? 0 : -EBUSY;
 
 	pasid_clear_entry(pte);
 	pasid_set_domain_id(pte, did);
@@ -738,9 +749,8 @@ int intel_pasid_setup_pass_through(struct intel_iommu *iommu,
 		return -ENODEV;
 	}
 
-	/* Caller must ensure PASID entry is not in use. */
 	if (pasid_pte_is_present(pte))
-		return -EBUSY;
+		return rid2pasid_domain_valid(pte, pasid, did) ? 0 : -EBUSY;
 
 	pasid_clear_entry(pte);
 	pasid_set_domain_id(pte, did);
-- 
2.25.1

