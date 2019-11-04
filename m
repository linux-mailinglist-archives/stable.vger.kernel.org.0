Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4B2EEFFD
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:25:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730695AbfKDVwM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:52:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:45552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730690AbfKDVwM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:52:12 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E2E8217F5;
        Mon,  4 Nov 2019 21:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904331;
        bh=Ew1uxJTVJthNfzNREG7gYLsWwvyHdnXZixxGGJqsyBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UkcK20AvDSgUvxLkTjh+zLb+TvyollYHzaHN7vzsqFvoD2BRUXdT6N5bOAH6QBqmj
         GczXFe4FH3TlhPgr1hyakHl3jBKmiXNOUoyn6lgKhKC45aiDwYN7ek6KerryfwdiFw
         FAu1WXcc3ivSTWbAO8piLuHSdU/sTZaSwCuHLa30=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chenwandun <chenwandun@huawei.com>,
        Minchan Kim <minchan@kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 01/95] zram: fix race between backing_dev_show and backing_dev_store
Date:   Mon,  4 Nov 2019 22:43:59 +0100
Message-Id: <20191104212038.811379835@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212038.056365853@linuxfoundation.org>
References: <20191104212038.056365853@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit f7daefe4231e57381d92c2e2ad905a899c28e402 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/zram/zram_drv.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 133178c9b2cf3..1b4e195c0d3c9 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -291,13 +291,14 @@ static void reset_bdev(struct zram *zram)
 static ssize_t backing_dev_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
+	struct file *file;
 	struct zram *zram = dev_to_zram(dev);
-	struct file *file = zram->backing_dev;
 	char *p;
 	ssize_t ret;
 
 	down_read(&zram->init_lock);
-	if (!zram_wb_enabled(zram)) {
+	file = zram->backing_dev;
+	if (!file) {
 		memcpy(buf, "none\n", 5);
 		up_read(&zram->init_lock);
 		return 5;
-- 
2.20.1



