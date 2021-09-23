Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 093D74156E1
	for <lists+stable@lfdr.de>; Thu, 23 Sep 2021 05:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239689AbhIWDo3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 23:44:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:42408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239462AbhIWDmO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Sep 2021 23:42:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E703E61278;
        Thu, 23 Sep 2021 03:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632368414;
        bh=EQZGOIz9/Y/m6GsumCpxjNFI6u7kXa5nJ4Z641bkq+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rt1hcv9RUcN+x0V7e7YvLSe3LJdJi5F4hDksNvk/mBVbMNPUJ5FwT918aIE1wmBU4
         iB28CVYzm1OPsYHaO7uDtSXeqo+3DyZ3u3iF4PVSEjmZs9l61hH7vQi8RBRwfoItNz
         tAIjcpLY03B5nnRymzLCCVddx3y2ueyCd9vjHpgI/fFQbbNeu974/GkCxme6Q2rArn
         xZDMDy6DuZ8EA/fk12q1gqoiJWGl0PZjCN64kXp2PPkPDYlD5ITJk93dJ4/vUvAMdq
         LWI/F8KzEbvWebRxK8KD6kOf73NqzdrIO9DY85h5HDarAvt2M+mxvo4C3rS7Oe1xFL
         B7PesRJITtCjg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, al@alarsen.net
Subject: [PATCH AUTOSEL 4.14 08/13] qnx4: avoid stringop-overread errors
Date:   Wed, 22 Sep 2021 23:39:54 -0400
Message-Id: <20210923033959.1421662-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210923033959.1421662-1-sashal@kernel.org>
References: <20210923033959.1421662-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit b7213ffa0e585feb1aee3e7173e965e66ee0abaa ]

The qnx4 directory entries are 64-byte blocks that have different
contents depending on the a status byte that is in the last byte of the
block.

In particular, a directory entry can be either a "link info" entry with
a 48-byte name and pointers to the real inode information, or an "inode
entry" with a smaller 16-byte name and the full inode information.

But the code was written to always just treat the directory name as if
it was part of that "inode entry", and just extend the name to the
longer case if the status byte said it was a link entry.

That work just fine and gives the right results, but now that gcc is
tracking data structure accesses much more, the code can trigger a
compiler error about using up to 48 bytes (the long name) in a structure
that only has that shorter name in it:

   fs/qnx4/dir.c: In function ‘qnx4_readdir’:
   fs/qnx4/dir.c:51:32: error: ‘strnlen’ specified bound 48 exceeds source size 16 [-Werror=stringop-overread]
      51 |                         size = strnlen(de->di_fname, size);
         |                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from fs/qnx4/qnx4.h:3,
                    from fs/qnx4/dir.c:16:
   include/uapi/linux/qnx4_fs.h:45:25: note: source object declared here
      45 |         char            di_fname[QNX4_SHORT_NAME_MAX];
         |                         ^~~~~~~~

which is because the source code doesn't really make this whole "one of
two different types" explicit.

Fix this by introducing a very explicit union of the two types, and
basically explaining to the compiler what is really going on.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/qnx4/dir.c | 51 ++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 34 insertions(+), 17 deletions(-)

diff --git a/fs/qnx4/dir.c b/fs/qnx4/dir.c
index a6ee23aadd28..2a66844b7ff8 100644
--- a/fs/qnx4/dir.c
+++ b/fs/qnx4/dir.c
@@ -15,13 +15,27 @@
 #include <linux/buffer_head.h>
 #include "qnx4.h"
 
+/*
+ * A qnx4 directory entry is an inode entry or link info
+ * depending on the status field in the last byte. The
+ * first byte is where the name start either way, and a
+ * zero means it's empty.
+ */
+union qnx4_directory_entry {
+	struct {
+		char de_name;
+		char de_pad[62];
+		char de_status;
+	};
+	struct qnx4_inode_entry inode;
+	struct qnx4_link_info link;
+};
+
 static int qnx4_readdir(struct file *file, struct dir_context *ctx)
 {
 	struct inode *inode = file_inode(file);
 	unsigned int offset;
 	struct buffer_head *bh;
-	struct qnx4_inode_entry *de;
-	struct qnx4_link_info *le;
 	unsigned long blknum;
 	int ix, ino;
 	int size;
@@ -38,27 +52,30 @@ static int qnx4_readdir(struct file *file, struct dir_context *ctx)
 		}
 		ix = (ctx->pos >> QNX4_DIR_ENTRY_SIZE_BITS) % QNX4_INODES_PER_BLOCK;
 		for (; ix < QNX4_INODES_PER_BLOCK; ix++, ctx->pos += QNX4_DIR_ENTRY_SIZE) {
+			union qnx4_directory_entry *de;
+			const char *name;
+
 			offset = ix * QNX4_DIR_ENTRY_SIZE;
-			de = (struct qnx4_inode_entry *) (bh->b_data + offset);
-			if (!de->di_fname[0])
+			de = (union qnx4_directory_entry *) (bh->b_data + offset);
+
+			if (!de->de_name)
 				continue;
-			if (!(de->di_status & (QNX4_FILE_USED|QNX4_FILE_LINK)))
+			if (!(de->de_status & (QNX4_FILE_USED|QNX4_FILE_LINK)))
 				continue;
-			if (!(de->di_status & QNX4_FILE_LINK))
-				size = QNX4_SHORT_NAME_MAX;
-			else
-				size = QNX4_NAME_MAX;
-			size = strnlen(de->di_fname, size);
-			QNX4DEBUG((KERN_INFO "qnx4_readdir:%.*s\n", size, de->di_fname));
-			if (!(de->di_status & QNX4_FILE_LINK))
+			if (!(de->de_status & QNX4_FILE_LINK)) {
+				size = sizeof(de->inode.di_fname);
+				name = de->inode.di_fname;
 				ino = blknum * QNX4_INODES_PER_BLOCK + ix - 1;
-			else {
-				le  = (struct qnx4_link_info*)de;
-				ino = ( le32_to_cpu(le->dl_inode_blk) - 1 ) *
+			} else {
+				size = sizeof(de->link.dl_fname);
+				name = de->link.dl_fname;
+				ino = ( le32_to_cpu(de->link.dl_inode_blk) - 1 ) *
 					QNX4_INODES_PER_BLOCK +
-					le->dl_inode_ndx;
+					de->link.dl_inode_ndx;
 			}
-			if (!dir_emit(ctx, de->di_fname, size, ino, DT_UNKNOWN)) {
+			size = strnlen(name, size);
+			QNX4DEBUG((KERN_INFO "qnx4_readdir:%.*s\n", size, name));
+			if (!dir_emit(ctx, name, size, ino, DT_UNKNOWN)) {
 				brelse(bh);
 				return 0;
 			}
-- 
2.30.2

