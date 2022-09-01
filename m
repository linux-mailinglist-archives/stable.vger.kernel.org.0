Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7815AA059
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 21:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233994AbiIATrB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 15:47:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiIATrA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 15:47:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16D7D86B5A;
        Thu,  1 Sep 2022 12:46:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99DF6B825DC;
        Thu,  1 Sep 2022 19:46:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DC00C433D6;
        Thu,  1 Sep 2022 19:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662061616;
        bh=UjTusUM8YH1BcCSwd28legk1+gUPPxjxcHJCXDf+2mo=;
        h=Date:To:From:Subject:From;
        b=K7d4TtTE08OjUgRHFHkCFFwmvzbDSyW/GlyZf8ByCb9Hj0/n0b2Jn2jQBmmJ4ekwL
         Pc2Q8jYl2zDl7OpE8zyhyKxDz5WtBvDmSwu74HijlXEUox7M7SG4VGwcUQntw93kRA
         HDB6F+nzYgUwVMKHOKJZtsaTcn2nFPL8tRQoShgI=
Date:   Thu, 01 Sep 2022 12:46:55 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        songmuchun@bytedance.com, mike.kravetz@oracle.com,
        david@redhat.com, baolin.wang@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-fix-races-when-looking-up-a-cont-pte-pmd-size-hugetlb-page.patch added to mm-hotfixes-unstable branch
Message-Id: <20220901194656.4DC00C433D6@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: fix races when looking up a CONT-PTE/PMD size hugetlb page
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb-fix-races-when-looking-up-a-cont-pte-pmd-size-hugetlb-page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-fix-races-when-looking-up-a-cont-pte-pmd-size-hugetlb-page.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm/hugetlb: fix races when looking up a CONT-PTE/PMD size hugetlb page
Date: Thu, 1 Sep 2022 18:41:31 +0800

On some architectures (like ARM64), it can support CONT-PTE/PMD size
hugetlb, which means it can support not only PMD/PUD size hugetlb (2M and
1G), but also CONT-PTE/PMD size(64K and 32M) if a 4K page size specified.

So when looking up a CONT-PTE size hugetlb page by follow_page(), it will
use pte_offset_map_lock() to get the pte entry lock for the CONT-PTE size
hugetlb in follow_page_pte().  However this pte entry lock is incorrect
for the CONT-PTE size hugetlb, since we should use huge_pte_lock() to get
the correct lock, which is mm->page_table_lock.

That means the pte entry of the CONT-PTE size hugetlb under current pte
lock is unstable in follow_page_pte(), we can continue to migrate or
poison the pte entry of the CONT-PTE size hugetlb, which can cause some
potential race issues, even though they are under the 'pte lock'.

For example, suppose thread A is trying to look up a CONT-PTE size hugetlb
page by move_pages() syscall under the lock, however antoher thread B can
migrate the CONT-PTE hugetlb page at the same time, which will cause
thread A to get an incorrect page, if thread A also wants to do page
migration, then data inconsistency error occurs.

Moreover we have the same issue for CONT-PMD size hugetlb in
follow_huge_pmd().

To fix above issues, rename the follow_huge_pmd() as follow_huge_pmd_pte()
to handle PMD and PTE level size hugetlb, which uses huge_pte_lock() to
get the correct pte entry lock to make the pte entry stable.

