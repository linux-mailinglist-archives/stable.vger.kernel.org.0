Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D40F45D397
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 04:24:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232591AbhKYD1b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 22:27:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234549AbhKYDZb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 22:25:31 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2AD0C0619D9
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 19:12:54 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id c4so4547661pfj.2
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 19:12:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=glg1j47E6Aumck1TvU69ObionOgNID+ISN0rKvu33AA=;
        b=yn2UNbxlYFY2bGnEcm0Uitdr39Sk/YbEfknDVPLdKL15PNdiHKWj+rAcIrHIr47CbU
         j3K4EakXwUpgxzau9nnhiOWabJ7xYZtJh9P1k+iE1nreuTjM5cWD9piyc8sEOsvIMcwG
         uKRIx1qT4FHE6YeUJraue0Wu+zZUMTMRpAmA+aASFZ8asatw8s7nltStdPAaGZwNeeFO
         ETCqGVHsxsrJmpAKSyVnDkfw14n7MjEo3vr0aYJGnyd8AvyxGISpxbg8D/aAUES+y1wm
         Y7oRrBR2NVhCAescMY0ZOIl4a7QvNm74hN1lziUgU9cH3K1rlqPDb5CjUwp4MGMnKJ23
         E7IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=glg1j47E6Aumck1TvU69ObionOgNID+ISN0rKvu33AA=;
        b=Rf0+YzypM0SiKDCoECIyEwTVlG7RKqW/6Yxs+IAa0FvTyq5h7jZrZWvwgdcXrnjjwM
         b779TOJGAxI6wToylAkZSueam4EcvUDgRto5OtWp28Va7gr43NU8PdrIpX6r325Pty8A
         gu/zMP29B46Nx1T7iFUPtU0URHSIwqH7UFOoOvBHFYTgT4KrW2xML5jTxZ1nloKm6dvu
         zBum7GblmFoRFzTNYmOlTio23A+WVoaveQYZhoF9IeKmB25N2x4isLZQpbRPDWPRVqSG
         ydRbp48HBDTNHOT3/tM6nPlnf3FM/TR0q5DifCBqYtswd4Xa/b+miON9U6jzMsF8XH1l
         fhtg==
X-Gm-Message-State: AOAM530iG22y4c1NTXDKJ/1IoNUlMokhrJPq9gkowwcId9pKWRpMN5SF
        Dnyzad2jq2gETHmoRPzZXy7JWA==
X-Google-Smtp-Source: ABdhPJwsDUQx2tG9dyc5T5xwcOQ8UU5feP0PsguUtZmWM6A25NY8Er/dsWohJHQqW0f+aMQUhvJooQ==
X-Received: by 2002:a63:1a4e:: with SMTP id a14mr13854390pgm.273.1637809974247;
        Wed, 24 Nov 2021 19:12:54 -0800 (PST)
Received: from C02FT5A6MD6R.bytedance.net ([61.120.150.76])
        by smtp.gmail.com with ESMTPSA id k2sm1238755pfc.9.2021.11.24.19.12.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Nov 2021 19:12:53 -0800 (PST)
From:   Gang Li <ligang.bdlg@bytedance.com>
To:     Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc:     stable@vger.kernel.org, songmuchun@bytedance.com,
        Gang Li <ligang.bdlg@bytedance.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4] shmem: fix a race between shmem_unused_huge_shrink and shmem_evict_inode
Date:   Thu, 25 Nov 2021 11:12:43 +0800
Message-Id: <20211125031244.89848-1-ligang.bdlg@bytedance.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch fixes a data race in commit 779750d20b93 ("shmem: split huge pages
beyond i_size under memory pressure").

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

Image there are 3 items in the local list (@list).
In the first traversal, A is not deleted from @list.

  1)    A->B->C
        ^
        |
        pos (leave)

In the second traversal, B is deleted from @list. Concurrently, A is
deleted from @list through shmem_evict_inode() since last reference counter of
inode is dropped by other thread. Then the @list is corrupted.

  2)    A->B->C
        ^  ^
        |  |
     evict pos (drop)

We should make sure the inode is either on the global list or deleted from
any local list before iput().

Fixed by moving inodes back to global list before we put them.

Fixes: 779750d20b93 ("shmem: split huge pages beyond i_size under memory pressure")
Signed-off-by: Gang Li <ligang.bdlg@bytedance.com>
---
 mm/shmem.c | 34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 9023103ee7d8..e6ccb2a076ff 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -569,7 +569,6 @@ static unsigned long shmem_unused_huge_shrink(struct shmem_sb_info *sbinfo,
 		/* inode is about to be evicted */
 		if (!inode) {
 			list_del_init(&info->shrinklist);
-			removed++;
 			goto next;
 		}
 
@@ -577,12 +576,12 @@ static unsigned long shmem_unused_huge_shrink(struct shmem_sb_info *sbinfo,
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
@@ -602,7 +601,7 @@ static unsigned long shmem_unused_huge_shrink(struct shmem_sb_info *sbinfo,
 		inode = &info->vfs_inode;
 
 		if (nr_to_split && split >= nr_to_split)
-			goto leave;
+			goto move_back;
 
 		page = find_get_page(inode->i_mapping,
 				(inode->i_size & HPAGE_PMD_MASK) >> PAGE_SHIFT);
@@ -616,38 +615,43 @@ static unsigned long shmem_unused_huge_shrink(struct shmem_sb_info *sbinfo,
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
 
-- 
2.20.1

