Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE3E745D4F2
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 07:48:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349304AbhKYGv2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 01:51:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346473AbhKYGt1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 01:49:27 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3CBAC06173E
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 22:46:16 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id j5-20020a17090a318500b001a6c749e697so5685933pjb.1
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 22:46:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AJKeYDChQLO4ew6FjZ6Y8Jm0rawpzT+mEb6zq+ylthQ=;
        b=OIJaXwOyYjpHI1G9DWSPynQ3Wdu8P1n50oK6pqqXtnBW2cVj+LLSV8VwhYefEO1SAY
         zrj9hgsv9jw7UlluOzPEu7+lVMz8wY8koTifDwOT+T3QHSFR9DPnaGO1xaCtf5w0Dg00
         TSG99VmpJuAtUb4dc6viHVwBfOanRme39VVz8BBmW7joKZ+Z2CX/Q0M3zbcvvj7Et3Vz
         rZJNfbrXVxyOPLBug+WdLoOCpEqA3hIoXxe+lNCMZfO8xBP7DO9wrYj22LPHFhbxDgUM
         To993p4Ma5Llc13o4FQLjYRK/DtfqhfhW+C6nHT1ybduI1/wRJU0/jhqPfpDL/+zQ0Se
         nmlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AJKeYDChQLO4ew6FjZ6Y8Jm0rawpzT+mEb6zq+ylthQ=;
        b=o6GIUvKqCJmj+poI6n95h7ky6aNATUkx/IH+3y5EOlcHjHy5gI8JH30OkUyhw3o3qy
         Piv1G4xd5SDuhm/FdeTW7/glmCIxuIpbzsjalc1655NrvFmC3N2LuYS/MAspy75jA3AH
         R3BBma+zU+OTcRTQ0Qfq9gjzE5NZVxbVoc5/Wu8WLTvRttRgtYwvuDE1zahbV3n96Gjn
         ist8hhYcZnKQq7A0OQeHBdMZF4hg7xQWtOoNLOXJKsmMvrblRYhQTXWQvaB84AqtmJWU
         tc3VivjJnB5SylLU+Q+cgaNZgJAv/ytKvN29wKPm7SoebPkmt+bFuOA0E6L8y0Yd2RuG
         5CGA==
X-Gm-Message-State: AOAM531/7CLBiObSbSWga1fsEfSJihQ5iD4dIJHoPTbwKa8ikf0n5x6F
        72sWQTdrqXunJ//qWSh7YbsOmFd0Pq2pGUpU
X-Google-Smtp-Source: ABdhPJwSiyVd0tMvU745BGU1v1Zfqqhru6Spx8LM0JTu1aWBPBkd1HNKcqGMPKfBIRAsFKd3azMakg==
X-Received: by 2002:a17:902:ea10:b0:142:112d:c0b9 with SMTP id s16-20020a170902ea1000b00142112dc0b9mr26227788plg.35.1637822776457;
        Wed, 24 Nov 2021 22:46:16 -0800 (PST)
Received: from C02FT5A6MD6R.bytedance.net ([61.120.150.76])
        by smtp.gmail.com with ESMTPSA id j17sm2082294pfj.55.2021.11.24.22.46.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Nov 2021 22:46:15 -0800 (PST)
From:   Gang Li <ligang.bdlg@bytedance.com>
To:     Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc:     Gang Li <ligang.bdlg@bytedance.com>, stable@vger.kernel.org,
        Muchun Song <songmuchun@bytedance.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5] shmem: fix a race between shmem_unused_huge_shrink and shmem_evict_inode
Date:   Thu, 25 Nov 2021 14:45:00 +0800
Message-Id: <20211125064502.99983-1-ligang.bdlg@bytedance.com>
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
Cc: stable@vger.kernel.org # v4.8+
Signed-off-by: Gang Li <ligang.bdlg@bytedance.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

---

Changes in v5:
- Fix a compile warning

Changes in v4:
- Rework the comments

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
 mm/shmem.c | 36 ++++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 16 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 9023103ee7d8..a6487fe0583f 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -554,7 +554,7 @@ static unsigned long shmem_unused_huge_shrink(struct shmem_sb_info *sbinfo,
 	struct shmem_inode_info *info;
 	struct page *page;
 	unsigned long batch = sc ? sc->nr_to_scan : 128;
-	int removed = 0, split = 0;
+	int split = 0;
 
 	if (list_empty(&sbinfo->shrinklist))
 		return SHRINK_STOP;
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

