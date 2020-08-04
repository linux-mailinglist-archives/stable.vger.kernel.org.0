Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 612CB23B290
	for <lists+stable@lfdr.de>; Tue,  4 Aug 2020 04:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725877AbgHDCDs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 22:03:48 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:57030 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbgHDCDs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Aug 2020 22:03:48 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07423QYp005096;
        Tue, 4 Aug 2020 02:03:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=X1HWxyJHRbd5gFbo7p28vx8i25sPsY5Sa9ZULHMcc78=;
 b=KyVEKGwGclmBtjO5X+zfQjhOYEBeXZFoRUIUcGHF2ODrRpjtBi44Dxf8BBnmSfi+ecUJ
 kzKyZQ5kbFrC5HxcU8IiQCAhrGa4/QG/ou6/xkwzfsdYvY2ck4a+adD+oy5E4zSPtD3x
 3kygSo8GMZIJVp1PpGQDWPP+OB+eP2jPArwaEBR7k5JYlLuZDDso11sv64b7OqpT/kY4
 JszZRk4k4HXTbJwpHlW2Zdgo81XuhCjWwD866J0cC58S+OpdH1SUEG7Tfk7261jsF52y
 3nPaw9FUwjGqtBT+eZk+POUpZ9ZbBNcoDpTWKPz408mqeS9ShmJ3W5z7nCOlQUM/zzI3 wQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 32pdnq4wcv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 04 Aug 2020 02:03:26 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07422nTx085923;
        Tue, 4 Aug 2020 02:03:25 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 32pdnp5m8n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Aug 2020 02:03:25 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07423Jqm013107;
        Tue, 4 Aug 2020 02:03:19 GMT
Received: from [192.168.2.112] (/50.38.35.18)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 03 Aug 2020 19:03:19 -0700
Subject: Re: [PATCH] hugetlbfs: remove call to huge_pte_alloc without
 i_mmap_rwsem
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Michal Hocko <mhocko@kernel.org>,
        Hugh Dickins <hughd@google.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Kirill A.Shutemov" <kirill.shutemov@linux.intel.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Prakash Sangappa <prakash.sangappa@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
References: <20200803224335.55794-1-mike.kravetz@oracle.com>
 <20200803225234.GD23808@casper.infradead.org>
 <9072d352-7a07-aac7-3439-3f524fc465ed@oracle.com>
