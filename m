Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF9CF2A37B5
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 01:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726104AbgKCA3P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 19:29:15 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:42312 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbgKCA3P (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Nov 2020 19:29:15 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A30Sv2B059904;
        Tue, 3 Nov 2020 00:28:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=geuTP6PRzJMI7bS6hI4wGJMvdsQqPL1ta9Wf0sxrcz0=;
 b=sGK+M3xfzLYYH4Zfq3gxBAfgy0sOgvejhls3dz3E1ZiyYIgarKcRH2Su8CMnMZTjMCCm
 lVmc6KBAAg5zPcQWSxaBhaFKNyyYL5cYzoO8fwpxjh9L9D1uFoSRRVUOStTY3u9iUkBv
 daQUDFPKyNj0J9Y6Nm3LezVDLYlafPU3G3jJYt1tSunob/xX9EqAg3dghlNKECT+QBfn
 GXGwK53XjXMp4fuULa5GUE/joQLK37i6GayAqBzyLeaxMksSIIpmw+uC5d5afOdV1P2R
 lz9rSbkmuoCfNRVBJF6NulNB94EmjXgsOy+fS51t3QRSPDko94hIzWE3kC+8YA3fFD4F WA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 34hhw2escy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 03 Nov 2020 00:28:56 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A30APrj076536;
        Tue, 3 Nov 2020 00:28:55 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 34hw0g069s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Nov 2020 00:28:55 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0A30SrTl000632;
        Tue, 3 Nov 2020 00:28:53 GMT
Received: from monkey.oracle.com (/50.38.35.18)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 02 Nov 2020 16:28:52 -0800
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc:     Hugh Dickins <hughd@google.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Michal Hocko <mhocko@kernel.org>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Prakash Sangappa <prakash.sangappa@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Kravetz <mike.kravetz@oracle.com>, stable@vger.kernel.org
Subject: [PATCH 3/4] hugetlbfs: use hinode_rwsem for pmd sharing synchronization
Date:   Mon,  2 Nov 2020 16:28:40 -0800
Message-Id: <20201103002841.273161-4-mike.kravetz@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201103002841.273161-1-mike.kravetz@oracle.com>
References: <20201026233150.371577-1-mike.kravetz@oracle.com>
 <20201103002841.273161-1-mike.kravetz@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9793 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 bulkscore=0
 mlxscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011030000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9793 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 clxscore=1015 priorityscore=1501 impostorscore=0
 spamscore=0 lowpriorityscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011030001
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit c0d0381ade79 ("hugetlbfs: use i_mmap_rwsem for more pmd sharing
synchronization") required changes to mm locking order that are hugetlb
specific.  Specifically, i_mmap_rwsem had to be taken before the page
lock.  This is not a big issue in hugetlb specific code, but becomes
more problematic in the areas of page migration and memory failure where
generic mm code had to deal with this change to lock ordering.  An ugly
routine 'hugetlb_page_mapping_lock_write' was added to help with these
issues.

Recently, Hugh Dickins diagnosed a migration BUG as caused by code
introduced with hugetlb i_mmap_rwsem synchronization [1].  Subsequent
discussion in that thread pointed out additional problems in the code.

In the previous patch, a rw_semaphore (hinode_rwsem) was added to the
hugetlbfs inode.  Using hinode_rwsem instead of i_mmap_rwsem is actually
a 'cleaner' approach to this problem as it can be inserted in the lock
hierarchy where needed.  And, there is no issue with other parts of the
mm using this rw_semaphore.

Change code to use hinode_rwsem instead of i_mmap_rwsem.

[1] https://lore.kernel.org/linux-mm/alpine.LSU.2.11.2010071833100.2214@eggly.anvils/

Fixes: c0d0381ade79 ("hugetlbfs: use i_mmap_rwsem for more pmd sharing synchronization")
Cc: <stable@vger.kernel.org>
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
---
 fs/hugetlbfs/inode.c    |  31 +++++--
 include/linux/fs.h      |  15 ----
 include/linux/hugetlb.h |   8 --
 mm/hugetlb.c            | 188 +++++++++++-----------------------------
 mm/memory-failure.c     |  34 +++-----
 mm/memory.c             |   5 ++
 mm/migrate.c            |  34 ++++----
 mm/rmap.c               |  21 ++---
 mm/userfaultfd.c        |  17 ++--
 9 files changed, 124 insertions(+), 229 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 4f1404b9f354..bc9979382a1e 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -501,24 +501,35 @@ static void remove_inode_hugepages(struct inode *inode, loff_t lstart,
 			mutex_lock(&hugetlb_fault_mutex_table[hash]);
 
 			/*
-			 * If page is mapped, it was faulted in after being
-			 * unmapped in caller.  Unmap (again) now after taking
-			 * the fault mutex.  The mutex will prevent faults
-			 * until we finish removing the page.
-			 *
-			 * This race can only happen in the hole punch case.
-			 * Getting here in a truncate operation is a bug.
+			 * After taking fault mutex, check if page is mapped.
+			 * If so, it was faulted in after being unmapped in
+			 * caller.
 			 */
 			if (unlikely(page_mapped(page))) {
+				bool hinode_locked;
+
+				/*
+				 * Unmap (again) now after taking the fault
+				 * mutex.  The mutex will prevent faults until
+				 * we finish removing the page.  Be sure to
+				 * take locks in the correct order.
+				 *
+				 * This race can only happen in the hole punch
+				 * case.  Getting here in a truncate operation
+				 * is a bug.
+				 */
 				BUG_ON(truncate_op);
-
 				mutex_unlock(&hugetlb_fault_mutex_table[hash]);
+				hinode_locked =
+					hinode_lock_write(inode, NULL, 0UL);
 				i_mmap_lock_write(mapping);
 				mutex_lock(&hugetlb_fault_mutex_table[hash]);
 				hugetlb_vmdelete_list(&mapping->i_mmap,
 					index * pages_per_huge_page(h),
 					(index + 1) * pages_per_huge_page(h));
 				i_mmap_unlock_write(mapping);
+				if (hinode_locked)
+					hinode_unlock_write(inode);
 			}
 
 			lock_page(page);
@@ -575,15 +586,19 @@ static int hugetlb_vmtruncate(struct inode *inode, loff_t offset)
 	pgoff_t pgoff;
 	struct address_space *mapping = inode->i_mapping;
 	struct hstate *h = hstate_inode(inode);
+	bool hinode_locked;
 
 	BUG_ON(offset & ~huge_page_mask(h));
 	pgoff = offset >> PAGE_SHIFT;
 
+	hinode_locked = hinode_lock_write(inode, NULL, 0UL);
 	i_size_write(inode, offset);
 	i_mmap_lock_write(mapping);
 	if (!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root))
 		hugetlb_vmdelete_list(&mapping->i_mmap, pgoff, 0);
 	i_mmap_unlock_write(mapping);
+	if (hinode_locked)
+		hinode_unlock_write(inode);
 	remove_inode_hugepages(inode, offset, LLONG_MAX);
 	return 0;
 }
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 21cc971fd960..8123f281c275 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -493,11 +493,6 @@ static inline void i_mmap_lock_write(struct address_space *mapping)
 	down_write(&mapping->i_mmap_rwsem);
 }
 
