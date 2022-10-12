Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A36F5FBF04
	for <lists+stable@lfdr.de>; Wed, 12 Oct 2022 04:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbiJLCGP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 22:06:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiJLCGM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 22:06:12 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 129335924B;
        Tue, 11 Oct 2022 19:06:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 13D4BCE1A95;
        Wed, 12 Oct 2022 02:06:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 357D3C433D6;
        Wed, 12 Oct 2022 02:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665540365;
        bh=ustdc5Ka9P+PhJ5oP4t1U2yFR5imlrzZWKZYa0TFqEY=;
        h=Date:To:From:Subject:From;
        b=IiFceTr+eyv7A4X90EaTCiX8rNbC7k3VyxicrWpE6HlU/mUt2VgDfIjyQ4KtgUofL
         WS5Li3CxWz8dsoOAeSvolBD9mqQz1S0IHwWjYh27rqaBQWAFdPfU1DWPs6IZLrqYG5
         qqrINLpe85q8be4Kj4jwnwHP+DTsR9jBgY7Wbj/o=
Date:   Tue, 11 Oct 2022 19:06:04 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        khalid.masum.92@gmail.com, konishi.ryusuke@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] nilfs2-fix-use-after-free-bug-of-struct-nilfs_root.patch removed from -mm tree
Message-Id: <20221012020605.357D3C433D6@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: nilfs2: fix use-after-free bug of struct nilfs_root
has been removed from the -mm tree.  Its filename was
     nilfs2-fix-use-after-free-bug-of-struct-nilfs_root.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: fix use-after-free bug of struct nilfs_root
Date: Tue, 4 Oct 2022 00:05:19 +0900

If the beginning of the inode bitmap area is corrupted on disk, an inode
with the same inode number as the root inode can be allocated and fail
soon after.  In this case, the subsequent call to nilfs_clear_inode() on
that bogus root inode will wrongly decrement the reference counter of
struct nilfs_root, and this will erroneously free struct nilfs_root,
causing kernel oopses.

This fixes the problem by changing nilfs_new_inode() to skip reserved
inode numbers while repairing the inode bitmap.

Link: https://lkml.kernel.org/r/20221003150519.39789-1-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+b8c672b0e22615c80fe0@syzkaller.appspotmail.com
Reported-by: Khalid Masum <khalid.masum.92@gmail.com>
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/inode.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

--- a/fs/nilfs2/inode.c~nilfs2-fix-use-after-free-bug-of-struct-nilfs_root
+++ a/fs/nilfs2/inode.c
@@ -328,6 +328,7 @@ struct inode *nilfs_new_inode(struct ino
 	struct inode *inode;
 	struct nilfs_inode_info *ii;
 	struct nilfs_root *root;
+	struct buffer_head *bh;
 	int err = -ENOMEM;
 	ino_t ino;
 
@@ -343,11 +344,25 @@ struct inode *nilfs_new_inode(struct ino
 	ii->i_state = BIT(NILFS_I_NEW);
 	ii->i_root = root;
 
-	err = nilfs_ifile_create_inode(root->ifile, &ino, &ii->i_bh);
+	err = nilfs_ifile_create_inode(root->ifile, &ino, &bh);
 	if (unlikely(err))
 		goto failed_ifile_create_inode;
 	/* reference count of i_bh inherits from nilfs_mdt_read_block() */
 
+	if (unlikely(ino < NILFS_USER_INO)) {
+		nilfs_warn(sb,
+			   "inode bitmap is inconsistent for reserved inodes");
+		do {
+			brelse(bh);
+			err = nilfs_ifile_create_inode(root->ifile, &ino, &bh);
+			if (unlikely(err))
+				goto failed_ifile_create_inode;
+		} while (ino < NILFS_USER_INO);
+
+		nilfs_info(sb, "repaired inode bitmap for reserved inodes");
+	}
+	ii->i_bh = bh;
+
 	atomic64_inc(&root->inodes_count);
 	inode_init_owner(&init_user_ns, inode, dir, mode);
 	inode->i_ino = ino;
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-fix-null-pointer-dereference-at-nilfs_bmap_lookup_at_level.patch
nilfs2-fix-leak-of-nilfs_root-in-case-of-writer-thread-creation-failure.patch

