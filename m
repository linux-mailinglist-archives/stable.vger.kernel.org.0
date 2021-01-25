Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E039302C37
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 21:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731633AbhAYUGx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 15:06:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:37386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731780AbhAYUGN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 15:06:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CEBA12255F;
        Mon, 25 Jan 2021 20:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611605133;
        bh=BvVJlV+WJ57zIORkloMuA7me5GTDG7cgxFEn6J3c6K0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H7JytCTvKSeQ4Zv/lKx5yN1zzUKeWMaT9DZoZQbG3RZYK9xWLvf8Op3gZ4LAlKpPz
         6R4l8Nk4juUcqdoKemi9YTHKhJDzt2pQSnYZU0Y75MyQVsyX8E2/XSCatHOB8tvYJ8
         r+bHXztmRfOkt8n66clntSZSsUDGQIe6+k9+i34P1awFgP+4Q5/fSd6sv7WdOVrfDW
         seVlRSm0zshsYrebkKz7m5Xh9UJcMjChYILsvzkUXanyNf6vRtXwT4ySf/2LEcSRwG
         0UGaL1uP4ncuMFKHT6Eitc29Ox3rWSjXkAmBexH3xYuTlSJVVMTs8WEOCxYqaNPQsa
         mCN/5RoT23d0g==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4.19 1/2] writeback: Drop I_DIRTY_TIME_EXPIRE
Date:   Mon, 25 Jan 2021 12:05:08 -0800
Message-Id: <20210125200509.261295-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125200509.261295-1-ebiggers@kernel.org>
References: <20210125200509.261295-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit 5fcd57505c002efc5823a7355e21f48dd02d5a51 upstream.

