Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA760420C40
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234177AbhJDNEA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:04:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:32834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233981AbhJDNCw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:02:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1570161409;
        Mon,  4 Oct 2021 12:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352363;
        bh=2x/8C7RGicmM784+vbWKsqQcHRNQFf3C1wuczzZL2ss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TVhF6routJSrf398yRM5pP9kOo4yRUDMPkY6+/8hspilxeehbkqX6wH5wTMKb0Kub
         0doToYL4vf+EUdeddGtzY9bpyI85Ri/Dm3qmq9EYDlSMxKSGy3kwbKFIkubQ027z/j
         13RgwcQTPTb/njiVdAuft4durjMnmE9e7t7+kriQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 31/75] qnx4: avoid stringop-overread errors
Date:   Mon,  4 Oct 2021 14:52:06 +0200
Message-Id: <20211004125032.558921579@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125031.530773667@linuxfoundation.org>
References: <20211004125031.530773667@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
2.33.0



