Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5292599A5
	for <lists+stable@lfdr.de>; Fri, 28 Jun 2019 14:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbfF1MA2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jun 2019 08:00:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:54138 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726837AbfF1MA2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Jun 2019 08:00:28 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 23730B631;
        Fri, 28 Jun 2019 12:00:27 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>, stable@vger.kernel.org
Subject: [PATCH 04/37] Revert "bcache: set CACHE_SET_IO_DISABLE in bch_cached_dev_error()"
Date:   Fri, 28 Jun 2019 19:59:27 +0800
Message-Id: <20190628120000.40753-5-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190628120000.40753-1-colyli@suse.de>
References: <20190628120000.40753-1-colyli@suse.de>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 6147305c73e4511ca1a975b766b97a779d442567.

Although this patch helps the failed bcache device to stop faster when
too many I/O errors detected on corresponding cached device, setting
CACHE_SET_IO_DISABLE bit to cache set c->flags was not a good idea. This
operation will disable all I/Os on cache set, which means other attached
bcache devices won't work neither.

Without this patch, the failed bcache device can also be stopped
eventually if internal I/O accomplished (e.g. writeback). Therefore here
I revert it.

Fixes: 6147305c73e4 ("bcache: set CACHE_SET_IO_DISABLE in bch_cached_dev_error()")
Reported-by: Yong Li <mr.liyong@qq.com>
Signed-off-by: Coly Li <colyli@suse.de>
Cc: stable@vger.kernel.org
---
 drivers/md/bcache/super.c | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 64d9de89a63f..ba2ad093bc80 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1437,8 +1437,6 @@ int bch_flash_dev_create(struct cache_set *c, uint64_t size)
 
 bool bch_cached_dev_error(struct cached_dev *dc)
 {
-	struct cache_set *c;
-
 	if (!dc || test_bit(BCACHE_DEV_CLOSING, &dc->disk.flags))
 		return false;
 
@@ -1449,21 +1447,6 @@ bool bch_cached_dev_error(struct cached_dev *dc)
 	pr_err("stop %s: too many IO errors on backing device %s\n",
 		dc->disk.disk->disk_name, dc->backing_dev_name);
 
-	/*
-	 * If the cached device is still attached to a cache set,
-	 * even dc->io_disable is true and no more I/O requests
-	 * accepted, cache device internal I/O (writeback scan or
-	 * garbage collection) may still prevent bcache device from
-	 * being stopped. So here CACHE_SET_IO_DISABLE should be
-	 * set to c->flags too, to make the internal I/O to cache
-	 * device rejected and stopped immediately.
-	 * If c is NULL, that means the bcache device is not attached
-	 * to any cache set, then no CACHE_SET_IO_DISABLE bit to set.
-	 */
-	c = dc->disk.c;
-	if (c && test_and_set_bit(CACHE_SET_IO_DISABLE, &c->flags))
-		pr_info("CACHE_SET_IO_DISABLE already set");
-
 	bcache_device_stop(&dc->disk);
 	return true;
 }
-- 
2.16.4