-static inline int i_mmap_trylock_write(struct address_space *mapping)
-{
-	return down_write_trylock(&mapping->i_mmap_rwsem);
-}
-
 static inline void i_mmap_unlock_write(struct address_space *mapping)
 {
 	up_write(&mapping->i_mmap_rwsem);
@@ -513,16 +508,6 @@ static inline void i_mmap_unlock_read(struct address_space *mapping)
 	up_read(&mapping->i_mmap_rwsem);
 }
 
-static inline void i_mmap_assert_locked(struct address_space *mapping)
-{
-	lockdep_assert_held(&mapping->i_mmap_rwsem);
-}
-
-static inline void i_mmap_assert_write_locked(struct address_space *mapping)
-{
-	lockdep_assert_held_write(&mapping->i_mmap_rwsem);
-}
-
 /*
  * Might pages of this file be mapped into userspace?
  */
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index c6a59c2dbc30..a03475cccb77 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -154,8 +154,6 @@ u32 hugetlb_fault_mutex_hash(struct address_space *mapping, pgoff_t idx);
 
 pte_t *huge_pmd_share(struct mm_struct *mm, unsigned long addr, pud_t *pud);
 
-struct address_space *hugetlb_page_mapping_lock_write(struct page *hpage);
-
 extern int sysctl_hugetlb_shm_group;
 extern struct list_head huge_boot_pages;
 
