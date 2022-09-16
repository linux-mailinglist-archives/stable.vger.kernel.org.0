Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56B5F5BAB1F
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 12:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbiIPKT4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 06:19:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231590AbiIPKSM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 06:18:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEF79AC26F;
        Fri, 16 Sep 2022 03:12:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 897FD62A20;
        Fri, 16 Sep 2022 10:11:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E085C433C1;
        Fri, 16 Sep 2022 10:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663323093;
        bh=LRRMg89awfRIwvKA8yTo6KSIu04EZVF1BJm2jCaOKsE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IKVCa6uvmBlJuo+zPdFPdE9poVGhpj3xDHDMsuX9WQHLwKJGWfWYGnw69ykxn+kOS
         g4mGAEeBVFLTZ7b7LvqufG/bBRePyfjIdunB3JL8kAaTUAgU7rEubfGAtRgT4VzPai
         MnLzgUaVRzEbyEcnHRSJnZbg1VhQrByChh9mwCko=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jerry Snitselaar <jsnitsel@redhat.com>,
        Wen Jin <wen.jin@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 12/35] iommu/vt-d: Fix kdump kernels boot failure with scalable mode
Date:   Fri, 16 Sep 2022 12:08:35 +0200
Message-Id: <20220916100447.454737005@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220916100446.916515275@linuxfoundation.org>
References: <20220916100446.916515275@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit 0c5f6c0d8201a809a6585b07b6263e9db2c874a3 ]

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
of copied entry. It needs to work for the old format as well as for the
extended context entries. As it's hard to find such a common bit for both
legacy and scalable mode context entries. This replaces it with a per-
IOMMU bitmap.

Fixes: 7373a8cc38197 ("iommu/vt-d: Setup context and enable RID2PASID support")
Cc: stable@vger.kernel.org
Reported-by: Jerry Snitselaar <jsnitsel@redhat.com>
Tested-by: Wen Jin <wen.jin@intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20220817011035.3250131-1-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c | 100 ++++++++++++++++--------------------
 include/linux/intel-iommu.h |   9 ++--
 2 files changed, 50 insertions(+), 59 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index bc5444daca9b4..2affdccb58e47 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -191,38 +191,6 @@ static phys_addr_t root_entry_uctp(struct root_entry *re)
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
@@ -270,6 +238,26 @@ static inline void context_clear_entry(struct context_entry *context)
 	context->hi = 0;
 }
 
