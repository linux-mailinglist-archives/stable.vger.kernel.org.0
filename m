Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 785FA69CD10
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:46:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232274AbjBTNqN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:46:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232266AbjBTNqM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:46:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A1911CF65
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:45:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B3004B80B96
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:45:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E14CC4339B;
        Mon, 20 Feb 2023 13:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900736;
        bh=HhdooBA5Ohf1dNUBemrq4hCsre8hIW+cTNUnOvOVt/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GTXCg/kBub23dpVF50svRSAkeSC/YRko6139lw9A6rO5T5T3fZHcIuih8R00PJDRu
         llreXxTFVhNKJCbeFTJsALvvQuTO9yOzlWBLZ8L1oNaxIQe4yaXABjlje1dJII+THv
         zlE+Fq9tnQ+SNzxVUJXdYmOt3i8iMbhhyFAemPck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Phillip Lougher <phillip@squashfs.org.uk>,
        syzbot+082fa4af80a5bb1a9843@syzkaller.appspotmail.com,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Fedor Pchelkin <pchelkin@ispras.ru>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.4 049/156] Squashfs: fix handling and sanity checking of xattr_ids count
Date:   Mon, 20 Feb 2023 14:34:53 +0100
Message-Id: <20230220133604.398239218@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>
References: <20230220133602.515342638@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Phillip Lougher <phillip@squashfs.org.uk>

commit f65c4bbbd682b0877b669828b4e033b8d5d0a2dc upstream.

A Sysbot [1] corrupted filesystem exposes two flaws in the handling and
sanity checking of the xattr_ids count in the filesystem.  Both of these
flaws cause computation overflow due to incorrect typing.

In the corrupted filesystem the xattr_ids value is 4294967071, which
stored in a signed variable becomes the negative number -225.

Flaw 1 (64-bit systems only):

The signed integer xattr_ids variable causes sign extension.

This causes variable overflow in the SQUASHFS_XATTR_*(A) macros.  The
variable is first multiplied by sizeof(struct squashfs_xattr_id) where the
type of the sizeof operator is "unsigned long".

On a 64-bit system this is 64-bits in size, and causes the negative number
to be sign extended and widened to 64-bits and then become unsigned.  This
produces the very large number 18446744073709548016 or 2^64 - 3600.  This
number when rounded up by SQUASHFS_METADATA_SIZE - 1 (8191 bytes) and
divided by SQUASHFS_METADATA_SIZE overflows and produces a length of 0
(stored in len).

Flaw 2 (32-bit systems only):

On a 32-bit system the integer variable is not widened by the unsigned
long type of the sizeof operator (32-bits), and the signedness of the
variable has no effect due it always being treated as unsigned.

The above corrupted xattr_ids value of 4294967071, when multiplied
overflows and produces the number 4294963696 or 2^32 - 3400.  This number
when rounded up by SQUASHFS_METADATA_SIZE - 1 (8191 bytes) and divided by
SQUASHFS_METADATA_SIZE overflows again and produces a length of 0.

The effect of the 0 length computation:

In conjunction with the corrupted xattr_ids field, the filesystem also has
a corrupted xattr_table_start value, where it matches the end of
filesystem value of 850.

This causes the following sanity check code to fail because the
incorrectly computed len of 0 matches the incorrect size of the table
reported by the superblock (0 bytes).

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

Changing the xattr_ids variable to be "usigned int" fixes the flaw on a
64-bit system.  This relies on the fact the computation is widened by the
unsigned long type of the sizeof operator.

Casting the variable to u64 in the above macro fixes this flaw on a 32-bit
system.

It also means 64-bit systems do not implicitly rely on the type of the
sizeof operator to widen the computation.

[1] https://lore.kernel.org/lkml/000000000000cd44f005f1a0f17f@google.com/

Link: https://lkml.kernel.org/r/20230127061842.10965-1-phillip@squashfs.org.uk
Fixes: 506220d2ba21 ("squashfs: add more sanity checks in xattr id lookup")
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Reported-by: <syzbot+082fa4af80a5bb1a9843@syzkaller.appspotmail.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Fedor Pchelkin <pchelkin@ispras.ru>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/squashfs/squashfs_fs.h    |    2 +-
 fs/squashfs/squashfs_fs_sb.h |    2 +-
 fs/squashfs/xattr.h          |    4 ++--
 fs/squashfs/xattr_id.c       |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

--- a/fs/squashfs/squashfs_fs.h
+++ b/fs/squashfs/squashfs_fs.h
@@ -183,7 +183,7 @@ static inline int squashfs_block_size(__
 #define SQUASHFS_ID_BLOCK_BYTES(A)	(SQUASHFS_ID_BLOCKS(A) *\
 					sizeof(u64))
 /* xattr id lookup table defines */
-#define SQUASHFS_XATTR_BYTES(A)		((A) * sizeof(struct squashfs_xattr_id))
+#define SQUASHFS_XATTR_BYTES(A)		(((u64) (A)) * sizeof(struct squashfs_xattr_id))
 
 #define SQUASHFS_XATTR_BLOCK(A)		(SQUASHFS_XATTR_BYTES(A) / \
 					SQUASHFS_METADATA_SIZE)
--- a/fs/squashfs/squashfs_fs_sb.h
+++ b/fs/squashfs/squashfs_fs_sb.h
@@ -63,7 +63,7 @@ struct squashfs_sb_info {
 	long long				bytes_used;
 	unsigned int				inodes;
 	unsigned int				fragments;
-	int					xattr_ids;
+	unsigned int				xattr_ids;
 	unsigned int				ids;
 };
 #endif
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
 
--- a/fs/squashfs/xattr_id.c
+++ b/fs/squashfs/xattr_id.c
@@ -56,7 +56,7 @@ int squashfs_xattr_lookup(struct super_b
  * Read uncompressed xattr id lookup table indexes from disk into memory
  */
 __le64 *squashfs_read_xattr_id_table(struct super_block *sb, u64 table_start,
-		u64 *xattr_table_start, int *xattr_ids)
+		u64 *xattr_table_start, unsigned int *xattr_ids)
 {
 	struct squashfs_sb_info *msblk = sb->s_fs_info;
 	unsigned int len, indexes;


