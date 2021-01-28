Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6375F307CA1
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 18:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232950AbhA1Reb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 12:34:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:51656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232977AbhA1RPw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 Jan 2021 12:15:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A193564E19;
        Thu, 28 Jan 2021 17:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611853965;
        bh=PV50oQmb0/DEI/hwnFr8KpZvz4yzyu6dKKE8d3QcwXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iNNOjOUsowdJ6KkWY8r31sAslmssxajMdPJ3EIz/OXcRtkm3g8XMn/08YFpQ3LDhr
         Y+hzJZvJaR1tj2MRlB1S8wQXJrM/+4HCjSjqlS4IUuVjHcWACsGX7zjb/Iy6xYSPTV
         X0gipE5A8sa2KyqE78VS5zPES1D0t7/n+UGm+TMnkZXTbSkLIPs5bPYod/IAInlXOo
         xejkyJJHlWSmuXAaW1k/+i2igR+IOBfMDJ5sItzInTPcvS0++p5ghbYoKot8dgPJJq
         uPEv3qBhuSQ0HcZfXsZ4C8sklW4S3oRuPv9ME4p77dejcZB8Y3Jv2mLrA6BChw+Gtb
         6zHovF/2xD6MQ==
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
Subject: [PATCH 07/16] rcu/nocb: Rename nocb_gp_update_state to nocb_gp_update_state_deoffloading
Date:   Thu, 28 Jan 2021 18:12:13 +0100
Message-Id: <20210128171222.131380-8-frederic@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210128171222.131380-1-frederic@kernel.org>
References: <20210128171222.131380-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Unconfuse a bit the name of this function which suggests returning true
when the state is updated. It actually returns true when the rdp is in
the process of deoffloading and we must ignore it.

Reported-by: Paul E. McKenney <paulmck@kernel.org>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Neeraj Upadhyay <neeraju@codeaurora.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 kernel/rcu/tree_plugin.h | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 53ff99a18ab1..86c3bcceede6 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2026,7 +2026,8 @@ static inline bool nocb_gp_enabled_cb(struct rcu_data *rdp)
 	return rcu_segcblist_test_flags(&rdp->cblist, flags);
 }
 
-static inline bool nocb_gp_update_state(struct rcu_data *rdp, bool *needwake_state)
+static inline bool nocb_gp_update_state_deoffloading(struct rcu_data *rdp,
+						     bool *needwake_state)
 {
 	struct rcu_segcblist *cblist = &rdp->cblist;
 
@@ -2036,7 +2037,7 @@ static inline bool nocb_gp_update_state(struct rcu_data *rdp, bool *needwake_sta
 			if (rcu_segcblist_test_flags(cblist, SEGCBLIST_KTHREAD_CB))
 				*needwake_state = true;
 		}
-		return true;
+		return false;
 	}
 
 	/*
@@ -2047,7 +2048,7 @@ static inline bool nocb_gp_update_state(struct rcu_data *rdp, bool *needwake_sta
 	rcu_segcblist_clear_flags(cblist, SEGCBLIST_KTHREAD_GP);
 	if (!rcu_segcblist_test_flags(cblist, SEGCBLIST_KTHREAD_CB))
 		*needwake_state = true;
-	return false;
+	return true;
 }
 
 
@@ -2085,7 +2086,7 @@ static void nocb_gp_wait(struct rcu_data *my_rdp)
 			continue;
 		trace_rcu_nocb_wake(rcu_state.name, rdp->cpu, TPS("Check"));
 		rcu_nocb_lock_irqsave(rdp, flags);
-		if (!nocb_gp_update_state(rdp, &needwake_state)) {
+		if (nocb_gp_update_state_deoffloading(rdp, &needwake_state)) {
 			rcu_nocb_unlock_irqrestore(rdp, flags);
 			if (needwake_state)
 				swake_up_one(&rdp->nocb_state_wq);
-- 
2.25.1

