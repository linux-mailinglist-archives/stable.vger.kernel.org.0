Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD704602AB
	for <lists+stable@lfdr.de>; Sun, 28 Nov 2021 01:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356758AbhK1Aw2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 27 Nov 2021 19:52:28 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:48490 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356649AbhK1Au1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 27 Nov 2021 19:50:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ADBB060F57;
        Sun, 28 Nov 2021 00:47:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC685C53FBF;
        Sun, 28 Nov 2021 00:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638060432;
        bh=LUnl8QQhQbXXBRhupQm/AK1I4wc8EoiajRpw1etrmIE=;
        h=Date:From:To:Subject:From;
        b=G11rVO3HnLZJpkgEED56W6rnuBZK/C105eG6Eye3/RjSN21V2pHA8G72kPknThawr
         JISfuvQN12jwqYqBMHA3xQCL3eCJ6QL38w5X/4IQs3FKIdoe4lYVnIdqNwTRZBjAa3
         FZKAfjiu/EoXpLl9XW13LU3YWCalzIrGLiJlhnv8=
Date:   Sat, 27 Nov 2021 16:47:11 -0800
From:   akpm@linux-foundation.org
To:     hughd@google.com, kirill.shutemov@linux.intel.com,
        ligang.bdlg@bytedance.com, mm-commits@vger.kernel.org,
        songmuchun@bytedance.com, stable@vger.kernel.org
Subject:  +
 =?US-ASCII?Q?shmem-fix-a-race-between-shmem=5Funused=5Fhuge=5Fshrink-and?=
 =?US-ASCII?Q?-shmem=5Fevict=5Finode.patch?= added to -mm tree
Message-ID: <20211128004711.XiCbmCqY4%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: shmem: fix a race between shmem_unused_huge_shrink and shmem_evict_inode
has been added to the -mm tree.  Its filename is
     shmem-fix-a-race-between-shmem_unused_huge_shrink-and-shmem_evict_inode.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/shmem-fix-a-race-between-shmem_unused_huge_shrink-and-shmem_evict_inode.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/shmem-fix-a-race-between-shmem_unused_huge_shrink-and-shmem_evict_inode.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Link: https://lkml.kernel.org/r/20211125064502.99983-1-ligang.bdlg@bytedance.com
Fixes: 779750d20b93 ("shmem: split huge pages beyond i_size under memory pressure")
Signed-off-by: Gang Li <ligang.bdlg@bytedance.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   36 ++++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 16 deletions(-)

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
@@ -616,38 +615,43 @@ next:
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
+		* Make sure the inode is either on the global list or deleted from
+		* any local list before iput() since it could be deleted in another
+		* thread once we put the inode (then the local list is corrupted).
+		*/
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

Patches currently in -mm which might be from ligang.bdlg@bytedance.com are

shmem-fix-a-race-between-shmem_unused_huge_shrink-and-shmem_evict_inode.patch
vmscan-make-drop_slab_node-static.patch

