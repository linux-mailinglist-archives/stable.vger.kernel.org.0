Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BDDAF737
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727225AbfD3L45 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:56:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:34376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730271AbfD3LsU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:48:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 421FD2054F;
        Tue, 30 Apr 2019 11:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624899;
        bh=anrotz1C9fOH+b6UZBvHZyzMJdl96x+yIRuz/JNQ6TU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vPbam7QuxwFykPRYxG0+7QOjXvEFCzddESUmS44WaB4mTRvZ4jVdcn83YFzhv+spU
         N++aC7lIvW4yESW+j4aIl9B6sHChiZ1ax3zYNNaeDm/qJF9e+KSrSnuZ64ETx3Hvum
         4XN4Sc4GtJnuVLHNWFOeVyTddiYCYOxvr2QRKIvQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitrii Tcvetkov <demfloro@demfloro.ru>,
        Douglas Anderson <dianders@chromium.org>,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 07/89] block, bfq: fix use after free in bfq_bfqq_expire
Date:   Tue, 30 Apr 2019 13:37:58 +0200
Message-Id: <20190430113610.117110202@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113609.741196396@linuxfoundation.org>
References: <20190430113609.741196396@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit eed47d19d9362bdd958e4ab56af480b9dbf6b2b6 ]

The function bfq_bfqq_expire() invokes the function
__bfq_bfqq_expire(), and the latter may free the in-service bfq-queue.
If this happens, then no other instruction of bfq_bfqq_expire() must
be executed, or a use-after-free will occur.

Basing on the assumption that __bfq_bfqq_expire() invokes
bfq_put_queue() on the in-service bfq-queue exactly once, the queue is
assumed to be freed if its refcounter is equal to one right before
invoking __bfq_bfqq_expire().

But, since commit 9dee8b3b057e ("block, bfq: fix queue removal from
weights tree") this assumption is false. __bfq_bfqq_expire() may also
invoke bfq_weights_tree_remove() and, since commit 9dee8b3b057e
("block, bfq: fix queue removal from weights tree"), also
the latter function may invoke bfq_put_queue(). So __bfq_bfqq_expire()
may invoke bfq_put_queue() twice, and this is the actual case where
the in-service queue may happen to be freed.

To address this issue, this commit moves the check on the refcounter
of the queue right around the last bfq_put_queue() that may be invoked
on the queue.

Fixes: 9dee8b3b057e ("block, bfq: fix queue removal from weights tree")
Reported-by: Dmitrii Tcvetkov <demfloro@demfloro.ru>
Reported-by: Douglas Anderson <dianders@chromium.org>
Tested-by: Dmitrii Tcvetkov <demfloro@demfloro.ru>
Tested-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Paolo Valente <paolo.valente@linaro.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bfq-iosched.c | 15 +++++++--------
 block/bfq-iosched.h |  2 +-
 block/bfq-wf2q.c    | 17 +++++++++++++++--
 3 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index e5ed28629271..72510c470001 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -2804,7 +2804,7 @@ static void bfq_dispatch_remove(struct request_queue *q, struct request *rq)
 	bfq_remove_request(q, rq);
 }
 
-static void __bfq_bfqq_expire(struct bfq_data *bfqd, struct bfq_queue *bfqq)
+static bool __bfq_bfqq_expire(struct bfq_data *bfqd, struct bfq_queue *bfqq)
 {
 	/*
 	 * If this bfqq is shared between multiple processes, check
@@ -2837,9 +2837,11 @@ static void __bfq_bfqq_expire(struct bfq_data *bfqd, struct bfq_queue *bfqq)
 	/*
 	 * All in-service entities must have been properly deactivated
 	 * or requeued before executing the next function, which
-	 * resets all in-service entites as no more in service.
+	 * resets all in-service entities as no more in service. This
+	 * may cause bfqq to be freed. If this happens, the next
+	 * function returns true.
 	 */
-	__bfq_bfqd_reset_in_service(bfqd);
+	return __bfq_bfqd_reset_in_service(bfqd);
 }
 
 /**
@@ -3244,7 +3246,6 @@ void bfq_bfqq_expire(struct bfq_data *bfqd,
 	bool slow;
 	unsigned long delta = 0;
 	struct bfq_entity *entity = &bfqq->entity;
-	int ref;
 
 	/*
 	 * Check whether the process is slow (see bfq_bfqq_is_slow).
@@ -3313,10 +3314,8 @@ void bfq_bfqq_expire(struct bfq_data *bfqd,
 	 * reason.
 	 */
 	__bfq_bfqq_recalc_budget(bfqd, bfqq, reason);
-	ref = bfqq->ref;
-	__bfq_bfqq_expire(bfqd, bfqq);
-
-	if (ref == 1) /* bfqq is gone, no more actions on it */
+	if (__bfq_bfqq_expire(bfqd, bfqq))
+		/* bfqq is gone, no more actions on it */
 		return;
 
 	bfqq->injected_service = 0;
diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
index 746bd570b85a..ca98c98a8179 100644
--- a/block/bfq-iosched.h
+++ b/block/bfq-iosched.h
@@ -993,7 +993,7 @@ bool __bfq_deactivate_entity(struct bfq_entity *entity,
 			     bool ins_into_idle_tree);
 bool next_queue_may_preempt(struct bfq_data *bfqd);
 struct bfq_queue *bfq_get_next_queue(struct bfq_data *bfqd);
-void __bfq_bfqd_reset_in_service(struct bfq_data *bfqd);
+bool __bfq_bfqd_reset_in_service(struct bfq_data *bfqd);
 void bfq_deactivate_bfqq(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 			 bool ins_into_idle_tree, bool expiration);
 void bfq_activate_bfqq(struct bfq_data *bfqd, struct bfq_queue *bfqq);
diff --git a/block/bfq-wf2q.c b/block/bfq-wf2q.c
index 4aab1a8191f0..8077bf71d2ac 100644
--- a/block/bfq-wf2q.c
+++ b/block/bfq-wf2q.c
@@ -1599,7 +1599,8 @@ struct bfq_queue *bfq_get_next_queue(struct bfq_data *bfqd)
 	return bfqq;
 }
 
-void __bfq_bfqd_reset_in_service(struct bfq_data *bfqd)
+/* returns true if the in-service queue gets freed */
+bool __bfq_bfqd_reset_in_service(struct bfq_data *bfqd)
 {
 	struct bfq_queue *in_serv_bfqq = bfqd->in_service_queue;
 	struct bfq_entity *in_serv_entity = &in_serv_bfqq->entity;
@@ -1623,8 +1624,20 @@ void __bfq_bfqd_reset_in_service(struct bfq_data *bfqd)
 	 * service tree either, then release the service reference to
 	 * the queue it represents (taken with bfq_get_entity).
 	 */
-	if (!in_serv_entity->on_st)
+	if (!in_serv_entity->on_st) {
+		/*
+		 * If no process is referencing in_serv_bfqq any
+		 * longer, then the service reference may be the only
+		 * reference to the queue. If this is the case, then
+		 * bfqq gets freed here.
+		 */
+		int ref = in_serv_bfqq->ref;
 		bfq_put_queue(in_serv_bfqq);
+		if (ref == 1)
+			return true;
+	}
+
+	return false;
 }
 
 void bfq_deactivate_bfqq(struct bfq_data *bfqd, struct bfq_queue *bfqq,
-- 
2.19.1



