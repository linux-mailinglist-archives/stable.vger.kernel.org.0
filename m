Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D25565D6C6
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 16:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229461AbjADPDF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 10:03:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234874AbjADPCp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 10:02:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CE1FB1DF
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 07:02:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 046B1B81698
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 15:02:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34100C433A0;
        Wed,  4 Jan 2023 15:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672844561;
        bh=wj5XoeidPud/QLly8SwDG6K+9N4sQAjpVVI3q0xNY9Q=;
        h=Subject:To:Cc:From:Date:From;
        b=ejaQAD60sAs1wU7/HsCPLUWhCzd4b4AUjfU+tL1RTk5TXqXpS8qo1ahjnWzO58EhN
         fEVnG0EHchl9G6o/CA9HRuvDIRuxXVnqz3fvPzvv55EHJqzVkjPI7PEgiSmTiOx2+Q
         rHJJZL+b5ysbBvncQ4XlZjricp2NQdDKMiwcg7EE=
Subject: FAILED: patch "[PATCH] ext4: don't set up encryption key during jbd2 transaction" failed to apply to 5.10-stable tree
To:     ebiggers@google.com, stable@vger.kernel.org, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 16:02:36 +0100
Message-ID: <167284455613548@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

4c0d5778385c ("ext4: don't set up encryption key during jbd2 transaction")
5298d4bfe80f ("unicode: clean up the Kconfig symbol confusion")
2b3d04787012 ("unicode: Add utf8-data module")
6ca99ce756c2 ("unicode: cache the normalization tables in struct unicode_map")
fbc59d65059e ("unicode: move utf8cursor to utf8-selftest.c")
9012d79cf0c7 ("unicode: simplify utf8len")
379210db489c ("unicode: remove the unused utf8{,n}age{min,max} functions")
49bd03cc7e95 ("unicode: pass a UNICODE_AGE() tripple to utf8_load")
f3a9c8239600 ("unicode: mark the version field in struct unicode_map unsigned")
a440943e68cd ("unicode: remove the charset field from struct unicode_map")
227c4d507c71 ("Merge tag 'f2fs-for-5.14-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4c0d5778385cb3618ff26a561ce41de2b7d9de70 Mon Sep 17 00:00:00 2001
From: Eric Biggers <ebiggers@google.com>
Date: Sun, 6 Nov 2022 14:48:36 -0800
Subject: [PATCH] ext4: don't set up encryption key during jbd2 transaction

Commit a80f7fcf1867 ("ext4: fixup ext4_fc_track_* functions' signature")
extended the scope of the transaction in ext4_unlink() too far, making
it include the call to ext4_find_entry().  However, ext4_find_entry()
can deadlock when called from within a transaction because it may need
to set up the directory's encryption key.

Fix this by restoring the transaction to its original scope.

Reported-by: syzbot+1a748d0007eeac3ab079@syzkaller.appspotmail.com
Fixes: a80f7fcf1867 ("ext4: fixup ext4_fc_track_* functions' signature")
Cc: <stable@vger.kernel.org> # v5.10+
Signed-off-by: Eric Biggers <ebiggers@google.com>
Link: https://lore.kernel.org/r/20221106224841.279231-3-ebiggers@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 3afdd99bb214..4e739902dc03 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3620,8 +3620,8 @@ extern void ext4_initialize_dirent_tail(struct buffer_head *bh,
 					unsigned int blocksize);
 extern int ext4_handle_dirty_dirblock(handle_t *handle, struct inode *inode,
 				      struct buffer_head *bh);
-extern int __ext4_unlink(handle_t *handle, struct inode *dir, const struct qstr *d_name,
-			 struct inode *inode);
+extern int __ext4_unlink(struct inode *dir, const struct qstr *d_name,
+			 struct inode *inode, struct dentry *dentry);
 extern int __ext4_link(struct inode *dir, struct inode *inode,
 		       struct dentry *dentry);
 
diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index 6d98f2b39b77..da0c8228cf9c 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -1397,7 +1397,7 @@ static int ext4_fc_replay_unlink(struct super_block *sb, struct ext4_fc_tl *tl,
 		return 0;
 	}
 
-	ret = __ext4_unlink(NULL, old_parent, &entry, inode);
+	ret = __ext4_unlink(old_parent, &entry, inode, NULL);
 	/* -ENOENT ok coz it might not exist anymore. */
 	if (ret == -ENOENT)
 		ret = 0;
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index c08c0aba1883..a789ea9b61a0 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3204,14 +3204,20 @@ static int ext4_rmdir(struct inode *dir, struct dentry *dentry)
 	return retval;
 }
 
