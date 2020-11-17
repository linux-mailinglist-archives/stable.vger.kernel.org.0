Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAD272B63AF
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:42:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732883AbgKQNkg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:40:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:52598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732876AbgKQNkg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:40:36 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D3F42467D;
        Tue, 17 Nov 2020 13:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620434;
        bh=tQWcMttNDOMYazO5hMAE7PAwKHVUNacXEJ6K9oa/mAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=spgZi+gbvWJ0zHfKgCF5ByBuEYnSMb+FtvMtzt4qThPtn0r8M5aYL4uEjYSseQxOE
         yDk2vC7VjhIYlHz8FbubWz5vuIIR7Qxyg7WyGWTFHzmYLZjUEasbWp4nmB6ythLEbw
         CdJCn3+X2gxDtDNRITN3EIE0FXhVfGQjjGnArGt4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@lca.pw>,
        Hugh Dickins <hughd@google.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.9 216/255] hugetlbfs: fix anon huge page migration race
Date:   Tue, 17 Nov 2020 14:05:56 +0100
Message-Id: <20201117122149.451098128@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Kravetz <mike.kravetz@oracle.com>

commit 336bf30eb76580b579dc711ded5d599d905c0217 upstream.

Qian Cai reported the following BUG in [1]

  LTP: starting move_pages12
  BUG: unable to handle page fault for address: ffffffffffffffe0
  ...
  RIP: 0010:anon_vma_interval_tree_iter_first+0xa2/0x170 avc_start_pgoff at mm/interval_tree.c:63
  Call Trace:
    rmap_walk_anon+0x141/0xa30 rmap_walk_anon at mm/rmap.c:1864
    try_to_unmap+0x209/0x2d0 try_to_unmap at mm/rmap.c:1763
    migrate_pages+0x1005/0x1fb0
    move_pages_and_store_status.isra.47+0xd7/0x1a0
    __x64_sys_move_pages+0xa5c/0x1100
    do_syscall_64+0x5f/0x310
    entry_SYSCALL_64_after_hwframe+0x44/0xa9

Hugh Dickins diagnosed this as a migration bug caused by code introduced
to use i_mmap_rwsem for pmd sharing synchronization.  Specifically, the
routine unmap_and_move_huge_page() is always passing the TTU_RMAP_LOCKED
flag to try_to_unmap() while holding i_mmap_rwsem.  This is wrong for
anon pages as the anon_vma_lock should be held in this case.  Further
analysis suggested that i_mmap_rwsem was not required to he held at all
when calling try_to_unmap for anon pages as an anon page could never be
part of a shared pmd mapping.

Discussion also revealed that the hack in hugetlb_page_mapping_lock_write
to drop page lock and acquire i_mmap_rwsem is wrong.  There is no way to
keep mapping valid while dropping page lock.

This patch does the following:

 - Do not take i_mmap_rwsem and set TTU_RMAP_LOCKED for anon pages when
   calling try_to_unmap.

 - Remove the hacky code in hugetlb_page_mapping_lock_write. The routine
   will now simply do a 'trylock' while still holding the page lock. If
   the trylock fails, it will return NULL. This could impact the
   callers:

    - migration calling code will receive -EAGAIN and retry up to the
      hard coded limit (10).

    - memory error code will treat the page as BUSY. This will force
      killing (SIGKILL) instead of SIGBUS any mapping tasks.

   Do note that this change in behavior only happens when there is a
   race. None of the standard kernel testing suites actually hit this
   race, but it is possible.

[1] https://lore.kernel.org/lkml/20200708012044.GC992@lca.pw/
[2] https://lore.kernel.org/linux-mm/alpine.LSU.2.11.2010071833100.2214@eggly.anvils/