@@ -199,12 +197,6 @@ static inline unsigned long hugetlb_total_pages(void)
 	return 0;
 }
 
-static inline struct address_space *hugetlb_page_mapping_lock_write(
-							struct page *hpage)
-{
-	return NULL;
-}
-
 static inline int huge_pmd_unshare(struct mm_struct *mm,
 					struct vm_area_struct *vma,
 					unsigned long *addr, pte_t *ptep)
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index da57018926e4..957abc2d02ff 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1568,106 +1568,6 @@ int PageHeadHuge(struct page *page_head)
 	return page_head[1].compound_dtor == HUGETLB_PAGE_DTOR;
 }
 
-/*
- * Find address_space associated with hugetlbfs page.
- * Upon entry page is locked and page 'was' mapped although mapped state
- * could change.  If necessary, use anon_vma to find vma and associated
- * address space.  The returned mapping may be stale, but it can not be
- * invalid as page lock (which is held) is required to destroy mapping.
- */
-static struct address_space *_get_hugetlb_page_mapping(struct page *hpage)
-{
-	struct anon_vma *anon_vma;
-	pgoff_t pgoff_start, pgoff_end;
-	struct anon_vma_chain *avc;
-	struct address_space *mapping = page_mapping(hpage);
-
-	/* Simple file based mapping */
-	if (mapping)
-		return mapping;
-
-	/*
-	 * Even anonymous hugetlbfs mappings are associated with an
-	 * underlying hugetlbfs file (see hugetlb_file_setup in mmap
-	 * code).  Find a vma associated with the anonymous vma, and
-	 * use the file pointer to get address_space.
-	 */
-	anon_vma = page_lock_anon_vma_read(hpage);
-	if (!anon_vma)
-		return mapping;  /* NULL */
-
-	/* Use first found vma */
-	pgoff_start = page_to_pgoff(hpage);
-	pgoff_end = pgoff_start + pages_per_huge_page(page_hstate(hpage)) - 1;
-	anon_vma_interval_tree_foreach(avc, &anon_vma->rb_root,
-					pgoff_start, pgoff_end) {
-		struct vm_area_struct *vma = avc->vma;
-
-		mapping = vma->vm_file->f_mapping;
-		break;
-	}
-
-	anon_vma_unlock_read(anon_vma);
-	return mapping;
-}
-
-/*
- * Find and lock address space (mapping) in write mode.
- *
- * Upon entry, the page is locked which allows us to find the mapping
- * even in the case of an anon page.  However, locking order dictates
- * the i_mmap_rwsem be acquired BEFORE the page lock.  This is hugetlbfs
- * specific.  So, we first try to lock the sema while still holding the
- * page lock.  If this works, great!  If not, then we need to drop the
- * page lock and then acquire i_mmap_rwsem and reacquire page lock.  Of
- * course, need to revalidate state along the way.
- */
-struct address_space *hugetlb_page_mapping_lock_write(struct page *hpage)
-{
-	struct address_space *mapping, *mapping2;
-
-	mapping = _get_hugetlb_page_mapping(hpage);
-retry:
-	if (!mapping)
-		return mapping;
-
-	/*
-	 * If no contention, take lock and return
-	 */
-	if (i_mmap_trylock_write(mapping))
-		return mapping;
-
-	/*
-	 * Must drop page lock and wait on mapping sema.
-	 * Note:  Once page lock is dropped, mapping could become invalid.
-	 * As a hack, increase map count until we lock page again.
-	 */
-	atomic_inc(&hpage->_mapcount);
-	unlock_page(hpage);
-	i_mmap_lock_write(mapping);
-	lock_page(hpage);
-	atomic_add_negative(-1, &hpage->_mapcount);
-
-	/* verify page is still mapped */
-	if (!page_mapped(hpage)) {
-		i_mmap_unlock_write(mapping);
-		return NULL;
-	}
-
-	/*
-	 * Get address space again and verify it is the same one
-	 * we locked.  If not, drop lock and retry.
-	 */
-	mapping2 = _get_hugetlb_page_mapping(hpage);
-	if (mapping2 != mapping) {
-		i_mmap_unlock_write(mapping);
-		mapping = mapping2;
-		goto retry;
-	}
-
-	return mapping;
-}
-
 pgoff_t __basepage_index(struct page *page)
 {
 	struct page *page_head = compound_head(page);
@@ -3818,9 +3718,9 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 	int cow;
 	struct hstate *h = hstate_vma(vma);
 	unsigned long sz = huge_page_size(h);
-	struct address_space *mapping = vma->vm_file->f_mapping;
 	struct mmu_notifier_range range;
 	int ret = 0;
+	bool hinode_locked;
 
 	cow = (vma->vm_flags & (VM_SHARED | VM_MAYWRITE)) == VM_MAYWRITE;
 
@@ -3829,16 +3729,17 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 					vma->vm_start,
 					vma->vm_end);
 		mmu_notifier_invalidate_range_start(&range);
