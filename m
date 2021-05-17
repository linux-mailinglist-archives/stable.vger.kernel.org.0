Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9A638367D
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244932AbhEQPdE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:33:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:56440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242143AbhEQPbE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:31:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 217A86112F;
        Mon, 17 May 2021 14:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262293;
        bh=DOSFAV5FBTUWvEG2rJoTVl/CMvEPtierD6XEI9p0b9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rqY8MPBYcLvCvocvdm2K4v+6DIkG1FLwAlasAOeXE/kzzSfWstQDw2b29nG3j56X/
         KtNorfe3eleDK84YtWMGQHIlW29RzFpJsGbSFqnEUZ/Pu4fZm3dK6/ogUxdrOEve0m
         TprzPGjjGcqDdZTdiKWo98cbM4woDqAK9tiMHUbc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.11 245/329] btrfs: fix race leading to unpersisted data and metadata on fsync
Date:   Mon, 17 May 2021 16:02:36 +0200
Message-Id: <20210517140310.393774335@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit 626e9f41f7c281ba3e02843702f68471706aa6d9 upstream.

When doing a fast fsync on a file, there is a race which can result in the
fsync returning success to user space without logging the inode and without
durably persisting new data.

The following example shows one possible scenario for this:

   $ mkfs.btrfs -f /dev/sdc
   $ mount /dev/sdc /mnt

   $ touch /mnt/bar
   $ xfs_io -f -c "pwrite -S 0xab 0 1M" -c "fsync" /mnt/baz

   # Now we have:
   # file bar == inode 257
   # file baz == inode 258

   $ mv /mnt/baz /mnt/foo

   # Now we have:
   # file bar == inode 257
   # file foo == inode 258

   $ xfs_io -c "pwrite -S 0xcd 0 1M" /mnt/foo

   # fsync bar before foo, it is important to trigger the race.
   $ xfs_io -c "fsync" /mnt/bar
   $ xfs_io -c "fsync" /mnt/foo

   # After this:
   # inode 257, file bar, is empty
   # inode 258, file foo, has 1M filled with 0xcd

   <power failure>

   # Replay the log:
   $ mount /dev/sdc /mnt

   # After this point file foo should have 1M filled with 0xcd and not 0xab

The following steps explain how the race happens:

1) Before the first fsync of inode 258, when it has the "baz" name, its
   ->logged_trans is 0, ->last_sub_trans is 0 and ->last_log_commit is -1.
   The inode also has the full sync flag set;

2) After the first fsync, we set inode 258 ->logged_trans to 6, which is
   the generation of the current transaction, and set ->last_log_commit
   to 0, which is the current value of ->last_sub_trans (done at
   btrfs_log_inode()).

   The full sync flag is cleared from the inode during the fsync.

   The log sub transaction that was committed had an ID of 0 and when we
   synced the log, at btrfs_sync_log(), we incremented root->log_transid
   from 0 to 1;

3) During the rename:

   We update inode 258, through btrfs_update_inode(), and that causes its
   ->last_sub_trans to be set to 1 (the current log transaction ID), and
   ->last_log_commit remains with a value of 0.

   After updating inode 258, because we have previously logged the inode
   in the previous fsync, we log again the inode through the call to
   btrfs_log_new_name(). This results in updating the inode's
   ->last_log_commit from 0 to 1 (the current value of its
   ->last_sub_trans).

   The ->last_sub_trans of inode 257 is updated to 1, which is the ID of
   the next log transaction;

4) Then a buffered write against inode 258 is made. This leaves the value
   of ->last_sub_trans as 1 (the ID of the current log transaction, stored
   at root->log_transid);

5) Then an fsync against inode 257 (or any other inode other than 258),
   happens. This results in committing the log transaction with ID 1,
   which results in updating root->last_log_commit to 1 and bumping
   root->log_transid from 1 to 2;

