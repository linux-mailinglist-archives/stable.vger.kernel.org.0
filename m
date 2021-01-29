Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0C063082B6
	for <lists+stable@lfdr.de>; Fri, 29 Jan 2021 01:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbhA2Ave (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 19:51:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:39536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231378AbhA2Au0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 Jan 2021 19:50:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 008BD61481;
        Fri, 29 Jan 2021 00:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611881385;
        bh=zydfLupXKAPApg8smC/QMpzzcHh0Ib/J7FrqIXTF6VA=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=Y73yZecTKjnVfU3LJfP7fKgtZFHBSA1ozeX6mFvxVOV9X66rZQ13IJyQBaYgzLbUp
         eDkbqh8PSdVbFZcOYW43sjxF7dBv61OoNfw84HOxP6NkkUq/gD/y5O9Xs4tYFNWZlc
         nZUv0zSA/9jXKvAEt38RxssAF5BTIrmdmdQO7EBEc3vaaPe+iCdgrGll5xxe+h+pOS
         usOSGDYWYJjPz1jz52OsUcp96I/aLcBbJCP25N2tSc/GP6F5fjEmR/1KL/G/3JgqlV
         UTNohM2U+rAtkrBdBVRy7nI+MFNWfPz1d6qW5cTEyM7cR7xPgNayGxgCFIOldJGqsc
         6EqBoBccXCm3w==
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id C335D35237A0; Thu, 28 Jan 2021 16:49:44 -0800 (PST)
Date:   Thu, 28 Jan 2021 16:49:44 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Frederic Weisbecker <frederic@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Neeraj Upadhyay <neeraju@codeaurora.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Stable <stable@vger.kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH 07/16] rcu/nocb: Rename nocb_gp_update_state to
 nocb_gp_update_state_deoffloading
Message-ID: <20210129004944.GZ2743@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20210128171222.131380-1-frederic@kernel.org>
 <20210128171222.131380-8-frederic@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210128171222.131380-8-frederic@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 28, 2021 at 06:12:13PM +0100, Frederic Weisbecker wrote:
> Unconfuse a bit the name of this function which suggests returning true
> when the state is updated. It actually returns true when the rdp is in
> the process of deoffloading and we must ignore it.
> 
> Reported-by: Paul E. McKenney <paulmck@kernel.org>
> Cc: Josh Triplett <josh@joshtriplett.org>
> Cc: Lai Jiangshan <jiangshanlai@gmail.com>
> Cc: Joel Fernandes <joel@joelfernandes.org>
> Cc: Neeraj Upadhyay <neeraju@codeaurora.org>
> Cc: Boqun Feng <boqun.feng@gmail.com>
> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>

Fair point, thank you!  I have queued this one for further review and
testing, with the usual wordsmithing shown below.

							Thanx, Paul

------------------------------------------------------------------------

commit 142d159f544763140e0f498936bca8f71563e0e0
Author: Frederic Weisbecker <frederic@kernel.org>
Date:   Thu Jan 28 18:12:13 2021 +0100

    rcu/nocb: Rename nocb_gp_update_state to nocb_gp_update_state_deoffloading
    
    The name nocb_gp_update_state() is unenlightening, so this commit changes
    it to nocb_gp_update_state_deoffloading().  This function now does what
    its name says, updates state and returns true if the CPU corresponding to
    the specified rcu_data structure is in the process of being de-offloaded.
    
    Reported-by: Paul E. McKenney <paulmck@kernel.org>
    Cc: Josh Triplett <josh@joshtriplett.org>
    Cc: Lai Jiangshan <jiangshanlai@gmail.com>
    Cc: Joel Fernandes <joel@joelfernandes.org>
    Cc: Neeraj Upadhyay <neeraju@codeaurora.org>
    Cc: Boqun Feng <boqun.feng@gmail.com>
    Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
    Signed-off-by: Paul E. McKenney <paulmck@kernel.org>

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index a3db700..9c0ee82 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2014,7 +2014,8 @@ static inline bool nocb_gp_enabled_cb(struct rcu_data *rdp)
 	return rcu_segcblist_test_flags(&rdp->cblist, flags);
 }
 
-static inline bool nocb_gp_update_state(struct rcu_data *rdp, bool *needwake_state)
+static inline bool nocb_gp_update_state_deoffloading(struct rcu_data *rdp,
+						     bool *needwake_state)
 {
 	struct rcu_segcblist *cblist = &rdp->cblist;
 
@@ -2024,7 +2025,7 @@ static inline bool nocb_gp_update_state(struct rcu_data *rdp, bool *needwake_sta
 			if (rcu_segcblist_test_flags(cblist, SEGCBLIST_KTHREAD_CB))
 				*needwake_state = true;
 		}
-		return true;
+		return false;
 	}
 
 	/*
@@ -2035,7 +2036,7 @@ static inline bool nocb_gp_update_state(struct rcu_data *rdp, bool *needwake_sta
 	rcu_segcblist_clear_flags(cblist, SEGCBLIST_KTHREAD_GP);
 	if (!rcu_segcblist_test_flags(cblist, SEGCBLIST_KTHREAD_CB))
 		*needwake_state = true;
-	return false;
+	return true;
 }
 
 
@@ -2073,7 +2074,7 @@ static void nocb_gp_wait(struct rcu_data *my_rdp)
 			continue;
 		trace_rcu_nocb_wake(rcu_state.name, rdp->cpu, TPS("Check"));
 		rcu_nocb_lock_irqsave(rdp, flags);
-		if (!nocb_gp_update_state(rdp, &needwake_state)) {
+		if (nocb_gp_update_state_deoffloading(rdp, &needwake_state)) {
 			rcu_nocb_unlock_irqrestore(rdp, flags);
 			if (needwake_state)
 				swake_up_one(&rdp->nocb_state_wq);
