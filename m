Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C46E41AA2E6
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 15:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505698AbgDONAi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 09:00:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2505701AbgDONAd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 09:00:33 -0400
Received: from mail-wr1-x449.google.com (mail-wr1-x449.google.com [IPv6:2a00:1450:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53FA7C061A0C
        for <stable@vger.kernel.org>; Wed, 15 Apr 2020 06:00:32 -0700 (PDT)
Received: by mail-wr1-x449.google.com with SMTP id j12so10480607wrr.18
        for <stable@vger.kernel.org>; Wed, 15 Apr 2020 06:00:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=URY6F6KK4EGLE/QgotrdIRgqRzHc/ZizxkpUMmHHyuQ=;
        b=ORilxXJOTRMf1QHPuEWNbTAU3PTvxpeYTb7QMdnlS3Kj/bTspaCVBnYIJ8snco8Gcx
         Mo3NNYxuEAJQ2Ecg8ck6ltZj76F9J1rI0i3KAgfawh/4no6p4WCmvAtYVhFCun0OIew1
         95K+Bs+W7x0l/3jb1F3Utee2z4/FiIwL6fxByGGgsRPfTTZONz7D4B4+BDehyu8d257W
         ofGuGxrItyYZvLO30FPjHQUIM9MeDon/++v/KMV0A44y2LGddh5/z67AQPFquH4qRD+L
         /btUI+n8s+fEb6/SkAUjUfxkWXBHmRiynUruNtjzka8vUBHZB9dy6UMPckJBi76SzAIO
         7xFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=URY6F6KK4EGLE/QgotrdIRgqRzHc/ZizxkpUMmHHyuQ=;
        b=Gz//Bt6J5AO/Vmz6DDSD0nXhYVlkWCY8gzKwbBOZ3H0uAP5o8by6Y91ki0ynPzGkOg
         thv3wiRMHHt6JbuJ6bENXdv0NlEDFDOPybNKZSS8qx3yHVA/Ut4NWOHQNpjy+BX8f6rx
         GxB1IpPgw/n5trzUmDzkSfcIOGYjO2H0MpoS8dZ0Hd/oJfT4fA2z7XmJn4tIHpRfv8iC
         kznmUMfCK2Ha9Hc7CtjXlLLT3ubRf9WLxBt3Zd69I296zwT6laWPGwj+IU7zAJDFX6Mu
         SgVEX1CPOeRiYnzKMGf7ga8d0IdDgRVIHm5UnjZ0Pm8lzFJxU5ywCnHxdf6wtsFxO7Gd
         r7mQ==
X-Gm-Message-State: AGi0PuaVM1pz8l87ppnDwqpLQv6IRysk6kgSd0BoAhsPKr3+1XmGUNkc
        Cux/tqhWIrLOcn+DtJKLRL+gihwvYFcoSA==
X-Google-Smtp-Source: APiQypK21OTA0HkDlRkYSIjkr8HT1D+32hK9oA1bI9GaizSkHalRm44EHaAz2MivXqyHyjkeJNdHHirILhfETw==
X-Received: by 2002:a5d:544f:: with SMTP id w15mr30994744wrv.77.1586955630910;
 Wed, 15 Apr 2020 06:00:30 -0700 (PDT)
Date:   Wed, 15 Apr 2020 14:00:16 +0100
In-Reply-To: <CAGvU0Hn2U88Dy2MEP-ZTNvfrWaKF4XL9EtR+4iF5BZ6_GW3Tvg@mail.gmail.com>
Message-Id: <20200415130017.244979-4-gprocida@google.com>
Mime-Version: 1.0
References: <CAGvU0Hn2U88Dy2MEP-ZTNvfrWaKF4XL9EtR+4iF5BZ6_GW3Tvg@mail.gmail.com>
X-Mailer: git-send-email 2.26.0.110.g2183baf09c-goog
Subject: [PATCH v2 3/4] blk-mq: sync the update nr_hw_queues with blk_mq_queue_tag_busy_iter
From:   Giuliano Procida <gprocida@google.com>
To:     greg@kroah.com
Cc:     Giuliano Procida <gprocida@google.com>, stable@vger.kernel.org,
        Jianchao Wang <jianchao.w.wang@oracle.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit f5bbbbe4d63577026f908a809f22f5fd5a90ea1f upstream.

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

NOTE: Back-ported to 4.4.y.

The upstream commit was intended to prevent concurrent manipulation of
nr_hw_queues and iteration over queues. The former doesn't happen in
this in 4.4.7 (as __blk_mq_update_nr_hw_queues doesn't exist). The
extra locking is also buggy in this commit but fixed in a follow-up.

It may protect against other concurrent accesses such as queue removal
by synchronising RCU locking around q_usage_counter.

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
2.26.0.110.g2183baf09c-goog

