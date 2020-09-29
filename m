Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED3E27CCCC
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729241AbgI2MjB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:39:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:33900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729363AbgI2LRF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:17:05 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13BF7208B8;
        Tue, 29 Sep 2020 11:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378224;
        bh=HaEK1ZZTGTBuHSHIFKqcYdSkijCp6uuTml9ia6HnfMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NwFijZ0pGLXnE/23GOCCdmvs391j+u4ICX5BWSpGB0Xdvjc1caW530ng2t/4J42a0
         mqIw1KEvsGHpaTUQ0hw+rZn5vSaD1L/ODkkXBMoXUXdP5GizzDifaHPMKiZFSpDxtD
         XQ84B7wrcU7ZczYb0EZbyEl9voEJHxS8ZrSzHANs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Guenter Roeck <groeck@chromium.org>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 105/166] bdev: Reduce time holding bd_mutex in sync in blkdev_close()
Date:   Tue, 29 Sep 2020 13:00:17 +0200
Message-Id: <20200929105940.451409033@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105935.184737111@linuxfoundation.org>
References: <20200929105935.184737111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit b849dd84b6ccfe32622988b79b7b073861fcf9f7 ]

While trying to "dd" to the block device for a USB stick, I
encountered a hung task warning (blocked for > 120 seconds).  I
managed to come up with an easy way to reproduce this on my system
(where /dev/sdb is the block device for my USB stick) with:

  while true; do dd if=/dev/zero of=/dev/sdb bs=4M; done

With my reproduction here are the relevant bits from the hung task
detector:

 INFO: task udevd:294 blocked for more than 122 seconds.
 ...
 udevd           D    0   294      1 0x00400008
 Call trace:
  ...
  mutex_lock_nested+0x40/0x50
  __blkdev_get+0x7c/0x3d4
  blkdev_get+0x118/0x138
  blkdev_open+0x94/0xa8
  do_dentry_open+0x268/0x3a0
  vfs_open+0x34/0x40
  path_openat+0x39c/0xdf4
  do_filp_open+0x90/0x10c
  do_sys_open+0x150/0x3c8
  ...

 ...
 Showing all locks held in the system:
 ...
 1 lock held by dd/2798:
  #0: ffffff814ac1a3b8 (&bdev->bd_mutex){+.+.}, at: __blkdev_put+0x50/0x204
 ...
 dd              D    0  2798   2764 0x00400208
 Call trace:
  ...
  schedule+0x8c/0xbc
  io_schedule+0x1c/0x40
  wait_on_page_bit_common+0x238/0x338
  __lock_page+0x5c/0x68
  write_cache_pages+0x194/0x500
  generic_writepages+0x64/0xa4
  blkdev_writepages+0x24/0x30
  do_writepages+0x48/0xa8
  __filemap_fdatawrite_range+0xac/0xd8
  filemap_write_and_wait+0x30/0x84
  __blkdev_put+0x88/0x204
  blkdev_put+0xc4/0xe4
  blkdev_close+0x28/0x38
  __fput+0xe0/0x238
  ____fput+0x1c/0x28
  task_work_run+0xb0/0xe4
  do_notify_resume+0xfc0/0x14bc
  work_pending+0x8/0x14

The problem appears related to the fact that my USB disk is terribly
slow and that I have a lot of RAM in my system to cache things.
Specifically my writes seem to be happening at ~15 MB/s and I've got
~4 GB of RAM in my system that can be used for buffering.  To write 4
GB of buffer to disk thus takes ~4000 MB / ~15 MB/s = ~267 seconds.

The 267 second number is a problem because in __blkdev_put() we call
sync_blockdev() while holding the bd_mutex.  Any other callers who
want the bd_mutex will be blocked for the whole time.

The problem is made worse because I believe blkdev_put() specifically
tells other tasks (namely udev) to go try to access the device at right
around the same time we're going to hold the mutex for a long time.

Putting some traces around this (after disabling the hung task detector),
I could confirm:
 dd:    437.608600: __blkdev_put() right before sync_blockdev() for sdb
 udevd: 437.623901: blkdev_open() right before blkdev_get() for sdb
 dd:    661.468451: __blkdev_put() right after sync_blockdev() for sdb
 udevd: 663.820426: blkdev_open() right after blkdev_get() for sdb

A simple fix for this is to realize that sync_blockdev() works fine if
you're not holding the mutex.  Also, it's not the end of the world if
you sync a little early (though it can have performance impacts).
Thus we can make a guess that we're going to need to do the sync and
then do it without holding the mutex.  We still do one last sync with
the mutex but it should be much, much faster.

With this, my hung task warnings for my test case are gone.

Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Guenter Roeck <groeck@chromium.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/block_dev.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 77ce77a283247..23fb999b49e15 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1777,6 +1777,16 @@ static void __blkdev_put(struct block_device *bdev, fmode_t mode, int for_part)
 	struct gendisk *disk = bdev->bd_disk;
 	struct block_device *victim = NULL;
 
+	/*
+	 * Sync early if it looks like we're the last one.  If someone else
+	 * opens the block device between now and the decrement of bd_openers
+	 * then we did a sync that we didn't need to, but that's not the end
+	 * of the world and we want to avoid long (could be several minute)
+	 * syncs while holding the mutex.
+	 */
+	if (bdev->bd_openers == 1)
+		sync_blockdev(bdev);
+
 	mutex_lock_nested(&bdev->bd_mutex, for_part);
 	if (for_part)
 		bdev->bd_part_count--;
-- 
2.25.1



