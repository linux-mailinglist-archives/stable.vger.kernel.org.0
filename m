Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C88267F212
	for <lists+stable@lfdr.de>; Sat, 28 Jan 2023 00:10:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbjA0XKG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 18:10:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbjA0XKF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 18:10:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BED49FF20;
        Fri, 27 Jan 2023 15:10:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A05B61DAE;
        Fri, 27 Jan 2023 23:10:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B43FEC433EF;
        Fri, 27 Jan 2023 23:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674861003;
        bh=dMs02SWS9CPnaJG/ya6+cSu4ojBBHhe+bgPmVn3PUHI=;
        h=Date:To:From:Subject:From;
        b=KFtQKTiivIQdOOY0Ds+lSS6iRhaFspeTUnWxy0niJu/YC4XkZmed9O61Rx2d6rRY5
         NWcfnGM7j32I5WOq7ezvfZeHLC8RkjiAcMvd//mM2HW2la4OJ8AYo7RWBJjq7hyjJa
         t1WAKJwHZLnh1sqNGURLqBYz9t47lwzheMqjoj2U=
Date:   Fri, 27 Jan 2023 15:10:03 -0800
To:     mm-commits@vger.kernel.org,
        syzbot+082fa4af80a5bb1a9843@syzkaller.appspotmail.com,
        stable@vger.kernel.org, pchelkin@ispras.ru, khoroshilov@ispras.ru,
        phillip@squashfs.org.uk, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-fix-handling-and-sanity-checking-of-xattr_ids-count.patch added to mm-hotfixes-unstable branch
Message-Id: <20230127231003.B43FEC433EF@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: Squashfs: fix handling and sanity checking of xattr_ids count
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     squashfs-fix-handling-and-sanity-checking-of-xattr_ids-count.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-fix-handling-and-sanity-checking-of-xattr_ids-count.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: Squashfs: fix handling and sanity checking of xattr_ids count
Date: Fri, 27 Jan 2023 06:18:42 +0000

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
---


--- a/fs/squashfs/squashfs_fs.h~squashfs-fix-handling-and-sanity-checking-of-xattr_ids-count
+++ a/fs/squashfs/squashfs_fs.h
@@ -183,7 +183,7 @@ static inline int squashfs_block_size(__
 #define SQUASHFS_ID_BLOCK_BYTES(A)	(SQUASHFS_ID_BLOCKS(A) *\
 					sizeof(u64))
 /* xattr id lookup table defines */
-#define SQUASHFS_XATTR_BYTES(A)		((A) * sizeof(struct squashfs_xattr_id))
+#define SQUASHFS_XATTR_BYTES(A)		(((u64) (A)) * sizeof(struct squashfs_xattr_id))
 
 #define SQUASHFS_XATTR_BLOCK(A)		(SQUASHFS_XATTR_BYTES(A) / \
 					SQUASHFS_METADATA_SIZE)
--- a/fs/squashfs/squashfs_fs_sb.h~squashfs-fix-handling-and-sanity-checking-of-xattr_ids-count
+++ a/fs/squashfs/squashfs_fs_sb.h
@@ -63,7 +63,7 @@ struct squashfs_sb_info {
 	long long				bytes_used;
 	unsigned int				inodes;
 	unsigned int				fragments;
-	int					xattr_ids;
+	unsigned int				xattr_ids;
 	unsigned int				ids;
 	bool					panic_on_errors;
 	const struct squashfs_decompressor_thread_ops *thread_ops;
--- a/fs/squashfs/xattr.h~squashfs-fix-handling-and-sanity-checking-of-xattr_ids-count
+++ a/fs/squashfs/xattr.h
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
 
--- a/fs/squashfs/xattr_id.c~squashfs-fix-handling-and-sanity-checking-of-xattr_ids-count
+++ a/fs/squashfs/xattr_id.c
@@ -56,7 +56,7 @@ int squashfs_xattr_lookup(struct super_b
  * Read uncompressed xattr id lookup table indexes from disk into memory
  */
 __le64 *squashfs_read_xattr_id_table(struct super_block *sb, u64 table_start,
-		u64 *xattr_table_start, int *xattr_ids)
+		u64 *xattr_table_start, unsigned int *xattr_ids)
 {
 	struct squashfs_sb_info *msblk = sb->s_fs_info;
 	unsigned int len, indexes;
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are

squashfs-fix-handling-and-sanity-checking-of-xattr_ids-count.patch

