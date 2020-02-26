Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6494116F604
	for <lists+stable@lfdr.de>; Wed, 26 Feb 2020 04:15:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729420AbgBZDO4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Feb 2020 22:14:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:33816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729434AbgBZDO4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Feb 2020 22:14:56 -0500
Received: from paulmck-ThinkPad-P72.home (199-192-87-166.static.wiline.com [199.192.87.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E43721927;
        Wed, 26 Feb 2020 03:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582686895;
        bh=t6C+JSqpJc3ZGM0GQELXv6dxp1w3T5mg2ZA90yJosw4=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=IJUq6jyQYRAIwcaoj/y5igedXdeK3nckj9xJenUbGWvkNY/n9b/2w2o2bVMUzmy9l
         tet1PSe45NBEpdYnTJua6nL/P21DiR9Cysxbo6O/CY2OcMs8cIXimZmG9DHHectwkz
         JSj5EThaVSHv3G94rkwwFarnWts2OYwCQZxZTONs=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 215983521EAF; Tue, 25 Feb 2020 19:14:55 -0800 (PST)
Date:   Tue, 25 Feb 2020 19:14:55 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Boqun Feng <boqun.feng@gmail.com>
Cc:     rcu@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@fb.com, mingo@kernel.org, jiangshanlai@gmail.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, fweisbec@gmail.com,
        oleg@redhat.com, joel@joelfernandes.org,
        "# 5 . 5 . x" <stable@vger.kernel.org>
Subject: Re: [PATCH tip/core/rcu 30/30] rcu: Make rcu_barrier() account for
 offline no-CBs CPUs
Message-ID: <20200226031455.GZ2935@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20200214235536.GA13364@paulmck-ThinkPad-P72>
 <20200214235607.13749-30-paulmck@kernel.org>
 <20200225102436.GF110915@debian-boqun.qqnc3lrjykvubdpftowmye0fmh.lx.internal.cloudapp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200225102436.GF110915@debian-boqun.qqnc3lrjykvubdpftowmye0fmh.lx.internal.cloudapp.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 25, 2020 at 06:24:36PM +0800, Boqun Feng wrote:
> Hi Paul,
> 
> On Fri, Feb 14, 2020 at 03:56:07PM -0800, paulmck@kernel.org wrote:
> > From: "Paul E. McKenney" <paulmck@kernel.org>
> > 
> > Currently, rcu_barrier() ignores offline CPUs,  However, it is possible
> > for an offline no-CBs CPU to have callbacks queued, and rcu_barrier()
> > must wait for those callbacks.  This commit therefore makes rcu_barrier()
> > directly invoke the rcu_barrier_func() with interrupts disabled for such
> > CPUs.  This requires passing the CPU number into this function so that
> > it can entrain the rcu_barrier() callback onto the correct CPU's callback
> > list, given that the code must instead execute on the current CPU.
> > 
> > While in the area, this commit fixes a bug where the first CPU's callback
> > might have been invoked before rcu_segcblist_entrain() returned, which
> > would also result in an early wakeup.
> > 
> > Fixes: 5d6742b37727 ("rcu/nocb: Use rcu_segcblist for no-CBs CPUs")
> > Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
> > Cc: <stable@vger.kernel.org> # 5.5.x
> > ---
> >  include/trace/events/rcu.h |  1 +
> >  kernel/rcu/tree.c          | 32 ++++++++++++++++++++------------
> >  2 files changed, 21 insertions(+), 12 deletions(-)
> > 
> > diff --git a/include/trace/events/rcu.h b/include/trace/events/rcu.h
> > index 5e49b06..d56d54c 100644
> > --- a/include/trace/events/rcu.h
> > +++ b/include/trace/events/rcu.h
> > @@ -712,6 +712,7 @@ TRACE_EVENT_RCU(rcu_torture_read,
> >   *	"Begin": rcu_barrier() started.
> >   *	"EarlyExit": rcu_barrier() piggybacked, thus early exit.
> >   *	"Inc1": rcu_barrier() piggyback check counter incremented.
> > + *	"OfflineNoCBQ": rcu_barrier() found offline no-CBs CPU with callbacks.
> >   *	"OnlineQ": rcu_barrier() found online CPU with callbacks.
> >   *	"OnlineNQ": rcu_barrier() found online CPU, no callbacks.
> >   *	"IRQ": An rcu_barrier_callback() callback posted on remote CPU.
> > diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> > index d15041f..160643e 100644
> > --- a/kernel/rcu/tree.c
> > +++ b/kernel/rcu/tree.c
> > @@ -3098,9 +3098,10 @@ static void rcu_barrier_callback(struct rcu_head *rhp)
> >  /*
> >   * Called with preemption disabled, and from cross-cpu IRQ context.
> >   */
> > -static void rcu_barrier_func(void *unused)
> > +static void rcu_barrier_func(void *cpu_in)
> >  {
> > -	struct rcu_data *rdp = raw_cpu_ptr(&rcu_data);
> > +	uintptr_t cpu = (uintptr_t)cpu_in;
> > +	struct rcu_data *rdp = per_cpu_ptr(&rcu_data, cpu);
> >  
> >  	rcu_barrier_trace(TPS("IRQ"), -1, rcu_state.barrier_sequence);
> >  	rdp->barrier_head.func = rcu_barrier_callback;
> > @@ -3127,7 +3128,7 @@ static void rcu_barrier_func(void *unused)
> >   */
> >  void rcu_barrier(void)
> >  {
> > -	int cpu;
> > +	uintptr_t cpu;
> >  	struct rcu_data *rdp;
> >  	unsigned long s = rcu_seq_snap(&rcu_state.barrier_sequence);
> >  
> > @@ -3150,13 +3151,14 @@ void rcu_barrier(void)
> >  	rcu_barrier_trace(TPS("Inc1"), -1, rcu_state.barrier_sequence);
> >  
> >  	/*
> > -	 * Initialize the count to one rather than to zero in order to
> > -	 * avoid a too-soon return to zero in case of a short grace period
> > -	 * (or preemption of this task).  Exclude CPU-hotplug operations
> > -	 * to ensure that no offline CPU has callbacks queued.
> > +	 * Initialize the count to two rather than to zero in order
> > +	 * to avoid a too-soon return to zero in case of an immediate
> > +	 * invocation of the just-enqueued callback (or preemption of
> > +	 * this task).  Exclude CPU-hotplug operations to ensure that no
> > +	 * offline non-offloaded CPU has callbacks queued.
> >  	 */
> >  	init_completion(&rcu_state.barrier_completion);
> > -	atomic_set(&rcu_state.barrier_cpu_count, 1);
> > +	atomic_set(&rcu_state.barrier_cpu_count, 2);
> >  	get_online_cpus();
> >  
> >  	/*
> > @@ -3166,13 +3168,19 @@ void rcu_barrier(void)
> >  	 */
> >  	for_each_possible_cpu(cpu) {
> >  		rdp = per_cpu_ptr(&rcu_data, cpu);
> > -		if (!cpu_online(cpu) &&
> > +		if (cpu_is_offline(cpu) &&
> >  		    !rcu_segcblist_is_offloaded(&rdp->cblist))
> >  			continue;
> > -		if (rcu_segcblist_n_cbs(&rdp->cblist)) {
> > +		if (rcu_segcblist_n_cbs(&rdp->cblist) && cpu_online(cpu)) {
> >  			rcu_barrier_trace(TPS("OnlineQ"), cpu,
> >  					  rcu_state.barrier_sequence);
> > -			smp_call_function_single(cpu, rcu_barrier_func, NULL, 1);
> > +			smp_call_function_single(cpu, rcu_barrier_func, (void *)cpu, 1);
> > +		} else if (cpu_is_offline(cpu)) {
> 
> I wonder whether this should be:
> 
> 		  else if (rcu_segcblist_n_cbs(&rdp->cblist) && cpu_is_offline(cpu))
> 
> ? Because I think we only want to queue the barrier call back if there
> are callbacks for a particular CPU. Am I missing something subtle?

I don't believe that you are missing anything at all!

Thank you very much -- this bug would not have shown up in any validation
setup that I am aware of.  ;-)

							Thanx, Paul

> Regards,
> Boqun
> 
> > +			rcu_barrier_trace(TPS("OfflineNoCBQ"), cpu,
> > +					  rcu_state.barrier_sequence);
> > +			local_irq_disable();
> > +			rcu_barrier_func((void *)cpu);
> > +			local_irq_enable();
> >  		} else {
> >  			rcu_barrier_trace(TPS("OnlineNQ"), cpu,
> >  					  rcu_state.barrier_sequence);
> > @@ -3184,7 +3192,7 @@ void rcu_barrier(void)
> >  	 * Now that we have an rcu_barrier_callback() callback on each
> >  	 * CPU, and thus each counted, remove the initial count.
> >  	 */
> > -	if (atomic_dec_and_test(&rcu_state.barrier_cpu_count))
> > +	if (atomic_sub_and_test(2, &rcu_state.barrier_cpu_count))
> >  		complete(&rcu_state.barrier_completion);
> >  
> >  	/* Wait for all rcu_barrier_callback() callbacks to be invoked. */
> > -- 
> > 2.9.5
> > 
