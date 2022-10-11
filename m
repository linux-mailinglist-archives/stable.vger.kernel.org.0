Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 889FB5FB54E
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 16:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbiJKOxK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 10:53:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbiJKOwV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 10:52:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 733279A9FC;
        Tue, 11 Oct 2022 07:51:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D71E611CE;
        Tue, 11 Oct 2022 14:51:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5469C433D6;
        Tue, 11 Oct 2022 14:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665499863;
        bh=amnk8lJW6qeMGwwgJpH/D2/U68r/u6Ka/DhR/9fs6jU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oph6MJ4ycCJUhxlkBpWlHX7gO3ihmC4o9heUvXDIMAncS8isp1si9uo8YNy3Urx1O
         JVOznpe4uTt4r2wtQ7mNfbkVnP89YHok0HanO2wnOXK2owioC+DYcNu38ygFbHunr/
         OUdmBtKdypmmLycQwtoZDIjQgnh/NFgbGA1NRAHamZnjru3XMIadehBM4ZwGVzmQlx
         i0SHyUiztf9iWcYfGbzNP1nzv+feNkdp1e/QFzHptKjgzkc5RMhZJ8hA6EZWqGn4w6
         onTZNFQFQNjayF4LBejKQ2ebTPdvOOmwJAqLDZD94nIgHXU+1WKzH5KVUaYKdHM1/K
         BPuGPX7sG5Eeg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ioannis Angelakopoulos <iangelak@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, clm@fb.com,
        linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 30/46] btrfs: add lockdep annotations for the ordered extents wait event
Date:   Tue, 11 Oct 2022 10:49:58 -0400
Message-Id: <20221011145015.1622882-30-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221011145015.1622882-1-sashal@kernel.org>
References: <20221011145015.1622882-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ioannis Angelakopoulos <iangelak@fb.com>

[ Upstream commit 5f4403e10f9b75b081bcc763b98d73e29de8c248 ]

This wait event is very similar to the pending ordered wait event in the
sense that it occurs in a different context than the condition signaling
for the event. The signaling occurs in btrfs_remove_ordered_extent()
while the wait event is implemented in btrfs_start_ordered_extent() in
fs/btrfs/ordered-data.c

