Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5D872598E9
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730565AbgIAP3w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:29:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:59588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730556AbgIAP3v (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:29:51 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92BD52158C;
        Tue,  1 Sep 2020 15:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974190;
        bh=NaOaH8glx58DCiI54aiOO/XM6TC+fQSKdJlxtVmi+T8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vHJbwauFp6DyeJL6Mqa8P7dxowf42+yUnUzMOC0xZNKQfvcoS2mSIWLqffxCIjJtF
         hQg0ClkiypekKAEiIH2JmUXchYZUKi4graqWXyWtZu05P8IEhSCQjZJgv8JKe8YXVO
         FQsgwkToSYu4lV4XqQG3/d0E9ACZUl/MhQIl0vu0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 079/214] btrfs: only commit delayed items at fsync if we are logging a directory
Date:   Tue,  1 Sep 2020 17:09:19 +0200
Message-Id: <20200901150956.768833483@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 5aa7d1a7f4a2f8ca6be1f32415e9365d026e8fa7 ]

When logging an inode we are committing its delayed items if either the
inode is a directory or if it is a new inode, created in the current
transaction.

We need to do it for directories, since new directory indexes are stored
as delayed items of the inode and when logging a directory we need to be
able to access all indexes from the fs/subvolume tree in order to figure
out which index ranges need to be logged.

However for new inodes that are not directories, we do not need to do it
because the only type of delayed item they can have is the inode item, and
we are guaranteed to always log an up to date version of the inode item:

*) for a full fsync we do it by committing the delayed inode and then
   copying the item from the fs/subvolume tree with
   copy_inode_items_to_log();

*) for a fast fsync we always log the inode item based on the contents of
   the in-memory struct btrfs_inode. We guarantee this is always done since
   commit e4545de5b035c7 ("Btrfs: fix fsync data loss after append write").

So stop running delayed items for a new inodes that are not directories,
since that forces committing the delayed inode into the fs/subvolume tree,
wasting time and adding contention to the tree when a full fsync is not
required. We will only do it in case a fast fsync is needed.

This patch is part of a series that has the following patches:

1/4 btrfs: only commit the delayed inode when doing a full fsync
2/4 btrfs: only commit delayed items at fsync if we are logging a directory
3/4 btrfs: stop incremening log_batch for the log root tree when syncing log
4/4 btrfs: remove no longer needed use of log_writers for the log root tree

After the entire patchset applied I saw about 12% decrease on max latency
reported by dbench. The test was done on a qemu vm, with 8 cores, 16Gb of
ram, using kvm and using a raw NVMe device directly (no intermediary fs on
the host). The test was invoked like the following:

  mkfs.btrfs -f /dev/sdk
  mount -o ssd -o nospace_cache /dev/sdk /mnt/sdk
  dbench -D /mnt/sdk -t 300 8
  umount /mnt/dsk

CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-log.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 0525b191843e1..709026698d915 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -5147,7 +5147,6 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 			   const loff_t end,
 			   struct btrfs_log_ctx *ctx)
 {
-	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_path *path;
 	struct btrfs_path *dst_path;
 	struct btrfs_key min_key;
@@ -5190,15 +5189,17 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 	max_key.offset = (u64)-1;
 
 	/*
-	 * Only run delayed items if we are a dir or a new file.
+	 * Only run delayed items if we are a directory. We want to make sure
+	 * all directory indexes hit the fs/subvolume tree so we can find them
+	 * and figure out which index ranges have to be logged.
+	 *
 	 * Otherwise commit the delayed inode only if the full sync flag is set,
 	 * as we want to make sure an up to date version is in the subvolume
 	 * tree so copy_inode_items_to_log() / copy_items() can find it and copy
 	 * it to the log tree. For a non full sync, we always log the inode item
 	 * based on the in-memory struct btrfs_inode which is always up to date.
 	 */
-	if (S_ISDIR(inode->vfs_inode.i_mode) ||
-	    inode->generation > fs_info->last_trans_committed)
+	if (S_ISDIR(inode->vfs_inode.i_mode))
 		ret = btrfs_commit_inode_delayed_items(trans, inode);
 	else if (test_bit(BTRFS_INODE_NEEDS_FULL_SYNC, &inode->runtime_flags))
 		ret = btrfs_commit_inode_delayed_inode(inode);
-- 
2.25.1



