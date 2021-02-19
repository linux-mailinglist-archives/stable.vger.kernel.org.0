Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50BD631F9D1
	for <lists+stable@lfdr.de>; Fri, 19 Feb 2021 14:20:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbhBSNUN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Feb 2021 08:20:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:48274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229636AbhBSNUM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Feb 2021 08:20:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9910264EBD;
        Fri, 19 Feb 2021 13:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613740771;
        bh=Yx9jk5EZ5H2ZUkOJFBsLlBBzhs1QMkg442BEs/j5vP4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J6nf954Z2fLvBnqfO7tTdzej8DYnjjbJn5aPaJJ3O30GhgMyk2cleMdL2uKgoMUZc
         HvTBJ9MP8y0Lgob1cGlSB2Y0D//GlrA+MmONXSXgsJFy5OYtdHRqFl6jsuny2pmJOu
         C8b8iZ6Uh13rePOB8md6h6q3iM/VLLFX2CikzKns=
Date:   Fri, 19 Feb 2021 14:19:28 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Wen Yang <simon.wy@alibaba-inc.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH 4.9] smp: Warn on function calls from softirq context
Message-ID: <YC+64AbAjL6+vUdG@kroah.com>
References: <20210219131210.72241-1-simon.wy@alibaba-inc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210219131210.72241-1-simon.wy@alibaba-inc.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 19, 2021 at 09:12:10PM +0800, Wen Yang wrote:
> >> On Fri, Feb 19, 2021 at 02:43:34PM +0800, Wen Yang wrote:
> >> From: Peter Zijlstra <peterz@infradead.org>
> >> 
> >> commit 19dbdcb8039cff16669a05136a29180778d16d0a upstream.
> >> 
> >> It's clearly documented that smp function calls cannot be invoked from
> >> softirq handling context. Unfortunately nothing enforces that or emits a
> >> warning.
> >> 
> >> A single function call can be invoked from softirq context only via
> >> smp_call_function_single_async().
> >> 
> >> The only legit context is task context, so add a warning to that effect.
> >> 
> >> Reported-by: luferry <luferry@163.com>
> >> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> >> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> >> Link: https://lkml.kernel.org/r/20190718160601.GP3402@hirez.programming.kicks-ass.net
> >> Cc: stable <stable@vger.kernel.org> # 4.9.x
> >> Signed-off-by: Wen Yang <simon.wy@alibaba-inc.com>
> >> ---
> >>  kernel/smp.c | 16 ++++++++++++++++
> >>  1 file changed, 16 insertions(+)
> >> 
> >> diff --git a/kernel/smp.c b/kernel/smp.c
> >> index 399905f..f2b29c4 100644
> >> --- a/kernel/smp.c
> >> +++ b/kernel/smp.c
> >> @@ -276,6 +276,14 @@ int smp_call_function_single(int cpu, smp_call_func_t func, void *info,
> >>  	WARN_ON_ONCE(cpu_online(this_cpu) && irqs_disabled()
> >>  	     && !oops_in_progress);
> >>  
> >> +	/*
> >> +	 * When @wait we can deadlock when we interrupt between llist_add() and
> >> +	 * arch_send_call_function_ipi*(); when !@wait we can deadlock due to
> >> +	 * csd_lock() on because the interrupt context uses the same csd
> >> +	 * storage.
> >> +	 */
> >> +	WARN_ON_ONCE(!in_task());
> >> +
> >>  	csd = &csd_stack;
> >>  	if (!wait) {
> >>  	csd = this_cpu_ptr(&csd_data);
> >> @@ -401,6 +409,14 @@ void smp_call_function_many(const struct cpumask *mask,
> >>  	WARN_ON_ONCE(cpu_online(this_cpu) && irqs_disabled()
> >>  	     && !oops_in_progress && !early_boot_irqs_disabled);
> >>  
> >> +	/*
> >> +	 * When @wait we can deadlock when we interrupt between llist_add() and
> >> +	 * arch_send_call_function_ipi*(); when !@wait we can deadlock due to
> >> +	 * csd_lock() on because the interrupt context uses the same csd
> >> +	 * storage.
> >> +	 */
> >> +	WARN_ON_ONCE(!in_task());
> >> +
> >>  	/* Try to fastpath.  So, what's a CPU they want? Ignoring this one. */
> >>  	cpu = cpumask_first_and(mask, cpu_online_mask);
> >>  	if (cpu == this_cpu)
> >> -- 
> >> 1.8.3.1
> >> 
> > 
> > WHy do you want this in the 4.9.y kernel tree only, and not all others?
> > What bug/problem does this fix?  It seems that it will only report
> > problems that other code has, not fix existing code.  If anything, it's
> > going to start causing machines to reboot that have "panic on warn" set,
> > is that a good thing to do?
> 
> 4.9, 4.14 and 4.19 should all need it.
> 
> We find that some third party kernel modules occasionally cause kernel
> panic (such as watchdog reset). After further analysis, it is found that the
> functions such as smp_call_function()/on_each_cpu() are called in the interrupt
> context or softirq context.

If no in-kernel code has this problem, then why is this needed to be
backported?

> Since these usages are illegal and cannot be prohibited, we should add a warning
> to enhance the robustness of the stable kernel and/or facilitate the analysis of
> the problems.

We don't care, nor can we do, anything about out-of-tree code.  If you
wish to add this patch to your specific kernels to catch bad things,
that's fine, but as it is, I do not see how this patch fits the stable
kernel rules.

thanks,

greg k-h
