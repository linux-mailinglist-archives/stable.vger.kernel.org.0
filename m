Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A91C62F1247
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 13:27:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbhAKM0u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 07:26:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbhAKM0u (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 07:26:50 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0549C061786;
        Mon, 11 Jan 2021 04:26:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=yffeqYboBqOGua6hWCkEf8XKAwaOj/3UxQruZqzhb1g=; b=WMxGA+VKW3fO7JteFchAlyxi9T
        3l4Jjs0FWsulRdLl+Ft7Ymq7xBdelXluchQFPRmvne3SLsgX+9D6DMjvi96a+IewVi72FKWKgWUQA
        gTFmRL9d2sm1vvtX1m9XXAX2Z1SYujzEf8TYf/1W1YbpRCvGjqCrzHUJxNYhPM+ErjCa7WwigUDwb
        jBmaUaVHiacc8cAHFnLPPGgpf0WJDcQmKo1r7RcyUAhJfcykd4gYmJTb3iEpx+phBsZT8SCKEbIld
        ye2mLVCssRDX4ggpEReSWPS1KZWOnxf1Gw7CI2tb8GU9G/TxZexK7xW0Io6adlO2nqp/tAjMtjOHK
        bYDyw2fg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1kywGm-003Cxp-Eb; Mon, 11 Jan 2021 12:26:00 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id DC3F4301324;
        Mon, 11 Jan 2021 13:25:59 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 9C195235E2519; Mon, 11 Jan 2021 13:25:59 +0100 (CET)
Date:   Mon, 11 Jan 2021 13:25:59 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Frederic Weisbecker <frederic@kernel.org>
Cc:     "Paul E . McKenney" <paulmck@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
Subject: Re: [RFC PATCH 6/8] sched: Report local wake up on resched blind
 zone within idle loop
Message-ID: <X/xD1/yjYXi28XXs@hirez.programming.kicks-ass.net>
References: <20210109020536.127953-1-frederic@kernel.org>
 <20210109020536.127953-7-frederic@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210109020536.127953-7-frederic@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 09, 2021 at 03:05:34AM +0100, Frederic Weisbecker wrote:
> The idle loop has several need_resched() checks that make sure we don't
> miss a rescheduling request. This means that any wake up performed on
> the local runqueue after the last generic need_resched() check is going
> to have its rescheduling silently ignored. This has happened in the
> past with rcu kthreads awaken from rcu_idle_enter() for example.
> 
> Perform sanity checks to report these situations.

I really don't like this..

 - it's too specific to the actual reschedule condition, any wakeup this
   late is dodgy, not only those that happen to cause a local
   reschedule.

 - we can already test this with unwind and checking against __cpuidle

 - moving all of __cpuidle into noinstr would also cover this. And we're
   going to have to do that anyway.

> +void noinstr sched_resched_local_assert_allowed(void)
> +{
> +	if (this_rq()->resched_local_allow)
> +		return;
> +

> +	/*
> +	 * Idle interrupts break the CPU from its pause and
> +	 * rescheduling happens on idle loop exit.
> +	 */
> +	if (in_hardirq())
> +		return;
> +
> +	/*
> +	 * What applies to hardirq also applies to softirq as
> +	 * we assume they execute on hardirq tail. Ksoftirqd
> +	 * shouldn't have resched_local_allow == 0.
> +	 * We also assume that no local_bh_enable() call may
> +	 * execute softirqs inline on fragile idle/entry
> +	 * path...
> +	 */
> +	if (in_serving_softirq())
> +		return;
> +
> +	WARN_ONCE(1, "Late current task rescheduling may be lost\n");

That seems like it wants to be:

	WARN_ONCE(in_task(), "...");

> +}


