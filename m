Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6707A2C6390
	for <lists+stable@lfdr.de>; Fri, 27 Nov 2020 12:09:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725989AbgK0LHC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Nov 2020 06:07:02 -0500
Received: from mx2.suse.de ([195.135.220.15]:43726 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725865AbgK0LHB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Nov 2020 06:07:01 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D44D4AF37;
        Fri, 27 Nov 2020 11:06:59 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 784BA1E1139; Fri, 27 Nov 2020 12:06:59 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     Ted Tso <tytso@mit.edu>
Cc:     <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org, Tahsin Erdogan <tahsin@google.com>
Subject: [PATCH] ext4: Fix deadlock with fs freezing and EA inodes
Date:   Fri, 27 Nov 2020 12:06:49 +0100
Message-Id: <20201127110649.24730-1-jack@suse.cz>
X-Mailer: git-send-email 2.16.4
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Xattr code using inodes with large xattr data can end up dropping last
inode reference (and thus deleting the inode) from places like
ext4_xattr_set_entry(). That function is called with transaction started
and so ext4_evict_inode() can deadlock against fs freezing like:

CPU1					CPU2

removexattr()				freeze_super()
  vfs_removexattr()
    ext4_xattr_set()
      handle = ext4_journal_start()
      ...
      ext4_xattr_set_entry()
        iput(old_ea_inode)
          ext4_evict_inode(old_ea_inode)
					  sb->s_writers.frozen = SB_FREEZE_FS;
					  sb_wait_write(sb, SB_FREEZE_FS);
					  ext4_freeze()
					    jbd2_journal_lock_updates()
					      -> blocks waiting for all
					         handles to stop
            sb_start_intwrite()
	      -> blocks as sb is already in SB_FREEZE_FS state

Generally it is advisable to delete inodes from a separate transaction
as it can consume quite some credits however in this case it would be
quite clumsy and furthermore the credits for inode deletion are quite
limited and already accounted for. So just tweak ext4_evict_inode() to
avoid freeze protection if we have transaction already started and thus
it is not really needed anyway.

CC: stable@vger.kernel.org
Fixes: dec214d00e0d ("ext4: xattr inode deduplication")
CC: Tahsin Erdogan <tahsin@google.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 72534319fae5..777eb08b29cd 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -175,6 +175,7 @@ void ext4_evict_inode(struct inode *inode)
 	 */
 	int extra_credits = 6;
 	struct ext4_xattr_inode_array *ea_inode_array = NULL;
+	bool freeze_protected = false;
 
 	trace_ext4_evict_inode(inode);
 
@@ -232,9 +233,14 @@ void ext4_evict_inode(struct inode *inode)
 
 	/*
 	 * Protect us against freezing - iput() caller didn't have to have any
-	 * protection against it
+	 * protection against it. When we are in a running transaction though,
+	 * we are already protected against freezing and we cannot grab further
+	 * protection due to lock ordering constraints.
 	 */
-	sb_start_intwrite(inode->i_sb);
+	if (!ext4_journal_current_handle()) {
+		sb_start_intwrite(inode->i_sb);
+		freeze_protected = true;
+	}
 
 	if (!IS_NOQUOTA(inode))
 		extra_credits += EXT4_MAXQUOTAS_DEL_BLOCKS(inode->i_sb);
@@ -253,7 +259,8 @@ void ext4_evict_inode(struct inode *inode)
 		 * cleaned up.
 		 */
 		ext4_orphan_del(NULL, inode);
-		sb_end_intwrite(inode->i_sb);
+		if (freeze_protected)
+			sb_end_intwrite(inode->i_sb);
 		goto no_delete;
 	}
 
@@ -294,7 +301,8 @@ void ext4_evict_inode(struct inode *inode)
 stop_handle:
 		ext4_journal_stop(handle);
 		ext4_orphan_del(NULL, inode);
-		sb_end_intwrite(inode->i_sb);
+		if (freeze_protected)
+			sb_end_intwrite(inode->i_sb);
 		ext4_xattr_inode_array_free(ea_inode_array);
 		goto no_delete;
 	}
@@ -323,7 +331,8 @@ void ext4_evict_inode(struct inode *inode)
 	else
 		ext4_free_inode(handle, inode);
 	ext4_journal_stop(handle);
-	sb_end_intwrite(inode->i_sb);
+	if (freeze_protected)
+		sb_end_intwrite(inode->i_sb);
 	ext4_xattr_inode_array_free(ea_inode_array);
 	return;
 no_delete:
-- 
2.16.4

