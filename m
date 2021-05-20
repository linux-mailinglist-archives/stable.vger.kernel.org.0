Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2058A38AA6C
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239685AbhETLNU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:13:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:55136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239689AbhETLLS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:11:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1FD861D4D;
        Thu, 20 May 2021 10:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505245;
        bh=N4uXevds4A1zJg1CGplbyIBjGFHqkwZUzcdNuCr9M0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rD6DDk9xAPOAMCG0VU/J/AqyWrQhf3+c+2dD4XdvJEEEyyW2XIV/D3VunfDM6fdJa
         vRA9/HjTSjmRNwmQoOC+IOMe3jRWnhap9m5Cv79M81Lp1Lvj/XELLJAr7qfqFcyiLM
         HHmse12bqGHRyLn1Rj5MLfKMQWDbMQO5tcQzxVFM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Zhang Yi <yi.zhang@huawei.com>, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.4 048/190] ext4: fix check to prevent false positive report of incorrect used inodes
Date:   Thu, 20 May 2021 11:21:52 +0200
Message-Id: <20210520092103.758561686@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092102.149300807@linuxfoundation.org>
References: <20210520092102.149300807@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Yi <yi.zhang@huawei.com>

commit a149d2a5cabbf6507a7832a1c4fd2593c55fd450 upstream.

Commit <50122847007> ("ext4: fix check to prevent initializing reserved
inodes") check the block group zero and prevent initializing reserved
inodes. But in some special cases, the reserved inode may not all belong
to the group zero, it may exist into the second group if we format
filesystem below.

  mkfs.ext4 -b 4096 -g 8192 -N 1024 -I 4096 /dev/sda

So, it will end up triggering a false positive report of a corrupted
file system. This patch fix it by avoid check reserved inodes if no free
inode blocks will be zeroed.

Cc: stable@kernel.org
Fixes: 50122847007 ("ext4: fix check to prevent initializing reserved inodes")
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Suggested-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20210331121516.2243099-1-yi.zhang@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/ialloc.c |   48 ++++++++++++++++++++++++++++++++----------------
 1 file changed, 32 insertions(+), 16 deletions(-)

--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -1278,6 +1278,7 @@ int ext4_init_inode_table(struct super_b
 	handle_t *handle;
 	ext4_fsblk_t blk;
 	int num, ret = 0, used_blks = 0;
+	unsigned long used_inos = 0;
 
 	/* This should not happen, but just to be sure check this */
 	if (sb->s_flags & MS_RDONLY) {
@@ -1308,22 +1309,37 @@ int ext4_init_inode_table(struct super_b
 	 * used inodes so we need to skip blocks with used inodes in
 	 * inode table.
 	 */
-	if (!(gdp->bg_flags & cpu_to_le16(EXT4_BG_INODE_UNINIT)))
-		used_blks = DIV_ROUND_UP((EXT4_INODES_PER_GROUP(sb) -
-			    ext4_itable_unused_count(sb, gdp)),
-			    sbi->s_inodes_per_block);
-
-	if ((used_blks < 0) || (used_blks > sbi->s_itb_per_group) ||
-	    ((group == 0) && ((EXT4_INODES_PER_GROUP(sb) -
-			       ext4_itable_unused_count(sb, gdp)) <
-			      EXT4_FIRST_INO(sb)))) {
-		ext4_error(sb, "Something is wrong with group %u: "
-			   "used itable blocks: %d; "
-			   "itable unused count: %u",
-			   group, used_blks,
-			   ext4_itable_unused_count(sb, gdp));
-		ret = 1;
-		goto err_out;
+	if (!(gdp->bg_flags & cpu_to_le16(EXT4_BG_INODE_UNINIT))) {
+		used_inos = EXT4_INODES_PER_GROUP(sb) -
+			    ext4_itable_unused_count(sb, gdp);
+		used_blks = DIV_ROUND_UP(used_inos, sbi->s_inodes_per_block);
+
+		/* Bogus inode unused count? */
+		if (used_blks < 0 || used_blks > sbi->s_itb_per_group) {
+			ext4_error(sb, "Something is wrong with group %u: "
+				   "used itable blocks: %d; "
+				   "itable unused count: %u",
+				   group, used_blks,
+				   ext4_itable_unused_count(sb, gdp));
+			ret = 1;
+			goto err_out;
+		}
+
+		used_inos += group * EXT4_INODES_PER_GROUP(sb);
+		/*
+		 * Are there some uninitialized inodes in the inode table
+		 * before the first normal inode?
+		 */
+		if ((used_blks != sbi->s_itb_per_group) &&
+		     (used_inos < EXT4_FIRST_INO(sb))) {
+			ext4_error(sb, "Something is wrong with group %u: "
+				   "itable unused count: %u; "
+				   "itables initialized count: %ld",
+				   group, ext4_itable_unused_count(sb, gdp),
+				   used_inos);
+			ret = 1;
+			goto err_out;
+		}
 	}
 
 	blk = ext4_inode_table(sb, gdp) + used_blks;


