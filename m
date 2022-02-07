Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14A034ABD8E
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 13:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388731AbiBGLpC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:45:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385175AbiBGLbR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:31:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C331BC03E97A;
        Mon,  7 Feb 2022 03:29:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5DC3D6077B;
        Mon,  7 Feb 2022 11:29:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24076C004E1;
        Mon,  7 Feb 2022 11:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233369;
        bh=6vj50r1AvP3r9OAXzpvy1MjM6N02vm1PiN84suqqwYY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oH28ytEGmaJrIPdqGp08btMiWbK1iEIokFHwQD0pM7112YWsPSGZV17UHpWcSIs0R
         U8OSUNaVhSyNMDAZDlzCyuNEq3oOuKLYVg7LMsC095QAObmnWEOnAFXg3HBys5WJKS
         Xpl9m3gjtLMacjVe+VWO2N9NUBr4N8IxxZsXuLQ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, luo penghao <luo.penghao@zte.com.cn>,
        Lukas Czerner <lczerner@redhat.com>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
        stable@kernel.org
Subject: [PATCH 5.15 102/110] ext4: fix error handling in ext4_fc_record_modified_inode()
Date:   Mon,  7 Feb 2022 12:07:15 +0100
Message-Id: <20220207103805.845715864@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103802.280120990@linuxfoundation.org>
References: <20220207103802.280120990@linuxfoundation.org>
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
@@ -1433,14 +1433,15 @@ static int ext4_fc_record_modified_inode
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
@@ -1472,7 +1473,9 @@ static int ext4_fc_replay_inode(struct s
 	}
 	inode = NULL;
 
-	ext4_fc_record_modified_inode(sb, ino);
+	ret = ext4_fc_record_modified_inode(sb, ino);
+	if (ret)
+		goto out;
 
 	raw_fc_inode = (struct ext4_inode *)
 		(val + offsetof(struct ext4_fc_inode, fc_raw_inode));
@@ -1671,6 +1674,8 @@ static int ext4_fc_replay_add_range(stru
 	}
 
 	ret = ext4_fc_record_modified_inode(sb, inode->i_ino);
+	if (ret)
+		goto out;
 
 	start = le32_to_cpu(ex->ee_block);
 	start_pblk = ext4_ext_pblock(ex);
@@ -1688,18 +1693,14 @@ static int ext4_fc_replay_add_range(stru
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
@@ -1713,10 +1714,8 @@ static int ext4_fc_replay_add_range(stru
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
 
@@ -1729,10 +1728,8 @@ static int ext4_fc_replay_add_range(stru
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
@@ -1752,10 +1749,8 @@ static int ext4_fc_replay_add_range(stru
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
@@ -1767,6 +1762,7 @@ next:
 	}
 	ext4_ext_replay_shrink_inode(inode, i_size_read(inode) >>
 					sb->s_blocksize_bits);
+out:
 	iput(inode);
 	return 0;
 }
@@ -1796,6 +1792,8 @@ ext4_fc_replay_del_range(struct super_bl
 	}
 
 	ret = ext4_fc_record_modified_inode(sb, inode->i_ino);
+	if (ret)
+		goto out;
 
 	jbd_debug(1, "DEL_RANGE, inode %ld, lblk %d, len %d\n",
 			inode->i_ino, le32_to_cpu(lrange.fc_lblk),
@@ -1805,10 +1803,8 @@ ext4_fc_replay_del_range(struct super_bl
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
@@ -1823,15 +1819,13 @@ ext4_fc_replay_del_range(struct super_bl
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
 


