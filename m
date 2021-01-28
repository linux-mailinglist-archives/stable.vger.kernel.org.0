Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68B30307CB0
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 18:39:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233096AbhA1RhH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 12:37:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:51652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232974AbhA1RPv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 Jan 2021 12:15:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A05064E1B;
        Thu, 28 Jan 2021 17:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611853963;
        bh=bTs7fd9i7Q6EclAKoUqBlqgbfCLJr2JGhkdqDWXc740=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ryjv06uP8xyKVxe8s0CbEyE6i9W/5FAcOJ1/AxGghd+c6i4kv6gdYK5hiuHqP5sx9
         A1wT1TqdkP7HFV2ZCH3w+jY68tS1MX/uMHeKZZqTyEhqbjCAWHa2oXi6deC+eLQjX5
         I6EeRrPtFJEfG3Zh8KmGfFQxxg/BUmGVKP7J8SSminlVXHonmMsXOiHqhAaJ2MnEMI
         F+sp5ski3tPoyqV0Fp155jS707YOfznVIkrnPvNQhkJ23Yo3Aafd0luQab9AZxfZKK
         EOyw19AXtn884Hq8w6T7ulWkG32hI2hTF/hIBGSBiweEzVR0XUGU1jzisxdBWQe9HR
         itQFLnRmL4A3w==
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
Subject: [PATCH 06/16] rcu/nocb: Avoid confusing double write of rdp->nocb_cb_sleep
Date:   Thu, 28 Jan 2021 18:12:12 +0100
Message-Id: <20210128171222.131380-7-frederic@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210128171222.131380-1-frederic@kernel.org>
References: <20210128171222.131380-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

rdp->nocb_cb_sleep is first set to true by default after processing
the callbacks then set back to false if we still find ready callbacks
to invoke.

This is confusing and even unsafe if it ever happens to be read
locklessly at some point. So make sure we write it only once per
nocb_cb_wait() loop.

Reported-by: Paul E. McKenney <paulmck@kernel.org>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Neeraj Upadhyay <neeraju@codeaurora.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 kernel/rcu/tree_plugin.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 7781830a3cf1..53ff99a18ab1 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2241,6 +2241,7 @@ static void nocb_cb_wait(struct rcu_data *rdp)
 	unsigned long flags;
 	bool needwake_state = false;
 	bool needwake_gp = false;
+	bool can_sleep = true;
 	struct rcu_node *rnp = rdp->mynode;
 
 	local_irq_save(flags);
@@ -2264,8 +2265,6 @@ static void nocb_cb_wait(struct rcu_data *rdp)
 		raw_spin_unlock_rcu_node(rnp); /* irqs remain disabled. */
 	}
 
-	WRITE_ONCE(rdp->nocb_cb_sleep, true);
-
 	if (rcu_segcblist_test_flags(cblist, SEGCBLIST_OFFLOADED)) {
 		if (!rcu_segcblist_test_flags(cblist, SEGCBLIST_KTHREAD_CB)) {
 			rcu_segcblist_set_flags(cblist, SEGCBLIST_KTHREAD_CB);
@@ -2273,7 +2272,7 @@ static void nocb_cb_wait(struct rcu_data *rdp)
 				needwake_state = true;
 		}
 		if (rcu_segcblist_ready_cbs(cblist))
-			WRITE_ONCE(rdp->nocb_cb_sleep, false);
+			can_sleep = false;
 	} else {
 		/*
 		 * De-offloading. Clear our flag and notify the de-offload worker.
@@ -2286,6 +2285,8 @@ static void nocb_cb_wait(struct rcu_data *rdp)
 			needwake_state = true;
 	}
 
+	WRITE_ONCE(rdp->nocb_cb_sleep, can_sleep);
+
 	if (rdp->nocb_cb_sleep)
 		trace_rcu_nocb_wake(rcu_state.name, rdp->cpu, TPS("CBSleep"));
 
-- 
2.25.1

