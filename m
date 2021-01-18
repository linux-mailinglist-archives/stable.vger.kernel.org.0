Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEC7A2FA919
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 19:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393700AbhARSmO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 13:42:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:36158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390704AbhARLlQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:41:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F4242223E;
        Mon, 18 Jan 2021 11:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970061;
        bh=4M374YJiLWmUFop75ZV8yP2L1ztd0k/zLC9RxGMq7m8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=084wFvUpcxtUnCAL1k53FlUO65QpPL40axmsveRje5mOIfVzc/aT8j4+tQq8VJ4CV
         Tyjzut0On6wVtUNi+lZ4yIH+sgrq2cKv8bS7sfhwkbCMxeZsqK8G/DyTtr6KVBEYq6
         xcIe3vUO0vD7yeXIfIGQWNYdqjNR9lGd2xvR6KP8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yi Li <yili@winhong.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
        stable@kernel.org
Subject: [PATCH 5.10 020/152] ext4: use IS_ERR instead of IS_ERR_OR_NULL and set inode null when IS_ERR
Date:   Mon, 18 Jan 2021 12:33:15 +0100
Message-Id: <20210118113353.741516653@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yi Li <yili@winhong.com>

commit 23dd561ad9eae02b4d51bb502fe4e1a0666e9567 upstream.

1: ext4_iget/ext4_find_extent never returns NULL, use IS_ERR
instead of IS_ERR_OR_NULL to fix this.

2: ext4_fc_replay_inode should set the inode to NULL when IS_ERR.
and go to call iput properly.

Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
Signed-off-by: Yi Li <yili@winhong.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20201230033827.3996064-1-yili@winhong.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/fast_commit.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -1269,14 +1269,14 @@ static int ext4_fc_replay_unlink(struct
 	entry.len = darg.dname_len;
 	inode = ext4_iget(sb, darg.ino, EXT4_IGET_NORMAL);
 
-	if (IS_ERR_OR_NULL(inode)) {
+	if (IS_ERR(inode)) {
 		jbd_debug(1, "Inode %d not found", darg.ino);
 		return 0;
 	}
 
 	old_parent = ext4_iget(sb, darg.parent_ino,
 				EXT4_IGET_NORMAL);
-	if (IS_ERR_OR_NULL(old_parent)) {
+	if (IS_ERR(old_parent)) {
 		jbd_debug(1, "Dir with inode  %d not found", darg.parent_ino);
 		iput(inode);
 		return 0;
@@ -1361,7 +1361,7 @@ static int ext4_fc_replay_link(struct su
 			darg.parent_ino, darg.dname_len);
 
 	inode = ext4_iget(sb, darg.ino, EXT4_IGET_NORMAL);
-	if (IS_ERR_OR_NULL(inode)) {
+	if (IS_ERR(inode)) {
 		jbd_debug(1, "Inode not found.");
 		return 0;
 	}
@@ -1417,10 +1417,11 @@ static int ext4_fc_replay_inode(struct s
 	trace_ext4_fc_replay(sb, tag, ino, 0, 0);
 
 	inode = ext4_iget(sb, ino, EXT4_IGET_NORMAL);
-	if (!IS_ERR_OR_NULL(inode)) {
+	if (!IS_ERR(inode)) {
 		ext4_ext_clear_bb(inode);
 		iput(inode);
 	}
+	inode = NULL;
 
 	ext4_fc_record_modified_inode(sb, ino);
 
@@ -1463,7 +1464,7 @@ static int ext4_fc_replay_inode(struct s
 
 	/* Given that we just wrote the inode on disk, this SHOULD succeed. */
 	inode = ext4_iget(sb, ino, EXT4_IGET_NORMAL);
-	if (IS_ERR_OR_NULL(inode)) {
+	if (IS_ERR(inode)) {
 		jbd_debug(1, "Inode not found.");
 		return -EFSCORRUPTED;
 	}
@@ -1515,7 +1516,7 @@ static int ext4_fc_replay_create(struct
 		goto out;
 
 	inode = ext4_iget(sb, darg.ino, EXT4_IGET_NORMAL);
-	if (IS_ERR_OR_NULL(inode)) {
+	if (IS_ERR(inode)) {
 		jbd_debug(1, "inode %d not found.", darg.ino);
 		inode = NULL;
 		ret = -EINVAL;
@@ -1528,7 +1529,7 @@ static int ext4_fc_replay_create(struct
 		 * dot and dot dot dirents are setup properly.
 		 */
 		dir = ext4_iget(sb, darg.parent_ino, EXT4_IGET_NORMAL);
-		if (IS_ERR_OR_NULL(dir)) {
+		if (IS_ERR(dir)) {
 			jbd_debug(1, "Dir %d not found.", darg.ino);
 			goto out;
 		}
@@ -1604,7 +1605,7 @@ static int ext4_fc_replay_add_range(stru
 
 	inode = ext4_iget(sb, le32_to_cpu(fc_add_ex->fc_ino),
 				EXT4_IGET_NORMAL);
-	if (IS_ERR_OR_NULL(inode)) {
+	if (IS_ERR(inode)) {
 		jbd_debug(1, "Inode not found.");
 		return 0;
 	}
@@ -1728,7 +1729,7 @@ ext4_fc_replay_del_range(struct super_bl
 		le32_to_cpu(lrange->fc_ino), cur, remaining);
 
 	inode = ext4_iget(sb, le32_to_cpu(lrange->fc_ino), EXT4_IGET_NORMAL);
-	if (IS_ERR_OR_NULL(inode)) {
+	if (IS_ERR(inode)) {
 		jbd_debug(1, "Inode %d not found", le32_to_cpu(lrange->fc_ino));
 		return 0;
 	}
@@ -1809,7 +1810,7 @@ static void ext4_fc_set_bitmaps_and_coun
 	for (i = 0; i < state->fc_modified_inodes_used; i++) {
 		inode = ext4_iget(sb, state->fc_modified_inodes[i],
 			EXT4_IGET_NORMAL);
-		if (IS_ERR_OR_NULL(inode)) {
+		if (IS_ERR(inode)) {
 			jbd_debug(1, "Inode %d not found.",
 				state->fc_modified_inodes[i]);
 			continue;
@@ -1826,7 +1827,7 @@ static void ext4_fc_set_bitmaps_and_coun
 
 			if (ret > 0) {
 				path = ext4_find_extent(inode, map.m_lblk, NULL, 0);
-				if (!IS_ERR_OR_NULL(path)) {
+				if (!IS_ERR(path)) {
 					for (j = 0; j < path->p_depth; j++)
 						ext4_mb_mark_bb(inode->i_sb,
 							path[j].p_block, 1, 1);


