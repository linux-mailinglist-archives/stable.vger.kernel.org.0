Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA0B587107
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 21:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234348AbiHATGA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 15:06:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234480AbiHATFI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 15:05:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0835422DF;
        Mon,  1 Aug 2022 12:03:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C119EB81615;
        Mon,  1 Aug 2022 19:03:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 454CBC43142;
        Mon,  1 Aug 2022 19:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659380605;
        bh=+4SKTbw3nLXOlgU1lDhCJECLQjdJh357I9ceTKF9pwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QX8r6atMPhqcjN7IJB0k1qFfzDCjtMt49El1V0xg2N7k+dAj52lsx2d/xOS+xBrbx
         84kEuj+yvIiaEg2gq8AtZadjoZt7WObXroMBrpu0U9ehbqruR/HgeE4AdHn9qiS8z+
         4r+TbIlgxoBf5fAyuux7ejCf0KsVfuUk7uN6dK/rAMIV3GarIVfk8I3IwFQ+lJSxea
         rxyuXoeL5BOV2wkwpHTITmnMvNgvNXxBKnyMZD4hdCcylpwYP48fXru5nnOb3NY/Ul
         o7UEb6XhkVd8pgbXBaF+VJlD80Qct3gJyo61madl04SHp8DLfw9OjObsp+nx5DwvlZ
         JdzVhkg11VBDQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, aneesh.kumar@linux.ibm.com,
        npiggin@gmail.com, linux-arch@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH AUTOSEL 5.4 4/6] mmu_gather: Force tlb-flush VM_PFNMAP vmas
Date:   Mon,  1 Aug 2022 15:03:15 -0400
Message-Id: <20220801190317.3819520-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220801190317.3819520-1-sashal@kernel.org>
References: <20220801190317.3819520-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit b67fbebd4cf980aecbcc750e1462128bffe8ae15 ]

Jann reported a race between munmap() and unmap_mapping_range(), where
unmap_mapping_range() will no-op once unmap_vmas() has unlinked the
VMA; however munmap() will not yet have invalidated the TLBs.

Therefore unmap_mapping_range() will complete while there are still
(stale) TLB entries for the specified range.

Mitigate this by force flushing TLBs for VM_PFNMAP ranges.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/asm-generic/tlb.h | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index fe05a8562c52..c44f7ac97f19 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -271,6 +271,7 @@ struct mmu_gather {
 	 */
 	unsigned int		vma_exec : 1;
 	unsigned int		vma_huge : 1;
+	unsigned int		vma_pfn  : 1;
 
 	unsigned int		batch_count;
 
@@ -345,7 +346,6 @@ tlb_update_vma_flags(struct mmu_gather *tlb, struct vm_area_struct *vma) { }
 #else /* CONFIG_MMU_GATHER_NO_RANGE */
 
 #ifndef tlb_flush
-
 /*
  * When an architecture does not provide its own tlb_flush() implementation
  * but does have a reasonably efficient flush_vma_range() implementation
@@ -365,6 +365,9 @@ static inline void tlb_flush(struct mmu_gather *tlb)
 		flush_tlb_range(&vma, tlb->start, tlb->end);
 	}
 }
+#endif
+
+#endif /* CONFIG_MMU_GATHER_NO_RANGE */
 
 static inline void
 tlb_update_vma_flags(struct mmu_gather *tlb, struct vm_area_struct *vma)
@@ -382,17 +385,9 @@ tlb_update_vma_flags(struct mmu_gather *tlb, struct vm_area_struct *vma)
 	 */
 	tlb->vma_huge = !!(vma->vm_flags & VM_HUGETLB);
 	tlb->vma_exec = !!(vma->vm_flags & VM_EXEC);
+	tlb->vma_pfn  = !!(vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP));
 }
 
-#else
-
-static inline void
-tlb_update_vma_flags(struct mmu_gather *tlb, struct vm_area_struct *vma) { }
-
-#endif
-
-#endif /* CONFIG_MMU_GATHER_NO_RANGE */
-
 static inline void tlb_flush_mmu_tlbonly(struct mmu_gather *tlb)
 {
 	if (!tlb->end)
@@ -476,12 +471,18 @@ static inline void tlb_end_vma(struct mmu_gather *tlb, struct vm_area_struct *vm
 		return;
 
 	/*
-	 * Do a TLB flush and reset the range at VMA boundaries; this avoids
-	 * the ranges growing with the unused space between consecutive VMAs,
-	 * but also the mmu_gather::vma_* flags from tlb_start_vma() rely on
-	 * this.
+	 * VM_PFNMAP is more fragile because the core mm will not track the
+	 * page mapcount -- there might not be page-frames for these PFNs after
+	 * all. Force flush TLBs for such ranges to avoid munmap() vs
+	 * unmap_mapping_range() races.
 	 */
-	tlb_flush_mmu_tlbonly(tlb);
+	if (tlb->vma_pfn || !IS_ENABLED(CONFIG_MMU_GATHER_MERGE_VMAS)) {
+		/*
+		 * Do a TLB flush and reset the range at VMA boundaries; this avoids
+		 * the ranges growing with the unused space between consecutive VMAs.
+		 */
+		tlb_flush_mmu_tlbonly(tlb);
+	}
 }
 
 /*
-- 
2.35.1

