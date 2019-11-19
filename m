Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A84A71015FC
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:49:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730549AbfKSFtO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:49:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:45888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730779AbfKSFtN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:49:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58A37208C3;
        Tue, 19 Nov 2019 05:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142552;
        bh=XTKduqN7mHhES6KQ6cLQz/6SZSC+gMKdX1Jkj9OtVMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RBygYwKIw7oruLMZG0sFuS1arLj77J93Rn387YR6+nBDs+gytXaX053q8K6oGZYi4
         T/kufXkaCqS/GdsSnO3QvFjlTpeVvh6QHWvGlaAMI3XN6G4jjdFP8geXYIwXoV5FKQ
         se9agfvqfDlycFArCuU/Ehz93dhcQQWCQ/p4LWb0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 119/239] blok, bfq: do not plug I/O if all queues are weight-raised
Date:   Tue, 19 Nov 2019 06:18:39 +0100
Message-Id: <20191119051329.460723697@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
References: <20191119051255.850204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Valente <paolo.valente@linaro.org>

[ Upstream commit c8765de0adfcaaf4ffb2d951e07444f00ffa9453 ]

To reduce latency for interactive and soft real-time applications, bfq
privileges the bfq_queues containing the I/O of these
applications. These privileged queues, referred-to as weight-raised
queues, get a much higher share of the device throughput
w.r.t. non-privileged queues. To preserve this higher share, the I/O
of any non-weight-raised queue must be plugged whenever a sync
weight-raised queue, while being served, remains temporarily empty. To
attain this goal, bfq simply plugs any I/O (from any queue), if a sync
weight-raised queue remains empty while in service.

Unfortunately, this plugging typically lowers throughput with random
I/O, on devices with internal queueing (because it reduces the filling
level of the internal queues of the device).

This commit addresses this issue by restricting the cases where
plugging is performed: if a sync weight-raised queue remains empty
while in service, then I/O plugging is performed only if some of the
active bfq_queues are *not* weight-raised (which is actually the only
circumstance where plugging is needed to preserve the higher share of
the throughput of weight-raised queues). This restriction proved able
to boost throughput in really many use cases needing only maximum
throughput.

Signed-off-by: Paolo Valente <paolo.valente@linaro.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bfq-iosched.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index e65b0da1007b4..93863c6173e66 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -3314,7 +3314,12 @@ static bool bfq_bfqq_may_idle(struct bfq_queue *bfqq)
 	 * whether bfqq is being weight-raised, because
 	 * bfq_symmetric_scenario() does not take into account also
 	 * weight-raised queues (see comments on
-	 * bfq_weights_tree_add()).
+	 * bfq_weights_tree_add()). In particular, if bfqq is being
+	 * weight-raised, it is important to idle only if there are
+	 * other, non-weight-raised queues that may steal throughput
+	 * to bfqq. Actually, we should be even more precise, and
+	 * differentiate between interactive weight raising and
+	 * soft real-time weight raising.
 	 *
 	 * As a side note, it is worth considering that the above
 	 * device-idling countermeasures may however fail in the
@@ -3326,7 +3331,8 @@ static bool bfq_bfqq_may_idle(struct bfq_queue *bfqq)
 	 * to let requests be served in the desired order until all
 	 * the requests already queued in the device have been served.
 	 */
-	asymmetric_scenario = bfqq->wr_coeff > 1 ||
+	asymmetric_scenario = (bfqq->wr_coeff > 1 &&
+			       bfqd->wr_busy_queues < bfqd->busy_queues) ||
 		!bfq_symmetric_scenario(bfqd);
 
 	/*
-- 
2.20.1



