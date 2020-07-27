Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7818422EFFF
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731655AbgG0OVC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:21:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:49464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731649AbgG0OU7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:20:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8865C2070B;
        Mon, 27 Jul 2020 14:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859659;
        bh=83FKRz4ljNSMiOUI7jVjYJBG5w+ym0EF6kAuhn8Zr0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N+IIraooUtkuIYWlioPsOt/hJxcwikf7eYzTjhLb4qf3/tLGev5mFzjMg8XR1TfBL
         Iok9QsC+Zl48fE7kZWJz2/qhYL6DKTYXP4r/7XSRJQY/b36xvundK6ZsRr4iF2RyqB
         jNkMkkXq7Tv05UkGIkMTlyhNJl7fa7KF5GERUBrA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 025/179] dm: do not use waitqueue for request-based DM
Date:   Mon, 27 Jul 2020 16:03:20 +0200
Message-Id: <20200727134933.894457600@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 85067747cf9888249fa11fa49ef75af5192d3988 ]

Given request-based DM now uses blk-mq's blk_mq_queue_inflight() to
determine if outstanding IO has completed (and DM has no control over
the blk-mq state machine used to track outstanding IO) it is unsafe to
wakeup waiter (dm_wait_for_completion) before blk-mq has cleared a
request's state bits (e.g. MQ_RQ_IN_FLIGHT or MQ_RQ_COMPLETE).  As
such dm_wait_for_completion() could be left to wait indefinitely if no
other requests complete.

Fix this by eliminating request-based DM's use of waitqueue to wait
for blk-mq requests to complete in dm_wait_for_completion.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
Depends-on: 3c94d83cb3526 ("blk-mq: change blk_mq_queue_busy() to blk_mq_queue_inflight()")
Cc: stable@vger.kernel.org
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-rq.c |  4 ---
 drivers/md/dm.c    | 64 ++++++++++++++++++++++++++++------------------
 2 files changed, 39 insertions(+), 29 deletions(-)

diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index 3f8577e2c13be..9fb46a6301d80 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -146,10 +146,6 @@ static void rq_end_stats(struct mapped_device *md, struct request *orig)
  */
 static void rq_completed(struct mapped_device *md)
 {
-	/* nudge anyone waiting on suspend queue */
-	if (unlikely(wq_has_sleeper(&md->wait)))
-		wake_up(&md->wait);
-
 	/*
 	 * dm_put() must be at the end of this function. See the comment above
 	 */
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index cefda95c9abb7..e70f22d7874fa 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -654,28 +654,6 @@ static void free_tio(struct dm_target_io *tio)
 	bio_put(&tio->clone);
 }
 
-static bool md_in_flight_bios(struct mapped_device *md)
-{
-	int cpu;
-	struct hd_struct *part = &dm_disk(md)->part0;
-	long sum = 0;
-
-	for_each_possible_cpu(cpu) {
-		sum += part_stat_local_read_cpu(part, in_flight[0], cpu);
-		sum += part_stat_local_read_cpu(part, in_flight[1], cpu);
-	}
-
-	return sum != 0;
-}
-
-static bool md_in_flight(struct mapped_device *md)
-{
-	if (queue_is_mq(md->queue))
-		return blk_mq_queue_inflight(md->queue);
-	else
-		return md_in_flight_bios(md);
-}
-
 u64 dm_start_time_ns_from_clone(struct bio *bio)
 {
 	struct dm_target_io *tio = container_of(bio, struct dm_target_io, clone);
@@ -2447,15 +2425,29 @@ void dm_put(struct mapped_device *md)
 }
 EXPORT_SYMBOL_GPL(dm_put);
 
-static int dm_wait_for_completion(struct mapped_device *md, long task_state)
+static bool md_in_flight_bios(struct mapped_device *md)
+{
+	int cpu;
+	struct hd_struct *part = &dm_disk(md)->part0;
+	long sum = 0;
+
+	for_each_possible_cpu(cpu) {
+		sum += part_stat_local_read_cpu(part, in_flight[0], cpu);
+		sum += part_stat_local_read_cpu(part, in_flight[1], cpu);
+	}
+
+	return sum != 0;
+}
+
+static int dm_wait_for_bios_completion(struct mapped_device *md, long task_state)
 {
 	int r = 0;
 	DEFINE_WAIT(wait);
 
-	while (1) {
+	while (true) {
 		prepare_to_wait(&md->wait, &wait, task_state);
 
-		if (!md_in_flight(md))
+		if (!md_in_flight_bios(md))
 			break;
 
 		if (signal_pending_state(task_state, current)) {
@@ -2470,6 +2462,28 @@ static int dm_wait_for_completion(struct mapped_device *md, long task_state)
 	return r;
 }
 
+static int dm_wait_for_completion(struct mapped_device *md, long task_state)
+{
+	int r = 0;
+
+	if (!queue_is_mq(md->queue))
+		return dm_wait_for_bios_completion(md, task_state);
+
+	while (true) {
+		if (!blk_mq_queue_inflight(md->queue))
+			break;
+
+		if (signal_pending_state(task_state, current)) {
+			r = -EINTR;
+			break;
+		}
+
+		msleep(5);
+	}
+
+	return r;
+}
+
 /*
  * Process the deferred bios
  */
-- 
2.25.1



