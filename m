Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EFC447FED6
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237575AbhL0Pc5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:32:57 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:33992 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238049AbhL0Pct (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:32:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0A4E610A6;
        Mon, 27 Dec 2021 15:32:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C26F3C36AEB;
        Mon, 27 Dec 2021 15:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619168;
        bh=4bRulaxE7kkQ/lwnl9f1sNtyQRvG9h/NNXObngGG0BA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nFV5yxeD+TkAQ+0MCNM5qhBWtLPTAmUeqyHexHrQJ699frJtvHPmMUHHt5CundE0Y
         s+Y6ACEIfxwH4Wfq2avkbMvLRgEArYWbk+l55mE/QRbVOAlNRWX5HN3AeJ+e/IAmRM
         1kFChayljlIbouOJAOeGOLWCy1EMc53+BfeC9N20=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitrii Tcvetkov <demfloro@demfloro.ru>,
        Douglas Anderson <dianders@chromium.org>,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>, Yu Kuai <yukuai3@huawei.com>
Subject: [PATCH 4.19 06/38] block, bfq: fix use after free in bfq_bfqq_expire
Date:   Mon, 27 Dec 2021 16:30:43 +0100
Message-Id: <20211227151319.590190184@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151319.379265346@linuxfoundation.org>
References: <20211227151319.379265346@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Valente <paolo.valente@linaro.org>

commit eed47d19d9362bdd958e4ab56af480b9dbf6b2b6 upstream.

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
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/bfq-iosched.c |   15 +++++++--------
 block/bfq-iosched.h |    2 +-
 block/bfq-wf2q.c    |   17 +++++++++++++++--
 3 files changed, 23 insertions(+), 11 deletions(-)

--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -2816,7 +2816,7 @@ static void bfq_dispatch_remove(struct r
 	bfq_remove_request(q, rq);
 }
 
-static void __bfq_bfqq_expire(struct bfq_data *bfqd, struct bfq_queue *bfqq)
+static bool __bfq_bfqq_expire(struct bfq_data *bfqd, struct bfq_queue *bfqq)
 {
 	/*
 	 * If this bfqq is shared between multiple processes, check
@@ -2849,9 +2849,11 @@ static void __bfq_bfqq_expire(struct bfq
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
@@ -3256,7 +3258,6 @@ void bfq_bfqq_expire(struct bfq_data *bf
 	bool slow;
 	unsigned long delta = 0;
 	struct bfq_entity *entity = &bfqq->entity;
-	int ref;
 
 	/*
 	 * Check whether the process is slow (see bfq_bfqq_is_slow).
@@ -3325,10 +3326,8 @@ void bfq_bfqq_expire(struct bfq_data *bf
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
--- a/block/bfq-iosched.h
+++ b/block/bfq-iosched.h
@@ -993,7 +993,7 @@ bool __bfq_deactivate_entity(struct bfq_
 			     bool ins_into_idle_tree);
 bool next_queue_may_preempt(struct bfq_data *bfqd);
 struct bfq_queue *bfq_get_next_queue(struct bfq_data *bfqd);
-void __bfq_bfqd_reset_in_service(struct bfq_data *bfqd);
+bool __bfq_bfqd_reset_in_service(struct bfq_data *bfqd);
 void bfq_deactivate_bfqq(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 			 bool ins_into_idle_tree, bool expiration);
 void bfq_activate_bfqq(struct bfq_data *bfqd, struct bfq_queue *bfqq);
--- a/block/bfq-wf2q.c
+++ b/block/bfq-wf2q.c
@@ -1600,7 +1600,8 @@ struct bfq_queue *bfq_get_next_queue(str
 	return bfqq;
 }
 
-void __bfq_bfqd_reset_in_service(struct bfq_data *bfqd)
+/* returns true if the in-service queue gets freed */
+bool __bfq_bfqd_reset_in_service(struct bfq_data *bfqd)
 {
 	struct bfq_queue *in_serv_bfqq = bfqd->in_service_queue;
 	struct bfq_entity *in_serv_entity = &in_serv_bfqq->entity;
@@ -1624,8 +1625,20 @@ void __bfq_bfqd_reset_in_service(struct
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


