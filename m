Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFBD563E3AC
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 23:51:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiK3Wvi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 17:51:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiK3Wvh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 17:51:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC19C748F8;
        Wed, 30 Nov 2022 14:51:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B06861E24;
        Wed, 30 Nov 2022 22:51:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAE87C433D6;
        Wed, 30 Nov 2022 22:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669848695;
        bh=oxK8dKbzdhAqn6tIMmcBlFcl8mifIOeGGcyvAczGw+w=;
        h=Date:To:From:Subject:From;
        b=K9ynGCR2nfBxUwMWJs6dMEs5yEB8ACi3W+hDtOkI3UlVn5dRKFTXpiovAeaqC3IXs
         XCkn5QKQbs9cuh+DC1Yb7SUrrpNQGzwKUlZiqp6APDzV9mIsWnHe27i2Oh49ef2bYb
         6pWk2+FtosLG5oAfsMH99ygKfmxFl8tFqm/ShfLU=
Date:   Wed, 30 Nov 2022 14:51:34 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        stable@vger.kernel.org, riel@surriel.com, peterx@redhat.com,
        naoya.horiguchi@linux.dev, nadav.amit@gmail.com,
        harperchen1110@gmail.com, david@redhat.com,
        axelrasmussen@google.com, almasrymina@google.com,
        mike.kravetz@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] madvise-use-zap_page_range_single-for-madvise-dontneed.patch removed from -mm tree
Message-Id: <20221130225135.AAE87C433D6@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: madvise: use zap_page_range_single for madvise dontneed
has been removed from the -mm tree.  Its filename was
     madvise-use-zap_page_range_single-for-madvise-dontneed.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: madvise: use zap_page_range_single for madvise dontneed
Date: Mon, 14 Nov 2022 15:55:05 -0800

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
---

 include/linux/mm.h |   27 +++++++++++++++++++--------
 mm/madvise.c       |    6 +++---
 mm/memory.c        |   23 +++++++++++------------
 3 files changed, 33 insertions(+), 23 deletions(-)

--- a/include/linux/mm.h~madvise-use-zap_page_range_single-for-madvise-dontneed
+++ a/include/linux/mm.h
@@ -1852,6 +1852,23 @@ static void __maybe_unused show_free_are
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
@@ -1869,6 +1886,8 @@ void zap_vma_ptes(struct vm_area_struct
 		  unsigned long size);
 void zap_page_range(struct vm_area_struct *vma, unsigned long address,
 		    unsigned long size);
+void zap_page_range_single(struct vm_area_struct *vma, unsigned long address,
+			   unsigned long size, struct zap_details *details);
 void unmap_vmas(struct mmu_gather *tlb, struct maple_tree *mt,
 		struct vm_area_struct *start_vma, unsigned long start,
 		unsigned long end);
@@ -3467,12 +3486,4 @@ madvise_set_anon_name(struct mm_struct *
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
--- a/mm/madvise.c~madvise-use-zap_page_range_single-for-madvise-dontneed
+++ a/mm/madvise.c
@@ -772,8 +772,8 @@ static int madvise_free_single_vma(struc
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
@@ -790,7 +790,7 @@ static int madvise_free_single_vma(struc
 static long madvise_dontneed_single_vma(struct vm_area_struct *vma,
 					unsigned long start, unsigned long end)
 {
-	zap_page_range(vma, start, end - start);
+	zap_page_range_single(vma, start, end - start, NULL);
 	return 0;
 }
 
--- a/mm/memory.c~madvise-use-zap_page_range_single-for-madvise-dontneed
+++ a/mm/memory.c
@@ -1341,15 +1341,6 @@ copy_page_range(struct vm_area_struct *d
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
@@ -1774,19 +1765,27 @@ void zap_page_range(struct vm_area_struc
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
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

selftests-vm-update-hugetlb-madvise.patch
hugetlb-remove-duplicate-mmu-notifications.patch

