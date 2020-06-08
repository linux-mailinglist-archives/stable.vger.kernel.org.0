Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F8351F15A0
	for <lists+stable@lfdr.de>; Mon,  8 Jun 2020 11:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729214AbgFHJki (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 05:40:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729184AbgFHJki (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jun 2020 05:40:38 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBCCFC08C5C3
        for <stable@vger.kernel.org>; Mon,  8 Jun 2020 02:40:37 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id a6so13840725qka.9
        for <stable@vger.kernel.org>; Mon, 08 Jun 2020 02:40:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=1p/V4XS0P/r27QM5FjNmtBpyXT2GSzFd1g5QJ5J4PYg=;
        b=nax2vCsIKAwm7Gl2tAp3GfPZGFCMxAzF6Sl/ZNzDE6rb/ARR0lgTDnuCI5xiNy2Erf
         O1fgKIXP6hbMnb7EBe9lL52NX9hOtbeYCTNGHIg85U1F49Gsg1aKvCarX2nT37UdAbgU
         eamGM17S4DxPOlQSe89/01zY4WaMUZkEtGJWfuHxk45JngPeZ21oGb1TSoilmQIiUXdA
         gc9b18Kd7J2r0IPpSZovrssmP04s3nyRpreKUaCqzYsdve+cW2BZlzdG8pVM2Z3hKR7d
         4oFCoCSzyWiMoeAPtpQ4bJn8173HAZv8JOcNgbfM0NUbEPw/BOhf3w1Y7gC8kVb3pJXH
         q78g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=1p/V4XS0P/r27QM5FjNmtBpyXT2GSzFd1g5QJ5J4PYg=;
        b=Yvz3Vb4Bqzey27TijewER5OlgaoM/+RAZD3WgbaQvszTI6qZJTJ+y0xUjxfOy0l1lv
         t+SzTMFWUT55uYGEp3hqp2akTnESlVZ70r95PHo/wJ3Ld/G3ADPe5oQQWHg1eivtkxd0
         MO0fiQrwmK/0GqGiRKWumiZcEa/8DZd0xk0GRJfmqXD//pyG1tnkj4FsPFwiPb2JWz2D
         cnqEf9oFVhuKNylaKnf96JGpZc/ZPaAClWm7+7eTfdwxwYOg0aO3A+33X4fjhQk3Dcu+
         lo4LlonKz+wUSPmVaawyll8h6VH8+HumlJV2APdo+9CIVLtSXQlO2DA3/uV5YAH8TA4l
         g8ow==
X-Gm-Message-State: AOAM530kYneH1AG/8QDzZvKBEs8cXbbiQRQi8uBO5SemYaugS4YS+9iW
        f5k811/cL1jy/DD5BfT4K+G5mWYY2/H5UA==
X-Google-Smtp-Source: ABdhPJxVh2xd+wxM5h9526ggDS1ufprwT1BFXefTibFhFZIkPJBjeirs8H27PXY6hCyR0yByjHxJ5h/ovQAsbw==
X-Received: by 2002:a0c:e885:: with SMTP id b5mr1349585qvo.38.1591609236956;
 Mon, 08 Jun 2020 02:40:36 -0700 (PDT)
Date:   Mon,  8 Jun 2020 10:40:30 +0100
Message-Id: <20200608094030.87031-1-gprocida@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.278.ge193c7cf3a9-goog
Subject: [PATCH] blk-mq: sync the update nr_hw_queues with blk_mq_queue_tag_busy_iter
From:   Giuliano Procida <gprocida@google.com>
To:     greg@kroah.com
Cc:     stable@vger.kernel.org, Jianchao Wang <jianchao.w.wang@oracle.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Giuliano Procida <gprocida@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jianchao Wang <jianchao.w.wang@oracle.com>

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

Backporting Notes

This is a re-backport, landing synchronize_rcu in the right place.

Signed-off-by: Jianchao Wang <jianchao.w.wang@oracle.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Giuliano Procida <gprocida@google.com>
---
 block/blk-mq.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 58be2eaa5aaa..e0ed7317e98c 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2331,6 +2331,10 @@ void blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set, int nr_hw_queues)
 
 	list_for_each_entry(q, &set->tag_list, tag_set_list)
 		blk_mq_freeze_queue(q);
+	/*
+	 * Sync with blk_mq_queue_tag_busy_iter.
+	 */
+	synchronize_rcu();
 
 	set->nr_hw_queues = nr_hw_queues;
 	list_for_each_entry(q, &set->tag_list, tag_set_list) {
@@ -2346,10 +2350,6 @@ void blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set, int nr_hw_queues)
 
 	list_for_each_entry(q, &set->tag_list, tag_set_list)
 		blk_mq_unfreeze_queue(q);
-	/*
-	 * Sync with blk_mq_queue_tag_busy_iter.
-	 */
-	synchronize_rcu();
 }
 EXPORT_SYMBOL_GPL(blk_mq_update_nr_hw_queues);
 
-- 
2.27.0.278.ge193c7cf3a9-goog

