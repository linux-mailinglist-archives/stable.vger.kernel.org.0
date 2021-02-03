Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C749D30DAFB
	for <lists+stable@lfdr.de>; Wed,  3 Feb 2021 14:22:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231543AbhBCNVJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Feb 2021 08:21:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231479AbhBCNVI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Feb 2021 08:21:08 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89864C061786
        for <stable@vger.kernel.org>; Wed,  3 Feb 2021 05:20:27 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id l12so24268232wry.2
        for <stable@vger.kernel.org>; Wed, 03 Feb 2021 05:20:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZUngNzKrNvH0ej3h0vECgxJ0aSlmB5p4rWMKzMxwWgM=;
        b=DHW8VtW+YB8CYLABpPzQqAjnPuGzoxuN0vng1Nyc1kp3NRi5ZS3PSHWkI5AF3QHCbj
         924IBiJJoNRrGA21/iO18HB0Nwtf8y1osNo4obrdJ24QaOsEOLwmQc/vcFjHAYJ/cs1S
         LDVyaIKC3qwtY7TprmcnIfe3zSLwI/mPu1VSjdBYqp9Cz5def0HttNEy7HBnLizZNBax
         YuSStfbv6ewb7KO4w/Em16OO31N8RP97i8o9sM76hoU6BmxV4gRV9Yg4aT9WvJSDZUhF
         +qtlFW2cvA41xRYiCwBHa/pdXBkwVhuaKXA3AQZyfhU5h5epDPjDd9afukcYumwBqBLS
         OOAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZUngNzKrNvH0ej3h0vECgxJ0aSlmB5p4rWMKzMxwWgM=;
        b=qckXkBXok3RdSpN6ACPp8A3bHQUEr+wTuLH9XOR1StiG5DcZ9oRZzOlPxI0hnv0xHc
         XLoKpepQ7V0Ha90AZ/VzDYhq4XAFXJca/PsZ69T8HMyMH9ECstM85gAYX8fIjYhScRs0
         E0mqWxPtY5aW5XLiOkjI3P/Cs8Gsug/tzC+Kw8jqHp7YVv26XxN5awkRPBMlfwXxPylJ
         sT/rC6b+fv+cndoMmHSs7MPrxJe2i9Rd9TRTeqE3s//W8St8cFDDUE21XoR1T87M/J/z
         dphYfvjGBKHsp54+2/QJ5u5wGI3u+QkFfNr5gA+cv+yXLdppompiF+6PhIVhjmskayEV
         K+XA==
X-Gm-Message-State: AOAM532+QdFAoLaPI0mPMzMfpd0ZHGoJrpS4ym+UMuhIqPpUBeSBz3UG
        HfqcGqT6y3fISR1jkP4a9AaZog==
X-Google-Smtp-Source: ABdhPJyI2oCM+pH2OzKhCAVDEHx2xqUF0IIt/Nx30XHfl7WY2U+Edy7239IrGOqCzEnmy29oNGb4fQ==
X-Received: by 2002:a5d:4a09:: with SMTP id m9mr3561871wrq.122.1612358426361;
        Wed, 03 Feb 2021 05:20:26 -0800 (PST)
Received: from jwang-Latitude-5491.fritz.box ([2001:16b8:4947:3c00:7cf4:7472:391:9d0d])
        by smtp.gmail.com with ESMTPSA id d10sm3738430wrn.88.2021.02.03.05.20.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 05:20:25 -0800 (PST)
From:   Jack Wang <jinpu.wang@cloud.ionos.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org,
        stable@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: [stable-4.19 3/8] blk-mq: don't hold q->sysfs_lock in blk_mq_map_swqueue
Date:   Wed,  3 Feb 2021 14:20:17 +0100
Message-Id: <20210203132022.92406-4-jinpu.wang@cloud.ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210203132022.92406-1-jinpu.wang@cloud.ionos.com>
References: <20210203132022.92406-1-jinpu.wang@cloud.ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

blk_mq_map_swqueue() is called from blk_mq_init_allocated_queue()
and blk_mq_update_nr_hw_queues(). For the former caller, the kobject
isn't exposed to userspace yet. For the latter caller, hctx sysfs entries
and debugfs are un-registered before updating nr_hw_queues.

On the other hand, commit 2f8f1336a48b ("blk-mq: always free hctx after
request queue is freed") moves freeing hctx into queue's release
handler, so there won't be race with queue release path too.

So don't hold q->sysfs_lock in blk_mq_map_swqueue().

Cc: Christoph Hellwig <hch@infradead.org>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
(cherry picked from commit c6ba933358f0d7a6a042b894dba20cc70396a6d3)
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
---
 block/blk-mq.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 0df43515ff94..195526b93895 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2324,11 +2324,6 @@ static void blk_mq_map_swqueue(struct request_queue *q)
 	struct blk_mq_ctx *ctx;
 	struct blk_mq_tag_set *set = q->tag_set;
 
-	/*
-	 * Avoid others reading imcomplete hctx->cpumask through sysfs
-	 */
-	mutex_lock(&q->sysfs_lock);
-
 	queue_for_each_hw_ctx(q, hctx, i) {
 		cpumask_clear(hctx->cpumask);
 		hctx->nr_ctx = 0;
@@ -2362,8 +2357,6 @@ static void blk_mq_map_swqueue(struct request_queue *q)
 		hctx->ctxs[hctx->nr_ctx++] = ctx;
 	}
 
-	mutex_unlock(&q->sysfs_lock);
-
 	queue_for_each_hw_ctx(q, hctx, i) {
 		/*
 		 * If no software queues are mapped to this hardware queue,
-- 
2.25.1

