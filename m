Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1116D5870C2
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 21:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233928AbiHATCz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 15:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233550AbiHATCs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 15:02:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D872331DD6;
        Mon,  1 Aug 2022 12:02:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1EE0DB81629;
        Mon,  1 Aug 2022 19:02:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA4CBC433D7;
        Mon,  1 Aug 2022 19:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659380556;
        bh=ZbgSdsrNcYnu7b0F+osAGYaeUQTYn6xkQ7jo2y29VpA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LRJtLubAlkZnd+71Wnk5BLJ3tP6VqtO4raaaRpc5NZtQWPJpObXRq7HnI2e0SQavk
         hE5+Xi9YLudQLfHezZKq9py8THdyLynf0lLrUP+OcEug6/mNgBN81Zr7KklzuMB2w9
         Bk7zMSBAZApbz3URdTp8oP28Uz5EjDpmP0sfEpuBPDHH7sa9tL+/58zZIzKDhRLSSL
         Ef4U3ruCJGYmDysjdbd5JDPp/m7NDQCLoqojo1Z7NTpy1fOMO5NksjtoPd5Mbckfr8
         3hCe57C7Lnd7HrxUYeXjOgoT5sV8y8Hrjin2ZaaByvVn288EC2PeHx3htm4jNSp2i5
         CStOZA30yTQoA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, aneesh.kumar@linux.ibm.com,
        npiggin@gmail.com, linux-arch@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH AUTOSEL 5.18 07/10] mmu_gather: Force tlb-flush VM_PFNMAP vmas
Date:   Mon,  1 Aug 2022 15:02:19 -0400
Message-Id: <20220801190222.3818378-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220801190222.3818378-1-sashal@kernel.org>
References: <20220801190222.3818378-1-sashal@kernel.org>
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
index 11ad549b5014..1306d85f5b18 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -288,6 +288,7 @@ struct mmu_gather {
 	 */
 	unsigned int		vma_exec : 1;
 	unsigned int		vma_huge : 1;
+	unsigned int		vma_pfn  : 1;
 
 	unsigned int		batch_count;
 
@@ -358,7 +359,6 @@ tlb_update_vma_flags(struct mmu_gather *tlb, struct vm_area_struct *vma) { }
 #else /* CONFIG_MMU_GATHER_NO_RANGE */
 
 #ifndef tlb_flush
-
 /*
  * When an architecture does not provide its own tlb_flush() implementation
  * but does have a reasonably efficient flush_vma_range() implementation
@@ -378,6 +378,9 @@ static inline void tlb_flush(struct mmu_gather *tlb)
 		flush_tlb_range(&vma, tlb->start, tlb->end);
 	}
 }
+#endif
+
+#endif /* CONFIG_MMU_GATHER_NO_RANGE */
 
 static inline void
 tlb_update_vma_flags(struct mmu_gather *tlb, struct vm_area_struct *vma)
@@ -395,17 +398,9 @@ tlb_update_vma_flags(struct mmu_gather *tlb, struct vm_area_struct *vma)
 	 */
 	tlb->vma_huge = is_vm_hugetlb_page(vma);
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
 	/*
@@ -494,12 +489,18 @@ static inline void tlb_end_vma(struct mmu_gather *tlb, struct vm_area_struct *vm
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

