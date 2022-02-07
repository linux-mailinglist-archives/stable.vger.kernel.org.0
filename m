Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3734ABC19
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:45:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384863AbiBGLaZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:30:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383914AbiBGLYD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:24:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6913C0401C2;
        Mon,  7 Feb 2022 03:24:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 546DEB81028;
        Mon,  7 Feb 2022 11:24:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EFC2C004E1;
        Mon,  7 Feb 2022 11:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233039;
        bh=jwWxuydULTtgYTV1nDL00L7tSOlEusY8iX84mfzayrc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jy0/sBa9uGH1l0MXX+U3Jv2KfhvIV99orl863kuQ+n+Kj5/lfSOkHL3Y+d5Oj+Koc
         eI6Off59Zh4Pu0t9OJK4dO85YM89rdAK2g5SyErKxPkstDjFtuVOd8xlB3h6DIqfCr
         8bsYCWMWVHXPoancbVT0iWxoXO6k/m7rgAP8Z3qk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, luo penghao <luo.penghao@zte.com.cn>,
        Lukas Czerner <lczerner@redhat.com>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
        stable@kernel.org
Subject: [PATCH 5.10 70/74] ext4: fix error handling in ext4_fc_record_modified_inode()
Date:   Mon,  7 Feb 2022 12:07:08 +0100
Message-Id: <20220207103759.525879295@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103757.232676988@linuxfoundation.org>
References: <20220207103757.232676988@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ritesh Harjani <riteshh@linux.ibm.com>

commit cdce59a1549190b66f8e3fe465c2b2f714b98a94 upstream.

Current code does not fully takes care of krealloc() error case, which
could lead to silent memory corruption or a kernel bug.  This patch
fixes that.

Also it cleans up some duplicated error handling logic from various
functions in fast_commit.c file.

Reported-by: luo penghao <luo.penghao@zte.com.cn>
Suggested-by: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Ritesh Harjani <riteshh@linux.ibm.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/62e8b6a1cce9359682051deb736a3c0953c9d1e9.1642416995.git.riteshh@linux.ibm.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/fast_commit.c |   64 ++++++++++++++++++++++----------------------------
 1 file changed, 29 insertions(+), 35 deletions(-)

--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -1388,14 +1388,15 @@ static int ext4_fc_record_modified_inode
 		if (state->fc_modified_inodes[i] == ino)
 			return 0;
 	if (state->fc_modified_inodes_used == state->fc_modified_inodes_size) {
-		state->fc_modified_inodes_size +=
-			EXT4_FC_REPLAY_REALLOC_INCREMENT;
 		state->fc_modified_inodes = krealloc(
-					state->fc_modified_inodes, sizeof(int) *
-					state->fc_modified_inodes_size,
-					GFP_KERNEL);
+				state->fc_modified_inodes,
+				sizeof(int) * (state->fc_modified_inodes_size +
+				EXT4_FC_REPLAY_REALLOC_INCREMENT),
+				GFP_KERNEL);
 		if (!state->fc_modified_inodes)
 			return -ENOMEM;
+		state->fc_modified_inodes_size +=
+			EXT4_FC_REPLAY_REALLOC_INCREMENT;
 	}
 	state->fc_modified_inodes[state->fc_modified_inodes_used++] = ino;
 	return 0;
@@ -1427,7 +1428,9 @@ static int ext4_fc_replay_inode(struct s
 	}
 	inode = NULL;
 
-	ext4_fc_record_modified_inode(sb, ino);
+	ret = ext4_fc_record_modified_inode(sb, ino);
+	if (ret)
+		goto out;
 
 	raw_fc_inode = (struct ext4_inode *)
 		(val + offsetof(struct ext4_fc_inode, fc_raw_inode));
@@ -1626,6 +1629,8 @@ static int ext4_fc_replay_add_range(stru
 	}
 
 	ret = ext4_fc_record_modified_inode(sb, inode->i_ino);
+	if (ret)
+		goto out;
 
 	start = le32_to_cpu(ex->ee_block);
 	start_pblk = ext4_ext_pblock(ex);
