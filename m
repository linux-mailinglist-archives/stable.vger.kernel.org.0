Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5CBD643314
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:34:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234003AbiLETeL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:34:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234001AbiLETdw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:33:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A42228721
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:28:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58710B81151
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:28:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFB64C433C1;
        Mon,  5 Dec 2022 19:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268524;
        bh=OpiqznKZ+clLNqugfoVhacYpA6n+7mu45qFFxkOpnKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VlvfrwzfnX1TQX4AJbDN448t7OMjIDVwfAxOEzOEMOQmR2EwVCO99ROmFd+BRVsWG
         8ioZ/6HUSbOPsOEMZaRFDUBjJ0PwhX+TCChn2JVf7kakpzipz3aJCAcN6YgPH3w3Qd
         3iNq5KC0g/K7gqDJgvFiVEon+NGHIvNmwAW8lTh4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 01/92] btrfs: sink iterator parameter to btrfs_ioctl_logical_to_ino
Date:   Mon,  5 Dec 2022 20:09:14 +0100
Message-Id: <20221205190803.512235803@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.464934752@linuxfoundation.org>
References: <20221205190803.464934752@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Sterba <dsterba@suse.com>

[ Upstream commit e3059ec06b9f1a96826cc2bb6ed131aac0942446 ]

There's only one function we pass to iterate_inodes_from_logical as
iterator, so we can drop the indirection and call it directly, after
moving the function to backref.c

Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 418ffb9e3cf6 ("btrfs: free btrfs_path before copying inodes to userspace")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/backref.c | 25 ++++++++++++++++++++++---
 fs/btrfs/backref.h |  3 +--
 fs/btrfs/ioctl.c   | 22 +---------------------
 3 files changed, 24 insertions(+), 26 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 6942707f8b03..7208ba22e734 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -2060,10 +2060,29 @@ int iterate_extent_inodes(struct btrfs_fs_info *fs_info,
 	return ret;
 }
 
+static int build_ino_list(u64 inum, u64 offset, u64 root, void *ctx)
+{
+	struct btrfs_data_container *inodes = ctx;
+	const size_t c = 3 * sizeof(u64);
+
+	if (inodes->bytes_left >= c) {
+		inodes->bytes_left -= c;
+		inodes->val[inodes->elem_cnt] = inum;
+		inodes->val[inodes->elem_cnt + 1] = offset;
+		inodes->val[inodes->elem_cnt + 2] = root;
+		inodes->elem_cnt += 3;
+	} else {
+		inodes->bytes_missing += c - inodes->bytes_left;
+		inodes->bytes_left = 0;
+		inodes->elem_missed += 3;
+	}
+
+	return 0;
+}
+
 int iterate_inodes_from_logical(u64 logical, struct btrfs_fs_info *fs_info,
 				struct btrfs_path *path,
-				iterate_extent_inodes_t *iterate, void *ctx,
-				bool ignore_offset)
+				void *ctx, bool ignore_offset)
 {
 	int ret;
 	u64 extent_item_pos;
@@ -2081,7 +2100,7 @@ int iterate_inodes_from_logical(u64 logical, struct btrfs_fs_info *fs_info,
 	extent_item_pos = logical - found_key.objectid;
 	ret = iterate_extent_inodes(fs_info, found_key.objectid,
 					extent_item_pos, search_commit_root,
-					iterate, ctx, ignore_offset);
+					build_ino_list, ctx, ignore_offset);
 
 	return ret;
 }
diff --git a/fs/btrfs/backref.h b/fs/btrfs/backref.h
index 17abde7f794c..6ed18b807b64 100644
--- a/fs/btrfs/backref.h
+++ b/fs/btrfs/backref.h
@@ -35,8 +35,7 @@ int iterate_extent_inodes(struct btrfs_fs_info *fs_info,
 				bool ignore_offset);
 
 int iterate_inodes_from_logical(u64 logical, struct btrfs_fs_info *fs_info,
-				struct btrfs_path *path,
-				iterate_extent_inodes_t *iterate, void *ctx,
+				struct btrfs_path *path, void *ctx,
 				bool ignore_offset);
 
 int paths_from_inode(u64 inum, struct inode_fs_paths *ipath);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index d0c31651ec80..58fe58b929d2 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3898,26 +3898,6 @@ static long btrfs_ioctl_ino_to_path(struct btrfs_root *root, void __user *arg)
 	return ret;
 }
 
-static int build_ino_list(u64 inum, u64 offset, u64 root, void *ctx)
-{
-	struct btrfs_data_container *inodes = ctx;
-	const size_t c = 3 * sizeof(u64);
-
-	if (inodes->bytes_left >= c) {
-		inodes->bytes_left -= c;
-		inodes->val[inodes->elem_cnt] = inum;
-		inodes->val[inodes->elem_cnt + 1] = offset;
-		inodes->val[inodes->elem_cnt + 2] = root;
-		inodes->elem_cnt += 3;
-	} else {
-		inodes->bytes_missing += c - inodes->bytes_left;
-		inodes->bytes_left = 0;
-		inodes->elem_missed += 3;
-	}
-
-	return 0;
-}
-
 static long btrfs_ioctl_logical_to_ino(struct btrfs_fs_info *fs_info,
 					void __user *arg, int version)
 {
@@ -3967,7 +3947,7 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs_fs_info *fs_info,
 	}
 
 	ret = iterate_inodes_from_logical(loi->logical, fs_info, path,
-					  build_ino_list, inodes, ignore_offset);
+					  inodes, ignore_offset);
 	if (ret == -EINVAL)
 		ret = -ENOENT;
 	if (ret < 0)
-- 
2.35.1



