Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7EB3D815E
	for <lists+stable@lfdr.de>; Tue, 15 Oct 2019 22:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733277AbfJOU6h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Oct 2019 16:58:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:49298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728276AbfJOU6g (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Oct 2019 16:58:36 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B11CF2083B;
        Tue, 15 Oct 2019 20:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571173116;
        bh=rB4fqiNCshP7e91BgjdHJfQFEZmxuyy9WJEBi5yOt8M=;
        h=Date:From:To:Subject:From;
        b=MBC45PoVFaTf1+F8uCCuruJGv+K/dlgwdzYN0b7IXkfem7JeW/esUgzLqZ1+N+56E
         Kk0IICsWTNRDWWx1ONm0QycUWtlQyxe4Z1NPHtWw68VKCmyXPdBQ9sW3Ne/H010tLR
         Li2+81yOcgDXyh9lwSctrVw+5QGLx8g+V4LJWv00=
Date:   Tue, 15 Oct 2019 13:58:35 -0700
From:   akpm@linux-foundation.org
To:     axboe@kernel.dk, chenwandun@huawei.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, sergey.senozhatsky.work@gmail.com,
        stable@vger.kernel.org
Subject:  +
 zram-fix-race-between-backing_dev_show-and-backing_dev_store.patch added to
 -mm tree
Message-ID: <20191015205835.C6MQoq9Iw%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: zram: fix race between backing_dev_show and backing_dev_store
has been added to the -mm tree.  Its filename is
     zram-fix-race-between-backing_dev_show-and-backing_dev_store.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-fix-race-between-backing_dev_show-and-backing_dev_store.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-fix-race-between-backing_dev_show-and-backing_dev_store.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

zram-fix-race-between-backing_dev_show-and-backing_dev_store.patch

