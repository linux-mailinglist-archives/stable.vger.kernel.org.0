Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA8B1C1591
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729945AbgEANa0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:30:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:54460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729941AbgEANaZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:30:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93BC120757;
        Fri,  1 May 2020 13:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588339825;
        bh=KBznDU0bh3Ra+af3e7xze1C8OKiJ9HJYkcorwt0Ev7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NwQfwSOArAmDJd6/Ag4BBgewqKBBow7/63IfKqdN2xcjmXWMMEl/xtmihwi4w3ccs
         tDQbw1hv10RNaL+vcm9S1TD5wmcs9Pi/v82aqnhDKEOc2wOwkjXR20mgW2SLCnNPzA
         SKHXwXYxnPK0A3lYaz6ZQOwAv3T0cTGM6qg+McQs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        stable@kernel.org, Ashwin H <ashwinh@vmware.com>
Subject: [PATCH 4.9 75/80] ext4: avoid declaring fs inconsistent due to invalid file handles
Date:   Fri,  1 May 2020 15:22:09 +0200
Message-Id: <20200501131536.769485348@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131513.810761598@linuxfoundation.org>
References: <20200501131513.810761598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

commit 8a363970d1dc38c4ec4ad575c862f776f468d057 upstream.

If we receive a file handle, either from NFS or open_by_handle_at(2),
and it points at an inode which has not been initialized, and the file
system has metadata checksums enabled, we shouldn't try to get the
inode, discover the checksum is invalid, and then declare the file
system as being inconsistent.

This can be reproduced by creating a test file system via "mke2fs -t
ext4 -O metadata_csum /tmp/foo.img 8M", mounting it, cd'ing into that
directory, and then running the following program.

#define _GNU_SOURCE
#include <fcntl.h>

struct handle {
	struct file_handle fh;
	unsigned char fid[MAX_HANDLE_SZ];
};

int main(int argc, char **argv)
{
	struct handle h = {{8, 1 }, { 12, }};

	open_by_handle_at(AT_FDCWD, &h.fh, O_RDONLY);
	return 0;
}

Google-Bug-Id: 120690101
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Ashwin H <ashwinh@vmware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/ext4.h   |   15 +++++++++++++--
 fs/ext4/ialloc.c |    2 +-
 fs/ext4/inode.c  |   44 +++++++++++++++++++++++++++++++-------------
 fs/ext4/ioctl.c  |    2 +-
 fs/ext4/namei.c  |    4 ++--
 fs/ext4/resize.c |    5 +++--
 fs/ext4/super.c  |   19 +++++--------------
 7 files changed, 56 insertions(+), 35 deletions(-)

