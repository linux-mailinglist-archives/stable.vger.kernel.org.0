Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 256FB62357
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390548AbfGHPe3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:34:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:36752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390543AbfGHPe2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:34:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1CF520651;
        Mon,  8 Jul 2019 15:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562600067;
        bh=i6acdeAxEMRD6gcNSjYZvA9AZg+jD55NhOTvfBmifLY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r/TCMQ8VSGHTv7b/OFkcpcWG9Ml9c0sGF8jEfQG/A4rBLKABrI55xfv6c2/hHgFu2
         +rXpdE9jfcOyTEmfcnP5oUljU9Y/zc47uRGa1nOgmyM1cxTmaesGaylRo1BdwOl2dv
         BP+PuzBY4XOl8G3ovPkXWKL+2IEEEBNEzbKrC5Vk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Sterba <dsterba@suse.com>,
        Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 5.1 82/96] btrfs: Ensure replaced device doesnt have pending chunk allocation
Date:   Mon,  8 Jul 2019 17:13:54 +0200
Message-Id: <20190708150530.889083692@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150526.234572443@linuxfoundation.org>
References: <20190708150526.234572443@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolay Borisov <nborisov@suse.com>

commit debd1c065d2037919a7da67baf55cc683fee09f0 upstream.

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

Reported-by: David Sterba <dsterba@suse.com>
Fixes: 391cd9df81ac ("Btrfs: fix unprotected alloc list insertion during the finishing procedure of replace")
CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/dev-replace.c |   26 +++++++++++++++++---------
 fs/btrfs/volumes.c     |    5 ++++-
 fs/btrfs/volumes.h     |    5 +++++
 3 files changed, 26 insertions(+), 10 deletions(-)

--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -603,17 +603,25 @@ static int btrfs_dev_replace_finishing(s
 	}
 	btrfs_wait_ordered_roots(fs_info, U64_MAX, 0, (u64)-1);
 
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
+		ret = btrfs_commit_transaction(trans);
+		WARN_ON(ret);
+		/* keep away write_all_supers() during the finishing procedure */
+		mutex_lock(&fs_info->fs_devices->device_list_mutex);
+		mutex_lock(&fs_info->chunk_mutex);
+		if (src_device->has_pending_chunks) {
+			mutex_unlock(&root->fs_info->chunk_mutex);
+			mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
+		} else {
+			break;
+		}
 	}
-	ret = btrfs_commit_transaction(trans);
-	WARN_ON(ret);
 
-	/* keep away write_all_supers() during the finishing procedure */
-	mutex_lock(&fs_info->fs_devices->device_list_mutex);
-	mutex_lock(&fs_info->chunk_mutex);
 	down_write(&dev_replace->rwsem);
 	dev_replace->replace_state =
 		scrub_ret ? BTRFS_IOCTL_DEV_REPLACE_STATE_CANCELED
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5222,9 +5222,11 @@ static int __btrfs_alloc_chunk(struct bt
 	if (ret)
 		goto error_del_extent;
 
-	for (i = 0; i < map->num_stripes; i++)
+	for (i = 0; i < map->num_stripes; i++) {
 		btrfs_device_set_bytes_used(map->stripes[i].dev,
 				map->stripes[i].dev->bytes_used + stripe_size);
+		map->stripes[i].dev->has_pending_chunks = true;
+	}
 
 	atomic64_sub(stripe_size * map->num_stripes, &info->free_chunk_space);
 
@@ -7716,6 +7718,7 @@ void btrfs_update_commit_device_bytes_us
 		for (i = 0; i < map->num_stripes; i++) {
 			dev = map->stripes[i].dev;
 			dev->commit_bytes_used = dev->bytes_used;
+			dev->has_pending_chunks = false;
 		}
 	}
 	mutex_unlock(&fs_info->chunk_mutex);
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -54,6 +54,11 @@ struct btrfs_device {
 
 	spinlock_t io_lock ____cacheline_aligned;
 	int running_pending;
+	/* When true means this device has pending chunk alloc in
+	 * current transaction. Protected by chunk_mutex.
+	 */
+	bool has_pending_chunks;
+
 	/* regular prio bios */
 	struct btrfs_pending_bios pending_bios;
 	/* sync bios */


