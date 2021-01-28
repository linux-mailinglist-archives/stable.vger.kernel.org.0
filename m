Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D51F5307C13
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 18:19:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232865AbhA1RSP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 12:18:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:51672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232993AbhA1RP7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 Jan 2021 12:15:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1404564E1F;
        Thu, 28 Jan 2021 17:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611853983;
        bh=jQeZCnPN9j/W0WVygyqTn9xlZJYBWTOBtC7NRzabw8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J/KzzQV5ce2TNoymsoBO1iTBrDgII+lGZCFbXDiEp8zVoi3p+oIY0Tt+NMrWBmnQq
         To+9NAI3aAKb1vu8K5Iyd2M0vnjpiE+1qbJSf8t8W0kUd3N4XeOQrdgNomzGA4fb4r
         i5KBjuYHDJi15powF8kfM/HuQkKoyO0fCy2bbkpMxhi0hjcA77LqAeCewYDc84MQsO
         hhsrZSD9NxDH/sa7mvPWbAeQd5GOSYNLBVuCXjG9NUE+Mbt95Vf6ENrXG30J8e5D/8
         RSkhptfZyItNNfbb01PB0KYWdKT1eUmKKw5UGcWnGsdCsPqpKjJ5Gp9jRY1zl5dP0r
         Oim3hlkqiaKlg==
From:   Frederic Weisbecker <frederic@kernel.org>
To:     "Paul E . McKenney" <paulmck@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Neeraj Upadhyay <neeraju@codeaurora.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Stable <stable@vger.kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>
Subject: [PATCH 14/16] rcu/nocb: Only cancel nocb timer if not polling
Date:   Thu, 28 Jan 2021 18:12:20 +0100
Message-Id: <20210128171222.131380-15-frederic@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210128171222.131380-1-frederic@kernel.org>
References: <20210128171222.131380-1-frederic@kernel.org>
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
 kernel/rcu/tree_plugin.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index eb8614577a2c..b1f76f341c66 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2178,16 +2178,16 @@ static void nocb_gp_wait(struct rcu_data *my_rdp)
 	my_rdp->nocb_gp_gp = needwait_gp;
 	my_rdp->nocb_gp_seq = needwait_gp ? wait_gp_seq : 0;
 	if (bypass) {
-		raw_spin_lock_irqsave(&my_rdp->nocb_gp_lock, flags);
-		// Avoid race with first bypass CB.
-		WRITE_ONCE(my_rdp->nocb_defer_wakeup, RCU_NOCB_WAKE_NOT);
-		del_timer(&my_rdp->nocb_timer);
 		if (!rcu_nocb_poll) {
+			raw_spin_lock_irqsave(&my_rdp->nocb_gp_lock, flags);
+			// Avoid race with first bypass CB.
+			WRITE_ONCE(my_rdp->nocb_defer_wakeup, RCU_NOCB_WAKE_NOT);
+			del_timer(&my_rdp->nocb_timer);
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

