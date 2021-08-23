Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 049C73F5054
	for <lists+stable@lfdr.de>; Mon, 23 Aug 2021 20:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232071AbhHWSZL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 14:25:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:59862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231716AbhHWSZK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Aug 2021 14:25:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A73C1613A8;
        Mon, 23 Aug 2021 18:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629743068;
        bh=yBXnHohHk48JZPMfxWkZOWwXC+BmRrIuLzSiruVsB5w=;
        h=Date:From:To:Subject:From;
        b=ZAZAvHIH11GebJ8z+HcBXsIQcOQB05Ca+kim6HvyyyXItlu6/rkvS03o0a3NyFwAF
         A8W+FhbyJAjnZzKMg9Kcjqip56wf1Fz91tJ4v1nX3H2EvRm1mMJ/lgzwPmVzBWXH4C
         hjUDF4amjcY2l7bJnQ8sfVyOlqZ+ZxDJxjCn873c=
Date:   Mon, 23 Aug 2021 11:24:27 -0700
From:   akpm@linux-foundation.org
To:     almasrymina@google.com, axelrasmussen@google.com, mhocko@suse.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@linux.dev, peterx@redhat.com,
        songmuchun@bytedance.com, stable@vger.kernel.org,
        syzbot+67654e51e54455f1c585@syzkaller.appspotmail.com
Subject:  [merged]
 hugetlb-dont-pass-page-cache-pages-to-restore_reserve_on_error.patch
 removed from -mm tree
Message-ID: <20210823182427.ShPxNqnFY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: hugetlb: don't pass page cache pages to restore_reserve_on_error
has been removed from the -mm tree.  Its filename was
     hugetlb-dont-pass-page-cache-pages-to-restore_reserve_on_error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: don't pass page cache pages to restore_reserve_on_error

syzbot hit kernel BUG at fs/hugetlbfs/inode.c:532 as described in [1].
This BUG triggers if the HPageRestoreReserve flag is set on a page in
the page cache.  It should never be set, as the routine
huge_add_to_page_cache explicitly clears the flag after adding a page
to the cache.

The only code other than huge page allocation which sets the flag is
restore_reserve_on_error.  It will potentially set the flag in rare out
of memory conditions.  syzbot was injecting errors to cause memory
allocation errors which exercised this specific path.

The code in restore_reserve_on_error is doing the right thing.  However,
there are instances where pages in the page cache were being passed to
restore_reserve_on_error.  This is incorrect, as once a page goes into
the cache reservation information will not be modified for the page until
it is removed from the cache.  Error paths do not remove pages from the
cache, so even in the case of error, the page will remain in the cache
and no reservation adjustment is needed.

Modify routines that potentially call restore_reserve_on_error with a
page cache page to no longer do so.

Note on fixes tag:
Prior to commit 846be08578ed ("mm/hugetlb: expand restore_reserve_on_error
functionality") the routine would not process page cache pages because
the HPageRestoreReserve flag is not set on such pages.  Therefore, this
issue could not be trigggered.  The code added by commit 846be08578ed
("mm/hugetlb: expand restore_reserve_on_error functionality") is needed
and correct.  It exposed incorrect calls to restore_reserve_on_error which
is the root cause addressed by this commit.

[1] https://lore.kernel.org/linux-mm/00000000000050776d05c9b7c7f0@google.com/

Link: https://lkml.kernel.org/r/20210818213304.37038-1-mike.kravetz@oracle.com
Fixes: 846be08578ed ("mm/hugetlb: expand restore_reserve_on_error functionality")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reported-by: <syzbot+67654e51e54455f1c585@syzkaller.appspotmail.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

--- a/mm/hugetlb.c~hugetlb-dont-pass-page-cache-pages-to-restore_reserve_on_error
+++ a/mm/hugetlb.c
@@ -2476,7 +2476,7 @@ void restore_reserve_on_error(struct hst
 		if (!rc) {
 			/*
 			 * This indicates there is an entry in the reserve map
-			 * added by alloc_huge_page.  We know it was added
+			 * not added by alloc_huge_page.  We know it was added
 			 * before the alloc_huge_page call, otherwise
 			 * HPageRestoreReserve would be set on the page.
 			 * Remove the entry so that a subsequent allocation
@@ -4660,7 +4660,9 @@ retry_avoidcopy:
 	spin_unlock(ptl);
 	mmu_notifier_invalidate_range_end(&range);
 out_release_all:
-	restore_reserve_on_error(h, vma, haddr, new_page);
+	/* No restore in case of successful pagetable update (Break COW) */
+	if (new_page != old_page)
+		restore_reserve_on_error(h, vma, haddr, new_page);
 	put_page(new_page);
 out_release_old:
 	put_page(old_page);
@@ -4776,7 +4778,7 @@ static vm_fault_t hugetlb_no_page(struct
 	pte_t new_pte;
 	spinlock_t *ptl;
 	unsigned long haddr = address & huge_page_mask(h);
-	bool new_page = false;
+	bool new_page, new_pagecache_page = false;
 
 	/*
 	 * Currently, we are forced to kill the process in the event the
@@ -4799,6 +4801,7 @@ static vm_fault_t hugetlb_no_page(struct
 		goto out;
 
 retry:
+	new_page = false;
 	page = find_lock_page(mapping, idx);
 	if (!page) {
 		/* Check for page in userfault range */
@@ -4842,6 +4845,7 @@ retry:
 					goto retry;
 				goto out;
 			}
+			new_pagecache_page = true;
 		} else {
 			lock_page(page);
 			if (unlikely(anon_vma_prepare(vma))) {
@@ -4926,7 +4930,9 @@ backout:
 	spin_unlock(ptl);
 backout_unlocked:
 	unlock_page(page);
-	restore_reserve_on_error(h, vma, haddr, page);
+	/* restore reserve for newly allocated pages not in page cache */
+	if (new_page && !new_pagecache_page)
+		restore_reserve_on_error(h, vma, haddr, page);
 	put_page(page);
 	goto out;
 }
@@ -5135,6 +5141,7 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 	int ret = -ENOMEM;
 	struct page *page;
 	int writable;
+	bool new_pagecache_page = false;
 
 	if (is_continue) {
 		ret = -EFAULT;
@@ -5228,6 +5235,7 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 		ret = huge_add_to_page_cache(page, mapping, idx);
 		if (ret)
 			goto out_release_nounlock;
+		new_pagecache_page = true;
 	}
 
 	ptl = huge_pte_lockptr(h, dst_mm, dst_pte);
@@ -5291,7 +5299,8 @@ out_release_unlock:
 	if (vm_shared || is_continue)
 		unlock_page(page);
 out_release_nounlock:
-	restore_reserve_on_error(h, dst_vma, dst_addr, page);
+	if (!new_pagecache_page)
+		restore_reserve_on_error(h, dst_vma, dst_addr, page);
 	put_page(page);
 	goto out;
 }
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-simplify-prep_compound_gigantic_page-ref-count-racing-code.patch
hugetlb-drop-ref-count-earlier-after-page-allocation.patch
hugetlb-before-freeing-hugetlb-page-set-dtor-to-appropriate-value.patch

