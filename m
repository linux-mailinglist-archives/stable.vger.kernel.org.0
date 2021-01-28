Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63070307CE7
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 18:48:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231565AbhA1Rpc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 12:45:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:50706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232907AbhA1RNL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 Jan 2021 12:13:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D003364DA1;
        Thu, 28 Jan 2021 17:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611853950;
        bh=cq5sMnnB4o21sAGO6NvpflGtFMDv/E4aEyoYLtoC3Go=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tjlOh4EUarzxHu7RW2y8mQtwd18aXvB8N136E3tPyo6E3/ZX/Wn8nhD/I8m6XTcSv
         MO4K9GeyLjXk32BUohdQqG0LziiHweAhye6To6Rwp7ZhfkqZap3gZwxyURYlZXQJqT
         +wGtBt7MwC+mI+teydnD9Sk5Cr5HachbY3SaxpebqfbBZ6VYQx8oMK1WriclUlAvI9
         IesC8hkQXA/YRvdT4YX+MTGDdoSA5XBBndMTzC6L+1X4/SpnORxjikYMirFkICNgTk
         9v6z6SCXdq8lQ45Ps5qvvHpx9V7KUSKrGuHuimAVCUpvhwo+fhXvrJm1DkivhZft3L
         jnPKvcuqPv/kw==
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
Subject: [PATCH 01/16] rcu/nocb: Fix potential missed nocb_timer rearm
Date:   Thu, 28 Jan 2021 18:12:07 +0100
Message-Id: <20210128171222.131380-2-frederic@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210128171222.131380-1-frederic@kernel.org>
References: <20210128171222.131380-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The "nocb_bypass_timer" ends up calling wake_nocb_gp() which deletes
the pending "nocb_timer" (note they are not the same timers) for the
given rdp without resetting the matching state stored in nocb_defer
wakeup.

As a result, a future call_rcu() on that rdp may be fooled and think the
timer is armed when it's not, missing a deferred nocb_gp wakeup.

Fix this with resetting rdp->nocb_defer_wakeup when we disarm the timer.

Fixes: d1b222c6be1f (rcu/nocb: Add bypass callback queueing)
Cc: Stable <stable@vger.kernel.org>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Neeraj Upadhyay <neeraju@codeaurora.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 kernel/rcu/tree_plugin.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 7e33dae0e6ee..a44f80d7661b 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -1705,6 +1705,8 @@ static bool wake_nocb_gp(struct rcu_data *rdp, bool force,
 		rcu_nocb_unlock_irqrestore(rdp, flags);
 		return false;
 	}
+
+	rdp->nocb_defer_wakeup = RCU_NOCB_WAKE_NOT;
 	del_timer(&rdp->nocb_timer);
 	rcu_nocb_unlock_irqrestore(rdp, flags);
 	raw_spin_lock_irqsave(&rdp_gp->nocb_gp_lock, flags);
-- 
2.25.1

