Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFE6845C808
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:52:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348599AbhKXOzh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:55:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:53292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344961AbhKXOzg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:55:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6990D60524;
        Wed, 24 Nov 2021 14:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637765547;
        bh=5dhCOHOPDLaykpUjwDvndyMO8fDWAczCxAEVkK7Z7WM=;
        h=From:To:Cc:Subject:Date:From;
        b=pxZMCdE36FKsG3OKrHfqS8gJ/XQb+zDkgcjWs1LT1CwIW6boCLsAc62ocselrpKPc
         do1tVWsaG4Fm5fpODLW3v0sz1ovCTL9oSrw0M211Nd5u0FDuAFQ/EG6lu5/9bTKcLQ
         hcL5k+GW46zEtP7RRGxygNDt+KWrCqkcuW4y9GzagvtATa5m/TfiKuY1jL0tS9P0Lg
         xuCLDg6JqNaeLjtgx/nZ2sn8KZFLdcgN0vGmLa333f2d886diok6nCi9bfS7PabdnA
         LKdtZ6gTTkzXkJvIP8bTPeCwJlJW7ZSqg+4xyE9CDrFnIdHx+Eddut/ZnTqXQmz+B0
         Qo3k1AQcPC+UQ==
From:   SeongJae Park <sj@kernel.org>
To:     akpm@linux-foundation.org
Cc:     shakeelb@google.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, SeongJae Park <sj@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH] mm/damon/core: Avoid fake load reports due to uninterruptible sleeps
Date:   Wed, 24 Nov 2021 14:52:19 +0000
Message-Id: <20211124145219.32866-1-sj@kernel.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Because DAMON sleeps in uninterruptible mode, /proc/loadavg reports fake
load while DAMON is turned on, though it is doing nothing.  This can
confuse users[1].  To avoid the case, this commit makes DAMON sleeps in
idle mode.

[1] https://lore.kernel.org/all/11868371.O9o76ZdvQC@natalenko.name/

Fixes: 2224d8485492 ("mm: introduce Data Access MONitor (DAMON)")
Reported-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 5.15.x
---
I think this needs to be applied on v5.15.y, but this cannot cleanly
applied there as is.  I will back-port this on v5.15.y and post later
once this is merged in the mainline.

 mm/damon/core.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index daacd9536c7c..7813f47aadc9 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -12,6 +12,8 @@
 #include <linux/kthread.h>
 #include <linux/mm.h>
 #include <linux/random.h>
+#include <linux/sched.h>
+#include <linux/sched/debug.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 
@@ -976,12 +978,25 @@ static unsigned long damos_wmark_wait_us(struct damos *scheme)
 	return 0;
 }
 
+/* sleep for @usecs in idle mode */
+static void __sched damon_usleep_idle(unsigned long usecs)
+{
+	ktime_t exp = ktime_add_us(ktime_get(), usecs);
+	u64 delta = usecs * NSEC_PER_USEC / 100;	/* allow 1% error */
+
+	for (;;) {
+		__set_current_state(TASK_IDLE);
+		if (!schedule_hrtimeout_range(&exp, delta, HRTIMER_MODE_ABS))
+			break;
+	}
+}
+
 static void kdamond_usleep(unsigned long usecs)
 {
 	if (usecs > 100 * 1000)
-		schedule_timeout_interruptible(usecs_to_jiffies(usecs));
+		schedule_timeout_idle(usecs_to_jiffies(usecs));
 	else
-		usleep_range(usecs, usecs + 1);
+		damon_usleep_idle(usecs);
 }
 
 /* Returns negative error code if it's not activated but should return */
@@ -1036,7 +1051,7 @@ static int kdamond_fn(void *data)
 				ctx->callback.after_sampling(ctx))
 			done = true;
 
-		usleep_range(ctx->sample_interval, ctx->sample_interval + 1);
+		kdamond_usleep(ctx->sample_interval);
 
 		if (ctx->primitive.check_accesses)
 			max_nr_accesses = ctx->primitive.check_accesses(ctx);
-- 
2.17.1