-	} else {
-		/*
-		 * For shared mappings i_mmap_rwsem must be held to call
-		 * huge_pte_alloc, otherwise the returned ptep could go
-		 * away if part of a shared pmd and another thread calls
-		 * huge_pmd_unshare.
-		 */
-		i_mmap_lock_read(mapping);
 	}
 
+	/*
+	 * For shared mappings hinode_rwsem must be held to call
+	 * huge_pte_alloc, otherwise the returned ptep could go
+	 * away if part of a shared pmd and another thread calls
+	 * huge_pmd_unshare.
+	 *
+	 */
+	hinode_locked = hinode_lock_read(vma->vm_file->f_inode, vma, 0UL);
+
 	for (addr = vma->vm_start; addr < vma->vm_end; addr += sz) {
 		spinlock_t *src_ptl, *dst_ptl;
 		src_pte = huge_pte_offset(src, addr, sz);
@@ -3914,8 +3815,8 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 
 	if (cow)
 		mmu_notifier_invalidate_range_end(&range);
-	else
-		i_mmap_unlock_read(mapping);
+	if (hinode_locked)
+		hinode_unlock_read(vma->vm_file->f_inode);
 
 	return ret;
 }
@@ -4311,7 +4212,8 @@ int huge_add_to_page_cache(struct page *page, struct address_space *mapping,
 static vm_fault_t hugetlb_no_page(struct mm_struct *mm,
 			struct vm_area_struct *vma,
 			struct address_space *mapping, pgoff_t idx,
-			unsigned long address, pte_t *ptep, unsigned int flags)
+			unsigned long address, pte_t *ptep, unsigned int flags,
+			bool hinode_locked)
 {
 	struct hstate *h = hstate_vma(vma);
 	vm_fault_t ret = VM_FAULT_SIGBUS;
@@ -4364,15 +4266,20 @@ static vm_fault_t hugetlb_no_page(struct mm_struct *mm,
 			};
 
 			/*
-			 * hugetlb_fault_mutex and i_mmap_rwsem must be
-			 * dropped before handling userfault.  Reacquire
-			 * after handling fault to make calling code simpler.
+			 * hugetlb_fault_mutex and inode mutex must be dropped
+			 * before handling userfault.  Reacquire after handling
+			 * fault to make calling code simpler.
 			 */
 			hash = hugetlb_fault_mutex_hash(mapping, idx);
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
-			i_mmap_unlock_read(mapping);
+			if (hinode_locked)
+				hinode_unlock_read(mapping->host);
+
 			ret = handle_userfault(&vmf, VM_UFFD_MISSING);
-			i_mmap_lock_read(mapping);
+
+			if (hinode_locked)
+				(void)hinode_lock_read(mapping->host, vma,
+							address);
 			mutex_lock(&hugetlb_fault_mutex_table[hash]);
 			goto out;
 		}
@@ -4534,6 +4441,7 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	struct address_space *mapping;
 	int need_wait_lock = 0;
 	unsigned long haddr = address & huge_page_mask(h);
+	bool hinode_locked;
 
 	ptep = huge_pte_offset(mm, haddr, huge_page_size(h));
 	if (ptep) {
@@ -4552,7 +4460,7 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	}
 
 	/*
-	 * Acquire i_mmap_rwsem before calling huge_pte_alloc and hold
+	 * Acquire hinode_rwsem before calling huge_pte_alloc and hold
 	 * until finished with ptep.  This prevents huge_pmd_unshare from
 	 * being called elsewhere and making the ptep no longer valid.
 	 *
@@ -4561,11 +4469,11 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	 * something has changed.
 	 */
 	mapping = vma->vm_file->f_mapping;
