Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBD1167DD65
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 07:23:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbjA0GWe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 01:22:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231532AbjA0GWD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 01:22:03 -0500
X-Greylist: delayed 165 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 26 Jan 2023 22:22:02 PST
Received: from p3plwbeout22-03.prod.phx3.secureserver.net (p3plsmtp22-03-2.prod.phx3.secureserver.net [68.178.252.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47A4D59B78
        for <stable@vger.kernel.org>; Thu, 26 Jan 2023 22:22:02 -0800 (PST)
Received: from mailex.mailcore.me ([94.136.40.141])
        by :WBEOUT: with ESMTP
        id LI4yp8bRgDEazLI4zpbS8V; Thu, 26 Jan 2023 23:19:17 -0700
X-CMAE-Analysis: v=2.4 cv=Qp+bYX+d c=1 sm=1 tr=0 ts=63d36ce5
 a=bheWAUFm1xGnSTQFbH9Kqg==:117 a=84ok6UeoqCVsigPHarzEiQ==:17
 a=ggZhUymU-5wA:10 a=RvmDmJFTN0MA:10 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8
 a=hSkVLCK3AAAA:8 a=FXvPX3liAAAA:8 a=EVEbNfvgc1qMiNCojxgA:9 a=jOG_20N5BSkA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=cQPPKAXgyycSBL8etih5:22 a=UObqyxdv-6Yh2QiB9mM_:22
X-SECURESERVER-ACCT: phillip@squashfs.org.uk  
X-SID:  LI4yp8bRgDEaz
Received: from 82-69-79-175.dsl.in-addr.zen.co.uk ([82.69.79.175] helo=phoenix.fritz.box)
        by smtp06.mailcore.me with esmtpa (Exim 4.94.2)
        (envelope-from <phillip@squashfs.org.uk>)
        id 1pLI4y-0006DZ-1o; Fri, 27 Jan 2023 06:19:16 +0000
From:   Phillip Lougher <phillip@squashfs.org.uk>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc:     pchelkin@ispras.ru, khoroshilov@ispras.ru,
        Phillip Lougher <phillip@squashfs.org.uk>,
        syzbot+082fa4af80a5bb1a9843@syzkaller.appspotmail.com,
        stable@vger.kernel.org
Subject: [PATCH] Squashfs: fix handling and sanity checking of xattr_ids count
Date:   Fri, 27 Jan 2023 06:18:42 +0000
Message-Id: <20230127061842.10965-1-phillip@squashfs.org.uk>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Mailcore-Auth: 439999529
X-Mailcore-Domain: 1394945
X-123-reg-Authenticated:  phillip@squashfs.org.uk  
X-Originating-IP: 82.69.79.175
X-CMAE-Envelope: MS4xfLkZ1dNLiEVzwJ47WaXxBBcnkt8+y60hMLICUBgIkfcOgxleZY3U3Xbv52xwWjcysG7wPMeQtKSpOFgjkn9SDII4KWQ8VTaqGZozX9sAA/ADR82/5M/R
 cw32O9ATDt5vc1jEj+It32AIw9iOkqNPBZAbXhu3ldcTfFh5i6N4Wwic8rHL8bSHst+h2zE9TDZYo07MKPpHG0yx/Gnrgx5ps64eAIUrMLRUfggdzNdTKNDE
 4cRtwA1tAs1hu46GBrHeCQ==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A Sysbot [1] corrupted filesystem exposes two flaws in the
handling and sanity checking of the xattr_ids count in the
filesystem.  Both of these flaws cause computation overflow
due to incorrect typing.

In the corrupted filesystem the xattr_ids value is 4294967071, which
stored in a signed variable becomes the negative number -225.

Flaw 1 (64-bit systems only):

The signed integer xattr_ids variable causes sign extension.

This causes variable overflow in the SQUASHFS_XATTR_*(A) macros.
The variable is first multiplied by sizeof(struct squashfs_xattr_id)
where the type of the sizeof operator is "unsigned long".

On a 64-bit system this is 64-bits in size, and causes the negative
number to be sign extended and widened to 64-bits and then become unsigned.
This produces the very large number 18446744073709548016 or 2^64 - 3600.
This number when rounded up by SQUASHFS_METADATA_SIZE - 1 (8191 bytes) and
divided by SQUASHFS_METADATA_SIZE overflows and produces a length of 0
(stored in len).

Flaw 2 (32-bit systems only):

On a 32-bit system the integer variable is not widened by the unsigned
long type of the sizeof operator (32-bits), and the signedness of the
variable has no effect due it always being treated as unsigned.

The above corrupted xattr_ids value of 4294967071, when multiplied
overflows and produces the number 4294963696 or 2^32 - 3400.  This
number when rounded up by SQUASHFS_METADATA_SIZE - 1 (8191 bytes) and
divided by SQUASHFS_METADATA_SIZE overflows again and produces a length
of 0.

The effect of the 0 length computation:

In conjunction with the corrupted xattr_ids field, the filesystem
also has a corrupted xattr_table_start value, where it matches
the end of filesystem value of 850.

This causes the following sanity check code to fail because the incorrectly
computed len of 0 matches the incorrect size of the table reported by the
superblock (0 bytes).

    len = SQUASHFS_XATTR_BLOCK_BYTES(*xattr_ids);
    indexes = SQUASHFS_XATTR_BLOCKS(*xattr_ids);

    /*
     * The computed size of the index table (len bytes) should exactly
     * match the table start and end points
    */
    start = table_start + sizeof(*id_table);
    end = msblk->bytes_used;

    if (len != (end - start))
            return ERR_PTR(-EINVAL);

Changing the xattr_ids variable to be "usigned int" fixes the flaw
on a 64-bit system.  This relies on the fact the computation is widened
by the unsigned long type of the sizeof operator.

Casting the variable to u64 in the above macro fixes this flaw on a 32-bit
system.

It also means 64-bit systems do not implicitly rely on the type of the
sizeof operator to widen the computation.

[1] https://lore.kernel.org/lkml/000000000000cd44f005f1a0f17f@google.com/

Fixes: 506220d2ba21 ("squashfs: add more sanity checks in xattr id lookup")
Reported-by: syzbot+082fa4af80a5bb1a9843@syzkaller.appspotmail.com
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Cc: <stable@vger.kernel.org>
---
 fs/squashfs/squashfs_fs.h    | 2 +-
 fs/squashfs/squashfs_fs_sb.h | 2 +-
 fs/squashfs/xattr.h          | 4 ++--
 fs/squashfs/xattr_id.c       | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/squashfs/squashfs_fs.h b/fs/squashfs/squashfs_fs.h
index b3fdc8212c5f..95f8e8901768 100644
--- a/fs/squashfs/squashfs_fs.h
+++ b/fs/squashfs/squashfs_fs.h
@@ -183,7 +183,7 @@ static inline int squashfs_block_size(__le32 raw)
 #define SQUASHFS_ID_BLOCK_BYTES(A)	(SQUASHFS_ID_BLOCKS(A) *\
 					sizeof(u64))
 /* xattr id lookup table defines */
-#define SQUASHFS_XATTR_BYTES(A)		((A) * sizeof(struct squashfs_xattr_id))
+#define SQUASHFS_XATTR_BYTES(A)		(((u64) (A)) * sizeof(struct squashfs_xattr_id))
 
 #define SQUASHFS_XATTR_BLOCK(A)		(SQUASHFS_XATTR_BYTES(A) / \
 					SQUASHFS_METADATA_SIZE)
