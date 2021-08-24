Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 732E43F6481
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238550AbhHXRFK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:05:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:45820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239286AbhHXRCg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:02:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 846F96154B;
        Tue, 24 Aug 2021 16:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824291;
        bh=wYxufF0btmKr0QC+zxXPFiJlU2FoATr8l5pNeV1zW+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cOv+x/1tNy2E3ROuwMgMFdINd6gd/3TUdHflnGH/53lHq87O7amftTdYJKXvPnazg
         pt/y6c/W9eeqDA7PKvQF3H8jFhGZwYEWXrIZGtTPwIzZCQZN+1dGUu1P6JULwji9e2
         Bk9U4xsSs9WHwbpxcOyVedjl6YAdoBcyn8cjpG9aExBXdcjl3URUPOu+U04XpAFwGJ
         d9aS38HUBV6XwyktlKW8zJXx7v7t8qV8oji8Qv5eqJGo2IvxjHKEtgYVV08VYKJXCH
         GYb6Ku36DRBVuBob543L6D9cWCL5PBMd1nvVI9QdykBLLcOYg1qRogGlPFJ8+8effa
         e8ZNWZcBFDXOA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Kravetz <mike.kravetz@oracle.com>,
        syzbot+67654e51e54455f1c585@syzkaller.appspotmail.com,
        Mina Almasry <almasrymina@google.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Peter Xu <peterx@redhat.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Michal Hocko <mhocko@suse.com>,
        Naoya Horiguchi <naoya.horiguchi@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 124/127] hugetlb: don't pass page cache pages to restore_reserve_on_error
Date:   Tue, 24 Aug 2021 12:56:04 -0400
Message-Id: <20210824165607.709387-125-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Kravetz <mike.kravetz@oracle.com>

[ Upstream commit c7b1850dfb41d0b4154aca8dbc04777fbd75616f ]

syzbot hit kernel BUG at fs/hugetlbfs/inode.c:532 as described in [1].
This BUG triggers if the HPageRestoreReserve flag is set on a page in
the page cache.  It should never be set, as the routine
huge_add_to_page_cache explicitly clears the flag after adding a page to
the cache.

The only code other than huge page allocation which sets the flag is
restore_reserve_on_error.  It will potentially set the flag in rare out
of memory conditions.  syzbot was injecting errors to cause memory
allocation errors which exercised this specific path.

The code in restore_reserve_on_error is doing the right thing.  However,
there are instances where pages in the page cache were being passed to
restore_reserve_on_error.  This is incorrect, as once a page goes into
the cache reservation information will not be modified for the page
until it is removed from the cache.  Error paths do not remove pages
from the cache, so even in the case of error, the page will remain in
the cache and no reservation adjustment is needed.

Modify routines that potentially call restore_reserve_on_error with a
page cache page to no longer do so.

Note on fixes tag: Prior to commit 846be08578ed ("mm/hugetlb: expand
restore_reserve_on_error functionality") the routine would not process
page cache pages because the HPageRestoreReserve flag is not set on such
pages.  Therefore, this issue could not be trigggered.  The code added
by commit 846be08578ed ("mm/hugetlb: expand restore_reserve_on_error
functionality") is needed and correct.  It exposed incorrect calls to
restore_reserve_on_error which is the root cause addressed by this
commit.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/hugetlb.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 6e35481a0a6b..6ad419e7e0a4 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2286,7 +2286,7 @@ void restore_reserve_on_error(struct hstate *h, struct vm_area_struct *vma,
 		if (!rc) {
 			/*
 			 * This indicates there is an entry in the reserve map
-			 * added by alloc_huge_page.  We know it was added
+			 * not added by alloc_huge_page.  We know it was added
 			 * before the alloc_huge_page call, otherwise
 			 * HPageRestoreReserve would be set on the page.
 			 * Remove the entry so that a subsequent allocation
@@ -4465,7 +4465,9 @@ retry_avoidcopy:
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
@@ -4581,7 +4583,7 @@ static vm_fault_t hugetlb_no_page(struct mm_struct *mm,
 	pte_t new_pte;
 	spinlock_t *ptl;
 	unsigned long haddr = address & huge_page_mask(h);
-	bool new_page = false;
+	bool new_page, new_pagecache_page = false;
 
 	/*
 	 * Currently, we are forced to kill the process in the event the
@@ -4604,6 +4606,7 @@ static vm_fault_t hugetlb_no_page(struct mm_struct *mm,
 		goto out;
 
 retry:
+	new_page = false;
 	page = find_lock_page(mapping, idx);
 	if (!page) {
 		/* Check for page in userfault range */
@@ -4647,6 +4650,7 @@ retry:
 					goto retry;
 				goto out;
 			}
+			new_pagecache_page = true;
 		} else {
 			lock_page(page);
 			if (unlikely(anon_vma_prepare(vma))) {
@@ -4731,7 +4735,9 @@ backout:
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
@@ -4940,6 +4946,7 @@ int hugetlb_mcopy_atomic_pte(struct mm_struct *dst_mm,
 	int ret;
 	struct page *page;
 	int writable;
+	bool new_pagecache_page = false;
 
 	mapping = dst_vma->vm_file->f_mapping;
 	idx = vma_hugecache_offset(h, dst_vma, dst_addr);
@@ -5004,6 +5011,7 @@ int hugetlb_mcopy_atomic_pte(struct mm_struct *dst_mm,
 		ret = huge_add_to_page_cache(page, mapping, idx);
 		if (ret)
 			goto out_release_nounlock;
+		new_pagecache_page = true;
 	}
 
 	ptl = huge_pte_lockptr(h, dst_mm, dst_pte);
@@ -5067,7 +5075,8 @@ out_release_unlock:
 	if (vm_shared || is_continue)
 		unlock_page(page);
 out_release_nounlock:
-	restore_reserve_on_error(h, dst_vma, dst_addr, page);
+	if (!new_pagecache_page)
+		restore_reserve_on_error(h, dst_vma, dst_addr, page);
 	put_page(page);
 	goto out;
 }
-- 
2.30.2

