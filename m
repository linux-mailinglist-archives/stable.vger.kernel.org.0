Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 565AF9E0A9
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732000AbfH0IEO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:04:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:33554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730431AbfH0IEN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:04:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63F78206BA;
        Tue, 27 Aug 2019 08:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566893052;
        bh=CeETEi2Wr7r5E+0ckBNN9DI8p3w6xM9/Ulo1YSbBOMA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l1s3HC2oIRV/h74rMSL+fLFRcIf6owrajlkWQh6DJ+riLkfiVFtGutYzhK9xeuRBA
         cFoawWtJVLSkj7+URIP9Oj9+duuJ4nZ8TsjUlCeU11LkyVtIOFFmVTgHS603iOHpRE
         f9EcAI/Ibkb42ktCpUjKK8Je1PHN7DVutN/FIrSM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hsin-Yi Wang <hsinyi@google.com>,
        Nicolas Boichat <drinkcat@chromium.org>,
        Doug Anderson <dianders@chromium.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 102/162] block, bfq: handle NULL return value by bfq_init_rq()
Date:   Tue, 27 Aug 2019 09:50:30 +0200
Message-Id: <20190827072741.819216658@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 404e776aa36d0..b528710364e9e 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -2085,9 +2085,14 @@ static void bfq_request_merged(struct request_queue *q, struct request *req,
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
@@ -2134,6 +2139,9 @@ static void bfq_requests_merged(struct request_queue *q, struct request *rq,
 	struct bfq_queue *bfqq = bfq_init_rq(rq),
 		*next_bfqq = bfq_init_rq(next);
 
+	if (!bfqq)
+		return;
+
 	/*
 	 * If next and rq belong to the same bfq_queue and next is older
 	 * than rq, then reposition rq in the fifo (by substituting next
@@ -5061,12 +5069,12 @@ static void bfq_insert_request(struct blk_mq_hw_ctx *hctx, struct request *rq,
 
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



