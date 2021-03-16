Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0279933D34E
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 12:46:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237448AbhCPLpe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 07:45:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:51098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237447AbhCPLp3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 07:45:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E21AF65020;
        Tue, 16 Mar 2021 11:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615895129;
        bh=rHEZ8llIHHXGM7jx1Z2zqiWqFW8Ao6YtWewieSAnCr8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JWjHwLKPgmed3EkyEsDiUo7u71UZGQigx+pLqIfH3roFOPmUpe2LywwbO+VnZbdiF
         OE/5Y8+9XcrkVYP33bPCpE+doXFIyHODQdzQBqkdNEOjoC3UD/wyKFilNuKmHDDoTZ
         Jdk3nFRtWx7W72c2x6vBRH3V/YqdhYhFHK1UmVpiHAJS9+vcuB0P4880+oyD9/3xDr
         WoJj3fra4LljulcZZcfNizKCbgD9Rn3oI9oq+U/PQK7PRhCTiaJj2bIypXIFbHYnB4
         cHzRpN5OnfORMWOyL+IxzxQSn4YyerkR3gv5vUUJn0+BKt3CfWbMfVoZ2YhZBMzkgK
         VMpLkTv80kUSg==
Date:   Tue, 16 Mar 2021 12:45:26 +0100
From:   Frederic Weisbecker <frederic@kernel.org>
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Boqun Feng <boqun.feng@gmail.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Neeraj Upadhyay <neeraju@codeaurora.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Stable <stable@vger.kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH 12/13] rcu/nocb: Prepare for finegrained deferred wakeup
Message-ID: <20210316114526.GA639918@lothringen>
References: <20210223001011.127063-1-frederic@kernel.org>
 <20210223001011.127063-13-frederic@kernel.org>
 <20210316030239.GA13675@paulmck-ThinkPad-P72>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316030239.GA13675@paulmck-ThinkPad-P72>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 15, 2021 at 08:02:39PM -0700, Paul E. McKenney wrote:
> On Tue, Feb 23, 2021 at 01:10:10AM +0100, Frederic Weisbecker wrote:
> > Provide a way to tune the deferred wakeup level we want to perform from
> > a safe wakeup point. Currently those sites are:
> > 
> > * nocb_timer
> > * user/idle/guest entry
> > * CPU down
> > * softirq/rcuc
> > 
> > All of these sites perform the wake up for both RCU_NOCB_WAKE and
> > RCU_NOCB_WAKE_FORCE.
> > 
> > In order to merge nocb_timer and nocb_bypass_timer together, we plan to
> > add a new RCU_NOCB_WAKE_BYPASS that really want to be deferred until
> > a timer fires so that we don't wake up the NOCB-gp kthread too early.
> > 
> > To prepare for that, integrate a wake up level/limit that a callsite is
> > deemed to perform.
> 
> This appears to need the following in order to build for non-NOCB
> configurations.  I will fold it in and am retesting.
> 
> 							Thanx, Paul
> 
> ------------------------------------------------------------------------
> 
> commit 55f59dd75a11455cf558fd387fbf9011017dcc8a
> Author: Paul E. McKenney <paulmck@kernel.org>
> Date:   Mon Mar 15 20:00:34 2021 -0700
> 
>     squash! rcu/nocb: Prepare for fine-grained deferred wakeup
>     
>     [ paulmck: Fix non-NOCB rcu_nocb_need_deferred_wakeup() definition. ]
>     Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
> 
> diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> index 0cc7f68..dfb048e 100644
> --- a/kernel/rcu/tree_plugin.h
> +++ b/kernel/rcu/tree_plugin.h
> @@ -2926,7 +2926,7 @@ static void __init rcu_boot_init_nocb_percpu_data(struct rcu_data *rdp)
>  {
>  }
>  
> -static int rcu_nocb_need_deferred_wakeup(struct rcu_data *rdp)
> +static int rcu_nocb_need_deferred_wakeup(struct rcu_data *rdp, int level)
>  {
>  	return false;
>  }


Oops thanks, I missed that.
