Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1832059CF
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 19:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387818AbgFWRoD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 13:44:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:60076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733192AbgFWRfb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 13:35:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 480E72078A;
        Tue, 23 Jun 2020 17:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592933730;
        bh=S4OBt6uJBfnbnKcJpzwKgOczPbY5w4kwCO+lHH4TmuU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CBAaz7twN0zNX/0GglqJF1FNbXY3krQKt0T4gFxYMITTlIpxh+lwASC4bp7bCE5gm
         wMaDiDopjFY9JPPHNq/HnTswh2PKUwKWdnhpRuqaYpIV2rkdq43dd0mDDNahbORkSG
         SutcuYjCA+jAt3SUxBOnzrH0GX4JYvqYqnEY1pj4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauricio Faria de Oliveira <mfo@canonical.com>,
        Ryan Finnie <ryan@finnie.org>,
        Sebastian Marsching <sebastian@marsching.com>,
        Coly Li <colyli@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-bcache@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 05/28] bcache: check and adjust logical block size for backing devices
Date:   Tue, 23 Jun 2020 13:35:00 -0400
Message-Id: <20200623173523.1355411-5-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200623173523.1355411-1-sashal@kernel.org>
References: <20200623173523.1355411-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauricio Faria de Oliveira <mfo@canonical.com>

[ Upstream commit dcacbc1242c71e18fa9d2eadc5647e115c9c627d ]

It's possible for a block driver to set logical block size to
a value greater than page size incorrectly; e.g. bcache takes
the value from the superblock, set by the user w/ make-bcache.

This causes a BUG/NULL pointer dereference in the path:

  __blkdev_get()
  -> set_init_blocksize() // set i_blkbits based on ...
     -> bdev_logical_block_size()
        -> queue_logical_block_size() // ... this value
  -> bdev_disk_changed()
     ...
     -> blkdev_readpage()
        -> block_read_full_page()
           -> create_page_buffers() // size = 1 << i_blkbits
              -> create_empty_buffers() // give size/take pointer
                 -> alloc_page_buffers() // return NULL
                 .. BUG!

Because alloc_page_buffers() is called with size > PAGE_SIZE,
thus it initializes head = NULL, skips the loop, return head;
then create_empty_buffers() gets (and uses) the NULL pointer.

This has been around longer than commit ad6bf88a6c19 ("block:
fix an integer overflow in logical block size"); however, it
increased the range of values that can trigger the issue.

Previously only 8k/16k/32k (on x86/4k page size) would do it,
as greater values overflow unsigned short to zero, and queue_
logical_block_size() would then use the default of 512.

Now the range with unsigned int is much larger, and users w/
the 512k value, which happened to be zero'ed previously and
work fine, started to hit this issue -- as the zero is gone,
and queue_logical_block_size() does return 512k (>PAGE_SIZE.)

Fix this by checking the bcache device's logical block size,
and if it's greater than page size, fallback to the backing/
cached device's logical page size.

This doesn't affect cache devices as those are still checked
for block/page size in read_super(); only the backing/cached
devices are not.

Apparently it's a regression from commit 2903381fce71 ("bcache:
Take data offset from the bdev superblock."), moving the check
into BCACHE_SB_VERSION_CDEV only. Now that we have superblocks
of backing devices out there with this larger value, we cannot
refuse to load them (i.e., have a similar check in _BDEV.)

Ideally perhaps bcache should use all values from the backing
device (physical/logical/io_min block size)? But for now just
fix the problematic case.

Test-case:

    # IMG=/root/disk.img
    # dd if=/dev/zero of=$IMG bs=1 count=0 seek=1G
    # DEV=$(losetup --find --show $IMG)
    # make-bcache --bdev $DEV --block 8k
      < see dmesg >

Before:

    # uname -r
    5.7.0-rc7

    [   55.944046] BUG: kernel NULL pointer dereference, address: 0000000000000000
    ...
    [   55.949742] CPU: 3 PID: 610 Comm: bcache-register Not tainted 5.7.0-rc7 #4
    ...
    [   55.952281] RIP: 0010:create_empty_buffers+0x1a/0x100
    ...
    [   55.966434] Call Trace:
    [   55.967021]  create_page_buffers+0x48/0x50
    [   55.967834]  block_read_full_page+0x49/0x380
    [   55.972181]  do_read_cache_page+0x494/0x610
    [   55.974780]  read_part_sector+0x2d/0xaa
    [   55.975558]  read_lba+0x10e/0x1e0
    [   55.977904]  efi_partition+0x120/0x5a6
    [   55.980227]  blk_add_partitions+0x161/0x390
    [   55.982177]  bdev_disk_changed+0x61/0xd0
    [   55.982961]  __blkdev_get+0x350/0x490
    [   55.983715]  __device_add_disk+0x318/0x480
    [   55.984539]  bch_cached_dev_run+0xc5/0x270
    [   55.986010]  register_bcache.cold+0x122/0x179
    [   55.987628]  kernfs_fop_write+0xbc/0x1a0
    [   55.988416]  vfs_write+0xb1/0x1a0
    [   55.989134]  ksys_write+0x5a/0xd0
    [   55.989825]  do_syscall_64+0x43/0x140
    [   55.990563]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
    [   55.991519] RIP: 0033:0x7f7d60ba3154
    ...

After:

    # uname -r
    5.7.0.bcachelbspgsz

    [   31.672460] bcache: bcache_device_init() bcache0: sb/logical block size (8192) greater than page size (4096) falling back to device logical block size (512)
    [   31.675133] bcache: register_bdev() registered backing device loop0

    # grep ^ /sys/block/bcache0/queue/*_block_size
    /sys/block/bcache0/queue/logical_block_size:512
    /sys/block/bcache0/queue/physical_block_size:8192

Reported-by: Ryan Finnie <ryan@finnie.org>
Reported-by: Sebastian Marsching <sebastian@marsching.com>
Signed-off-by: Mauricio Faria de Oliveira <mfo@canonical.com>
Signed-off-by: Coly Li <colyli@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/super.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 4d8bf731b118c..a2e5a0fcd7d5c 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -819,7 +819,8 @@ static void bcache_device_free(struct bcache_device *d)
 }
 
 static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