Link: https://lkml.kernel.org/r/635f43bdd85ac2615a58405da82b4d33c6e5eb05.1662017562.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Suggested-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    8 ++++----
 mm/gup.c                |   14 +++++++++++++-
 mm/hugetlb.c            |   27 +++++++++++++--------------
 3 files changed, 30 insertions(+), 19 deletions(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-fix-races-when-looking-up-a-cont-pte-pmd-size-hugetlb-page
+++ a/include/linux/hugetlb.h
@@ -207,8 +207,8 @@ struct page *follow_huge_addr(struct mm_
 struct page *follow_huge_pd(struct vm_area_struct *vma,
 			    unsigned long address, hugepd_t hpd,
 			    int flags, int pdshift);
-struct page *follow_huge_pmd(struct mm_struct *mm, unsigned long address,
-				pmd_t *pmd, int flags);
+struct page *follow_huge_pmd_pte(struct vm_area_struct *vma, unsigned long address,
+				 int flags);
 struct page *follow_huge_pud(struct mm_struct *mm, unsigned long address,
 				pud_t *pud, int flags);
 struct page *follow_huge_pgd(struct mm_struct *mm, unsigned long address,
@@ -312,8 +312,8 @@ static inline struct page *follow_huge_p
 	return NULL;
 }
 
-static inline struct page *follow_huge_pmd(struct mm_struct *mm,
-				unsigned long address, pmd_t *pmd, int flags)
+static inline struct page *follow_huge_pmd_pte(struct vm_area_struct *vma,
+				unsigned long address, int flags)
 {
 	return NULL;
 }
--- a/mm/gup.c~mm-hugetlb-fix-races-when-looking-up-a-cont-pte-pmd-size-hugetlb-page
+++ a/mm/gup.c
@@ -530,6 +530,18 @@ static struct page *follow_page_pte(stru
 	if (WARN_ON_ONCE((flags & (FOLL_PIN | FOLL_GET)) ==
 			 (FOLL_PIN | FOLL_GET)))
 		return ERR_PTR(-EINVAL);
+
+	/*
+	 * Considering PTE level hugetlb, like continuous-PTE hugetlb on
+	 * ARM64 architecture.
+	 */
+	if (is_vm_hugetlb_page(vma)) {
+		page = follow_huge_pmd_pte(vma, address, flags);
+		if (page)
+			return page;
+		return no_page_table(vma, flags);
+	}
+
 retry:
 	if (unlikely(pmd_bad(*pmd)))
 		return no_page_table(vma, flags);
@@ -662,7 +674,7 @@ static struct page *follow_pmd_mask(stru
 	if (pmd_none(pmdval))
 		return no_page_table(vma, flags);
 	if (pmd_huge(pmdval) && is_vm_hugetlb_page(vma)) {
-		page = follow_huge_pmd(mm, address, pmd, flags);
+		page = follow_huge_pmd_pte(vma, address, flags);
 		if (page)
 			return page;
 		return no_page_table(vma, flags);
--- a/mm/hugetlb.c~mm-hugetlb-fix-races-when-looking-up-a-cont-pte-pmd-size-hugetlb-page
+++ a/mm/hugetlb.c
@@ -6944,12 +6944,13 @@ follow_huge_pd(struct vm_area_struct *vm
 }
 
 struct page * __weak
-follow_huge_pmd(struct mm_struct *mm, unsigned long address,
-		pmd_t *pmd, int flags)
+follow_huge_pmd_pte(struct vm_area_struct *vma, unsigned long address, int flags)
 {
+	struct hstate *h = hstate_vma(vma);
+	struct mm_struct *mm = vma->vm_mm;
 	struct page *page = NULL;
 	spinlock_t *ptl;
-	pte_t pte;
+	pte_t *ptep, pte;
 
 	/*
 	 * FOLL_PIN is not supported for follow_page(). Ordinary GUP goes via
@@ -6959,17 +6960,15 @@ follow_huge_pmd(struct mm_struct *mm, un
 		return NULL;
 
 retry:
-	ptl = pmd_lockptr(mm, pmd);
-	spin_lock(ptl);
-	/*
-	 * make sure that the address range covered by this pmd is not
-	 * unmapped from other threads.
-	 */
-	if (!pmd_huge(*pmd))
-		goto out;
-	pte = huge_ptep_get((pte_t *)pmd);
+	ptep = huge_pte_offset(mm, address, huge_page_size(h));
+	if (!ptep)
+		return NULL;
+
+	ptl = huge_pte_lock(h, mm, ptep);
+	pte = huge_ptep_get(ptep);
 	if (pte_present(pte)) {
-		page = pmd_page(*pmd) + ((address & ~PMD_MASK) >> PAGE_SHIFT);
+		page = pte_page(pte) +
+			((address & ~huge_page_mask(h)) >> PAGE_SHIFT);
 		/*
 		 * try_grab_page() should always succeed here, because: a) we
 		 * hold the pmd (ptl) lock, and b) we've just checked that the
@@ -6985,7 +6984,7 @@ retry:
 	} else {
 		if (is_hugetlb_entry_migration(pte)) {
 			spin_unlock(ptl);
-			__migration_entry_wait_huge((pte_t *)pmd, ptl);
+			__migration_entry_wait_huge(ptep, ptl);
 			goto retry;
 		}
 		/*
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-hugetlb-fix-races-when-looking-up-a-cont-pte-pmd-size-hugetlb-page.patch
mm-migrate-do-not-retry-10-times-for-the-subpages-of-fail-to-migrate-thp.patch
mm-damon-validate-if-the-pmd-entry-is-present-before-accessing.patch
mm-damon-replace-pmd_huge-with-pmd_trans_huge-for-thp.patch

