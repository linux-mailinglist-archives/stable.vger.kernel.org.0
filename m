Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF86631F53C
	for <lists+stable@lfdr.de>; Fri, 19 Feb 2021 07:49:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbhBSGtE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Feb 2021 01:49:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:34966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229481AbhBSGtD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Feb 2021 01:49:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EFB6964EC0;
        Fri, 19 Feb 2021 06:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613717302;
        bh=hEjTUqC7iNuEn22lOe27q43sJZ4W9TBRrWhJp293ur0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LcuZWS0KW4MrjIiAxlz4np3a1PY3QqEK9qs7g+Q8dlUDfT0sj/1z1lGZB4Z38n+lV
         4KAChdprqlLkT4IrWUR+uK7sufmgDNKvBsWJk6SDcgFEm1wsxJrbmYKopAt9CQkhIq
         6O5nJpVdblCFVT9YUp35mRb81lC364DIZGpYg9ZY=
Date:   Fri, 19 Feb 2021 07:48:19 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Wen Yang <simon.wy@alibaba-inc.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        luferry <luferry@163.com>, Thomas Gleixner <tglx@linutronix.de>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH 4.9] smp: Warn on function calls from softirq context
Message-ID: <YC9fM6Os1RTA4GQf@kroah.com>
References: <20210219064334.69421-1-simon.wy@alibaba-inc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210219064334.69421-1-simon.wy@alibaba-inc.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 19, 2021 at 02:43:34PM +0800, Wen Yang wrote:
> From: Peter Zijlstra <peterz@infradead.org>
> 
> commit 19dbdcb8039cff16669a05136a29180778d16d0a upstream.
> 
> It's clearly documented that smp function calls cannot be invoked from
> softirq handling context. Unfortunately nothing enforces that or emits a
> warning.
> 
> A single function call can be invoked from softirq context only via
> smp_call_function_single_async().
> 
> The only legit context is task context, so add a warning to that effect.
> 
> Reported-by: luferry <luferry@163.com>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Link: https://lkml.kernel.org/r/20190718160601.GP3402@hirez.programming.kicks-ass.net
> Cc: stable <stable@vger.kernel.org> # 4.9.x
> Signed-off-by: Wen Yang <simon.wy@alibaba-inc.com>
> ---
>  kernel/smp.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/kernel/smp.c b/kernel/smp.c
> index 399905f..f2b29c4 100644
> --- a/kernel/smp.c
> +++ b/kernel/smp.c
> @@ -276,6 +276,14 @@ int smp_call_function_single(int cpu, smp_call_func_t func, void *info,
>  	WARN_ON_ONCE(cpu_online(this_cpu) && irqs_disabled()
>  		     && !oops_in_progress);
>  
> +	/*
> +	 * When @wait we can deadlock when we interrupt between llist_add() and
> +	 * arch_send_call_function_ipi*(); when !@wait we can deadlock due to
> +	 * csd_lock() on because the interrupt context uses the same csd
> +	 * storage.
> +	 */
> +	WARN_ON_ONCE(!in_task());
> +
>  	csd = &csd_stack;
>  	if (!wait) {
>  		csd = this_cpu_ptr(&csd_data);
> @@ -401,6 +409,14 @@ void smp_call_function_many(const struct cpumask *mask,
>  	WARN_ON_ONCE(cpu_online(this_cpu) && irqs_disabled()
>  		     && !oops_in_progress && !early_boot_irqs_disabled);
>  
> +	/*
> +	 * When @wait we can deadlock when we interrupt between llist_add() and
> +	 * arch_send_call_function_ipi*(); when !@wait we can deadlock due to
> +	 * csd_lock() on because the interrupt context uses the same csd
> +	 * storage.
> +	 */
> +	WARN_ON_ONCE(!in_task());
> +
>  	/* Try to fastpath.  So, what's a CPU they want? Ignoring this one. */
>  	cpu = cpumask_first_and(mask, cpu_online_mask);
>  	if (cpu == this_cpu)
> -- 
> 1.8.3.1
> 

WHy do you want this in the 4.9.y kernel tree only, and not all others?
What bug/problem does this fix?  It seems that it will only report
problems that other code has, not fix existing code.  If anything, it's
going to start causing machines to reboot that have "panic on warn" set,
is that a good thing to do?

thanks,

greg k-h
