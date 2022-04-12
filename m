Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED4F4FCA2A
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 02:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243454AbiDLAvY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 20:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244329AbiDLAuw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 20:50:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4626730566;
        Mon, 11 Apr 2022 17:47:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D7FCB819BF;
        Tue, 12 Apr 2022 00:47:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F28EC385AA;
        Tue, 12 Apr 2022 00:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649724420;
        bh=lfWgNDuTl3Fsk91sCVN2UOdFZ9227/ZxwTLk25yq+7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W8rfxafzEZ4tvGtjwTOXAHpNUO4kqif79y0wgXeK9gJ+P5ffH35EQpMRoobAmdvgq
         OEAVOFAA3ULmLkSPj2R3aBvDHpO0hol8dmClj1DTH2AouxSvvT7o7uOizN0AP+Qt+n
         xp25/YLUIdaQKpvRStr9EC7wAgDXtHOl+Rw6kM18KExgsUscmLX9U1tkurrcjEFWcD
         y/YW2BIQ8lFdztuDLXSEHJdv7vMXYx6o4EvAhxIL93j4sOwQVBs4RfuxN3ZpmrWyJY
         5KRGfxtHb3IWlo5h7jHUMNDzlHVEUXG+W9ofOJN2X2S0ge6a0aTwAZSHELCHjJ20zg
         r+iSHgvE3Ep5w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, clm@fb.com,
        josef@toxicpanda.com, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 02/41] btrfs: fix fallocate to use file_modified to update permissions consistently
Date:   Mon, 11 Apr 2022 20:46:14 -0400
Message-Id: <20220412004656.350101-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412004656.350101-1-sashal@kernel.org>
References: <20220412004656.350101-1-sashal@kernel.org>
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
index a1762363f61f..dc1e4d1b7291 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2878,8 +2878,9 @@ int btrfs_replace_file_extents(struct btrfs_inode *inode,
 	return ret;
 }
 
-static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
+static int btrfs_punch_hole(struct file *file, loff_t offset, loff_t len)
 {
+	struct inode *inode = file_inode(file);
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct extent_state *cached_state = NULL;
@@ -2911,6 +2912,10 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 		goto out_only_mutex;
 	}
 
+	ret = file_modified(file);
+	if (ret)
+		goto out_only_mutex;
+
 	lockstart = round_up(offset, btrfs_inode_sectorsize(BTRFS_I(inode)));
 	lockend = round_down(offset + len,
 			     btrfs_inode_sectorsize(BTRFS_I(inode))) - 1;
@@ -3351,7 +3356,7 @@ static long btrfs_fallocate(struct file *file, int mode,
 		return -EOPNOTSUPP;
 
 	if (mode & FALLOC_FL_PUNCH_HOLE)
-		return btrfs_punch_hole(inode, offset, len);
+		return btrfs_punch_hole(file, offset, len);
 
 	/*
 	 * Only trigger disk allocation, don't trigger qgroup reserve
@@ -3373,6 +3378,10 @@ static long btrfs_fallocate(struct file *file, int mode,
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

