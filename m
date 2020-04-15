Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD621AA2E7
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 15:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505701AbgDONAj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 09:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2505704AbgDONAf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 09:00:35 -0400
Received: from mail-wr1-x449.google.com (mail-wr1-x449.google.com [IPv6:2a00:1450:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A07DC061A0C
        for <stable@vger.kernel.org>; Wed, 15 Apr 2020 06:00:35 -0700 (PDT)
Received: by mail-wr1-x449.google.com with SMTP id q10so3990178wrv.10
        for <stable@vger.kernel.org>; Wed, 15 Apr 2020 06:00:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=2UV+AKDA4iEmqm7ZUjmQLtTc9rj0RmktA+MuCIQAXQs=;
        b=Kh9PxRKS3VUM33vtK19o53nAO6ex33O7LCJaEhBiAg9o9KPZIkZ9ajIGr+dl4iiBkY
         0JaVhxnVbtGWikryxmfbfnM7O2NASXKbmixSu7a6sNRozwlbWs12+mshAvCycnd8bXle
         hfVNEPPYA64rT0RuZww0GdpYspaWCGm7E07MicehKsTJU1QAxCHHzfImJKJHIEjJNGYa
         f+u5kiB0KbNTNnWKhB1HEgGypfPJ4L9l3EkG1oE6H9fZrfRWO5ARfLZS+FbX1TClF6FR
         5vbWaoyIm8exxKPlvRIvB+IQgMt1Lh0VhW95UDwYMJ2s5r72NeWQh8jO6ESwSejZnYNN
         gHpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=2UV+AKDA4iEmqm7ZUjmQLtTc9rj0RmktA+MuCIQAXQs=;
        b=UzKl1v9Ubb55p3hwG1dDtkDWUETxg8CME4OT3w7neDMLktUJaavufjufkROeShxmUE
         kJBiEAnZqUxiNDRbmVyHsd4ctUi/H1EFPH4SxjXssUUF4JkXbeWJRtmO2JuZCzTNyfov
         /GJ/RwN5TuARLTo/WnetA74KtNBkTk1uJIU1FoXQhZwBkTHJST0TsYTnOBhHs3cGaz2F
         7M04E8OPWaMARnEBgkbGnhTsBEvADfZq8NT76Fxje7HEmBFU1dySapOXXqbvwG1TpRjB
         wi4dQZtFgAIpILtURqtx9xJaOZ/QnQED5qx6zpbmSQzqWHUHW/d+nPY6J9KQrru44uSi
         BHTA==
X-Gm-Message-State: AGi0PuZ37oF1vb2Iu6bhUv7DvoBziZltzFBi+D7WPWly6P6PVaSKZFRl
        WAZIzI3OO+9LUe/kjuR1rRqOUrSuDXmwRA==
X-Google-Smtp-Source: APiQypL9uylGrQea/UxwB1BDWUUiyk0xf/DrSmA5OjRIN8UrN+0JmEn8GdhYHxzHW/zEZTZIcU2NaPyRs7YYFg==
X-Received: by 2002:adf:dd83:: with SMTP id x3mr21196481wrl.298.1586955634125;
 Wed, 15 Apr 2020 06:00:34 -0700 (PDT)
Date:   Wed, 15 Apr 2020 14:00:17 +0100
In-Reply-To: <CAGvU0Hn2U88Dy2MEP-ZTNvfrWaKF4XL9EtR+4iF5BZ6_GW3Tvg@mail.gmail.com>
Message-Id: <20200415130017.244979-5-gprocida@google.com>
Mime-Version: 1.0
References: <CAGvU0Hn2U88Dy2MEP-ZTNvfrWaKF4XL9EtR+4iF5BZ6_GW3Tvg@mail.gmail.com>
X-Mailer: git-send-email 2.26.0.110.g2183baf09c-goog
Subject: [PATCH v2 4/4] blk-mq: Allow blocking queue tag iter callbacks
From:   Giuliano Procida <gprocida@google.com>
To:     greg@kroah.com
Cc:     Giuliano Procida <gprocida@google.com>, stable@vger.kernel.org,
        Jianchao Wang <jianchao.w.wang@oracle.com>,
        Keith Busch <keith.busch@intel.com>,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 530ca2c9bd6949c72c9b5cfc330cb3dbccaa3f5b upstream.

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
2.26.0.110.g2183baf09c-goog

