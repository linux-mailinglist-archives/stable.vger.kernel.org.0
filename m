Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 753D7E6807
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:26:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732895AbfJ0V0Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:26:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:48182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732891AbfJ0V0O (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:26:14 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59DE9222C9;
        Sun, 27 Oct 2019 21:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211573;
        bh=6nO+AR2fnfay1owM09QIsyt2LwsgCbKrNTQqyfGoboI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C8RNtT6BBnF5crZNc+omWp9St6e3QF3CZ1pXt35WdEuGT304XtUL9CXDNWBZwWWon
         t6G1RNSR9mw4O++XFa20Su5QIgVaIvQvxFDFWZ490DyqqXJ0x05lUo1k7GgVmWpM7w
         6f915cxXRRX+qj4SNVUkeiHuQO+xS3ob6qE1Btns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.3 183/197] btrfs: dont needlessly create extent-refs kernel thread
Date:   Sun, 27 Oct 2019 22:01:41 +0100
Message-Id: <20191027203406.352458705@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Sterba <dsterba@suse.com>

commit 80ed4548d0711d15ca51be5dee0ff813051cfc90 upstream.

The patch 32b593bfcb58 ("Btrfs: remove no longer used function to run
delayed refs asynchronously") removed the async delayed refs but the
thread has been created, without any use. Remove it to avoid resource
consumption.

Fixes: 32b593bfcb58 ("Btrfs: remove no longer used function to run delayed refs asynchronously")
CC: stable@vger.kernel.org # 5.2+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/ctree.h   |    2 --
 fs/btrfs/disk-io.c |    6 ------
 2 files changed, 8 deletions(-)

--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -908,8 +908,6 @@ struct btrfs_fs_info {
 	struct btrfs_workqueue *fixup_workers;
 	struct btrfs_workqueue *delayed_workers;
 
-	/* the extent workers do delayed refs on the extent allocation tree */
-	struct btrfs_workqueue *extent_workers;
 	struct task_struct *transaction_kthread;
 	struct task_struct *cleaner_kthread;
 	u32 thread_pool_size;
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2036,7 +2036,6 @@ static void btrfs_stop_all_workers(struc
 	btrfs_destroy_workqueue(fs_info->readahead_workers);
 	btrfs_destroy_workqueue(fs_info->flush_workers);
 	btrfs_destroy_workqueue(fs_info->qgroup_rescan_workers);
-	btrfs_destroy_workqueue(fs_info->extent_workers);
 	/*
 	 * Now that all other work queues are destroyed, we can safely destroy
 	 * the queues used for metadata I/O, since tasks from those other work
@@ -2242,10 +2241,6 @@ static int btrfs_init_workqueues(struct
 				      max_active, 2);
 	fs_info->qgroup_rescan_workers =
 		btrfs_alloc_workqueue(fs_info, "qgroup-rescan", flags, 1, 0);
-	fs_info->extent_workers =
-		btrfs_alloc_workqueue(fs_info, "extent-refs", flags,
-				      min_t(u64, fs_devices->num_devices,
-					    max_active), 8);
 
 	if (!(fs_info->workers && fs_info->delalloc_workers &&
 	      fs_info->submit_workers && fs_info->flush_workers &&
@@ -2256,7 +2251,6 @@ static int btrfs_init_workqueues(struct
 	      fs_info->endio_freespace_worker && fs_info->rmw_workers &&
 	      fs_info->caching_workers && fs_info->readahead_workers &&
 	      fs_info->fixup_workers && fs_info->delayed_workers &&
-	      fs_info->extent_workers &&
 	      fs_info->qgroup_rescan_workers)) {
 		return -ENOMEM;
 	}


