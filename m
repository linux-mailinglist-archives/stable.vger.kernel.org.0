Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7216608BF3
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 12:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbiJVKvE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 06:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230454AbiJVKul (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 06:50:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06D00285105;
        Sat, 22 Oct 2022 03:07:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E722260A5C;
        Sat, 22 Oct 2022 07:37:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09275C433D6;
        Sat, 22 Oct 2022 07:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424245;
        bh=NsVJ/BIVWYCUiIPM2sLFZV0xqyU63Ea0NVA+bdB/+IU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KYcS/q455gyqXRzbZgftArqYYz2LDohCjZu7YgFEzY46YijmBNTYC6dMoCFZZJtdc
         XnFTTCJFwKfqucDkpgmjxYBUIrBRCZFs8BazOasxngvz8Kj7aI/gQZjYJTk06bTpR3
         ymweYP+3xhstbcYKx63Fv0Mf5oJzunhiQoLZkAf0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        David Hildenbrand <david@redhat.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.19 075/717] mm/hugetlb: fix races when looking up a CONT-PTE/PMD size hugetlb page
Date:   Sat, 22 Oct 2022 09:19:14 +0200
Message-Id: <20221022072428.550961015@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baolin Wang <baolin.wang@linux.alibaba.com>

commit fac35ba763ed07ba93154c95ffc0c4a55023707f upstream.

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

Mike said:

Support for CONT_PMD/_PTE was added with bb9dd3df8ee9 ("arm64: hugetlb:
refactor find_num_contig()").  Patch series "Support for contiguous pte
hugepages", v4.  However, I do not believe these code paths were
executed until migration support was added with 5480280d3f2d ("arm64/mm:
enable HugeTLB migration for contiguous bit HugeTLB pages") I would go
with 5480280d3f2d for the Fixes: targe.

Link: https://lkml.kernel.org/r/635f43bdd85ac2615a58405da82b4d33c6e5eb05.1662017562.git.baolin.wang@linux.alibaba.com
Fixes: 5480280d3f2d ("arm64/mm: enable HugeTLB migration for contiguous bit HugeTLB pages")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Suggested-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/hugetlb.h |    8 ++++----
 mm/gup.c                |   14 +++++++++++++-
 mm/hugetlb.c            |   27 +++++++++++++--------------
 3 files changed, 30 insertions(+), 19 deletions(-)

--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -203,8 +203,8 @@ struct page *follow_huge_addr(struct mm_
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
@@ -308,8 +308,8 @@ static inline struct page *follow_huge_p
 	return NULL;
 }
 
-static inline struct page *follow_huge_pmd(struct mm_struct *mm,
-				unsigned long address, pmd_t *pmd, int flags)
+static inline struct page *follow_huge_pmd_pte(struct vm_area_struct *vma,
+				unsigned long address, int flags)
 {
 	return NULL;
 }
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -531,6 +531,18 @@ static struct page *follow_page_pte(stru
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
@@ -663,7 +675,7 @@ static struct page *follow_pmd_mask(stru
 	if (pmd_none(pmdval))
 		return no_page_table(vma, flags);
 	if (pmd_huge(pmdval) && is_vm_hugetlb_page(vma)) {
-		page = follow_huge_pmd(mm, address, pmd, flags);
+		page = follow_huge_pmd_pte(vma, address, flags);
 		if (page)
 			return page;
 		return no_page_table(vma, flags);
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6906,12 +6906,13 @@ follow_huge_pd(struct vm_area_struct *vm
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
@@ -6921,17 +6922,15 @@ follow_huge_pmd(struct mm_struct *mm, un
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
@@ -6947,7 +6946,7 @@ retry:
 	} else {
 		if (is_hugetlb_entry_migration(pte)) {
 			spin_unlock(ptl);
-			__migration_entry_wait_huge((pte_t *)pmd, ptl);
+			__migration_entry_wait_huge(ptep, ptl);
 			goto retry;
 		}
 		/*


