Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 250D73E2569
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240985AbhHFITx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:19:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:46112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244171AbhHFITZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 04:19:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F37D61207;
        Fri,  6 Aug 2021 08:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628237938;
        bh=TeLO9gAxDj6YaTXtxuLF1pntS5ZsT/hnTGPhOnvVTjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PtIM3V9OX+6NpONRBCuTVysrs42fuViUEoKvkmU8ynnm9wnSt74iHusEVWHD3V2pU
         AZ2i8/+PRqqNXhu+xFs7mFFyOd9Grjz1kXtF7z65GKWdKCsuol6VBZJmprmHAojd1S
         RnLJEYbfeygJ1Hbxe5uPNDRz+bI42khaB++sr52Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 03/30] btrfs: fix race causing unnecessary inode logging during link and rename
Date:   Fri,  6 Aug 2021 10:16:41 +0200
Message-Id: <20210806081113.245614581@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210806081113.126861800@linuxfoundation.org>
References: <20210806081113.126861800@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit de53d892e5c51dfa0a158e812575a75a6c991f39 ]

When we are doing a rename or a link operation for an inode that was logged
in the previous transaction and that transaction is still committing, we
have a time window where we incorrectly consider that the inode was logged
previously in the current transaction and therefore decide to log it to
update it in the log. The following steps give an example on how this
happens during a link operation:

1) Inode X is logged in transaction 1000, so its logged_trans field is set
   to 1000;

2) Task A starts to commit transaction 1000;

3) The state of transaction 1000 is changed to TRANS_STATE_UNBLOCKED;

4) Task B starts a link operation for inode X, and as a consequence it
   starts transaction 1001;

5) Task A is still committing transaction 1000, therefore the value stored
   at fs_info->last_trans_committed is still 999;

6) Task B calls btrfs_log_new_name(), it reads a value of 999 from
   fs_info->last_trans_committed and because the logged_trans field of
   inode X has a value of 1000, the function does not return immediately,
   instead it proceeds to logging the inode, which should not happen
   because the inode was logged in the previous transaction (1000) and
   not in the current one (1001).

This is not a functional problem, just wasted time and space logging an
inode that does not need to be logged, contributing to higher latency
for link and rename operations.

So fix this by comparing the inodes' logged_trans field with the
generation of the current transaction instead of comparing with the value
stored in fs_info->last_trans_committed.

This case is often hit when running dbench for a long enough duration, as
it does lots of rename operations.

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
 fs/btrfs/tree-log.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 4b913de2f24f..d3a2bec931ca 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -6443,7 +6443,6 @@ void btrfs_log_new_name(struct btrfs_trans_handle *trans,
 			struct btrfs_inode *inode, struct btrfs_inode *old_dir,
 			struct dentry *parent)
 {
-	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_log_ctx ctx;
 
 	/*
@@ -6457,8 +6456,8 @@ void btrfs_log_new_name(struct btrfs_trans_handle *trans,
 	 * if this inode hasn't been logged and directory we're renaming it
 	 * from hasn't been logged, we don't need to log it
 	 */
-	if (inode->logged_trans <= fs_info->last_trans_committed &&
-	    (!old_dir || old_dir->logged_trans <= fs_info->last_trans_committed))
+	if (inode->logged_trans < trans->transid &&
+	    (!old_dir || old_dir->logged_trans < trans->transid))
 		return;
 
 	btrfs_init_log_ctx(&ctx, &inode->vfs_inode);
-- 
2.30.2



