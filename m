Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1556DD9258
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 15:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389778AbfJPNWS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 09:22:18 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:60597 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729306AbfJPNWS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Oct 2019 09:22:18 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 51FE821EAF;
        Wed, 16 Oct 2019 09:22:17 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 16 Oct 2019 09:22:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=ajC4q0
        Ck7VfgzNuxppsRS8dx4MopdZtAhvZqZcBTWaY=; b=CZI+GtLkQrqsEZMM599Gye
        tdcFf3YHn6mZzUaGkLu3X2DzTXpM9q17hQDvqW20upIyHFZY/MXAG6lKynuDn7NF
        GJ2UT4sCXHudv51bW7QBtFKtPT5eK22vH0sl01INxSp8LViUs+cQYkwS5LGXVuC7
        LCXVS6jv8wkiDLQs/5dEfv1O6tx3aWbYWl9cwvn6VWxhsd6SHrqb3c3+/QyxPOJC
        /6BDPeEWelv1ryIEus5wjfcZK9HMitbyA3vsEgdmTOyhThNgiv60W0Fja9jTSUPh
        +DAdLzWEzshm6A8CnUMhHx07eNQPgV7gvQycJjGYph8gjJDiXbAIP9aYgl75p0Qg
        ==
X-ME-Sender: <xms:iRmnXffVCz0o5hYUWxdgzijv4ZDcR2cYWKPlM9ytMpk469Qt9qvq3Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrjeehgdeihecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepvddtledrudefiedrvdefiedrleegnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedv
X-ME-Proxy: <xmx:iRmnXQEg9of8tmQDN17STnNnY3zhY3Ch7yhnB-uDL-DznI5e-IxbLQ>
    <xmx:iRmnXSvS3jQ5ghh7j8L0H2LzqkHSHbb4BfHV37GLxOraO4_L4RCqNA>
    <xmx:iRmnXSpcVY0fV7CPSxHg983lEd346YujtI0-XuctXJpKrjOdKn0rXQ>
    <xmx:iRmnXXFpr2kTZo9c8KfFH9FTiAMFw45n3_2bZ-u9mAoRgsNCcesBCw>
Received: from localhost (unknown [209.136.236.94])
        by mail.messagingengine.com (Postfix) with ESMTPA id E47E0D60063;
        Wed, 16 Oct 2019 09:22:16 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: fix incorrect updating of log root tree" failed to apply to 4.4-stable tree
To:     josef@toxicpanda.com, clm@fb.com, dsterba@suse.com,
        fdmanana@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 16 Oct 2019 06:22:07 -0700
Message-ID: <1571232127114150@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4203e968947071586a98b5314fd7ffdea3b4f971 Mon Sep 17 00:00:00 2001
From: Josef Bacik <josef@toxicpanda.com>
Date: Mon, 30 Sep 2019 16:27:25 -0400
Subject: [PATCH] btrfs: fix incorrect updating of log root tree

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

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 77b6797fcac3..2488eb4b70fc 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2932,7 +2932,8 @@ static int walk_log_tree(struct btrfs_trans_handle *trans,
  * in the tree of log roots
  */
 static int update_log_root(struct btrfs_trans_handle *trans,
-			   struct btrfs_root *log)
+			   struct btrfs_root *log,
+			   struct btrfs_root_item *root_item)
 {
 	struct btrfs_fs_info *fs_info = log->fs_info;
 	int ret;
@@ -2940,10 +2941,10 @@ static int update_log_root(struct btrfs_trans_handle *trans,
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
@@ -3041,6 +3042,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_root *log = root->log_root;
 	struct btrfs_root *log_root_tree = fs_info->log_root_tree;
+	struct btrfs_root_item new_root_item;
 	int log_transid = 0;
 	struct btrfs_log_ctx root_log_ctx;
 	struct blk_plug plug;
@@ -3104,17 +3106,25 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
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
-	/*
-	 * Update or create log root item under the root's log_mutex to prevent
-	 * races with concurrent log syncs that can lead to failure to update
-	 * log root item because it was not created yet.
-	 */
-	ret = update_log_root(trans, log);
 	/*
 	 * IO has been started, blocks of the log tree have WRITTEN flag set
 	 * in their headers. new modifications of the log will be written to
@@ -3135,6 +3145,14 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
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

