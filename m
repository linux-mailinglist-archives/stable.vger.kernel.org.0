Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25FD25492DA
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380362AbiFMOCK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:02:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380388AbiFMOAI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:00:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2F678DDC5;
        Mon, 13 Jun 2022 04:38:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CD06612A8;
        Mon, 13 Jun 2022 11:38:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E2D8C34114;
        Mon, 13 Jun 2022 11:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120281;
        bh=YLhttcZMZGaOIF9jhTmY3/sTXVBFMSJCqpPCbEzUyKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZFWws8Sk4JtYr6poOnB6poq04MMDVLikGkdMjDSjbsZhhTIvNVOtZJCCtrS/mH5nB
         rth6QSgaFesRi/ltjht6yx5CiZEw/IdxafwHo/zZ/YvoFajgdpeObaeRv/rm7LaAc/
         wa5U7Qx6Aj2yyyJ2bBfYshMmO4bkaHMK4qyOJSNg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jchao Sun <sunjunchao2870@gmail.com>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 5.18 316/339] writeback: Fix inode->i_io_list not be protected by inode->i_lock error
Date:   Mon, 13 Jun 2022 12:12:21 +0200
Message-Id: <20220613094936.332889957@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jchao Sun <sunjunchao2870@gmail.com>

commit 10e14073107dd0b6d97d9516a02845a8e501c2c9 upstream.

Commit b35250c0816c ("writeback: Protect inode->i_io_list with
inode->i_lock") made inode->i_io_list not only protected by
wb->list_lock but also inode->i_lock, but inode_io_list_move_locked()
was missed. Add lock there and also update comment describing
things protected by inode->i_lock. This also fixes a race where
__mark_inode_dirty() could move inode under flush worker's hands
and thus sync(2) could miss writing some inodes.

Fixes: b35250c0816c ("writeback: Protect inode->i_io_list with inode->i_lock")
Link: https://lore.kernel.org/r/20220524150540.12552-1-sunjunchao2870@gmail.com
CC: stable@vger.kernel.org
Signed-off-by: Jchao Sun <sunjunchao2870@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fs-writeback.c |   37 ++++++++++++++++++++++++++++---------
 fs/inode.c        |    2 +-
 2 files changed, 29 insertions(+), 10 deletions(-)

--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -120,6 +120,7 @@ static bool inode_io_list_move_locked(st
 				      struct list_head *head)
 {
 	assert_spin_locked(&wb->list_lock);
+	assert_spin_locked(&inode->i_lock);
 
 	list_move(&inode->i_io_list, head);
 
@@ -1365,9 +1366,9 @@ static int move_expired_inodes(struct li
 		inode = wb_inode(delaying_queue->prev);
 		if (inode_dirtied_after(inode, dirtied_before))
 			break;
+		spin_lock(&inode->i_lock);
 		list_move(&inode->i_io_list, &tmp);
 		moved++;
-		spin_lock(&inode->i_lock);
 		inode->i_state |= I_SYNC_QUEUED;
 		spin_unlock(&inode->i_lock);
 		if (sb_is_blkdev_sb(inode->i_sb))
@@ -1383,7 +1384,12 @@ static int move_expired_inodes(struct li
 		goto out;
 	}
 
-	/* Move inodes from one superblock together */
+	/*
+	 * Although inode's i_io_list is moved from 'tmp' to 'dispatch_queue',
+	 * we don't take inode->i_lock here because it is just a pointless overhead.
+	 * Inode is already marked as I_SYNC_QUEUED so writeback list handling is
+	 * fully under our control.
+	 */
 	while (!list_empty(&tmp)) {
 		sb = wb_inode(tmp.prev)->i_sb;
 		list_for_each_prev_safe(pos, node, &tmp) {
@@ -1826,8 +1832,8 @@ static long writeback_sb_inodes(struct s
 			 * We'll have another go at writing back this inode
 			 * when we completed a full scan of b_io.
 			 */
-			spin_unlock(&inode->i_lock);
 			requeue_io(inode, wb);
+			spin_unlock(&inode->i_lock);
 			trace_writeback_sb_inodes_requeue(inode);
 			continue;
 		}
@@ -2358,6 +2364,7 @@ void __mark_inode_dirty(struct inode *in
 {
 	struct super_block *sb = inode->i_sb;
 	int dirtytime = 0;
+	struct bdi_writeback *wb = NULL;
 
 	trace_writeback_mark_inode_dirty(inode, flags);
 
@@ -2410,13 +2417,24 @@ void __mark_inode_dirty(struct inode *in
 		inode->i_state |= flags;
 
 		/*
+		 * Grab inode's wb early because it requires dropping i_lock and we
+		 * need to make sure following checks happen atomically with dirty
+		 * list handling so that we don't move inodes under flush worker's
+		 * hands.
+		 */
+		if (!was_dirty) {
+			wb = locked_inode_to_wb_and_lock_list(inode);
+			spin_lock(&inode->i_lock);
+		}
+
+		/*
 		 * If the inode is queued for writeback by flush worker, just
 		 * update its dirty state. Once the flush worker is done with
 		 * the inode it will place it on the appropriate superblock
 		 * list, based upon its state.
 		 */
 		if (inode->i_state & I_SYNC_QUEUED)
-			goto out_unlock_inode;
+			goto out_unlock;
 
 		/*
 		 * Only add valid (hashed) inodes to the superblock's
@@ -2424,22 +2442,19 @@ void __mark_inode_dirty(struct inode *in
 		 */
 		if (!S_ISBLK(inode->i_mode)) {
 			if (inode_unhashed(inode))
-				goto out_unlock_inode;
+				goto out_unlock;
 		}
 		if (inode->i_state & I_FREEING)
-			goto out_unlock_inode;
+			goto out_unlock;
 
 		/*
 		 * If the inode was already on b_dirty/b_io/b_more_io, don't
 		 * reposition it (that would break b_dirty time-ordering).
 		 */
 		if (!was_dirty) {
-			struct bdi_writeback *wb;
 			struct list_head *dirty_list;
 			bool wakeup_bdi = false;
 
-			wb = locked_inode_to_wb_and_lock_list(inode);
-
 			inode->dirtied_when = jiffies;
 			if (dirtytime)
 				inode->dirtied_time_when = jiffies;
@@ -2453,6 +2468,7 @@ void __mark_inode_dirty(struct inode *in
 							       dirty_list);
 
 			spin_unlock(&wb->list_lock);
+			spin_unlock(&inode->i_lock);
 			trace_writeback_dirty_inode_enqueue(inode);
 
 			/*
@@ -2467,6 +2483,9 @@ void __mark_inode_dirty(struct inode *in
 			return;
 		}
 	}
+out_unlock:
+	if (wb)
+		spin_unlock(&wb->list_lock);
 out_unlock_inode:
 	spin_unlock(&inode->i_lock);
 }
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -27,7 +27,7 @@
  * Inode locking rules:
  *
  * inode->i_lock protects:
- *   inode->i_state, inode->i_hash, __iget()
+ *   inode->i_state, inode->i_hash, __iget(), inode->i_io_list
  * Inode LRU list locks protect:
  *   inode->i_sb->s_inode_lru, inode->i_lru
  * inode->i_sb->s_inode_list_lock protects:


