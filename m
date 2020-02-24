Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 256C7169CC0
	for <lists+stable@lfdr.de>; Mon, 24 Feb 2020 04:53:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727168AbgBXDxQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Feb 2020 22:53:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:52340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727166AbgBXDxQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 23 Feb 2020 22:53:16 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A34B20675;
        Mon, 24 Feb 2020 03:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582516393;
        bh=Zi/CTNYcRp0z3HUkkApfXy20JAw9tXXfObcAyzmFaiQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=me2gF3ch8ecEDkrXi09zgnplpXCGhid7FcxWt3P6wvjaqE3VD9mtyM9+u8z/0muig
         /DLvL4VE+lRmVsSz5TpDXuCldc9Tkq6Zr/CcfwJFR7plzKYGvXIGgZI8Xmv4f4L/s3
         jevELeBJlnOMW1rbfuh/cP6xnoLoGoxaYj91inhk=
Date:   Sun, 23 Feb 2020 19:53:13 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org,
        stable@vger.kernel.org
Subject:  +
 fat-fix-uninit-memory-access-for-partial-initialized-inode.patch added to
 -mm tree
Message-ID: <20200224035313.g57L75EAv%akpm@linux-foundation.org>
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: fat: fix uninit-memory access for partial initialized inode
has been added to the -mm tree.  Its filename is
     fat-fix-uninit-memory-access-for-partial-initialized-inode.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fat-fix-uninit-memory-access-for-partial-initialized-inode.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fat-fix-uninit-memory-access-for-partial-initialized-inode.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

fat-fix-uninit-memory-access-for-partial-initialized-inode.patch

