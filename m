Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 289BE330E45
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 13:36:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232251AbhCHMgW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 07:36:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:45272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232157AbhCHMfx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 07:35:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8CEB56520F;
        Mon,  8 Mar 2021 12:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615206952;
        bh=k8YsLo0p7ozQulWsC23XtUepzaCfeBihz5Z9E8K+vpk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D8Daf86QQfcoRrZ68prlaaJf2gcZRhSkrlUHTI4Im6Idl5/1D/CeL/7yudj0dTj9g
         yfaUZ3rywTaPO5rPFhQcBrGEOjdqin4OPa65XUR+dwLY9HQMCRosL9sZHyZ4ItipZe
         iSAIZJ62qAq0qh2MLAYFDY7DK5M3ZX1uHEiBvXkc=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anand Jain <anand.jain@oracle.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.11 11/44] btrfs: fix race between swap file activation and snapshot creation
Date:   Mon,  8 Mar 2021 13:34:49 +0100
Message-Id: <20210308122719.134769151@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210308122718.586629218@linuxfoundation.org>
References: <20210308122718.586629218@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Filipe Manana <fdmanana@suse.com>

commit dd0734f2a866f9d619d4abf97c3d71bcdee40ea9 upstream.

When creating a snapshot we check if the current number of swap files, in
the root, is non-zero, and if it is, we error out and warn that we can not
create the snapshot because there are active swap files.

However this is racy because when a task started activation of a swap
file, another task might have started already snapshot creation and might
have seen the counter for the number of swap files as zero. This means
that after the swap file is activated we may end up with a snapshot of the
same root successfully created, and therefore when the first write to the
swap file happens it has to fall back into COW mode, which should never
happen for active swap files.

Basically what can happen is:

1) Task A starts snapshot creation and enters ioctl.c:create_snapshot().
   There it sees that root->nr_swapfiles has a value of 0 so it continues;

2) Task B enters btrfs_swap_activate(). It is not aware that another task
   started snapshot creation but it did not finish yet. It increments
   root->nr_swapfiles from 0 to 1;

3) Task B checks that the file meets all requirements to be an active
   swap file - it has NOCOW set, there are no snapshots for the inode's
   root at the moment, no file holes, no reflinked extents, etc;

4) Task B returns success and now the file is an active swap file;

5) Task A commits the transaction to create the snapshot and finishes.
   The swap file's extents are now shared between the original root and
   the snapshot;

6) A write into an extent of the swap file is attempted - there is a
   snapshot of the file's root, so we fall back to COW mode and therefore
   the physical location of the extent changes on disk.

So fix this by taking the snapshot lock during swap file activation before
locking the extent range, as that is the order in which we lock these
during buffered writes.

Fixes: ed46ff3d42378 ("Btrfs: support swap files")
CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -10099,7 +10099,8 @@ static int btrfs_swap_activate(struct sw
 			       sector_t *span)
 {
 	struct inode *inode = file_inode(file);
-	struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
 	struct extent_state *cached_state = NULL;
 	struct extent_map *em = NULL;
@@ -10150,13 +10151,27 @@ static int btrfs_swap_activate(struct sw
 	   "cannot activate swapfile while exclusive operation is running");
 		return -EBUSY;
 	}
+
+	/*
+	 * Prevent snapshot creation while we are activating the swap file.
+	 * We do not want to race with snapshot creation. If snapshot creation
+	 * already started before we bumped nr_swapfiles from 0 to 1 and
+	 * completes before the first write into the swap file after it is
+	 * activated, than that write would fallback to COW.
+	 */
+	if (!btrfs_drew_try_write_lock(&root->snapshot_lock)) {
+		btrfs_exclop_finish(fs_info);
+		btrfs_warn(fs_info,
+	   "cannot activate swapfile because snapshot creation is in progress");
+		return -EINVAL;
+	}
 	/*
 	 * Snapshots can create extents which require COW even if NODATACOW is
 	 * set. We use this counter to prevent snapshots. We must increment it
 	 * before walking the extents because we don't want a concurrent
 	 * snapshot to run after we've already checked the extents.
 	 */
-	atomic_inc(&BTRFS_I(inode)->root->nr_swapfiles);
+	atomic_inc(&root->nr_swapfiles);
 
 	isize = ALIGN_DOWN(inode->i_size, fs_info->sectorsize);
 
@@ -10302,6 +10317,8 @@ out:
 	if (ret)
 		btrfs_swap_deactivate(file);
 
+	btrfs_drew_write_unlock(&root->snapshot_lock);
+
 	btrfs_exclop_finish(fs_info);
 
 	if (ret)


