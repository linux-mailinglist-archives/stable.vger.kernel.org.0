Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92354D511B
	for <lists+stable@lfdr.de>; Sat, 12 Oct 2019 18:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728636AbfJLQoB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Oct 2019 12:44:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:44770 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728338AbfJLQmB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 12 Oct 2019 12:42:01 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C5E3CB481;
        Sat, 12 Oct 2019 16:41:59 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 048B2DA7E3; Sat, 12 Oct 2019 18:42:12 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>, stable@vger.kernel.org
Subject: [PATCH] btrfs: don't needlessly create extent-refs kernel thread
Date:   Sat, 12 Oct 2019 18:42:10 +0200
Message-Id: <20191012164210.17081-1-dsterba@suse.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch 32b593bfcb58 ("Btrfs: remove no longer used function to run
delayed refs asynchronously") removed the async delayed refs but the
thread has been created, without any use. Remove it to avoid resource
consumption.

Fixes: 32b593bfcb58 ("Btrfs: remove no longer used function to run delayed refs asynchronously")
CC: stable@vger.kernel.org # 5.2+
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h   | 2 --
 fs/btrfs/disk-io.c | 6 ------
 2 files changed, 8 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index d17e79a40930..ba7981478558 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -734,8 +734,6 @@ struct btrfs_fs_info {
 	struct btrfs_workqueue *fixup_workers;
 	struct btrfs_workqueue *delayed_workers;
 
-	/* the extent workers do delayed refs on the extent allocation tree */
-	struct btrfs_workqueue *extent_workers;
 	struct task_struct *transaction_kthread;
 	struct task_struct *cleaner_kthread;
 	u32 thread_pool_size;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 7d6886f70f8f..5d32deb42993 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2002,7 +2002,6 @@ static void btrfs_stop_all_workers(struct btrfs_fs_info *fs_info)
 	btrfs_destroy_workqueue(fs_info->readahead_workers);
 	btrfs_destroy_workqueue(fs_info->flush_workers);
 	btrfs_destroy_workqueue(fs_info->qgroup_rescan_workers);
-	btrfs_destroy_workqueue(fs_info->extent_workers);
 	/*
 	 * Now that all other work queues are destroyed, we can safely destroy
 	 * the queues used for metadata I/O, since tasks from those other work
@@ -2198,10 +2197,6 @@ static int btrfs_init_workqueues(struct btrfs_fs_info *fs_info,
 				      max_active, 2);
 	fs_info->qgroup_rescan_workers =
 		btrfs_alloc_workqueue(fs_info, "qgroup-rescan", flags, 1, 0);
-	fs_info->extent_workers =
-		btrfs_alloc_workqueue(fs_info, "extent-refs", flags,
-				      min_t(u64, fs_devices->num_devices,
-					    max_active), 8);
 
 	if (!(fs_info->workers && fs_info->delalloc_workers &&
 	      fs_info->flush_workers &&
@@ -2212,7 +2207,6 @@ static int btrfs_init_workqueues(struct btrfs_fs_info *fs_info,
 	      fs_info->endio_freespace_worker && fs_info->rmw_workers &&
 	      fs_info->caching_workers && fs_info->readahead_workers &&
 	      fs_info->fixup_workers && fs_info->delayed_workers &&
-	      fs_info->extent_workers &&
 	      fs_info->qgroup_rescan_workers)) {
 		return -ENOMEM;
 	}
-- 
2.23.0

