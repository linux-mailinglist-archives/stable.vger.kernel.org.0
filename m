Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6107172035
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731441AbgB0Nws (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:52:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:52424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731101AbgB0Nwr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:52:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6486920801;
        Thu, 27 Feb 2020 13:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811566;
        bh=RNLN69BGm8fANgSoBTtbZd9/AhSz5a+ERLa+TyBFI1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KC93wqKsllWw50dMh+umJyy5yeZ1nVpNn4iOoqtn49ItEegoSrcLbd83oKGC1ndBT
         JRS0YGS/hJYsG4oocUqEXy5RpTUMP8um3Hi88OhcPkVJ7buidojEHOxpmLEwl906eT
         OC5WM6svSl38GsTypadC5/1AAz/8pzDjPsYoDBEo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
        stable@kernel.org
Subject: [PATCH 4.14 017/237] ext4: fix checksum errors with indexed dirs
Date:   Thu, 27 Feb 2020 14:33:51 +0100
Message-Id: <20200227132257.356800487@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132255.285644406@linuxfoundation.org>
References: <20200227132255.285644406@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit 48a34311953d921235f4d7bbd2111690d2e469cf upstream.

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

1) We just disallow loading any directory inodes with EXT4_INDEX_FL when
DIR_INDEX is not enabled. This is harsh but it should be very rare (it
means someone disabled DIR_INDEX on existing filesystem and didn't run
e2fsck), e2fsck can fix the problem, and we don't want to answer the
difficult question: "Should we rather corrupt the directory more or
should we ignore that DIR_INDEX feature is not set?"

2) When we find out htree structure is corrupted (but the filesystem and
the directory should in support htrees), we continue just ignoring htree
information for reading but we refuse to add new entries to the
directory to avoid corrupting it more.

Link: https://lore.kernel.org/r/20200210144316.22081-1-jack@suse.cz
Fixes: dbe89444042a ("ext4: Calculate and verify checksums for htree nodes")
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/dir.c   |   14 ++++++++------
 fs/ext4/ext4.h  |    5 ++++-
 fs/ext4/inode.c |   12 ++++++++++++
 fs/ext4/namei.c |    7 +++++++
 4 files changed, 31 insertions(+), 7 deletions(-)

--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -125,12 +125,14 @@ static int ext4_readdir(struct file *fil
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
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2386,8 +2386,11 @@ void ext4_insert_dentry(struct inode *in
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
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4817,6 +4817,18 @@ struct inode *ext4_iget(struct super_blo
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
+		EXT4_ERROR_INODE(inode,
+				 "iget: Dir with htree data on filesystem without dir_index feature.");
+		ret = -EFSCORRUPTED;
+		goto bad_inode;
+	}
 	ei->i_disksize = inode->i_size;
 #ifdef CONFIG_QUOTA
 	ei->i_reserved_quota = 0;
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2094,6 +2094,13 @@ static int ext4_add_entry(handle_t *hand
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