@@ -1643,18 +1648,14 @@ static int ext4_fc_replay_add_range(stru
 		map.m_pblk = 0;
 		ret = ext4_map_blocks(NULL, inode, &map, 0);
 
-		if (ret < 0) {
-			iput(inode);
-			return 0;
-		}
+		if (ret < 0)
+			goto out;
 
 		if (ret == 0) {
 			/* Range is not mapped */
 			path = ext4_find_extent(inode, cur, NULL, 0);
-			if (IS_ERR(path)) {
-				iput(inode);
-				return 0;
-			}
+			if (IS_ERR(path))
+				goto out;
 			memset(&newex, 0, sizeof(newex));
 			newex.ee_block = cpu_to_le32(cur);
 			ext4_ext_store_pblock(
@@ -1668,10 +1669,8 @@ static int ext4_fc_replay_add_range(stru
 			up_write((&EXT4_I(inode)->i_data_sem));
 			ext4_ext_drop_refs(path);
 			kfree(path);
-			if (ret) {
-				iput(inode);
-				return 0;
-			}
+			if (ret)
+				goto out;
 			goto next;
 		}
 
@@ -1684,10 +1683,8 @@ static int ext4_fc_replay_add_range(stru
 			ret = ext4_ext_replay_update_ex(inode, cur, map.m_len,
 					ext4_ext_is_unwritten(ex),
 					start_pblk + cur - start);
-			if (ret) {
-				iput(inode);
-				return 0;
-			}
+			if (ret)
+				goto out;
 			/*
 			 * Mark the old blocks as free since they aren't used
 			 * anymore. We maintain an array of all the modified
@@ -1707,10 +1704,8 @@ static int ext4_fc_replay_add_range(stru
 			ext4_ext_is_unwritten(ex), map.m_pblk);
 		ret = ext4_ext_replay_update_ex(inode, cur, map.m_len,
 					ext4_ext_is_unwritten(ex), map.m_pblk);
-		if (ret) {
-			iput(inode);
-			return 0;
-		}
+		if (ret)
+			goto out;
 		/*
 		 * We may have split the extent tree while toggling the state.
 		 * Try to shrink the extent tree now.
@@ -1722,6 +1717,7 @@ next:
 	}
 	ext4_ext_replay_shrink_inode(inode, i_size_read(inode) >>
 					sb->s_blocksize_bits);
+out:
 	iput(inode);
 	return 0;
 }
@@ -1751,6 +1747,8 @@ ext4_fc_replay_del_range(struct super_bl
 	}
 
 	ret = ext4_fc_record_modified_inode(sb, inode->i_ino);
+	if (ret)
+		goto out;
 
 	jbd_debug(1, "DEL_RANGE, inode %ld, lblk %d, len %d\n",
 			inode->i_ino, le32_to_cpu(lrange.fc_lblk),
@@ -1760,10 +1758,8 @@ ext4_fc_replay_del_range(struct super_bl
 		map.m_len = remaining;
 
 		ret = ext4_map_blocks(NULL, inode, &map, 0);
-		if (ret < 0) {
-			iput(inode);
-			return 0;
-		}
+		if (ret < 0)
+			goto out;
 		if (ret > 0) {
 			remaining -= ret;
 			cur += ret;
@@ -1778,15 +1774,13 @@ ext4_fc_replay_del_range(struct super_bl
 	ret = ext4_ext_remove_space(inode, lrange.fc_lblk,
 				lrange.fc_lblk + lrange.fc_len - 1);
 	up_write(&EXT4_I(inode)->i_data_sem);
-	if (ret) {
-		iput(inode);
-		return 0;
-	}
+	if (ret)
+		goto out;
 	ext4_ext_replay_shrink_inode(inode,
 		i_size_read(inode) >> sb->s_blocksize_bits);
 	ext4_mark_inode_dirty(NULL, inode);
+out:
 	iput(inode);
-
 	return 0;
 }
 


