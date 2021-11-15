Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D65D5450DA0
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:57:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236659AbhKOSAn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:00:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:39822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239389AbhKOR6b (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:58:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF2F76327F;
        Mon, 15 Nov 2021 17:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997723;
        bh=DZbOmKrBp4IilsyeptlOM6kdJfp+p0GFJdKYThr44K8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oVdmuPXpC4VNuxgktkxsoSiuep8Ui1QN1hmewqNRCeCppvxn4JgZ4kpe251hVIxoJ
         3zMT47Z3O3JxA1D3XeVKKP0YO34Cq2yw2nR2FKpjA4aM6SxpA5MmgjBmq3PR8GU4ZS
         Ic/CQhwb2p0vpXI1KX/y5D3NV1T4gozOdW4157m4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 219/575] block: bump max plugged deferred size from 16 to 32
Date:   Mon, 15 Nov 2021 17:59:04 +0100
Message-Id: <20211115165351.286653305@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
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
index 69cc552c3dfc9..e4422a09b1265 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2116,14 +2116,14 @@ static void blk_add_rq_to_plug(struct blk_plug *plug, struct request *rq)
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
index f84c83300f6fa..997941cd999f6 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -188,6 +188,12 @@ bool blk_bio_list_merge(struct request_queue *q, struct list_head *list,
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
index 8aae375864b6b..4ba17736b614f 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1248,8 +1248,6 @@ struct blk_plug {
 	bool multiple_queues;
 	bool nowait;
 };
-#define BLK_MAX_REQUEST_COUNT 16
-#define BLK_PLUG_FLUSH_SIZE (128 * 1024)
 
 struct blk_plug_cb;
 typedef void (*blk_plug_cb_fn)(struct blk_plug_cb *, bool);
-- 
2.33.0



