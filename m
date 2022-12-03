Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD1364166C
	for <lists+stable@lfdr.de>; Sat,  3 Dec 2022 12:23:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbiLCLXC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Dec 2022 06:23:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbiLCLXA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Dec 2022 06:23:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F371E15708
        for <stable@vger.kernel.org>; Sat,  3 Dec 2022 03:22:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A843D60BC1
        for <stable@vger.kernel.org>; Sat,  3 Dec 2022 11:22:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B79B0C433D6;
        Sat,  3 Dec 2022 11:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670066578;
        bh=0k42c5e2+Dt+mfF346KiuVukE92AN9MujlAFsNyZshI=;
        h=Subject:To:Cc:From:Date:From;
        b=Vqx15Tsfw0rKsrcZO4R+idQdxnHyzUcvjQPDLRgOQyQ2dI1HPem2b61IeU3MtTJ+e
         5uO5qNs+vE5nSu2BpRwcM861SSmt/lHdJ2USPOQ3SQ+667U7zNavGFmTFnyHD/BsTr
         IPdyHOiRvtdk1ikKxRKIX0xi5FMqyeqamPvhM7xA=
Subject: FAILED: patch "[PATCH] madvise: use zap_page_range_single for madvise dontneed" failed to apply to 6.0-stable tree
To:     mike.kravetz@oracle.com, akpm@linux-foundation.org,
        almasrymina@google.com, axelrasmussen@google.com, david@redhat.com,
        harperchen1110@gmail.com, nadav.amit@gmail.com,
        naoya.horiguchi@linux.dev, peterx@redhat.com, riel@surriel.com,
        stable@vger.kernel.org, vbabka@suse.cz, willy@infradead.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 03 Dec 2022 12:22:48 +0100
Message-ID: <1670066568575@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.0-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

21b85b09527c ("madvise: use zap_page_range_single for madvise dontneed")
763ecb035029 ("mm: remove the vma linked list")
8220543df148 ("nommu: remove uses of VMA linked list")
11f9a21ab655 ("mm/mmap: reorganize munmap to use maple states")
e99668a56430 ("mm/mmap: move mmap_region() below do_munmap()")
7964cf8caa4d ("mm: remove vmacache")
4dd1b84140c1 ("mm/mmap: use advanced maple tree API for mmap_region()")
abdba2dda0c4 ("mm: use maple tree operations for find_vma_intersection()")
2e7ce7d354f2 ("mm/mmap: change do_brk_flags() to expand existing VMA and add do_brk_munmap()")
3b0e81a1cdc9 ("mmap: change zeroing of maple tree in __vma_adjust()")
524e00b36e8c ("mm: remove rb tree.")
c9dbe82cb99d ("kernel/fork: use maple tree for dup_mmap() during forking")
3499a13168da ("mm/mmap: use maple tree for unmapped_area{_topdown}")
be8432e7166e ("mm/mmap: use the maple tree in find_vma() instead of the rbtree.")
2e3af1db1744 ("mmap: use the VMA iterator in count_vma_pages_range()")
f39af05949a4 ("mm: add VMA iterator")
d4af56c5c7c6 ("mm: start tracking VMAs with maple tree")
54a611b60590 ("Maple Tree: add new data structure")
bd74fdaea146 ("mm: multi-gen LRU: support page table walks")
018ee47f1489 ("mm: multi-gen LRU: exploit locality in rmap")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 21b85b09527c28e242db55c1b751f7f7549b830c Mon Sep 17 00:00:00 2001
From: Mike Kravetz <mike.kravetz@oracle.com>
Date: Mon, 14 Nov 2022 15:55:05 -0800
Subject: [PATCH] madvise: use zap_page_range_single for madvise dontneed

This series addresses the issue first reported in [1], and fully described
in patch 2.  Patches 1 and 2 address the user visible issue and are tagged
for stable backports.

While exploring solutions to this issue, related problems with mmu
notification calls were discovered.  This is addressed in the patch
"hugetlb: remove duplicate mmu notifications:".  Since there are no user
visible effects, this third is not tagged for stable backports.

Previous discussions suggested further cleanup by removing the
routine zap_page_range.  This is possible because zap_page_range_single
is now exported, and all callers of zap_page_range pass ranges entirely
within a single vma.  This work will be done in a later patch so as not
to distract from this bug fix.

[1] https://lore.kernel.org/lkml/CAO4mrfdLMXsao9RF4fUE8-Wfde8xmjsKrTNMNC9wjUb6JudD0g@mail.gmail.com/


This patch (of 2):

Expose the routine zap_page_range_single to zap a range within a single
vma.  The madvise routine madvise_dontneed_single_vma can use this routine
as it explicitly operates on a single vma.  Also, update the mmu
notification range in zap_page_range_single to take hugetlb pmd sharing
into account.  This is required as MADV_DONTNEED supports hugetlb vmas.

Link: https://lkml.kernel.org/r/20221114235507.294320-1-mike.kravetz@oracle.com
Link: https://lkml.kernel.org/r/20221114235507.294320-2-mike.kravetz@oracle.com
Fixes: 90e7e7f5ef3f ("mm: enable MADV_DONTNEED for hugetlb mappings")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reported-by: Wei Chen <harperchen1110@gmail.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 8bbcccbc5565..cbfb489d381c 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1852,6 +1852,23 @@ static void __maybe_unused show_free_areas(unsigned int flags, nodemask_t *nodem
 	__show_free_areas(flags, nodemask, MAX_NR_ZONES - 1);
 }
 
