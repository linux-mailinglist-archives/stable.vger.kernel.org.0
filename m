Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68157420EB1
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236889AbhJDN13 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:27:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:38132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236904AbhJDNZ3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:25:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D03B461BFA;
        Mon,  4 Oct 2021 13:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353074;
        bh=mLPb6hulsMq1lTMNvsdsnk8XTYdT/BNwE/91kPs/tvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d2i/88q2TfbtqYMr3dcenp9sBGrwa2kbYRbE3Im0DogIvlD0no7ddYl6YR7raJnix
         lUlq8P8evjllVmlDoMWyqqbFMaiqFlB+m7odMxasCcgSox1XZL09UiG+yLJiDs4MwI
         y0QKcA+1NREyiw88CIWzs27IotyTNKWrmssLC3qk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Harshad Shirwadkar <harshadshirwadkar@gmail.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.10 79/93] ext4: add error checking to ext4_ext_replay_set_iblocks()
Date:   Mon,  4 Oct 2021 14:53:17 +0200
Message-Id: <20211004125037.199914705@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125034.579439135@linuxfoundation.org>
References: <20211004125034.579439135@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

commit 1fd95c05d8f742abfe906620780aee4dbe1a2db0 upstream.

If the call to ext4_map_blocks() fails due to an corrupted file
system, ext4_ext_replay_set_iblocks() can get stuck in an infinite
loop.  This could be reproduced by running generic/526 with a file
system that has inline_data and fast_commit enabled.  The system will
repeatedly log to the console:

EXT4-fs warning (device dm-3): ext4_block_to_path:105: block 1074800922 > max in inode 131076

and the stack that it gets stuck in is:

   ext4_block_to_path+0xe3/0x130
   ext4_ind_map_blocks+0x93/0x690
   ext4_map_blocks+0x100/0x660
   skip_hole+0x47/0x70
   ext4_ext_replay_set_iblocks+0x223/0x440
   ext4_fc_replay_inode+0x29e/0x3b0
   ext4_fc_replay+0x278/0x550
   do_one_pass+0x646/0xc10
   jbd2_journal_recover+0x14a/0x270
   jbd2_journal_load+0xc4/0x150
   ext4_load_journal+0x1f3/0x490
   ext4_fill_super+0x22d4/0x2c00

With this patch, generic/526 still fails, but system is no longer
locking up in a tight loop.  It's likely the root casue is that
fast_commit replay is corrupting file systems with inline_data, and we
probably need to add better error handling in the fast commit replay
code path beyond what is done here, which essentially just breaks the
infinite loop without reporting the to the higher levels of the code.

Fixes: 8016E29F4362 ("ext4: fast commit recovery path")
Cc: stable@kernel.org
Cc: Harshad Shirwadkar <harshadshirwadkar@gmail.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/extents.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5907,7 +5907,7 @@ void ext4_ext_replay_shrink_inode(struct
 }
 
 /* Check if *cur is a hole and if it is, skip it */
-static void skip_hole(struct inode *inode, ext4_lblk_t *cur)
+static int skip_hole(struct inode *inode, ext4_lblk_t *cur)
 {
 	int ret;
 	struct ext4_map_blocks map;
@@ -5916,9 +5916,12 @@ static void skip_hole(struct inode *inod
 	map.m_len = ((inode->i_size) >> inode->i_sb->s_blocksize_bits) - *cur;
 
 	ret = ext4_map_blocks(NULL, inode, &map, 0);
+	if (ret < 0)
+		return ret;
 	if (ret != 0)
-		return;
+		return 0;
 	*cur = *cur + map.m_len;
+	return 0;
 }
 
 /* Count number of blocks used by this inode and update i_blocks */
@@ -5967,7 +5970,9 @@ int ext4_ext_replay_set_iblocks(struct i
 	 * iblocks by total number of differences found.
 	 */
 	cur = 0;
-	skip_hole(inode, &cur);
+	ret = skip_hole(inode, &cur);
+	if (ret < 0)
+		goto out;
 	path = ext4_find_extent(inode, cur, NULL, 0);
 	if (IS_ERR(path))
 		goto out;
@@ -5986,8 +5991,12 @@ int ext4_ext_replay_set_iblocks(struct i
 		}
 		cur = max(cur + 1, le32_to_cpu(ex->ee_block) +
 					ext4_ext_get_actual_len(ex));
-		skip_hole(inode, &cur);
-
+		ret = skip_hole(inode, &cur);
+		if (ret < 0) {
+			ext4_ext_drop_refs(path);
+			kfree(path);
+			break;
+		}
 		path2 = ext4_find_extent(inode, cur, NULL, 0);
 		if (IS_ERR(path2)) {
 			ext4_ext_drop_refs(path);


