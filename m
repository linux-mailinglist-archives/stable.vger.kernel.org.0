Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D89EAE0D3
	for <lists+stable@lfdr.de>; Tue, 10 Sep 2019 00:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392062AbfIIWQT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Sep 2019 18:16:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:45162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392053AbfIIWQS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Sep 2019 18:16:18 -0400
Received: from sasha-vm.mshome.net (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53CAF21D6C;
        Mon,  9 Sep 2019 22:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568067377;
        bh=AeTtAhhO3ekmXdN1I9ysSjm8aV2vHCTIt/9tWFksyFU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jYjbyJ3hf45Vwv17CrLJ0cKSra62i3SwHZ/ub2/Q4HG3vmQDUtKGGGOwyubU7zLkF
         1OB1yWmgYB52eRBUrYFub4Z1tLBAJv5JbXaQrkENSrHKo69ZFkyRUBFKia/VWQXgCP
         S8WY7/YRJ+LBsbwfMF0jSDkQNqtqxX3cElwVMa9U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Sanjay K Kumar <sanjay.k.kumar@intel.com>,
        Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.2 07/12] iommu/vt-d: Remove global page flush support
Date:   Mon,  9 Sep 2019 11:40:47 -0400
Message-Id: <20190909154052.30941-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190909154052.30941-1-sashal@kernel.org>
References: <20190909154052.30941-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jacob Pan <jacob.jun.pan@linux.intel.com>

[ Upstream commit 8744daf4b0699b724ee0a56b313a6c0c4ea289e3 ]

Global pages support is removed from VT-d spec 3.0. Since global pages G
flag only affects first-level paging structures and because DMA request
with PASID are only supported by VT-d spec. 3.0 and onward, we can
safely remove global pages support.

For kernel shared virtual address IOTLB invalidation, PASID
granularity and page selective within PASID will be used. There is
no global granularity supported. Without this fix, IOTLB invalidation
will cause invalid descriptor error in the queued invalidation (QI)
interface.

Fixes: 1c4f88b7f1f9 ("iommu/vt-d: Shared virtual address in scalable mode")
Reported-by: Sanjay K Kumar <sanjay.k.kumar@intel.com>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel-svm.c   | 36 +++++++++++++++---------------------
 include/linux/intel-iommu.h |  3 ---
 2 files changed, 15 insertions(+), 24 deletions(-)

