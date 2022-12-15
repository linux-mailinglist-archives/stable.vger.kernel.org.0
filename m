Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8575364E03A
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 19:10:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbiLOSKx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 13:10:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbiLOSKv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 13:10:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 183092ED69
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 10:10:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A95E661E97
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 18:10:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B1D4C433D2;
        Thu, 15 Dec 2022 18:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671127849;
        bh=l5F10/3iOfBE4QaVJt435kT9CGUeqtbnNHs9/kKJ6fs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tgbGGbM9/pJVc30kA1ssB1L184d92r9/by9B/Hh8xL4uOG9CJ8MXfFPHJEZp0rU2i
         jHPZ5R1Ytt+OecBYf5Kxv1HIpsjiTAG90D6Q8t8S5OVIg+3OhUw6z8O8OF85E5ON5N
         O9h1Wi7NJjJRj3Br2qyjDO/OTJjAsanByseEwa/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        David Hildenbrand <david@redhat.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Samuel Mendoza-Jonas <samjonas@amazon.com>
Subject: [PATCH 5.4 3/9] mm/hugetlb: fix races when looking up a CONT-PTE/PMD size hugetlb page
Date:   Thu, 15 Dec 2022 19:10:30 +0100
Message-Id: <20221215172905.598525125@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221215172905.468656378@linuxfoundation.org>
References: <20221215172905.468656378@linuxfoundation.org>
User-Agent: quilt/0.67
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
[5.4: Fixup contextual diffs before pin_user_pages()]
Signed-off-by: Samuel Mendoza-Jonas <samjonas@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/hugetlb.h |    6 +++---
 mm/gup.c                |   13 ++++++++++++-
 mm/hugetlb.c            |   30 +++++++++++++++---------------
 3 files changed, 30 insertions(+), 19 deletions(-)

--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -127,8 +127,8 @@ struct page *follow_huge_addr(struct mm_
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
@@ -175,7 +175,7 @@ static inline void hugetlb_show_meminfo(
 {
 }
 #define follow_huge_pd(vma, addr, hpd, flags, pdshift) NULL
-#define follow_huge_pmd(mm, addr, pmd, flags)	NULL
+#define follow_huge_pmd_pte(vma, addr, flags)	NULL
 #define follow_huge_pud(mm, addr, pud, flags)	NULL
 #define follow_huge_pgd(mm, addr, pgd, flags)	NULL
 #define prepare_hugepage_range(file, addr, len)	(-EINVAL)
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -188,6 +188,17 @@ static struct page *follow_page_pte(stru
 	spinlock_t *ptl;
 	pte_t *ptep, pte;
 
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
@@ -333,7 +344,7 @@ static struct page *follow_pmd_mask(stru
 	if (pmd_none(pmdval))
 		return no_page_table(vma, flags);
 	if (pmd_huge(pmdval) && vma->vm_flags & VM_HUGETLB) {
-		page = follow_huge_pmd(mm, address, pmd, flags);
+		page = follow_huge_pmd_pte(vma, address, flags);
 		if (page)
 			return page;
 		return no_page_table(vma, flags);
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5157,30 +5157,30 @@ follow_huge_pd(struct vm_area_struct *vm
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
+
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
 		if (flags & FOLL_GET)
 			get_page(page);
 	} else {
 		if (is_hugetlb_entry_migration(pte)) {
 			spin_unlock(ptl);
-			__migration_entry_wait(mm, (pte_t *)pmd, ptl);
+			__migration_entry_wait(mm, ptep, ptl);
 			goto retry;
 		}
 		/*
@@ -5188,7 +5188,7 @@ retry:
 		 * follow_page_mask().
 		 */
 	}
-out:
+
 	spin_unlock(ptl);
 	return page;
 }


