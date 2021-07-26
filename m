Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF0B03D5520
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 10:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233101AbhGZHdD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 03:33:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:41668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233109AbhGZHcz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 03:32:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC5CF60F37;
        Mon, 26 Jul 2021 08:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627287204;
        bh=rRZ1voSL+PQMiqbPW3j26mPS3sBF5DGL8ivNUP926kQ=;
        h=Subject:To:Cc:From:Date:From;
        b=0tAUqVcarkpeinO5HcktsjAdNpRCZpX27g1v2TyFNMxbc4yWxz8c0ZUv6W697oZZ0
         9xruVZWAElg37UOP9Uwl5ohR1gO7wmOdIHqUQsRlgYW5wi8gGL0B0jriE3enYxPias
         BAiDgFSG5DULWd8KbKUcO+VZaDXRMWpj5gzZyi9Q=
Subject: FAILED: patch "[PATCH] mmc: core: Use kref in place of struct mmc_blk_data::usage" failed to apply to 5.10-stable tree
To:     swboyd@chromium.org, matthias.schiffer@ew.tq-group.com,
        sujitka@chromium.org, ulf.hansson@linaro.org, zsm@chromium.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 26 Jul 2021 10:06:56 +0200
Message-ID: <1627286816205108@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From edb25572fc7058db5a98223e11d2d50497178553 Mon Sep 17 00:00:00 2001
From: Stephen Boyd <swboyd@chromium.org>
Date: Wed, 23 Jun 2021 00:50:01 -0700
Subject: [PATCH] mmc: core: Use kref in place of struct mmc_blk_data::usage

Ulf reported the following KASAN splat after adding some manual hacks
into mmc-utils[1].

 DEBUG: mmc_blk_open: Let's sleep for 10s..
 mmc1: card 0007 removed
 BUG: KASAN: use-after-free in mmc_blk_get+0x58/0xb8
 Read of size 4 at addr ffff00000a394a28 by task mmc/180

 CPU: 2 PID: 180 Comm: mmc Not tainted 5.10.0-rc4-00069-gcc758c8c7127-dirty #5
 Hardware name: Qualcomm Technologies, Inc. APQ 8016 SBC (DT)
 Call trace:
  dump_backtrace+0x0/0x2b4
  show_stack+0x18/0x6c
  dump_stack+0xfc/0x168
  print_address_description.constprop.0+0x6c/0x488
  kasan_report+0x118/0x210
  __asan_load4+0x94/0xd0
  mmc_blk_get+0x58/0xb8
  mmc_blk_open+0x7c/0xdc
  __blkdev_get+0x3b4/0x964
  blkdev_get+0x64/0x100
  blkdev_open+0xe8/0x104
  do_dentry_open+0x234/0x61c
  vfs_open+0x54/0x64
  path_openat+0xe04/0x1584
  do_filp_open+0xe8/0x1e4
  do_sys_openat2+0x120/0x230
  __arm64_sys_openat+0xf0/0x15c
  el0_svc_common.constprop.0+0xac/0x234
  do_el0_svc+0x84/0xa0
  el0_sync_handler+0x264/0x270
  el0_sync+0x174/0x180

 Allocated by task 33:
  stack_trace_save+0x9c/0xdc
  kasan_save_stack+0x28/0x60
  __kasan_kmalloc.constprop.0+0xc8/0xf0
  kasan_kmalloc+0x10/0x20
  mmc_blk_alloc_req+0x94/0x4b0
  mmc_blk_probe+0x2d4/0xaa4
  mmc_bus_probe+0x34/0x4c
  really_probe+0x148/0x6e0
  driver_probe_device+0x78/0xec
  __device_attach_driver+0x108/0x16c
  bus_for_each_drv+0xf4/0x15c
  __device_attach+0x168/0x240
  device_initial_probe+0x14/0x20
  bus_probe_device+0xec/0x100
  device_add+0x55c/0xaf0
  mmc_add_card+0x288/0x380
  mmc_attach_sd+0x18c/0x22c
  mmc_rescan+0x444/0x4f0
  process_one_work+0x3b8/0x650
  worker_thread+0xa0/0x724
  kthread+0x218/0x220
  ret_from_fork+0x10/0x38

 Freed by task 33:
  stack_trace_save+0x9c/0xdc
  kasan_save_stack+0x28/0x60
  kasan_set_track+0x28/0x40
  kasan_set_free_info+0x24/0x4c
  __kasan_slab_free+0x100/0x180
  kasan_slab_free+0x14/0x20
  kfree+0xb8/0x46c
  mmc_blk_put+0xe4/0x11c
  mmc_blk_remove_req.part.0+0x6c/0xe4
  mmc_blk_remove+0x368/0x370
  mmc_bus_remove+0x34/0x50
  __device_release_driver+0x228/0x31c
  device_release_driver+0x2c/0x44
  bus_remove_device+0x1e4/0x200
  device_del+0x2b0/0x770
  mmc_remove_card+0xf0/0x150
  mmc_sd_detect+0x9c/0x150
  mmc_rescan+0x110/0x4f0
  process_one_work+0x3b8/0x650
  worker_thread+0xa0/0x724
  kthread+0x218/0x220
  ret_from_fork+0x10/0x38

 The buggy address belongs to the object at ffff00000a394800
  which belongs to the cache kmalloc-1k of size 1024
 The buggy address is located 552 bytes inside of
  1024-byte region [ffff00000a394800, ffff00000a394c00)
 The buggy address belongs to the page:
 page:00000000ff84ed53 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x8a390
 head:00000000ff84ed53 order:3 compound_mapcount:0 compound_pincount:0
 flags: 0x3fffc0000010200(slab|head)
 raw: 03fffc0000010200 dead000000000100 dead000000000122 ffff000009f03800
 raw: 0000000000000000 0000000000100010 00000001ffffffff 0000000000000000
 page dumped because: kasan: bad access detected

 Memory state around the buggy address:
  ffff00000a394900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff00000a394980: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 >ffff00000a394a00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                   ^
  ffff00000a394a80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff00000a394b00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb

