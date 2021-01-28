Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72B18307CC2
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 18:42:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233101AbhA1RhJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 12:37:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:51654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232975AbhA1RPv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 Jan 2021 12:15:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1410A64E17;
        Thu, 28 Jan 2021 17:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611853968;
        bh=Pc2PWEMkka3xOHgiMFiU+fKJXRO2FfKG+02M0y/azS4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tc7fodaXCP4WtMVQK4cmL3kTPyPeqYuzC2OSksNO6AVlJwwVQsJFGGjFr4LfRNUzA
         YiCmZMzI2/6b+JeKXMGc5D6fqK6QP0Ju6CLDgzArfh/c15beivuE9iETh4v2fF0TxZ
         Kev3KOXwWNfWaf/PkcGIZhJn2qNroIMHxQMt7N3XHxfEl7Sf7T2zy9NlhI4crUlUiz
         JbSHovJtR6g7D0ucPXtwozW8j8ovzgkC0nt9qLipW369uC1mSli761l6Pr05UZj4JF
         tx3EEFx4NekyJmJpyCcz90nH6Ad5KmfGCmJ3FFdzw3TLGnLyfa57i8NvOYnPYJkGCQ
         qzV/Y0VmeE1iQ==
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
Subject: [PATCH 08/16] rcu/nocb: Move trace_rcu_nocb_wake() calls outside nocb_lock when possible
Date:   Thu, 28 Jan 2021 18:12:14 +0100
Message-Id: <20210128171222.131380-9-frederic@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210128171222.131380-1-frederic@kernel.org>
References: <20210128171222.131380-1-frederic@kernel.org>
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
index 86c3bcceede6..8c5fea58ee80 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -1700,9 +1700,9 @@ static bool wake_nocb_gp(struct rcu_data *rdp, bool force,
 
 	lockdep_assert_held(&rdp->nocb_lock);
 	if (!READ_ONCE(rdp_gp->nocb_gp_kthread)) {
+		rcu_nocb_unlock_irqrestore(rdp, flags);
 		trace_rcu_nocb_wake(rcu_state.name, rdp->cpu,
 				    TPS("AlreadyAwake"));
-		rcu_nocb_unlock_irqrestore(rdp, flags);
 		return false;
 	}
 
@@ -1950,9 +1950,9 @@ static void __call_rcu_nocb_wake(struct rcu_data *rdp, bool was_alldone,
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
@@ -1987,8 +1987,8 @@ static void __call_rcu_nocb_wake(struct rcu_data *rdp, bool was_alldone,
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

