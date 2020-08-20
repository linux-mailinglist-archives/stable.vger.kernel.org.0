Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B07924B2D5
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 11:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728252AbgHTJhx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:37:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:54584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728856AbgHTJhu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:37:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 432182075E;
        Thu, 20 Aug 2020 09:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916269;
        bh=UYIBLA8WibIjjCLyWu8ir8Voaqbk5WTp/nNLFt6poao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DRSy1gEgQihwttWa0hXmOUWkLZ5FlOelIPYvzwtcLUb6GBgjlmeOmshTo+2NctOtz
         suQTWwhA/ZaRRmJZjT6QIQoJaIQ4HvS0O4rZMHYKRBbmv0BUGhXfcMw0lsldu9teKF
         2JunN2Vb3oHJ9HDeCNnTvrEbNU6wzp9VVLS5dDe4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        Hugh Dickins <hughd@google.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Kirill A.Shutemov" <kirill.shutemov@linux.intel.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Prakash Sangappa <prakash.sangappa@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.7 070/204] hugetlbfs: remove call to huge_pte_alloc without i_mmap_rwsem
Date:   Thu, 20 Aug 2020 11:19:27 +0200
Message-Id: <20200820091609.830343544@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091606.194320503@linuxfoundation.org>
References: <20200820091606.194320503@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Kravetz <mike.kravetz@oracle.com>

commit 34ae204f18519f0920bd50a644abd6fefc8dbfcf upstream.

