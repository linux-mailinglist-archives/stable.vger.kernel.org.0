Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5FB653DBD4
	for <lists+stable@lfdr.de>; Sun,  5 Jun 2022 15:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344534AbiFENyc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Jun 2022 09:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344477AbiFENy2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Jun 2022 09:54:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0B4364D7;
        Sun,  5 Jun 2022 06:54:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5F1660F03;
        Sun,  5 Jun 2022 13:54:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84380C34115;
        Sun,  5 Jun 2022 13:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654437243;
        bh=AU8d+kJilhAOhDFwChzPGNMoONnIHkfPe6ac7uyzwz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D15nyA7udLO1XyADgsX9UsjWPfZaSUW5rtQR/B7FhojMfqcfZyBSV4GozRtcUXZBw
         JnygbbqUBPeDgxwHw9nIJYK0O4V9qjFI5TzSxZmDrGmAHq/U455pGL+JT8LIJFt0G+
         4SoF0Y3sUYdvrgzkgc5sl+BnTKHkdEZBKnyLbDjkhLdgP2rDB/58mb9AOKbPfKhSyx
         NNhLIHpfjId58+AQthrh10Btm1opokIAw4cFj+k8RUtEfENGcPafbQ5ATIIGc1Dyjl
         i3mSOKIccPTgfN9ldWNa0M572UCiyD5s16jdjtvce5iHgWKEHUffjd4kc5t1b19kiR
         H3yyYdzdJYivg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <jstultz@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH MANUALSEL 5.17 3/6] time/sched_clock: Round the frequency reported to nearest rather than down
Date:   Sun,  5 Jun 2022 09:53:34 -0400
Message-Id: <20220605135341.61427-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220605135341.61427-1-sashal@kernel.org>
References: <20220605135341.61427-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Maciej W. Rozycki" <macro@orcam.me.uk>

[ Upstream commit 92067440f1311dfa4d77b57a9da6b3706f5da32e ]

The frequency reported for clock sources are rounded down, which gives
misleading figures, e.g.:

 I/O ASIC clock frequency 24999480Hz
 sched_clock: 32 bits at 24MHz, resolution 40ns, wraps every 85901132779ns
 MIPS counter frequency 59998512Hz
 sched_clock: 32 bits at 59MHz, resolution 16ns, wraps every 35792281591ns

Rounding to nearest is more adequate:

 I/O ASIC clock frequency 24999664Hz
 sched_clock: 32 bits at 25MHz, resolution 40ns, wraps every 85900499947ns
 MIPS counter frequency 59999728Hz
 sched_clock: 32 bits at 60MHz, resolution 16ns, wraps every 35791556599ns

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: John Stultz <jstultz@google.com>
Link: https://lore.kernel.org/r/alpine.DEB.2.21.2204240055590.9383@angie.orcam.me.uk
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/sched_clock.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/time/sched_clock.c b/kernel/time/sched_clock.c
index b1b9b12899f5..ee07f3ac1e5b 100644
--- a/kernel/time/sched_clock.c
+++ b/kernel/time/sched_clock.c
@@ -8,6 +8,7 @@
 #include <linux/jiffies.h>
 #include <linux/ktime.h>
 #include <linux/kernel.h>
+#include <linux/math.h>
 #include <linux/moduleparam.h>
 #include <linux/sched.h>
 #include <linux/sched/clock.h>
@@ -199,11 +200,11 @@ sched_clock_register(u64 (*read)(void), int bits, unsigned long rate)
 
 	r = rate;
 	if (r >= 4000000) {
-		r /= 1000000;
+		r = DIV_ROUND_CLOSEST(r, 1000000);
 		r_unit = 'M';
 	} else {
 		if (r >= 1000) {
-			r /= 1000;
+			r = DIV_ROUND_CLOSEST(r, 1000);
 			r_unit = 'k';
 		} else {
 			r_unit = ' ';
-- 
2.35.1

