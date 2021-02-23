Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAEFA3222FC
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 01:14:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbhBWALn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 19:11:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:57974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231951AbhBWALj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 19:11:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A51C64E5C;
        Tue, 23 Feb 2021 00:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614039032;
        bh=g0q9LRexy8H6IBvAIs7Jmz8PDL+JiYECTuHr6cLodC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qxHBPxGXMbanQFccmhWM3FcvwuaZGnQuZzmOeUCP1F8xWnKB2iN6v0yZhPAS9hx7B
         C4BVDuiUZX2dc1/MN4M9zkVnDlVJsGd1llG7N1XHpyZ9O6GI8X3Uk3tA/18C6WgONk
         byMs/9D1r0QpZ6vhoyiceiiJjwH5/VrIm8BLYwj6sirA+cGnesS7rYfzyFsmeAZ1h3
         pZfaQShKrELaaBlUdA2d+00r4MavrLFTmQsm8S4LG1pDBOE3os8NorPAtgEu28Htnp
         fFqc0yDTu5jzCiVdRF76Xa0nFB3bM1HajupckFE/AZC/YSQSgWzePfLM1+pBjjkUZ0
         aE3sL0Gs+yFKQ==
From:   Frederic Weisbecker <frederic@kernel.org>
To:     "Paul E . McKenney" <paulmck@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Boqun Feng <boqun.feng@gmail.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Neeraj Upadhyay <neeraju@codeaurora.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Stable <stable@vger.kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>
Subject: [PATCH 06/13] timer: Revert "timer: Add timer_curr_running()"
Date:   Tue, 23 Feb 2021 01:10:04 +0100
Message-Id: <20210223001011.127063-7-frederic@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210223001011.127063-1-frederic@kernel.org>
References: <20210223001011.127063-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit dcd42591ebb8a25895b551a5297ea9c24414ba54.
The only user was RCU/nocb.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Neeraj Upadhyay <neeraju@codeaurora.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/timer.h |  2 --
 kernel/time/timer.c   | 14 --------------
 2 files changed, 16 deletions(-)

diff --git a/include/linux/timer.h b/include/linux/timer.h
index 4118a97e62fb..fda13c9d1256 100644
--- a/include/linux/timer.h
+++ b/include/linux/timer.h
@@ -192,8 +192,6 @@ extern int try_to_del_timer_sync(struct timer_list *timer);
 
 #define del_singleshot_timer_sync(t) del_timer_sync(t)
 
-extern bool timer_curr_running(struct timer_list *timer);
-
 extern void init_timers(void);
 struct hrtimer;
 extern enum hrtimer_restart it_real_fn(struct hrtimer *);
diff --git a/kernel/time/timer.c b/kernel/time/timer.c
index f475f1a027c8..8dbc008f8942 100644
--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -1237,20 +1237,6 @@ int try_to_del_timer_sync(struct timer_list *timer)
 }
 EXPORT_SYMBOL(try_to_del_timer_sync);
 
-bool timer_curr_running(struct timer_list *timer)
-{
-	int i;
-
-	for (i = 0; i < NR_BASES; i++) {
-		struct timer_base *base = this_cpu_ptr(&timer_bases[i]);
-
-		if (base->running_timer == timer)
-			return true;
-	}
-
-	return false;
-}
-
 #ifdef CONFIG_PREEMPT_RT
 static __init void timer_base_init_expiry_lock(struct timer_base *base)
 {
-- 
2.25.1

