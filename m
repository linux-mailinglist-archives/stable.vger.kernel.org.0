Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4C2470E29
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 23:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344750AbhLJWuF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 17:50:05 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:56974 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344718AbhLJWuE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 17:50:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B4E98CE2B7D;
        Fri, 10 Dec 2021 22:46:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D744C00446;
        Fri, 10 Dec 2021 22:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639176385;
        bh=xc+JETihgXXiqFz+VxJKnyLRp8GtucnyUYHiLi2tBko=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=wKkojB9qiP7L8VhAuqE8tbOQLuu6A7HnEMTqWibjBuoWcIShSrua/HVUrPvRy8tcJ
         tpBhJD9LmgkFyZ21EJ7Yv79wLepROv2EbHRqCrgT+wc0+JzDKA2fAdprQSXFQzmOSI
         DPsQPm+YvPun06Qrkm9f0ZZjpOdWGtj3zCmlGK/A=
Date:   Fri, 10 Dec 2021 14:46:25 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, john.stultz@linaro.org,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        oleksandr@natalenko.name, sj@kernel.org, stable@vger.kernel.org,
        tglx@linutronix.de, torvalds@linux-foundation.org
Subject:  [patch 06/21] mm/damon/core: fix fake load reports due to
 uninterruptible sleeps
Message-ID: <20211210224625.aHoRXImMJ%akpm@linux-foundation.org>
In-Reply-To: <20211210144539.663efee2c80d8450e6180230@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: fix fake load reports due to uninterruptible sleeps

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
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-fix-fake-load-reports-due-to-uninterruptible-sleeps
+++ a/mm/damon/core.c
@@ -981,9 +981,9 @@ static unsigned long damos_wmark_wait_us
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
@@ -1038,7 +1038,7 @@ static int kdamond_fn(void *data)
 				ctx->callback.after_sampling(ctx))
 			done = true;
 
-		usleep_range(ctx->sample_interval, ctx->sample_interval + 1);
+		kdamond_usleep(ctx->sample_interval);
 
 		if (ctx->primitive.check_accesses)
 			max_nr_accesses = ctx->primitive.check_accesses(ctx);
_