However, in this case a thread must not acquire the lockdep map for the
ordered extents wait event when the ordered extent is related to a free
space inode. That is because lockdep creates dependencies between locks
acquired both in execution paths related to normal inodes and paths
related to free space inodes, thus leading to false positives.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Ioannis Angelakopoulos <iangelak@fb.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ctree.h        |  1 +
 fs/btrfs/disk-io.c      |  1 +
 fs/btrfs/inode.c        | 13 +++++++++++++
 fs/btrfs/ordered-data.c | 18 ++++++++++++++++++
 4 files changed, 33 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 8bd9a6d5ade6..804962f97452 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1100,6 +1100,7 @@ struct btrfs_fs_info {
 	struct lockdep_map btrfs_trans_num_extwriters_map;
 	struct lockdep_map btrfs_state_change_map[4];
 	struct lockdep_map btrfs_trans_pending_ordered_map;
+	struct lockdep_map btrfs_ordered_extent_map;
 
 #ifdef CONFIG_BTRFS_FS_REF_VERIFY
 	spinlock_t ref_verify_lock;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 393553fdfed6..e0e1730e67d7 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2993,6 +2993,7 @@ void btrfs_init_fs_info(struct btrfs_fs_info *fs_info)
 	btrfs_lockdep_init_map(fs_info, btrfs_trans_num_writers);
 	btrfs_lockdep_init_map(fs_info, btrfs_trans_num_extwriters);
 	btrfs_lockdep_init_map(fs_info, btrfs_trans_pending_ordered);
+	btrfs_lockdep_init_map(fs_info, btrfs_ordered_extent);
 	btrfs_state_lockdep_init_map(fs_info, btrfs_trans_commit_start,
 				     BTRFS_LOCKDEP_TRANS_COMMIT_START);
 	btrfs_state_lockdep_init_map(fs_info, btrfs_trans_unblocked,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1372210869b1..b06955727055 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3225,6 +3225,8 @@ int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 		clear_bits |= EXTENT_DELALLOC_NEW;
 
 	freespace_inode = btrfs_is_free_space_inode(inode);
+	if (!freespace_inode)
+		btrfs_lockdep_acquire(fs_info, btrfs_ordered_extent);
 
 	if (test_bit(BTRFS_ORDERED_IOERR, &ordered_extent->flags)) {
 		ret = -EIO;
@@ -8959,6 +8961,7 @@ void btrfs_destroy_inode(struct inode *vfs_inode)
 	struct btrfs_ordered_extent *ordered;
 	struct btrfs_inode *inode = BTRFS_I(vfs_inode);
 	struct btrfs_root *root = inode->root;
+	bool freespace_inode;
 
 	WARN_ON(!hlist_empty(&vfs_inode->i_dentry));
 	WARN_ON(vfs_inode->i_data.nrpages);
@@ -8980,6 +8983,12 @@ void btrfs_destroy_inode(struct inode *vfs_inode)
 	if (!root)
 		return;
 
+	/*
+	 * If this is a free space inode do not take the ordered extents lockdep
+	 * map.
+	 */
+	freespace_inode = btrfs_is_free_space_inode(inode);
+
 	while (1) {
 		ordered = btrfs_lookup_first_ordered_extent(inode, (u64)-1);
 		if (!ordered)
@@ -8988,6 +8997,10 @@ void btrfs_destroy_inode(struct inode *vfs_inode)
 			btrfs_err(root->fs_info,
 				  "found ordered extent %llu %llu on inode cleanup",
 				  ordered->file_offset, ordered->num_bytes);
+
+			if (!freespace_inode)
+				btrfs_lockdep_acquire(root->fs_info, btrfs_ordered_extent);
+
 			btrfs_remove_ordered_extent(inode, ordered);
 			btrfs_put_ordered_extent(ordered);
 			btrfs_put_ordered_extent(ordered);
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 2a4cb6db42d1..eb24a6d20ff8 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -524,6 +524,13 @@ void btrfs_remove_ordered_extent(struct btrfs_inode *btrfs_inode,
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct rb_node *node;
 	bool pending;
+	bool freespace_inode;
+
+	/*
+	 * If this is a free space inode the thread has not acquired the ordered
+	 * extents lockdep map.
+	 */
+	freespace_inode = btrfs_is_free_space_inode(btrfs_inode);
 
 	btrfs_lockdep_acquire(fs_info, btrfs_trans_pending_ordered);
 	/* This is paired with btrfs_add_ordered_extent. */
@@ -597,6 +604,8 @@ void btrfs_remove_ordered_extent(struct btrfs_inode *btrfs_inode,
 	}
 	spin_unlock(&root->ordered_extent_lock);
 	wake_up(&entry->wait);
+	if (!freespace_inode)
+		btrfs_lockdep_release(fs_info, btrfs_ordered_extent);
 }
 
 static void btrfs_run_ordered_extent_work(struct btrfs_work *work)
@@ -715,9 +724,16 @@ void btrfs_start_ordered_extent(struct btrfs_ordered_extent *entry, int wait)
 	u64 start = entry->file_offset;
 	u64 end = start + entry->num_bytes - 1;
 	struct btrfs_inode *inode = BTRFS_I(entry->inode);
+	bool freespace_inode;
 
 	trace_btrfs_ordered_extent_start(inode, entry);
 
+	/*
+	 * If this is a free space inode do not take the ordered extents lockdep
+	 * map.
+	 */
+	freespace_inode = btrfs_is_free_space_inode(inode);
+
 	/*
 	 * pages in the range can be dirty, clean or writeback.  We
 	 * start IO on any dirty ones so the wait doesn't stall waiting
@@ -726,6 +742,8 @@ void btrfs_start_ordered_extent(struct btrfs_ordered_extent *entry, int wait)
 	if (!test_bit(BTRFS_ORDERED_DIRECT, &entry->flags))
 		filemap_fdatawrite_range(inode->vfs_inode.i_mapping, start, end);
 	if (wait) {
+		if (!freespace_inode)
+			btrfs_might_wait_for_event(inode->root->fs_info, btrfs_ordered_extent);
 		wait_event(entry->wait, test_bit(BTRFS_ORDERED_COMPLETE,
 						 &entry->flags));
 	}
-- 
2.35.1

