Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 633A44C74A6
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:45:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238653AbiB1RqI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:46:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239581AbiB1RoX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:44:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDBAB9D4F4;
        Mon, 28 Feb 2022 09:36:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DEA55614D5;
        Mon, 28 Feb 2022 17:36:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F27FAC340E7;
        Mon, 28 Feb 2022 17:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069798;
        bh=Utl/2VDfVpqlSGlqHYDKHbZYY9ND1hsbHFc5pFhnRa4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vQzuCpBi9BHy20ie+LBrXqB7RSRizDFXRPOnVOAK/FWrK/vBk07Zv3z0Pyvg0MuhL
         qGSR1Z8Pv10dvXSe6qnEpkQhvl6rHkfJpf7ui5uepKNC2g71hUe4LI+eLMrDnu5I7R
         I3RNNiUy18G8B8n21CT1PBexPJsQheBoChilnI8w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Chen <chenbo.chen@alibaba-inc.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 008/139] io_uring: dont convert to jiffies for waiting on timeouts
Date:   Mon, 28 Feb 2022 18:23:02 +0100
Message-Id: <20220228172348.578223724@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172347.614588246@linuxfoundation.org>
References: <20220228172347.614588246@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 228339662b398a59b3560cd571deb8b25b253c7e upstream.

If an application calls io_uring_enter(2) with a timespec passed in,
convert that timespec to ktime_t rather than jiffies. The latter does
not provide the granularity the application may expect, and may in
fact provided different granularity on different systems, depending
on what the HZ value is configured at.

Turn the timespec into an absolute ktime_t, and use that with
schedule_hrtimeout() instead.

Link: https://github.com/axboe/liburing/issues/531
Cc: stable@vger.kernel.org
Reported-by: Bob Chen <chenbo.chen@alibaba-inc.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7590,7 +7590,7 @@ static int io_run_task_work_sig(void)
 /* when returns >0, the caller should retry */
 static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 					  struct io_wait_queue *iowq,
-					  signed long *timeout)
+					  ktime_t timeout)
 {
 	int ret;
 
@@ -7602,8 +7602,9 @@ static inline int io_cqring_wait_schedul
 	if (test_bit(0, &ctx->check_cq_overflow))
 		return 1;
 
-	*timeout = schedule_timeout(*timeout);
-	return !*timeout ? -ETIME : 1;
+	if (!schedule_hrtimeout(&timeout, HRTIMER_MODE_ABS))
+		return -ETIME;
+	return 1;
 }
 
 /*
@@ -7616,7 +7617,7 @@ static int io_cqring_wait(struct io_ring
 {
 	struct io_wait_queue iowq;
 	struct io_rings *rings = ctx->rings;
-	signed long timeout = MAX_SCHEDULE_TIMEOUT;
+	ktime_t timeout = KTIME_MAX;
 	int ret;
 
 	do {
@@ -7632,7 +7633,7 @@ static int io_cqring_wait(struct io_ring
 
 		if (get_timespec64(&ts, uts))
 			return -EFAULT;
-		timeout = timespec64_to_jiffies(&ts);
+		timeout = ktime_add_ns(timespec64_to_ktime(ts), ktime_get_ns());
 	}
 
 	if (sig) {
@@ -7664,7 +7665,7 @@ static int io_cqring_wait(struct io_ring
 		}
 		prepare_to_wait_exclusive(&ctx->cq_wait, &iowq.wq,
 						TASK_INTERRUPTIBLE);
-		ret = io_cqring_wait_schedule(ctx, &iowq, &timeout);
+		ret = io_cqring_wait_schedule(ctx, &iowq, timeout);
 		finish_wait(&ctx->cq_wait, &iowq.wq);
 		cond_resched();
 	} while (ret > 0);


