Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D907537CA01
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237018AbhELQYD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:24:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:58050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240126AbhELQRO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:17:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE6FE61C7E;
        Wed, 12 May 2021 15:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834202;
        bh=/KxQ6l34LVY5e9xrrsw9nn+mBVdI45Q7yJKb8+S8w7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w3Fgh5c0n/O42V/zWgU0yiaO3nEt8R7yJ/CpBHtlasNZtaUOs5kTDE7CJSJ7seX/6
         b8d9jc41wEgZeM+Djo8hPIocRZXGITqAWhc0MW1xPHQAaN1C69J3lcnrzI4dyJJ+gk
         p1bTZkkSsDy3I4Bt0cv5kbgW0vBe58sfGWKzp9XM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ashok Raj <ashok.raj@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 442/601] iommu/vt-d: Invalidate PASID cache when root/context entry changed
Date:   Wed, 12 May 2021 16:48:39 +0200
Message-Id: <20210512144842.403119073@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit c0474a606ecb9326227b4d68059942f9db88a897 ]

When the Intel IOMMU is operating in the scalable mode, some information
from the root and context table may be used to tag entries in the PASID
cache. Software should invalidate the PASID-cache when changing root or
context table entries.

Suggested-by: Ashok Raj <ashok.raj@intel.com>
Fixes: 7373a8cc38197 ("iommu/vt-d: Setup context and enable RID2PASID support")
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20210320025415.641201-4-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c | 18 +++++++++---------
 include/linux/intel-iommu.h |  1 +
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 82300b0d3074..93f17a8a42e2 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -1336,6 +1336,11 @@ static void iommu_set_root_entry(struct intel_iommu *iommu)
 		      readl, (sts & DMA_GSTS_RTPS), sts);
 
 	raw_spin_unlock_irqrestore(&iommu->register_lock, flag);
+
+	iommu->flush.flush_context(iommu, 0, 0, 0, DMA_CCMD_GLOBAL_INVL);
+	if (sm_supported(iommu))
+		qi_flush_pasid_cache(iommu, 0, QI_PC_GLOBAL, 0);
+	iommu->flush.flush_iotlb(iommu, 0, 0, 0, DMA_TLB_GLOBAL_FLUSH);
 }
 
 void iommu_flush_write_buffer(struct intel_iommu *iommu)
@@ -2481,6 +2486,10 @@ static void domain_context_clear_one(struct intel_iommu *iommu, u8 bus, u8 devfn
 				   (((u16)bus) << 8) | devfn,
 				   DMA_CCMD_MASK_NOBIT,
 				   DMA_CCMD_DEVICE_INVL);
+
+	if (sm_supported(iommu))
+		qi_flush_pasid_cache(iommu, did_old, QI_PC_ALL_PASIDS, 0);
+
 	iommu->flush.flush_iotlb(iommu,
 				 did_old,
 				 0,
@@ -3325,8 +3334,6 @@ static int __init init_dmars(void)
 		register_pasid_allocator(iommu);
 #endif
 		iommu_set_root_entry(iommu);
-		iommu->flush.flush_context(iommu, 0, 0, 0, DMA_CCMD_GLOBAL_INVL);
-		iommu->flush.flush_iotlb(iommu, 0, 0, 0, DMA_TLB_GLOBAL_FLUSH);
 	}
 
 #ifdef CONFIG_INTEL_IOMMU_BROKEN_GFX_WA
@@ -3516,12 +3523,7 @@ static int init_iommu_hw(void)
 		}
 
 		iommu_flush_write_buffer(iommu);
-
 		iommu_set_root_entry(iommu);
-
-		iommu->flush.flush_context(iommu, 0, 0, 0,
-					   DMA_CCMD_GLOBAL_INVL);
-		iommu->flush.flush_iotlb(iommu, 0, 0, 0, DMA_TLB_GLOBAL_FLUSH);
 		iommu_enable_translation(iommu);
 		iommu_disable_protect_mem_regions(iommu);
 	}
@@ -3849,8 +3851,6 @@ static int intel_iommu_add(struct dmar_drhd_unit *dmaru)
 		goto disable_iommu;
 
 	iommu_set_root_entry(iommu);
-	iommu->flush.flush_context(iommu, 0, 0, 0, DMA_CCMD_GLOBAL_INVL);
-	iommu->flush.flush_iotlb(iommu, 0, 0, 0, DMA_TLB_GLOBAL_FLUSH);
 	iommu_enable_translation(iommu);
 
 	iommu_disable_protect_mem_regions(iommu);
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index ecb35fdff03e..ce30ea103b8d 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -369,6 +369,7 @@ enum {
 /* PASID cache invalidation granu */
 #define QI_PC_ALL_PASIDS	0
 #define QI_PC_PASID_SEL		1
+#define QI_PC_GLOBAL		3
 
 #define QI_EIOTLB_ADDR(addr)	((u64)(addr) & VTD_PAGE_MASK)
 #define QI_EIOTLB_IH(ih)	(((u64)ih) << 6)
-- 
2.30.2



