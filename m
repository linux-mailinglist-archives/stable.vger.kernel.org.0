Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A43E17FE48
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728121AbgCJNeQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:34:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:50366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727770AbgCJMqs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:46:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5E5E20674;
        Tue, 10 Mar 2020 12:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844408;
        bh=xl9wnhembeDGjI5M84bf2op9bwgLmvBsjfk6ygNAZLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Noc3yvZryMFfY7BlwPlH8B1Sjel82msnfrGwnD35gps/VFB33HL2gCQBWjSQkADwj
         J7a4UYE360YSj+5nBYe1xo5oEYC0igyZsYeTV37po2Bj6E6bqQ9ZKsi7J/DBbibNiL
         iP2+JKWn1WeCiMXkvTVYmQe6ZkvWgvMH2Q6WkU0w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+9d82b8de2992579da5d0@syzkaller.appspotmail.com,
        Andrew Morton <akpm@linux-foundation.org>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.9 69/88] fat: fix uninit-memory access for partial initialized inode
Date:   Tue, 10 Mar 2020 13:39:17 +0100
Message-Id: <20200310123623.092076720@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123606.543939933@linuxfoundation.org>
References: <20200310123606.543939933@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

commit bc87302a093f0eab45cd4e250c2021299f712ec6 upstream.

When get an error in the middle of reading an inode, some fields in the
inode might be still not initialized.  And then the evict_inode path may
access those fields via iput().

To fix, this makes sure that inode fields are initialized.

Reported-by: syzbot+9d82b8de2992579da5d0@syzkaller.appspotmail.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/871rqnreqx.fsf@mail.parknet.co.jp
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/fat/inode.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -736,6 +736,13 @@ static struct inode *fat_alloc_inode(str
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
 
@@ -1366,16 +1373,6 @@ out:
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
@@ -1820,13 +1817,11 @@ int fat_fill_super(struct super_block *s
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


