Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC663307CA0
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 18:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232798AbhA1Rea (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 12:34:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:51662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232986AbhA1RPy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 Jan 2021 12:15:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 389AB64E15;
        Thu, 28 Jan 2021 17:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611853973;
        bh=fhusc1wuTqLzOxUdIHskj1dqwbyC6LdZg87VOwYou5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R8KymZX+ZXUTSbxthj7PdBL4sVRgIo6EVTVhFspL+Sjl+GGado6OZypH6Hn1kvUwM
         LcQXnlLQKQ7/tHgUVPnr4JglwekLv7ua0P3pXVtdCzXRpH3GUem1QMOZGrEvO8tCDn
         JM/wiCBx2+MQqUUp+VvxIzXD/1rRAtiNOiKs74fpQFsO1q0EVMQEhLw0A4J/bqS+v0
         lad5BKIlyL1qYePsxMgKLqAgchdRGtjDIXs3w3a/nKrnWAEliPUnEqXSMyIY0tAWm5
         cya5cdpFAKSBxhEtkAtJjPWjtLLS/k+hKz84mIcGZAuQZINLovnwpaj80MAt0IBkh6
         tCcgZgGNYhM2g==
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
Subject: [PATCH 10/16] rcu/nocb: Directly call __wake_nocb_gp() from bypass timer
Date:   Thu, 28 Jan 2021 18:12:16 +0100
Message-Id: <20210128171222.131380-11-frederic@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210128171222.131380-1-frederic@kernel.org>
References: <20210128171222.131380-1-frederic@kernel.org>
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
index 5e83ea380bec..28ace1ae83d6 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2018,9 +2018,10 @@ static void do_nocb_bypass_wakeup_timer(struct timer_list *t)
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

