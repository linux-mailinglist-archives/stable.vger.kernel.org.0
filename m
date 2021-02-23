Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4670A322302
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 01:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232007AbhBWAMB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 19:12:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:57984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231985AbhBWALq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 19:11:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C2C064E6B;
        Tue, 23 Feb 2021 00:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614039045;
        bh=UHYzx2TIfTFTCeB6LccMdvDKP2NcRtZDp11UlSXWfGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pX07jZM5qdUeP7As41Av4AI/qHTjl1ZuhiV0MQvCW3uVI/4z3saAAwOnPWutchBYt
         xTlzivz2AdLrHuolOMky6qCnuK6TPZjhieDVhzAGqqj2M6Yihp8FRYZeeVcVuAjZ8+
         Eb6qVs+MSdXhvQBdX8ezIJbfj6/YFTlVHvQ4B/vXHR4LA9dCCXi9Yaw0siQqjFlE0S
         1r7e/Hy+1tOYsY9vhzp8AG9/Ces10cUR6hrxRrBbUovFtRV/ejdl5Qr3n+xm3lcT18
         X04d7u/okq5lgMFvze6yFNLmEW7lcooXwQYGWH45NFKyJvVD6tHN2AYMP5cnTJ/DB/
         6PWFRCSY7hp6Q==
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
Subject: [PATCH 11/13] rcu/nocb: Only cancel nocb timer if not polling
Date:   Tue, 23 Feb 2021 01:10:09 +0100
Message-Id: <20210223001011.127063-12-frederic@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210223001011.127063-1-frederic@kernel.org>
References: <20210223001011.127063-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

No need to disarm the nocb_timer if rcu_nocb is polling because it
shouldn't be armed either.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Neeraj Upadhyay <neeraju@codeaurora.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
---
 kernel/rcu/tree_plugin.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 9da67b0d3997..d8b50ff40e4b 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2186,18 +2186,18 @@ static void nocb_gp_wait(struct rcu_data *my_rdp)
 	my_rdp->nocb_gp_gp = needwait_gp;
 	my_rdp->nocb_gp_seq = needwait_gp ? wait_gp_seq : 0;
 	if (bypass) {
-		raw_spin_lock_irqsave(&my_rdp->nocb_gp_lock, flags);
-		// Avoid race with first bypass CB.
-		if (my_rdp->nocb_defer_wakeup > RCU_NOCB_WAKE_NOT) {
-			WRITE_ONCE(my_rdp->nocb_defer_wakeup, RCU_NOCB_WAKE_NOT);
-			del_timer(&my_rdp->nocb_timer);
-		}
 		if (!rcu_nocb_poll) {
+			raw_spin_lock_irqsave(&my_rdp->nocb_gp_lock, flags);
+			// Avoid race with first bypass CB.
+			if (my_rdp->nocb_defer_wakeup > RCU_NOCB_WAKE_NOT) {
+				WRITE_ONCE(my_rdp->nocb_defer_wakeup, RCU_NOCB_WAKE_NOT);
+				del_timer(&my_rdp->nocb_timer);
+			}
 			// At least one child with non-empty ->nocb_bypass, so set
 			// timer in order to avoid stranding its callbacks.
 			mod_timer(&my_rdp->nocb_bypass_timer, j + 2);
+			raw_spin_unlock_irqrestore(&my_rdp->nocb_gp_lock, flags);
 		}
-		raw_spin_unlock_irqrestore(&my_rdp->nocb_gp_lock, flags);
 	}
 	if (rcu_nocb_poll) {
 		/* Polling, so trace if first poll in the series. */
-- 
2.25.1

