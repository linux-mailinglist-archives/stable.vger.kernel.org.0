Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6715B2F12A5
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 13:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727230AbhAKM5j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 07:57:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:47986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727114AbhAKM5i (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 07:57:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DB4B20728;
        Mon, 11 Jan 2021 12:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610369818;
        bh=WAlsCM2z9lOTHqMg7LOk+d/mYCm8oj+S8UjSrkvBjfg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jqDAhg3fraQzP9QEVTZVVCDBqLXckaEooiJu34wRg8mrzJ6EnqdcKoUAlilUO+/cU
         l10VWsy/iCXNbfEISrgdNMHfOLDhKs7B0t5Jstsn2XSG4Brc1feRRNmGXe5/W2PmqS
         zd0Wd6YxuJSMD2Mq1GKbuMle529+XLDUQBLV16Yc7HsSFyfkCD3BY3lZiEz4bB5YWw
         W+xFRDsl8D0oO29D5LK0DYo0S3kTFLbdNnUXJnYUjTdsDLkyuAw6MMAc1g82kUoxip
         dinZ0pddlq5DM0KGPM9PITDFoZHSPhaYMtmfHRTcSuqPmfrDtm0kbzaJ+zjjS4XFMY
         BUgHYnTPk6auA==
Date:   Mon, 11 Jan 2021 13:56:55 +0100
From:   Frederic Weisbecker <frederic@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     "Paul E . McKenney" <paulmck@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
Subject: Re: [RFC PATCH 6/8] sched: Report local wake up on resched blind
 zone within idle loop
Message-ID: <20210111125655.GF242508@lothringen>
References: <20210109020536.127953-1-frederic@kernel.org>
 <20210109020536.127953-7-frederic@kernel.org>
 <X/xD1/yjYXi28XXs@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X/xD1/yjYXi28XXs@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 11, 2021 at 01:25:59PM +0100, Peter Zijlstra wrote:
> On Sat, Jan 09, 2021 at 03:05:34AM +0100, Frederic Weisbecker wrote:
> > The idle loop has several need_resched() checks that make sure we don't
> > miss a rescheduling request. This means that any wake up performed on
> > the local runqueue after the last generic need_resched() check is going
> > to have its rescheduling silently ignored. This has happened in the
> > past with rcu kthreads awaken from rcu_idle_enter() for example.
> > 
> > Perform sanity checks to report these situations.
> 
> I really don't like this..
> 
>  - it's too specific to the actual reschedule condition, any wakeup this
>    late is dodgy, not only those that happen to cause a local
>    reschedule.

Right.

> 
>  - we can already test this with unwind and checking against __cpuidle
> 
>  - moving all of __cpuidle into noinstr would also cover this. And we're
>    going to have to do that anyway.

Ok then, I'll wait for that instead.

> 
> > +void noinstr sched_resched_local_assert_allowed(void)
> > +{
> > +	if (this_rq()->resched_local_allow)
> > +		return;
> > +
> 
> > +	/*
> > +	 * Idle interrupts break the CPU from its pause and
> > +	 * rescheduling happens on idle loop exit.
> > +	 */
> > +	if (in_hardirq())
> > +		return;
> > +
> > +	/*
> > +	 * What applies to hardirq also applies to softirq as
> > +	 * we assume they execute on hardirq tail. Ksoftirqd
> > +	 * shouldn't have resched_local_allow == 0.
> > +	 * We also assume that no local_bh_enable() call may
> > +	 * execute softirqs inline on fragile idle/entry
> > +	 * path...
> > +	 */
> > +	if (in_serving_softirq())
> > +		return;
> > +
> > +	WARN_ONCE(1, "Late current task rescheduling may be lost\n");
> 
> That seems like it wants to be:
> 
> 	WARN_ONCE(in_task(), "...");

Right! But I guess I'll drop that patch now.

Thanks.
