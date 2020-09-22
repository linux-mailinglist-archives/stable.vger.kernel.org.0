Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 444F5274BBB
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 23:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbgIVV4B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 17:56:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:45702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726448AbgIVV4B (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Sep 2020 17:56:01 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A035208A9;
        Tue, 22 Sep 2020 21:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600811760;
        bh=XBdjEAvmmpai5DbQ/x+VMB6xuyGQmFdDI8gE6tQNkPA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YRykSR+k9K2LHgUfJYsjmzeGH1neqrawBGF3a0dGdMnghgRzRNQ2M+wLldfHsizSV
         G3ILWCycCxzR8cyP5Mel4+JBgxby9OVl6gH8RVnURT3xLmfKwGeJG+hrSRmje3b/wV
         jctHRvynVkc7xsIx/ta/9DuZbKUWxsZvzpv3k03c=
Date:   Tue, 22 Sep 2020 14:55:58 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>, tytso@mit.edu,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] random: use correct memory barriers for crng_node_pool
Message-ID: <20200922215558.GA1833749@gmail.com>
References: <20200917072644.GA5311@gondor.apana.org.au>
 <20200917165802.GC855@sol.localdomain>
 <20200921081939.GA4193@gondor.apana.org.au>
 <20200921152714.GC29330@paulmck-ThinkPad-P72>
 <20200921221104.GA6556@gondor.apana.org.au>
 <20200921232639.GK29330@paulmck-ThinkPad-P72>
 <20200921235243.GA32959@sol.localdomain>
 <20200922183100.GZ29330@paulmck-ThinkPad-P72>
 <20200922190936.GB1616407@gmail.com>
 <20200922205628.GD29330@paulmck-ThinkPad-P72>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200922205628.GD29330@paulmck-ThinkPad-P72>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 22, 2020 at 01:56:28PM -0700, Paul E. McKenney wrote:
> > You're missing the point here.  b and c could easily be allocated by a function
> > alloc_b() that's in another file.
> 
> I am still missing something.
> 
> If by "allocated" you mean something like kmalloc(), the compiler doesn't
> know the address.  If you instead mean that there is a function that
> returns the address of another translation unit's static variable, then
> any needed ordering should preferably be built into that function's API.
> Either way, one would hope for some documentation of anything the caller
> needed to be careful of.
> 
> > > Besides which, control dependencies should be used only by LKMM experts
> > > at this point.  
> > 
> > What does that even mean?  Control dependencies are everywhere.
> 
> Does the following work better for you?
> 
> "... the non-local ordering properties of control dependencies should be
> relied on only by LKMM experts ...".

No.  I don't know what that means.  And I think very few people would know.

I just want to know if I use the one-time init pattern with a pointer to a data
structure foo, are the readers using foo_use() supposed to use READ_ONCE() or
are they supposed to use smp_load_acquire().

It seems the answer is that smp_load_acquire() is the only safe choice, since
foo_use() *might* involve a control dependency, or might in the future since
it's part of another kernel subsystem and its implementation could change.

