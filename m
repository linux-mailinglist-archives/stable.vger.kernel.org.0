Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23C0D2E796C
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 14:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727569AbgL3NJP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 08:09:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:53388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727359AbgL3NFM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Dec 2020 08:05:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18C6E2256F;
        Wed, 30 Dec 2020 13:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609333458;
        bh=lnVSXdFmehZrpQWUW6F5loKkRCcy5WSEoMPQzN5Nx7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ffZjZQtkxSzEvA9U7gRV53i4oDx+KNuKwwFQaw4Uy7z9csu8dJFRQhivPtLYEUFDf
         NTBsmLIv4VbVe21ntommMnEf6//lwHsTOOtUVfrPuqc93YosPmxW+3YLXnELMHaOu/
         J6tlMTpok6hXHrjuek5dED7kUHk9Ziwc1w5HwvYNYCgE/JvNwoybClMDbTMQbySqcV
         9Y2YJv5hhj2uTYboOdd6jX+92AJ52Nvd83yjbJ9yd8IDntBTGgO0a468eMaGRd7iAJ
         TKCYDPNnUD9EiFCdIEwO1eHYxA2f4a11fLPB73TJ1SantawNh/6Dmwe21194t0U6s7
         tc6NFGopZMv2w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <frederic@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 15/17] tick/sched: Remove bogus boot "safety" check
Date:   Wed, 30 Dec 2020 08:03:55 -0500
Message-Id: <20201230130357.3637261-15-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201230130357.3637261-1-sashal@kernel.org>
References: <20201230130357.3637261-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit ba8ea8e7dd6e1662e34e730eadfc52aa6816f9dd ]

can_stop_idle_tick() checks whether the do_timer() duty has been taken over
by a CPU on boot. That's silly because the boot CPU always takes over with
the initial clockevent device.

But even if no CPU would have installed a clockevent and taken over the
duty then the question whether the tick on the current CPU can be stopped
or not is moot. In that case the current CPU would have no clockevent
either, so there would be nothing to keep ticking.

Remove it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Frederic Weisbecker <frederic@kernel.org>
Link: https://lore.kernel.org/r/20201206212002.725238293@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/tick-sched.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 5c9fcc72460df..4419486d7413c 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -916,13 +916,6 @@ static bool can_stop_idle_tick(int cpu, struct tick_sched *ts)
 		 */
 		if (tick_do_timer_cpu == cpu)
 			return false;
-		/*
-		 * Boot safety: make sure the timekeeping duty has been
-		 * assigned before entering dyntick-idle mode,
-		 * tick_do_timer_cpu is TICK_DO_TIMER_BOOT
-		 */
-		if (unlikely(tick_do_timer_cpu == TICK_DO_TIMER_BOOT))
-			return false;
 
 		/* Should not happen for nohz-full */
 		if (WARN_ON_ONCE(tick_do_timer_cpu == TICK_DO_TIMER_NONE))
-- 
2.27.0

