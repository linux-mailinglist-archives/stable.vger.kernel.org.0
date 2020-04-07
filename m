Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E29961A123B
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 18:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbgDGQ4D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 12:56:03 -0400
Received: from mail-wr1-f74.google.com ([209.85.221.74]:36506 "EHLO
        mail-wr1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726403AbgDGQ4D (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 12:56:03 -0400
Received: by mail-wr1-f74.google.com with SMTP id t13so2307234wru.3
        for <stable@vger.kernel.org>; Tue, 07 Apr 2020 09:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=fLkRnz42MMFsz9P3PZmrHqquQYGRjgFXJjHB/aWD2dc=;
        b=pgEUkI6vLpR0Mz8gREbcnmKxSJrI57xSn2HIIYHs2DUubSnjERIaCbpMex+BkEuh/M
         EjV7cSzAY4jB7jWJIhYNIH+ujmGXtUkkCqWkMCPUcd8D8Tj8SfKa/pQ6nKRJyfRWq/HF
         ycHi0uUYkhWV2WNwwPWme2XT/qCxqL0NMatKvDP6XCC33U/5YbI8Y5O8jI1C2GRaX4ha
         G5q9zWMNqWh4+vA/P9ZhmhpipkV+9AOEVNLlImiXTvPoEuZtyzBtqX795A3FMzjMe3ua
         NiDmtsm0hNDkoxiCPF/0Ne+Ez2P/FQN3TM4IC4GhWxKaVhs6LxfgszFM5zSPSr3X7iCW
         fhpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=fLkRnz42MMFsz9P3PZmrHqquQYGRjgFXJjHB/aWD2dc=;
        b=jRC/5x+bKTjP5dan59WhyBvd89hQHpHrUEwZcE78N7QdUwtothmULwn9sOTBIaEToh
         U/lAri13ZP3dCvaSio0lwW8ZRP+CzrfdrHGtNmuHUrJ6ra+bFt8PJ35L9FfmUDo/SBHV
         sz979QLTqLt8hdfS6lh7wxW4MbY2GPoUNLFSwvrN3Ba3VDs3IKXiRyYUG3YgvHCl8/0M
         bayR9qCSGmhUd5B/f3sJYr9KD34FPWSeQ4obSo5D9wGKPTPl2JR6QQ3XBgg/80HrK8Sg
         ZTklymWykd2w9ydmWDyzYsklEKXRQLBPCm1VKsCU1CO6UzY8x+fBPIkxznRnbuokGlkT
         FNgA==
X-Gm-Message-State: AGi0PubdVlxk32sMx4Ob56L7m1AcaivJe27uq9nyXEI8pKkLtjh6UAId
        UcNhpjgH5kx8zXVsRI5T1oS3jNQktRocew==
X-Google-Smtp-Source: APiQypJ9PsExIsbGzyc8eVF2baUGl3IRqGQ8K2XGFKJ9mS9dmLD7tDZiUPLe6ConthLIwLbu49wdGcWskHAzRw==
X-Received: by 2002:adf:f74d:: with SMTP id z13mr3933066wrp.55.1586278561068;
 Tue, 07 Apr 2020 09:56:01 -0700 (PDT)
Date:   Tue,  7 Apr 2020 17:55:38 +0100
In-Reply-To: <CAGvU0Hn2U88Dy2MEP-ZTNvfrWaKF4XL9EtR+4iF5BZ6_GW3Tvg@mail.gmail.com>
Message-Id: <20200407165539.161505-4-gprocida@google.com>
Mime-Version: 1.0
References: <CAGvU0Hn2U88Dy2MEP-ZTNvfrWaKF4XL9EtR+4iF5BZ6_GW3Tvg@mail.gmail.com>
X-Mailer: git-send-email 2.26.0.292.g33ef6b2f38-goog
Subject: [PATCH 3/4] blk-mq: sync things with blk_mq_queue_tag_busy_iter
From:   Giuliano Procida <gprocida@google.com>
To:     greg@kroah.com
Cc:     stable@vger.kernel.org, Giuliano Procida <gprocida@google.com>,
        Jianchao Wang <jianchao.w.wang@oracle.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit f5bbbbe4d63577026f908a809f22f5fd5a90ea1f upstream.

The original commit was intended to prevent concurrent manipulation of
nr_hw_queues and iteration over queues. The former doesn't happen in
this older kernel version. However, the extra locking (which is buggy
as it exists in this commit) may protect against other concurrent
accesses such as queue removal.

The original commit message follows for completeness.

blk-mq: sync the update nr_hw_queues with blk_mq_queue_tag_busy_iter

For blk-mq, part_in_flight/rw will invoke blk_mq_in_flight/rw to
account the inflight requests. It will access the queue_hw_ctx and
nr_hw_queues w/o any protection. When updating nr_hw_queues and
blk_mq_in_flight/rw occur concurrently, panic comes up.

Before update nr_hw_queues, the q will be frozen. So we could use
q_usage_counter to avoid the race. percpu_ref_is_zero is used here
so that we will not miss any in-flight request. The access to
nr_hw_queues and queue_hw_ctx in blk_mq_queue_tag_busy_iter are
under rcu critical section, __blk_mq_update_nr_hw_queues could use
synchronize_rcu to ensure the zeroed q_usage_counter to be globally
visible.

Signed-off-by: Jianchao Wang <jianchao.w.wang@oracle.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Giuliano Procida <gprocida@google.com>
---
 block/blk-mq-tag.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index a07ca3488d96..bf356de30134 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -481,6 +481,14 @@ void blk_mq_queue_tag_busy_iter(struct request_queue *q, busy_iter_fn *fn,
 	struct blk_mq_hw_ctx *hctx;
 	int i;
 
+	/*
+	 * Avoid potential races with things like queue removal.
+	 */
+	rcu_read_lock();
+	if (percpu_ref_is_zero(&q->q_usage_counter)) {
+		rcu_read_unlock();
+		return;
+	}
 
 	queue_for_each_hw_ctx(q, hctx, i) {
 		struct blk_mq_tags *tags = hctx->tags;
@@ -497,7 +505,7 @@ void blk_mq_queue_tag_busy_iter(struct request_queue *q, busy_iter_fn *fn,
 		bt_for_each(hctx, &tags->bitmap_tags, tags->nr_reserved_tags, fn, priv,
 		      false);
 	}
-
+	rcu_read_unlock();
 }
 
 static unsigned int bt_unused_tags(struct blk_mq_bitmap_tags *bt)
-- 
2.26.0.292.g33ef6b2f38-goog