> If this control dependency's non-local ordering places any requirements on
> the users of that code, those requirements need to be clearly documented.
> It is of course better if the control dependency's non-local ordering
> properties are local to the code containing those control dependencies
> so that the callers don't need to worry about the resulting non-local
> ordering.
> 
> > > But in the LKMM documentation, you are likely to find LKMM experts who
> > > want to optimize all the way, particularly in cases like the one-time
> > > init pattern where all the data is often local.  And the best basis for
> > > READ_ONCE() in one-time init is not a control dependency, but rather
> > > ordering of accesses to a single variable from a single task combined
> > > with locking, both of which are quite robust and much easier to use,
> > > especially in comparison to control dependencies.
> > > 
> > > My goal for LKMM is not that each and every developer have a full
> > > understanding of every nook and cranny of that model, but instead that
> > > people can find the primitives supporting the desired point in the
> > > performance/simplicity tradoff space.  And yes, I have more writing
> > > to do to make more progress towards that goal.
> > 
> > So are you saying people should use smp_load_acquire(), or are you saying people
> > should use READ_ONCE()?
> 
> C'mon, you know the answer to that!  ;-)
> 
> The answer is that it depends on both the people and the situation.
> 
> In the specific case of crng, where you need address dependency
> ordering but the pointed-to data is dynamically allocated and never
> deallocated, READ_ONCE() now suffices [1].  Of course, smp_load_acquire()
> also suffices, at the cost of extra/expensive instructions on some
> architectures.  The cmpxchg() needs at least release semantics, but
> presumably no one cares if this operation is a bit more expensive than
> it needs to be.
> 
> So, is select_crng() used on a fastpath?  If so, READ_ONCE()
> might be necessary.  If not, why bother with anything stronger than
> smp_load_acquire()?  The usual approach is to run this both ways on ARM
> or PowerPC and see if it makes a significant difference.  If there is
> no significant difference, keep it simple and just use smp_load_acquire().
> 
> If the code was sufficiently performance-insensitive, even better would
> be to just use locking.  My hope is that no one bothered with the atomics
> without a good reason, but you never know.
> 
> I confess some uncertainty as to how the transition from the global
> primary_crng and the per-NUMA-node locks is handled.  I hope that the
> global primary_crng guards global state that is disjoint from the state
> being allocated by do_numa_crng_init()!

crng_node_pool just uses the one-time init pattern.  It's nothing unusual; lots
of other places in the kernel want to do one-time initialization too.  It seems
to be one of the more common cases where people run into the LKMM at all.
I tried to document it in
https://lkml.kernel.org/lkml/20200717044427.68747-1-ebiggers@kernel.org/T/#u,
but people complained it was still too complicated.

I hope that people can at least reach some general recommendation about
READ_ONCE() vs. smp_load_acquire(), so that every kernel developer doesn't have
to understand the detailed difference, and so that we don't need to have a long
discussion (potentially requiring LWN coverage) about every patch.

> 
> Use the simplest thing that gets the job done.  Which in the Linux kernel
> often won't be all that simple, but life is like that sometimes.
> 
> 							Thanx, Paul
> 
> [1]	It used to be that READ_ONCE() did -not- suffice on DEC Alpha,
> 	but this has thankfully changed, so that lockless_dereference()
> 	is no more.

Let me give an example using spinlock_t, since that's used in crng_node_pool.
However, it could be any other data structure too; this is *just an example*.
And it doesn't matter if the implementation is currently different; the point is
that it's an *implementation*.

The allocation side uses spin_lock_init(), while the read side uses spin_lock().
Let's say that some debugging feature is enabled where spin locks use some
global debugging information (say, a list of all locks) that gets allocated the
first time a spin lock is initialized:

	static struct spin_lock_debug_info *debug_info;
	static DEFINE_MUTEX(debug_info_alloc_mutex);

	void spin_lock_init(spinlock_t *lock)
	{
	#ifdef CONFIG_DEBUG_SPIN_LOCKS
		mutex_lock(&debug_info_alloc_mutex);
		if (!debug_info)
			debug_info = alloc_debug_info();
		add_lock(debug_info, lock);
		mutex_unlock(&debug_info_alloc_mutex);
	#endif
		real_spin_lock_init(lock);
	}

	void spin_lock(spinlock_t *lock)
	{
	#ifdef CONFIG_DEBUG_SPIN_LOCKS
		debug_info->...; # use the debug info
	#endif
		real_spin_lock(lock);
	}

In that case, readers would have a control dependency between the condition of
the data struct containing the spinlock_t being non-NULL, and the dereference of
debug_info by spin_lock().  So anyone "receiving" a data structure containing a
spinlock_t would need to use smp_load_acquire(), not READ_ONCE().

Point is, whether it's safe to use READ_ONCE() with a data structure or not is
an implementation detail, not an API guarantee.

- Eric
