Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C40CE10EDAB
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 18:02:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727653AbfLBRCR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 12:02:17 -0500
Received: from mx2.suse.de ([195.135.220.15]:53810 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727569AbfLBRCR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Dec 2019 12:02:17 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8025BBD40;
        Mon,  2 Dec 2019 17:02:15 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 46A361E0B4C; Mon,  2 Dec 2019 18:02:15 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     Ted Tso <tytso@mit.edu>
Cc:     <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH 1/2] ext4: Fix ext4_empty_dir() for directories with holes
Date:   Mon,  2 Dec 2019 18:02:12 +0100
Message-Id: <20191202170213.4761-2-jack@suse.cz>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191202170213.4761-1-jack@suse.cz>
References: <20191202170213.4761-1-jack@suse.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Function ext4_empty_dir() doesn't correctly handle directories with
holes and crashes on bh->b_data dereference when bh is NULL. Reorganize
the loop to use 'offset' variable all the times instead of comparing
pointers to current direntry with bh->b_data pointer. Also add more
strict checking of '.' and '..' directory entries to avoid entering loop
in possibly invalid state on corrupted filesystems.

References: CVE-2019-19037
CC: stable@vger.kernel.org
Fixes: 4e19d6b65fb4 ("ext4: allow directory holes")
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/namei.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index a427d2031a8d..abf52f98f3ca 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2808,7 +2808,7 @@ bool ext4_empty_dir(struct inode *inode)
 {
 	unsigned int offset;
 	struct buffer_head *bh;
-	struct ext4_dir_entry_2 *de, *de1;
+	struct ext4_dir_entry_2 *de;
 	struct super_block *sb;
 
 	if (ext4_has_inline_data(inode)) {
@@ -2833,19 +2833,25 @@ bool ext4_empty_dir(struct inode *inode)
 		return true;
 
 	de = (struct ext4_dir_entry_2 *) bh->b_data;
-	de1 = ext4_next_entry(de, sb->s_blocksize);
-	if (le32_to_cpu(de->inode) != inode->i_ino ||
-			le32_to_cpu(de1->inode) == 0 ||
-			strcmp(".", de->name) || strcmp("..", de1->name)) {
-		ext4_warning_inode(inode, "directory missing '.' and/or '..'");
+	if (ext4_check_dir_entry(inode, NULL, de, bh, bh->b_data, bh->b_size,
+				 0) ||
+	    le32_to_cpu(de->inode) != inode->i_ino || strcmp(".", de->name)) {
+		ext4_warning_inode(inode, "directory missing '.'");
+		brelse(bh);
+		return true;
+	}
+	offset = ext4_rec_len_from_disk(de->rec_len, sb->s_blocksize);
+	de = ext4_next_entry(de, sb->s_blocksize);
+	if (ext4_check_dir_entry(inode, NULL, de, bh, bh->b_data, bh->b_size,
+				 offset) ||
+	    le32_to_cpu(de->inode) == 0 || strcmp("..", de->name)) {
+		ext4_warning_inode(inode, "directory missing '..'");
 		brelse(bh);
 		return true;
 	}
-	offset = ext4_rec_len_from_disk(de->rec_len, sb->s_blocksize) +
-		 ext4_rec_len_from_disk(de1->rec_len, sb->s_blocksize);
-	de = ext4_next_entry(de1, sb->s_blocksize);
+	offset += ext4_rec_len_from_disk(de->rec_len, sb->s_blocksize);
 	while (offset < inode->i_size) {
-		if ((void *) de >= (void *) (bh->b_data+sb->s_blocksize)) {
+		if (!(offset & (sb->s_blocksize - 1))) {
 			unsigned int lblock;
 			brelse(bh);
 			lblock = offset >> EXT4_BLOCK_SIZE_BITS(sb);
@@ -2856,12 +2862,11 @@ bool ext4_empty_dir(struct inode *inode)
 			}
 			if (IS_ERR(bh))
 				return true;
-			de = (struct ext4_dir_entry_2 *) bh->b_data;
 		}
+		de = (struct ext4_dir_entry_2 *) (bh->b_data +
+					(offset & (sb->s_blocksize - 1)));
 		if (ext4_check_dir_entry(inode, NULL, de, bh,
 					 bh->b_data, bh->b_size, offset)) {
-			de = (struct ext4_dir_entry_2 *)(bh->b_data +
-							 sb->s_blocksize);
 			offset = (offset | (sb->s_blocksize - 1)) + 1;
 			continue;
 		}
@@ -2870,7 +2875,6 @@ bool ext4_empty_dir(struct inode *inode)
 			return false;
 		}
 		offset += ext4_rec_len_from_disk(de->rec_len, sb->s_blocksize);
-		de = ext4_next_entry(de, sb->s_blocksize);
 	}
 	brelse(bh);
 	return true;
-- 
2.16.4

