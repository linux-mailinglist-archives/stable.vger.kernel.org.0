Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19407460270
	for <lists+stable@lfdr.de>; Sun, 28 Nov 2021 00:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231998AbhK1ACO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 27 Nov 2021 19:02:14 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42654 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231622AbhK1AAO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 27 Nov 2021 19:00:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B264B80662;
        Sat, 27 Nov 2021 23:56:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9096C53FBF;
        Sat, 27 Nov 2021 23:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638057417;
        bh=icvtoA57qKh1cqysQd7r48aFx/Nx1ZcR23HSoh8yZLg=;
        h=Date:From:To:Subject:From;
        b=BYeBqBg4myi7IrQq8pcbB4Oe56ycqJMujRbZ6MuC2SYlhgC5ub6950LJNxQTmh5ql
         ZPWVfs1VGtv4SLmBWHahgXsz5UYzvur8gVYeQpEQ/ZqYpmFAvTc1k0mH471Xv5Gbwk
         68A5dNcPhAGfRZwCecjfjOc67owC6pra49CStq6Y=
Date:   Sat, 27 Nov 2021 15:56:56 -0800
From:   akpm@linux-foundation.org
To:     john.stultz@linaro.org, mm-commits@vger.kernel.org,
        oleksandr@natalenko.name, sj@kernel.org, stable@vger.kernel.org,
        tglx@linutronix.de
Subject:  +
 mm-damon-core-fix-fake-load-reports-due-to-uninterruptible-sleeps.patch
 added to -mm tree
Message-ID: <20211127235656.knlr2mtzg%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/damon/core: fix fake load reports due to uninterruptible sleeps
has been added to the -mm tree.  Its filename is
     mm-damon-core-fix-fake-load-reports-due-to-uninterruptible-sleeps.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-core-fix-fake-load-reports-due-to-uninterruptible-sleeps.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-core-fix-fake-load-reports-due-to-uninterruptible-sleeps.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
Cc: Oleksandr Natalenko <oleksandr@natalenko.name>
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

Patches currently in -mm which might be from sj@kernel.org are

timers-implement-usleep_idle_range.patch
mm-damon-core-fix-fake-load-reports-due-to-uninterruptible-sleeps.patch
mm-damon-remove-some-no-need-func-definitions-in-damonh-file-fix.patch

