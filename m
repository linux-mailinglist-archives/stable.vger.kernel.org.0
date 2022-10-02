Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44EB85F227B
	for <lists+stable@lfdr.de>; Sun,  2 Oct 2022 12:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229594AbiJBKU2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Oct 2022 06:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiJBKU0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Oct 2022 06:20:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 789A1220E8
        for <stable@vger.kernel.org>; Sun,  2 Oct 2022 03:20:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 14ED460DF1
        for <stable@vger.kernel.org>; Sun,  2 Oct 2022 10:20:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15962C433C1;
        Sun,  2 Oct 2022 10:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664706023;
        bh=v4dUjpyL/oliEo2duqHwXI98QgRRYS0s9aiFNR4p7So=;
        h=Subject:To:Cc:From:Date:From;
        b=m3RN0LyP19QvOu132xtOUoqYEZulhLA3L1Dtep7HXfg2p65VcAfM/z2esrab9eGeM
         aVzZlo/T4iSBiJA/995aLchEP7EbX0p4751T3M7JqKVm0b3S4Nkx8M+1Jc4XHhDZxR
         qZ1NvRk9h66mDkVxIks9VSAKUcsLTOIwKQin4utg=
Subject: FAILED: patch "[PATCH] mm: gup: fix the fast GUP race against THP collapse" failed to apply to 5.15-stable tree
To:     shy828301@gmail.com, akpm@linux-foundation.org,
        aneesh.kumar@linux.ibm.com, christophe.leroy@csgroup.eu,
        david@redhat.com, hughd@google.com, jgg@nvidia.com,
        jhubbard@nvidia.com, kirill.shutemov@linux.intel.com,
        mpe@ellerman.id.au, npiggin@gmail.com, peterx@redhat.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 02 Oct 2022 12:21:01 +0200
Message-ID: <1664706061218173@kroah.com>
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

70cbc3cc78a9 ("mm: gup: fix the fast GUP race against THP collapse")
b0496fe4effd ("mm/gup: Convert gup_pte_range() to use a folio")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 70cbc3cc78a997d8247b50389d37c4e1736019da Mon Sep 17 00:00:00 2001
From: Yang Shi <shy828301@gmail.com>
Date: Wed, 7 Sep 2022 11:01:43 -0700
Subject: [PATCH] mm: gup: fix the fast GUP race against THP collapse