diff --git a/drivers/iommu/intel-svm.c b/drivers/iommu/intel-svm.c
index eceaa7e968ae8..641dc223c97b8 100644
--- a/drivers/iommu/intel-svm.c
+++ b/drivers/iommu/intel-svm.c
@@ -100,24 +100,19 @@ int intel_svm_finish_prq(struct intel_iommu *iommu)
 }
 
 static void intel_flush_svm_range_dev (struct intel_svm *svm, struct intel_svm_dev *sdev,
-				       unsigned long address, unsigned long pages, int ih, int gl)
+				unsigned long address, unsigned long pages, int ih)
 {
 	struct qi_desc desc;
 
-	if (pages == -1) {
-		/* For global kernel pages we have to flush them in *all* PASIDs
-		 * because that's the only option the hardware gives us. Despite
-		 * the fact that they are actually only accessible through one. */
-		if (gl)
-			desc.qw0 = QI_EIOTLB_PASID(svm->pasid) |
-					QI_EIOTLB_DID(sdev->did) |
-					QI_EIOTLB_GRAN(QI_GRAN_ALL_ALL) |
-					QI_EIOTLB_TYPE;
-		else
-			desc.qw0 = QI_EIOTLB_PASID(svm->pasid) |
-					QI_EIOTLB_DID(sdev->did) |
-					QI_EIOTLB_GRAN(QI_GRAN_NONG_PASID) |
-					QI_EIOTLB_TYPE;
+	/*
+	 * Do PASID granu IOTLB invalidation if page selective capability is
+	 * not available.
+	 */
+	if (pages == -1 || !cap_pgsel_inv(svm->iommu->cap)) {
+		desc.qw0 = QI_EIOTLB_PASID(svm->pasid) |
+			QI_EIOTLB_DID(sdev->did) |
+			QI_EIOTLB_GRAN(QI_GRAN_NONG_PASID) |
+			QI_EIOTLB_TYPE;
 		desc.qw1 = 0;
 	} else {
 		int mask = ilog2(__roundup_pow_of_two(pages));
@@ -127,7 +122,6 @@ static void intel_flush_svm_range_dev (struct intel_svm *svm, struct intel_svm_d
 				QI_EIOTLB_GRAN(QI_GRAN_PSI_PASID) |
 				QI_EIOTLB_TYPE;
 		desc.qw1 = QI_EIOTLB_ADDR(address) |
-				QI_EIOTLB_GL(gl) |
 				QI_EIOTLB_IH(ih) |
 				QI_EIOTLB_AM(mask);
 	}
@@ -162,13 +156,13 @@ static void intel_flush_svm_range_dev (struct intel_svm *svm, struct intel_svm_d
 }
 
 static void intel_flush_svm_range(struct intel_svm *svm, unsigned long address,
-				  unsigned long pages, int ih, int gl)
+				unsigned long pages, int ih)
 {
 	struct intel_svm_dev *sdev;
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(sdev, &svm->devs, list)
-		intel_flush_svm_range_dev(svm, sdev, address, pages, ih, gl);
+		intel_flush_svm_range_dev(svm, sdev, address, pages, ih);
 	rcu_read_unlock();
 }
 
@@ -180,7 +174,7 @@ static void intel_invalidate_range(struct mmu_notifier *mn,
 	struct intel_svm *svm = container_of(mn, struct intel_svm, notifier);
 
 	intel_flush_svm_range(svm, start,
-			      (end - start + PAGE_SIZE - 1) >> VTD_PAGE_SHIFT, 0, 0);
+			      (end - start + PAGE_SIZE - 1) >> VTD_PAGE_SHIFT, 0);
 }
 
 static void intel_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
@@ -203,7 +197,7 @@ static void intel_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
 	rcu_read_lock();
 	list_for_each_entry_rcu(sdev, &svm->devs, list) {
 		intel_pasid_tear_down_entry(svm->iommu, sdev->dev, svm->pasid);
-		intel_flush_svm_range_dev(svm, sdev, 0, -1, 0, !svm->mm);
+		intel_flush_svm_range_dev(svm, sdev, 0, -1, 0);
 	}
 	rcu_read_unlock();
 
@@ -410,7 +404,7 @@ int intel_svm_unbind_mm(struct device *dev, int pasid)
 				 * large and has to be physically contiguous. So it's
 				 * hard to be as defensive as we might like. */
 				intel_pasid_tear_down_entry(iommu, dev, svm->pasid);
-				intel_flush_svm_range_dev(svm, sdev, 0, -1, 0, !svm->mm);
+				intel_flush_svm_range_dev(svm, sdev, 0, -1, 0);
 				kfree_rcu(sdev, rcu);
 
 				if (list_empty(&svm->devs)) {
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index 6a8dd4af01472..ba8dc520cc79a 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -346,7 +346,6 @@ enum {
 #define QI_PC_PASID_SEL		(QI_PC_TYPE | QI_PC_GRAN(1))
 
 #define QI_EIOTLB_ADDR(addr)	((u64)(addr) & VTD_PAGE_MASK)
-#define QI_EIOTLB_GL(gl)	(((u64)gl) << 7)
 #define QI_EIOTLB_IH(ih)	(((u64)ih) << 6)
 #define QI_EIOTLB_AM(am)	(((u64)am))
 #define QI_EIOTLB_PASID(pasid) 	(((u64)pasid) << 32)
@@ -378,8 +377,6 @@ enum {
 #define QI_RESP_INVALID		0x1
 #define QI_RESP_FAILURE		0xf
 
-#define QI_GRAN_ALL_ALL			0
-#define QI_GRAN_NONG_ALL		1
 #define QI_GRAN_NONG_PASID		2
 #define QI_GRAN_PSI_PASID		3
 
-- 
2.20.1