-			      sector_t sectors, make_request_fn make_request_fn)
+			      sector_t sectors, make_request_fn make_request_fn,
+			      struct block_device *cached_bdev)
 {
 	struct request_queue *q;
 	const size_t max_stripes = min_t(size_t, INT_MAX,
@@ -885,6 +886,21 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
 	q->limits.io_min		= block_size;
 	q->limits.logical_block_size	= block_size;
 	q->limits.physical_block_size	= block_size;
+
+	if (q->limits.logical_block_size > PAGE_SIZE && cached_bdev) {
+		/*
+		 * This should only happen with BCACHE_SB_VERSION_BDEV.
+		 * Block/page size is checked for BCACHE_SB_VERSION_CDEV.
+		 */
+		pr_info("%s: sb/logical block size (%u) greater than page size "
+			"(%lu) falling back to device logical block size (%u)",
+			d->disk->disk_name, q->limits.logical_block_size,
+			PAGE_SIZE, bdev_logical_block_size(cached_bdev));
+
+		/* This also adjusts physical block size/min io size if needed */
+		blk_queue_logical_block_size(q, bdev_logical_block_size(cached_bdev));
+	}
+
 	blk_queue_flag_set(QUEUE_FLAG_NONROT, d->disk->queue);
 	blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, d->disk->queue);
 	blk_queue_flag_set(QUEUE_FLAG_DISCARD, d->disk->queue);
@@ -1342,7 +1358,7 @@ static int cached_dev_init(struct cached_dev *dc, unsigned int block_size)
 
 	ret = bcache_device_init(&dc->disk, block_size,
 			 dc->bdev->bd_part->nr_sects - dc->sb.data_offset,
-			 cached_dev_make_request);
+			 cached_dev_make_request, dc->bdev);
 	if (ret)
 		return ret;
 
@@ -1455,7 +1471,7 @@ static int flash_dev_run(struct cache_set *c, struct uuid_entry *u)
 	kobject_init(&d->kobj, &bch_flash_dev_ktype);
 
 	if (bcache_device_init(d, block_bytes(c), u->sectors,
-			flash_dev_make_request))
+			flash_dev_make_request, NULL))
 		goto err;
 
 	bcache_device_attach(d, c, u - c->uuids);
-- 
2.25.1