Commit c0d0381ade79 ("hugetlbfs: use i_mmap_rwsem for more pmd sharing
synchronization") requires callers of huge_pte_alloc to hold i_mmap_rwsem
in at least read mode.  This is because the explicit locking in
huge_pmd_share (called by huge_pte_alloc) was removed.  When restructuring
the code, the call to huge_pte_alloc in the else block at the beginning of
hugetlb_fault was missed.

Unfortunately, that else clause is exercised when there is no page table
entry.  This will likely lead to a call to huge_pmd_share.  If
huge_pmd_share thinks pmd sharing is possible, it will traverse the
mapping tree (i_mmap) without holding i_mmap_rwsem.  If someone else is
modifying the tree, bad things such as addressing exceptions or worse
could happen.

Simply remove the else clause.  It should have been removed previously.
The code following the else will call huge_pte_alloc with the appropriate
locking.

To prevent this type of issue in the future, add routines to assert that
i_mmap_rwsem is held, and call these routines in huge pmd sharing
routines.

Fixes: c0d0381ade79 ("hugetlbfs: use i_mmap_rwsem for more pmd sharing synchronization")
Suggested-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Kirill A.Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Prakash Sangappa <prakash.sangappa@oracle.com>
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/e670f327-5cf9-1959-96e4-6dc7cc30d3d5@oracle.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/fs.h      |   10 ++++++++++
 include/linux/hugetlb.h |    8 +++++---
 mm/hugetlb.c            |   15 +++++++--------
 mm/rmap.c               |    2 +-
 4 files changed, 23 insertions(+), 12 deletions(-)

--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -546,6 +546,16 @@ static inline void i_mmap_unlock_read(st
 	up_read(&mapping->i_mmap_rwsem);
 }
 
+static inline void i_mmap_assert_locked(struct address_space *mapping)
+{
+	lockdep_assert_held(&mapping->i_mmap_rwsem);
+}
+
+static inline void i_mmap_assert_write_locked(struct address_space *mapping)
+{
+	lockdep_assert_held_write(&mapping->i_mmap_rwsem);
+}
+
 /*
  * Might pages of this file be mapped into userspace?
  */
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -165,7 +165,8 @@ pte_t *huge_pte_alloc(struct mm_struct *
 			unsigned long addr, unsigned long sz);
 pte_t *huge_pte_offset(struct mm_struct *mm,
 		       unsigned long addr, unsigned long sz);
-int huge_pmd_unshare(struct mm_struct *mm, unsigned long *addr, pte_t *ptep);
+int huge_pmd_unshare(struct mm_struct *mm, struct vm_area_struct *vma,
+				unsigned long *addr, pte_t *ptep);
 void adjust_range_if_pmd_sharing_possible(struct vm_area_struct *vma,
 				unsigned long *start, unsigned long *end);
 struct page *follow_huge_addr(struct mm_struct *mm, unsigned long address,
@@ -204,8 +205,9 @@ static inline struct address_space *huge
 	return NULL;
 }
 
-static inline int huge_pmd_unshare(struct mm_struct *mm, unsigned long *addr,
-					pte_t *ptep)
+static inline int huge_pmd_unshare(struct mm_struct *mm,
+					struct vm_area_struct *vma,
+					unsigned long *addr, pte_t *ptep)
 {
 	return 0;
 }
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3840,7 +3840,7 @@ void __unmap_hugepage_range(struct mmu_g
 			continue;
 
 		ptl = huge_pte_lock(h, mm, ptep);
-		if (huge_pmd_unshare(mm, &address, ptep)) {
+		if (huge_pmd_unshare(mm, vma, &address, ptep)) {
 			spin_unlock(ptl);
 			/*
 			 * We just unmapped a page of PMDs by clearing a PUD.
@@ -4427,10 +4427,6 @@ vm_fault_t hugetlb_fault(struct mm_struc
 		} else if (unlikely(is_hugetlb_entry_hwpoisoned(entry)))
 			return VM_FAULT_HWPOISON_LARGE |
 				VM_FAULT_SET_HINDEX(hstate_index(h));
-	} else {
-		ptep = huge_pte_alloc(mm, haddr, huge_page_size(h));
-		if (!ptep)
-			return VM_FAULT_OOM;
 	}
 
 	/*
@@ -4907,7 +4903,7 @@ unsigned long hugetlb_change_protection(
 		if (!ptep)
 			continue;
 		ptl = huge_pte_lock(h, mm, ptep);
-		if (huge_pmd_unshare(mm, &address, ptep)) {
+		if (huge_pmd_unshare(mm, vma, &address, ptep)) {
 			pages++;
 			spin_unlock(ptl);
 			shared_pmd = true;
@@ -5288,12 +5284,14 @@ out:
  * returns: 1 successfully unmapped a shared pte page
  *	    0 the underlying pte page is not shared, or it is the last user
  */
-int huge_pmd_unshare(struct mm_struct *mm, unsigned long *addr, pte_t *ptep)
+int huge_pmd_unshare(struct mm_struct *mm, struct vm_area_struct *vma,
+					unsigned long *addr, pte_t *ptep)
 {
 	pgd_t *pgd = pgd_offset(mm, *addr);
 	p4d_t *p4d = p4d_offset(pgd, *addr);
 	pud_t *pud = pud_offset(p4d, *addr);
 
+	i_mmap_assert_write_locked(vma->vm_file->f_mapping);
 	BUG_ON(page_count(virt_to_page(ptep)) == 0);
 	if (page_count(virt_to_page(ptep)) == 1)
 		return 0;
@@ -5311,7 +5309,8 @@ pte_t *huge_pmd_share(struct mm_struct *
 	return NULL;
 }
 
-int huge_pmd_unshare(struct mm_struct *mm, unsigned long *addr, pte_t *ptep)
+int huge_pmd_unshare(struct mm_struct *mm, struct vm_area_struct *vma,
+				unsigned long *addr, pte_t *ptep)
 {
 	return 0;
 }
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1458,7 +1458,7 @@ static bool try_to_unmap_one(struct page
 			 * do this outside rmap routines.
 			 */
 			VM_BUG_ON(!(flags & TTU_RMAP_LOCKED));
-			if (huge_pmd_unshare(mm, &address, pvmw.pte)) {
+			if (huge_pmd_unshare(mm, vma, &address, pvmw.pte)) {
 				/*
 				 * huge_pmd_unshare unmapped an entire PMD
 				 * page.  There is no way of knowing exactly


