Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86B3B24B405
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 11:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729976AbgHTJzu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:55:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:38932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730048AbgHTJzs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:55:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 931022078D;
        Thu, 20 Aug 2020 09:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917348;
        bh=SVS21djZw9/LqBL4/NWJn5UrOM1V2Waxvqw8K5pIbbk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dD/7Owz//WfdzrFRUK3pQwyqu3NtOrJMwgL0ZXEVtKR8aFFoMIXdr9q6Wk4Npj3QO
         I3yuxdcEyi20B1onDFSlk70Zl1MM2TOWVqf0NPQa6wP4BJi2lT9pO8VCb805l6HWy+
         937pctVKbjJEiGzADNEzeFdzWq7d0nkFKLs+upNA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Qiujun Huang <anenbupt@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 78/92] fs/minix: set s_maxbytes correctly
Date:   Thu, 20 Aug 2020 11:22:03 +0200
Message-Id: <20200820091541.715985654@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091537.490965042@linuxfoundation.org>
References: <20200820091537.490965042@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit 32ac86efff91a3e4ef8c3d1cadd4559e23c8e73a ]

The minix filesystem leaves super_block::s_maxbytes at MAX_NON_LFS rather
than setting it to the actual filesystem-specific limit.  This is broken
because it means userspace doesn't see the standard behavior like getting
EFBIG and SIGXFSZ when exceeding the maximum file size.

Fix this by setting s_maxbytes correctly.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Qiujun Huang <anenbupt@gmail.com>
Link: http://lkml.kernel.org/r/20200628060846.682158-5-ebiggers@kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/minix/inode.c    | 12 +++++++-----
 fs/minix/itree_v1.c |  2 +-
 fs/minix/itree_v2.c |  3 +--
 fs/minix/minix.h    |  1 -
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/minix/inode.c b/fs/minix/inode.c
index 4f994de46e6b9..03fe8bac36cf4 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -155,8 +155,10 @@ static int minix_remount (struct super_block * sb, int * flags, char * data)
 	return 0;
 }
 
-static bool minix_check_superblock(struct minix_sb_info *sbi)
+static bool minix_check_superblock(struct super_block *sb)
 {
+	struct minix_sb_info *sbi = minix_sb(sb);
+
 	if (sbi->s_imap_blocks == 0 || sbi->s_zmap_blocks == 0)
 		return false;
 
@@ -166,7 +168,7 @@ static bool minix_check_superblock(struct minix_sb_info *sbi)
 	 * of indirect blocks which places the limit well above U32_MAX.
 	 */
 	if (sbi->s_version == MINIX_V1 &&
-	    sbi->s_max_size > (7 + 512 + 512*512) * BLOCK_SIZE)
+	    sb->s_maxbytes > (7 + 512 + 512*512) * BLOCK_SIZE)
 		return false;
 
 	return true;
@@ -207,7 +209,7 @@ static int minix_fill_super(struct super_block *s, void *data, int silent)
 	sbi->s_zmap_blocks = ms->s_zmap_blocks;
 	sbi->s_firstdatazone = ms->s_firstdatazone;
 	sbi->s_log_zone_size = ms->s_log_zone_size;
-	sbi->s_max_size = ms->s_max_size;
+	s->s_maxbytes = ms->s_max_size;
 	s->s_magic = ms->s_magic;
 	if (s->s_magic == MINIX_SUPER_MAGIC) {
 		sbi->s_version = MINIX_V1;
@@ -238,7 +240,7 @@ static int minix_fill_super(struct super_block *s, void *data, int silent)
 		sbi->s_zmap_blocks = m3s->s_zmap_blocks;
 		sbi->s_firstdatazone = m3s->s_firstdatazone;
 		sbi->s_log_zone_size = m3s->s_log_zone_size;
-		sbi->s_max_size = m3s->s_max_size;
+		s->s_maxbytes = m3s->s_max_size;
 		sbi->s_ninodes = m3s->s_ninodes;
 		sbi->s_nzones = m3s->s_zones;
 		sbi->s_dirsize = 64;
@@ -250,7 +252,7 @@ static int minix_fill_super(struct super_block *s, void *data, int silent)
 	} else
 		goto out_no_fs;
 
-	if (!minix_check_superblock(sbi))
+	if (!minix_check_superblock(s))
 		goto out_illegal_sb;
 
 	/*
diff --git a/fs/minix/itree_v1.c b/fs/minix/itree_v1.c
index 046cc96ee7adb..c0d418209ead1 100644
--- a/fs/minix/itree_v1.c
+++ b/fs/minix/itree_v1.c
@@ -29,7 +29,7 @@ static int block_to_path(struct inode * inode, long block, int offsets[DEPTH])
 	if (block < 0) {
 		printk("MINIX-fs: block_to_path: block %ld < 0 on dev %pg\n",
 			block, inode->i_sb->s_bdev);
-	} else if (block >= (minix_sb(inode->i_sb)->s_max_size/BLOCK_SIZE)) {
+	} else if (block >= inode->i_sb->s_maxbytes/BLOCK_SIZE) {
 		if (printk_ratelimit())
 			printk("MINIX-fs: block_to_path: "
 			       "block %ld too big on dev %pg\n",
diff --git a/fs/minix/itree_v2.c b/fs/minix/itree_v2.c
index f7fc7eccccccd..ee8af2f9e2828 100644
--- a/fs/minix/itree_v2.c
+++ b/fs/minix/itree_v2.c
@@ -32,8 +32,7 @@ static int block_to_path(struct inode * inode, long block, int offsets[DEPTH])
 	if (block < 0) {
 		printk("MINIX-fs: block_to_path: block %ld < 0 on dev %pg\n",
 			block, sb->s_bdev);
-	} else if ((u64)block * (u64)sb->s_blocksize >=
-			minix_sb(sb)->s_max_size) {
+	} else if ((u64)block * (u64)sb->s_blocksize >= sb->s_maxbytes) {
 		if (printk_ratelimit())
 			printk("MINIX-fs: block_to_path: "
 			       "block %ld too big on dev %pg\n",
diff --git a/fs/minix/minix.h b/fs/minix/minix.h
index df081e8afcc3c..168d45d3de73e 100644
--- a/fs/minix/minix.h
+++ b/fs/minix/minix.h
@@ -32,7 +32,6 @@ struct minix_sb_info {
 	unsigned long s_zmap_blocks;
 	unsigned long s_firstdatazone;
 	unsigned long s_log_zone_size;
-	unsigned long s_max_size;
 	int s_dirsize;
 	int s_namelen;
 	struct buffer_head ** s_imap;
-- 
2.25.1



