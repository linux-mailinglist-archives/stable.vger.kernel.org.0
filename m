Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 074D52E3BF3
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:57:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406572AbgL1N4l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:56:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:58052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406544AbgL1N4i (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:56:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A992207B2;
        Mon, 28 Dec 2020 13:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163782;
        bh=bctFitTEeo52VyCh0ydGO5T7uJluqm3P91V+Q30OYy8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=puPbWxOtYDAUYeVG9tNPoQFhQ4+m4sGZ7RPo8ocpt42M71d92O+AAxhDzhvr1tXnY
         ZBJQqPnK225QGLPrRmQ8mAd5nkvASGbusYhWJi0Ce21HyZ4tQG4N1W8/xh18fBaaiK
         n4aJUV5URouXAG4zh3V603Ko2m0OdmmIuCsUkwsg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Andreas Dilger <adilger@dilger.ca>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.4 375/453] ext4: fix deadlock with fs freezing and EA inodes
Date:   Mon, 28 Dec 2020 13:50:11 +0100
Message-Id: <20201228124955.248188088@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
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
@@ -203,6 +203,7 @@ void ext4_evict_inode(struct inode *inod
 	 */
 	int extra_credits = 6;
 	struct ext4_xattr_inode_array *ea_inode_array = NULL;
+	bool freeze_protected = false;
 
 	trace_ext4_evict_inode(inode);
 
@@ -250,9 +251,14 @@ void ext4_evict_inode(struct inode *inod
 
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
@@ -271,7 +277,8 @@ void ext4_evict_inode(struct inode *inod
 		 * cleaned up.
 		 */
 		ext4_orphan_del(NULL, inode);
-		sb_end_intwrite(inode->i_sb);
+		if (freeze_protected)
+			sb_end_intwrite(inode->i_sb);
 		goto no_delete;
 	}
 
@@ -312,7 +319,8 @@ void ext4_evict_inode(struct inode *inod
 stop_handle:
 		ext4_journal_stop(handle);
 		ext4_orphan_del(NULL, inode);
-		sb_end_intwrite(inode->i_sb);
+		if (freeze_protected)
+			sb_end_intwrite(inode->i_sb);
 		ext4_xattr_inode_array_free(ea_inode_array);
 		goto no_delete;
 	}
@@ -341,7 +349,8 @@ stop_handle:
 	else
 		ext4_free_inode(handle, inode);
 	ext4_journal_stop(handle);
-	sb_end_intwrite(inode->i_sb);
+	if (freeze_protected)
+		sb_end_intwrite(inode->i_sb);
 	ext4_xattr_inode_array_free(ea_inode_array);
 	return;
 no_delete:


