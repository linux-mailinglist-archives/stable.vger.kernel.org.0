Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FFB848F23B
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 23:05:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbiANWF0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 17:05:26 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58348 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbiANWF0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 17:05:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C028B8260F;
        Fri, 14 Jan 2022 22:05:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB18FC36AE5;
        Fri, 14 Jan 2022 22:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642197924;
        bh=UW1gO00Rf3OgyA+/XNaq+nZ6muF292ZuljiSVTpw6sI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=j4JpGheqJ0ItsRvu1N1noyOETc4mCX/sQ0pijsmUYER1Zj6Nrp+Kzqk4XHVYxFJ7X
         SM1w71sQutykBkH68eyllbfSV0UNflDB2RRh8Dc68hMB852cbTYURIklYIo3exLgm0
         7qRQle4nJftTxk+6r9SFTjT1/FwdvRKihR3cJcRQ=
Date:   Fri, 14 Jan 2022 14:05:23 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hughd@google.com,
        kirill.shutemov@linux.intel.com, ligang.bdlg@bytedance.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        songmuchun@bytedance.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 046/146] shmem: fix a race between
 shmem_unused_huge_shrink and shmem_evict_inode
Message-ID: <20220114220523.T4gcXYcCD%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gang Li <ligang.bdlg@bytedance.com>
Subject: shmem: fix a race between shmem_unused_huge_shrink and shmem_evict_inode

Fix a data race in commit 779750d20b93 ("shmem: split huge pages beyond
i_size under memory pressure").

Here are call traces causing race:

   Call Trace 1:
     shmem_unused_huge_shrink+0x3ae/0x410
     ? __list_lru_walk_one.isra.5+0x33/0x160
     super_cache_scan+0x17c/0x190
     shrink_slab.part.55+0x1ef/0x3f0
     shrink_node+0x10e/0x330
     kswapd+0x380/0x740
     kthread+0xfc/0x130
     ? mem_cgroup_shrink_node+0x170/0x170
     ? kthread_create_on_node+0x70/0x70
     ret_from_fork+0x1f/0x30

   Call Trace 2:
     shmem_evict_inode+0xd8/0x190
     evict+0xbe/0x1c0
     do_unlinkat+0x137/0x330
     do_syscall_64+0x76/0x120
     entry_SYSCALL_64_after_hwframe+0x3d/0xa2

A simple explanation:

Image there are 3 items in the local list (@list).  In the first
traversal, A is not deleted from @list.

  1)    A->B->C
        ^
        |
        pos (leave)

In the second traversal, B is deleted from @list.  Concurrently, A is
deleted from @list through shmem_evict_inode() since last reference
counter of inode is dropped by other thread.  Then the @list is corrupted.

  2)    A->B->C
        ^  ^
        |  |
     evict pos (drop)

We should make sure the inode is either on the global list or deleted from
any local list before iput().

Fixed by moving inodes back to global list before we put them.

[akpm@linux-foundation.org: coding style fixes]
Link: https://lkml.kernel.org/r/20211125064502.99983-1-ligang.bdlg@bytedance.com
Fixes: 779750d20b93 ("shmem: split huge pages beyond i_size under memory pressure")
Signed-off-by: Gang Li <ligang.bdlg@bytedance.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   37 +++++++++++++++++++++----------------
 1 file changed, 21 insertions(+), 16 deletions(-)

--- a/mm/shmem.c~shmem-fix-a-race-between-shmem_unused_huge_shrink-and-shmem_evict_inode
+++ a/mm/shmem.c
@@ -554,7 +554,7 @@ static unsigned long shmem_unused_huge_s
 	struct shmem_inode_info *info;
 	struct page *page;
 	unsigned long batch = sc ? sc->nr_to_scan : 128;
-	int removed = 0, split = 0;
+	int split = 0;
 
 	if (list_empty(&sbinfo->shrinklist))
 		return SHRINK_STOP;
@@ -569,7 +569,6 @@ static unsigned long shmem_unused_huge_s
 		/* inode is about to be evicted */
 		if (!inode) {
 			list_del_init(&info->shrinklist);
-			removed++;
 			goto next;
 		}
 
@@ -577,12 +576,12 @@ static unsigned long shmem_unused_huge_s
 		if (round_up(inode->i_size, PAGE_SIZE) ==
 				round_up(inode->i_size, HPAGE_PMD_SIZE)) {
 			list_move(&info->shrinklist, &to_remove);
-			removed++;
 			goto next;
 		}
 
 		list_move(&info->shrinklist, &list);
 next:
+		sbinfo->shrinklist_len--;
 		if (!--batch)
 			break;
 	}
@@ -602,7 +601,7 @@ next:
 		inode = &info->vfs_inode;
 
 		if (nr_to_split && split >= nr_to_split)
-			goto leave;
+			goto move_back;
 
 		page = find_get_page(inode->i_mapping,
 				(inode->i_size & HPAGE_PMD_MASK) >> PAGE_SHIFT);
@@ -616,38 +615,44 @@ next:
 		}
 
 		/*
-		 * Leave the inode on the list if we failed to lock
-		 * the page at this time.
+		 * Move the inode on the list back to shrinklist if we failed
+		 * to lock the page at this time.
 		 *
 		 * Waiting for the lock may lead to deadlock in the
 		 * reclaim path.
 		 */
 		if (!trylock_page(page)) {
 			put_page(page);
-			goto leave;
+			goto move_back;
 		}
 
 		ret = split_huge_page(page);
 		unlock_page(page);
 		put_page(page);
 
-		/* If split failed leave the inode on the list */
+		/* If split failed move the inode on the list back to shrinklist */
 		if (ret)
-			goto leave;
+			goto move_back;
 
 		split++;
 drop:
 		list_del_init(&info->shrinklist);
-		removed++;
-leave:
+		goto put;
+move_back:
+		/*
+		 * Make sure the inode is either on the global list or deleted
+		 * from any local list before iput() since it could be deleted
+		 * in another thread once we put the inode (then the local list
+		 * is corrupted).
+		 */
+		spin_lock(&sbinfo->shrinklist_lock);
+		list_move(&info->shrinklist, &sbinfo->shrinklist);
+		sbinfo->shrinklist_len++;
+		spin_unlock(&sbinfo->shrinklist_lock);
+put:
 		iput(inode);
 	}
 
-	spin_lock(&sbinfo->shrinklist_lock);
-	list_splice_tail(&list, &sbinfo->shrinklist);
-	sbinfo->shrinklist_len -= removed;
-	spin_unlock(&sbinfo->shrinklist_lock);
-
 	return split;
 }
 
_
