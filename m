Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95CC5DF6F5
	for <lists+stable@lfdr.de>; Mon, 21 Oct 2019 22:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730362AbfJUUnf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Oct 2019 16:43:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:44182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730293AbfJUUnf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Oct 2019 16:43:35 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9725820882;
        Mon, 21 Oct 2019 20:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571690614;
        bh=oi3dKi/Dv1WkTPceygh5z+KeDVAV61/rYP2DagYbUdE=;
        h=Date:From:To:Subject:From;
        b=byx/x/RYPswnxFIVrWDGwUJsVk9itOp3+UO2nY4TCH1dSRox29r8V6kmK2C2EY1T8
         BZXjBfpeSaxKjX7YDj0jBzjrieqjuwtdaBYXIupkcaMBbKsZhP6O2iuw3F2DDmjj6v
         Skfb/M1aovA+berE82stBkP0psnMrnuqVjNCmcgg=
Date:   Mon, 21 Oct 2019 13:43:34 -0700
From:   akpm@linux-foundation.org
To:     axboe@kernel.dk, chenwandun@huawei.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, sergey.senozhatsky.work@gmail.com,
        stable@vger.kernel.org
Subject:  [merged]
 zram-fix-race-between-backing_dev_show-and-backing_dev_store.patch removed
 from -mm tree
Message-ID: <20191021204334.LT8tOP0fk%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: zram: fix race between backing_dev_show and backing_dev_store
has been removed from the -mm tree.  Its filename was
     zram-fix-race-between-backing_dev_show-and-backing_dev_store.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chenwandun <chenwandun@huawei.com>
Subject: zram: fix race between backing_dev_show and backing_dev_store

CPU0:				       CPU1:
backing_dev_show		       backing_dev_store
    ......				   ......
    file = zram->backing_dev;
    down_read(&zram->init_lock);	   down_read(&zram->init_init_lock)
    file_path(file, ...);		   zram->backing_dev = backing_dev;
    up_read(&zram->init_lock);		   up_read(&zram->init_lock);

gets the value of zram->backing_dev too early in backing_dev_show, which
resultin the value being NULL at the beginning, and not NULL later.

backtrace:
[<ffffff8570e0f3ec>] d_path+0xcc/0x174
[<ffffff8570decd90>] file_path+0x10/0x18
[<ffffff85712f7630>] backing_dev_show+0x40/0xb4
[<ffffff85712c776c>] dev_attr_show+0x20/0x54
[<ffffff8570e835e4>] sysfs_kf_seq_show+0x9c/0x10c
[<ffffff8570e82b98>] kernfs_seq_show+0x28/0x30
[<ffffff8570e1c580>] seq_read+0x184/0x488
[<ffffff8570e81ec4>] kernfs_fop_read+0x5c/0x1a4
[<ffffff8570dee0fc>] __vfs_read+0x44/0x128
[<ffffff8570dee310>] vfs_read+0xa0/0x138
[<ffffff8570dee860>] SyS_read+0x54/0xb4

Link: http://lkml.kernel.org/r/1571046839-16814-1-git-send-email-chenwandun@huawei.com
Signed-off-by: Chenwandun <chenwandun@huawei.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: <stable@vger.kernel.org>	[4.14+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-fix-race-between-backing_dev_show-and-backing_dev_store
+++ a/drivers/block/zram/zram_drv.c
@@ -413,13 +413,14 @@ static void reset_bdev(struct zram *zram
 static ssize_t backing_dev_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
+	struct file *file;
 	struct zram *zram = dev_to_zram(dev);
-	struct file *file = zram->backing_dev;
 	char *p;
 	ssize_t ret;
 
 	down_read(&zram->init_lock);
-	if (!zram->backing_dev) {
+	file = zram->backing_dev;
+	if (!file) {
 		memcpy(buf, "none\n", 5);
 		up_read(&zram->init_lock);
 		return 5;
_

Patches currently in -mm which might be from chenwandun@huawei.com are


