Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECC6E17CBDA
	for <lists+stable@lfdr.de>; Sat,  7 Mar 2020 05:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbgCGEBY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Mar 2020 23:01:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:50344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbgCGEBX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Mar 2020 23:01:23 -0500
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FE70206D5;
        Sat,  7 Mar 2020 04:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583553683;
        bh=B21Pu0Ryc2/0PXHYkY+HC/Vai/qxkHvM+ukG59mumWc=;
        h=Date:From:To:Subject:From;
        b=gQdTZTzOT5yzbOoZ6OaWxNmYr3O6io+63NJ8w1B19j2acBBMXp27o5IexO5omh8YO
         HC+duHGOedul+LLUB9oj7/MRFS1pj5HXCeBA2bCFhDg/ExMdxeU9gy1ySbEquMyvOg
         jkPtFMgB0ccQvXAZh+i/uPGlj2PDzXdMuo3lQ4IE=
Date:   Fri, 06 Mar 2020 20:01:23 -0800
From:   akpm@linux-foundation.org
To:     hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org,
        stable@vger.kernel.org
Subject:  [merged]
 fat-fix-uninit-memory-access-for-partial-initialized-inode.patch removed
 from -mm tree
Message-ID: <20200307040123.dgX5RB-O8%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: fat: fix uninit-memory access for partial initialized inode
has been removed from the -mm tree.  Its filename was
     fat-fix-uninit-memory-access-for-partial-initialized-inode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: fat: fix uninit-memory access for partial initialized inode

When get an error in the middle of reading an inode, some fields in the
inode might be still not initialized.  And then the evict_inode path may
access those fields via iput().

To fix, this makes sure that inode fields are initialized.

Link: http://lkml.kernel.org/r/871rqnreqx.fsf@mail.parknet.co.jp
Reported-by: syzbot+9d82b8de2992579da5d0@syzkaller.appspotmail.com
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/inode.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

--- a/fs/fat/inode.c~fat-fix-uninit-memory-access-for-partial-initialized-inode
+++ a/fs/fat/inode.c
@@ -750,6 +750,13 @@ static struct inode *fat_alloc_inode(str
 		return NULL;
 
 	init_rwsem(&ei->truncate_lock);
+	/* Zeroing to allow iput() even if partial initialized inode. */
+	ei->mmu_private = 0;
+	ei->i_start = 0;
+	ei->i_logstart = 0;
+	ei->i_attrs = 0;
+	ei->i_pos = 0;
+
 	return &ei->vfs_inode;
 }
 
@@ -1374,16 +1381,6 @@ out:
 	return 0;
 }
 
-static void fat_dummy_inode_init(struct inode *inode)
-{
-	/* Initialize this dummy inode to work as no-op. */
-	MSDOS_I(inode)->mmu_private = 0;
-	MSDOS_I(inode)->i_start = 0;
-	MSDOS_I(inode)->i_logstart = 0;
-	MSDOS_I(inode)->i_attrs = 0;
-	MSDOS_I(inode)->i_pos = 0;
-}
-
 static int fat_read_root(struct inode *inode)
 {
 	struct msdos_sb_info *sbi = MSDOS_SB(inode->i_sb);
@@ -1844,13 +1841,11 @@ int fat_fill_super(struct super_block *s
 	fat_inode = new_inode(sb);
 	if (!fat_inode)
 		goto out_fail;
-	fat_dummy_inode_init(fat_inode);
 	sbi->fat_inode = fat_inode;
 
 	fsinfo_inode = new_inode(sb);
 	if (!fsinfo_inode)
 		goto out_fail;
-	fat_dummy_inode_init(fsinfo_inode);
 	fsinfo_inode->i_ino = MSDOS_FSINFO_INO;
 	sbi->fsinfo_inode = fsinfo_inode;
 	insert_inode_hash(fsinfo_inode);
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are