-	i_mmap_lock_read(mapping);
+	hinode_locked = hinode_lock_read(mapping->host, vma, address);
 	ptep = huge_pte_alloc(mm, haddr, huge_page_size(h));
 	if (!ptep) {
-		i_mmap_unlock_read(mapping);
-		return VM_FAULT_OOM;
+		ret = VM_FAULT_OOM;
+		goto out_mutex;
 	}
 
 	/*
@@ -4579,7 +4487,8 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 
 	entry = huge_ptep_get(ptep);
 	if (huge_pte_none(entry)) {
-		ret = hugetlb_no_page(mm, vma, mapping, idx, address, ptep, flags);
+		ret = hugetlb_no_page(mm, vma, mapping, idx, address, ptep,
+					flags, hinode_locked);
 		goto out_mutex;
 	}
 
@@ -4661,7 +4570,8 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	}
 out_mutex:
 	mutex_unlock(&hugetlb_fault_mutex_table[hash]);
-	i_mmap_unlock_read(mapping);
+	if (hinode_locked)
+		hinode_unlock_read(mapping->host);
 	/*
 	 * Generally it's safe to hold refcount during waiting page lock. But
 	 * here we just wait to defer the next page fault to avoid busy loop and
@@ -5002,6 +4912,7 @@ unsigned long hugetlb_change_protection(struct vm_area_struct *vma,
 	unsigned long pages = 0;
 	bool shared_pmd = false;
 	struct mmu_notifier_range range;
+	bool hinode_locked;
 
 	/*
 	 * In the case of shared PMDs, the area to flush could be beyond
@@ -5016,6 +4927,8 @@ unsigned long hugetlb_change_protection(struct vm_area_struct *vma,
 	flush_cache_range(vma, range.start, range.end);
 
 	mmu_notifier_invalidate_range_start(&range);
+	hinode_locked = hinode_lock_write(vma->vm_file->f_inode, vma,
+						range.start);
 	i_mmap_lock_write(vma->vm_file->f_mapping);
 	for (; address < end; address += huge_page_size(h)) {
 		spinlock_t *ptl;
@@ -5078,6 +4991,8 @@ unsigned long hugetlb_change_protection(struct vm_area_struct *vma,
 	 * See Documentation/vm/mmu_notifier.rst
 	 */
 	i_mmap_unlock_write(vma->vm_file->f_mapping);
+	if (hinode_locked)
+		hinode_unlock_write(vma->vm_file->f_inode);
 	mmu_notifier_invalidate_range_end(&range);
 
 	return pages << h->order;
