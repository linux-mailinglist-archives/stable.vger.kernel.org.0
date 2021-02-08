Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAC0B313655
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:10:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbhBHPJW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:09:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233051AbhBHPGk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 10:06:40 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE0B8C061793
        for <stable@vger.kernel.org>; Mon,  8 Feb 2021 07:04:31 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id s26so12715731edt.10
        for <stable@vger.kernel.org>; Mon, 08 Feb 2021 07:04:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZUngNzKrNvH0ej3h0vECgxJ0aSlmB5p4rWMKzMxwWgM=;
        b=Q7rAdYh4ff339PdEOnCEsp4zlVZ4SuAyfxcm7pSn5+SfZY1Xy4uZd6++rbDpyYIN3/
         1Vyj+R98jHNZoGGAMbQu8vd+9LowLpNHXhFBeHDXZRbTmQYFETlWhNu472ugkpshqPAL
         DFJPpFMiDmhkJd1ptcZUMuF7dZda3iv13tsQPaY+kbkh1SlTmW2LIvkNKMFSlHMoPuet
         wDMw8M/9Kq0aeL0xp+7v4ULb6wEtmRwV3LAI+GAU2dTNdtEWjduqVVoC5cYHjJVR4k9c
         I97GUjcIwbKrSw7GWEdg0VJMZzd7taCXhc0c3TGWAbRBUSexTj4duJ96IWSqLgClmbWX
         sIsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZUngNzKrNvH0ej3h0vECgxJ0aSlmB5p4rWMKzMxwWgM=;
        b=j7u9i4X1NROR1SiZaWTKRBcabEYdMS4jQxeE++j6vEVdOHpjIkRMofSGSE//MAipPM
         qzYrp0HyHx5M6pbahRrDbIR0dBqnp/Yk1sYkihnXYT/NrkOzZVYzPA3Yss0Yywoc9hV1
         Rky/58bnkOWrGxwEFU1dNgMST4mqPAJHsDY5qjMdQ9zb+brEjDvVsNVa8lI5r5q7hCi9
         42pdSx1OudOryYdOOp/qvIKyl5yv1V/0eYJ+uZhkq5bCq1RqhoOA+lO+6FpPMCDuneaw
         V32h10pPJKvWtmtvpGsZ8O73EQBbMURe3IEkweKcvpKibVJhaEkGKdFar80gp8xAsU7D
         rD6g==
X-Gm-Message-State: AOAM530eEx6LkV1oaMGBsHP2jQXz2WPHfAZi7Jr63C7/D77q1k1LqV1l
        OiuPJMVThnNRlh06isFhMPaseA==
X-Google-Smtp-Source: ABdhPJwxpseea9cgYrxDaWyUi+hatIWUUez4QRXKIKsaBvlrjfHG61CnJYxrzAlB/kdt9hbb6mH3yA==
X-Received: by 2002:aa7:d8c9:: with SMTP id k9mr17798759eds.366.1612796670608;
        Mon, 08 Feb 2021 07:04:30 -0800 (PST)
Received: from jwang-Latitude-5491.fkb.profitbricks.net ([2001:16b8:4980:d900:bc0f:acd:c20a:c261])
        by smtp.gmail.com with ESMTPSA id kb25sm4359106ejc.19.2021.02.08.07.04.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 07:04:30 -0800 (PST)
From:   Jack Wang <jinpu.wang@cloud.ionos.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org, axboe@kernel.dk,
        stable@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [stable-4.19 Resend 3/7] blk-mq: don't hold q->sysfs_lock in blk_mq_map_swqueue
Date:   Mon,  8 Feb 2021 16:04:22 +0100
Message-Id: <20210208150426.62755-4-jinpu.wang@cloud.ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210208150426.62755-1-jinpu.wang@cloud.ionos.com>
References: <20210208150426.62755-1-jinpu.wang@cloud.ionos.com>
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

