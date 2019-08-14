Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60EFF8C75B
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 04:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729002AbfHNCXC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 22:23:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:48788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729412AbfHNCRa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 22:17:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6730F20843;
        Wed, 14 Aug 2019 02:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565749049;
        bh=NSafegQqM6bZHr8DIYO0zVk1Y9lQxdXuReFFnkivw10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H5O2f+EU+ncEOfmjWcQk4UtAgQgqlXIsiroFTpCiMsxXq4PeHJQLSug235Qa7Pn8m
         8MhjCLTOHGOB/6qvEY40V/AVRZ5T1DytWMw/KcvEoBhNhQMPC38X+X6Ms8l0nM2qPc
         gLGytBrw4BZWKK3GD8G9Om6qYqLqHIzLHESygjUc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paolo Valente <paolo.valente@linaro.org>,
        Hsin-Yi Wang <hsinyi@google.com>,
        Nicolas Boichat <drinkcat@chromium.org>,
        Doug Anderson <dianders@chromium.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 62/68] block, bfq: handle NULL return value by bfq_init_rq()
Date:   Tue, 13 Aug 2019 22:15:40 -0400
Message-Id: <20190814021548.16001-62-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021548.16001-1-sashal@kernel.org>
References: <20190814021548.16001-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Valente <paolo.valente@linaro.org>

[ Upstream commit fd03177c33b287c6541f4048f1d67b7b45a1abc9 ]

As reported in [1], the call bfq_init_rq(rq) may return NULL in case
of OOM (in particular, if rq->elv.icq is NULL because memory
allocation failed in failed in ioc_create_icq()).

This commit handles this circumstance.

[1] https://lkml.org/lkml/2019/7/22/824

Cc: Hsin-Yi Wang <hsinyi@google.com>
Cc: Nicolas Boichat <drinkcat@chromium.org>
Cc: Doug Anderson <dianders@chromium.org>
Reported-by: Guenter Roeck <linux@roeck-us.net>
Reported-by: Hsin-Yi Wang <hsinyi@google.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Paolo Valente <paolo.valente@linaro.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bfq-iosched.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index becd793a258c8..d8d2ac294b0c0 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -1886,9 +1886,14 @@ static void bfq_request_merged(struct request_queue *q, struct request *req,
 	    blk_rq_pos(container_of(rb_prev(&req->rb_node),
 				    struct request, rb_node))) {
 		struct bfq_queue *bfqq = bfq_init_rq(req);
-		struct bfq_data *bfqd = bfqq->bfqd;
+		struct bfq_data *bfqd;
 		struct request *prev, *next_rq;
 
+		if (!bfqq)
+			return;
+
+		bfqd = bfqq->bfqd;
+
 		/* Reposition request in its sort_list */
 		elv_rb_del(&bfqq->sort_list, req);
 		elv_rb_add(&bfqq->sort_list, req);
@@ -1930,6 +1935,9 @@ static void bfq_requests_merged(struct request_queue *q, struct request *rq,
 	struct bfq_queue *bfqq = bfq_init_rq(rq),
 		*next_bfqq = bfq_init_rq(next);
 
+	if (!bfqq)
+		return;
+
 	/*
 	 * If next and rq belong to the same bfq_queue and next is older
 	 * than rq, then reposition rq in the fifo (by substituting next
@@ -4590,12 +4598,12 @@ static void bfq_insert_request(struct blk_mq_hw_ctx *hctx, struct request *rq,
 
 	spin_lock_irq(&bfqd->lock);
 	bfqq = bfq_init_rq(rq);
-	if (at_head || blk_rq_is_passthrough(rq)) {
+	if (!bfqq || at_head || blk_rq_is_passthrough(rq)) {
 		if (at_head)
 			list_add(&rq->queuelist, &bfqd->dispatch);
 		else
 			list_add_tail(&rq->queuelist, &bfqd->dispatch);
-	} else { /* bfqq is assumed to be non null here */
+	} else {
 		idle_timer_disabled = __bfq_insert_request(bfqd, rq);
 		/*
 		 * Update bfqq, because, if a queue merge has occurred
-- 
2.20.1

