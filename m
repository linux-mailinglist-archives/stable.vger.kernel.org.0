Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E93813222F7
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 01:11:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231605AbhBWALL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 19:11:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:57628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231228AbhBWALI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 19:11:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B04964E4A;
        Tue, 23 Feb 2021 00:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614039027;
        bh=+xHRpZfRZlMH4BcSafsfZN/+p8jTkcZfN6LHiFtt/Ek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qzdqni6xyRNYGzF+VkZAyEV2qBKZNlOZb7K8fudbu8aBkrjOUIBbl/4xbMrdBJTFN
         godX+6AqeHGDnHMjANxpdCygoGLvVPGNyReUbW5D/wgVBiVaisPGGRrD4pqQJCBEpZ
         w4c75Fk41+mmFkbuN/8OKyxnE6JqSmXm1ZZNUos2VUrvM5gQbxSTBb6WC7wDkMzXPi
         7r7IK89SyTsUTkftpF20PlQEVfWT9vyp2mCXsBQmEqWEPY7Niyi3CkplYITN9BqQfk
         FwaSJFiqP093NjRE39Wjw6uQsHYjqA3EuWlBXZwwm1jTNOJKoGKIxEVE7caMisMbwE
         LxRe3QC/dnebA==
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
Subject: [PATCH 04/13] rcu/nocb: Move trace_rcu_nocb_wake() calls outside nocb_lock when possible
Date:   Tue, 23 Feb 2021 01:10:02 +0100
Message-Id: <20210223001011.127063-5-frederic@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210223001011.127063-1-frederic@kernel.org>
References: <20210223001011.127063-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Those tracing calls don't need to be under the nocb lock. Move them
outside.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Neeraj Upadhyay <neeraju@codeaurora.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
---
 kernel/rcu/tree_plugin.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 924fa3d1df0d..587df271d640 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -1715,9 +1715,9 @@ static bool wake_nocb_gp(struct rcu_data *rdp, bool force,
 
 	lockdep_assert_held(&rdp->nocb_lock);
 	if (!READ_ONCE(rdp_gp->nocb_gp_kthread)) {
+		rcu_nocb_unlock_irqrestore(rdp, flags);
 		trace_rcu_nocb_wake(rcu_state.name, rdp->cpu,
 				    TPS("AlreadyAwake"));
-		rcu_nocb_unlock_irqrestore(rdp, flags);
 		return false;
 	}
 
@@ -1967,9 +1967,9 @@ static void __call_rcu_nocb_wake(struct rcu_data *rdp, bool was_alldone,
 	// If we are being polled or there is no kthread, just leave.
 	t = READ_ONCE(rdp->nocb_gp_kthread);
 	if (rcu_nocb_poll || !t) {
+		rcu_nocb_unlock_irqrestore(rdp, flags);
 		trace_rcu_nocb_wake(rcu_state.name, rdp->cpu,
 				    TPS("WakeNotPoll"));
-		rcu_nocb_unlock_irqrestore(rdp, flags);
 		return;
 	}
 	// Need to actually to a wakeup.
@@ -2004,8 +2004,8 @@ static void __call_rcu_nocb_wake(struct rcu_data *rdp, bool was_alldone,
 					   TPS("WakeOvfIsDeferred"));
 		rcu_nocb_unlock_irqrestore(rdp, flags);
 	} else {
+		rcu_nocb_unlock_irqrestore(rdp, flags);
 		trace_rcu_nocb_wake(rcu_state.name, rdp->cpu, TPS("WakeNot"));
-		rcu_nocb_unlock_irqrestore(rdp, flags);
 	}
 	return;
 }
-- 
2.25.1

