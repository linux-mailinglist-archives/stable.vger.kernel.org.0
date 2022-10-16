Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05EB95FFEC3
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 13:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbiJPLEF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 07:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbiJPLEF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 07:04:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DAFC33342
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 04:04:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4380960A56
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 11:04:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32399C433D6;
        Sun, 16 Oct 2022 11:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665918242;
        bh=mAnzNsp4GViRNRhg6JaSCD6ZJbylqVXRKH+HjJSOCXc=;
        h=Subject:To:Cc:From:Date:From;
        b=niSeItGZmUlErCkfQWbGXWuwq4ldVucE/6ozwSpftD89IrqvQ+kVFA9dvQ1V+GeNP
         zxXkC1bjzY1CllY+Zd4RtFQibooNLYjKvS01RrZC+JIByETlvnKJXdPH9cZI+swDFO
         ZmXsE7ACadLrEfw1gzaiTskZk3Qv6EsRYh/1NFOg=
Subject: FAILED: patch "[PATCH] mm/hugetlb: fix races when looking up a CONT-PTE/PMD size" failed to apply to 5.10-stable tree
To:     baolin.wang@linux.alibaba.com, akpm@linux-foundation.org,
        david@redhat.com, mike.kravetz@oracle.com,
        songmuchun@bytedance.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Oct 2022 13:04:46 +0200
Message-ID: <1665918286240232@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

fac35ba763ed ("mm/hugetlb: fix races when looking up a CONT-PTE/PMD size hugetlb page")
ad1ac596e8a8 ("mm/migration: fix potential pte_unmap on an not mapped pte")
4dd845b5a3e5 ("mm/swapops: rework swap entry manipulation code")
af5cdaf82238 ("mm: remove special swap entry functions")
b3807a91aca7 ("mm: page_vma_mapped_walk(): add a level of indentation")
e2e1d4076c77 ("mm: page_vma_mapped_walk(): prettify PVMW_MIGRATION block")
3306d3119cea ("mm: page_vma_mapped_walk(): use pmde for *pvmw->pmd")
f003c03bd29e ("mm: page_vma_mapped_walk(): use page for pvmw->page")
494334e43c16 ("mm/thp: fix vma_address() if virtual address below file offset")
732ed55823fc ("mm/thp: try_to_unmap() use TTU_SYNC for safe splitting")
99fa8a48203d ("mm/thp: fix __split_huge_pmd_locked() on shmem migration entry")
ffc90cbb2970 ("mm, thp: use head page in __migration_entry_wait()")
a44f89dc6c5f ("mm/huge_memory.c: use helper function migration_entry_to_page()")
374437a274e2 ("mm/pgtable-generic.c: optimize the VM_BUG_ON condition in pmdp_huge_clear_flush()")
c045c72ccde3 ("mm/pgtable-generic.c: simplify the VM_BUG_ON condition in pmdp_huge_clear_flush()")
013339df116c ("mm/rmap: always do TTU_IGNORE_ACCESS")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From fac35ba763ed07ba93154c95ffc0c4a55023707f Mon Sep 17 00:00:00 2001
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Date: Thu, 1 Sep 2022 18:41:31 +0800
Subject: [PATCH] mm/hugetlb: fix races when looking up a CONT-PTE/PMD size
 hugetlb page

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

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 3ec981a0d8b3..67c88b82fc32 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -207,8 +207,8 @@ struct page *follow_huge_addr(struct mm_struct *mm, unsigned long address,
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
@@ -312,8 +312,8 @@ static inline struct page *follow_huge_pd(struct vm_area_struct *vma,
 	return NULL;
 }
 
-static inline struct page *follow_huge_pmd(struct mm_struct *mm,
-				unsigned long address, pmd_t *pmd, int flags)
+static inline struct page *follow_huge_pmd_pte(struct vm_area_struct *vma,
+				unsigned long address, int flags)
 {
 	return NULL;
 }
diff --git a/mm/gup.c b/mm/gup.c
index 00926abb4426..251cb6a10bc0 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -530,6 +530,18 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
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
@@ -662,7 +674,7 @@ static struct page *follow_pmd_mask(struct vm_area_struct *vma,
 	if (pmd_none(pmdval))
 		return no_page_table(vma, flags);
 	if (pmd_huge(pmdval) && is_vm_hugetlb_page(vma)) {
-		page = follow_huge_pmd(mm, address, pmd, flags);
+		page = follow_huge_pmd_pte(vma, address, flags);
 		if (page)
 			return page;
 		return no_page_table(vma, flags);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 0bdfc7e1c933..9564bf817e6a 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6946,12 +6946,13 @@ follow_huge_pd(struct vm_area_struct *vma,
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
@@ -6961,17 +6962,15 @@ follow_huge_pmd(struct mm_struct *mm, unsigned long address,
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
@@ -6987,7 +6986,7 @@ follow_huge_pmd(struct mm_struct *mm, unsigned long address,
 	} else {
 		if (is_hugetlb_entry_migration(pte)) {
 			spin_unlock(ptl);
-			__migration_entry_wait_huge((pte_t *)pmd, ptl);
+			__migration_entry_wait_huge(ptep, ptl);
 			goto retry;
 		}
 		/*

