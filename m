Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 083961A123C
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 18:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbgDGQ4H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 12:56:07 -0400
Received: from mail-wm1-f73.google.com ([209.85.128.73]:55375 "EHLO
        mail-wm1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726403AbgDGQ4H (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 12:56:07 -0400
Received: by mail-wm1-f73.google.com with SMTP id e16so1177736wmh.5
        for <stable@vger.kernel.org>; Tue, 07 Apr 2020 09:56:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ICm9U3yZy/Ev7sKd+9OKUZakrAzUhKVeWWqfMgFPpQM=;
        b=u/G+YiNz49YGzK/BWekqu7/L+5x8hBQe4fOW269mekCs0smq/nKvp+aMATTpJrwXzz
         JGUr+KOKCk0krNm9hrHabeX9xFYirsA3qmgmJzn9a/PKA2+s6RBdWtsVFnMmKBGI598L
         Q+fPl8PqQc1EwYjO2p91pmK9HFErg8KFUVzqzJsJuPnfIFvA+1lQ6rd57oCoijq05YjK
         YftHq0k7+GltRRPoQ3BWdaaFfBNnrI82ZlGm0i2GaFXQK/1mlLCb/uBeZdABl/fWC/Cs
         jkvUdQSjwHkQrquj6jMVJw2qVJ1tyd5PCo1OcRGNRM9eZpXq1jqhASQ9nu+a5xmUciIr
         qQmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ICm9U3yZy/Ev7sKd+9OKUZakrAzUhKVeWWqfMgFPpQM=;
        b=SMZZPrgqKbREonfAJsZ3CeKEyxgVjH2W5uxjulyuqcK7p45b+ToKDfpxSvTPbvergt
         DZ9cMVAAk+6fMARCJy6KmUcHL5X1aNZP8LF1V2hWz7RuqvR0tSjpqV5n3Cz6PpKVVAMN
         RMDZ2sxsqfgOfRs9hZmprowrSU04PGpodEpx5WPy0S6QchHyBtGjE0AtrxXxXxU73vrr
         xaCZE0ubgVeFQ9x6klTaC0tyQMEDP+sVXG+BBSVO6X45utsV48Tm58gTU+biUROf2i6z
         E6FPTR7L/qXkSpDSx6iQxZGKpuJi9DHM9SAX/5X+sFvT9zVxVlJEQQ4zNol/mxh23LBs
         V+Ow==
X-Gm-Message-State: AGi0Pub7CCkBedeGNVEUlbYUw3OHvlhqcHUPPhaPO45zXaVL7eWNsErT
        5KJz5X3NIXgijvoQLOEM5GMkF7mNb2nhlg==
X-Google-Smtp-Source: APiQypKonT8sho7Fm5zQdHqP0SBns9B7Ah7mj/M/pcKg3iVfFFO2RoYl+SsxwPmpegFIhyxVhG0l2WEz7v7hlw==
X-Received: by 2002:a5d:670f:: with SMTP id o15mr3669283wru.120.1586278564132;
 Tue, 07 Apr 2020 09:56:04 -0700 (PDT)
Date:   Tue,  7 Apr 2020 17:55:39 +0100
In-Reply-To: <CAGvU0Hn2U88Dy2MEP-ZTNvfrWaKF4XL9EtR+4iF5BZ6_GW3Tvg@mail.gmail.com>
Message-Id: <20200407165539.161505-5-gprocida@google.com>
Mime-Version: 1.0
References: <CAGvU0Hn2U88Dy2MEP-ZTNvfrWaKF4XL9EtR+4iF5BZ6_GW3Tvg@mail.gmail.com>
X-Mailer: git-send-email 2.26.0.292.g33ef6b2f38-goog
Subject: [PATCH 4/4] blk-mq: Allow blocking queue tag iter callbacks
From:   Giuliano Procida <gprocida@google.com>
To:     greg@kroah.com
Cc:     stable@vger.kernel.org, Giuliano Procida <gprocida@google.com>,
        Jianchao Wang <jianchao.w.wang@oracle.com>,
        Keith Busch <keith.busch@intel.com>,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 530ca2c9bd6949c72c9b5cfc330cb3dbccaa3f5b upstream.

This change is a back-ported fix to the back-port of f5bbbbe4d6357,
a439abbd6e707232b1f399e6df1a85ace42e8f9f.

A recent commit runs tag iterator callbacks under the rcu read lock,
but existing callbacks do not satisfy the non-blocking requirement.
The commit intended to prevent an iterator from accessing a queue that's
being modified. This patch fixes the original issue by taking a queue
reference instead of reading it, which allows callbacks to make blocking
calls.

Fixes: f5bbbbe4d6357 ("blk-mq: sync the update nr_hw_queues with blk_mq_queue_tag_busy_iter")
Acked-by: Jianchao Wang <jianchao.w.wang@oracle.com>
Signed-off-by: Keith Busch <keith.busch@intel.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Giuliano Procida <gprocida@google.com>
---
 block/blk-mq-tag.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index bf356de30134..c1c654319287 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -484,11 +484,8 @@ void blk_mq_queue_tag_busy_iter(struct request_queue *q, busy_iter_fn *fn,
 	/*
 	 * Avoid potential races with things like queue removal.
 	 */
-	rcu_read_lock();
-	if (percpu_ref_is_zero(&q->q_usage_counter)) {
-		rcu_read_unlock();
+	if (!percpu_ref_tryget(&q->q_usage_counter))
 		return;
-	}
 
 	queue_for_each_hw_ctx(q, hctx, i) {
 		struct blk_mq_tags *tags = hctx->tags;
@@ -505,7 +502,7 @@ void blk_mq_queue_tag_busy_iter(struct request_queue *q, busy_iter_fn *fn,
 		bt_for_each(hctx, &tags->bitmap_tags, tags->nr_reserved_tags, fn, priv,
 		      false);
 	}
-	rcu_read_unlock();
+	blk_queue_exit(q);
 }
 
 static unsigned int bt_unused_tags(struct blk_mq_bitmap_tags *bt)
-- 
2.26.0.292.g33ef6b2f38-goog

