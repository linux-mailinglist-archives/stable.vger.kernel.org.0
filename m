Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 051A35219BF
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244630AbiEJNvF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245479AbiEJNrp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:47:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99A574AE23;
        Tue, 10 May 2022 06:35:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4467B81DA2;
        Tue, 10 May 2022 13:35:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2072EC385A6;
        Tue, 10 May 2022 13:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189747;
        bh=8afKrTcSFrOsl6NLq2WePN47DZBqol78HM8qqa1Bh2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t19MfabBluxsyo94hTsXlMns3FfnlLfUxfSLCt05k2OiSCNscsoiX2xuL0fcr71Wq
         SVzXGqjRJAIFB8I1tVMfJiu5ZniTwgNdlVRzczUITJ0CnWs2vQHEXX2ws6zhQzDC4a
         oCupf7MSjdYAQcKHnUl+RT1o0ssAkRFAhOGN487k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Stevens <stevensd@chromium.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.17 016/140] iommu/vt-d: Calculate mask for non-aligned flushes
Date:   Tue, 10 May 2022 15:06:46 +0200
Message-Id: <20220510130742.070972532@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
References: <20220510130741.600270947@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Stevens <stevensd@chromium.org>

commit 59bf3557cf2f8a469a554aea1e3d2c8e72a579f7 upstream.

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
Link: https://lore.kernel.org/r/20220410013533.3959168-2-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/intel/iommu.c |   27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -1717,7 +1717,8 @@ static void iommu_flush_iotlb_psi(struct
 				  unsigned long pfn, unsigned int pages,
 				  int ih, int map)
 {
-	unsigned int mask = ilog2(__roundup_pow_of_two(pages));
+	unsigned int aligned_pages = __roundup_pow_of_two(pages);
+	unsigned int mask = ilog2(aligned_pages);
 	uint64_t addr = (uint64_t)pfn << VTD_PAGE_SHIFT;
 	u16 did = domain->iommu_did[iommu->seq_id];
 
@@ -1729,10 +1730,30 @@ static void iommu_flush_iotlb_psi(struct
 	if (domain_use_first_level(domain)) {
 		domain_flush_piotlb(iommu, domain, addr, pages, ih);
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


