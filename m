Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8335512C9C5
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:19:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728345AbfL2R1F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:27:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:48894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726796AbfL2R1E (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:27:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0607020409;
        Sun, 29 Dec 2019 17:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640423;
        bh=xqmpT8M4Y7EMU/GjjouJghEXD0iA5QrDxKWyPVXQU6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iTPHacsgHDOacvIk8dzlC8dg31FgsHdsR9Yyh3DLd9Y3idqECFkgRQk9OYAh2q7+U
         pJeFbq7YKTXNeIisMtdmS2aDsUjfI6uAibU0AsgOusu7VV0HYdYzufaehA0L1oFacn
         i/Uo9ROGU++Z2o46YfGFin54wviO8tmw/kGUZJrM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.14 151/161] ext4: fix ext4_empty_dir() for directories with holes
Date:   Sun, 29 Dec 2019 18:19:59 +0100
Message-Id: <20191229162447.013699297@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162355.500086350@linuxfoundation.org>
References: <20191229162355.500086350@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit 64d4ce892383b2ad6d782e080d25502f91bf2a38 upstream.

Function ext4_empty_dir() doesn't correctly handle directories with
holes and crashes on bh->b_data dereference when bh is NULL. Reorganize
the loop to use 'offset' variable all the times instead of comparing
pointers to current direntry with bh->b_data pointer. Also add more
strict checking of '.' and '..' directory entries to avoid entering loop
in possibly invalid state on corrupted filesystems.

CC: stable@vger.kernel.org
Fixes: 4e19d6b65fb4 ("ext4: allow directory holes")
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20191202170213.4761-2-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/namei.c |   32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2702,7 +2702,7 @@ bool ext4_empty_dir(struct inode *inode)
 {
 	unsigned int offset;
 	struct buffer_head *bh;
-	struct ext4_dir_entry_2 *de, *de1;
+	struct ext4_dir_entry_2 *de;
 	struct super_block *sb;
 
 	if (ext4_has_inline_data(inode)) {
@@ -2727,19 +2727,25 @@ bool ext4_empty_dir(struct inode *inode)
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
 		brelse(bh);
 		return true;
 	}
-	offset = ext4_rec_len_from_disk(de->rec_len, sb->s_blocksize) +
-		 ext4_rec_len_from_disk(de1->rec_len, sb->s_blocksize);
-	de = ext4_next_entry(de1, sb->s_blocksize);
+	offset = ext4_rec_len_from_disk(de->rec_len, sb->s_blocksize);
+	de = ext4_next_entry(de, sb->s_blocksize);
+	if (ext4_check_dir_entry(inode, NULL, de, bh, bh->b_data, bh->b_size,
+				 offset) ||
+	    le32_to_cpu(de->inode) == 0 || strcmp("..", de->name)) {
+		ext4_warning_inode(inode, "directory missing '..'");
+		brelse(bh);
+		return true;
+	}
+	offset += ext4_rec_len_from_disk(de->rec_len, sb->s_blocksize);
 	while (offset < inode->i_size) {
-		if ((void *) de >= (void *) (bh->b_data+sb->s_blocksize)) {
+		if (!(offset & (sb->s_blocksize - 1))) {
 			unsigned int lblock;
 			brelse(bh);
 			lblock = offset >> EXT4_BLOCK_SIZE_BITS(sb);
@@ -2750,12 +2756,11 @@ bool ext4_empty_dir(struct inode *inode)
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
@@ -2764,7 +2769,6 @@ bool ext4_empty_dir(struct inode *inode)
 			return false;
 		}
 		offset += ext4_rec_len_from_disk(de->rec_len, sb->s_blocksize);
-		de = ext4_next_entry(de, sb->s_blocksize);
 	}
 	brelse(bh);
 	return true;