6) Then an fsync against inode 258 starts. We flush delalloc and wait only
   for writeback to complete, since the full sync flag is not set in the
   inode's runtime flags - we do not wait for ordered extents to complete.

   Then, at btrfs_sync_file(), we call btrfs_inode_in_log() before the
   ordered extent completes. The call returns true:

     static inline bool btrfs_inode_in_log(...)
     {
         bool ret = false;

         spin_lock(&inode->lock);
         if (inode->logged_trans == generation &&
             inode->last_sub_trans <= inode->last_log_commit &&
             inode->last_sub_trans <= inode->root->last_log_commit)
                 ret = true;
         spin_unlock(&inode->lock);
         return ret;
     }

   generation has a value of 6 (fs_info->generation), ->logged_trans also
   has a value of 6 (set when we logged the inode during the first fsync
   and when logging it during the rename), ->last_sub_trans has a value
   of 1, set during the rename (step 3), ->last_log_commit also has a
   value of 1 (set in step 3) and root->last_log_commit has a value of 1,
   which was set in step 5 when fsyncing inode 257.

   As a consequence we don't log the inode, any new extents and do not
   sync the log, resulting in a data loss if a power failure happens
   after the fsync and before the current transaction commits.
   Also, because we do not log the inode, after a power failure the mtime
   and ctime of the inode do not match those we had before.

   When the ordered extent completes before we call btrfs_inode_in_log(),
   then the call returns false and we log the inode and sync the log,
   since at the end of ordered extent completion we update the inode and
   set ->last_sub_trans to 2 (the value of root->log_transid) and
   ->last_log_commit to 1.

This problem is found after removing the check for the emptiness of the
inode's list of modified extents in the recent commit 209ecbb8585bf6
("btrfs: remove stale comment and logic from btrfs_inode_in_log()"),
added in the 5.13 merge window. However checking the emptiness of the
list is not really the way to solve this problem, and was never intended
to, because while that solves the problem for COW writes, the problem
persists for NOCOW writes because in that case the list is always empty.

In the case of NOCOW writes, even though we wait for the writeback to
complete before returning from btrfs_sync_file(), we end up not logging
the inode, which has a new mtime/ctime, and because we don't sync the log,
we never issue disk barriers (send REQ_PREFLUSH to the device) since that
only happens when we sync the log (when we write super blocks at
btrfs_sync_log()). So effectively, for a NOCOW case, when we return from
btrfs_sync_file() to user space, we are not guaranteeing that the data is
durably persisted on disk.

Also, while the example above uses a rename exchange to show how the
problem happens, it is not the only way to trigger it. An alternative
could be adding a new hard link to inode 258, since that also results
in calling btrfs_log_new_name() and updating the inode in the log.
An example reproducer using the addition of a hard link instead of a
rename operation:

  $ mkfs.btrfs -f /dev/sdc
  $ mount /dev/sdc /mnt

  $ touch /mnt/bar
  $ xfs_io -f -c "pwrite -S 0xab 0 1M" -c "fsync" /mnt/foo

  $ ln /mnt/foo /mnt/foo_link
  $ xfs_io -c "pwrite -S 0xcd 0 1M" /mnt/foo

  $ xfs_io -c "fsync" /mnt/bar
  $ xfs_io -c "fsync" /mnt/foo

  <power failure>

  # Replay the log:
  $ mount /dev/sdc /mnt

  # After this point file foo often has 1M filled with 0xab and not 0xcd

The reasons leading to the final fsync of file foo, inode 258, not
persisting the new data are the same as for the previous example with
a rename operation.

So fix by never skipping logging and log syncing when there are still any
ordered extents in flight. To avoid making the conditional if statement
that checks if logging an inode is needed harder to read, place all the
logic into an helper function with separate if statements to make it more
manageable and easier to read.

A test case for fstests will follow soon.

