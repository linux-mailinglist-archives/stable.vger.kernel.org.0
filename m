Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCF533222FF
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 01:14:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231997AbhBWALr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 19:11:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:57976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231972AbhBWALl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 19:11:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 203C964E62;
        Tue, 23 Feb 2021 00:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614039035;
        bh=ELih/SPtMdv+yXWE7FNjvy62unjN5/KdJbWzbWLuT0g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BsQf70hPZgSTMNGkSM0ulARjNkVo7Rx1EsjAwGT4H6SoERDssQHy7FdkRzeSUMaje
         vk+mdkYf0vPOa19LoYZZneCRPEwMA6wA1AYs08HEnqzD5UTNYrsR7IrlIketEmwodX
         pcF6OOrrSgNEVZEZkIXFapmiiBl1DZphnKdjKeXW9vvNWSo/tvUIb6E+YhBMz107R0
         85RDA0FYR6wSSAS+f4X1jMYH9kqrvl3zAtNUCQsfq27bR5ajzJ1JVFVYZWBpCnx5H4
         q59Rfbnaxv6u4Oyn2cC6+kKQES8/Pr4/MNOhizI2DXQVywgCnoGLEtcm1snI6TX9y7
         ju7YVh8i6znvg==
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
Subject: [PATCH 07/13] rcu/nocb: Directly call __wake_nocb_gp() from bypass timer
Date:   Tue, 23 Feb 2021 01:10:05 +0100
Message-Id: <20210223001011.127063-8-frederic@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210223001011.127063-1-frederic@kernel.org>
References: <20210223001011.127063-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The bypass timer calls __call_rcu_nocb_wake() instead of directly
calling __wake_nocb_gp(). The only difference here is that
rdp->qlen_last_fqs_check gets overriden. But resetting the deferred
force quiescent state base shouldn't be relevant for that timer. In fact
the bypass queue in concern can be for any rdp from the group and not
necessarily the rdp leader on which the bypass timer is attached.

Therefore we can simply call directly __wake_nocb_gp(). This way we
don't even need to lock the nocb_lock.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Neeraj Upadhyay <neeraju@codeaurora.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
---
 kernel/rcu/tree_plugin.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 847636d3e93d..c80b214a86bb 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2025,9 +2025,10 @@ static void do_nocb_bypass_wakeup_timer(struct timer_list *t)
 	struct rcu_data *rdp = from_timer(rdp, t, nocb_bypass_timer);
 
 	trace_rcu_nocb_wake(rcu_state.name, rdp->cpu, TPS("Timer"));
-	rcu_nocb_lock_irqsave(rdp, flags);
+
+	raw_spin_lock_irqsave(&rdp->nocb_gp_lock, flags);
 	smp_mb__after_spinlock(); /* Timer expire before wakeup. */
-	__call_rcu_nocb_wake(rdp, true, flags);
+	__wake_nocb_gp(rdp, rdp, false, flags);
 }
 
 /*
-- 
2.25.1

