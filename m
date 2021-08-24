Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB9C3F6535
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239452AbhHXRKm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:10:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:52018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239327AbhHXRJD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:09:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A12B61A50;
        Tue, 24 Aug 2021 17:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824415;
        bh=btWMwOiFZAZWEb/7YTv621HOBNvvdcouSg8F3+LP9wk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QmaImOcnUrPJ/YwghEFbwZtSzdQvrfoO0gRNwAUdrvwTPRE7lIJ1nHlszlUdajvbz
         dM+UsSJ5wh46pfAGt3s2CqB/UadE8d8UrtZ+1yZH92DcY2p0NZdy7ZpmY57IypPAdf
         LFYVntvsjyQaDETDPMb8sb5jHcer3puB1drGWBv+x28cZd0o0KMXg4ONOg1GbRln8Z
         PbrUrZVTv1VLaHV8iRw4L+JAOcYm8kZz1k6afGcTA8Qsqe9z/VxHteBF39mxmb1A8Y
         TvP4PNf+4sPClkwzhuZU4Kn5lIoU9hIi7yGsNg/h8VljZGvb691KdT71YDNVnysvf9
         vbI4X6Z7ONC+g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 66/98] iommu/vt-d: Consolidate duplicate cache invaliation code
Date:   Tue, 24 Aug 2021 12:58:36 -0400
Message-Id: <20210824165908.709932-67-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165908.709932-1-sashal@kernel.org>
References: <20210824165908.709932-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.61-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.61-rc1
X-KernelTest-Deadline: 2021-08-26T16:58+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit 9872f9bd9dbd68f75e8db782717d71e8594f6a02 ]

The pasid based IOTLB and devTLB invalidation code is duplicate in
several places. Consolidate them by using the common helpers.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20210114085021.717041-1-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/pasid.c | 18 ++----------
 drivers/iommu/intel/svm.c   | 55 ++++++-------------------------------
 2 files changed, 11 insertions(+), 62 deletions(-)

diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index 1e7c17989084..77fbe9908abd 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -466,20 +466,6 @@ pasid_cache_invalidation_with_pasid(struct intel_iommu *iommu,
 	qi_submit_sync(iommu, &desc, 1, 0);
 }
 
-static void
-iotlb_invalidation_with_pasid(struct intel_iommu *iommu, u16 did, u32 pasid)
-{
-	struct qi_desc desc;
-
-	desc.qw0 = QI_EIOTLB_PASID(pasid) | QI_EIOTLB_DID(did) |
-			QI_EIOTLB_GRAN(QI_GRAN_NONG_PASID) | QI_EIOTLB_TYPE;
-	desc.qw1 = 0;
-	desc.qw2 = 0;
-	desc.qw3 = 0;
-
-	qi_submit_sync(iommu, &desc, 1, 0);
-}
-
 static void
 devtlb_invalidation_with_pasid(struct intel_iommu *iommu,
 			       struct device *dev, u32 pasid)
@@ -524,7 +510,7 @@ void intel_pasid_tear_down_entry(struct intel_iommu *iommu, struct device *dev,
 		clflush_cache_range(pte, sizeof(*pte));
 
 	pasid_cache_invalidation_with_pasid(iommu, did, pasid);
-	iotlb_invalidation_with_pasid(iommu, did, pasid);
+	qi_flush_piotlb(iommu, did, pasid, 0, -1, 0);
 
 	/* Device IOTLB doesn't need to be flushed in caching mode. */
 	if (!cap_caching_mode(iommu->cap))
@@ -540,7 +526,7 @@ static void pasid_flush_caches(struct intel_iommu *iommu,
 
 	if (cap_caching_mode(iommu->cap)) {
 		pasid_cache_invalidation_with_pasid(iommu, did, pasid);
-		iotlb_invalidation_with_pasid(iommu, did, pasid);
+		qi_flush_piotlb(iommu, did, pasid, 0, -1, 0);
 	} else {
 		iommu_flush_write_buffer(iommu);
 	}
diff --git a/drivers/iommu/intel/svm.c b/drivers/iommu/intel/svm.c
index 6168dec7cb40..aabf56272b86 100644
--- a/drivers/iommu/intel/svm.c
+++ b/drivers/iommu/intel/svm.c
@@ -123,53 +123,16 @@ static void __flush_svm_range_dev(struct intel_svm *svm,
 				  unsigned long address,
 				  unsigned long pages, int ih)
 {
-	struct qi_desc desc;
+	struct device_domain_info *info = get_domain_info(sdev->dev);
 
-	if (pages == -1) {
-		desc.qw0 = QI_EIOTLB_PASID(svm->pasid) |
-			QI_EIOTLB_DID(sdev->did) |
-			QI_EIOTLB_GRAN(QI_GRAN_NONG_PASID) |
-			QI_EIOTLB_TYPE;
-		desc.qw1 = 0;
-	} else {
-		int mask = ilog2(__roundup_pow_of_two(pages));
-
-		desc.qw0 = QI_EIOTLB_PASID(svm->pasid) |
-				QI_EIOTLB_DID(sdev->did) |
-				QI_EIOTLB_GRAN(QI_GRAN_PSI_PASID) |
-				QI_EIOTLB_TYPE;
-		desc.qw1 = QI_EIOTLB_ADDR(address) |
-				QI_EIOTLB_IH(ih) |
-				QI_EIOTLB_AM(mask);
-	}
-	desc.qw2 = 0;
-	desc.qw3 = 0;
-	qi_submit_sync(sdev->iommu, &desc, 1, 0);
-
-	if (sdev->dev_iotlb) {
-		desc.qw0 = QI_DEV_EIOTLB_PASID(svm->pasid) |
-				QI_DEV_EIOTLB_SID(sdev->sid) |
-				QI_DEV_EIOTLB_QDEP(sdev->qdep) |
-				QI_DEIOTLB_TYPE;
-		if (pages == -1) {
-			desc.qw1 = QI_DEV_EIOTLB_ADDR(-1ULL >> 1) |
-					QI_DEV_EIOTLB_SIZE;
-		} else if (pages > 1) {
-			/* The least significant zero bit indicates the size. So,
-			 * for example, an "address" value of 0x12345f000 will
-			 * flush from 0x123440000 to 0x12347ffff (256KiB). */
-			unsigned long last = address + ((unsigned long)(pages - 1) << VTD_PAGE_SHIFT);
-			unsigned long mask = __rounddown_pow_of_two(address ^ last);
-
-			desc.qw1 = QI_DEV_EIOTLB_ADDR((address & ~mask) |
-					(mask - 1)) | QI_DEV_EIOTLB_SIZE;
-		} else {
-			desc.qw1 = QI_DEV_EIOTLB_ADDR(address);
-		}
-		desc.qw2 = 0;
-		desc.qw3 = 0;
-		qi_submit_sync(sdev->iommu, &desc, 1, 0);
-	}
+	if (WARN_ON(!pages))
+		return;
+
+	qi_flush_piotlb(sdev->iommu, sdev->did, svm->pasid, address, pages, ih);
+	if (info->ats_enabled)
+		qi_flush_dev_iotlb_pasid(sdev->iommu, sdev->sid, info->pfsid,
+					 svm->pasid, sdev->qdep, address,
+					 order_base_2(pages));
 }
 
 static void intel_flush_svm_range_dev(struct intel_svm *svm,
-- 
2.30.2

