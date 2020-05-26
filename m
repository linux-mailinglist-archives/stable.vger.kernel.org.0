Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17B061C156C
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729418AbgEAN1L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:27:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:49282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728908AbgEAN1J (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:27:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AD9B2166E;
        Fri,  1 May 2020 13:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588339628;
        bh=06WB4Sn8XRHbJuL4eKdIbrrh8LdhZBrzwa+PEZNVp3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D13AigSaGpZ5W7fnna90+3TohgmOAQgPyHLyxKDrEt/Bc7kU2VA7e1MBB1QH5oFKM
         Nzsr/8NqCCnax9Quwx1mNuvBSqYnUiTPPdqK9JwJkQcL+lNGaHJk/aiso2VWdpTjhx
         YPaRW5Cha68W/ZDLilEE+ZyFjd0e1TpjiitnrW48=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        stable@kernel.org, Ashwin H <ashwinh@vmware.com>
Subject: [PATCH 4.4 66/70] ext4: avoid declaring fs inconsistent due to invalid file handles
Date:   Fri,  1 May 2020 15:21:54 +0200
Message-Id: <20200501131532.839974052@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131513.302599262@linuxfoundation.org>
References: <20200501131513.302599262@linuxfoundation.org>
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
 fs/ext4/super.c  |   28 ++++++++++------------------
 7 files changed, 61 insertions(+), 39 deletions(-)

--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2497,8 +2497,19 @@ int do_journal_get_write_access(handle_t
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
@@ -1150,7 +1150,7 @@ struct inode *ext4_orphan_get(struct sup
 	if (!ext4_test_bit(bit, bitmap_bh->b_data))
 		goto bad_orphan;
 
-	inode = ext4_iget(sb, ino);
+	inode = ext4_iget(sb, ino, EXT4_IGET_NORMAL);
 	if (IS_ERR(inode)) {
 		err = PTR_ERR(inode);
 		ext4_error(sb, "couldn't read orphan inode %lu (err %d)",
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4214,7 +4214,9 @@ static inline void ext4_iget_extra_inode
 		EXT4_I(inode)->i_inline_off = 0;
 }
 
-struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
+struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
+			  ext4_iget_flags flags, const char *function,
+			  unsigned int line)
 {
 	struct ext4_iloc iloc;
 	struct ext4_inode *raw_inode;
@@ -4227,6 +4229,18 @@ struct inode *ext4_iget(struct super_blo
 	uid_t i_uid;
 	gid_t i_gid;
 
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
@@ -4242,11 +4256,18 @@ struct inode *ext4_iget(struct super_blo
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
@@ -4273,7 +4294,8 @@ struct inode *ext4_iget(struct super_blo
 	}
 
 	if (!ext4_inode_csum_verify(inode, raw_inode, ei)) {
-		EXT4_ERROR_INODE(inode, "checksum invalid");
+		ext4_error_inode(inode, function, line, 0,
+				 "iget: checksum invalid");
 		ret = -EFSBADCRC;
 		goto bad_inode;
 	}
@@ -4321,7 +4343,8 @@ struct inode *ext4_iget(struct super_blo
 			((__u64)le16_to_cpu(raw_inode->i_file_acl_high)) << 32;
 	inode->i_size = ext4_isize(raw_inode);
 	if ((size = i_size_read(inode)) < 0) {
-		EXT4_ERROR_INODE(inode, "bad i_size value: %lld", size);
+		ext4_error_inode(inode, function, line, 0,
+				 "iget: bad i_size value: %lld", size);
 		ret = -EFSCORRUPTED;
 		goto bad_inode;
 	}
@@ -4404,7 +4427,8 @@ struct inode *ext4_iget(struct super_blo
 	ret = 0;
 	if (ei->i_file_acl &&
 	    !ext4_data_block_valid(EXT4_SB(sb), ei->i_file_acl, 1)) {
-		EXT4_ERROR_INODE(inode, "bad extended attribute block %llu",
+		ext4_error_inode(inode, function, line, 0,
+				 "iget: bad extended attribute block %llu",
 				 ei->i_file_acl);
 		ret = -EFSCORRUPTED;
 		goto bad_inode;
@@ -4459,7 +4483,8 @@ struct inode *ext4_iget(struct super_blo
 		make_bad_inode(inode);
 	} else {
 		ret = -EFSCORRUPTED;
-		EXT4_ERROR_INODE(inode, "bogus i_mode (%o)", inode->i_mode);
+		ext4_error_inode(inode, function, line, 0,
+				 "iget: bogus i_mode (%o)", inode->i_mode);
 		goto bad_inode;
 	}
 	brelse(iloc.bh);
@@ -4473,13 +4498,6 @@ bad_inode:
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
@@ -105,7 +105,7 @@ static long swap_inode_boot_loader(struc
 	if (!inode_owner_or_capable(inode) || !capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	inode_bl = ext4_iget(sb, EXT4_BOOT_LOADER_INO);
+	inode_bl = ext4_iget(sb, EXT4_BOOT_LOADER_INO, EXT4_IGET_SPECIAL);
 	if (IS_ERR(inode_bl))
 		return PTR_ERR(inode_bl);
 	ei_bl = EXT4_I(inode_bl);
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1601,7 +1601,7 @@ static struct dentry *ext4_lookup(struct
 					 dentry);
 			return ERR_PTR(-EFSCORRUPTED);
 		}
-		inode = ext4_iget_normal(dir->i_sb, ino);
+		inode = ext4_iget(dir->i_sb, ino, EXT4_IGET_NORMAL);
 		if (inode == ERR_PTR(-ESTALE)) {
 			EXT4_ERROR_INODE(dir,
 					 "deleted inode referenced: %u",
@@ -1646,7 +1646,7 @@ struct dentry *ext4_get_parent(struct de
 		return ERR_PTR(-EFSCORRUPTED);
 	}
 
-	return d_obtain_alias(ext4_iget_normal(d_inode(child)->i_sb, ino));
+	return d_obtain_alias(ext4_iget(d_inode(child)->i_sb, ino, EXT4_IGET_NORMAL));
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
@@ -1022,20 +1022,11 @@ static struct inode *ext4_nfs_get_inode(
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
@@ -4036,7 +4027,7 @@ no_journal:
 	 * so we can safely mount the rest of the filesystem now.
 	 */
 
-	root = ext4_iget(sb, EXT4_ROOT_INO);
+	root = ext4_iget(sb, EXT4_ROOT_INO, EXT4_IGET_SPECIAL);
 	if (IS_ERR(root)) {
 		ext4_msg(sb, KERN_ERR, "get root inode failed");
 		ret = PTR_ERR(root);
@@ -4273,11 +4264,12 @@ static journal_t *ext4_get_journal(struc
 
 	BUG_ON(!ext4_has_feature_journal(sb));
 
-	/* First, test for the existence of a valid inode on disk.  Bad
-	 * things happen if we iget() an unused inode, as the subsequent
-	 * iput() will try to delete it. */
-
-	journal_inode = ext4_iget(sb, journal_inum);
+	/*
+	 * Test for the existence of a valid inode on disk.  Bad things
+	 * happen if we iget() an unused inode, as the subsequent iput()
+	 * will try to delete it.
+	 */
+	journal_inode = ext4_iget(sb, journal_inum, EXT4_IGET_SPECIAL);
 	if (IS_ERR(journal_inode)) {
 		ext4_msg(sb, KERN_ERR, "no journal found");
 		return NULL;
@@ -5241,7 +5233,7 @@ static int ext4_quota_enable(struct supe
 	if (!qf_inums[type])
 		return -EPERM;
 
-	qf_inode = ext4_iget(sb, qf_inums[type]);
+	qf_inode = ext4_iget(sb, qf_inums[type], EXT4_IGET_SPECIAL);
 	if (IS_ERR(qf_inode)) {
 		ext4_error(sb, "Bad quota inode # %lu", qf_inums[type]);
 		return PTR_ERR(qf_inode);


