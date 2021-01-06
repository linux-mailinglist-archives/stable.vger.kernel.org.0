Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB6D2ECB19
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 08:52:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725983AbhAGHvJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 02:51:09 -0500
Received: from mga12.intel.com ([192.55.52.136]:19929 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725862AbhAGHvI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 02:51:08 -0500
IronPort-SDR: vuuAXZWHdHd6bdAnajzgbgKtzgl+cK3TSRaoUzdfFJ8G3dLjpUdf5tFpyozRUAz6vF2kINcQsb
 GL7rSMpNzmQA==
X-IronPort-AV: E=McAfee;i="6000,8403,9856"; a="156577778"
X-IronPort-AV: E=Sophos;i="5.79,329,1602572400"; 
   d="scan'208";a="156577778"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2021 23:50:24 -0800
IronPort-SDR: stQ4a6PiUxDXQzWh2hLoc4caPZ/2WrIoah2M+H/b8sfCVEcRyIa1Pmed22d1x8vRYgqLZFUnTC
 XT6vnhXtRSqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,329,1602572400"; 
   d="scan'208";a="351169587"
Received: from yiliu-dev.bj.intel.com (HELO iov-dev2.bj.intel.com) ([10.238.156.135])
  by fmsmga008.fm.intel.com with ESMTP; 06 Jan 2021 23:50:20 -0800
From:   Liu Yi L <yi.l.liu@intel.com>
To:     baolu.lu@linux.intel.com, joro@8bytes.org, will@kernel.org
Cc:     kevin.tian@intel.com, ashok.raj@intel.com, jun.j.tian@intel.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        yi.y.sun@intel.com, yi.l.liu@intel.com, dan.carpenter@oracle.com,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Guo Kaijie <Kaijie.Guo@intel.com>,
        Xin Zeng <xin.zeng@intel.com>, stable@vger.kernel.org,
        #@vger.kernel.org, v5.0+@vger.kernel.org
Subject: [PATCH v4 1/3] iommu/vt-d: Move intel_iommu info from struct intel_svm to struct intel_svm_dev
Date:   Thu,  7 Jan 2021 00:03:55 +0800
Message-Id: <1609949037-25291-2-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1609949037-25291-1-git-send-email-yi.l.liu@intel.com>
References: <1609949037-25291-1-git-send-email-yi.l.liu@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Current struct intel_svm has a field to record the struct intel_iommu
pointer for a PASID bind. And struct intel_svm will be shared by all
the devices bind to the same process. The devices may be behind different
DMAR units. As the iommu driver code uses the intel_iommu pointer stored
in intel_svm struct to do cache invalidations, it may only flush the cache
on a single DMAR unit, for others, the cache invalidation is missed.

As intel_svm struct already has a device list, this patch just moves the
intel_iommu pointer to be a field of intel_svm_dev struct.

Fixes: 1c4f88b7f1f92 ("iommu/vt-d: Shared virtual address in scalable mode")
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Raj Ashok <ashok.raj@intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Reported-by: Guo Kaijie <Kaijie.Guo@intel.com>
Reported-by: Xin Zeng <xin.zeng@intel.com>
Signed-off-by: Guo Kaijie <Kaijie.Guo@intel.com>
Signed-off-by: Xin Zeng <xin.zeng@intel.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
Tested-by: Guo Kaijie <Kaijie.Guo@intel.com>
Cc: stable@vger.kernel.org # v5.0+
Acked-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/iommu/intel/svm.c   | 9 +++++----
 include/linux/intel-iommu.h | 2 +-
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/intel/svm.c b/drivers/iommu/intel/svm.c
index 4fa248b..6956669 100644
--- a/drivers/iommu/intel/svm.c
+++ b/drivers/iommu/intel/svm.c
@@ -142,7 +142,7 @@ static void intel_flush_svm_range_dev (struct intel_svm *svm, struct intel_svm_d
 	}
 	desc.qw2 = 0;
 	desc.qw3 = 0;
-	qi_submit_sync(svm->iommu, &desc, 1, 0);
+	qi_submit_sync(sdev->iommu, &desc, 1, 0);
 
 	if (sdev->dev_iotlb) {
 		desc.qw0 = QI_DEV_EIOTLB_PASID(svm->pasid) |
@@ -166,7 +166,7 @@ static void intel_flush_svm_range_dev (struct intel_svm *svm, struct intel_svm_d
 		}
 		desc.qw2 = 0;
 		desc.qw3 = 0;
-		qi_submit_sync(svm->iommu, &desc, 1, 0);
+		qi_submit_sync(sdev->iommu, &desc, 1, 0);
 	}
 }
 
@@ -211,7 +211,7 @@ static void intel_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
 	 */
 	rcu_read_lock();
 	list_for_each_entry_rcu(sdev, &svm->devs, list)
-		intel_pasid_tear_down_entry(svm->iommu, sdev->dev,
+		intel_pasid_tear_down_entry(sdev->iommu, sdev->dev,
 					    svm->pasid, true);
 	rcu_read_unlock();
 
@@ -363,6 +363,7 @@ int intel_svm_bind_gpasid(struct iommu_domain *domain, struct device *dev,
 	}
 	sdev->dev = dev;
 	sdev->sid = PCI_DEVID(info->bus, info->devfn);
+	sdev->iommu = iommu;
 
 	/* Only count users if device has aux domains */
 	if (iommu_dev_feature_enabled(dev, IOMMU_DEV_FEAT_AUX))
@@ -546,6 +547,7 @@ intel_svm_bind_mm(struct device *dev, unsigned int flags,
 		goto out;
 	}
 	sdev->dev = dev;
+	sdev->iommu = iommu;
 
 	ret = intel_iommu_enable_pasid(iommu, dev);
 	if (ret) {
@@ -575,7 +577,6 @@ intel_svm_bind_mm(struct device *dev, unsigned int flags,
 			kfree(sdev);
 			goto out;
 		}
-		svm->iommu = iommu;
 
 		if (pasid_max > intel_pasid_max_id)
 			pasid_max = intel_pasid_max_id;
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index d956987..9452268 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -758,6 +758,7 @@ struct intel_svm_dev {
 	struct list_head list;
 	struct rcu_head rcu;
 	struct device *dev;
+	struct intel_iommu *iommu;
 	struct svm_dev_ops *ops;
 	struct iommu_sva sva;
 	u32 pasid;
@@ -771,7 +772,6 @@ struct intel_svm {
 	struct mmu_notifier notifier;
 	struct mm_struct *mm;
 
-	struct intel_iommu *iommu;
 	unsigned int flags;
 	u32 pasid;
 	int gpasid; /* In case that guest PASID is different from host PASID */
-- 
2.7.4

