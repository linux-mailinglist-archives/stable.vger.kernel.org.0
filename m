Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9762A5233
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:48:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731378AbgKCUrm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:47:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:38324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731367AbgKCUrm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:47:42 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C62FC223FD;
        Tue,  3 Nov 2020 20:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436461;
        bh=OlkrlWvBlgacWn6cEy3tc/WFHg9lIR7sccu3BttW8so=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MZtSAmLKTO3HhAgqcXB1l1D5mL7mcCHOMsvC4NyFbjuy7FhLEuS1b++gWV4dgHSRU
         9AhTxXXJb32FkDDaXgceN9IfLrdVOdrOnsQwVWzk7lZ030hbyhGKGq6UU/AOV+0i4N
         /O/Kjk2H4YaYPUuvJkL0QuYKM0QF/H4yJzoJSbWA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH 5.9 223/391] btrfs: qgroup: fix qgroup meta rsv leak for subvolume operations
Date:   Tue,  3 Nov 2020 21:34:34 +0100
Message-Id: <20201103203401.995861735@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit e85fde5162bf1b242cbd6daf7dba0f9b457d592b upstream.

[BUG]
When quota is enabled for TEST_DEV, generic/013 sometimes fails like this:

  generic/013 14s ... _check_dmesg: something found in dmesg (see xfstests-dev/results//generic/013.dmesg)

And with the following metadata leak:

  BTRFS warning (device dm-3): qgroup 0/1370 has unreleased space, type 2 rsv 49152
  ------------[ cut here ]------------
  WARNING: CPU: 2 PID: 47912 at fs/btrfs/disk-io.c:4078 close_ctree+0x1dc/0x323 [btrfs]
  Call Trace:
   btrfs_put_super+0x15/0x17 [btrfs]
   generic_shutdown_super+0x72/0x110
   kill_anon_super+0x18/0x30
   btrfs_kill_super+0x17/0x30 [btrfs]
   deactivate_locked_super+0x3b/0xa0
   deactivate_super+0x40/0x50
   cleanup_mnt+0x135/0x190
   __cleanup_mnt+0x12/0x20
   task_work_run+0x64/0xb0
   __prepare_exit_to_usermode+0x1bc/0x1c0
   __syscall_return_slowpath+0x47/0x230
   do_syscall_64+0x64/0xb0
   entry_SYSCALL_64_after_hwframe+0x44/0xa9
  ---[ end trace a6cfd45ba80e4e06 ]---
  BTRFS error (device dm-3): qgroup reserved space leaked
  BTRFS info (device dm-3): disk space caching is enabled
  BTRFS info (device dm-3): has skinny extents

[CAUSE]
The qgroup preallocated meta rsv operations of that offending root are:

  btrfs_delayed_inode_reserve_metadata: rsv_meta_prealloc root=1370 num_bytes=131072
  btrfs_delayed_inode_reserve_metadata: rsv_meta_prealloc root=1370 num_bytes=131072
  btrfs_subvolume_reserve_metadata: rsv_meta_prealloc root=1370 num_bytes=49152
  btrfs_delayed_inode_release_metadata: convert_meta_prealloc root=1370 num_bytes=-131072
  btrfs_delayed_inode_release_metadata: convert_meta_prealloc root=1370 num_bytes=-131072

It's pretty obvious that, we reserve qgroup meta rsv in
btrfs_subvolume_reserve_metadata(), but doesn't have corresponding
release/convert calls in btrfs_subvolume_release_metadata().

This leads to the leakage.

[FIX]
To fix this bug, we should follow what we're doing in
btrfs_delalloc_reserve_metadata(), where we reserve qgroup space, and
add it to block_rsv->qgroup_rsv_reserved.

And free the qgroup reserved metadata space when releasing the
block_rsv.

To do this, we need to change the btrfs_subvolume_release_metadata() to
accept btrfs_root, and record the qgroup_to_release number, and call
btrfs_qgroup_convert_reserved_meta() for it.

Fixes: 733e03a0b26a ("btrfs: qgroup: Split meta rsv type into meta_prealloc and meta_pertrans")
CC: stable@vger.kernel.org # 4.19+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/ctree.h     |    2 +-
 fs/btrfs/inode.c     |    2 +-
 fs/btrfs/ioctl.c     |    6 +++---
 fs/btrfs/root-tree.c |   13 +++++++++++--
 4 files changed, 16 insertions(+), 7 deletions(-)

--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2619,7 +2619,7 @@ enum btrfs_flush_state {
 int btrfs_subvolume_reserve_metadata(struct btrfs_root *root,
 				     struct btrfs_block_rsv *rsv,
 				     int nitems, bool use_global_rsv);
-void btrfs_subvolume_release_metadata(struct btrfs_fs_info *fs_info,
+void btrfs_subvolume_release_metadata(struct btrfs_root *root,
 				      struct btrfs_block_rsv *rsv);
 void btrfs_delalloc_release_extents(struct btrfs_inode *inode, u64 num_bytes);
 
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4051,7 +4051,7 @@ out_end_trans:
 		err = ret;
 	inode->i_flags |= S_DEAD;
 out_release:
-	btrfs_subvolume_release_metadata(fs_info, &block_rsv);
+	btrfs_subvolume_release_metadata(root, &block_rsv);
 out_up_write:
 	up_write(&fs_info->subvol_sem);
 	if (err) {
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -618,7 +618,7 @@ static noinline int create_subvol(struct
 	trans = btrfs_start_transaction(root, 0);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
-		btrfs_subvolume_release_metadata(fs_info, &block_rsv);
+		btrfs_subvolume_release_metadata(root, &block_rsv);
 		goto fail_free;
 	}
 	trans->block_rsv = &block_rsv;
@@ -742,7 +742,7 @@ fail:
 	kfree(root_item);
 	trans->block_rsv = NULL;
 	trans->bytes_reserved = 0;
-	btrfs_subvolume_release_metadata(fs_info, &block_rsv);
+	btrfs_subvolume_release_metadata(root, &block_rsv);
 
 	err = btrfs_commit_transaction(trans);
 	if (err && !ret)
@@ -856,7 +856,7 @@ fail:
 	if (ret && pending_snapshot->snap)
 		pending_snapshot->snap->anon_dev = 0;
 	btrfs_put_root(pending_snapshot->snap);
-	btrfs_subvolume_release_metadata(fs_info, &pending_snapshot->block_rsv);
+	btrfs_subvolume_release_metadata(root, &pending_snapshot->block_rsv);
 free_pending:
 	if (pending_snapshot->anon_dev)
 		free_anon_bdev(pending_snapshot->anon_dev);
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -512,11 +512,20 @@ int btrfs_subvolume_reserve_metadata(str
 	if (ret && qgroup_num_bytes)
 		btrfs_qgroup_free_meta_prealloc(root, qgroup_num_bytes);
 
+	if (!ret) {
+		spin_lock(&rsv->lock);
+		rsv->qgroup_rsv_reserved += qgroup_num_bytes;
+		spin_unlock(&rsv->lock);
+	}
 	return ret;
 }
 
-void btrfs_subvolume_release_metadata(struct btrfs_fs_info *fs_info,
+void btrfs_subvolume_release_metadata(struct btrfs_root *root,
 				      struct btrfs_block_rsv *rsv)
 {
-	btrfs_block_rsv_release(fs_info, rsv, (u64)-1, NULL);
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	u64 qgroup_to_release;
+
+	btrfs_block_rsv_release(fs_info, rsv, (u64)-1, &qgroup_to_release);
+	btrfs_qgroup_convert_reserved_meta(root, qgroup_to_release);
 }


