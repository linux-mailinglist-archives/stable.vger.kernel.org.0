Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A809358C232
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 05:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236850AbiHHDvU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 23:51:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235277AbiHHDvU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 23:51:20 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E4996473;
        Sun,  7 Aug 2022 20:51:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659930679; x=1691466679;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=JvFoOsrKG4TH442GCX9qpNph6AZxckOT3phGGk6AHDY=;
  b=NybsLSAq0i7My3oxKkAM5lkrqNrLWK2VwnjwIGWr/v8GZjYTecPaxDeH
   3V/SCzDEjXIiQeOjimawJeHchQmnvVzejeuIGbRZp0yYWhCvBKmy77cEN
   mJ7qMu0kMJM+lng44kleDHUe2g/FNtV1wfHVrlmA/HAhA1hp3C4YQuHXs
   RBbJRIuLmrGHJ9DK3OfTpEYtHNHolij3RKQTcmlyGqt+PIq3U1iRN3yK4
   MBisnjQWL4zEwU2DSQFBCGmDPrCgae5ey5IZE+/UWc8hlkgGhEPZiOdZQ
   hoDyJhTBzIlILHqEhf+9eVSsw6r+Z3XsZzE0ZXuVE8V3pq9IiNA6hzCob
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10432"; a="270269598"
X-IronPort-AV: E=Sophos;i="5.93,221,1654585200"; 
   d="scan'208";a="270269598"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 20:51:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,221,1654585200"; 
   d="scan'208";a="632714196"
Received: from allen-box.sh.intel.com ([10.239.159.48])
  by orsmga008.jf.intel.com with ESMTP; 07 Aug 2022 20:51:15 -0700
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     iommu@lists.linux.dev
Cc:     Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        Wen Jin <wen.jin@intel.com>, linux-kernel@vger.kernel.org,
        Lu Baolu <baolu.lu@linux.intel.com>, stable@vger.kernel.org
Subject: [PATCH 1/1] iommu/vt-d: Fix kdump kernels boot failure with scalable mode
Date:   Mon,  8 Aug 2022 11:46:12 +0800
Message-Id: <20220808034612.1691470-1-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The translation table copying code for kdump kernels is currently based
on the extended root/context entry formats of ECS mode defined in older
VT-d v2.5, and doesn't handle the scalable mode formats. This causes
the kexec capture kernel boot failure with DMAR faults if the IOMMU was
enabled in scalable mode by the previous kernel.

The ECS mode has already been deprecated by the VT-d spec since v3.0 and
Intel IOMMU driver doesn't support this mode as there's no real hardware
implementation. Hence this converts ECS checking in copying table code
into scalable mode.

The existing copying code consumes a bit in the context entry as a mark
of copied entry. This marker needs to work for the old format as well as
for extended context entries. It's hard to find such a bit for both
legacy and scalable mode context entries. This replaces it with a per-
IOMMU bitmap.

Fixes: 7373a8cc38197 ("iommu/vt-d: Setup context and enable RID2PASID support")
Cc: stable@vger.kernel.org
Reported-by: Jerry Snitselaar <jsnitsel@redhat.com>
Tested-by: Wen Jin <wen.jin@intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/iommu/intel/iommu.h   | 17 ++++++--
 drivers/iommu/intel/debugfs.c |  3 +-
 drivers/iommu/intel/iommu.c   | 76 +++++++++--------------------------
 3 files changed, 35 insertions(+), 61 deletions(-)

diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
index fae45bbb0c7f..e9b851c42575 100644
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -197,7 +197,6 @@
 #define ecap_dis(e)		(((e) >> 27) & 0x1)
 #define ecap_nest(e)		(((e) >> 26) & 0x1)
 #define ecap_mts(e)		(((e) >> 25) & 0x1)
-#define ecap_ecs(e)		(((e) >> 24) & 0x1)
 #define ecap_iotlb_offset(e) 	((((e) >> 8) & 0x3ff) * 16)
 #define ecap_max_iotlb_offset(e) (ecap_iotlb_offset(e) + 16)
 #define ecap_coherent(e)	((e) & 0x1)
