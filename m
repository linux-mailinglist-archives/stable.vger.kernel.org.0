Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87332420D7C
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236054AbhJDNPf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:15:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:53112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236263AbhJDNNn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:13:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1FEC61B98;
        Mon,  4 Oct 2021 13:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352726;
        bh=04kIWPn05Hq1DT9FgELgq24nOOVbuN6zG7jDb7g0c10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dWqWZJhDZPaEYE3DdgIvvLDEhzjJtwVBJcaTgEmfhHMcmHlAKRdF3UHNWpNaGewF0
         gFOaVUng0LPAbjWp2T27Xd78wpTI1b37qgEP4ZEhaoBPX6HTRKeLgGCOuYp31yYJko
         SDx4FNPiZWnANkACnPSa2EvT8fwm5oEc2v35a6yo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@kernel.org>
Subject: [PATCH 4.19 55/95] qnx4: work around gcc false positive warning bug
Date:   Mon,  4 Oct 2021 14:52:25 +0200
Message-Id: <20211004125035.366534793@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125033.572932188@linuxfoundation.org>
References: <20211004125033.572932188@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit d5f6545934c47e97c0b48a645418e877b452a992 upstream.

In commit b7213ffa0e58 ("qnx4: avoid stringop-overread errors") I tried
to teach gcc about how the directory entry structure can be two
different things depending on a status flag.  It made the code clearer,
and it seemed to make gcc happy.

However, Arnd points to a gcc bug, where despite using two different
members of a union, gcc then gets confused, and uses the size of one of
the members to decide if a string overrun happens.  And not necessarily
the rigth one.

End result: with some configurations, gcc-11 will still complain about
the source buffer size being overread:

  fs/qnx4/dir.c: In function 'qnx4_readdir':
  fs/qnx4/dir.c:76:32: error: 'strnlen' specified bound [16, 48] exceeds source size 1 [-Werror=stringop-overread]
     76 |                         size = strnlen(name, size);
        |                                ^~~~~~~~~~~~~~~~~~~
  fs/qnx4/dir.c:26:22: note: source object declared here
     26 |                 char de_name;
        |                      ^~~~~~~

because gcc will get confused about which union member entry is actually
getting accessed, even when the source code is very clear about it.  Gcc
internally will have combined two "redundant" pointers (pointing to
different union elements that are at the same offset), and takes the
size checking from one or the other - not necessarily the right one.

This is clearly a gcc bug, but we can work around it fairly easily.  The
biggest thing here is the big honking comment about why we do what we
do.

Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=99578#c6
Reported-and-tested-by: Arnd Bergmann <arnd@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/qnx4/dir.c |   36 +++++++++++++++++++++++++++---------
 1 file changed, 27 insertions(+), 9 deletions(-)

--- a/fs/qnx4/dir.c
+++ b/fs/qnx4/dir.c
@@ -20,12 +20,33 @@
  * depending on the status field in the last byte. The
  * first byte is where the name start either way, and a
  * zero means it's empty.
+ *
+ * Also, due to a bug in gcc, we don't want to use the
+ * real (differently sized) name arrays in the inode and
+ * link entries, but always the 'de_name[]' one in the
+ * fake struct entry.
+ *
+ * See
+ *
+ *   https://gcc.gnu.org/bugzilla/show_bug.cgi?id=99578#c6
+ *
+ * for details, but basically gcc will take the size of the
+ * 'name' array from one of the used union entries randomly.
+ *
+ * This use of 'de_name[]' (48 bytes) avoids the false positive
+ * warnings that would happen if gcc decides to use 'inode.di_name'
+ * (16 bytes) even when the pointer and size were to come from
+ * 'link.dl_name' (48 bytes).
+ *
+ * In all cases the actual name pointer itself is the same, it's
+ * only the gcc internal 'what is the size of this field' logic
+ * that can get confused.
  */
 union qnx4_directory_entry {
 	struct {
-		char de_name;
-		char de_pad[62];
-		char de_status;
+		const char de_name[48];
+		u8 de_pad[15];
+		u8 de_status;
 	};
 	struct qnx4_inode_entry inode;
 	struct qnx4_link_info link;
@@ -53,29 +74,26 @@ static int qnx4_readdir(struct file *fil
 		ix = (ctx->pos >> QNX4_DIR_ENTRY_SIZE_BITS) % QNX4_INODES_PER_BLOCK;
 		for (; ix < QNX4_INODES_PER_BLOCK; ix++, ctx->pos += QNX4_DIR_ENTRY_SIZE) {
 			union qnx4_directory_entry *de;
-			const char *name;
 
 			offset = ix * QNX4_DIR_ENTRY_SIZE;
 			de = (union qnx4_directory_entry *) (bh->b_data + offset);
 
-			if (!de->de_name)
+			if (!de->de_name[0])
 				continue;
 			if (!(de->de_status & (QNX4_FILE_USED|QNX4_FILE_LINK)))
 				continue;
 			if (!(de->de_status & QNX4_FILE_LINK)) {
 				size = sizeof(de->inode.di_fname);
-				name = de->inode.di_fname;
 				ino = blknum * QNX4_INODES_PER_BLOCK + ix - 1;
 			} else {
 				size = sizeof(de->link.dl_fname);
-				name = de->link.dl_fname;
 				ino = ( le32_to_cpu(de->link.dl_inode_blk) - 1 ) *
 					QNX4_INODES_PER_BLOCK +
 					de->link.dl_inode_ndx;
 			}
-			size = strnlen(name, size);
+			size = strnlen(de->de_name, size);
 			QNX4DEBUG((KERN_INFO "qnx4_readdir:%.*s\n", size, name));
-			if (!dir_emit(ctx, name, size, ino, DT_UNKNOWN)) {
+			if (!dir_emit(ctx, de->de_name, size, ino, DT_UNKNOWN)) {
 				brelse(bh);
 				return 0;
 			}


