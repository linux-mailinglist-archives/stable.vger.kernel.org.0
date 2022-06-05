Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE1953DBFD
	for <lists+stable@lfdr.de>; Sun,  5 Jun 2022 15:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344799AbiFEN5J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Jun 2022 09:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344336AbiFEN4x (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Jun 2022 09:56:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EA201057E;
        Sun,  5 Jun 2022 06:55:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 397DEB80735;
        Sun,  5 Jun 2022 13:55:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ADDBC385A5;
        Sun,  5 Jun 2022 13:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654437324;
        bh=qtgmRQbNxV0nqdmTRYUEhZMQC2FrHihA9RNYjajKkPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=shh82fRfbwcXia7W2uYdmWK5GQZc+9RdGJ1H6dpiZ02ejSiU/W1BbEtITRQcf2sWx
         CLVxJMlZaedQpIJnsNptC8npa/WcOv6KHdV+Iwv6RT/Gwopw1yMafJe8EQ9QT26jir
         W/wr1nRvWuvotKp0pSwfc1L4HvgW2OhsLvaXzrTn/saWobaQqoS8ofzBRdkso7SquE
         8gtxydf1zCTI51Xtd9EHHDLSSmkYF43Wja3NQyoxjlk9tXBjt8bWYQ1MAwO12N2j6v
         lbDJG0z8PwgxuGDEVMqQ9kL7qgNddtu09aJ0ZABBNpn5H9rM5hHnPmJHMM2xQhTLmC
         QFrm63+4qAVuw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <jstultz@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH MANUALSEL 4.19 2/4] time/sched_clock: Round the frequency reported to nearest rather than down
Date:   Sun,  5 Jun 2022 09:55:12 -0400
Message-Id: <20220605135519.61765-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220605135519.61765-1-sashal@kernel.org>
References: <20220605135519.61765-1-sashal@kernel.org>
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
index 78eb05aa8003..dc1fe853a3f4 100644
--- a/kernel/time/sched_clock.c
+++ b/kernel/time/sched_clock.c
@@ -11,6 +11,7 @@
 #include <linux/jiffies.h>
 #include <linux/ktime.h>
 #include <linux/kernel.h>
+#include <linux/math.h>
 #include <linux/moduleparam.h>
 #include <linux/sched.h>
 #include <linux/sched/clock.h>
@@ -213,11 +214,11 @@ sched_clock_register(u64 (*read)(void), int bits, unsigned long rate)
 
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

