Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24890E67C2
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:24:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732453AbfJ0VYJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:24:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:45662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732428AbfJ0VYI (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:24:08 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C337621783;
        Sun, 27 Oct 2019 21:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211448;
        bh=9bcCU39ZWTggCACE2Egvoc42+x08ORp7iVYCKacHHeo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ft6tkr6pUyRRbf/UB/dli8IxNHc59S/CNheYJoeNBlvoH/K7ec+cmK6Bscw7pHDyp
         5DpKbhbVfY+QfYhqArequ84rtcWNCHkfpL1rdhTnYbKVkbGGTZ8ewD9zxeO8pCQzss
         LIoOgvp0DjXGLTuG6mMfSTZtR0+z7zsOMtyJOXAU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chenwandun <chenwandun@huawei.com>,
        Minchan Kim <minchan@kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.3 155/197] zram: fix race between backing_dev_show and backing_dev_store
Date:   Sun, 27 Oct 2019 22:01:13 +0100
Message-Id: <20191027203400.055050644@linuxfoundation.org>
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

From: Chenwandun <chenwandun@huawei.com>

commit f7daefe4231e57381d92c2e2ad905a899c28e402 upstream.

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
  d_path+0xcc/0x174
  file_path+0x10/0x18
  backing_dev_show+0x40/0xb4
  dev_attr_show+0x20/0x54
  sysfs_kf_seq_show+0x9c/0x10c
  kernfs_seq_show+0x28/0x30
  seq_read+0x184/0x488
  kernfs_fop_read+0x5c/0x1a4
  __vfs_read+0x44/0x128
  vfs_read+0xa0/0x138
  SyS_read+0x54/0xb4

Link: http://lkml.kernel.org/r/1571046839-16814-1-git-send-email-chenwandun@huawei.com
Signed-off-by: Chenwandun <chenwandun@huawei.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: <stable@vger.kernel.org>	[4.14+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/zram/zram_drv.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
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


