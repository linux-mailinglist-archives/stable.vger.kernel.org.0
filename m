Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 671ED2F0AA6
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 01:41:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbhAKAk5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Jan 2021 19:40:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:47040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726350AbhAKAk5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 10 Jan 2021 19:40:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0ECD722AAF;
        Mon, 11 Jan 2021 00:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610325616;
        bh=QSVYNEYMoEPMyuGN+8amhzH4/+0MkW/3it5M0xSMDYI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Bwo+pv3OlqyIOVzvVOEjqSQQXZAoAiRY8DoLFfh1YsRmMj22qKXOXtK3YQiXinl9o
         svrfPJKn+R4qTp9QLDcnjSdMl5KXEWlvhlsAoOFXKa7MlxQVN4qVWK5gEs6uuPg3fp
         sp/RqJlWbc8L0JvaeaPno8HNRp6IOdoLDom8SCsDnQZf4t/iY/zfwwui1ESll0tsyM
         GSYqn8048tKxOj/BTDldkeHLFu/I6MOwoDBZcYw5UW9DHm6ndiFIYwlbLkK4h0sHLa
         WgZ7jQI1wHYcjdInd/sxiGhzl3JSzbiMct5DXr6TwEr6yGdgPvr/DQwSqAlP/kzO7P
         HLcuVDajb9pSA==
Date:   Mon, 11 Jan 2021 01:40:14 +0100
From:   Frederic Weisbecker <frederic@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>,
        "Paul E . McKenney" <paulmck@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
Subject: Re: [RFC PATCH 5/8] entry: Explicitly flush pending rcuog wakeup
 before last rescheduling points
Message-ID: <20210111004014.GA242508@lothringen>
References: <20210109020536.127953-1-frederic@kernel.org>
 <20210109020536.127953-6-frederic@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210109020536.127953-6-frederic@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 09, 2021 at 03:05:33AM +0100, Frederic Weisbecker wrote:
> Following the idle loop model, cleanly check for pending rcuog wakeup
> before the last rescheduling point on resuming to user mode. This
> way we can avoid to do it from rcu_user_enter() with the last resort
> self-IPI hack that enforces rescheduling.
> 
> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar<mingo@kernel.org>
> Cc: Paul E. McKenney <paulmck@kernel.org>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>  kernel/entry/common.c |  6 ++++++
>  kernel/rcu/tree.c     | 12 +++++++-----
>  2 files changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/entry/common.c b/kernel/entry/common.c
> index 378341642f94..8f3292b5f9b7 100644
> --- a/kernel/entry/common.c
> +++ b/kernel/entry/common.c
> @@ -178,6 +178,9 @@ static unsigned long exit_to_user_mode_loop(struct pt_regs *regs,
>  		/* Architecture specific TIF work */
>  		arch_exit_to_user_mode_work(regs, ti_work);
>  
> +		/* Check if any of the above work has queued a deferred wakeup */
> +		rcu_nocb_flush_deferred_wakeup();

So this needs to be moved to the IRQs disabled section, just a few lines later,
otherwise preemption may schedule another task that in turn do call_rcu() and create
new deferred wake up (thank Paul for the warning). Not to mention moving to
another CPU with its own deferred wakeups to flush...

I'll fix that for the next version.

Thanks.
