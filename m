Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4244611B65A
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:00:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731482AbfLKPNl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:13:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:37538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731473AbfLKPNk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:13:40 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCECD24671;
        Wed, 11 Dec 2019 15:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077219;
        bh=xZEIST2/HgaO23PjJOPNxsu/fBMAas1f2zAOn7G+6DI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=177v0ndSHPD3bhqUv0cl5y7e8rPw81zSssIaV4TeDrJ30badgNbLG9AAmyYupqsf6
         8Uq0EJjssbm1jonWq3bhQC8t/bscK3zGyXTGF5c7QbMruS5KD4vAZmIy5Qv9NSXIGd
         5+0Om9kTdVAgIz6KxQWdZt6NKeRJ4H3OePK53IwE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sahitya Tummala <stummala@codeaurora.org>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.4 099/134] f2fs: Fix deadlock in f2fs_gc() context during atomic files handling
Date:   Wed, 11 Dec 2019 10:11:15 -0500
Message-Id: <20191211151150.19073-99-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211151150.19073-1-sashal@kernel.org>
References: <20191211151150.19073-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sahitya Tummala <stummala@codeaurora.org>

[ Upstream commit 677017d196ba2a4cfff13626b951cc9a206b8c7c ]

The FS got stuck in the below stack when the storage is almost
full/dirty condition (when FG_GC is being done).

schedule_timeout
io_schedule_timeout
congestion_wait
f2fs_drop_inmem_pages_all
f2fs_gc
f2fs_balance_fs
__write_node_page
f2fs_fsync_node_pages
f2fs_do_sync_file
f2fs_ioctl

The root cause for this issue is there is a potential infinite loop
in f2fs_drop_inmem_pages_all() for the case where gc_failure is true
and when there an inode whose i_gc_failures[GC_FAILURE_ATOMIC] is
not set. Fix this by keeping track of the total atomic files
currently opened and using that to exit from this condition.

Fix-suggested-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Sahitya Tummala <stummala@codeaurora.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/f2fs.h    |  1 +
 fs/f2fs/file.c    |  1 +
 fs/f2fs/segment.c | 21 +++++++++++++++------
 3 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index f078cd20dab88..9046432b87c2d 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1289,6 +1289,7 @@ struct f2fs_sb_info {
 	unsigned int gc_mode;			/* current GC state */
 	unsigned int next_victim_seg[2];	/* next segment in victim section */
 	/* for skip statistic */
+	unsigned int atomic_files;              /* # of opened atomic file */
 	unsigned long long skipped_atomic_files[2];	/* FG_GC and BG_GC */
 	unsigned long long skipped_gc_rwsem;		/* FG_GC only */
 
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 29bc0a542759a..8ed8e4328bd1a 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1890,6 +1890,7 @@ static int f2fs_ioc_start_atomic_write(struct file *filp)
 	spin_lock(&sbi->inode_lock[ATOMIC_FILE]);
 	if (list_empty(&fi->inmem_ilist))
 		list_add_tail(&fi->inmem_ilist, &sbi->inode_list[ATOMIC_FILE]);
+	sbi->atomic_files++;
 	spin_unlock(&sbi->inode_lock[ATOMIC_FILE]);
 
 	/* add inode in inmem_list first and set atomic_file */
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 8087095814819..7d85784012678 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -288,6 +288,8 @@ void f2fs_drop_inmem_pages_all(struct f2fs_sb_info *sbi, bool gc_failure)
 	struct list_head *head = &sbi->inode_list[ATOMIC_FILE];
 	struct inode *inode;
 	struct f2fs_inode_info *fi;
+	unsigned int count = sbi->atomic_files;
+	unsigned int looped = 0;
 next:
 	spin_lock(&sbi->inode_lock[ATOMIC_FILE]);
 	if (list_empty(head)) {
@@ -296,22 +298,26 @@ next:
 	}
 	fi = list_first_entry(head, struct f2fs_inode_info, inmem_ilist);
 	inode = igrab(&fi->vfs_inode);
+	if (inode)
+		list_move_tail(&fi->inmem_ilist, head);
 	spin_unlock(&sbi->inode_lock[ATOMIC_FILE]);
 
 	if (inode) {
 		if (gc_failure) {
-			if (fi->i_gc_failures[GC_FAILURE_ATOMIC])
-				goto drop;
-			goto skip;
+			if (!fi->i_gc_failures[GC_FAILURE_ATOMIC])
+				goto skip;
 		}
-drop:
 		set_inode_flag(inode, FI_ATOMIC_REVOKE_REQUEST);
 		f2fs_drop_inmem_pages(inode);
+skip:
 		iput(inode);
 	}
-skip:
 	congestion_wait(BLK_RW_ASYNC, HZ/50);
 	cond_resched();
+	if (gc_failure) {
+		if (++looped >= count)
+			return;
+	}
 	goto next;
 }
 
@@ -327,13 +333,16 @@ void f2fs_drop_inmem_pages(struct inode *inode)
 		mutex_unlock(&fi->inmem_lock);
 	}
 
-	clear_inode_flag(inode, FI_ATOMIC_FILE);
 	fi->i_gc_failures[GC_FAILURE_ATOMIC] = 0;
 	stat_dec_atomic_write(inode);
 
 	spin_lock(&sbi->inode_lock[ATOMIC_FILE]);
 	if (!list_empty(&fi->inmem_ilist))
 		list_del_init(&fi->inmem_ilist);
+	if (f2fs_is_atomic_file(inode)) {
+		clear_inode_flag(inode, FI_ATOMIC_FILE);
+		sbi->atomic_files--;
+	}
 	spin_unlock(&sbi->inode_lock[ATOMIC_FILE]);
 }
 
-- 
2.20.1

