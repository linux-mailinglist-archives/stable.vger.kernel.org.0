Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05BA13135C1
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 15:54:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232951AbhBHOyU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 09:54:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:49626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233050AbhBHOxv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 09:53:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBFC264E0B;
        Mon,  8 Feb 2021 14:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612795991;
        bh=i6f/6e4GcjdYXiSC4q7RU5ecXO577LdJe4fGuhC3+7Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e0LPizB5rUAklGv6vltYdeXCuWd1OqWVWjcnZULW3E6Bfdx5PTLCfBINp7fXa/If5
         2206YM+eT6ivp5xKk/nV0G5YyLvyxnvbIG+Vz7HKx88C1MFiGuAAwaJJPmyySISN4R
         zkh/xMIaBK6LLleVzXn18SS28WprDFQo22i9Qkiyt20RbxQ8cjYGKrQhZXC/wxlGzA
         DErIjyXcrlUooaSBv5QdezXlsF+yMtpEkzxw71nNEGCEpbB0y4z4Q9dIdVkwDTjnsf
         bFobyW0wp9t7ujyVRsL/jH3mbuMvwRuKPkiQCgU2Me8v048BLAWIEzBoyDLDaZyHGs
         TT0vA5QAsyFiQ==
Date:   Mon, 8 Feb 2021 15:53:08 +0100
From:   Frederic Weisbecker <frederic@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     "Paul E . McKenney" <paulmck@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 2/5] rcu/nocb: Perform deferred wake up before last
 idle's need_resched() check
Message-ID: <20210208145308.GC3969@lothringen>
References: <20210131230548.32970-1-frederic@kernel.org>
 <20210131230548.32970-3-frederic@kernel.org>
 <YCFOnhwQAjMMkwGN@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YCFOnhwQAjMMkwGN@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 08, 2021 at 03:45:50PM +0100, Peter Zijlstra wrote:
> On Mon, Feb 01, 2021 at 12:05:45AM +0100, Frederic Weisbecker wrote:
> 
> > diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
> > index 305727ea0677..b601a3aa2152 100644
> > --- a/kernel/sched/idle.c
> > +++ b/kernel/sched/idle.c
> > @@ -55,6 +55,7 @@ __setup("hlt", cpu_idle_nopoll_setup);
> >  static noinline int __cpuidle cpu_idle_poll(void)
> >  {
> >  	trace_cpu_idle(0, smp_processor_id());
> > +	rcu_nocb_flush_deferred_wakeup();
> >  	stop_critical_timings();
> >  	rcu_idle_enter();
> >  	local_irq_enable();
> > @@ -173,6 +174,8 @@ static void cpuidle_idle_call(void)
> >  	struct cpuidle_driver *drv = cpuidle_get_cpu_driver(dev);
> >  	int next_state, entered_state;
> >  
> > +	rcu_nocb_flush_deferred_wakeup();
> > +
> >  	/*
> >  	 * Check if the idle task must be rescheduled. If it is the
> >  	 * case, exit the function after re-enabling the local irq.
> 
> Ok if I do this instead?
> 
> --- a/kernel/sched/idle.c
> +++ b/kernel/sched/idle.c
> @@ -55,7 +55,6 @@ __setup("hlt", cpu_idle_nopoll_setup);
>  static noinline int __cpuidle cpu_idle_poll(void)
>  {
>  	trace_cpu_idle(0, smp_processor_id());
> -	rcu_nocb_flush_deferred_wakeup();
>  	stop_critical_timings();
>  	rcu_idle_enter();
>  	local_irq_enable();
> @@ -174,8 +173,6 @@ static void cpuidle_idle_call(void)
>  	struct cpuidle_driver *drv = cpuidle_get_cpu_driver(dev);
>  	int next_state, entered_state;
>  
> -	rcu_nocb_flush_deferred_wakeup();
> -
>  	/*
>  	 * Check if the idle task must be rescheduled. If it is the
>  	 * case, exit the function after re-enabling the local irq.
> @@ -288,6 +285,7 @@ static void do_idle(void)
>  		}
>  
>  		arch_cpu_idle_enter();
> +		rcu_nocb_flush_deferred_wakeup();
>  
>  		/*
>  		 * In poll mode we reenable interrupts and spin. Also if we

Right, I think that should work. Nothing should call_rcu() before the
need_resched() call. And if it does, we still have the nocb_timer to do
the deferred wakeup in the worst case.

Thanks.

