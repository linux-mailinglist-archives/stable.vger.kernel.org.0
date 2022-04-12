Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93DEB4FCAC2
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 02:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244837AbiDLA4I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 20:56:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245256AbiDLAzX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 20:55:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FCF8E031;
        Mon, 11 Apr 2022 17:49:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 80816617E9;
        Tue, 12 Apr 2022 00:49:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D29DCC385AC;
        Tue, 12 Apr 2022 00:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649724550;
        bh=nqTocmM82ERuIyMTNxXt0a1iqomNj0dglld3fwjcjPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BFfX2MCMw/shnnQjUHQEseuY/6UjUWxrRJZIl+HYEfPySFSBp/W+4elrklwFxP4Qu
         8xt5RLm2UsCcza6R5ZMJBmWVfLplU9EPmdlkMUrv6n826F4qU3ARE2zxITwi/Tm39t
         YxhF77GVLUGfLEAZMgC61X4ebDC4mF1UjYKK+ZBMWYJ7B80JjVr+tNRCboSNPxlON7
         dCPhTn0PTWlTEBwleTimNJNtVjDmClyz63Kc+41erBHkdRd9mlMx7guxcuAzq21j2o
         b6FfG+FQmRdbRwcAKsMcqR2Xh9ixm9f12bWz0agNSMrJKcSl6sq42YasPHrZQQKOgr
         dR0h7UMl8HAGA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, clm@fb.com,
        josef@toxicpanda.com, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 02/30] btrfs: fix fallocate to use file_modified to update permissions consistently
Date:   Mon, 11 Apr 2022 20:48:36 -0400
Message-Id: <20220412004906.350678-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412004906.350678-1-sashal@kernel.org>
References: <20220412004906.350678-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 05fd9564e9faf0f23b4676385e27d9405cef6637 ]

Since the initial introduction of (posix) fallocate back at the turn of
the century, it has been possible to use this syscall to change the
user-visible contents of files.  This can happen by extending the file
size during a preallocation, or through any of the newer modes (punch,
zero range).  Because the call can be used to change file contents, we
should treat it like we do any other modification to a file -- update
the mtime, and drop set[ug]id privileges/capabilities.

The VFS function file_modified() does all this for us if pass it a
locked inode, so let's make fallocate drop permissions correctly.

Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/file.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index f59ec55e5feb..416a1b753ff6 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2833,8 +2833,9 @@ int btrfs_replace_file_extents(struct inode *inode, struct btrfs_path *path,
 	return ret;
 }
 
-static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
+static int btrfs_punch_hole(struct file *file, loff_t offset, loff_t len)
 {
+	struct inode *inode = file_inode(file);
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct extent_state *cached_state = NULL;
@@ -2866,6 +2867,10 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 		goto out_only_mutex;
 	}
 
+	ret = file_modified(file);
+	if (ret)
+		goto out_only_mutex;
+
 	lockstart = round_up(offset, btrfs_inode_sectorsize(BTRFS_I(inode)));
 	lockend = round_down(offset + len,
 			     btrfs_inode_sectorsize(BTRFS_I(inode))) - 1;
@@ -3301,7 +3306,7 @@ static long btrfs_fallocate(struct file *file, int mode,
 		return -EOPNOTSUPP;
 
 	if (mode & FALLOC_FL_PUNCH_HOLE)
-		return btrfs_punch_hole(inode, offset, len);
+		return btrfs_punch_hole(file, offset, len);
 
 	/*
 	 * Only trigger disk allocation, don't trigger qgroup reserve
@@ -3323,6 +3328,10 @@ static long btrfs_fallocate(struct file *file, int mode,
 			goto out;
 	}
 
+	ret = file_modified(file);
+	if (ret)
+		goto out;
+
 	/*
 	 * TODO: Move these two operations after we have checked
 	 * accurate reserved space, or fallocate can still fail but
-- 
2.35.1

