Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03A0E24304F
	for <lists+stable@lfdr.de>; Wed, 12 Aug 2020 23:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbgHLVCD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Aug 2020 17:02:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:48252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726526AbgHLVCD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 Aug 2020 17:02:03 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8D5D20768;
        Wed, 12 Aug 2020 21:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266122;
        bh=G3zVLnLAxYzflIwAFERMWmVw7juIK4Iq0WiKt4or/Mw=;
        h=Date:From:To:Subject:From;
        b=GHPPppbVb6m21EZMAwaMQkhFHj+tMQFZ/XHhYjX4/FRU8LWK7prdhosyIS5g86jiP
         04mtwmMCsZslT5AK9EFgX+SHvQojFbDep4tajCS11M3vxm4aoU5gUWIYN+55cOnd8u
         9vp1u9oRP6xBp53llGFBDMHXZyVmsc4SgpG+or94=
Date:   Wed, 12 Aug 2020 14:02:01 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com,
        dave@stgolabs.net, hughd@google.com,
        kirill.shutemov@linux.intel.com, mhocko@kernel.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        n-horiguchi@ah.jp.nec.com, prakash.sangappa@oracle.com,
        stable@vger.kernel.org, willy@infradead.org
Subject:  [merged]
 hugetlbfs-remove-call-to-huge_pte_alloc-without-i_mmap_rwsem.patch removed
 from -mm tree
Message-ID: <20200812210201.BFsvD7wUZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: hugetlbfs: remove call to huge_pte_alloc without i_mmap_rwsem
has been removed from the -mm tree.  Its filename was
     hugetlbfs-remove-call-to-huge_pte_alloc-without-i_mmap_rwsem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlbfs: remove call to huge_pte_alloc without i_mmap_rwsem

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

Link: http://lkml.kernel.org/r/e670f327-5cf9-1959-96e4-6dc7cc30d3d5@oracle.com
Fixes: c0d0381ade79 ("hugetlbfs: use i_mmap_rwsem for more pmd sharing synchronization")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Kirill A.Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Prakash Sangappa <prakash.sangappa@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h      |   10 ++++++++++
 include/linux/hugetlb.h |    8 +++++---
 mm/hugetlb.c            |   15 +++++++--------
 mm/rmap.c               |    2 +-
 4 files changed, 23 insertions(+), 12 deletions(-)

--- a/include/linux/fs.h~hugetlbfs-remove-call-to-huge_pte_alloc-without-i_mmap_rwsem
+++ a/include/linux/fs.h
@@ -518,6 +518,16 @@ static inline void i_mmap_unlock_read(st
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
--- a/include/linux/hugetlb.h~hugetlbfs-remove-call-to-huge_pte_alloc-without-i_mmap_rwsem
+++ a/include/linux/hugetlb.h
@@ -164,7 +164,8 @@ pte_t *huge_pte_alloc(struct mm_struct *
 			unsigned long addr, unsigned long sz);
 pte_t *huge_pte_offset(struct mm_struct *mm,
 		       unsigned long addr, unsigned long sz);
-int huge_pmd_unshare(struct mm_struct *mm, unsigned long *addr, pte_t *ptep);
+int huge_pmd_unshare(struct mm_struct *mm, struct vm_area_struct *vma,
+				unsigned long *addr, pte_t *ptep);
 void adjust_range_if_pmd_sharing_possible(struct vm_area_struct *vma,
 				unsigned long *start, unsigned long *end);
 struct page *follow_huge_addr(struct mm_struct *mm, unsigned long address,
@@ -203,8 +204,9 @@ static inline struct address_space *huge
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
--- a/mm/hugetlb.c~hugetlbfs-remove-call-to-huge_pte_alloc-without-i_mmap_rwsem
+++ a/mm/hugetlb.c
@@ -3967,7 +3967,7 @@ void __unmap_hugepage_range(struct mmu_g
 			continue;
 
 		ptl = huge_pte_lock(h, mm, ptep);
-		if (huge_pmd_unshare(mm, &address, ptep)) {
+		if (huge_pmd_unshare(mm, vma, &address, ptep)) {
 			spin_unlock(ptl);
 			/*
 			 * We just unmapped a page of PMDs by clearing a PUD.
@@ -4554,10 +4554,6 @@ vm_fault_t hugetlb_fault(struct mm_struc
 		} else if (unlikely(is_hugetlb_entry_hwpoisoned(entry)))
 			return VM_FAULT_HWPOISON_LARGE |
 				VM_FAULT_SET_HINDEX(hstate_index(h));
-	} else {
-		ptep = huge_pte_alloc(mm, haddr, huge_page_size(h));
-		if (!ptep)
-			return VM_FAULT_OOM;
 	}
 
 	/*
@@ -5034,7 +5030,7 @@ unsigned long hugetlb_change_protection(
 		if (!ptep)
 			continue;
 		ptl = huge_pte_lock(h, mm, ptep);
-		if (huge_pmd_unshare(mm, &address, ptep)) {
+		if (huge_pmd_unshare(mm, vma, &address, ptep)) {
 			pages++;
 			spin_unlock(ptl);
 			shared_pmd = true;
@@ -5415,12 +5411,14 @@ out:
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
@@ -5438,7 +5436,8 @@ pte_t *huge_pmd_share(struct mm_struct *
 	return NULL;
 }
 
-int huge_pmd_unshare(struct mm_struct *mm, unsigned long *addr, pte_t *ptep)
+int huge_pmd_unshare(struct mm_struct *mm, struct vm_area_struct *vma,
+				unsigned long *addr, pte_t *ptep)
 {
 	return 0;
 }
--- a/mm/rmap.c~hugetlbfs-remove-call-to-huge_pte_alloc-without-i_mmap_rwsem
+++ a/mm/rmap.c
@@ -1469,7 +1469,7 @@ static bool try_to_unmap_one(struct page
 			 * do this outside rmap routines.
 			 */
 			VM_BUG_ON(!(flags & TTU_RMAP_LOCKED));
-			if (huge_pmd_unshare(mm, &address, pvmw.pte)) {
+			if (huge_pmd_unshare(mm, vma, &address, pvmw.pte)) {
 				/*
 				 * huge_pmd_unshare unmapped an entire PMD
 				 * page.  There is no way of knowing exactly
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are


