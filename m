Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A08932BC05
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 22:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359112AbhCCNg5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 08:36:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:38008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232926AbhCCBXV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 20:23:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 306C964FB4;
        Wed,  3 Mar 2021 01:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614734550;
        bh=uYBqMWEu2cum0jtgCVaXQt5AB4RMzXYdMt4CxTKk0fw=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=Ve9j/TxL2rBLxXwJRfTZy23sV8UIjOVbxxKaUnt4dpCtMxhM86qUgjPJIzt8qSkiq
         Bd0NSV3Qy2C7Zzb0B4qJh/YFO+LuKyFxuojHv4T6TlkyLkNmGJ5byjqOxBdAl8g9Ja
         emOZpQpoaNOez4/w/dg8MKBNh0vCrZiMY1iakKG+B7CZgFafrWQW4GnuDbOhHQFkL0
         tY5S9xox+rgRFIeSWUEjVvkwTgVNglXAZ3T5UYEXmZB4Pv82WDVsZAwk7KSJWZErpk
         POoEEkC3TFHH73KlN1TlRPhBqbavw2x9ayBfYGvcZJ2VjICDBIdl66Ru5QAl+HFPfG
         d3gFcHbvanR1Q==
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id BA1CB3522A62; Tue,  2 Mar 2021 17:22:29 -0800 (PST)
Date:   Tue, 2 Mar 2021 17:22:29 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Frederic Weisbecker <frederic@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Boqun Feng <boqun.feng@gmail.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Neeraj Upadhyay <neeraju@codeaurora.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Stable <stable@vger.kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH 11/13] rcu/nocb: Only cancel nocb timer if not polling
Message-ID: <20210303012229.GB20917@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20210223001011.127063-1-frederic@kernel.org>
 <20210223001011.127063-12-frederic@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210223001011.127063-12-frederic@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 23, 2021 at 01:10:09AM +0100, Frederic Weisbecker wrote:
> No need to disarm the nocb_timer if rcu_nocb is polling because it
> shouldn't be armed either.
> 
> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> Cc: Josh Triplett <josh@joshtriplett.org>
> Cc: Lai Jiangshan <jiangshanlai@gmail.com>
> Cc: Joel Fernandes <joel@joelfernandes.org>
> Cc: Neeraj Upadhyay <neeraju@codeaurora.org>
> Cc: Boqun Feng <boqun.feng@gmail.com>

OK, so it does make sense to move that del_timer() under the following
"if" statement, then.  ;-)

> ---
>  kernel/rcu/tree_plugin.h | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> index 9da67b0d3997..d8b50ff40e4b 100644
> --- a/kernel/rcu/tree_plugin.h
> +++ b/kernel/rcu/tree_plugin.h
> @@ -2186,18 +2186,18 @@ static void nocb_gp_wait(struct rcu_data *my_rdp)
>  	my_rdp->nocb_gp_gp = needwait_gp;
>  	my_rdp->nocb_gp_seq = needwait_gp ? wait_gp_seq : 0;
>  	if (bypass) {
> -		raw_spin_lock_irqsave(&my_rdp->nocb_gp_lock, flags);
> -		// Avoid race with first bypass CB.
> -		if (my_rdp->nocb_defer_wakeup > RCU_NOCB_WAKE_NOT) {
> -			WRITE_ONCE(my_rdp->nocb_defer_wakeup, RCU_NOCB_WAKE_NOT);
> -			del_timer(&my_rdp->nocb_timer);
> -		}
>  		if (!rcu_nocb_poll) {
> +			raw_spin_lock_irqsave(&my_rdp->nocb_gp_lock, flags);
> +			// Avoid race with first bypass CB.
> +			if (my_rdp->nocb_defer_wakeup > RCU_NOCB_WAKE_NOT) {
> +				WRITE_ONCE(my_rdp->nocb_defer_wakeup, RCU_NOCB_WAKE_NOT);
> +				del_timer(&my_rdp->nocb_timer);
> +			}
>  			// At least one child with non-empty ->nocb_bypass, so set
>  			// timer in order to avoid stranding its callbacks.
>  			mod_timer(&my_rdp->nocb_bypass_timer, j + 2);
> +			raw_spin_unlock_irqrestore(&my_rdp->nocb_gp_lock, flags);
>  		}
> -		raw_spin_unlock_irqrestore(&my_rdp->nocb_gp_lock, flags);
>  	}
>  	if (rcu_nocb_poll) {
>  		/* Polling, so trace if first poll in the series. */
> -- 
> 2.25.1
> 