For NOCOW writes, the problem existed before commit b5e6c3e170b770
("btrfs: always wait on ordered extents at fsync time"), introduced in
kernel 4.19, then it went away with that commit since we started to always
wait for ordered extent completion before logging.

The problem came back again once the fast fsync path was changed again to
avoid waiting for ordered extent completion, in commit 487781796d3022
("btrfs: make fast fsyncs wait only for writeback"), added in kernel 5.10.

However, for COW writes, the race only happens after the recent
commit 209ecbb8585bf6 ("btrfs: remove stale comment and logic from
btrfs_inode_in_log()"), introduced in the 5.13 merge window. For NOCOW
writes, the bug existed before that commit. So tag 5.10+ as the release
for stable backports.

CC: stable@vger.kernel.org # 5.10+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/file.c     |   36 +++++++++++++++++++++++++-----------
 fs/btrfs/tree-log.c |    3 ++-
 2 files changed, 27 insertions(+), 12 deletions(-)

--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2082,6 +2082,30 @@ static int start_ordered_ops(struct inod
 	return ret;
 }
 
+static inline bool skip_inode_logging(const struct btrfs_log_ctx *ctx)
+{
+	struct btrfs_inode *inode = BTRFS_I(ctx->inode);
+	struct btrfs_fs_info *fs_info = inode->root->fs_info;
+
+	if (btrfs_inode_in_log(inode, fs_info->generation) &&
+	    list_empty(&ctx->ordered_extents))
+		return true;
+
+	/*
+	 * If we are doing a fast fsync we can not bail out if the inode's
+	 * last_trans is <= then the last committed transaction, because we only
+	 * update the last_trans of the inode during ordered extent completion,
+	 * and for a fast fsync we don't wait for that, we only wait for the
+	 * writeback to complete.
+	 */
+	if (inode->last_trans <= fs_info->last_trans_committed &&
+	    (test_bit(BTRFS_INODE_NEEDS_FULL_SYNC, &inode->runtime_flags) ||
+	     list_empty(&ctx->ordered_extents)))
+		return true;
+
+	return false;
+}
+
 /*
  * fsync call for both files and directories.  This logs the inode into
  * the tree log instead of forcing full commits whenever possible.
@@ -2097,7 +2121,6 @@ int btrfs_sync_file(struct file *file, l
 {
 	struct dentry *dentry = file_dentry(file);
 	struct inode *inode = d_inode(dentry);
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_trans_handle *trans;
 	struct btrfs_log_ctx ctx;
@@ -2196,17 +2219,8 @@ int btrfs_sync_file(struct file *file, l
 
 	atomic_inc(&root->log_batch);
 
-	/*
-	 * If we are doing a fast fsync we can not bail out if the inode's
-	 * last_trans is <= then the last committed transaction, because we only
-	 * update the last_trans of the inode during ordered extent completion,
-	 * and for a fast fsync we don't wait for that, we only wait for the
-	 * writeback to complete.
-	 */
 	smp_mb();
-	if (btrfs_inode_in_log(BTRFS_I(inode), fs_info->generation) ||
-	    (BTRFS_I(inode)->last_trans <= fs_info->last_trans_committed &&
-	     (full_sync || list_empty(&ctx.ordered_extents)))) {
+	if (skip_inode_logging(&ctx)) {
 		/*
 		 * We've had everything committed since the last time we were
 		 * modified so clear this flag in case it was set for whatever
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -6066,7 +6066,8 @@ static int btrfs_log_inode_parent(struct
 	 * (since logging them is pointless, a link count of 0 means they
 	 * will never be accessible).
 	 */
-	if (btrfs_inode_in_log(inode, trans->transid) ||
+	if ((btrfs_inode_in_log(inode, trans->transid) &&
+	     list_empty(&ctx->ordered_extents)) ||
 	    inode->vfs_inode.i_nlink == 0) {
 		ret = BTRFS_NO_LOG_SYNC;
 		goto end_no_trans;


