Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4860B21F366
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 16:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbgGNOCL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 10:02:11 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:47317 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727794AbgGNOCL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jul 2020 10:02:11 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id AB38F5762;
        Tue, 14 Jul 2020 10:02:09 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 14 Jul 2020 10:02:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=6OxziY
        M1BiabqoTcUOt6C+ldSA5/EOku7gTETLoDkwo=; b=B383jhDODOYhsuQiEUZaxc
        F+XRUYbsHyywuk5C9gEwWxyWUnA8CyZlaWPZvEMNvK9mmAOwowws0TOfHueeIByG
        KSUh4zPtpitnkXmGBxYh8KPBtOrFD6LqZCS7Ptz/HbGTiN6XBEeDKtDI5mA8ATpY
        ItbTaFINOwcWVHe3hhN+gMHjAipyLkSw40KUzf4G+ivOi7EiI3EigSRSCY4PP2yX
        kCFNfAKEnaz26EWNQtai6W2xunWNeEaAf6bPqyEznjzG1O6X+ENqD8JvXO2c332R
        xWGEHmcwe2IhOwhlEaXbpWu6r8Exp4CdcDauDQeowlJBVM/ndh846guMKTkBey5w
        ==
X-ME-Sender: <xms:4LoNX-BfPFaOshO_21FZu7Kfs1PKd2XuH_2e5g-6DQ3lCCefxUgBAA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrfedtgdejgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:4LoNX4guTuAOMJvISgiSHSMs0XqLauLQMLClDXy0Zj4kY3-jGT3sPQ>
    <xmx:4LoNXxlY2Ism4fL-AuhrWgYM041aC86DIXyXPPQWHArsH5VNgAv0BA>
    <xmx:4LoNX8xkMxQcr_LcGiaL4BULFJCBf2vIzluSiQB-SAQD4iAmrq9tMQ>
    <xmx:4boNX2OqZhpWoVCdZy_42UIZIq3tVMSJ-ok9y2ANcjfoiaND5lCzdmbY6lM>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3FBC43280064;
        Tue, 14 Jul 2020 10:02:08 -0400 (EDT)
Subject: FAILED: patch "[PATCH] dm: do not use waitqueue for request-based DM" failed to apply to 5.7-stable tree
To:     ming.lei@redhat.com, snitzer@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 14 Jul 2020 16:02:04 +0200
Message-ID: <1594735324238163@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.7-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 85067747cf9888249fa11fa49ef75af5192d3988 Mon Sep 17 00:00:00 2001
From: Ming Lei <ming.lei@redhat.com>
Date: Wed, 24 Jun 2020 16:00:58 -0400
Subject: [PATCH] dm: do not use waitqueue for request-based DM

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

diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index f60c02512121..85e0daabad49 100644
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
index e6807792fec8..446aff589732 100644
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
@@ -2470,15 +2448,29 @@ void dm_put(struct mapped_device *md)
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
@@ -2493,6 +2485,28 @@ static int dm_wait_for_completion(struct mapped_device *md, long task_state)
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

