Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 008A560AAF1
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236081AbiJXNm1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:42:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234075AbiJXNim (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:38:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00DADB03D5;
        Mon, 24 Oct 2022 05:36:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 929E661297;
        Mon, 24 Oct 2022 12:36:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4D55C433C1;
        Mon, 24 Oct 2022 12:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614984;
        bh=wNyFHM2p/6dzf+FMI40mFTip7NEogrKvFAWKGDqg7as=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WnoMSnEGVXX37UsB8sPj/3ksziGWYTrsb45kNrvsiybP5LYAgpwejI46oK6P3lHdS
         mHtG46Ku2rCzG9loLmMTkmW5fYeArt2XlLH+JZaG/Td1vbfVkht1o9GfGmVJDuM32j
         n8Ozr4O/LXmuvRKUDlYcPkuNcTrXZ0A35yWdwAP0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>, stable@kernel.org,
        Lukas Czerner <lczerner@redhat.com>, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.15 078/530] fs: record I_DIRTY_TIME even if inode already has I_DIRTY_INODE
Date:   Mon, 24 Oct 2022 13:27:02 +0200
Message-Id: <20221024113048.542721677@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Czerner <lczerner@redhat.com>

commit cbfecb927f429a6fa613d74b998496bd71e4438a upstream.

Currently the I_DIRTY_TIME will never get set if the inode already has
I_DIRTY_INODE with assumption that it supersedes I_DIRTY_TIME.  That's
true, however ext4 will only update the on-disk inode in
->dirty_inode(), not on actual writeback. As a result if the inode
already has I_DIRTY_INODE state by the time we get to
__mark_inode_dirty() only with I_DIRTY_TIME, the time was already filled
into on-disk inode and will not get updated until the next I_DIRTY_INODE
update, which might never come if we crash or get a power failure.

The problem can be reproduced on ext4 by running xfstest generic/622
with -o iversion mount option.

Fix it by allowing I_DIRTY_TIME to be set even if the inode already has
I_DIRTY_INODE. Also make sure that the case is properly handled in
writeback_single_inode() as well. Additionally changes in
xfs_fs_dirty_inode() was made to accommodate for I_DIRTY_TIME in flag.

Thanks Jan Kara for suggestions on how to make this work properly.

Cc: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: stable@kernel.org
Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Suggested-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220825100657.44217-1-lczerner@redhat.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/filesystems/vfs.rst |    3 +++
 fs/fs-writeback.c                 |   37 +++++++++++++++++++++++++------------
 fs/xfs/xfs_super.c                |   10 ++++++++--
 include/linux/fs.h                |    9 +++++----
 4 files changed, 41 insertions(+), 18 deletions(-)

--- a/Documentation/filesystems/vfs.rst
+++ b/Documentation/filesystems/vfs.rst
@@ -274,6 +274,9 @@ or bottom half).
 	This is specifically for the inode itself being marked dirty,
 	not its data.  If the update needs to be persisted by fdatasync(),
 	then I_DIRTY_DATASYNC will be set in the flags argument.
