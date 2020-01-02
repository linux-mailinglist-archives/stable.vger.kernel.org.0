Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDD1E12EC0B
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:15:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727947AbgABWOm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:14:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:55022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727146AbgABWOl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:14:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1D6822314;
        Thu,  2 Jan 2020 22:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003280;
        bh=OKseluqIOLKPXGDIT2P+FxfP6IiKBsOcbvgBxl8Gx8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SNvFI7rf62rlz2v546VCo1u+4W2f9qGekUuBio0zkZ7WhEzmA60BLPS/lrTr4BvK5
         6vpNjEsSeEo3/NyAvRb/HPOaDLNNw2PgSo3Bua8p/fAVTed88PVA8DIHyCZc4KTSBY
         z8+LOiOvKnGOwBB/WwjEin3Al+QRv4tnU04fDR3s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Sahitya Tummala <stummala@codeaurora.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 095/191] f2fs: Fix deadlock in f2fs_gc() context during atomic files handling
Date:   Thu,  2 Jan 2020 23:06:17 +0100
Message-Id: <20200102215840.097249623@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index f078cd20dab8..9046432b87c2 100644
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
index 29bc0a542759..8ed8e4328bd1 100644
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
index 808709581481..7d8578401267 100644
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



