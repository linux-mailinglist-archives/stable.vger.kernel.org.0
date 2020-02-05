Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 776BE15367E
	for <lists+stable@lfdr.de>; Wed,  5 Feb 2020 18:30:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727306AbgBERag (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Feb 2020 12:30:36 -0500
Received: from mx2.suse.de ([195.135.220.15]:42552 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726822AbgBERag (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Feb 2020 12:30:36 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0116CACD7;
        Wed,  5 Feb 2020 17:30:33 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 2FBD41E0E31; Wed,  5 Feb 2020 18:30:29 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     Ted Tso <tytso@mit.edu>
Cc:     <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH] ext4: Fix checksum errors with indexed dirs
Date:   Wed,  5 Feb 2020 18:30:25 +0100
Message-Id: <20200205173025.12221-1-jack@suse.cz>
X-Mailer: git-send-email 2.16.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DIR_INDEX has been introduced as a compat ext4 feature. That means that
even kernels / tools that don't understand the feature may modify the
filesystem. This works because for kernels not understanding indexed dir
format, internal htree nodes appear just as empty directory entries.
Index dir aware kernels then check the htree structure is still
consistent before using the data. This all worked reasonably well until
metadata checksums were introduced. The problem is that these
effectively made DIR_INDEX only ro-compatible because internal htree
nodes store checksums in a different place than normal directory blocks.
Thus any modification ignorant to DIR_INDEX (or just clearing
EXT4_INDEX_FL from the inode) will effectively cause checksum mismatch
and trigger kernel errors. So we have to be more careful when dealing
with indexed directories on filesystems with checksumming enabled.

1) We just disallow loading and directory inodes with EXT4_INDEX_FL when
DIR_INDEX is not enabled. This is harsh but it should be very rare (it
means someone disabled DIR_INDEX on existing filesystem and didn't run
e2fsck), e2fsck can fix the problem, and we don't want to answer the
difficult question: "Should we rather corrupt the directory more or
should we ignore that DIR_INDEX feature is not set?"

2) When we find out htree structure is corrupted (but the filesystem and
the directory should in support htrees), we continue just ignoring htree
information for reading but we refuse to add new entries to the
directory to avoid corrupting it more.

CC: stable@vger.kernel.org
Fixes: dbe89444042a ("ext4: Calculate and verify checksums for htree nodes")
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/dir.c   | 14 ++++++++------
 fs/ext4/ext4.h  |  5 ++++-
 fs/ext4/inode.c | 13 +++++++++++++
 fs/ext4/namei.c |  7 +++++++
 4 files changed, 32 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index 9f00fc0bf21d..cb9ea593b544 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -129,12 +129,14 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
 		if (err != ERR_BAD_DX_DIR) {
 			return err;
 		}
-		/*
-		 * We don't set the inode dirty flag since it's not
-		 * critical that it get flushed back to the disk.
-		 */
-		ext4_clear_inode_flag(file_inode(file),
-				      EXT4_INODE_INDEX);
+		/* Can we just clear INDEX flag to ignore htree information? */
+		if (!ext4_has_metadata_csum(sb)) {
+			/*
+			 * We don't set the inode dirty flag since it's not
+			 * critical that it gets flushed back to the disk.
+			 */
+			ext4_clear_inode_flag(inode, EXT4_INODE_INDEX);
+		}
 	}
 
 	if (ext4_has_inline_data(inode)) {
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index f8578caba40d..1fd6c1e2ce2a 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2482,8 +2482,11 @@ void ext4_insert_dentry(struct inode *inode,
 			struct ext4_filename *fname);
 static inline void ext4_update_dx_flag(struct inode *inode)
 {
-	if (!ext4_has_feature_dir_index(inode->i_sb))
+	if (!ext4_has_feature_dir_index(inode->i_sb)) {
+		/* ext4_iget() should have caught this... */
+		WARN_ON_ONCE(ext4_has_feature_metadata_csum(inode->i_sb));
 		ext4_clear_inode_flag(inode, EXT4_INODE_INDEX);
+	}
 }
 static const unsigned char ext4_filetype_table[] = {
 	DT_UNKNOWN, DT_REG, DT_DIR, DT_CHR, DT_BLK, DT_FIFO, DT_SOCK, DT_LNK
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 629a25d999f0..d33135308c1b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4615,6 +4615,19 @@ struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
 		ret = -EFSCORRUPTED;
 		goto bad_inode;
 	}
+	/*
+	 * If dir_index is not enabled but there's dir with INDEX flag set,
+	 * we'd normally treat htree data as empty space. But with metadata
+	 * checksumming that corrupts checksums so forbid that.
+	 */
+	if (!ext4_has_feature_dir_index(sb) && ext4_has_metadata_csum(sb) &&
+	    ext4_test_inode_flag(inode, EXT4_INODE_INDEX)) {
+		ext4_error_inode(inode, function, line, 0,
+				 "iget: Dir with htree data on filesystem "
+				 "without dir_index feature.");
+		ret = -EFSCORRUPTED;
+		goto bad_inode;
+	}
 	ei->i_disksize = inode->i_size;
 #ifdef CONFIG_QUOTA
 	ei->i_reserved_quota = 0;
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 1cb42d940784..deb9f7a02976 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2207,6 +2207,13 @@ static int ext4_add_entry(handle_t *handle, struct dentry *dentry,
 		retval = ext4_dx_add_entry(handle, &fname, dir, inode);
 		if (!retval || (retval != ERR_BAD_DX_DIR))
 			goto out;
+		/* Can we just ignore htree data? */
+		if (ext4_has_metadata_csum(sb)) {
+			EXT4_ERROR_INODE(dir,
+				"Directory has corrupted htree index.");
+			retval = -EFSCORRUPTED;
+			goto out;
+		}
 		ext4_clear_inode_flag(dir, EXT4_INODE_INDEX);
 		dx_fallback++;
 		ext4_mark_inode_dirty(handle, dir);
-- 
2.16.4

