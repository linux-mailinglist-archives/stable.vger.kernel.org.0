Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50AEE17B6B8
	for <lists+stable@lfdr.de>; Fri,  6 Mar 2020 07:28:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbgCFG2h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Mar 2020 01:28:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:36360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725853AbgCFG2h (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Mar 2020 01:28:37 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D06A720866;
        Fri,  6 Mar 2020 06:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583476117;
        bh=KU1tSKe/m0KQSCY4RiUcf8+atSOe8EGaBGirOxcvx44=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=yFMUJTP4Kj34A8gyE7oho9vX0PZ4lHnsmxtBizGPUkqk1TUxzmnrMEaIN50VsiKvY
         u83ig1ZGVtVU0KVbm6dIPuLEWIQYIrTfAuVCLSOFzB1zfsUIr4xWYdntqkUlBnZrBn
         IxVwPvPZMemmE4cpxb2zH7pasKvV00ScKMHIgWXY=
Date:   Thu, 05 Mar 2020 22:28:36 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hirofumi@mail.parknet.co.jp,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 4/7] fat: fix uninit-memory access for partial
 initialized inode
Message-ID: <20200306062836.JsWi6MsBE%akpm@linux-foundation.org>
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
