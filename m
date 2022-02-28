Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2A674C75AF
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:55:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239435AbiB1R4G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:56:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240785AbiB1Ryp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:54:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00F6B532C6;
        Mon, 28 Feb 2022 09:43:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 915C960180;
        Mon, 28 Feb 2022 17:43:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99CB6C340E7;
        Mon, 28 Feb 2022 17:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070205;
        bh=8seL92Jujnzxe9kcZe3hncaHsIPde+ilak9Z5aBPr0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XSZKlrRnN4PODrfSLExwF00Pp8Ehw5wwRVkGyXGqkAR3yxP5jKxS9Nr4i2ikkwwjR
         1RJ9ashgK79B9e9PIIvAXyytF4egfvomDQQ0+R1eRQrXPh2lz617QmTV3sARv2/9n/
         xxGSqw7AI9mU2Xnymx/1IOUBvlnIz7bZLNrQbwcQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Chen <chenbo.chen@alibaba-inc.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.16 008/164] io_uring: dont convert to jiffies for waiting on timeouts
Date:   Mon, 28 Feb 2022 18:22:50 +0100
Message-Id: <20220228172400.500203076@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
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
@@ -7633,7 +7633,7 @@ static int io_run_task_work_sig(void)
 /* when returns >0, the caller should retry */
 static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 					  struct io_wait_queue *iowq,
-					  signed long *timeout)
+					  ktime_t timeout)
 {
 	int ret;
 
@@ -7645,8 +7645,9 @@ static inline int io_cqring_wait_schedul
 	if (test_bit(0, &ctx->check_cq_overflow))
 		return 1;
 
-	*timeout = schedule_timeout(*timeout);
-	return !*timeout ? -ETIME : 1;
+	if (!schedule_hrtimeout(&timeout, HRTIMER_MODE_ABS))
+		return -ETIME;
+	return 1;
 }
 
 /*
@@ -7659,7 +7660,7 @@ static int io_cqring_wait(struct io_ring
 {
 	struct io_wait_queue iowq;
 	struct io_rings *rings = ctx->rings;
-	signed long timeout = MAX_SCHEDULE_TIMEOUT;
+	ktime_t timeout = KTIME_MAX;
 	int ret;
 
 	do {
@@ -7675,7 +7676,7 @@ static int io_cqring_wait(struct io_ring
 
 		if (get_timespec64(&ts, uts))
 			return -EFAULT;
-		timeout = timespec64_to_jiffies(&ts);
+		timeout = ktime_add_ns(timespec64_to_ktime(ts), ktime_get_ns());
 	}
 
 	if (sig) {
@@ -7707,7 +7708,7 @@ static int io_cqring_wait(struct io_ring
 		}
 		prepare_to_wait_exclusive(&ctx->cq_wait, &iowq.wq,
 						TASK_INTERRUPTIBLE);
-		ret = io_cqring_wait_schedule(ctx, &iowq, &timeout);
+		ret = io_cqring_wait_schedule(ctx, &iowq, timeout);
 		finish_wait(&ctx->cq_wait, &iowq.wq);
 		cond_resched();
 	} while (ret > 0);