@@ -5327,16 +5242,11 @@ void adjust_range_if_pmd_sharing_possible(struct vm_area_struct *vma,
  * !shared pmd case because we can allocate the pmd later as well, it makes the
  * code much cleaner.
  *
- * This routine must be called with i_mmap_rwsem held in at least read mode if
- * sharing is possible.  For hugetlbfs, this prevents removal of any page
- * table entries associated with the address space.  This is important as we
- * are setting up sharing based on existing page table entries (mappings).
- *
- * NOTE: This routine is only called from huge_pte_alloc.  Some callers of
- * huge_pte_alloc know that sharing is not possible and do not take
- * i_mmap_rwsem as a performance optimization.  This is handled by the
- * if !vma_shareable check at the beginning of the routine. i_mmap_rwsem is
- * only required for subsequent processing.
+ * This must be called with hinode_rwsem held in read mode if sharing is
+ * possible.  Otherwise, it could race with huge_pmd_unshare and the pte_t
+ * pointer could become invalid before being returned to the caller.  Callers
+ * should use the helper routine hinode_lock_read() which will determine if
+ * sharing is possible and acquire the rwsem if necessary.
  */
 pte_t *huge_pmd_share(struct mm_struct *mm, unsigned long addr, pud_t *pud)
 {
@@ -5352,8 +5262,9 @@ pte_t *huge_pmd_share(struct mm_struct *mm, unsigned long addr, pud_t *pud)
 
 	if (!vma_shareable(vma, addr))
 		return (pte_t *)pmd_alloc(mm, pud, addr);
+	hinode_assert_locked(mapping);
 
-	i_mmap_assert_locked(mapping);
+	i_mmap_lock_read(mapping);
 	vma_interval_tree_foreach(svma, &mapping->i_mmap, idx, idx) {
 		if (svma == vma)
 			continue;
@@ -5383,6 +5294,7 @@ pte_t *huge_pmd_share(struct mm_struct *mm, unsigned long addr, pud_t *pud)
 	spin_unlock(ptl);
 out:
 	pte = (pte_t *)pmd_alloc(mm, pud, addr);
+	i_mmap_unlock_read(mapping);
 	return pte;
 }
 
@@ -5393,7 +5305,10 @@ pte_t *huge_pmd_share(struct mm_struct *mm, unsigned long addr, pud_t *pud)
  * indicated by page_count > 1, unmap is achieved by clearing pud and
  * decrementing the ref count. If count == 1, the pte page is not shared.
  *
- * Called with page table lock held and i_mmap_rwsem held in write mode.
+ * Called with page table lock held and hinode_rwsem held in write mode if
+ * sharing is possible.  Callers should use the helper routine
+ * hinode_lock_write() which will determine if sharing is possible and acquire
+ * the rwsem if necessary.
  *
  * returns: 1 successfully unmapped a shared pte page
  *	    0 the underlying pte page is not shared, or it is the last user
@@ -5405,11 +5320,12 @@ int huge_pmd_unshare(struct mm_struct *mm, struct vm_area_struct *vma,
 	p4d_t *p4d = p4d_offset(pgd, *addr);
 	pud_t *pud = pud_offset(p4d, *addr);
 
-	i_mmap_assert_write_locked(vma->vm_file->f_mapping);
 	BUG_ON(page_count(virt_to_page(ptep)) == 0);
 	if (page_count(virt_to_page(ptep)) == 1)
 		return 0;
 
+	hinode_assert_write_locked(vma->vm_file->f_mapping);
+
 	pud_clear(pud);
 	put_page(virt_to_page(ptep));
 	mm_dec_nr_pmds(mm);
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index c0bb186bba62..593c109a3c80 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -992,7 +992,7 @@ static bool hwpoison_user_mappings(struct page *p, unsigned long pfn,
 	enum ttu_flags ttu = TTU_IGNORE_MLOCK | TTU_IGNORE_ACCESS;
 	struct address_space *mapping;
 	LIST_HEAD(tokill);
-	bool unmap_success = true;
+	bool unmap_success;
 	int kill = 1, forcekill;
 	struct page *hpage = *hpagep;
 	bool mlocked = PageMlocked(hpage);
@@ -1054,31 +1054,19 @@ static bool hwpoison_user_mappings(struct page *p, unsigned long pfn,
 	if (kill)
 		collect_procs(hpage, &tokill, flags & MF_ACTION_REQUIRED);
 
-	if (!PageHuge(hpage)) {
-		unmap_success = try_to_unmap(hpage, ttu);
-	} else {
+	if (PageHuge(hpage) && !PageAnon(hpage) && mapping) {
+		bool hinode_locked;
 		/*
 		 * For hugetlb pages, try_to_unmap could potentially call
-		 * huge_pmd_unshare.  Because of this, take semaphore in
-		 * write mode here and set TTU_RMAP_LOCKED to indicate we
-		 * have taken the lock at this higer level.
-		 *
-		 * Note that the call to hugetlb_page_mapping_lock_write
-		 * is necessary even if mapping is already set.  It handles
-		 * ugliness of potentially having to drop page lock to obtain
-		 * i_mmap_rwsem.
+		 * huge_pmd_unshare.  Because of this, take hinode_rwsem
+		 * in write mode before calling.
 		 */
-		mapping = hugetlb_page_mapping_lock_write(hpage);
-
-		if (mapping) {
-			unmap_success = try_to_unmap(hpage,
-						     ttu|TTU_RMAP_LOCKED);
-			i_mmap_unlock_write(mapping);
-		} else {
-			pr_info("Memory failure: %#lx: could not find mapping for mapped huge page\n",
-				pfn);
-			unmap_success = false;
-		}
+		hinode_locked = hinode_lock_write(mapping->host, NULL, 0UL);
+		unmap_success = try_to_unmap(hpage, ttu);
+		if (hinode_locked)
+			hinode_unlock_write(mapping->host);
+	} else {
+		unmap_success = try_to_unmap(hpage, ttu);
 	}
 	if (!unmap_success)
 		pr_err("Memory failure: %#lx: failed to unmap page (mapcount=%d)\n",
diff --git a/mm/memory.c b/mm/memory.c
index c48f8df6e502..315d92bb68ff 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1465,9 +1465,14 @@ static void unmap_single_vma(struct mmu_gather *tlb,
 			 * safe to do nothing in this case.
 			 */
 			if (vma->vm_file) {
+				bool hinode_locked;
+
+				hinode_locked = hinode_lock_write(vma->vm_file->f_inode, vma, 0UL);
 				i_mmap_lock_write(vma->vm_file->f_mapping);
 				__unmap_hugepage_range_final(tlb, vma, start, end, NULL);
 				i_mmap_unlock_write(vma->vm_file->f_mapping);
+				if (hinode_locked)
+					hinode_unlock_write(vma->vm_file->f_inode);
 			}
 		} else
 			unmap_page_range(tlb, vma, start, end, details);
diff --git a/mm/migrate.c b/mm/migrate.c
index 5ca5842df5db..a5685565cf1a 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1280,7 +1280,6 @@ static int unmap_and_move_huge_page(new_page_t get_new_page,
 	int page_was_mapped = 0;
 	struct page *new_hpage;
 	struct anon_vma *anon_vma = NULL;
-	struct address_space *mapping = NULL;
 
 	/*
 	 * Migratability of hugepages depends on architectures and their size.
@@ -1328,36 +1327,33 @@ static int unmap_and_move_huge_page(new_page_t get_new_page,
 		goto put_anon;
 
 	if (page_mapped(hpage)) {
+		struct address_space *mapping = NULL;
+		bool hinode_locked = false;
+
 		/*
 		 * try_to_unmap could potentially call huge_pmd_unshare.
-		 * Because of this, take semaphore in write mode here and
-		 * set TTU_RMAP_LOCKED to let lower levels know we have
-		 * taken the lock.
+		 * Take hinode_rwsem if sharing is possible.
 		 */
-		mapping = hugetlb_page_mapping_lock_write(hpage);
-		if (unlikely(!mapping))
-			goto unlock_put_anon;
-
+		if (!PageAnon(hpage)) {
+			mapping = page_mapping(hpage);
+			if (mapping)
+				hinode_locked = hinode_lock_write(mapping->host,
+								NULL, 0UL);
+		}
 		try_to_unmap(hpage,
-			TTU_MIGRATION|TTU_IGNORE_MLOCK|TTU_IGNORE_ACCESS|
-			TTU_RMAP_LOCKED);
+			TTU_MIGRATION|TTU_IGNORE_MLOCK|TTU_IGNORE_ACCESS);
 		page_was_mapped = 1;
-		/*
-		 * Leave mapping locked until after subsequent call to
-		 * remove_migration_ptes()
-		 */
+		if (hinode_locked)
+			hinode_unlock_write(mapping->host);
 	}
 
 	if (!page_mapped(hpage))
 		rc = move_to_new_page(new_hpage, hpage, mode);
 
-	if (page_was_mapped) {
+	if (page_was_mapped)
 		remove_migration_ptes(hpage,
-			rc == MIGRATEPAGE_SUCCESS ? new_hpage : hpage, true);
-		i_mmap_unlock_write(mapping);
-	}
+			rc == MIGRATEPAGE_SUCCESS ? new_hpage : hpage, false);
 
-unlock_put_anon:
 	unlock_page(new_hpage);
 
 put_anon:
diff --git a/mm/rmap.c b/mm/rmap.c
index 1b84945d655c..bb05ec810734 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -22,7 +22,8 @@
  *
  * inode->i_mutex	(while writing or truncating, not reading or faulting)
  *   mm->mmap_lock
- *     page->flags PG_locked (lock_page)   * (see huegtlbfs below)
+ *   hugetlbfs inode->hinode_rwsem (hugetlbfs specific, see below)
+ *     page->flags PG_locked (lock_page)
  *       hugetlbfs_i_mmap_rwsem_key (in huge_pmd_share)
  *         mapping->i_mmap_rwsem
  *           hugetlb_fault_mutex (hugetlbfs specific page fault mutex)
@@ -45,10 +46,11 @@
  *   ->tasklist_lock
  *     pte map lock
  *
- * * hugetlbfs PageHuge() pages take locks in this order:
- *         mapping->i_mmap_rwsem
- *           hugetlb_fault_mutex (hugetlbfs specific page fault mutex)
- *             page->flags PG_locked (lock_page)
+ * hugetlbfs PageHuge() pages take locks in this order:
+ *   hugetlbfs inode->hinode_rwsem
+ *     mapping->i_mmap_rwsem
+ *       hugetlb_fault_mutex ((hugetlbfs specific page fault mutex)
+ *         page->flags PG_locked (NOT acquired with mapping->i_mmap_rwsem)
  */
 
 #include <linux/mm.h>
@@ -1413,9 +1415,6 @@ static bool try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
 		/*
 		 * If sharing is possible, start and end will be adjusted
 		 * accordingly.
-		 *
-		 * If called for a huge page, caller must hold i_mmap_rwsem
-		 * in write mode as it is possible to call huge_pmd_unshare.
 		 */
 		adjust_range_if_pmd_sharing_possible(vma, &range.start,
 						     &range.end);
@@ -1463,12 +1462,6 @@ static bool try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
 		address = pvmw.address;
 
 		if (PageHuge(page)) {
-			/*
-			 * To call huge_pmd_unshare, i_mmap_rwsem must be
-			 * held in write mode.  Caller needs to explicitly
-			 * do this outside rmap routines.
-			 */
-			VM_BUG_ON(!(flags & TTU_RMAP_LOCKED));
 			if (huge_pmd_unshare(mm, vma, &address, pvmw.pte)) {
 				/*
 				 * huge_pmd_unshare unmapped an entire PMD
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 9a3d451402d7..b94101591027 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -220,6 +220,7 @@ static __always_inline ssize_t __mcopy_atomic_hugetlb(struct mm_struct *dst_mm,
 	pgoff_t idx;
 	u32 hash;
 	struct address_space *mapping;
+	bool hinode_locked;
 
 	/*
 	 * There is no default zero huge page for all huge page sizes as
@@ -278,13 +279,14 @@ static __always_inline ssize_t __mcopy_atomic_hugetlb(struct mm_struct *dst_mm,
 		BUG_ON(dst_addr >= dst_start + len);
 
 		/*
-		 * Serialize via i_mmap_rwsem and hugetlb_fault_mutex.
-		 * i_mmap_rwsem ensures the dst_pte remains valid even
+		 * Serialize via hinode_rwsem and hugetlb_fault_mutex.
+		 * hinode_rwsem ensures the dst_pte remains valid even
 		 * in the case of shared pmds.  fault mutex prevents
 		 * races with other faulting threads.
 		 */
 		mapping = dst_vma->vm_file->f_mapping;
-		i_mmap_lock_read(mapping);
+		hinode_locked = hinode_lock_read(mapping->host, dst_vma,
+								dst_addr);
 		idx = linear_page_index(dst_vma, dst_addr);
 		hash = hugetlb_fault_mutex_hash(mapping, idx);
 		mutex_lock(&hugetlb_fault_mutex_table[hash]);
@@ -293,7 +295,8 @@ static __always_inline ssize_t __mcopy_atomic_hugetlb(struct mm_struct *dst_mm,
 		dst_pte = huge_pte_alloc(dst_mm, dst_addr, vma_hpagesize);
 		if (!dst_pte) {
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
-			i_mmap_unlock_read(mapping);
+			if (hinode_locked)
+				hinode_unlock_read(mapping->host);
 			goto out_unlock;
 		}
 
@@ -301,7 +304,8 @@ static __always_inline ssize_t __mcopy_atomic_hugetlb(struct mm_struct *dst_mm,
 		dst_pteval = huge_ptep_get(dst_pte);
 		if (!huge_pte_none(dst_pteval)) {
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
-			i_mmap_unlock_read(mapping);
+			if (hinode_locked)
+				hinode_unlock_read(mapping->host);
 			goto out_unlock;
 		}
 
@@ -309,7 +313,8 @@ static __always_inline ssize_t __mcopy_atomic_hugetlb(struct mm_struct *dst_mm,
 						dst_addr, src_addr, &page);
 
 		mutex_unlock(&hugetlb_fault_mutex_table[hash]);
-		i_mmap_unlock_read(mapping);
+		if (hinode_locked)
+			hinode_unlock_read(mapping->host);
 		vm_alloc_shared = vm_shared;
 
 		cond_resched();
-- 
2.28.0