Message-ID: <e670f327-5cf9-1959-96e4-6dc7cc30d3d5@oracle.com>
Date:   Mon, 3 Aug 2020 19:03:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <9072d352-7a07-aac7-3439-3f524fc465ed@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9702 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 mlxscore=0
 bulkscore=0 adultscore=0 phishscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008040013
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9702 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 suspectscore=0 clxscore=1015 priorityscore=1501 bulkscore=0 adultscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008040013
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/3/20 4:00 PM, Mike Kravetz wrote:
> On 8/3/20 3:52 PM, Matthew Wilcox wrote:
>> On Mon, Aug 03, 2020 at 03:43:35PM -0700, Mike Kravetz wrote:
>>> Commit c0d0381ade79 ("hugetlbfs: use i_mmap_rwsem for more pmd sharing
>>> synchronization") requires callers of huge_pte_alloc to hold i_mmap_rwsem
>>> in at least read mode.  This is because the explicit locking in
>>> huge_pmd_share (called by huge_pte_alloc) was removed.  When restructuring
>>> the code, the call to huge_pte_alloc in the else block at the beginning
>>> of hugetlb_fault was missed.
>>
>> Should we have a call to mmap_assert_locked() in huge_pte_alloc(),
>> at least the generic one?
> 
> That is the wrong semaphore.
> 
> However, I was not aware of the checks for a semaphore being held as is
> done in rwsem_is_locked().  That would have caught this when the original
> code was changed.  Thanks for pointing this out.
> 
> Let me update the patch and add checks to huge_pmd_share().

Here is an updated version.

I added routines to assert that i_mmap_rwsem is held as required.  This
requires changing the parameters passed to huge_pmd_unshare.  Verified
that the problematic call to huge_pte_alloc (that this patch also removes)
will generate WARNINGs.

Not sure if the fix should be separated from the verification code for
sending to stable?

From 8d1d4f858da7a593a04ce8dc06b067bf0075903f Mon Sep 17 00:00:00 2001
From: Mike Kravetz <mike.kravetz@oracle.com>
Date: Mon, 3 Aug 2020 14:38:06 -0700
Subject: [PATCH v2] hugetlbfs: remove call to huge_pte_alloc without
 i_mmap_rwsem

Commit c0d0381ade79 ("hugetlbfs: use i_mmap_rwsem for more pmd sharing
synchronization") requires callers of huge_pte_alloc to hold i_mmap_rwsem
in at least read mode.  This is because the explicit locking in
huge_pmd_share (called by huge_pte_alloc) was removed.  When restructuring
the code, the call to huge_pte_alloc in the else block at the beginning
of hugetlb_fault was missed.

Unfortunately, that else clause is exercised when there is no page table
entry.  This will likely lead to a call to huge_pmd_share.  If
huge_pmd_share thinks pmd sharing is possible, it will traverse the mapping
tree (i_mmap) without holding i_mmap_rwsem.  If someone else is modifying
the tree, bad things such as addressing exceptions or worse could happen.

Simply remove the else clause.  It should have been removed previously.
The code following the else will call huge_pte_alloc with the appropriate
locking.

To prevent this type of issue in the future, add routines to assert that
i_mmap_rwsem is held, and call these routines in huge pmd sharing routines.

Fixes: c0d0381ade79 ("hugetlbfs: use i_mmap_rwsem for more pmd sharing synchronization")
Cc: <stable@vger.kernel.org>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
---
 include/linux/fs.h      | 10 ++++++++++
 include/linux/hugetlb.h |  8 +++++---
 mm/hugetlb.c            | 15 +++++++--------
 mm/rmap.c               |  2 +-
 4 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index f5abba86107d..2dab217c6047 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -549,6 +549,16 @@ static inline void i_mmap_unlock_read(struct address_space *mapping)
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
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 50650d0d01b9..a520bf26e5d8 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -164,7 +164,8 @@ pte_t *huge_pte_alloc(struct mm_struct *mm,
 			unsigned long addr, unsigned long sz);
 pte_t *huge_pte_offset(struct mm_struct *mm,
 		       unsigned long addr, unsigned long sz);
-int huge_pmd_unshare(struct mm_struct *mm, unsigned long *addr, pte_t *ptep);
+int huge_pmd_unshare(struct mm_struct *mm, struct vm_area_struct *vma,
+				unsigned long *addr, pte_t *ptep);
 void adjust_range_if_pmd_sharing_possible(struct vm_area_struct *vma,
 				unsigned long *start, unsigned long *end);
 struct page *follow_huge_addr(struct mm_struct *mm, unsigned long address,
@@ -203,8 +204,9 @@ static inline struct address_space *hugetlb_page_mapping_lock_write(
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
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 590111ea6975..6ac686b09bb6 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3952,7 +3952,7 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 			continue;
 
 		ptl = huge_pte_lock(h, mm, ptep);
-		if (huge_pmd_unshare(mm, &address, ptep)) {
+		if (huge_pmd_unshare(mm, vma, &address, ptep)) {
 			spin_unlock(ptl);
 			/*
 			 * We just unmapped a page of PMDs by clearing a PUD.
@@ -4539,10 +4539,6 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 		} else if (unlikely(is_hugetlb_entry_hwpoisoned(entry)))
 			return VM_FAULT_HWPOISON_LARGE |
 				VM_FAULT_SET_HINDEX(hstate_index(h));
-	} else {
-		ptep = huge_pte_alloc(mm, haddr, huge_page_size(h));
-		if (!ptep)
-			return VM_FAULT_OOM;
 	}
 
 	/*
@@ -5019,7 +5015,7 @@ unsigned long hugetlb_change_protection(struct vm_area_struct *vma,
 		if (!ptep)
 			continue;
 		ptl = huge_pte_lock(h, mm, ptep);
-		if (huge_pmd_unshare(mm, &address, ptep)) {
+		if (huge_pmd_unshare(mm, vma, &address, ptep)) {
 			pages++;
 			spin_unlock(ptl);
 			shared_pmd = true;
@@ -5404,12 +5400,14 @@ pte_t *huge_pmd_share(struct mm_struct *mm, unsigned long addr, pud_t *pud)
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
@@ -5427,7 +5425,8 @@ pte_t *huge_pmd_share(struct mm_struct *mm, unsigned long addr, pud_t *pud)
 	return NULL;
 }
 
-int huge_pmd_unshare(struct mm_struct *mm, unsigned long *addr, pte_t *ptep)
+int huge_pmd_unshare(struct mm_struct *mm, struct vm_area_struct *vma,
+				unsigned long *addr, pte_t *ptep)
 {
 	return 0;
 }
diff --git a/mm/rmap.c b/mm/rmap.c
index 5fe2dedce1fc..6cce9ef06753 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1469,7 +1469,7 @@ static bool try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
 			 * do this outside rmap routines.
 			 */
 			VM_BUG_ON(!(flags & TTU_RMAP_LOCKED));
-			if (huge_pmd_unshare(mm, &address, pvmw.pte)) {
+			if (huge_pmd_unshare(mm, vma, &address, pvmw.pte)) {
 				/*
 				 * huge_pmd_unshare unmapped an entire PMD
 				 * page.  There is no way of knowing exactly
-- 
2.25.4

