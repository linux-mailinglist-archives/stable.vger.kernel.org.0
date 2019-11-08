Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7023F4977
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:03:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389966AbfKHMDZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 07:03:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:56864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732734AbfKHLmo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:42:44 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A15A222466;
        Fri,  8 Nov 2019 11:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213363;
        bh=g6zAEREEgLTWT7LnJikRiT6qbd4YDdqTAfzWJ67n6H4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e2PYmMOXRIQSOp1GrRRe6GlgP+4Zr6+OsEll+fwsQvH7GM5t3N3Uvvm6umH2VaaN4
         RWoQZa3XVhTnxEijmjhK11TOePDUpCn3Sk1M8FpocgWFK0EKssFWQxeQjBiFerIja8
         XkvpQODooYhCeDUjayVZxXEVn9lNgwctcPVTd+S0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 191/205] blok, bfq: do not plug I/O if all queues are weight-raised
Date:   Fri,  8 Nov 2019 06:37:38 -0500
Message-Id: <20191108113752.12502-191-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 35ddaa820737c..66b1ebc21ce4f 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -3593,7 +3593,12 @@ static bool bfq_better_to_idle(struct bfq_queue *bfqq)
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
@@ -3605,7 +3610,8 @@ static bool bfq_better_to_idle(struct bfq_queue *bfqq)
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

