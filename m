Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71E143F0E70
	for <lists+stable@lfdr.de>; Thu, 19 Aug 2021 00:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234686AbhHRWz6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 18:55:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:58370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231976AbhHRWz5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Aug 2021 18:55:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B850D6108D;
        Wed, 18 Aug 2021 22:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629327321;
        bh=kInF5ENEadqKHvt3hFupGKGCF0+d2v80gLsHGHRYfOg=;
        h=Date:From:To:Subject:From;
        b=mYrU3To1jxg2+rFfx8iLpzKUowo1RGg1PzqM71YXSIFK6eixN7AC4ZsGDu/3WlIO5
         JBJbnlBO4O87a1oWEWuqAGxzxmCe7HlIbBv7B/i9XLWDmUSHhrOSYONVM4f2+YFldB
         omEq1f0Adx6+LsZln5cRMkQpT27eXv1+GrJwWp+0=
Date:   Wed, 18 Aug 2021 15:55:21 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org,
        syzbot+67654e51e54455f1c585@syzkaller.appspotmail.com,
        stable@vger.kernel.org, songmuchun@bytedance.com,
        peterx@redhat.com, naoya.horiguchi@linux.dev, mhocko@suse.com,
        axelrasmussen@google.com, almasrymina@google.com,
        mike.kravetz@oracle.com
Subject:  +
 hugetlb-dont-pass-page-cache-pages-to-restore_reserve_on_error.patch added to
 -mm tree
Message-ID: <20210818225521.fDbry%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: hugetlb: don't pass page cache pages to restore_reserve_on_error
has been added to the -mm tree.  Its filename is
     hugetlb-dont-pass-page-cache-pages-to-restore_reserve_on_error.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlb-dont-pass-page-cache-pages-to-restore_reserve_on_error.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-dont-pass-page-cache-pages-to-restore_reserve_on_error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

hugetlb-dont-pass-page-cache-pages-to-restore_reserve_on_error.patch
hugetlb-simplify-prep_compound_gigantic_page-ref-count-racing-code.patch
hugetlb-drop-ref-count-earlier-after-page-allocation.patch
hugetlb-before-freeing-hugetlb-page-set-dtor-to-appropriate-value.patch

