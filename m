Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B297830DAFD
	for <lists+stable@lfdr.de>; Wed,  3 Feb 2021 14:22:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231629AbhBCNVT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Feb 2021 08:21:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231551AbhBCNVO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Feb 2021 08:21:14 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC554C061788
        for <stable@vger.kernel.org>; Wed,  3 Feb 2021 05:20:28 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id p15so24192591wrq.8
        for <stable@vger.kernel.org>; Wed, 03 Feb 2021 05:20:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gw7klKD2RMcDufoZq/xD79IYKU/w+UW1t1ZRskK2cSw=;
        b=Xo3T/6OzcmD0Mn8NxHLMT1cZZKeZDgrb4AfPb8tvGfYHvD4k5ZYQgRqKRctBUNHrnN
         sHcuF56MfnhOLXOJZJNTTPkTlXrD/Jo1/1fqFJ7/23f0OMOP+omKLmI+zEpbznQ8cPjH
         MZgqh0MBwxqLukvyS5+HpOrP26E7y2fplD8/1yQqIplpJ+09ZXsG/iT/v6hZ0We8UowC
         JTDGRFjBF4tMvoKdgZk+k92Wdr5V4OlYXkvTdAzkSYfeyNtTH/eKrYYfBH92LWwWGLsz
         5OX4NL1msrXtTjEZ38Y6mx1qQzwSvXygL+joHmUTTVE9fAipqFGK3WKoegxuWJfcwS/c
         BmMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gw7klKD2RMcDufoZq/xD79IYKU/w+UW1t1ZRskK2cSw=;
        b=rOjJggQLSBSuarV8lESijjwR400G69rwG0GMTQFO9CAqPVnNke71dARjzaFVragM/s
         XbNsdW95swtWWiaMqQeSpu/3Ccb0j4G8QP3foaAiVJoOrm6ooQY0qT/3apWRRw77b4DB
         dDUAjWRy3bTclykSPbRm5gKvAg+3BTLr2iXg0CQ3tEhfy8wFfV4BU6OaFDOcI5D9eM5+
         g2AqkctsAPMTa7J4BZ+g+DuyvrOWXLhr6pNaezLKW+aR4hoXiNu3iE8GW/29HWswBf80
         xoTpcf2s7PjlCSl15ErRD2X7vrsjGjbbP7bzbA14T92kVMWdsTDsk6UG9SvPJpUoBkUY
         DYGA==
X-Gm-Message-State: AOAM532WF5HHfrFdshcu3n8AdutBbzntGQjuSmG9s0NoxZxJ6ZlYJ4pU
        lZIFMrqNqDzlwXmRsPQhJpEX6g==
X-Google-Smtp-Source: ABdhPJxuC+OxHUcITZry6CqRC0oVUyuilBYyozCM9c6bPp70yMMFDqQM9Muz+KO5/1Oi9ZUtOqkoCA==
X-Received: by 2002:adf:e3c2:: with SMTP id k2mr3488677wrm.337.1612358427445;
        Wed, 03 Feb 2021 05:20:27 -0800 (PST)
Received: from jwang-Latitude-5491.fritz.box ([2001:16b8:4947:3c00:7cf4:7472:391:9d0d])
        by smtp.gmail.com with ESMTPSA id d10sm3738430wrn.88.2021.02.03.05.20.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 05:20:27 -0800 (PST)
From:   Jack Wang <jinpu.wang@cloud.ionos.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org,
        stable@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: [stable-4.19 4/8] block: add helper for checking if queue is registered
Date:   Wed,  3 Feb 2021 14:20:18 +0100
Message-Id: <20210203132022.92406-5-jinpu.wang@cloud.ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210203132022.92406-1-jinpu.wang@cloud.ionos.com>
References: <20210203132022.92406-1-jinpu.wang@cloud.ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

There are 4 users which check if queue is registered, so add one helper
to check it.

Cc: Christoph Hellwig <hch@infradead.org>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
(cherry picked from commit 58c898ba370e68d39470cd0d932b524682c1f9be)
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
---
 block/blk-sysfs.c      | 4 ++--
 block/blk-wbt.c        | 2 +-
 block/elevator.c       | 2 +-
 include/linux/blkdev.h | 1 +
 4 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 8286640d4d66..0a7636d24563 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -896,7 +896,7 @@ int blk_register_queue(struct gendisk *disk)
 	if (WARN_ON(!q))
 		return -ENXIO;
 
-	WARN_ONCE(test_bit(QUEUE_FLAG_REGISTERED, &q->queue_flags),
+	WARN_ONCE(blk_queue_registered(q),
 		  "%s is registering an already registered queue\n",
 		  kobject_name(&dev->kobj));
 	queue_flag_set_unlocked(QUEUE_FLAG_REGISTERED, q);
@@ -973,7 +973,7 @@ void blk_unregister_queue(struct gendisk *disk)
 		return;
 
 	/* Return early if disk->queue was never registered. */
-	if (!test_bit(QUEUE_FLAG_REGISTERED, &q->queue_flags))
+	if (!blk_queue_registered(q))
 		return;
 
 	/*
diff --git a/block/blk-wbt.c b/block/blk-wbt.c
index f1de8ba483a9..50f2abfa1a60 100644
--- a/block/blk-wbt.c
+++ b/block/blk-wbt.c
@@ -708,7 +708,7 @@ void wbt_enable_default(struct request_queue *q)
 		return;
 
 	/* Queue not registered? Maybe shutting down... */
-	if (!test_bit(QUEUE_FLAG_REGISTERED, &q->queue_flags))
+	if (!blk_queue_registered(q))
 		return;
 
 	if ((q->mq_ops && IS_ENABLED(CONFIG_BLK_WBT_MQ)) ||
diff --git a/block/elevator.c b/block/elevator.c
index ddbcd36616a8..9bffe4558929 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -1083,7 +1083,7 @@ static int __elevator_change(struct request_queue *q, const char *name)
 	struct elevator_type *e;
 
 	/* Make sure queue is not in the middle of being removed */
-	if (!test_bit(QUEUE_FLAG_REGISTERED, &q->queue_flags))
+	if (!blk_queue_registered(q))
 		return -ENOENT;
 
 	/*
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 745b2d0dcf78..3a2b34c2c82b 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -743,6 +743,7 @@ bool blk_queue_flag_test_and_clear(unsigned int flag, struct request_queue *q);
 #define blk_queue_quiesced(q)	test_bit(QUEUE_FLAG_QUIESCED, &(q)->queue_flags)
 #define blk_queue_pm_only(q)	atomic_read(&(q)->pm_only)
 #define blk_queue_fua(q)	test_bit(QUEUE_FLAG_FUA, &(q)->queue_flags)
+#define blk_queue_registered(q)	test_bit(QUEUE_FLAG_REGISTERED, &(q)->queue_flags)
 
 extern void blk_set_pm_only(struct request_queue *q);
 extern void blk_clear_pm_only(struct request_queue *q);
-- 
2.25.1

