Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC0CC2E9A6A
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:13:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727902AbhADQJW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:09:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:38782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728591AbhADQB3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 11:01:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC6C721D93;
        Mon,  4 Jan 2021 16:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609776049;
        bh=lnVSXdFmehZrpQWUW6F5loKkRCcy5WSEoMPQzN5Nx7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JJRabLpXPqyxbGnQApTwrAebzRobBwKD/QwPCxyVspoTvjHQamH57yN69bjKD5vhQ
         BSRLQuT/f/teruEAnwIZZ/y8sqZPyf8ZfLcJuM0DkveJlfymBcmTBa56oNE56DMjZH
         EswUWD8KU7EimqZU+wGyBBL4vFyZSAPPo7CNa330=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <frederic@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 45/47] tick/sched: Remove bogus boot "safety" check
Date:   Mon,  4 Jan 2021 16:57:44 +0100
Message-Id: <20210104155707.907106131@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155705.740576914@linuxfoundation.org>
References: <20210104155705.740576914@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