The only use of I_DIRTY_TIME_EXPIRE is to detect in
__writeback_single_inode() that inode got there because flush worker
decided it's time to writeback the dirty inode time stamps (either
because we are syncing or because of age). However we can detect this
directly in __writeback_single_inode() and there's no need for the
strange propagation with I_DIRTY_TIME_EXPIRE flag.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/inode.c                  |  2 +-
 fs/fs-writeback.c                | 28 +++++++++++-----------------
 fs/xfs/xfs_trans_inode.c         |  4 ++--
 include/linux/fs.h               |  1 -
 include/trace/events/writeback.h |  1 -
 5 files changed, 14 insertions(+), 22 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index b2a9c746f8ce4..edeb837081c80 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5209,7 +5209,7 @@ static int other_inode_match(struct inode * inode, unsigned long ino,
 	    (inode->i_state & I_DIRTY_TIME)) {
 		struct ext4_inode_info	*ei = EXT4_I(inode);
 
-		inode->i_state &= ~(I_DIRTY_TIME | I_DIRTY_TIME_EXPIRED);
+		inode->i_state &= ~I_DIRTY_TIME;
 		spin_unlock(&inode->i_lock);
 
 		spin_lock(&ei->i_raw_lock);
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 15216b440880a..96cdce0144efc 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1157,7 +1157,7 @@ static bool inode_dirtied_after(struct inode *inode, unsigned long t)
  */
 static int move_expired_inodes(struct list_head *delaying_queue,
 			       struct list_head *dispatch_queue,
-			       int flags, unsigned long dirtied_before)
+			       unsigned long dirtied_before)
 {
 	LIST_HEAD(tmp);
 	struct list_head *pos, *node;
@@ -1173,8 +1173,6 @@ static int move_expired_inodes(struct list_head *delaying_queue,
 		list_move(&inode->i_io_list, &tmp);
 		moved++;
 		spin_lock(&inode->i_lock);
-		if (flags & EXPIRE_DIRTY_ATIME)
-			inode->i_state |= I_DIRTY_TIME_EXPIRED;
 		inode->i_state |= I_SYNC_QUEUED;
 		spin_unlock(&inode->i_lock);
 		if (sb_is_blkdev_sb(inode->i_sb))
@@ -1222,11 +1220,11 @@ static void queue_io(struct bdi_writeback *wb, struct wb_writeback_work *work,
 
 	assert_spin_locked(&wb->list_lock);
 	list_splice_init(&wb->b_more_io, &wb->b_io);
-	moved = move_expired_inodes(&wb->b_dirty, &wb->b_io, 0, dirtied_before);
+	moved = move_expired_inodes(&wb->b_dirty, &wb->b_io, dirtied_before);
 	if (!work->for_sync)
 		time_expire_jif = jiffies - dirtytime_expire_interval * HZ;
 	moved += move_expired_inodes(&wb->b_dirty_time, &wb->b_io,
-				     EXPIRE_DIRTY_ATIME, time_expire_jif);
+				     time_expire_jif);
 	if (moved)
 		wb_io_lists_populated(wb);
 	trace_writeback_queue_io(wb, work, dirtied_before, moved);
@@ -1402,18 +1400,14 @@ __writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 	spin_lock(&inode->i_lock);
 
 	dirty = inode->i_state & I_DIRTY;
-	if (inode->i_state & I_DIRTY_TIME) {
-		if ((dirty & I_DIRTY_INODE) ||
-		    wbc->sync_mode == WB_SYNC_ALL ||
-		    unlikely(inode->i_state & I_DIRTY_TIME_EXPIRED) ||
-		    unlikely(time_after(jiffies,
-					(inode->dirtied_time_when +
-					 dirtytime_expire_interval * HZ)))) {
-			dirty |= I_DIRTY_TIME | I_DIRTY_TIME_EXPIRED;
-			trace_writeback_lazytime(inode);
-		}
-	} else
-		inode->i_state &= ~I_DIRTY_TIME_EXPIRED;
+	if ((inode->i_state & I_DIRTY_TIME) &&
+	    ((dirty & I_DIRTY_INODE) ||
+	     wbc->sync_mode == WB_SYNC_ALL || wbc->for_sync ||
+	     time_after(jiffies, inode->dirtied_time_when +
+			dirtytime_expire_interval * HZ))) {
+		dirty |= I_DIRTY_TIME;
+		trace_writeback_lazytime(inode);
+	}
 	inode->i_state &= ~dirty;
 
 	/*
diff --git a/fs/xfs/xfs_trans_inode.c b/fs/xfs/xfs_trans_inode.c
index ae453dd236a69..6fcdf7e449fe7 100644
--- a/fs/xfs/xfs_trans_inode.c
+++ b/fs/xfs/xfs_trans_inode.c
@@ -99,9 +99,9 @@ xfs_trans_log_inode(
 	 * to log the timestamps, or will clear already cleared fields in the
 	 * worst case.
 	 */
-	if (inode->i_state & (I_DIRTY_TIME | I_DIRTY_TIME_EXPIRED)) {
+	if (inode->i_state & I_DIRTY_TIME) {
 		spin_lock(&inode->i_lock);
-		inode->i_state &= ~(I_DIRTY_TIME | I_DIRTY_TIME_EXPIRED);
+		inode->i_state &= ~I_DIRTY_TIME;
 		spin_unlock(&inode->i_lock);
 	}
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 876bfb6df06a9..b6a955ba6173a 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2071,7 +2071,6 @@ static inline void init_sync_kiocb(struct kiocb *kiocb, struct file *filp)
 #define I_DIO_WAKEUP		(1 << __I_DIO_WAKEUP)
 #define I_LINKABLE		(1 << 10)
 #define I_DIRTY_TIME		(1 << 11)
-#define I_DIRTY_TIME_EXPIRED	(1 << 12)
 #define I_WB_SWITCH		(1 << 13)
 #define I_OVL_INUSE		(1 << 14)
 #define I_CREATING		(1 << 15)
diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
index 29d09755e5cfc..146e7b3faa856 100644
--- a/include/trace/events/writeback.h
+++ b/include/trace/events/writeback.h
@@ -20,7 +20,6 @@
 		{I_CLEAR,		"I_CLEAR"},		\
 		{I_SYNC,		"I_SYNC"},		\
 		{I_DIRTY_TIME,		"I_DIRTY_TIME"},	\
-		{I_DIRTY_TIME_EXPIRED,	"I_DIRTY_TIME_EXPIRED"}, \
 		{I_REFERENCED,		"I_REFERENCED"}		\
 	)
 
-- 
2.30.0

