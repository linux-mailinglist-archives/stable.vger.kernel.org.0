Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC4B2E161E
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731225AbgLWC5u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:57:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:45448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729040AbgLWCUi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:20:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87D7022273;
        Wed, 23 Dec 2020 02:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690023;
        bh=SGdl1bYJJOC8B55sbmgtI5mC/kAXIsBDiYgc2YSAk50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qOgs8sDk7MurtV3olF21SrDQrXGWkQNTcLivFB1zdufC2Flc+T7eFnh3mZuk//Ow2
         Q23TmjyJLSNOQpWhBkajScppO4DavHXX385zQp2VzVuzWIlprnHDbWUlnnynTXjy/J
         2D4YeM583PpzH4+VH05oQfiBB7RzrUIfnN6LJigGQeZiGP5S9iY4TREjHeeMwWrlRK
         5ioLX9B+y4cZ7PhEWIzEyqoKwOUFy1OOD7Y+v6s3WRrObtR1ezyJ36t/IHQl5l7BfZ
         RJo5OMAj6/YPJksU6kmhJkYt5bD6H+EFAz+gEz6+fINH+rjXjtptjuCw3rj0IhPw6l
         f80LQaAm2YmMw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Filipe Manana <fdmanana@suse.com>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 100/130] btrfs: fix race that results in logging old extents during a fast fsync
Date:   Tue, 22 Dec 2020 21:17:43 -0500
Message-Id: <20201223021813.2791612-100-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 5f96bfb7633c55b578c6b32f32624061f25010db ]

When logging the extents of an inode during a fast fsync, we have a time
window where we can log extents that are from the previous transaction and
already persisted. This only makes us waste time unnecessarily.

The following sequence of steps shows how this can happen:

1) We are at transaction 1000;

2) An ordered extent E from inode I completes, that is it has gone through
   btrfs_finish_ordered_io(), and it set the extent maps' generation to
   1000 when we unpin the extent, which is the generation of the current
   transaction;

3) The commit for transaction 1000 starts by task A;

4) The task committing transaction 1000 sets the transaction state to
   unblocked, writes the dirty extent buffers and the super blocks, then
   unlocks tree_log_mutex;

5) Some change is made to inode I, resulting in creation of a new
   transaction with a generation of 1001;

6) The transaction 1000 commit starts unpinning extents. At this point
   fs_info->last_trans_committed still has a value of 999;

7) Task B starts an fsync on inode I, and when it gets to
   btrfs_log_changed_extents() sees the extent map for extent E in the
   list of modified extents. It sees the extent map has a generation of
   1000 and fs_info->last_trans_committed has a value of 999, so it
   proceeds to logging the respective file extent item and all the
   checksums covering its range.

   So we end up wasting time since the extent was already persisted and
   is reachable through the trees pointed to by the super block committed
   by transaction 1000.

So just fix this by comparing the extent maps generation against the
generation of the transaction handle - if it is smaller then the id in the
handle, we know the extent was already persisted and we do not need to log
it.

This patch belongs to a patch set that is comprised of the following
patches:

  btrfs: fix race causing unnecessary inode logging during link and rename
  btrfs: fix race that results in logging old extents during a fast fsync
  btrfs: fix race that causes unnecessary logging of ancestor inodes
  btrfs: fix race that makes inode logging fallback to transaction commit
  btrfs: fix race leading to unnecessary transaction commit when logging inode
  btrfs: do not block inode logging for so long during transaction commit

Performance results are mentioned in the change log of the last patch.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-log.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index de53e51669976..12182db88222b 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4372,14 +4372,12 @@ static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
 	struct extent_map *em, *n;
 	struct list_head extents;
 	struct extent_map_tree *tree = &inode->extent_tree;
-	u64 test_gen;
 	int ret = 0;
 	int num = 0;
 
 	INIT_LIST_HEAD(&extents);
 
 	write_lock(&tree->lock);
-	test_gen = root->fs_info->last_trans_committed;
 
 	list_for_each_entry_safe(em, n, &tree->modified_extents, list) {
 		/*
@@ -4412,7 +4410,7 @@ static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
 			goto process;
 		}
 
-		if (em->generation <= test_gen)
+		if (em->generation < trans->transid)
 			continue;
 
 		/* We log prealloc extents beyond eof later. */
-- 
2.27.0