+/*
+ * Parameter block passed down to zap_pte_range in exceptional cases.
+ */
+struct zap_details {
+	struct folio *single_folio;	/* Locked folio to be unmapped */
+	bool even_cows;			/* Zap COWed private pages too? */
+	zap_flags_t zap_flags;		/* Extra flags for zapping */
+};
+
+/*
+ * Whether to drop the pte markers, for example, the uffd-wp information for
+ * file-backed memory.  This should only be specified when we will completely
+ * drop the page in the mm, either by truncation or unmapping of the vma.  By
+ * default, the flag is not set.
+ */
+#define  ZAP_FLAG_DROP_MARKER        ((__force zap_flags_t) BIT(0))
+
 #ifdef CONFIG_MMU
 extern bool can_do_mlock(void);
 #else
@@ -1869,6 +1886,8 @@ void zap_vma_ptes(struct vm_area_struct *vma, unsigned long address,
 		  unsigned long size);
 void zap_page_range(struct vm_area_struct *vma, unsigned long address,
 		    unsigned long size);
+void zap_page_range_single(struct vm_area_struct *vma, unsigned long address,
+			   unsigned long size, struct zap_details *details);
 void unmap_vmas(struct mmu_gather *tlb, struct maple_tree *mt,
 		struct vm_area_struct *start_vma, unsigned long start,
 		unsigned long end);
@@ -3467,12 +3486,4 @@ madvise_set_anon_name(struct mm_struct *mm, unsigned long start,
 }
 #endif
 
-/*
- * Whether to drop the pte markers, for example, the uffd-wp information for
- * file-backed memory.  This should only be specified when we will completely
- * drop the page in the mm, either by truncation or unmapping of the vma.  By
- * default, the flag is not set.
- */
-#define  ZAP_FLAG_DROP_MARKER        ((__force zap_flags_t) BIT(0))
-
 #endif /* _LINUX_MM_H */
diff --git a/mm/madvise.c b/mm/madvise.c
index c7105ec6d08c..b913ba6efc10 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -772,8 +772,8 @@ static int madvise_free_single_vma(struct vm_area_struct *vma,
  * Application no longer needs these pages.  If the pages are dirty,
  * it's OK to just throw them away.  The app will be more careful about
  * data it wants to keep.  Be sure to free swap resources too.  The
- * zap_page_range call sets things up for shrink_active_list to actually free
- * these pages later if no one else has touched them in the meantime,
+ * zap_page_range_single call sets things up for shrink_active_list to actually
+ * free these pages later if no one else has touched them in the meantime,
  * although we could add these pages to a global reuse list for
  * shrink_active_list to pick up before reclaiming other pages.
  *
@@ -790,7 +790,7 @@ static int madvise_free_single_vma(struct vm_area_struct *vma,
 static long madvise_dontneed_single_vma(struct vm_area_struct *vma,
 					unsigned long start, unsigned long end)
 {
-	zap_page_range(vma, start, end - start);
+	zap_page_range_single(vma, start, end - start, NULL);
 	return 0;
 }
 
diff --git a/mm/memory.c b/mm/memory.c
index 8a6d5c823f91..9bc5edc35725 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1341,15 +1341,6 @@ copy_page_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma)
 	return ret;
 }
 
-/*
- * Parameter block passed down to zap_pte_range in exceptional cases.
- */
-struct zap_details {
-	struct folio *single_folio;	/* Locked folio to be unmapped */
-	bool even_cows;			/* Zap COWed private pages too? */
-	zap_flags_t zap_flags;		/* Extra flags for zapping */
-};
-
 /* Whether we should zap all COWed (private) pages too */
 static inline bool should_zap_cows(struct zap_details *details)
 {
@@ -1774,19 +1765,27 @@ void zap_page_range(struct vm_area_struct *vma, unsigned long start,
  *
  * The range must fit into one VMA.
  */
-static void zap_page_range_single(struct vm_area_struct *vma, unsigned long address,
+void zap_page_range_single(struct vm_area_struct *vma, unsigned long address,
 		unsigned long size, struct zap_details *details)
 {
+	const unsigned long end = address + size;
 	struct mmu_notifier_range range;
 	struct mmu_gather tlb;
 
 	lru_add_drain();
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, vma->vm_mm,
-				address, address + size);
+				address, end);
+	if (is_vm_hugetlb_page(vma))
+		adjust_range_if_pmd_sharing_possible(vma, &range.start,
+						     &range.end);
 	tlb_gather_mmu(&tlb, vma->vm_mm);
 	update_hiwater_rss(vma->vm_mm);
 	mmu_notifier_invalidate_range_start(&range);
-	unmap_single_vma(&tlb, vma, address, range.end, details);
+	/*
+	 * unmap 'address-end' not 'range.start-range.end' as range
+	 * could have been expanded for hugetlb pmd sharing.
+	 */
+	unmap_single_vma(&tlb, vma, address, end, details);
 	mmu_notifier_invalidate_range_end(&range);
 	tlb_finish_mmu(&tlb);
 }

