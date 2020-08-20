Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D40624BDFB
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728523AbgHTNQr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:16:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:48576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728497AbgHTJfR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:35:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DFB6A207DE;
        Thu, 20 Aug 2020 09:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916116;
        bh=fvOvliW8q5/VOllEgpMZZoBv04p5/mEGwJ2s1DxwVd8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UAqqWnY5I8NasKhI553bJ7B/FoLApww2CTqaP7O2afhwA3s7HUfRqdSrH72L8oGjE
         c4o5zHxoUGDn4lsJE3dKV0hjTdKH7rbjU2uBlytDx/wGiEQEaXQQhNLpNuvfgjwNdA
         s0TCw0p91DXH1LhI0zFl6oMF/40oeDgsD+ap3NqU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.7 017/204] btrfs: remove no longer needed use of log_writers for the log root tree
Date:   Thu, 20 Aug 2020 11:18:34 +0200
Message-Id: <20200820091607.105284138@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091606.194320503@linuxfoundation.org>
References: <20200820091606.194320503@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit a93e01682e283f6de09d6ce8f805dc52a2e942fb upstream.

When syncing the log, we used to update the log root tree without holding
neither the log_mutex of the subvolume root nor the log_mutex of log root
tree.

We used to have two critical sections delimited by the log_mutex of the
log root tree, so in the first one we incremented the log_writers of the
log root tree and on the second one we decremented it and waited for the
log_writers counter to go down to zero. This was because the update of
the log root tree happened between the two critical sections.

The use of two critical sections allowed a little bit more of parallelism
and required the use of the log_writers counter, necessary to make sure
we didn't miss any log root tree update when we have multiple tasks trying
to sync the log in parallel.

However after commit 06989c799f0481 ("Btrfs: fix race updating log root
item during fsync") the log root tree update was moved into a critical
section delimited by the subvolume's log_mutex. Later another commit
moved the log tree update from that critical section into the second
critical section delimited by the log_mutex of the log root tree. Both
commits addressed different bugs.

The end result is that the first critical section delimited by the
log_mutex of the log root tree became pointless, since there's nothing
done between it and the second critical section, we just have an unlock
of the log_mutex followed by a lock operation. This means we can merge
both critical sections, as the first one does almost nothing now, and we
can stop using the log_writers counter of the log root tree, which was
incremented in the first critical section and decremented in the second
criticial section, used to make sure no one in the second critical section
started writeback of the log root tree before some other task updated it.

So just remove the mutex_unlock() followed by mutex_lock() of the log root
tree, as well as the use of the log_writers counter for the log root tree.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/ctree.h    |    1 +
 fs/btrfs/tree-log.c |   13 -------------
 2 files changed, 1 insertion(+), 13 deletions(-)

--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1038,6 +1038,7 @@ struct btrfs_root {
 	wait_queue_head_t log_writer_wait;
 	wait_queue_head_t log_commit_wait[2];
 	struct list_head log_ctxs[2];
+	/* Used only for log trees of subvolumes, not for the log root tree */
 	atomic_t log_writers;
 	atomic_t log_commit[2];
 	/* Used only for log trees of subvolumes, not for the log root tree */
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3125,28 +3125,17 @@ int btrfs_sync_log(struct btrfs_trans_ha
 	btrfs_init_log_ctx(&root_log_ctx, NULL);
 
 	mutex_lock(&log_root_tree->log_mutex);
-	atomic_inc(&log_root_tree->log_writers);
 
 	index2 = log_root_tree->log_transid % 2;
 	list_add_tail(&root_log_ctx.list, &log_root_tree->log_ctxs[index2]);
 	root_log_ctx.log_transid = log_root_tree->log_transid;
 
-	mutex_unlock(&log_root_tree->log_mutex);
-
-	mutex_lock(&log_root_tree->log_mutex);
-
 	/*
 	 * Now we are safe to update the log_root_tree because we're under the
 	 * log_mutex, and we're a current writer so we're holding the commit
 	 * open until we drop the log_mutex.
 	 */
 	ret = update_log_root(trans, log, &new_root_item);
-
-	if (atomic_dec_and_test(&log_root_tree->log_writers)) {
-		/* atomic_dec_and_test implies a barrier */
-		cond_wake_up_nomb(&log_root_tree->log_writer_wait);
-	}
-
 	if (ret) {
 		if (!list_empty(&root_log_ctx.list))
 			list_del_init(&root_log_ctx.list);
@@ -3192,8 +3181,6 @@ int btrfs_sync_log(struct btrfs_trans_ha
 				root_log_ctx.log_transid - 1);
 	}
 
-	wait_for_writer(log_root_tree);
-
 	/*
 	 * now that we've moved on to the tree of log tree roots,
 	 * check the full commit flag again


