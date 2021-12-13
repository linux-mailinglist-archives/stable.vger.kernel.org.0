Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0873A472748
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237871AbhLMJ73 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:59:29 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:39308 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239382AbhLMJ5P (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:57:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 416B1B80E63;
        Mon, 13 Dec 2021 09:57:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C112C34601;
        Mon, 13 Dec 2021 09:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389433;
        bh=BtnyKAUcFEHFJBGJih+sKxOT3PrmwV4N42S+2eNTadY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vTa2BGlZtRCzkyz2h2MDQWNIn22WgnEwrPhizMmrB5GfMIfvuyOeB4kSEU4Uf0isz
         rbb7LLS/k7uxhEkZIyGUmfgyngdm5IzlRXD3x4JSV2traWR+oaHUsKBFw/Y8ZH6ucs
         O/Pzcs6PXk/Y4OXJGaGUrP6KYe91rB+9iJZvApNs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        SeongJae Park <sj@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 061/171] mm/damon/core: fix fake load reports due to uninterruptible sleeps
Date:   Mon, 13 Dec 2021 10:29:36 +0100
Message-Id: <20211213092947.137050575@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: SeongJae Park <sj@kernel.org>

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
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/core.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -357,6 +357,15 @@ int damon_start(struct damon_ctx **ctxs,
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
@@ -370,8 +379,7 @@ static int __damon_stop(struct damon_ctx
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


