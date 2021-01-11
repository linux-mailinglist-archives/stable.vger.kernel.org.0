Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 765C92F1218
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 13:06:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbhAKMFY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 07:05:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbhAKMFU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 07:05:20 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B170C061795;
        Mon, 11 Jan 2021 04:04:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=okJh5T5JUHbtQcEyhttfzXGbXcDNpFBisqV852wbo54=; b=ZKDb0wZq+jCuCP9Y+2OVH8d+Vt
        MqQTH4ohAtniBycrO5uiMvWbwaY2qEl89UvIrtV+N/QVNXGHcXE7dQaviHQRMTppQO3d6yPO5QTjh
        XwhVViwOolFRI0tULQLm6eGkuLXIh5+laEhcGA1ZEGA4nbcIs7Mq4nxaqgNQqSTDIe2LrPapcwuZg
        1Kgp3CygQn/y8a1eg9x8eE62DT/n0pf7fUYOuP476Fp0kiha38Z1sCYpByjK3NJZy7mPC6Y/pXNUy
        +gth0IVV34C4Dc3ZEi102m/1F3kRWH+7Zl5Gt4cDgqRZSY6p6FwdNMj9QnbsC7qvMT92/jZBG/FqS
        aWhB1D0Q==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kyvvz-0007Z7-My; Mon, 11 Jan 2021 12:04:31 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id DE40B30015A;
        Mon, 11 Jan 2021 13:04:24 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id C53B82BB727A5; Mon, 11 Jan 2021 13:04:24 +0100 (CET)
Date:   Mon, 11 Jan 2021 13:04:24 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Frederic Weisbecker <frederic@kernel.org>
Cc:     "Paul E . McKenney" <paulmck@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
Subject: Re: [RFC PATCH 4/8] rcu/nocb: Trigger self-IPI on late deferred wake
 up before user resume
Message-ID: <X/w+yJmCBnDWxtoE@hirez.programming.kicks-ass.net>
References: <20210109020536.127953-1-frederic@kernel.org>
 <20210109020536.127953-5-frederic@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210109020536.127953-5-frederic@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 09, 2021 at 03:05:32AM +0100, Frederic Weisbecker wrote:
> Entering RCU idle mode may cause a deferred wake up of an RCU NOCB_GP
> kthread (rcuog) to be serviced.
> 
> Unfortunately the call to rcu_user_enter() is already past the last
> rescheduling opportunity before we resume to userspace or to guest mode.
> We may escape there with the woken task ignored.
> 
> The ultimate resort to fix every callsites is to trigger a self-IPI
> (nohz_full depends on IRQ_WORK) that will trigger a reschedule on IRQ
> tail or guest exit.
> 
> Eventually every site that want a saner treatment will need to carefully
> place a call to rcu_nocb_flush_deferred_wakeup() before the last explicit
> need_resched() check upon resume.
> 
> Reported-by: Paul E. McKenney <paulmck@kernel.org>
> Fixes: 96d3fd0d315a (rcu: Break call_rcu() deadlock involving scheduler and perf)
> Cc: stable@vger.kernel.org
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar<mingo@kernel.org>
> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> ---
>  kernel/rcu/tree.c        | 22 +++++++++++++++++++++-
>  kernel/rcu/tree.h        |  2 +-
>  kernel/rcu/tree_plugin.h | 25 ++++++++++++++++---------
>  3 files changed, 38 insertions(+), 11 deletions(-)
> 
> diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> index b6e1377774e3..2920dfc9f58c 100644
> --- a/kernel/rcu/tree.c
> +++ b/kernel/rcu/tree.c
> @@ -676,6 +676,18 @@ void rcu_idle_enter(void)
>  EXPORT_SYMBOL_GPL(rcu_idle_enter);
>  
>  #ifdef CONFIG_NO_HZ_FULL
> +
> +/*
> + * An empty function that will trigger a reschedule on
> + * IRQ tail once IRQs get re-enabled on userspace resume.
> + */
> +static void late_wakeup_func(struct irq_work *work)
> +{
> +}
> +
> +static DEFINE_PER_CPU(struct irq_work, late_wakeup_work) =
> +	IRQ_WORK_INIT(late_wakeup_func);
> +
>  /**
>   * rcu_user_enter - inform RCU that we are resuming userspace.
>   *
> @@ -692,9 +704,17 @@ noinstr void rcu_user_enter(void)
>  	struct rcu_data *rdp = this_cpu_ptr(&rcu_data);
>  
>  	lockdep_assert_irqs_disabled();
> -	do_nocb_deferred_wakeup(rdp);
> +	/*
> +	 * We may be past the last rescheduling opportunity in the entry code.
> +	 * Trigger a self IPI that will fire and reschedule once we resume to
> +	 * user/guest mode.
> +	 */
> +	if (do_nocb_deferred_wakeup(rdp) && need_resched())
> +		irq_work_queue(this_cpu_ptr(&late_wakeup_work));
> +
>  	rcu_eqs_enter(true);
>  }

Do we have the guarantee that every architecture that supports NOHZ_FULL
has arch_irq_work_raise() on?

Also, can't you do the same thing you did earlier and do that wakeup
thing before we complete exit_to_user_mode_prepare() ?
