Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAD3D313583
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 15:48:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232561AbhBHOq7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 09:46:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232805AbhBHOqn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 09:46:43 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9A25C061786;
        Mon,  8 Feb 2021 06:46:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ezjM9RK8q9ZkDU1hNSWqUp0BpKofzQPgjLv9MoG7YR4=; b=K4Z/FZ84HTnviv3KOinJCLCc2E
        Nd2m71fWtpnBotID/OaFotnIvBm0AKd1GEn1vvGk6E6rVTCQP9WU8h8jdrwGFLS4tTJvmWvg3CDdZ
        l1BAY3T6RS6vFIeaILq7ONb9Yn1Rwlp2rxP4zjt+9/xt0QYWaENveK/k2CWvAbCWIQnEzxgRXYAsT
        Tbe9lGZ74EIYG4XFAtyn35C3kFX9N+5S6MB7ZUGkpX1KofxOILj3GBjtmn8jj9xApocKZ/iRyWQW6
        LjwCAoFtgDyL1DACAOTucmlsSx3yxSly3ujl836DHjxcT+P7khvOFmThucPXRx0sm32kmN9UiHKwj
        OIYimmcg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l97nX-0001A9-7H; Mon, 08 Feb 2021 14:45:55 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 943DA3010D2;
        Mon,  8 Feb 2021 15:45:50 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 57DF22BF5C9B6; Mon,  8 Feb 2021 15:45:50 +0100 (CET)
Date:   Mon, 8 Feb 2021 15:45:50 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Frederic Weisbecker <frederic@kernel.org>
Cc:     "Paul E . McKenney" <paulmck@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 2/5] rcu/nocb: Perform deferred wake up before last
 idle's need_resched() check
Message-ID: <YCFOnhwQAjMMkwGN@hirez.programming.kicks-ass.net>
References: <20210131230548.32970-1-frederic@kernel.org>
 <20210131230548.32970-3-frederic@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210131230548.32970-3-frederic@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 01, 2021 at 12:05:45AM +0100, Frederic Weisbecker wrote:

> diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
> index 305727ea0677..b601a3aa2152 100644
> --- a/kernel/sched/idle.c
> +++ b/kernel/sched/idle.c
> @@ -55,6 +55,7 @@ __setup("hlt", cpu_idle_nopoll_setup);
>  static noinline int __cpuidle cpu_idle_poll(void)
>  {
>  	trace_cpu_idle(0, smp_processor_id());
> +	rcu_nocb_flush_deferred_wakeup();
>  	stop_critical_timings();
>  	rcu_idle_enter();
>  	local_irq_enable();
> @@ -173,6 +174,8 @@ static void cpuidle_idle_call(void)
>  	struct cpuidle_driver *drv = cpuidle_get_cpu_driver(dev);
>  	int next_state, entered_state;
>  
> +	rcu_nocb_flush_deferred_wakeup();
> +
>  	/*
>  	 * Check if the idle task must be rescheduled. If it is the
>  	 * case, exit the function after re-enabling the local irq.

Ok if I do this instead?

--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -55,7 +55,6 @@ __setup("hlt", cpu_idle_nopoll_setup);
 static noinline int __cpuidle cpu_idle_poll(void)
 {
 	trace_cpu_idle(0, smp_processor_id());
-	rcu_nocb_flush_deferred_wakeup();
 	stop_critical_timings();
 	rcu_idle_enter();
 	local_irq_enable();
@@ -174,8 +173,6 @@ static void cpuidle_idle_call(void)
 	struct cpuidle_driver *drv = cpuidle_get_cpu_driver(dev);
 	int next_state, entered_state;
 
-	rcu_nocb_flush_deferred_wakeup();
-
 	/*
 	 * Check if the idle task must be rescheduled. If it is the
 	 * case, exit the function after re-enabling the local irq.
@@ -288,6 +285,7 @@ static void do_idle(void)
 		}
 
 		arch_cpu_idle_enter();
+		rcu_nocb_flush_deferred_wakeup();
 
 		/*
 		 * In poll mode we reenable interrupts and spin. Also if we
