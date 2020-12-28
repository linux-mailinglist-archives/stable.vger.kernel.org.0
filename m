Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F02A2E3E64
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:27:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502303AbgL1O1a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:27:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:35216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502299AbgL1O12 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:27:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C99AC229C5;
        Mon, 28 Dec 2020 14:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165608;
        bh=ouWmlPyMFKcL4kW80E8RxcRo03ImrAsfCNh707PK3Tg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sB+WvhSmIuHP/tDUEe5V/dZnZ+yhu5wIENqpPAQ09SR3SlLn0X1VuQIyZ4oYuPFkK
         2yDn4HuljLWAFbfoqzc+t72lRZzxKLl5vcTaDqNmmz0M3GHcET6dWueFW3mYJK9+Vi
         0iBx0tvEOjHI/SaQz1BsqNuy6Koz0JtXF5BD7OZs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Andreas Dilger <adilger@dilger.ca>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.10 592/717] ext4: fix deadlock with fs freezing and EA inodes
Date:   Mon, 28 Dec 2020 13:49:50 +0100
Message-Id: <20201228125049.274273481@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit 46e294efc355c48d1dd4d58501aa56dac461792a upstream.

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

Cc: stable@vger.kernel.org
Fixes: dec214d00e0d ("ext4: xattr inode deduplication")
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Link: https://lore.kernel.org/r/20201127110649.24730-1-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/inode.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -175,6 +175,7 @@ void ext4_evict_inode(struct inode *inod
 	 */
 	int extra_credits = 6;
 	struct ext4_xattr_inode_array *ea_inode_array = NULL;
+	bool freeze_protected = false;
 
 	trace_ext4_evict_inode(inode);
 
@@ -232,9 +233,14 @@ void ext4_evict_inode(struct inode *inod
 
 	/*
 	 * Protect us against freezing - iput() caller didn't have to have any
-	 * protection against it
-	 */
-	sb_start_intwrite(inode->i_sb);
+	 * protection against it. When we are in a running transaction though,
+	 * we are already protected against freezing and we cannot grab further
+	 * protection due to lock ordering constraints.
+	 */
+	if (!ext4_journal_current_handle()) {
+		sb_start_intwrite(inode->i_sb);
+		freeze_protected = true;
+	}
 
 	if (!IS_NOQUOTA(inode))
 		extra_credits += EXT4_MAXQUOTAS_DEL_BLOCKS(inode->i_sb);
@@ -253,7 +259,8 @@ void ext4_evict_inode(struct inode *inod
 		 * cleaned up.
 		 */
 		ext4_orphan_del(NULL, inode);
-		sb_end_intwrite(inode->i_sb);
+		if (freeze_protected)
+			sb_end_intwrite(inode->i_sb);
 		goto no_delete;
 	}
 
@@ -294,7 +301,8 @@ void ext4_evict_inode(struct inode *inod
 stop_handle:
 		ext4_journal_stop(handle);
 		ext4_orphan_del(NULL, inode);
-		sb_end_intwrite(inode->i_sb);
+		if (freeze_protected)
+			sb_end_intwrite(inode->i_sb);
 		ext4_xattr_inode_array_free(ea_inode_array);
 		goto no_delete;
 	}
@@ -323,7 +331,8 @@ stop_handle:
 	else
 		ext4_free_inode(handle, inode);
 	ext4_journal_stop(handle);
-	sb_end_intwrite(inode->i_sb);
+	if (freeze_protected)
+		sb_end_intwrite(inode->i_sb);
 	ext4_xattr_inode_array_free(ea_inode_array);
 	return;
 no_delete:


