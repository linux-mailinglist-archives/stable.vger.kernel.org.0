Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB3E42F1220
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 13:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726110AbhAKMJP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 07:09:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbhAKMJP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 07:09:15 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17F30C061786;
        Mon, 11 Jan 2021 04:08:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=x0Cwt6O1sa0R2VhMooIo3pX/LbTSiCsKZ4/zQbQKyRo=; b=cRHF/rgEBsoms9jolqjULP6m59
        NXjuJX98OI2FNy3NDkBf4+rqxT6+Rsk+qjcSLNge/NX9e/rSZaTA0ouMup5kp+qNJN4krd+1fojrg
        H9T/iwybyPM/5zs9J8paUxXfb408FrmsFRPT523YoHAVn5flPbmRZZdGrWkoV7WL4VIRvcHevLE1s
        VEzs9WCUKk5VLgpnMBI2T8ybQawMYHWVvDKmxzCcNoLDwZRHN0ad+P0g4wmRln2yb1DbzmhYBkFv2
        aQOcagaZwQ6pctvovLMf5f35KLaT1SAa0yBvw5WsVEeKlU+w+qmGB72hXQmfc/dGUCBAjSYt0av/8
        pw09hLoQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1kyvzV-003Bk0-Qd; Mon, 11 Jan 2021 12:08:15 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id EFBA63010C8;
        Mon, 11 Jan 2021 13:08:08 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id DA3A52BB727AB; Mon, 11 Jan 2021 13:08:08 +0100 (CET)
Date:   Mon, 11 Jan 2021 13:08:08 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Frederic Weisbecker <frederic@kernel.org>
Cc:     "Paul E . McKenney" <paulmck@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
Subject: Re: [RFC PATCH 5/8] entry: Explicitly flush pending rcuog wakeup
 before last rescheduling points
Message-ID: <X/w/qBdnnQ5pFQxJ@hirez.programming.kicks-ass.net>
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
> +
>  		/*
>  		 * Disable interrupts and reevaluate the work flags as they
>  		 * might have changed while interrupts and preemption was
> @@ -197,6 +200,9 @@ static void exit_to_user_mode_prepare(struct pt_regs *regs)
>  
>  	lockdep_assert_irqs_disabled();
>  
> +	/* Flush pending rcuog wakeup before the last need_resched() check */
> +	rcu_nocb_flush_deferred_wakeup();
> +
>  	if (unlikely(ti_work & EXIT_TO_USER_MODE_WORK))
>  		ti_work = exit_to_user_mode_loop(regs, ti_work);
>  
> diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> index 2920dfc9f58c..3c4c0d5cea65 100644
> --- a/kernel/rcu/tree.c
> +++ b/kernel/rcu/tree.c
> @@ -705,12 +705,14 @@ noinstr void rcu_user_enter(void)
>  
>  	lockdep_assert_irqs_disabled();
>  	/*
> -	 * We may be past the last rescheduling opportunity in the entry code.
> -	 * Trigger a self IPI that will fire and reschedule once we resume to
> -	 * user/guest mode.
> +	 * Other than generic entry implementation, we may be past the last
> +	 * rescheduling opportunity in the entry code. Trigger a self IPI
> +	 * that will fire and reschedule once we resume in user/guest mode.
>  	 */
> -	if (do_nocb_deferred_wakeup(rdp) && need_resched())
> -		irq_work_queue(this_cpu_ptr(&late_wakeup_work));
> +	if (!IS_ENABLED(CONFIG_GENERIC_ENTRY) || (current->flags & PF_VCPU)) {

We have xfer_to_guest_mode_work() for that PF_VCPU case.

> +		if (do_nocb_deferred_wakeup(rdp) && need_resched())
> +			irq_work_queue(this_cpu_ptr(&late_wakeup_work));
> +	}