Looking closer at the problem, it looks like a classic dangling pointer
bug. The 'struct mmc_blk_data' that is used after being freed in
mmc_blk_put() is stashed away in 'md->disk->private_data' via
mmc_blk_alloc_req() but used in mmc_blk_get() because the 'usage' count
isn't properly aligned with the lifetime of the pointer. You'd expect
the 'usage' member to be in sync with the kfree(), and it mostly is,
except that mmc_blk_get() needs to dereference the potentially freed
memory storage for the 'struct mmc_blk_data' stashed away in the
private_data member to look at 'usage' before it actually figures out if
it wants to consider it a valid pointer or not. That's not going to work
if the freed memory has been overwritten by something else after the
free, and KASAN rightly complains here.

To fix the immediate problem, let's set the private_data member to NULL
in mmc_blk_put() so that mmc_blk_get() can consider the object "on the
way out" if the pointer is NULL and not even try to look at 'usage' if
the object isn't going to be around much longer. With that set to NULL
on the last mmc_blk_put(), optimize the get path further and use a kref
underneath the 'open_lock' mutex to only up the reference count if it's
non-zero, i.e.  alive, and otherwise make mmc_blk_get() return NULL,
without actually testing the reference count if we're in the process of
removing the object from the system.

Finally, tighten the locking region on the put side to only be around
the parts that are removing the 'mmc_blk_data' from the system and
publishing that fact to the gendisk and then drop the lock as soon as we
can to avoid holding the lock around code that doesn't need it. This
fixes the KASAN issue.

Cc: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Cc: Sujit Kautkar <sujitka@chromium.org>
Cc: Zubin Mithra <zsm@chromium.org>
Reported-by: Ulf Hansson <ulf.hansson@linaro.org>
Link: https://lore.kernel.org/linux-mmc/CAPDyKFryT63Jc7+DXWSpAC19qpZRqFr1orxwYGMuSqx247O8cQ@mail.gmail.com/ [1]
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/20210623075002.1746924-2-swboyd@chromium.org
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
index 9890a1532cb0..ce8aed562929 100644
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -28,6 +28,7 @@
 #include <linux/errno.h>
 #include <linux/hdreg.h>
 #include <linux/kdev_t.h>
+#include <linux/kref.h>
 #include <linux/blkdev.h>
 #include <linux/cdev.h>
 #include <linux/mutex.h>
@@ -111,7 +112,7 @@ struct mmc_blk_data {
 #define MMC_BLK_CMD23	(1 << 0)	/* Can do SET_BLOCK_COUNT for multiblock */
 #define MMC_BLK_REL_WR	(1 << 1)	/* MMC Reliable write support */
 
-	unsigned int	usage;
+	struct kref	kref;
 	unsigned int	read_only;
 	unsigned int	part_type;
 	unsigned int	reset_done;
@@ -181,10 +182,8 @@ static struct mmc_blk_data *mmc_blk_get(struct gendisk *disk)
 
 	mutex_lock(&open_lock);
 	md = disk->private_data;
-	if (md && md->usage == 0)
+	if (md && !kref_get_unless_zero(&md->kref))
 		md = NULL;
-	if (md)
-		md->usage++;
 	mutex_unlock(&open_lock);
 
 	return md;
@@ -196,18 +195,25 @@ static inline int mmc_get_devidx(struct gendisk *disk)
 	return devidx;
 }
 
-static void mmc_blk_put(struct mmc_blk_data *md)
+static void mmc_blk_kref_release(struct kref *ref)
 {
-	mutex_lock(&open_lock);
-	md->usage--;
-	if (md->usage == 0) {
-		int devidx = mmc_get_devidx(md->disk);
+	struct mmc_blk_data *md = container_of(ref, struct mmc_blk_data, kref);
+	int devidx;
 
-		ida_simple_remove(&mmc_blk_ida, devidx);
-		put_disk(md->disk);
-		kfree(md);
-	}
+	devidx = mmc_get_devidx(md->disk);
+	ida_simple_remove(&mmc_blk_ida, devidx);
+
+	mutex_lock(&open_lock);
+	md->disk->private_data = NULL;
 	mutex_unlock(&open_lock);
+
+	put_disk(md->disk);
+	kfree(md);
+}
+
+static void mmc_blk_put(struct mmc_blk_data *md)
+{
+	kref_put(&md->kref, mmc_blk_kref_release);
 }
 
 static ssize_t power_ro_lock_show(struct device *dev,
@@ -2327,7 +2333,8 @@ static struct mmc_blk_data *mmc_blk_alloc_req(struct mmc_card *card,
 
 	INIT_LIST_HEAD(&md->part);
 	INIT_LIST_HEAD(&md->rpmbs);
-	md->usage = 1;
+	kref_init(&md->kref);
+
 	md->queue.blkdata = md;
 
 	md->disk->major	= MMC_BLOCK_MAJOR;

