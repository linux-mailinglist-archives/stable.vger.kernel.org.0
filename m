Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 693E1259CBC
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 19:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728901AbgIAPNc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:13:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:56454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727924AbgIAPNZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:13:25 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44742206FA;
        Tue,  1 Sep 2020 15:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973204;
        bh=belXu7omzPeApGlTS4KaxbtVsiHLafu16x2QecE00Ro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e2GVXeen82ARYLxXDRsBsnXcJoo+fm7IUNljWee8TdfftHppLsCXveck1IFC3Oja5
         5sDrZX4YMutXPGXFOcEb2nf1yApYSgWS61PLjFbgLleRQRxOYYyxUhST5BgGv9B4TD
         jUkowV7iIsoGQB9F9FHmzN+M/hwuf2LzcWn7znEg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martijn Coenen <maco@android.com>,
        Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>
Subject: [PATCH 4.4 48/62] writeback: Avoid skipping inode writeback
Date:   Tue,  1 Sep 2020 17:10:31 +0200
Message-Id: <20200901150923.145317853@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150920.697676718@linuxfoundation.org>
References: <20200901150920.697676718@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit 5afced3bf28100d81fb2fe7e98918632a08feaf5 upstream.

Inode's i_io_list list head is used to attach inode to several different
lists - wb->{b_dirty, b_dirty_time, b_io, b_more_io}. When flush worker
prepares a list of inodes to writeback e.g. for sync(2), it moves inodes
to b_io list. Thus it is critical for sync(2) data integrity guarantees
that inode is not requeued to any other writeback list when inode is
queued for processing by flush worker. That's the reason why
writeback_single_inode() does not touch i_io_list (unless the inode is
completely clean) and why __mark_inode_dirty() does not touch i_io_list
if I_SYNC flag is set.

However there are two flaws in the current logic:

1) When inode has only I_DIRTY_TIME set but it is already queued in b_io
list due to sync(2), concurrent __mark_inode_dirty(inode, I_DIRTY_SYNC)
can still move inode back to b_dirty list resulting in skipping
writeback of inode time stamps during sync(2).

2) When inode is on b_dirty_time list and writeback_single_inode() races
with __mark_inode_dirty() like:

writeback_single_inode()		__mark_inode_dirty(inode, I_DIRTY_PAGES)
  inode->i_state |= I_SYNC
  __writeback_single_inode()
					  inode->i_state |= I_DIRTY_PAGES;
					  if (inode->i_state & I_SYNC)
					    bail
  if (!(inode->i_state & I_DIRTY_ALL))
  - not true so nothing done

We end up with I_DIRTY_PAGES inode on b_dirty_time list and thus
standard background writeback will not writeback this inode leading to
possible dirty throttling stalls etc. (thanks to Martijn Coenen for this
analysis).

Fix these problems by tracking whether inode is queued in b_io or
b_more_io lists in a new I_SYNC_QUEUED flag. When this flag is set, we
know flush worker has queued inode and we should not touch i_io_list.
On the other hand we also know that once flush worker is done with the
inode it will requeue the inode to appropriate dirty list. When
I_SYNC_QUEUED is not set, __mark_inode_dirty() can (and must) move inode
to appropriate dirty list.

Reported-by: Martijn Coenen <maco@android.com>
Reviewed-by: Martijn Coenen <maco@android.com>
Tested-by: Martijn Coenen <maco@android.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Fixes: 0ae45f63d4ef ("vfs: add support for a lazytime mount option")
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/fs-writeback.c  |   17 ++++++++++++-----
 include/linux/fs.h |    8 ++++++--
 2 files changed, 18 insertions(+), 7 deletions(-)

--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -162,6 +162,7 @@ static void inode_io_list_del_locked(str
 	assert_spin_locked(&wb->list_lock);
 	assert_spin_locked(&inode->i_lock);
 
+	inode->i_state &= ~I_SYNC_QUEUED;
 	list_del_init(&inode->i_io_list);
 	wb_io_lists_depopulated(wb);
 }
@@ -1062,6 +1063,7 @@ static void redirty_tail_locked(struct i
 			inode->dirtied_when = jiffies;
 	}
 	inode_io_list_move_locked(inode, wb, &wb->b_dirty);
+	inode->i_state &= ~I_SYNC_QUEUED;
 }
 
 static void redirty_tail(struct inode *inode, struct bdi_writeback *wb)
@@ -1137,8 +1139,11 @@ static int move_expired_inodes(struct li
 			break;
 		list_move(&inode->i_io_list, &tmp);
 		moved++;
+		spin_lock(&inode->i_lock);
 		if (flags & EXPIRE_DIRTY_ATIME)
-			set_bit(__I_DIRTY_TIME_EXPIRED, &inode->i_state);
+			inode->i_state |= I_DIRTY_TIME_EXPIRED;
+		inode->i_state |= I_SYNC_QUEUED;
+		spin_unlock(&inode->i_lock);
 		if (sb_is_blkdev_sb(inode->i_sb))
 			continue;
 		if (sb && sb != inode->i_sb)
@@ -1313,6 +1318,7 @@ static void requeue_inode(struct inode *
 	} else if (inode->i_state & I_DIRTY_TIME) {
 		inode->dirtied_when = jiffies;
 		inode_io_list_move_locked(inode, wb, &wb->b_dirty_time);
+		inode->i_state &= ~I_SYNC_QUEUED;
 	} else {
 		/* The inode is clean. Remove from writeback lists. */
 		inode_io_list_del_locked(inode, wb);
@@ -2140,11 +2146,12 @@ void __mark_inode_dirty(struct inode *in
 		inode->i_state |= flags;
 
 		/*
-		 * If the inode is being synced, just update its dirty state.
-		 * The unlocker will place the inode on the appropriate
-		 * superblock list, based upon its state.
+		 * If the inode is queued for writeback by flush worker, just
+		 * update its dirty state. Once the flush worker is done with
+		 * the inode it will place it on the appropriate superblock
+		 * list, based upon its state.
 		 */
-		if (inode->i_state & I_SYNC)
+		if (inode->i_state & I_SYNC_QUEUED)
 			goto out_unlock_inode;
 
 		/*
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1882,6 +1882,10 @@ struct super_operations {
  *			wb stat updates to grab mapping->tree_lock.  See
  *			inode_switch_wb_work_fn() for details.
  *
+ * I_SYNC_QUEUED	Inode is queued in b_io or b_more_io writeback lists.
+ *			Used to detect that mark_inode_dirty() should not move
+ * 			inode between dirty lists.
+ *
  * Q: What is the difference between I_WILL_FREE and I_FREEING?
  */
 #define I_DIRTY_SYNC		(1 << 0)
@@ -1899,9 +1903,9 @@ struct super_operations {
 #define I_DIO_WAKEUP		(1 << __I_DIO_WAKEUP)
 #define I_LINKABLE		(1 << 10)
 #define I_DIRTY_TIME		(1 << 11)
-#define __I_DIRTY_TIME_EXPIRED	12
-#define I_DIRTY_TIME_EXPIRED	(1 << __I_DIRTY_TIME_EXPIRED)
+#define I_DIRTY_TIME_EXPIRED	(1 << 12)
 #define I_WB_SWITCH		(1 << 13)
+#define I_SYNC_QUEUED		(1 << 17)
 
 #define I_DIRTY (I_DIRTY_SYNC | I_DIRTY_DATASYNC | I_DIRTY_PAGES)
 #define I_DIRTY_ALL (I_DIRTY | I_DIRTY_TIME)


