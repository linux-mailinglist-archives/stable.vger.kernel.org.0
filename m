Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34D1D45209D
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:53:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351863AbhKPAzw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:55:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:44632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245751AbhKOTVI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C878632EF;
        Mon, 15 Nov 2021 18:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001634;
        bh=GBNPxPVeLR32XxNszEFLDPWZp3XuXm0BjfRNbtSRdEg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mAmnD2Tvy8YuoLYtOi2BOnoJoKmxTmu54jIHXQ1fpqEKQlOzPRzw3DnDPG21FxMUc
         NOgfRC2bZRkcPEdwlTCV6rRUHsxq3lmeNCpE8j4ap2d9tkhPjDJ0ILdytG44pMcrHd
         uzgWt6OrEXy7XOG6SNeEJE45oc6u+T5qmXK0grTM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 263/917] block: bump max plugged deferred size from 16 to 32
Date:   Mon, 15 Nov 2021 17:55:58 +0100
Message-Id: <20211115165437.704594286@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
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
index 652a31fc3bb38..49587c181e3fd 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2148,14 +2148,14 @@ static void blk_add_rq_to_plug(struct blk_plug *plug, struct request *rq)
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
index 6c3c00a8fe19d..aab72194d2266 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -184,6 +184,12 @@ bool blk_bio_list_merge(struct request_queue *q, struct list_head *list,
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
index 12b9dbcc980ee..683aee3654200 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1198,8 +1198,6 @@ struct blk_plug {
 	bool multiple_queues;
 	bool nowait;
 };
-#define BLK_MAX_REQUEST_COUNT 16
-#define BLK_PLUG_FLUSH_SIZE (128 * 1024)
 
 struct blk_plug_cb;
 typedef void (*blk_plug_cb_fn)(struct blk_plug_cb *, bool);
-- 
2.33.0



