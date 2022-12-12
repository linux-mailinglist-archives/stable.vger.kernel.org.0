Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC1864A118
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:35:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232330AbiLLNe4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:34:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232650AbiLLNez (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:34:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4692B13E12
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:34:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06CFFB80D50
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:34:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02AACC433D2;
        Mon, 12 Dec 2022 13:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670852091;
        bh=8NqRGz+tlm88FZK6iH96S4jTC2qkc9CFlCu4rv/riSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aPrEUjOJ270NLg7j8i2KmhePUeJAbcwasIH2rfcYTUwwqWc2qz38QpMU68fBU7bj2
         BUAD/wI1dHMJ5Hs8Mi5Aw8S866hvbjWL/Ek9VBYMXc4UPajiv4qDLlxnvNqPJ5ZdsH
         OQ74g1MeIr2eEvs2+fliAZtF2YBUBiCbQlPf4awc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mike Kravetz <mike.kravetz@oracle.com>,
        Wei Chen <harperchen1110@gmail.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        David Hildenbrand <david@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Mina Almasry <almasrymina@google.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Naoya Horiguchi <naoya.horiguchi@linux.dev>,
        Peter Xu <peterx@redhat.com>, Rik van Riel <riel@surriel.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 001/157] madvise: use zap_page_range_single for madvise dontneed
Date:   Mon, 12 Dec 2022 14:15:49 +0100
Message-Id: <20221212130934.416697866@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
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

From: Mike Kravetz <mike.kravetz@oracle.com>

[ Upstream commit 21b85b09527c28e242db55c1b751f7f7549b830c ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mm.h | 27 +++++++++++++++++++--------
 mm/madvise.c       |  6 +++---
 mm/memory.c        | 23 +++++++++++------------
 3 files changed, 33 insertions(+), 23 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 21f8b27bd9fd..df804bf5f4a5 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1778,6 +1778,23 @@ extern void pagefault_out_of_memory(void);
 
 extern void show_free_areas(unsigned int flags, nodemask_t *nodemask);
 
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
@@ -1797,6 +1814,8 @@ void zap_page_range(struct vm_area_struct *vma, unsigned long address,
 		    unsigned long size);
 void unmap_vmas(struct mmu_gather *tlb, struct vm_area_struct *start_vma,
 		unsigned long start, unsigned long end);
+void zap_page_range_single(struct vm_area_struct *vma, unsigned long address,
+			   unsigned long size, struct zap_details *details);
 
 struct mmu_notifier_range;
 
@@ -3386,12 +3405,4 @@ madvise_set_anon_name(struct mm_struct *mm, unsigned long start,
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
index 98ed17a4471a..b2831b57aef8 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -770,8 +770,8 @@ static int madvise_free_single_vma(struct vm_area_struct *vma,
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
@@ -788,7 +788,7 @@ static int madvise_free_single_vma(struct vm_area_struct *vma,
 static long madvise_dontneed_single_vma(struct vm_area_struct *vma,
 					unsigned long start, unsigned long end)
 {
-	zap_page_range(vma, start, end - start);
+	zap_page_range_single(vma, start, end - start, NULL);
 	return 0;
 }
 
diff --git a/mm/memory.c b/mm/memory.c
index de0dbe09b013..68d5b3dcec2e 100644
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
@@ -1769,19 +1760,27 @@ void zap_page_range(struct vm_area_struct *vma, unsigned long start,
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
-- 
2.35.1