--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2496,8 +2496,19 @@ int do_journal_get_write_access(handle_t
 #define FALL_BACK_TO_NONDELALLOC 1
 #define CONVERT_INLINE_DATA	 2
 
-extern struct inode *ext4_iget(struct super_block *, unsigned long);
-extern struct inode *ext4_iget_normal(struct super_block *, unsigned long);
+typedef enum {
+	EXT4_IGET_NORMAL =	0,
+	EXT4_IGET_SPECIAL =	0x0001, /* OK to iget a system inode */
+	EXT4_IGET_HANDLE = 	0x0002	/* Inode # is from a handle */
+} ext4_iget_flags;
+
+extern struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
+				 ext4_iget_flags flags, const char *function,
+				 unsigned int line);
+
+#define ext4_iget(sb, ino, flags) \
+	__ext4_iget((sb), (ino), (flags), __func__, __LINE__)
+
 extern int  ext4_write_inode(struct inode *, struct writeback_control *);
 extern int  ext4_setattr(struct dentry *, struct iattr *);
 extern int  ext4_getattr(struct vfsmount *mnt, struct dentry *dentry,
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -1158,7 +1158,7 @@ struct inode *ext4_orphan_get(struct sup
 	if (!ext4_test_bit(bit, bitmap_bh->b_data))
 		goto bad_orphan;
 
-	inode = ext4_iget(sb, ino);
+	inode = ext4_iget(sb, ino, EXT4_IGET_NORMAL);
 	if (IS_ERR(inode)) {
 		err = PTR_ERR(inode);
 		ext4_error(sb, "couldn't read orphan inode %lu (err %d)",
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4474,7 +4474,9 @@ int ext4_get_projid(struct inode *inode,
 	return 0;
 }
 
-struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
+struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
+			  ext4_iget_flags flags, const char *function,
+			  unsigned int line)
 {
 	struct ext4_iloc iloc;
 	struct ext4_inode *raw_inode;
@@ -4488,6 +4490,18 @@ struct inode *ext4_iget(struct super_blo
 	gid_t i_gid;
 	projid_t i_projid;
 
+	if (((flags & EXT4_IGET_NORMAL) &&
+	     (ino < EXT4_FIRST_INO(sb) && ino != EXT4_ROOT_INO)) ||
+	    (ino < EXT4_ROOT_INO) ||
+	    (ino > le32_to_cpu(EXT4_SB(sb)->s_es->s_inodes_count))) {
+		if (flags & EXT4_IGET_HANDLE)
+			return ERR_PTR(-ESTALE);
+		__ext4_error(sb, function, line,
+			     "inode #%lu: comm %s: iget: illegal inode #",
+			     ino, current->comm);
+		return ERR_PTR(-EFSCORRUPTED);
+	}
+
 	inode = iget_locked(sb, ino);
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
@@ -4503,11 +4517,18 @@ struct inode *ext4_iget(struct super_blo
 	raw_inode = ext4_raw_inode(&iloc);
 
 	if ((ino == EXT4_ROOT_INO) && (raw_inode->i_links_count == 0)) {
-		EXT4_ERROR_INODE(inode, "root inode unallocated");
+		ext4_error_inode(inode, function, line, 0,
+				 "iget: root inode unallocated");
 		ret = -EFSCORRUPTED;
 		goto bad_inode;
 	}
 
+	if ((flags & EXT4_IGET_HANDLE) &&
+	    (raw_inode->i_links_count == 0) && (raw_inode->i_mode == 0)) {
+		ret = -ESTALE;
+		goto bad_inode;
+	}
+
 	if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE) {
 		ei->i_extra_isize = le16_to_cpu(raw_inode->i_extra_isize);
 		if (EXT4_GOOD_OLD_INODE_SIZE + ei->i_extra_isize >
@@ -4534,7 +4555,8 @@ struct inode *ext4_iget(struct super_blo
 	}
 
 	if (!ext4_inode_csum_verify(inode, raw_inode, ei)) {
-		EXT4_ERROR_INODE(inode, "checksum invalid");
+		ext4_error_inode(inode, function, line, 0,
+				 "iget: checksum invalid");
 		ret = -EFSBADCRC;
 		goto bad_inode;
 	}
@@ -4590,7 +4612,8 @@ struct inode *ext4_iget(struct super_blo
 			((__u64)le16_to_cpu(raw_inode->i_file_acl_high)) << 32;
 	inode->i_size = ext4_isize(raw_inode);
 	if ((size = i_size_read(inode)) < 0) {
-		EXT4_ERROR_INODE(inode, "bad i_size value: %lld", size);
+		ext4_error_inode(inode, function, line, 0,
+				 "iget: bad i_size value: %lld", size);
 		ret = -EFSCORRUPTED;
 		goto bad_inode;
 	}
@@ -4673,7 +4696,8 @@ struct inode *ext4_iget(struct super_blo
 	ret = 0;
 	if (ei->i_file_acl &&
 	    !ext4_data_block_valid(EXT4_SB(sb), ei->i_file_acl, 1)) {
-		EXT4_ERROR_INODE(inode, "bad extended attribute block %llu",
+		ext4_error_inode(inode, function, line, 0,
+				 "iget: bad extended attribute block %llu",
 				 ei->i_file_acl);
 		ret = -EFSCORRUPTED;
 		goto bad_inode;
@@ -4728,7 +4752,8 @@ struct inode *ext4_iget(struct super_blo
 		make_bad_inode(inode);
 	} else {
 		ret = -EFSCORRUPTED;
-		EXT4_ERROR_INODE(inode, "bogus i_mode (%o)", inode->i_mode);
+		ext4_error_inode(inode, function, line, 0,
+				 "iget: bogus i_mode (%o)", inode->i_mode);
 		goto bad_inode;
 	}
 	brelse(iloc.bh);
@@ -4742,13 +4767,6 @@ bad_inode:
 	return ERR_PTR(ret);
 }
 
-struct inode *ext4_iget_normal(struct super_block *sb, unsigned long ino)
-{
-	if (ino < EXT4_FIRST_INO(sb) && ino != EXT4_ROOT_INO)
-		return ERR_PTR(-EFSCORRUPTED);
-	return ext4_iget(sb, ino);
-}
-
 static int ext4_inode_blocks_set(handle_t *handle,
 				struct ext4_inode *raw_inode,
 				struct ext4_inode_info *ei)
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -104,7 +104,7 @@ static long swap_inode_boot_loader(struc
 	if (!inode_owner_or_capable(inode) || !capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	inode_bl = ext4_iget(sb, EXT4_BOOT_LOADER_INO);
+	inode_bl = ext4_iget(sb, EXT4_BOOT_LOADER_INO, EXT4_IGET_SPECIAL);
 	if (IS_ERR(inode_bl))
 		return PTR_ERR(inode_bl);
 	ei_bl = EXT4_I(inode_bl);
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1626,7 +1626,7 @@ static struct dentry *ext4_lookup(struct
 					 dentry);
 			return ERR_PTR(-EFSCORRUPTED);
 		}
-		inode = ext4_iget_normal(dir->i_sb, ino);
+		inode = ext4_iget(dir->i_sb, ino, EXT4_IGET_NORMAL);
 		if (inode == ERR_PTR(-ESTALE)) {
 			EXT4_ERROR_INODE(dir,
 					 "deleted inode referenced: %u",
@@ -1675,7 +1675,7 @@ struct dentry *ext4_get_parent(struct de
 		return ERR_PTR(-EFSCORRUPTED);
 	}
 
-	return d_obtain_alias(ext4_iget_normal(child->d_sb, ino));
+	return d_obtain_alias(ext4_iget(child->d_sb, ino, EXT4_IGET_NORMAL));
 }
 
 /*
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1649,7 +1649,7 @@ int ext4_group_add(struct super_block *s
 				     "No reserved GDT blocks, can't resize");
 			return -EPERM;
 		}
-		inode = ext4_iget(sb, EXT4_RESIZE_INO);
+		inode = ext4_iget(sb, EXT4_RESIZE_INO, EXT4_IGET_SPECIAL);
 		if (IS_ERR(inode)) {
 			ext4_warning(sb, "Error opening resize inode");
 			return PTR_ERR(inode);
@@ -1977,7 +1977,8 @@ retry:
 		}
 
 		if (!resize_inode)
-			resize_inode = ext4_iget(sb, EXT4_RESIZE_INO);
+			resize_inode = ext4_iget(sb, EXT4_RESIZE_INO,
+						 EXT4_IGET_SPECIAL);
 		if (IS_ERR(resize_inode)) {
 			ext4_warning(sb, "Error opening resize inode");
 			return PTR_ERR(resize_inode);
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1049,20 +1049,11 @@ static struct inode *ext4_nfs_get_inode(
 {
 	struct inode *inode;
 
-	if (ino < EXT4_FIRST_INO(sb) && ino != EXT4_ROOT_INO)
-		return ERR_PTR(-ESTALE);
-	if (ino > le32_to_cpu(EXT4_SB(sb)->s_es->s_inodes_count))
-		return ERR_PTR(-ESTALE);
-
-	/* iget isn't really right if the inode is currently unallocated!!
-	 *
-	 * ext4_read_inode will return a bad_inode if the inode had been
-	 * deleted, so we should be safe.
-	 *
+	/*
 	 * Currently we don't know the generation for parent directory, so
 	 * a generation of 0 means "accept any"
 	 */
-	inode = ext4_iget_normal(sb, ino);
+	inode = ext4_iget(sb, ino, EXT4_IGET_HANDLE);
 	if (IS_ERR(inode))
 		return ERR_CAST(inode);
 	if (generation && inode->i_generation != generation) {
@@ -4195,7 +4186,7 @@ no_journal:
 	 * so we can safely mount the rest of the filesystem now.
 	 */
 
-	root = ext4_iget(sb, EXT4_ROOT_INO);
+	root = ext4_iget(sb, EXT4_ROOT_INO, EXT4_IGET_SPECIAL);
 	if (IS_ERR(root)) {
 		ext4_msg(sb, KERN_ERR, "get root inode failed");
 		ret = PTR_ERR(root);
@@ -4447,7 +4438,7 @@ static struct inode *ext4_get_journal_in
 	 * happen if we iget() an unused inode, as the subsequent iput()
 	 * will try to delete it.
 	 */
-	journal_inode = ext4_iget(sb, journal_inum);
+	journal_inode = ext4_iget(sb, journal_inum, EXT4_IGET_SPECIAL);
 	if (IS_ERR(journal_inode)) {
 		ext4_msg(sb, KERN_ERR, "no journal found");
 		return NULL;
@@ -5476,7 +5467,7 @@ static int ext4_quota_enable(struct supe
 	if (!qf_inums[type])
 		return -EPERM;
 
-	qf_inode = ext4_iget(sb, qf_inums[type]);
+	qf_inode = ext4_iget(sb, qf_inums[type], EXT4_IGET_SPECIAL);
 	if (IS_ERR(qf_inode)) {
 		ext4_error(sb, "Bad quota inode # %lu", qf_inums[type]);
 		return PTR_ERR(qf_inode);


