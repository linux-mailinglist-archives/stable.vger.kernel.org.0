Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56DEB4FAB6C
	for <lists+stable@lfdr.de>; Sun, 10 Apr 2022 03:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234411AbiDJBkk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Apr 2022 21:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiDJBkk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Apr 2022 21:40:40 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF52053A7F
        for <stable@vger.kernel.org>; Sat,  9 Apr 2022 18:38:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649554710; x=1681090710;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=In+/QOrPU5IpcGY/W0qgls0wxYTkECZ2NYOwXQKNj5c=;
  b=DK8We4W9jRf+q0z1jBnB9GBLq4lTPDv1rAaNp+He4rA/LOghlSlUE7nG
   03XXrCP2vO/1UOlqOrR+VfxOhpZK0OLVkp5d5YYoYV/jg00U9JoeqOe9p
   nER+fzQnigDD8auUB3jaFi0Jqplb7+BZU9bXfgOGfa7751RHXgO2DDZ/+
   D7hDNHMjaLC0xCUX8XUt+IUllAJoLtBmRY1N34AoaoDmsar6/o4KuEL6S
   QaCUncrua91/7Y+bMSkaTJiaqHZ3XV9lsLuMl0iXlWMPqJgXfk9ms/Vjp
   hYY4a0CKTwCa5/g8sd3qyMQXiur+vJWK+nuQa3nYjyURjezpiy9Iy89oY
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10312"; a="262108781"
X-IronPort-AV: E=Sophos;i="5.90,248,1643702400"; 
   d="scan'208";a="262108781"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2022 18:38:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,248,1643702400"; 
   d="scan'208";a="610529709"
Received: from allen-box.sh.intel.com ([10.239.159.48])
  by fmsmga008.fm.intel.com with ESMTP; 09 Apr 2022 18:38:28 -0700
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     David Stevens <stevensd@chromium.org>,
        Kevin Tian <kevin.tian@intel.com>,
        iommu@lists.linux-foundation.org, stable@vger.kernel.org,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH 1/1] iommu/vt-d: Calculate mask for non-aligned flushes
Date:   Sun, 10 Apr 2022 09:35:33 +0800
Message-Id: <20220410013533.3959168-2-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220410013533.3959168-1-baolu.lu@linux.intel.com>
References: <20220410013533.3959168-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Stevens <stevensd@chromium.org>

Calculate the appropriate mask for non-size-aligned page selective
invalidation. Since psi uses the mask value to mask out the lower order
bits of the target address, properly flushing the iotlb requires using a
mask value such that [pfn, pfn+pages) all lie within the flushed
size-aligned region.  This is not normally an issue because iova.c
always allocates iovas that are aligned to their size. However, iovas
which come from other sources (e.g. userspace via VFIO) may not be
aligned.

To properly flush the IOTLB, both the start and end pfns need to be
equal after applying the mask. That means that the most efficient mask
to use is the index of the lowest bit that is equal where all higher
bits are also equal. For example, if pfn=0x17f and pages=3, then
end_pfn=0x181, so the smallest mask we can use is 8. Any differences
above the highest bit of pages are due to carrying, so by xnor'ing pfn
and end_pfn and then masking out the lower order bits based on pages, we
get 0xffffff00, where the first set bit is the mask we want to use.

Fixes: 6fe1010d6d9c ("vfio/type1: DMA unmap chunking")
Cc: stable@vger.kernel.org
Signed-off-by: David Stevens <stevensd@chromium.org>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/20220401022430.1262215-1-stevensd@google.com
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/iommu/intel/iommu.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index df5c62ecf942..0ea47e17b379 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -1588,7 +1588,8 @@ static void iommu_flush_iotlb_psi(struct intel_iommu *iommu,
 				  unsigned long pfn, unsigned int pages,
 				  int ih, int map)
 {
-	unsigned int mask = ilog2(__roundup_pow_of_two(pages));
+	unsigned int aligned_pages = __roundup_pow_of_two(pages);
+	unsigned int mask = ilog2(aligned_pages);
 	uint64_t addr = (uint64_t)pfn << VTD_PAGE_SHIFT;
 	u16 did = domain->iommu_did[iommu->seq_id];
 
@@ -1600,10 +1601,30 @@ static void iommu_flush_iotlb_psi(struct intel_iommu *iommu,
 	if (domain_use_first_level(domain)) {
 		qi_flush_piotlb(iommu, did, PASID_RID2PASID, addr, pages, ih);
 	} else {
+		unsigned long bitmask = aligned_pages - 1;
+
+		/*
+		 * PSI masks the low order bits of the base address. If the
+		 * address isn't aligned to the mask, then compute a mask value
+		 * needed to ensure the target range is flushed.
+		 */
+		if (unlikely(bitmask & pfn)) {
+			unsigned long end_pfn = pfn + pages - 1, shared_bits;
+
+			/*
+			 * Since end_pfn <= pfn + bitmask, the only way bits
+			 * higher than bitmask can differ in pfn and end_pfn is
+			 * by carrying. This means after masking out bitmask,
+			 * high bits starting with the first set bit in
+			 * shared_bits are all equal in both pfn and end_pfn.
+			 */
+			shared_bits = ~(pfn ^ end_pfn) & ~bitmask;
+			mask = shared_bits ? __ffs(shared_bits) : BITS_PER_LONG;
+		}
+
 		/*
 		 * Fallback to domain selective flush if no PSI support or
-		 * the size is too big. PSI requires page size to be 2 ^ x,
-		 * and the base address is naturally aligned to the size.
+		 * the size is too big.
 		 */
 		if (!cap_pgsel_inv(iommu->cap) ||
 		    mask > cap_max_amask_val(iommu->cap))
-- 
2.25.1