+static inline bool context_copied(struct intel_iommu *iommu, u8 bus, u8 devfn)
+{
+	if (!iommu->copied_tables)
+		return false;
+
+	return test_bit(((long)bus << 8) | devfn, iommu->copied_tables);
+}
+
+static inline void
+set_context_copied(struct intel_iommu *iommu, u8 bus, u8 devfn)
+{
+	set_bit(((long)bus << 8) | devfn, iommu->copied_tables);
+}
+
+static inline void
+clear_context_copied(struct intel_iommu *iommu, u8 bus, u8 devfn)
+{
+	clear_bit(((long)bus << 8) | devfn, iommu->copied_tables);
+}
+
 /*
  * This domain is a statically identity mapping domain.
  *	1. This domain creats a static 1:1 mapping to all usable memory.
@@ -792,6 +780,13 @@ struct context_entry *iommu_context_addr(struct intel_iommu *iommu, u8 bus,
 	struct context_entry *context;
 	u64 *entry;
 
+	/*
+	 * Except that the caller requested to allocate a new entry,
+	 * returning a copied context entry makes no sense.
+	 */
+	if (!alloc && context_copied(iommu, bus, devfn))
+		return NULL;
+
 	entry = &root->lo;
 	if (sm_supported(iommu)) {
 		if (devfn >= 0x80) {
@@ -1899,6 +1894,11 @@ static void free_dmar_iommu(struct intel_iommu *iommu)
 		iommu->domain_ids = NULL;
 	}
 
+	if (iommu->copied_tables) {
+		bitmap_free(iommu->copied_tables);
+		iommu->copied_tables = NULL;
+	}
+
 	g_iommus[iommu->seq_id] = NULL;
 
 	/* free context mapping */
@@ -2107,7 +2107,7 @@ static int domain_context_mapping_one(struct dmar_domain *domain,
 		goto out_unlock;
 
 	ret = 0;
-	if (context_present(context))
+	if (context_present(context) && !context_copied(iommu, bus, devfn))
 		goto out_unlock;
 
 	/*
@@ -2119,7 +2119,7 @@ static int domain_context_mapping_one(struct dmar_domain *domain,
 	 * in-flight DMA will exist, and we don't need to worry anymore
 	 * hereafter.
 	 */
-	if (context_copied(context)) {
+	if (context_copied(iommu, bus, devfn)) {
 		u16 did_old = context_domain_id(context);
 
 		if (did_old < cap_ndoms(iommu->cap)) {
@@ -2130,6 +2130,8 @@ static int domain_context_mapping_one(struct dmar_domain *domain,
 			iommu->flush.flush_iotlb(iommu, did_old, 0, 0,
 						 DMA_TLB_DSI_FLUSH);
 		}
+
+		clear_context_copied(iommu, bus, devfn);
 	}
 
 	context_clear_entry(context);
@@ -3024,32 +3026,14 @@ static int copy_context_table(struct intel_iommu *iommu,
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
+		set_context_copied(iommu, bus, devfn);
 		new_ce[idx] = ce;
 	}
 
@@ -3076,8 +3060,8 @@ static int copy_translation_tables(struct intel_iommu *iommu)
 	bool new_ext, ext;
 
 	rtaddr_reg = dmar_readq(iommu->reg + DMAR_RTADDR_REG);
-	ext        = !!(rtaddr_reg & DMA_RTADDR_RTT);
-	new_ext    = !!ecap_ecs(iommu->ecap);
+	ext        = !!(rtaddr_reg & DMA_RTADDR_SMT);
+	new_ext    = !!sm_supported(iommu);
 
 	/*
 	 * The RTT bit can only be changed when translation is disabled,
@@ -3088,6 +3072,10 @@ static int copy_translation_tables(struct intel_iommu *iommu)
 	if (new_ext != ext)
 		return -EINVAL;
 
+	iommu->copied_tables = bitmap_zalloc(BIT_ULL(16), GFP_KERNEL);
+	if (!iommu->copied_tables)
+		return -ENOMEM;
+
 	old_rt_phys = rtaddr_reg & VTD_PAGE_MASK;
 	if (!old_rt_phys)
 		return -EINVAL;
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index 05a65eb155f76..81da7107e3bd0 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -196,7 +196,6 @@
 #define ecap_dis(e)		(((e) >> 27) & 0x1)
 #define ecap_nest(e)		(((e) >> 26) & 0x1)
 #define ecap_mts(e)		(((e) >> 25) & 0x1)
-#define ecap_ecs(e)		(((e) >> 24) & 0x1)
 #define ecap_iotlb_offset(e) 	((((e) >> 8) & 0x3ff) * 16)
 #define ecap_max_iotlb_offset(e) (ecap_iotlb_offset(e) + 16)
 #define ecap_coherent(e)	((e) & 0x1)
@@ -264,7 +263,6 @@
 #define DMA_GSTS_CFIS (((u32)1) << 23)
 
 /* DMA_RTADDR_REG */
-#define DMA_RTADDR_RTT (((u64)1) << 11)
 #define DMA_RTADDR_SMT (((u64)1) << 10)
 
 /* CCMD_REG */
@@ -594,6 +592,7 @@ struct intel_iommu {
 #ifdef CONFIG_INTEL_IOMMU
 	unsigned long 	*domain_ids; /* bitmap of domains */
 	struct dmar_domain ***domains; /* ptr to domains */
+	unsigned long	*copied_tables; /* bitmap of copied tables */
 	spinlock_t	lock; /* protect context, domain ids */
 	struct root_entry *root_entry; /* virtual address */
 
@@ -713,6 +712,11 @@ static inline int first_pte_in_page(struct dma_pte *pte)
 	return !((unsigned long)pte & ~VTD_PAGE_MASK);
 }
 
+static inline bool context_present(struct context_entry *context)
+{
+	return (context->lo & 1);
+}
+
 extern struct dmar_drhd_unit * dmar_find_matched_drhd_unit(struct pci_dev *dev);
 extern int dmar_find_matched_atsr_unit(struct pci_dev *dev);
 
@@ -806,7 +810,6 @@ static inline void intel_iommu_debugfs_init(void) {}
 #endif /* CONFIG_INTEL_IOMMU_DEBUGFS */
 
 extern const struct attribute_group *intel_iommu_groups[];
-bool context_present(struct context_entry *context);
 struct context_entry *iommu_context_addr(struct intel_iommu *iommu, u8 bus,
 					 u8 devfn, int alloc);
 
-- 
2.35.1



