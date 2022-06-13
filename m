Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADC4454995F
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241788AbiFMQ7N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 12:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243441AbiFMQ7C (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 12:59:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2F37C03BF;
        Mon, 13 Jun 2022 04:52:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2DEC7B80D31;
        Mon, 13 Jun 2022 11:52:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70098C34114;
        Mon, 13 Jun 2022 11:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655121167;
        bh=YycKPzdJxTbW5+w6r9JyYgY11ta38vQTfHttPyjnstA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IbsQNwWmRg8aVfJBysfBmFmYMzOZLfZJMxEJS8dQrJRPXHSM9f/RWm/GAdZEfG3WZ
         PG4qMDqJ4eaBHSj2Qi7HIeins+HdRZcJRmnM8Oz85TTqcxz8IghHPo2BTms7R5qvyS
         WHB02JwodU4kkBuM3zu8Jzn9Ce8ApuLxSSobmhi8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jchao Sun <sunjunchao2870@gmail.com>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 5.17 273/298] writeback: Fix inode->i_io_list not be protected by inode->i_lock error
Date:   Mon, 13 Jun 2022 12:12:47 +0200
Message-Id: <20220613094933.359287645@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
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
 
@@ -1402,9 +1403,9 @@ static int move_expired_inodes(struct li
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
@@ -1420,7 +1421,12 @@ static int move_expired_inodes(struct li
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
@@ -1863,8 +1869,8 @@ static long writeback_sb_inodes(struct s
 			 * We'll have another go at writing back this inode
 			 * when we completed a full scan of b_io.
 			 */
-			spin_unlock(&inode->i_lock);
 			requeue_io(inode, wb);
+			spin_unlock(&inode->i_lock);
 			trace_writeback_sb_inodes_requeue(inode);
 			continue;
 		}
@@ -2400,6 +2406,7 @@ void __mark_inode_dirty(struct inode *in
 {
 	struct super_block *sb = inode->i_sb;
 	int dirtytime = 0;
+	struct bdi_writeback *wb = NULL;
 
 	trace_writeback_mark_inode_dirty(inode, flags);
 
@@ -2452,13 +2459,24 @@ void __mark_inode_dirty(struct inode *in
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
@@ -2466,22 +2484,19 @@ void __mark_inode_dirty(struct inode *in
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
@@ -2495,6 +2510,7 @@ void __mark_inode_dirty(struct inode *in
 							       dirty_list);
 
 			spin_unlock(&wb->list_lock);
+			spin_unlock(&inode->i_lock);
 			trace_writeback_dirty_inode_enqueue(inode);
 
 			/*
@@ -2509,6 +2525,9 @@ void __mark_inode_dirty(struct inode *in
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