Fixes: c0d0381ade79 ("hugetlbfs: use i_mmap_rwsem for more pmd sharing synchronization")
Reported-by: Qian Cai <cai@lca.pw>
Suggested-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20201105195058.78401-1-mike.kravetz@oracle.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/hugetlb.c        |   90 ++--------------------------------------------------
 mm/memory-failure.c |   36 +++++++++-----------
 mm/migrate.c        |   46 ++++++++++++++------------
 mm/rmap.c           |    5 --
 4 files changed, 48 insertions(+), 129 deletions(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1579,103 +1579,23 @@ int PageHeadHuge(struct page *page_head)
 }
 
 /*
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
  * Find and lock address space (mapping) in write mode.
  *
- * Upon entry, the page is locked which allows us to find the mapping
- * even in the case of an anon page.  However, locking order dictates
- * the i_mmap_rwsem be acquired BEFORE the page lock.  This is hugetlbfs
- * specific.  So, we first try to lock the sema while still holding the
- * page lock.  If this works, great!  If not, then we need to drop the
- * page lock and then acquire i_mmap_rwsem and reacquire page lock.  Of
- * course, need to revalidate state along the way.
+ * Upon entry, the page is locked which means that page_mapping() is
+ * stable.  Due to locking order, we can only trylock_write.  If we can
+ * not get the lock, simply return NULL to caller.
  */
 struct address_space *hugetlb_page_mapping_lock_write(struct page *hpage)
 {
-	struct address_space *mapping, *mapping2;
+	struct address_space *mapping = page_mapping(hpage);
 
-	mapping = _get_hugetlb_page_mapping(hpage);
-retry:
 	if (!mapping)
 		return mapping;
 
-	/*
-	 * If no contention, take lock and return
-	 */
 	if (i_mmap_trylock_write(mapping))
 		return mapping;
 
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
+	return NULL;
 }
 
 pgoff_t __basepage_index(struct page *page)
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1031,27 +1031,25 @@ static bool hwpoison_user_mappings(struc
 	if (!PageHuge(hpage)) {
 		unmap_success = try_to_unmap(hpage, ttu);
 	} else {
-		/*
-		 * For hugetlb pages, try_to_unmap could potentially call
-		 * huge_pmd_unshare.  Because of this, take semaphore in
-		 * write mode here and set TTU_RMAP_LOCKED to indicate we
-		 * have taken the lock at this higer level.
-		 *
-		 * Note that the call to hugetlb_page_mapping_lock_write
-		 * is necessary even if mapping is already set.  It handles
-		 * ugliness of potentially having to drop page lock to obtain
-		 * i_mmap_rwsem.
-		 */
-		mapping = hugetlb_page_mapping_lock_write(hpage);
-
-		if (mapping) {
-			unmap_success = try_to_unmap(hpage,
+		if (!PageAnon(hpage)) {
+			/*
+			 * For hugetlb pages in shared mappings, try_to_unmap
+			 * could potentially call huge_pmd_unshare.  Because of
+			 * this, take semaphore in write mode here and set
+			 * TTU_RMAP_LOCKED to indicate we have taken the lock
+			 * at this higer level.
+			 */
+			mapping = hugetlb_page_mapping_lock_write(hpage);
+			if (mapping) {
+				unmap_success = try_to_unmap(hpage,
 						     ttu|TTU_RMAP_LOCKED);
-			i_mmap_unlock_write(mapping);
+				i_mmap_unlock_write(mapping);
+			} else {
+				pr_info("Memory failure: %#lx: could not lock mapping for mapped huge page\n", pfn);
+				unmap_success = false;
+			}
 		} else {
-			pr_info("Memory failure: %#lx: could not find mapping for mapped huge page\n",
-				pfn);
-			unmap_success = false;
+			unmap_success = try_to_unmap(hpage, ttu);
 		}
 	}
 	if (!unmap_success)
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1333,34 +1333,38 @@ static int unmap_and_move_huge_page(new_
 		goto put_anon;
 
 	if (page_mapped(hpage)) {
-		/*
-		 * try_to_unmap could potentially call huge_pmd_unshare.
-		 * Because of this, take semaphore in write mode here and
-		 * set TTU_RMAP_LOCKED to let lower levels know we have
-		 * taken the lock.
-		 */
-		mapping = hugetlb_page_mapping_lock_write(hpage);
-		if (unlikely(!mapping))
-			goto unlock_put_anon;
-
-		try_to_unmap(hpage,
-			TTU_MIGRATION|TTU_IGNORE_MLOCK|TTU_IGNORE_ACCESS|
-			TTU_RMAP_LOCKED);
+		bool mapping_locked = false;
+		enum ttu_flags ttu = TTU_MIGRATION|TTU_IGNORE_MLOCK|
+					TTU_IGNORE_ACCESS;
+
+		if (!PageAnon(hpage)) {
+			/*
+			 * In shared mappings, try_to_unmap could potentially
+			 * call huge_pmd_unshare.  Because of this, take
+			 * semaphore in write mode here and set TTU_RMAP_LOCKED
+			 * to let lower levels know we have taken the lock.
+			 */
+			mapping = hugetlb_page_mapping_lock_write(hpage);
+			if (unlikely(!mapping))
+				goto unlock_put_anon;
+
+			mapping_locked = true;
+			ttu |= TTU_RMAP_LOCKED;
+		}
+
+		try_to_unmap(hpage, ttu);
 		page_was_mapped = 1;
-		/*
-		 * Leave mapping locked until after subsequent call to
-		 * remove_migration_ptes()
-		 */
+
+		if (mapping_locked)
+			i_mmap_unlock_write(mapping);
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
 
 unlock_put_anon:
 	unlock_page(new_hpage);
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1413,9 +1413,6 @@ static bool try_to_unmap_one(struct page
 		/*
 		 * If sharing is possible, start and end will be adjusted
 		 * accordingly.
-		 *
-		 * If called for a huge page, caller must hold i_mmap_rwsem
-		 * in write mode as it is possible to call huge_pmd_unshare.
 		 */
 		adjust_range_if_pmd_sharing_possible(vma, &range.start,
 						     &range.end);
@@ -1462,7 +1459,7 @@ static bool try_to_unmap_one(struct page
 		subpage = page - page_to_pfn(page) + pte_pfn(*pvmw.pte);
 		address = pvmw.address;
 
-		if (PageHuge(page)) {
+		if (PageHuge(page) && !PageAnon(page)) {
 			/*
 			 * To call huge_pmd_unshare, i_mmap_rwsem must be
 			 * held in write mode.  Caller needs to explicitly


