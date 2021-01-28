Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03AF23080AC
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 22:44:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbhA1Vng (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 16:43:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:36356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229819AbhA1VnJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 Jan 2021 16:43:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A6D464DEC;
        Thu, 28 Jan 2021 21:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611870144;
        bh=SHLJyAHDIysCZy7SQeVx7WntvL4hQVTViya4xyAtYxM=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=FCTRu0KLSSG05rACSyXH8rVKxWR9f+AbvXeC09bb+YpzjeKpjBwXwAqFBpfusaeuR
         HRrNlCLXr3WB2Mh+Mm0t+KpqBzsajLoYBBuMCf8sQ5z/AhEgn6CI6z5RShUXJ9bzCz
         mAGxbwiXXnb0viZc9L5bJDIKNuOKNkIbBhUHlDsKFe8fix3KGFmRaFEzOSUsfIq+fm
         SZ6B+uKOEDXkHghaUQgk0CE2JFA2iJsQtKsDLxZ23gykaDDyAIdjjBWHXPS1R4scX/
         +v41mqBk7WFt9dpMqXb9rSWWCWsE/vZmgeQGhY8004n/N89KKx3McuiTECD0v0XUpm
         4G7T0GfbscRjQ==
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id D805F35237A0; Thu, 28 Jan 2021 13:42:23 -0800 (PST)
Date:   Thu, 28 Jan 2021 13:42:23 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Frederic Weisbecker <frederic@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Neeraj Upadhyay <neeraju@codeaurora.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Stable <stable@vger.kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH 06/16] rcu/nocb: Avoid confusing double write of
 rdp->nocb_cb_sleep
Message-ID: <20210128214223.GU2743@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20210128171222.131380-1-frederic@kernel.org>
 <20210128171222.131380-7-frederic@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210128171222.131380-7-frederic@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 28, 2021 at 06:12:12PM +0100, Frederic Weisbecker wrote:
> rdp->nocb_cb_sleep is first set to true by default after processing
> the callbacks then set back to false if we still find ready callbacks
> to invoke.
> 
> This is confusing and even unsafe if it ever happens to be read
> locklessly at some point. So make sure we write it only once per
> nocb_cb_wait() loop.
> 
> Reported-by: Paul E. McKenney <paulmck@kernel.org>
> Cc: Josh Triplett <josh@joshtriplett.org>
> Cc: Lai Jiangshan <jiangshanlai@gmail.com>
> Cc: Joel Fernandes <joel@joelfernandes.org>
> Cc: Neeraj Upadhyay <neeraju@codeaurora.org>
> Cc: Boqun Feng <boqun.feng@gmail.com>
> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>

Nice, queued, thank you!  The usual wordsmithing &c...

							Thanx, Paul

------------------------------------------------------------------------

commit cbc3fbfe8424edc90668d5878eb493ae2ff1b888
Author: Frederic Weisbecker <frederic@kernel.org>
Date:   Thu Jan 28 18:12:12 2021 +0100

    rcu/nocb: Avoid confusing double write of rdp->nocb_cb_sleep
    
    The nocb_cb_wait() function first sets the rdp->nocb_cb_sleep flag to
    true by after invoking the callbacks, and then sets it back to false if
    it finds more callbacks that are ready to invoke.
    
    This is confusing and will become unsafe if this flag is ever read
    locklessly.  This commit therefore writes it only once, based on the
    state after both callback invocation and checking.
    
    Reported-by: Paul E. McKenney <paulmck@kernel.org>
    Cc: Josh Triplett <josh@joshtriplett.org>
    Cc: Lai Jiangshan <jiangshanlai@gmail.com>
    Cc: Joel Fernandes <joel@joelfernandes.org>
    Cc: Neeraj Upadhyay <neeraju@codeaurora.org>
    Cc: Boqun Feng <boqun.feng@gmail.com>
    Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
    Signed-off-by: Paul E. McKenney <paulmck@kernel.org>

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index c61613a..a3db700 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2229,6 +2229,7 @@ static void nocb_cb_wait(struct rcu_data *rdp)
 	unsigned long flags;
 	bool needwake_state = false;
 	bool needwake_gp = false;
+	bool can_sleep = true;
 	struct rcu_node *rnp = rdp->mynode;
 
 	local_irq_save(flags);
@@ -2252,8 +2253,6 @@ static void nocb_cb_wait(struct rcu_data *rdp)
 		raw_spin_unlock_rcu_node(rnp); /* irqs remain disabled. */
 	}
 
-	WRITE_ONCE(rdp->nocb_cb_sleep, true);
-
 	if (rcu_segcblist_test_flags(cblist, SEGCBLIST_OFFLOADED)) {
 		if (!rcu_segcblist_test_flags(cblist, SEGCBLIST_KTHREAD_CB)) {
 			rcu_segcblist_set_flags(cblist, SEGCBLIST_KTHREAD_CB);
@@ -2261,7 +2260,7 @@ static void nocb_cb_wait(struct rcu_data *rdp)
 				needwake_state = true;
 		}
 		if (rcu_segcblist_ready_cbs(cblist))
-			WRITE_ONCE(rdp->nocb_cb_sleep, false);
+			can_sleep = false;
 	} else {
 		/*
 		 * De-offloading. Clear our flag and notify the de-offload worker.
@@ -2274,6 +2273,8 @@ static void nocb_cb_wait(struct rcu_data *rdp)
 			needwake_state = true;
 	}
 
+	WRITE_ONCE(rdp->nocb_cb_sleep, can_sleep);
+
 	if (rdp->nocb_cb_sleep)
 		trace_rcu_nocb_wake(rcu_state.name, rdp->cpu, TPS("CBSleep"));
 