Since general RCU GUP fast was introduced in commit 2667f50e8b81 ("mm:
introduce a general RCU get_user_pages_fast()"), a TLB flush is no longer
sufficient to handle concurrent GUP-fast in all cases, it only handles
traditional IPI-based GUP-fast correctly.  On architectures that send an
IPI broadcast on TLB flush, it works as expected.  But on the
architectures that do not use IPI to broadcast TLB flush, it may have the
below race:

   CPU A                                          CPU B
THP collapse                                     fast GUP
                                              gup_pmd_range() <-- see valid pmd
                                                  gup_pte_range() <-- work on pte
pmdp_collapse_flush() <-- clear pmd and flush
__collapse_huge_page_isolate()
    check page pinned <-- before GUP bump refcount
                                                      pin the page
                                                      check PTE <-- no change
__collapse_huge_page_copy()
    copy data to huge page
    ptep_clear()
install huge pmd for the huge page
                                                      return the stale page
discard the stale page

The race can be fixed by checking whether PMD is changed or not after
taking the page pin in fast GUP, just like what it does for PTE.  If the
PMD is changed it means there may be parallel THP collapse, so GUP should
back off.

Also update the stale comment about serializing against fast GUP in
khugepaged.

Link: https://lkml.kernel.org/r/20220907180144.555485-1-shy828301@gmail.com
Fixes: 2667f50e8b81 ("mm: introduce a general RCU get_user_pages_fast()")
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

diff --git a/mm/gup.c b/mm/gup.c
index 5abdaf487460..00926abb4426 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2345,8 +2345,28 @@ static void __maybe_unused undo_dev_pagemap(int *nr, int nr_start,
 }
 
 #ifdef CONFIG_ARCH_HAS_PTE_SPECIAL
-static int gup_pte_range(pmd_t pmd, unsigned long addr, unsigned long end,
-			 unsigned int flags, struct page **pages, int *nr)
+/*
+ * Fast-gup relies on pte change detection to avoid concurrent pgtable
+ * operations.
+ *
+ * To pin the page, fast-gup needs to do below in order:
+ * (1) pin the page (by prefetching pte), then (2) check pte not changed.
+ *
+ * For the rest of pgtable operations where pgtable updates can be racy
+ * with fast-gup, we need to do (1) clear pte, then (2) check whether page
+ * is pinned.
+ *
+ * Above will work for all pte-level operations, including THP split.
+ *
+ * For THP collapse, it's a bit more complicated because fast-gup may be
+ * walking a pgtable page that is being freed (pte is still valid but pmd
+ * can be cleared already).  To avoid race in such condition, we need to
+ * also check pmd here to make sure pmd doesn't change (corresponds to
+ * pmdp_collapse_flush() in the THP collapse code path).
+ */
+static int gup_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
+			 unsigned long end, unsigned int flags,
+			 struct page **pages, int *nr)
 {
 	struct dev_pagemap *pgmap = NULL;
 	int nr_start = *nr, ret = 0;
@@ -2392,7 +2412,8 @@ static int gup_pte_range(pmd_t pmd, unsigned long addr, unsigned long end,
 			goto pte_unmap;
 		}
 
-		if (unlikely(pte_val(pte) != pte_val(*ptep))) {
+		if (unlikely(pmd_val(pmd) != pmd_val(*pmdp)) ||
+		    unlikely(pte_val(pte) != pte_val(*ptep))) {
 			gup_put_folio(folio, 1, flags);
 			goto pte_unmap;
 		}
@@ -2439,8 +2460,9 @@ static int gup_pte_range(pmd_t pmd, unsigned long addr, unsigned long end,
  * get_user_pages_fast_only implementation that can pin pages. Thus it's still
  * useful to have gup_huge_pmd even if we can't operate on ptes.
  */
-static int gup_pte_range(pmd_t pmd, unsigned long addr, unsigned long end,
-			 unsigned int flags, struct page **pages, int *nr)
+static int gup_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
+			 unsigned long end, unsigned int flags,
+			 struct page **pages, int *nr)
 {
 	return 0;
 }
@@ -2764,7 +2786,7 @@ static int gup_pmd_range(pud_t *pudp, pud_t pud, unsigned long addr, unsigned lo
 			if (!gup_huge_pd(__hugepd(pmd_val(pmd)), addr,
 					 PMD_SHIFT, next, flags, pages, nr))
 				return 0;
-		} else if (!gup_pte_range(pmd, addr, next, flags, pages, nr))
+		} else if (!gup_pte_range(pmd, pmdp, addr, next, flags, pages, nr))
 			return 0;
 	} while (pmdp++, addr = next, addr != end);
 
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 01f71786d530..70b7ac66411c 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1083,10 +1083,12 @@ static void collapse_huge_page(struct mm_struct *mm,
 
 	pmd_ptl = pmd_lock(mm, pmd); /* probably unnecessary */
 	/*
-	 * After this gup_fast can't run anymore. This also removes
-	 * any huge TLB entry from the CPU so we won't allow
-	 * huge and small TLB entries for the same virtual address
-	 * to avoid the risk of CPU bugs in that area.
+	 * This removes any huge TLB entry from the CPU so we won't allow
+	 * huge and small TLB entries for the same virtual address to
+	 * avoid the risk of CPU bugs in that area.
+	 *
+	 * Parallel fast GUP is fine since fast GUP will back off when
+	 * it detects PMD is changed.
 	 */
 	_pmd = pmdp_collapse_flush(vma, address, pmd);
 	spin_unlock(pmd_ptl);

