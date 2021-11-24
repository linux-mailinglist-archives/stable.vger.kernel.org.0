Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB66A45B7A4
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 10:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237290AbhKXJqj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 04:46:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237340AbhKXJqh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 04:46:37 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51E0AC061714
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 01:43:28 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id u80so2088033pfc.9
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 01:43:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9j74+svXlAhYzIbtiOUuOMeegqkYiFJlWDyGAbHKBPI=;
        b=2oZLMiNp+HiAvA+dAovJcOVGymnGUk7R0O2Iz/T/nluwu0aHXSWroQtxIo18l11UWb
         pcXa4UlmdZBtN0PS2DREcGPNHEyN/uLeXkXyRkDAXHaZ/31UnsrpwguAZwbEuUpyb9hO
         zJPyZ0E8hEHRtdSGOiJP2AaOcxdMZn+CB06Xie6QaoqBL73RkpRUpEg5pw3DJ7q9fnVk
         6gy1/OTCoVrhdO98gUNHgN95uWbcSXNKtAY7KpGOYOIYB+kajLDbEIJ4IUxVQ0QB+n7J
         2Z7lu6IGZr+rG+nxU483tA1wPAjMFI2K7ADdsYQO4nouH03RUTOm5Ko3FAh2ud+i0ZOi
         3/Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9j74+svXlAhYzIbtiOUuOMeegqkYiFJlWDyGAbHKBPI=;
        b=vgS0yMJWx+oG3ZhNj7DhYf/KmsL8esIAju5R8wG4vCFhpb+26KtDRVuXQy5YWN6Jc4
         N2E7fkmlySpfBsOuo0YUGJy5C5Aw4peEYb3MZrM/uqc8FaHnr7Dgygc5QXuazL3wtZfp
         Z0pxRjpOVfjIhV5PyViie/8JsBVVRaMBieBlHHK1ttsxr+bfvvVqXug8Mlk9OTeCorkD
         k5cjEtXTSJKzOVS5ECzOewjc0S59i2C/y8BriGuA36W28uTBnE+cUv5CwmSw9Gu8KPGR
         +kB5VSRHv5J8xYwL+2yILMrW8BXnUY194IuRoBwRmMBUWzRZBMeB3b0GFxl1hS3E/ZxC
         NlRw==
X-Gm-Message-State: AOAM533/8Yo4PnEiHryjTtF7x0MMGxmYMnUCGUveVSifGkRU5rVBcotr
        jL1sMPPMipVn8PLP7qfgAfhwI0x/EmrpJA/I
X-Google-Smtp-Source: ABdhPJw/5BatWlVVq8CJs2SBSQkHdwVorJfVnIElodhICjb3mJCYV1CdWP1MLuha9y61FQVz0D470Q==
X-Received: by 2002:a65:654f:: with SMTP id a15mr9301517pgw.195.1637747007854;
        Wed, 24 Nov 2021 01:43:27 -0800 (PST)
Received: from C02FT5A6MD6R.bytedance.net ([61.120.150.76])
        by smtp.gmail.com with ESMTPSA id p188sm15402195pfg.102.2021.11.24.01.43.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Nov 2021 01:43:25 -0800 (PST)
From:   Gang Li <ligang.bdlg@bytedance.com>
To:     Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc:     stable@vger.kernel.org, songmuchun@bytedance.com,
        Gang Li <ligang.bdlg@bytedance.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3] shmem: fix a race between shmem_unused_huge_shrink and shmem_evict_inode
Date:   Wed, 24 Nov 2021 17:43:16 +0800
Message-Id: <20211124094317.69719-1-ligang.bdlg@bytedance.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch fixes a data race in commit 779750d20b93 ("shmem: split huge pages
beyond i_size under memory pressure").

Here are call traces:

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

The simultaneous deletion of adjacent elements in the local list (@list)
by shmem_unused_huge_shrink and shmem_evict_inode will break the list.

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

Fix:

We should make sure the item is either on the global list or deleted from
any local list before iput().

Fixed by moving inodes that are on @list and will not be deleted back to
global list before iput.

Fixes: 779750d20b93 ("shmem: split huge pages beyond i_size under memory pressure")
Signed-off-by: Gang Li <ligang.bdlg@bytedance.com>

---

Changes in v3:
- Add more comment.
- Use list_move(&info->shrinklist, &sbinfo->shrinklist) instead of 
  list_move(pos, &sbinfo->shrinklist) for consistency.

Changes in v2: https://lore.kernel.org/all/20211124030840.88455-1-ligang.bdlg@bytedance.com/
- Move spinlock to the front of iput instead of changing lock type
  since iput will call evict which may cause deadlock by requesting
  shrinklist_lock.
- Add call trace in commit message.

v1: https://lore.kernel.org/lkml/20211122064126.76734-1-ligang.bdlg@bytedance.com/

---
 mm/shmem.c | 35 ++++++++++++++++++++---------------
 1 file changed, 20 insertions(+), 15 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 9023103ee7d8..ab2df692bd58 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -569,7 +569,6 @@ static unsigned long shmem_unused_huge_shrink(struct shmem_sb_info *sbinfo,
 		/* inode is about to be evicted */
 		if (!inode) {
 			list_del_init(&info->shrinklist);
-			removed++;
 			goto next;
 		}
 
@@ -577,15 +576,16 @@ static unsigned long shmem_unused_huge_shrink(struct shmem_sb_info *sbinfo,
 		if (round_up(inode->i_size, PAGE_SIZE) ==
 				round_up(inode->i_size, HPAGE_PMD_SIZE)) {
 			list_move(&info->shrinklist, &to_remove);
-			removed++;
 			goto next;
 		}
 
 		list_move(&info->shrinklist, &list);
 next:
+		removed++;
 		if (!--batch)
 			break;
 	}
+	sbinfo->shrinklist_len -= removed;
 	spin_unlock(&sbinfo->shrinklist_lock);
 
 	list_for_each_safe(pos, next, &to_remove) {
@@ -602,7 +602,7 @@ static unsigned long shmem_unused_huge_shrink(struct shmem_sb_info *sbinfo,
 		inode = &info->vfs_inode;
 
 		if (nr_to_split && split >= nr_to_split)
-			goto leave;
+			goto move_back;
 
 		page = find_get_page(inode->i_mapping,
 				(inode->i_size & HPAGE_PMD_MASK) >> PAGE_SHIFT);
@@ -616,38 +616,43 @@ static unsigned long shmem_unused_huge_shrink(struct shmem_sb_info *sbinfo,
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
+		/* inodes that are on @list and will not be deleted must be moved back to
+		 * global list before iput for two reasons:
+		 * 1. iput in lock: iput call shmem_evict_inode, then cause deadlock.
+		 * 2. iput before lock: shmem_evict_inode may grab the inode on @list,
+		 *    which will cause race.
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
 
-- 
2.20.1

