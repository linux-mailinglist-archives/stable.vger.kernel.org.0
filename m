Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09D73D9FB8
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395528AbfJPV5m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:57:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:50608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395516AbfJPV5m (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:57:42 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3EDB218DE;
        Wed, 16 Oct 2019 21:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263061;
        bh=nj2s/8Yp2W0RC4AUkCJ9rriUDVt7cGSPze4YEpcsPmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f7BT2QZXMAWePoCZY134Dxcf1mDGUGdKomr9FLgEmvqQ0KB2YE3/8hJU2QBE+7+YM
         nzHMks23OaicSWGbjy5Orzxc+269xOR+An+VO+2aPQLTc8JF0eFnxk/sd1qz2f3Ahx
         9mYw9nbAGzpCLMO/utJCZPwx1oSM5fwX8JOR+xq0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Mason <clm@fb.com>,
        Filipe Manana <fdmanana@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.19 63/81] btrfs: fix incorrect updating of log root tree
Date:   Wed, 16 Oct 2019 14:51:14 -0700
Message-Id: <20191016214844.214258814@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214805.727399379@linuxfoundation.org>
References: <20191016214805.727399379@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit 4203e968947071586a98b5314fd7ffdea3b4f971 upstream.

We've historically had reports of being unable to mount file systems
because the tree log root couldn't be read.  Usually this is the "parent
transid failure", but could be any of the related errors, including
"fsid mismatch" or "bad tree block", depending on which block got
allocated.

The modification of the individual log root items are serialized on the
per-log root root_mutex.  This means that any modification to the
per-subvol log root_item is completely protected.

However we update the root item in the log root tree outside of the log
root tree log_mutex.  We do this in order to allow multiple subvolumes
to be updated in each log transaction.

This is problematic however because when we are writing the log root
tree out we update the super block with the _current_ log root node
information.  Since these two operations happen independently of each
other, you can end up updating the log root tree in between writing out
the dirty blocks and setting the super block to point at the current
root.

This means we'll point at the new root node that hasn't been written
out, instead of the one we should be pointing at.  Thus whatever garbage
or old block we end up pointing at complains when we mount the file
system later and try to replay the log.

Fix this by copying the log's root item into a local root item copy.
Then once we're safely under the log_root_tree->log_mutex we update the
root item in the log_root_tree.  This way we do not modify the
log_root_tree while we're committing it, fixing the problem.

CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Chris Mason <clm@fb.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/tree-log.c |   36 +++++++++++++++++++++++++++---------
 1 file changed, 27 insertions(+), 9 deletions(-)

--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2860,7 +2860,8 @@ out:
  * in the tree of log roots
  */
 static int update_log_root(struct btrfs_trans_handle *trans,
-			   struct btrfs_root *log)
+			   struct btrfs_root *log,
+			   struct btrfs_root_item *root_item)
 {
 	struct btrfs_fs_info *fs_info = log->fs_info;
 	int ret;
@@ -2868,10 +2869,10 @@ static int update_log_root(struct btrfs_
 	if (log->log_transid == 1) {
 		/* insert root item on the first sync */
 		ret = btrfs_insert_root(trans, fs_info->log_root_tree,
-				&log->root_key, &log->root_item);
+				&log->root_key, root_item);
 	} else {
 		ret = btrfs_update_root(trans, fs_info->log_root_tree,
-				&log->root_key, &log->root_item);
+				&log->root_key, root_item);
 	}
 	return ret;
 }
@@ -2969,6 +2970,7 @@ int btrfs_sync_log(struct btrfs_trans_ha
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_root *log = root->log_root;
 	struct btrfs_root *log_root_tree = fs_info->log_root_tree;
+	struct btrfs_root_item new_root_item;
 	int log_transid = 0;
 	struct btrfs_log_ctx root_log_ctx;
 	struct blk_plug plug;
@@ -3032,18 +3034,26 @@ int btrfs_sync_log(struct btrfs_trans_ha
 		goto out;
 	}
 
+	/*
+	 * We _must_ update under the root->log_mutex in order to make sure we
+	 * have a consistent view of the log root we are trying to commit at
+	 * this moment.
+	 *
+	 * We _must_ copy this into a local copy, because we are not holding the
+	 * log_root_tree->log_mutex yet.  This is important because when we
+	 * commit the log_root_tree we must have a consistent view of the
+	 * log_root_tree when we update the super block to point at the
+	 * log_root_tree bytenr.  If we update the log_root_tree here we'll race
+	 * with the commit and possibly point at the new block which we may not
+	 * have written out.
+	 */
 	btrfs_set_root_node(&log->root_item, log->node);
+	memcpy(&new_root_item, &log->root_item, sizeof(new_root_item));
 
 	root->log_transid++;
 	log->log_transid = root->log_transid;
 	root->log_start_pid = 0;
 	/*
-	 * Update or create log root item under the root's log_mutex to prevent
-	 * races with concurrent log syncs that can lead to failure to update
-	 * log root item because it was not created yet.
-	 */
-	ret = update_log_root(trans, log);
-	/*
 	 * IO has been started, blocks of the log tree have WRITTEN flag set
 	 * in their headers. new modifications of the log will be written to
 	 * new positions. so it's safe to allow log writers to go in.
@@ -3063,6 +3073,14 @@ int btrfs_sync_log(struct btrfs_trans_ha
 	mutex_unlock(&log_root_tree->log_mutex);
 
 	mutex_lock(&log_root_tree->log_mutex);
+
+	/*
+	 * Now we are safe to update the log_root_tree because we're under the
+	 * log_mutex, and we're a current writer so we're holding the commit
+	 * open until we drop the log_mutex.
+	 */
+	ret = update_log_root(trans, log, &new_root_item);
+
 	if (atomic_dec_and_test(&log_root_tree->log_writers)) {
 		/* atomic_dec_and_test implies a barrier */
 		cond_wake_up_nomb(&log_root_tree->log_writer_wait);


