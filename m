Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CDEF47194E
	for <lists+stable@lfdr.de>; Sun, 12 Dec 2021 09:28:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbhLLI2q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Dec 2021 03:28:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbhLLI2p (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Dec 2021 03:28:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40CA8C061714;
        Sun, 12 Dec 2021 00:28:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB9EFB80B60;
        Sun, 12 Dec 2021 08:28:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5263C341C6;
        Sun, 12 Dec 2021 08:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639297722;
        bh=+vwEV3ZYpJcBSjbOoQrwfGcgCqTPvwgHQWlYU/fi9iY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z6ijJhFizilf6GF2g0lVgV57OFQBGnWLqDlLQLnhRfJBaqdjz4ebzllQS7PHG7CBr
         a+ItpL16EK5TP0oUmblYyCqq3/MVqYMSLcxFtbv58HX/B2Q40PK29uFH6waGSIdgFR
         Y8hC/Nqzc+BqwIZPi2AeiTLLIKiTj+S5P607XpXjYE0wxnERzra+vN5M9w7n+0lR6E
         g7CAE3a5JqSwva4165J6S4rIyMTnXkIxTws5wS25lrhpct1GGPRiqH7R3U87YNZ8x2
         ZKiYtijq0VW9ULuU/xCl7AxBWR73Rxk5fMja0ZKAzI75XlDVsLn5up+y5s8PFHVHir
         z+Q5I8JX9gRXA==
From:   SeongJae Park <sj@kernel.org>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org
Cc:     akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, SeongJae Park <sj@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH for-v5.15.x 2/2] mm/damon/core: fix fake load reports due to uninterruptible sleeps
Date:   Sun, 12 Dec 2021 08:28:30 +0000
Message-Id: <20211212082831.26988-3-sj@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211212082831.26988-1-sj@kernel.org>
References: <20211212082831.26988-1-sj@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 70e9274805fccfd175d0431a947bfd11ee7df40e upstream.

Because DAMON sleeps in uninterruptible mode, /proc/loadavg reports fake
load while DAMON is turned on, though it is doing nothing.  This can
confuse users[1].  To avoid the case, this commit makes DAMON sleeps in
idle mode.

[1] https://lore.kernel.org/all/11868371.O9o76ZdvQC@natalenko.name/

Link: https://lkml.kernel.org/r/20211126145015.15862-3-sj@kernel.org
Fixes: 2224d8485492 ("mm: introduce Data Access MONitor (DAMON)")
Reported-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Signed-off-by: SeongJae Park <sj@kernel.org>
Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 mm/damon/core.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 30e9211f494a..7a4912d6e65f 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -357,6 +357,15 @@ int damon_start(struct damon_ctx **ctxs, int nr_ctxs)
 	return err;
 }
 
+static void kdamond_usleep(unsigned long usecs)
+{
+	/* See Documentation/timers/timers-howto.rst for the thresholds */
+	if (usecs > 20 * 1000)
+		schedule_timeout_idle(usecs_to_jiffies(usecs));
+	else
+		usleep_idle_range(usecs, usecs + 1);
+}
+
 /*
  * __damon_stop() - Stops monitoring of given context.
  * @ctx:	monitoring context
@@ -370,8 +379,7 @@ static int __damon_stop(struct damon_ctx *ctx)
 		ctx->kdamond_stop = true;
 		mutex_unlock(&ctx->kdamond_lock);
 		while (damon_kdamond_running(ctx))
-			usleep_range(ctx->sample_interval,
-					ctx->sample_interval * 2);
+			kdamond_usleep(ctx->sample_interval);
 		return 0;
 	}
 	mutex_unlock(&ctx->kdamond_lock);
@@ -670,7 +678,7 @@ static int kdamond_fn(void *data)
 				ctx->callback.after_sampling(ctx))
 			set_kdamond_stop(ctx);
 
-		usleep_range(ctx->sample_interval, ctx->sample_interval + 1);
+		kdamond_usleep(ctx->sample_interval);
 
 		if (ctx->primitive.check_accesses)
 			max_nr_accesses = ctx->primitive.check_accesses(ctx);
-- 
2.17.1