@@ -265,7 +264,6 @@
 #define DMA_GSTS_CFIS (((u32)1) << 23)
 
 /* DMA_RTADDR_REG */
-#define DMA_RTADDR_RTT (((u64)1) << 11)
 #define DMA_RTADDR_SMT (((u64)1) << 10)
 
 /* CCMD_REG */
@@ -579,6 +577,7 @@ struct intel_iommu {
 
 #ifdef CONFIG_INTEL_IOMMU
 	unsigned long 	*domain_ids; /* bitmap of domains */
+	unsigned long	*copied_tables; /* bitmap of copied tables */
 	spinlock_t	lock; /* protect context, domain ids */
 	struct root_entry *root_entry; /* virtual address */
 
@@ -701,6 +700,19 @@ static inline int nr_pte_to_next_page(struct dma_pte *pte)
 		(struct dma_pte *)ALIGN((unsigned long)pte, VTD_PAGE_SIZE) - pte;
 }
 
+static inline bool context_copied(struct intel_iommu *iommu, u8 bus, u8 devfn)
+{
+	if (!iommu->copied_tables)
+		return false;
+
+	return test_bit(((long)bus << 8) | devfn, iommu->copied_tables);
+}
+
+static inline bool context_present(struct context_entry *context)
+{
+	return (context->lo & 1);
+}
+
 extern struct dmar_drhd_unit * dmar_find_matched_drhd_unit(struct pci_dev *dev);
 
 extern int dmar_enable_qi(struct intel_iommu *iommu);
@@ -784,7 +796,6 @@ static inline void intel_iommu_debugfs_init(void) {}
 #endif /* CONFIG_INTEL_IOMMU_DEBUGFS */
 
 extern const struct attribute_group *intel_iommu_groups[];
-bool context_present(struct context_entry *context);
 struct context_entry *iommu_context_addr(struct intel_iommu *iommu, u8 bus,
 					 u8 devfn, int alloc);
 
diff --git a/drivers/iommu/intel/debugfs.c b/drivers/iommu/intel/debugfs.c
index 1f925285104e..f4fd249daad9 100644
--- a/drivers/iommu/intel/debugfs.c
+++ b/drivers/iommu/intel/debugfs.c
@@ -241,7 +241,8 @@ static void ctx_tbl_walk(struct seq_file *m, struct intel_iommu *iommu, u16 bus)
 		if (!context)
 			return;
 
-		if (!context_present(context))
+		if (!context_present(context) ||
+		    context_copied(iommu, bus, devfn))
 			continue;
 
 		tbl_wlk.bus = bus;
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 7cca030a508e..889ad2c9a7b9 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -163,38 +163,6 @@ static phys_addr_t root_entry_uctp(struct root_entry *re)
 	return re->hi & VTD_PAGE_MASK;
 }
 
-static inline void context_clear_pasid_enable(struct context_entry *context)
-{
-	context->lo &= ~(1ULL << 11);
-}
-
-static inline bool context_pasid_enabled(struct context_entry *context)
-{
-	return !!(context->lo & (1ULL << 11));
-}
-
-static inline void context_set_copied(struct context_entry *context)
-{
-	context->hi |= (1ull << 3);
-}
-
-static inline bool context_copied(struct context_entry *context)
-{
-	return !!(context->hi & (1ULL << 3));
-}
-
-static inline bool __context_present(struct context_entry *context)
-{
-	return (context->lo & 1);
-}
-
-bool context_present(struct context_entry *context)
-{
-	return context_pasid_enabled(context) ?
-	     __context_present(context) :
-	     __context_present(context) && !context_copied(context);
-}
-
 static inline void context_set_present(struct context_entry *context)
 {
 	context->lo |= 1;
@@ -764,7 +732,8 @@ static int device_context_mapped(struct intel_iommu *iommu, u8 bus, u8 devfn)
 	spin_lock(&iommu->lock);
 	context = iommu_context_addr(iommu, bus, devfn, 0);
 	if (context)
-		ret = context_present(context);
+		ret = context_present(context) &&
+				!context_copied(iommu, bus, devfn);
 	spin_unlock(&iommu->lock);
 	return ret;
 }
