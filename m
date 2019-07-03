Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16F5B5E13F
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 11:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbfGCJpz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 05:45:55 -0400
Received: from mx2.suse.de ([195.135.220.15]:45832 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725847AbfGCJpz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Jul 2019 05:45:55 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 77EF3AF5B;
        Wed,  3 Jul 2019 09:45:53 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: Ensure replaced device doesn't have pending chunk allocation
Date:   Wed,  3 Jul 2019 12:45:48 +0300
Message-Id: <20190703094552.15833-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Recent FITRIM work, namely bbbf7243d62d ("btrfs: combine device update
operations during transaction commit") combined the way certain
operations are recoded in a transaction. As a result an ASSERT was added
in dev_replace_finish to ensure the new code works correctly.
Unfortunately I got reports that it's possible to trigger the assert,
meaning that during a device replace it's possible to have an unfinished
chunk allocation on the source device.

This is supposed to be prevented by the fact that a transaction is
committed before finishing the replace oepration and alter acquiring the
chunk mutex. This is not sufficient since by the time the transaction is
committed and the chunk mutex acquired it's possible to allocate a chunk
depending on the workload being executed on the replaced device. This
bug has been present ever since device replace was introduced but there
was never code which checks for it.

The correct way to fix is to ensure that there is no pending device
modification operation when the chunk mutex is acquire and if there is
repeat transaction commit. Unfortunately it's not possible to just
exclude the source device from btrfs_fs_devices::dev_alloc_list since
this causes ENOSPC to be hit in transaction commit.

Fixing that in another way would need to add special cases to handle the
last writes and forbid new ones. The looped transaction fix is more
obvious, and can be easily backported. The runtime of dev-replace is
long so there's no noticeable delay caused by that.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 Hello Greg, 

 Please merge the following backport of upstream commit debd1c065d2037919a7da67baf55cc683fee09f0
 to 4.9 stable branch. 

 fs/btrfs/dev-replace.c | 29 +++++++++++++++++++----------
 fs/btrfs/volumes.c     |  2 ++
 fs/btrfs/volumes.h     |  5 +++++
 3 files changed, 26 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index fb973cc0af66..395b07764269 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -511,18 +511,27 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 	}
 	btrfs_wait_ordered_roots(root->fs_info, -1, 0, (u64)-1);
 
-	trans = btrfs_start_transaction(root, 0);
-	if (IS_ERR(trans)) {
-		mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
-		return PTR_ERR(trans);
+	while (1) {
+		trans = btrfs_start_transaction(root, 0);
+		if (IS_ERR(trans)) {
+			mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
+			return PTR_ERR(trans);
+		}
+		ret = btrfs_commit_transaction(trans, root);
+		WARN_ON(ret);
+		mutex_lock(&uuid_mutex);
+		/* keep away write_all_supers() during the finishing procedure */
+		mutex_lock(&root->fs_info->fs_devices->device_list_mutex);
+		mutex_lock(&root->fs_info->chunk_mutex);
+		if (src_device->has_pending_chunks) {
+			mutex_unlock(&root->fs_info->chunk_mutex);
+			mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
+			mutex_unlock(&uuid_mutex);
+		} else {
+			break;
+		}
 	}
-	ret = btrfs_commit_transaction(trans, root);
-	WARN_ON(ret);
 
-	mutex_lock(&uuid_mutex);
-	/* keep away write_all_supers() during the finishing procedure */
-	mutex_lock(&root->fs_info->fs_devices->device_list_mutex);
-	mutex_lock(&root->fs_info->chunk_mutex);
 	btrfs_dev_replace_lock(dev_replace, 1);
 	dev_replace->replace_state =
 		scrub_ret ? BTRFS_IOCTL_DEV_REPLACE_STATE_CANCELED
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index c063ac57c30e..94b61afe996c 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4876,6 +4876,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	for (i = 0; i < map->num_stripes; i++) {
 		num_bytes = map->stripes[i].dev->bytes_used + stripe_size;
 		btrfs_device_set_bytes_used(map->stripes[i].dev, num_bytes);
+		map->stripes[i].dev->has_pending_chunks = true;
 	}
 
 	spin_lock(&extent_root->fs_info->free_chunk_lock);
@@ -7250,6 +7251,7 @@ void btrfs_update_commit_device_bytes_used(struct btrfs_root *root,
 		for (i = 0; i < map->num_stripes; i++) {
 			dev = map->stripes[i].dev;
 			dev->commit_bytes_used = dev->bytes_used;
+			dev->has_pending_chunks = false;
 		}
 	}
 	unlock_chunks(root);
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 9c09aa29d6bd..663d66828cca 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -62,6 +62,11 @@ struct btrfs_device {
 
 	spinlock_t io_lock ____cacheline_aligned;
 	int running_pending;
+	/* When true means this device has pending chunk alloc in
+	 * current transaction. Protected by chunk_mutex.
+	 */
+	bool has_pending_chunks;
+
 	/* regular prio bios */
 	struct btrfs_pending_bios pending_bios;
 	/* WRITE_SYNC bios */
-- 
2.17.1

