Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDBB173CD1
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391976AbfGXT52 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:57:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:42832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390624AbfGXT52 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:57:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C82A622ADA;
        Wed, 24 Jul 2019 19:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998247;
        bh=i4aVbIWDcP5MUJJbB/xFWkj7MzCTZsjXQDrEtV5fXfI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VE0E9auL20w72wBWUkdjbfmgMTYaVit2H7Qd51YS+XsDesoDDtIK42U6yf1WkYUk/
         jgU25vAXIRueDnCjS1yeCPV40TTNwE1JTZbAFWlmMmwsJ+Cr2CcH6WoE1snP9M4drN
         vJ63CvGTJuLZWlYnUyvI+xXRPiOEKYxqEnlezDHg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yong Li <mr.liyong@qq.com>,
        Coly Li <colyli@suse.de>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.1 256/371] Revert "bcache: set CACHE_SET_IO_DISABLE in bch_cached_dev_error()"
Date:   Wed, 24 Jul 2019 21:20:08 +0200
Message-Id: <20190724191743.836522352@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Coly Li <colyli@suse.de>

commit 695277f16b3a102fcc22c97fdf2de77c7b19f0b3 upstream.

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
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/bcache/super.c |   17 -----------------
 1 file changed, 17 deletions(-)

--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1429,8 +1429,6 @@ int bch_flash_dev_create(struct cache_se
 
 bool bch_cached_dev_error(struct cached_dev *dc)
 {
-	struct cache_set *c;
-
 	if (!dc || test_bit(BCACHE_DEV_CLOSING, &dc->disk.flags))
 		return false;
 
@@ -1441,21 +1439,6 @@ bool bch_cached_dev_error(struct cached_
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


