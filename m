Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60DA154147B
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358758AbiFGUST (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376561AbiFGUQy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:16:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EB45172C14;
        Tue,  7 Jun 2022 11:29:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66D21B8237C;
        Tue,  7 Jun 2022 18:29:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D28FFC385A5;
        Tue,  7 Jun 2022 18:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626565;
        bh=3xOZY2rZbOX3Q/5YOONZrsu9wJxQTj1y2E9gwJ19t04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OapB7OXBQu3rmJaaWomxLq/VJA0gNYWEEqMVGP+9QNSlq64LF5KKupyX5aBvQ5UQu
         /KE852lcqYt7r9Qqsp0TJ2jT00vWEFXIQ6/XFMzPRDe8mv2t1XdXiFOJgrdWRHqA84
         FN2YTaCpM8H/C1k6mf5K6Ts6oAbohJk9HVuirSaY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 422/772] bfq: Relax waker detection for shared queues
Date:   Tue,  7 Jun 2022 19:00:14 +0200
Message-Id: <20220607165001.439896878@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

[ Upstream commit f950667356ce90a41b446b726d4595a10cb65415 ]

Currently we look for waker only if current queue has no requests. This
makes sense for bfq queues with a single process however for shared
queues when there is a larger number of processes the condition that
queue has no requests is difficult to meet because often at least one
process has some request in flight although all the others are waiting
for the waker to do the work and this harms throughput. Relax the "no
queued request for bfq queue" condition to "the current task has no
queued requests yet". For this, we also need to start tracking number of
requests in flight for each task.

This patch (together with the following one) restores the performance
for dbench with 128 clients that regressed with commit c65e6fd460b4
("bfq: Do not let waker requests skip proper accounting") because
this commit makes requests of wakers properly enter BFQ queues and thus
these queues become ineligible for the old waker detection logic.
Dbench results:

         Vanilla 5.18-rc3        5.18-rc3 + revert      5.18-rc3 patched
Mean     1237.36 (   0.00%)      950.16 *  23.21%*      988.35 *  20.12%*

Numbers are time to complete workload so lower is better.

Fixes: c65e6fd460b4 ("bfq: Do not let waker requests skip proper accounting")
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220519105235.31397-1-jack@suse.cz
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bfq-iosched.c | 5 +++--
 block/bfq-iosched.h | 1 +
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 963f9f549232..047368c23984 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -2133,7 +2133,6 @@ static void bfq_check_waker(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 	if (!bfqd->last_completed_rq_bfqq ||
 	    bfqd->last_completed_rq_bfqq == bfqq ||
 	    bfq_bfqq_has_short_ttime(bfqq) ||
-	    bfqq->dispatched > 0 ||
 	    now_ns - bfqd->last_completion >= 4 * NSEC_PER_MSEC ||
 	    bfqd->last_completed_rq_bfqq == bfqq->waker_bfqq)
 		return;
@@ -2210,7 +2209,7 @@ static void bfq_add_request(struct request *rq)
 	bfqq->queued[rq_is_sync(rq)]++;
 	bfqd->queued++;
 
-	if (RB_EMPTY_ROOT(&bfqq->sort_list) && bfq_bfqq_sync(bfqq)) {
+	if (bfq_bfqq_sync(bfqq) && RQ_BIC(rq)->requests <= 1) {
 		bfq_check_waker(bfqd, bfqq, now_ns);
 
 		/*
@@ -6563,6 +6562,7 @@ static void bfq_finish_requeue_request(struct request *rq)
 		bfq_completed_request(bfqq, bfqd);
 	}
 	bfq_finish_requeue_request_body(bfqq);
+	RQ_BIC(rq)->requests--;
 	spin_unlock_irqrestore(&bfqd->lock, flags);
 
 	/*
@@ -6796,6 +6796,7 @@ static struct bfq_queue *bfq_init_rq(struct request *rq)
 
 	bfqq_request_allocated(bfqq);
 	bfqq->ref++;
+	bic->requests++;
 	bfq_log_bfqq(bfqd, bfqq, "get_request %p: bfqq %p, %d",
 		     rq, bfqq, bfqq->ref);
 
diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
index 07288b9da389..a1ec70af64c8 100644
--- a/block/bfq-iosched.h
+++ b/block/bfq-iosched.h
@@ -469,6 +469,7 @@ struct bfq_io_cq {
 	struct bfq_queue *stable_merge_bfqq;
 
 	bool stably_merged;	/* non splittable if true */
+	unsigned int requests;	/* Number of requests this process has in flight */
 };
 
 /**
-- 
2.35.1