@@ -1688,6 +1657,11 @@ static void free_dmar_iommu(struct intel_iommu *iommu)
 		iommu->domain_ids = NULL;
 	}
 
+	if (iommu->copied_tables) {
+		bitmap_free(iommu->copied_tables);
+		iommu->copied_tables = NULL;
+	}
+
 	/* free context mapping */
 	free_context_table(iommu);
 
@@ -1913,7 +1887,7 @@ static int domain_context_mapping_one(struct dmar_domain *domain,
 		goto out_unlock;
 
 	ret = 0;
-	if (context_present(context))
+	if (context_present(context) && !context_copied(iommu, bus, devfn))
 		goto out_unlock;
 
 	/*
@@ -1925,7 +1899,7 @@ static int domain_context_mapping_one(struct dmar_domain *domain,
 	 * in-flight DMA will exist, and we don't need to worry anymore
 	 * hereafter.
 	 */
-	if (context_copied(context)) {
+	if (context_copied(iommu, bus, devfn)) {
 		u16 did_old = context_domain_id(context);
 
 		if (did_old < cap_ndoms(iommu->cap)) {
@@ -1936,6 +1910,8 @@ static int domain_context_mapping_one(struct dmar_domain *domain,
 			iommu->flush.flush_iotlb(iommu, did_old, 0, 0,
 						 DMA_TLB_DSI_FLUSH);
 		}
+
+		clear_bit(((long)bus << 8) | devfn, iommu->copied_tables);
 	}
 
 	context_clear_entry(context);
@@ -2684,32 +2660,14 @@ static int copy_context_table(struct intel_iommu *iommu,
 		/* Now copy the context entry */
 		memcpy(&ce, old_ce + idx, sizeof(ce));
 
-		if (!__context_present(&ce))
+		if (!context_present(&ce))
 			continue;
 
 		did = context_domain_id(&ce);
 		if (did >= 0 && did < cap_ndoms(iommu->cap))
 			set_bit(did, iommu->domain_ids);
 
-		/*
-		 * We need a marker for copied context entries. This
-		 * marker needs to work for the old format as well as
-		 * for extended context entries.
-		 *
-		 * Bit 67 of the context entry is used. In the old
-		 * format this bit is available to software, in the
-		 * extended format it is the PGE bit, but PGE is ignored
-		 * by HW if PASIDs are disabled (and thus still
-		 * available).
-		 *
-		 * So disable PASIDs first and then mark the entry
-		 * copied. This means that we don't copy PASID
-		 * translations from the old kernel, but this is fine as
-		 * faults there are not fatal.
-		 */
-		context_clear_pasid_enable(&ce);
-		context_set_copied(&ce);
-
+		set_bit(((long)bus << 8) | devfn, iommu->copied_tables);
 		new_ce[idx] = ce;
 	}
 
@@ -2735,8 +2693,8 @@ static int copy_translation_tables(struct intel_iommu *iommu)
 	bool new_ext, ext;
 
 	rtaddr_reg = dmar_readq(iommu->reg + DMAR_RTADDR_REG);
-	ext        = !!(rtaddr_reg & DMA_RTADDR_RTT);
-	new_ext    = !!ecap_ecs(iommu->ecap);
+	ext        = !!(rtaddr_reg & DMA_RTADDR_SMT);
+	new_ext    = !!ecap_smts(iommu->ecap);
 
 	/*
 	 * The RTT bit can only be changed when translation is disabled,
@@ -2747,6 +2705,10 @@ static int copy_translation_tables(struct intel_iommu *iommu)
 	if (new_ext != ext)
 		return -EINVAL;
 
+	iommu->copied_tables = bitmap_zalloc(BIT_ULL(16), GFP_KERNEL);
+	if (!iommu->copied_tables)
+		return -ENOMEM;
+
 	old_rt_phys = rtaddr_reg & VTD_PAGE_MASK;
 	if (!old_rt_phys)
 		return -EINVAL;
-- 
2.25.1

