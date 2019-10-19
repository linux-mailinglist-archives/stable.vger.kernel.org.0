Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA514DD656
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 05:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727325AbfJSDUQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 23:20:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:33610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727181AbfJSDUQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 23:20:16 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 393B822468;
        Sat, 19 Oct 2019 03:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571455215;
        bh=N/iUHVGm7NC7r721VMBmrmymMT3Cc/PZyZIjY0Jy73U=;
        h=Date:From:To:Subject:From;
        b=sp6ztH3mYRlbskEwsjYx7hqyLf08QBspii6u5RcawlHxCmTA5UW6Xz+ngVdxOSxdE
         8dqBU37lx86rbNWvCNLDlNeUWhevsLs7H90LsBEcwKvorEl0NNhrXXmSzquEOYd4QC
         FCTf3AaJKqLKhQ+VIkq1xH4xQ2tsEdYxF0gDJZqw=
Date:   Fri, 18 Oct 2019 20:20:14 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, axboe@kernel.dk, chenwandun@huawei.com,
        linux-mm@kvack.org, minchan@kernel.org, mm-commits@vger.kernel.org,
        sergey.senozhatsky.work@gmail.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 17/26] zram: fix race between backing_dev_show and
 backing_dev_store
Message-ID: <20191019032014.mkysg81b4%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