diff --git a/fs/squashfs/squashfs_fs_sb.h b/fs/squashfs/squashfs_fs_sb.h
index 659082e9e51d..72f6f4b37863 100644
--- a/fs/squashfs/squashfs_fs_sb.h
+++ b/fs/squashfs/squashfs_fs_sb.h
@@ -63,7 +63,7 @@ struct squashfs_sb_info {
 	long long				bytes_used;
 	unsigned int				inodes;
 	unsigned int				fragments;
-	int					xattr_ids;
+	unsigned int				xattr_ids;
 	unsigned int				ids;
 	bool					panic_on_errors;
 	const struct squashfs_decompressor_thread_ops *thread_ops;
diff --git a/fs/squashfs/xattr.h b/fs/squashfs/xattr.h
index d8a270d3ac4c..f1a463d8bfa0 100644
--- a/fs/squashfs/xattr.h
+++ b/fs/squashfs/xattr.h
@@ -10,12 +10,12 @@
 
 #ifdef CONFIG_SQUASHFS_XATTR
 extern __le64 *squashfs_read_xattr_id_table(struct super_block *, u64,
-		u64 *, int *);
+		u64 *, unsigned int *);
 extern int squashfs_xattr_lookup(struct super_block *, unsigned int, int *,
 		unsigned int *, unsigned long long *);
 #else
 static inline __le64 *squashfs_read_xattr_id_table(struct super_block *sb,
-		u64 start, u64 *xattr_table_start, int *xattr_ids)
+		u64 start, u64 *xattr_table_start, unsigned int *xattr_ids)
 {
 	struct squashfs_xattr_id_table *id_table;
 
diff --git a/fs/squashfs/xattr_id.c b/fs/squashfs/xattr_id.c
index 087cab8c78f4..c8469c656e0d 100644
--- a/fs/squashfs/xattr_id.c
+++ b/fs/squashfs/xattr_id.c
@@ -56,7 +56,7 @@ int squashfs_xattr_lookup(struct super_block *sb, unsigned int index,
  * Read uncompressed xattr id lookup table indexes from disk into memory
  */
 __le64 *squashfs_read_xattr_id_table(struct super_block *sb, u64 table_start,
-		u64 *xattr_table_start, int *xattr_ids)
+		u64 *xattr_table_start, unsigned int *xattr_ids)
 {
 	struct squashfs_sb_info *msblk = sb->s_fs_info;
 	unsigned int len, indexes;
-- 
2.35.1

