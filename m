Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE22324D77
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 11:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233732AbhBYKBT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 05:01:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:34228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235483AbhBYJ7B (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Feb 2021 04:59:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6673D64F20;
        Thu, 25 Feb 2021 09:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614246915;
        bh=vB6rxebxntfOVBLahpQwVeHkkIIhS6QSp2wWiPj8TR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LkAnWlAAbZT7JAVPOj8UHjjMjv3nxbu6OjqJ1SZsMW4XwIj1Rss06OkV1GM4IvfqO
         ukjLdW9BUFVa5lxoFSvhniLfgbj7RrWkuXrKSLx/BKs+dkVKMzZzhI0vjoHCJSd8hb
         +85eUWYtEd9L9+rWqnbj6ognyPaAHxqEpeU9naMI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dan Williams <dan.j.williams@intel.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 14/23] mm: simplify follow_pte{,pmd}
Date:   Thu, 25 Feb 2021 10:53:45 +0100
Message-Id: <20210225092517.211062201@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210225092516.531932232@linuxfoundation.org>
References: <20210225092516.531932232@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit ff5c19ed4b087073cea38ff0edc80c23d7256943 upstream.

Merge __follow_pte_pmd, follow_pte_pmd and follow_pte into a single
follow_pte function and just pass two additional NULL arguments for the
two previous follow_pte callers.

[sfr@canb.auug.org.au: merge fix for "s390/pci: remove races against pte updates"]
  Link: https://lkml.kernel.org/r/20201111221254.7f6a3658@canb.auug.org.au

Link: https://lkml.kernel.org/r/20201029101432.47011-3-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/dax.c           |    9 ++++-----
 include/linux/mm.h |    6 +++---
 mm/memory.c        |   35 +++++------------------------------
 3 files changed, 12 insertions(+), 38 deletions(-)

--- a/fs/dax.c
+++ b/fs/dax.c
@@ -810,12 +810,11 @@ static void dax_entry_mkclean(struct add
 		address = pgoff_address(index, vma);
 
 		/*
-		 * Note because we provide range to follow_pte_pmd it will
-		 * call mmu_notifier_invalidate_range_start() on our behalf
-		 * before taking any lock.
+		 * Note because we provide range to follow_pte it will call
+		 * mmu_notifier_invalidate_range_start() on our behalf before
+		 * taking any lock.
 		 */
-		if (follow_pte_pmd(vma->vm_mm, address, &range,
-				   &ptep, &pmdp, &ptl))
+		if (follow_pte(vma->vm_mm, address, &range, &ptep, &pmdp, &ptl))
 			continue;
 
 		/*
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1655,9 +1655,9 @@ void free_pgd_range(struct mmu_gather *t
 		unsigned long end, unsigned long floor, unsigned long ceiling);
 int
 copy_page_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma);
-int follow_pte_pmd(struct mm_struct *mm, unsigned long address,
-		   struct mmu_notifier_range *range,
-		   pte_t **ptepp, pmd_t **pmdpp, spinlock_t **ptlp);
+int follow_pte(struct mm_struct *mm, unsigned long address,
+		struct mmu_notifier_range *range, pte_t **ptepp, pmd_t **pmdpp,
+		spinlock_t **ptlp);
 int follow_pfn(struct vm_area_struct *vma, unsigned long address,
 	unsigned long *pfn);
 int follow_phys(struct vm_area_struct *vma, unsigned long address,
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4707,9 +4707,9 @@ int __pmd_alloc(struct mm_struct *mm, pu
 }
 #endif /* __PAGETABLE_PMD_FOLDED */
 
-static int __follow_pte_pmd(struct mm_struct *mm, unsigned long address,
-			    struct mmu_notifier_range *range,
-			    pte_t **ptepp, pmd_t **pmdpp, spinlock_t **ptlp)
+int follow_pte(struct mm_struct *mm, unsigned long address,
+	       struct mmu_notifier_range *range, pte_t **ptepp, pmd_t **pmdpp,
+	       spinlock_t **ptlp)
 {
 	pgd_t *pgd;
 	p4d_t *p4d;
@@ -4774,31 +4774,6 @@ out:
 	return -EINVAL;
 }
 
-static inline int follow_pte(struct mm_struct *mm, unsigned long address,
-			     pte_t **ptepp, spinlock_t **ptlp)
-{
-	int res;
-
-	/* (void) is needed to make gcc happy */
-	(void) __cond_lock(*ptlp,
-			   !(res = __follow_pte_pmd(mm, address, NULL,
-						    ptepp, NULL, ptlp)));
-	return res;
-}
-
-int follow_pte_pmd(struct mm_struct *mm, unsigned long address,
-		   struct mmu_notifier_range *range,
-		   pte_t **ptepp, pmd_t **pmdpp, spinlock_t **ptlp)
-{
-	int res;
-
-	/* (void) is needed to make gcc happy */
-	(void) __cond_lock(*ptlp,
-			   !(res = __follow_pte_pmd(mm, address, range,
-						    ptepp, pmdpp, ptlp)));
-	return res;
-}
-
 /**
  * follow_pfn - look up PFN at a user virtual address
  * @vma: memory mapping
@@ -4819,7 +4794,7 @@ int follow_pfn(struct vm_area_struct *vm
 	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
 		return ret;
 
-	ret = follow_pte(vma->vm_mm, address, &ptep, &ptl);
+	ret = follow_pte(vma->vm_mm, address, NULL, &ptep, NULL, &ptl);
 	if (ret)
 		return ret;
 	*pfn = pte_pfn(*ptep);
@@ -4840,7 +4815,7 @@ int follow_phys(struct vm_area_struct *v
 	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
 		goto out;
 
-	if (follow_pte(vma->vm_mm, address, &ptep, &ptl))
+	if (follow_pte(vma->vm_mm, address, NULL, &ptep, NULL, &ptl))
 		goto out;
 	pte = *ptep;
 


