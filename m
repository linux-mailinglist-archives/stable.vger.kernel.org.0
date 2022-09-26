Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 665725EB113
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 21:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbiIZTPh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 15:15:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbiIZTPf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 15:15:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F7A26AF5;
        Mon, 26 Sep 2022 12:15:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8656CB80D3C;
        Mon, 26 Sep 2022 19:15:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 224E1C433C1;
        Mon, 26 Sep 2022 19:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664219731;
        bh=3DP5Ew3qqZjt1d1Tms4noOGJuPAIzH6oZuVNLGb+ziA=;
        h=Date:To:From:Subject:From;
        b=Hy11V0iNDcKHd3/FRZbpFTOw7ZSMQLwzELB/zB+SabTRT5yGRCtLfHQTxNsq/WwGd
         bFGk76qJznP5ncbhpGzvrEPWWaQExd/JHSNbz8yBrgpBNeKNtmqplFYVHz9CqAHMYL
         KUrFxI9oaq66NPMlx/Asf1f8StAlUmzv88B5rWJQ=
Date:   Mon, 26 Sep 2022 12:15:30 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        peterx@redhat.com, npiggin@gmail.com, mpe@ellerman.id.au,
        kirill.shutemov@linux.intel.com, jhubbard@nvidia.com,
        jgg@nvidia.com, hughd@google.com, david@redhat.com,
        christophe.leroy@csgroup.eu, aneesh.kumar@linux.ibm.com,
        shy828301@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-gup-fix-the-fast-gup-race-against-thp-collapse.patch removed from -mm tree
Message-Id: <20220926191531.224E1C433C1@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm: gup: fix the fast GUP race against THP collapse
has been removed from the -mm tree.  Its filename was
     mm-gup-fix-the-fast-gup-race-against-thp-collapse.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yang Shi <shy828301@gmail.com>
Subject: mm: gup: fix the fast GUP race against THP collapse
Date: Wed, 7 Sep 2022 11:01:43 -0700

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
---

 mm/gup.c        |   34 ++++++++++++++++++++++++++++------
 mm/khugepaged.c |   10 ++++++----
 2 files changed, 34 insertions(+), 10 deletions(-)

--- a/mm/gup.c~mm-gup-fix-the-fast-gup-race-against-thp-collapse
+++ a/mm/gup.c
@@ -2357,8 +2357,28 @@ static void __maybe_unused undo_dev_page
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
@@ -2404,7 +2424,8 @@ static int gup_pte_range(pmd_t pmd, unsi
 			goto pte_unmap;
 		}
 
-		if (unlikely(pte_val(pte) != pte_val(*ptep))) {
+		if (unlikely(pmd_val(pmd) != pmd_val(*pmdp)) ||
+		    unlikely(pte_val(pte) != pte_val(*ptep))) {
 			gup_put_folio(folio, 1, flags);
 			goto pte_unmap;
 		}
@@ -2451,8 +2472,9 @@ pte_unmap:
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
@@ -2776,7 +2798,7 @@ static int gup_pmd_range(pud_t *pudp, pu
 			if (!gup_huge_pd(__hugepd(pmd_val(pmd)), addr,
 					 PMD_SHIFT, next, flags, pages, nr))
 				return 0;
-		} else if (!gup_pte_range(pmd, addr, next, flags, pages, nr))
+		} else if (!gup_pte_range(pmd, pmdp, addr, next, flags, pages, nr))
 			return 0;
 	} while (pmdp++, addr = next, addr != end);
 
--- a/mm/khugepaged.c~mm-gup-fix-the-fast-gup-race-against-thp-collapse
+++ a/mm/khugepaged.c
@@ -1083,10 +1083,12 @@ static void collapse_huge_page(struct mm
 
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
_

Patches currently in -mm which might be from shy828301@gmail.com are

mm-madv_collapse-refetch-vm_end-after-reacquiring-mmap_lock.patch

