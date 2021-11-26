Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF19545F046
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 16:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350426AbhKZPGm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 10:06:42 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59762 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237166AbhKZPEm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Nov 2021 10:04:42 -0500
X-Greylist: delayed 661 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Nov 2021 10:04:42 EST
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1773B622A9;
        Fri, 26 Nov 2021 14:50:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5EDFC9305F;
        Fri, 26 Nov 2021 14:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637938226;
        bh=3UuzhmSP/V3v920tpSUyBSyVCTZdS6flxK4IwxjCSag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QlNxq1pgLqwfObJ9a/kiDbtETqF1ghoOlk5q2bhYRgfqY+ZFcTs16casgzOT2L1uN
         8GA5AyyVqJzKKWbr6ffu98uR87qQseX9NIL7GiN6KdqVXo0fBYhCJGcdOuxB+sxkNR
         hgblBy9r3Q7lg73KpGtAd07bTpyIdHMQhz2FbJKRxrVdeusbhbBoghhtgM0g/RVM20
         AZ9yK5sZ+uQazMRpcmncN9rrl7ut+1ZZklaVML4iLV/HYd5tZvCnUQ7H+gQOz7mtNW
         JpSPgdgKZ5vAUWrmQcqbEJ3gj/bYiqxRuC2v285JM2OkDJ+oqG/tSy39yG7KcCx23Z
         Ul+MR6LCIlR7w==
From:   SeongJae Park <sj@kernel.org>
To:     akpm@linux-foundation.org
Cc:     oleksandr@natalenko.name, john.stultz@linaro.org,
        tglx@linutronix.de, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, SeongJae Park <sj@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH v3 2/2] mm/damon/core: Fix fake load reports due to uninterruptible sleeps
Date:   Fri, 26 Nov 2021 14:50:15 +0000
Message-Id: <20211126145015.15862-3-sj@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211126145015.15862-1-sj@kernel.org>
References: <20211126145015.15862-1-sj@kernel.org>
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
 mm/damon/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index daacd9536c7c..8cd8fddc931e 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -979,9 +979,9 @@ static unsigned long damos_wmark_wait_us(struct damos *scheme)
 static void kdamond_usleep(unsigned long usecs)
 {
 	if (usecs > 100 * 1000)
-		schedule_timeout_interruptible(usecs_to_jiffies(usecs));
+		schedule_timeout_idle(usecs_to_jiffies(usecs));
 	else
-		usleep_range(usecs, usecs + 1);
+		usleep_idle_range(usecs, usecs + 1);
 }
 
 /* Returns negative error code if it's not activated but should return */
@@ -1036,7 +1036,7 @@ static int kdamond_fn(void *data)
 				ctx->callback.after_sampling(ctx))
 			done = true;
 
-		usleep_range(ctx->sample_interval, ctx->sample_interval + 1);
+		kdamond_usleep(ctx->sample_interval);
 
 		if (ctx->primitive.check_accesses)
 			max_nr_accesses = ctx->primitive.check_accesses(ctx);
-- 
2.17.1