+	I_DIRTY_TIME will be set in the flags in case lazytime is enabled
+	and struct inode has times updated since the last ->dirty_inode
+	call.
 
 ``write_inode``
 	this method is called when the VFS needs to write an inode to
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1745,9 +1745,14 @@ static int writeback_single_inode(struct
 	 */
 	if (!(inode->i_state & I_DIRTY_ALL))
 		inode_cgwb_move_to_attached(inode, wb);
-	else if (!(inode->i_state & I_SYNC_QUEUED) &&
-		 (inode->i_state & I_DIRTY))
-		redirty_tail_locked(inode, wb);
+	else if (!(inode->i_state & I_SYNC_QUEUED)) {
+		if ((inode->i_state & I_DIRTY))
+			redirty_tail_locked(inode, wb);
+		else if (inode->i_state & I_DIRTY_TIME) {
+			inode->dirtied_when = jiffies;
+			inode_io_list_move_locked(inode, wb, &wb->b_dirty_time);
+		}
+	}
 
 	spin_unlock(&wb->list_lock);
 	inode_sync_complete(inode);
@@ -2401,6 +2406,20 @@ void __mark_inode_dirty(struct inode *in
 
 	if (flags & I_DIRTY_INODE) {
 		/*
+		 * Inode timestamp update will piggback on this dirtying.
+		 * We tell ->dirty_inode callback that timestamps need to
+		 * be updated by setting I_DIRTY_TIME in flags.
+		 */
+		if (inode->i_state & I_DIRTY_TIME) {
+			spin_lock(&inode->i_lock);
+			if (inode->i_state & I_DIRTY_TIME) {
+				inode->i_state &= ~I_DIRTY_TIME;
+				flags |= I_DIRTY_TIME;
+			}
+			spin_unlock(&inode->i_lock);
+		}
+
+		/*
 		 * Notify the filesystem about the inode being dirtied, so that
 		 * (if needed) it can update on-disk fields and journal the
 		 * inode.  This is only needed when the inode itself is being
@@ -2409,7 +2428,8 @@ void __mark_inode_dirty(struct inode *in
 		 */
 		trace_writeback_dirty_inode_start(inode, flags);
 		if (sb->s_op->dirty_inode)
-			sb->s_op->dirty_inode(inode, flags & I_DIRTY_INODE);
+			sb->s_op->dirty_inode(inode,
+				flags & (I_DIRTY_INODE | I_DIRTY_TIME));
 		trace_writeback_dirty_inode(inode, flags);
 
 		/* I_DIRTY_INODE supersedes I_DIRTY_TIME. */
@@ -2430,21 +2450,15 @@ void __mark_inode_dirty(struct inode *in
 	 */
 	smp_mb();
 
-	if (((inode->i_state & flags) == flags) ||
-	    (dirtytime && (inode->i_state & I_DIRTY_INODE)))
+	if ((inode->i_state & flags) == flags)
 		return;
 
 	spin_lock(&inode->i_lock);
-	if (dirtytime && (inode->i_state & I_DIRTY_INODE))
-		goto out_unlock_inode;
 	if ((inode->i_state & flags) != flags) {
 		const int was_dirty = inode->i_state & I_DIRTY;
 
 		inode_attach_wb(inode, NULL);
 
-		/* I_DIRTY_INODE supersedes I_DIRTY_TIME. */
-		if (flags & I_DIRTY_INODE)
-			inode->i_state &= ~I_DIRTY_TIME;
 		inode->i_state |= flags;
 
 		/*
@@ -2517,7 +2531,6 @@ void __mark_inode_dirty(struct inode *in
 out_unlock:
 	if (wb)
 		spin_unlock(&wb->list_lock);
-out_unlock_inode:
 	spin_unlock(&inode->i_lock);
 }
 EXPORT_SYMBOL(__mark_inode_dirty);
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -642,7 +642,7 @@ xfs_fs_destroy_inode(
 static void
 xfs_fs_dirty_inode(
 	struct inode			*inode,
-	int				flag)
+	int				flags)
 {
 	struct xfs_inode		*ip = XFS_I(inode);
 	struct xfs_mount		*mp = ip->i_mount;
@@ -650,7 +650,13 @@ xfs_fs_dirty_inode(
 
 	if (!(inode->i_sb->s_flags & SB_LAZYTIME))
 		return;
-	if (flag != I_DIRTY_SYNC || !(inode->i_state & I_DIRTY_TIME))
+
+	/*
+	 * Only do the timestamp update if the inode is dirty (I_DIRTY_SYNC)
+	 * and has dirty timestamp (I_DIRTY_TIME). I_DIRTY_TIME can be passed
+	 * in flags possibly together with I_DIRTY_SYNC.
+	 */
+	if ((flags & ~I_DIRTY_TIME) != I_DIRTY_SYNC || !(flags & I_DIRTY_TIME))
 		return;
 
 	if (xfs_trans_alloc(mp, &M_RES(mp)->tr_fsyncts, 0, 0, 0, &tp))
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2288,13 +2288,14 @@ static inline void kiocb_clone(struct ki
  *			don't have to write inode on fdatasync() when only
  *			e.g. the timestamps have changed.
  * I_DIRTY_PAGES	Inode has dirty pages.  Inode itself may be clean.
- * I_DIRTY_TIME		The inode itself only has dirty timestamps, and the
+ * I_DIRTY_TIME		The inode itself has dirty timestamps, and the
  *			lazytime mount option is enabled.  We keep track of this
  *			separately from I_DIRTY_SYNC in order to implement
  *			lazytime.  This gets cleared if I_DIRTY_INODE
- *			(I_DIRTY_SYNC and/or I_DIRTY_DATASYNC) gets set.  I.e.
- *			either I_DIRTY_TIME *or* I_DIRTY_INODE can be set in
- *			i_state, but not both.  I_DIRTY_PAGES may still be set.
+ *			(I_DIRTY_SYNC and/or I_DIRTY_DATASYNC) gets set. But
+ *			I_DIRTY_TIME can still be set if I_DIRTY_SYNC is already
+ *			in place because writeback might already be in progress
+ *			and we don't want to lose the time update
  * I_NEW		Serves as both a mutex and completion notification.
  *			New inodes set I_NEW.  If two processes both create
  *			the same inode, one of them will release its inode and


