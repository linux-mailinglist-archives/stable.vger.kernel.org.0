Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35FE6404FB2
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350596AbhIIMWQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:22:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:58740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351504AbhIIMTL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:19:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D83261A83;
        Thu,  9 Sep 2021 11:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188214;
        bh=dstg8Ouqmyfn6wHreXuDINkCXZFIAngAC/Slw/7LRFw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m68HKzLVx9oP3YnU4K8Ry0df9WOPNN7RhTVx7GrArn6TaY8J+Rnu094qVANxPsDVE
         J02nZM06Y79rjVmTneYl/gruLZIp6s9bqOa8+pEPDR846vyUNJeSHL2DJDar1MrroK
         81J4g0UeX2CRP2o8Tz+cbhdpCiGyNKh+FKbYOSZXHyzR+n7BdIxP6yPKL5a+aftS+I
         Ocbxm8jzmi3BmqsMyaHwlF2nA9BlmeNfhNfexljvdmQoURR1RcuAnpDa0U+k18swlR
         LKZfphhxGvcf1VHH7YfH8lXTdlfzc4UJuGVPj3qFuz+kh+hZ06jUpipNTbWt4Jv3ao
         +M/YYyLhg6QNw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Filipe Manana <fdmanana@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 169/219] btrfs: remove racy and unnecessary inode transaction update when using no-holes
Date:   Thu,  9 Sep 2021 07:45:45 -0400
Message-Id: <20210909114635.143983-169-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit cceaa89f02f15f232391ae4be214137b0a0285c0 ]

When using the NO_HOLES feature and expanding the size of an inode, we
update the inode's last_trans, last_sub_trans and last_log_commit fields
at maybe_insert_hole() so that a fsync does know that the inode needs to
be logged (by making sure that btrfs_inode_in_log() returns false). This
happens for expanding truncate operations, buffered writes, direct IO
writes and when cloning extents to an offset greater than the inode's
i_size.

However the way we do it is racy, because in between setting the inode's
last_sub_trans and last_log_commit fields, the log transaction ID that was
assigned to last_sub_trans might be committed before we read the root's
last_log_commit and assign that value to last_log_commit. If that happens
it would make a future call to btrfs_inode_in_log() return true. This is
a race that should be extremely unlikely to be hit in practice, and it is
the same that was described by commit bc0939fcfab0d7 ("btrfs: fix race
between marking inode needs to be logged and log syncing").

The fix would simply be to set last_log_commit to the value we assigned
to last_sub_trans minus 1, like it was done in that commit. However
updating these two fields plus the last_trans field is pointless here
because all the callers of btrfs_cont_expand() (which is the only
caller of maybe_insert_hole()) always call btrfs_set_inode_last_trans()
or btrfs_update_inode() after calling btrfs_cont_expand(). Calling either
btrfs_set_inode_last_trans() or btrfs_update_inode() guarantees that the
next fsync will log the inode, as it makes btrfs_inode_in_log() return
false.

So just remove the code that explicitly sets the inode's last_trans,
last_sub_trans and last_log_commit fields.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 6328deb27d12..e245034caba1 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5064,15 +5064,13 @@ static int maybe_insert_hole(struct btrfs_root *root, struct btrfs_inode *inode,
 	int ret;
 
 	/*
-	 * Still need to make sure the inode looks like it's been updated so
-	 * that any holes get logged if we fsync.
+	 * If NO_HOLES is enabled, we don't need to do anything.
+	 * Later, up in the call chain, either btrfs_set_inode_last_sub_trans()
+	 * or btrfs_update_inode() will be called, which guarantee that the next
+	 * fsync will know this inode was changed and needs to be logged.
 	 */
-	if (btrfs_fs_incompat(fs_info, NO_HOLES)) {
-		inode->last_trans = fs_info->generation;
-		inode->last_sub_trans = root->log_transid;
-		inode->last_log_commit = root->last_log_commit;
+	if (btrfs_fs_incompat(fs_info, NO_HOLES))
 		return 0;
-	}
 
 	/*
 	 * 1 - for the one we're dropping
-- 
2.30.2

