Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1380A15DEA1
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:05:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389881AbgBNQEP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:04:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:52170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389876AbgBNQEO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:04:14 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00ABA2467D;
        Fri, 14 Feb 2020 16:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696253;
        bh=zXYDllGi1W/9ul4JnuG2KMjPEJFmSPCqF3M/JJp9SfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Vpa9wxZnnRlyMklZg7rsbJMfdBp9vZC/aMs9l5zu7i3TCJv/VjQvvpXDizrtaPI5
         oByHSON2CosWlHra/JE/emGAku7I65yNTgK6TisPVhSBbTMF3o098ZooYWOuOL6/ek
         k6HfK+6f71Up8jXp1WwKpxOb/8DHaNZ9K34QZWQQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paolo Valente <paolo.valente@linaro.org>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Patrick Dung <patdung100@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 109/459] block, bfq: do not plug I/O for bfq_queues with no proc refs
Date:   Fri, 14 Feb 2020 10:55:59 -0500
Message-Id: <20200214160149.11681-109-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Valente <paolo.valente@linaro.org>

[ Upstream commit f718b093277df582fbf8775548a4f163e664d282 ]

Commit 478de3380c1c ("block, bfq: deschedule empty bfq_queues not
referred by any process") fixed commit 3726112ec731 ("block, bfq:
re-schedule empty queues if they deserve I/O plugging") by
descheduling an empty bfq_queue when it remains with not process
reference. Yet, this still left a case uncovered: an empty bfq_queue
with not process reference that remains in service. This happens for
an in-service sync bfq_queue that is deemed to deserve I/O-dispatch
plugging when it remains empty. Yet no new requests will arrive for
such a bfq_queue if no process sends requests to it any longer. Even
worse, the bfq_queue may happen to be prematurely freed while still in
service (because there may remain no reference to it any longer).

This commit solves this problem by preventing I/O dispatch from being
plugged for the in-service bfq_queue, if the latter has no process
reference (the bfq_queue is then prevented from remaining in service).

Fixes: 3726112ec731 ("block, bfq: re-schedule empty queues if they deserve I/O plugging")
Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Reported-by: Patrick Dung <patdung100@gmail.com>
Tested-by: Patrick Dung <patdung100@gmail.com>
Signed-off-by: Paolo Valente <paolo.valente@linaro.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bfq-iosched.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 0c6214497fcc1..5498d05b873d3 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -3444,6 +3444,10 @@ static void bfq_dispatch_remove(struct request_queue *q, struct request *rq)
 static bool idling_needed_for_service_guarantees(struct bfq_data *bfqd,
 						 struct bfq_queue *bfqq)
 {
+	/* No point in idling for bfqq if it won't get requests any longer */
+	if (unlikely(!bfqq_process_refs(bfqq)))
+		return false;
+
 	return (bfqq->wr_coeff > 1 &&
 		(bfqd->wr_busy_queues <
 		 bfq_tot_busy_queues(bfqd) ||
@@ -4077,6 +4081,10 @@ static bool idling_boosts_thr_without_issues(struct bfq_data *bfqd,
 		bfqq_sequential_and_IO_bound,
 		idling_boosts_thr;
 
+	/* No point in idling for bfqq if it won't get requests any longer */
+	if (unlikely(!bfqq_process_refs(bfqq)))
+		return false;
+
 	bfqq_sequential_and_IO_bound = !BFQQ_SEEKY(bfqq) &&
 		bfq_bfqq_IO_bound(bfqq) && bfq_bfqq_has_short_ttime(bfqq);
 
@@ -4170,6 +4178,10 @@ static bool bfq_better_to_idle(struct bfq_queue *bfqq)
 	struct bfq_data *bfqd = bfqq->bfqd;
 	bool idling_boosts_thr_with_no_issue, idling_needed_for_service_guar;
 
+	/* No point in idling for bfqq if it won't get requests any longer */
+	if (unlikely(!bfqq_process_refs(bfqq)))
+		return false;
+
 	if (unlikely(bfqd->strict_guarantees))
 		return true;
 
-- 
2.20.1