-int __ext4_unlink(handle_t *handle, struct inode *dir, const struct qstr *d_name,
-		  struct inode *inode)
+int __ext4_unlink(struct inode *dir, const struct qstr *d_name,
+		  struct inode *inode,
+		  struct dentry *dentry /* NULL during fast_commit recovery */)
 {
 	int retval = -ENOENT;
 	struct buffer_head *bh;
 	struct ext4_dir_entry_2 *de;
+	handle_t *handle;
 	int skip_remove_dentry = 0;
 
+	/*
+	 * Keep this outside the transaction; it may have to set up the
+	 * directory's encryption key, which isn't GFP_NOFS-safe.
+	 */
 	bh = ext4_find_entry(dir, d_name, &de, NULL);
 	if (IS_ERR(bh))
 		return PTR_ERR(bh);
@@ -3228,7 +3234,14 @@ int __ext4_unlink(handle_t *handle, struct inode *dir, const struct qstr *d_name
 		if (EXT4_SB(inode->i_sb)->s_mount_state & EXT4_FC_REPLAY)
 			skip_remove_dentry = 1;
 		else
-			goto out;
+			goto out_bh;
+	}
+
+	handle = ext4_journal_start(dir, EXT4_HT_DIR,
+				    EXT4_DATA_TRANS_BLOCKS(dir->i_sb));
+	if (IS_ERR(handle)) {
+		retval = PTR_ERR(handle);
+		goto out_bh;
 	}
 
 	if (IS_DIRSYNC(dir))
@@ -3237,12 +3250,12 @@ int __ext4_unlink(handle_t *handle, struct inode *dir, const struct qstr *d_name
 	if (!skip_remove_dentry) {
 		retval = ext4_delete_entry(handle, dir, de, bh);
 		if (retval)
-			goto out;
+			goto out_handle;
 		dir->i_ctime = dir->i_mtime = current_time(dir);
 		ext4_update_dx_flag(dir);
 		retval = ext4_mark_inode_dirty(handle, dir);
 		if (retval)
-			goto out;
+			goto out_handle;
 	} else {
 		retval = 0;
 	}
@@ -3255,15 +3268,17 @@ int __ext4_unlink(handle_t *handle, struct inode *dir, const struct qstr *d_name
 		ext4_orphan_add(handle, inode);
 	inode->i_ctime = current_time(inode);
 	retval = ext4_mark_inode_dirty(handle, inode);
-
-out:
+	if (dentry && !retval)
+		ext4_fc_track_unlink(handle, dentry);
+out_handle:
+	ext4_journal_stop(handle);
+out_bh:
 	brelse(bh);
 	return retval;
 }
 
 static int ext4_unlink(struct inode *dir, struct dentry *dentry)
 {
-	handle_t *handle;
 	int retval;
 
 	if (unlikely(ext4_forced_shutdown(EXT4_SB(dir->i_sb))))
@@ -3281,16 +3296,7 @@ static int ext4_unlink(struct inode *dir, struct dentry *dentry)
 	if (retval)
 		goto out_trace;
 
-	handle = ext4_journal_start(dir, EXT4_HT_DIR,
-				    EXT4_DATA_TRANS_BLOCKS(dir->i_sb));
-	if (IS_ERR(handle)) {
-		retval = PTR_ERR(handle);
-		goto out_trace;
-	}
-
-	retval = __ext4_unlink(handle, dir, &dentry->d_name, d_inode(dentry));
-	if (!retval)
-		ext4_fc_track_unlink(handle, dentry);
+	retval = __ext4_unlink(dir, &dentry->d_name, d_inode(dentry), dentry);
 #if IS_ENABLED(CONFIG_UNICODE)
 	/* VFS negative dentries are incompatible with Encoding and
 	 * Case-insensitiveness. Eventually we'll want avoid
@@ -3301,8 +3307,6 @@ static int ext4_unlink(struct inode *dir, struct dentry *dentry)
 	if (IS_CASEFOLDED(dir))
 		d_invalidate(dentry);
 #endif
-	if (handle)
-		ext4_journal_stop(handle);
 
 out_trace:
 	trace_ext4_unlink_exit(dentry, retval);

