Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92DDF45101C
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:38:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242578AbhKOSll (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:41:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:46352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242632AbhKOSjK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:39:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34772632ED;
        Mon, 15 Nov 2021 18:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999446;
        bh=YyT7r9fXaurAhv+M7sUwBSm6FhPaYMV2NyYut70xZaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wus0mIl6HjmZ2vPqPNfganrX/r9tW5/ftUJTjRYhV9hkWw/jEf6Cti8ZdpEDBNRZY
         HwByFpvgYWxYEnT+iWl5vI5tNxGD7UwOBRqd7MLm0VSfvxPpc9hw6hWkHRjF1FlYwK
         88INyL7JN3WgK6Lz7WiINWzxQeEhC2+mvECxpK08=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 282/849] block: bump max plugged deferred size from 16 to 32
Date:   Mon, 15 Nov 2021 17:56:05 +0100
Message-Id: <20211115165429.817023857@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit ba0ffdd8ce48ad7f7e85191cd29f9674caca3745 ]

Particularly for NVMe with efficient deferred submission for many
requests, there are nice benefits to be seen by bumping the default max
plug count from 16 to 32. This is especially true for virtualized setups,
where the submit part is more expensive. But can be noticed even on
native hardware.

Reduce the multiple queue factor from 4 to 2, since we're changing the
default size.

While changing it, move the defines into the block layer private header.
These aren't values that anyone outside of the block layer uses, or
should use.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c         | 4 ++--
 block/blk.h            | 6 ++++++
 include/linux/blkdev.h | 2 --
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index dc49483334c72..9c658883020fb 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2141,14 +2141,14 @@ static void blk_add_rq_to_plug(struct blk_plug *plug, struct request *rq)
 }
 
 /*
- * Allow 4x BLK_MAX_REQUEST_COUNT requests on plug queue for multiple
+ * Allow 2x BLK_MAX_REQUEST_COUNT requests on plug queue for multiple
  * queues. This is important for md arrays to benefit from merging
  * requests.
  */
 static inline unsigned short blk_plug_max_rq_count(struct blk_plug *plug)
 {
 	if (plug->multiple_queues)
-		return BLK_MAX_REQUEST_COUNT * 4;
+		return BLK_MAX_REQUEST_COUNT * 2;
 	return BLK_MAX_REQUEST_COUNT;
 }
 
diff --git a/block/blk.h b/block/blk.h
index f10cc9b2c27f7..1af7c13ccc708 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -181,6 +181,12 @@ bool blk_bio_list_merge(struct request_queue *q, struct list_head *list,
 void blk_account_io_start(struct request *req);
 void blk_account_io_done(struct request *req, u64 now);
 
+/*
+ * Plug flush limits
+ */
+#define BLK_MAX_REQUEST_COUNT	32
+#define BLK_PLUG_FLUSH_SIZE	(128 * 1024)
+
 /*
  * Internal elevator interface
  */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 4b0f8bb0671d1..e7979fe7e4fad 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1223,8 +1223,6 @@ struct blk_plug {
 	bool multiple_queues;
 	bool nowait;
 };
-#define BLK_MAX_REQUEST_COUNT 16
-#define BLK_PLUG_FLUSH_SIZE (128 * 1024)
 
 struct blk_plug_cb;
 typedef void (*blk_plug_cb_fn)(struct blk_plug_cb *, bool);
-- 
2.33.0



