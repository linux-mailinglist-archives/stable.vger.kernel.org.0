Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD1A274A6E
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 22:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbgIVU4a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 16:56:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:37202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726448AbgIVU4a (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Sep 2020 16:56:30 -0400
Received: from paulmck-ThinkPad-P72.home (unknown [50.45.173.55])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F2DE2065D;
        Tue, 22 Sep 2020 20:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600808189;
        bh=11Sd5fjZkjY1iedWTT9O8zSYJ5RgMEnSC+7qoWNl8J8=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=O52xvwU6UkgC1Fa11f5q4scqCL5UBEvuWz4lrZYDMN6cKYARi90dMPmBWHggNbTUj
         sypBl0bzVg4GE2pDVP0FvAcQegWnB+gHUyVSlClnKBMEA6zWJwmbZEXHseN3eQpsei
         sTlV8G1p+QnIH9UBCQu84LMeymISAjG8oXn5yCc4=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id C3F6435227BD; Tue, 22 Sep 2020 13:56:28 -0700 (PDT)
Date:   Tue, 22 Sep 2020 13:56:28 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>, tytso@mit.edu,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] random: use correct memory barriers for crng_node_pool
Message-ID: <20200922205628.GD29330@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20200916233042.51634-1-ebiggers@kernel.org>
 <20200917072644.GA5311@gondor.apana.org.au>
 <20200917165802.GC855@sol.localdomain>
 <20200921081939.GA4193@gondor.apana.org.au>
 <20200921152714.GC29330@paulmck-ThinkPad-P72>
 <20200921221104.GA6556@gondor.apana.org.au>
 <20200921232639.GK29330@paulmck-ThinkPad-P72>
 <20200921235243.GA32959@sol.localdomain>
 <20200922183100.GZ29330@paulmck-ThinkPad-P72>
 <20200922190936.GB1616407@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200922190936.GB1616407@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 22, 2020 at 12:09:36PM -0700, Eric Biggers wrote:
> On Tue, Sep 22, 2020 at 11:31:00AM -0700, Paul E. McKenney wrote:
> > > Also, it's not just the p == &global_variable case.  Consider:
> > > 
> > > struct a { struct b *b; };
> > > struct b { ... };
> > > 
> > > Thread 1:
> > > 
> > > 	/* one-time initialized data shared by all instances of b */
> > > 	static struct c *c;
> > > 
> > > 	void init_b(struct a *a)
> > > 	{
> > > 		if (!c)
> > > 			c = alloc_c();
> > > 
> > > 		smp_store_release(&a->b, kzalloc(sizeof(struct b)));
> > > 	}
> > > 
> > > Thread 2:
> > > 
> > > 	void use_b_if_present(struct a *a)
> > > 	{
> > > 		struct b *b = READ_ONCE(a->b);
> > > 
> > > 		if (b) {
> > > 			c->... # crashes because c still appears to be NULL
> > > 		}
> > > 	}
> > > 
> > > 
> > > So when the *first* "b" is allocated, the global data "c" is initialized.  Then
> > > when using a "b", we expect to be able to access "c".  But there's no
> > > data dependency from "b" to "c"; it's a control dependency only.
> > > So smp_load_acquire() is needed, not READ_ONCE().
> > > 
> > > And it can be an internal implementation detail of "b"'s subsystem whether it
> > > happens to use global data "c".
> > 
> > Given that "c" is static, these two subsystems must be in the same
> > translation unit.  So I don't see how this qualifies as being internal to
> > "b"'s subsystem.
> 
> You're missing the point here.  b and c could easily be allocated by a function
> alloc_b() that's in another file.

I am still missing something.

If by "allocated" you mean something like kmalloc(), the compiler doesn't
know the address.  If you instead mean that there is a function that
returns the address of another translation unit's static variable, then
any needed ordering should preferably be built into that function's API.
Either way, one would hope for some documentation of anything the caller
needed to be careful of.

> > Besides which, control dependencies should be used only by LKMM experts
> > at this point.  
> 
> What does that even mean?  Control dependencies are everywhere.

Does the following work better for you?

"... the non-local ordering properties of control dependencies should be
relied on only by LKMM experts ...".

> > > This sort of thing is why people objected to the READ_ONCE() optimization during
> > > the discussion at
> > > https://lkml.kernel.org/linux-fsdevel/20200717044427.68747-1-ebiggers@kernel.org/T/#u.
> > > Most kernel developers aren't experts in the LKMM, and they want something
> > > that's guaranteed to be correct without having to to think really hard about it
> > > and make assumptions about the internal implementation details of other
> > > subsystems, how compilers have implemented the C standard, and so on.
> > 
> > And smp_load_acquire()is provided for that reason.  Its name was
> > even based on the nomenclature used in the C standard and elsewhere.
> > And again, control dependencies are for LKMM experts, as they are very
> > tricky to get right.
> 
> How does a developer know that the code they're calling in another subsystem
> wasn't written by one of these "experts" and therefore has a control dependency?

If this control dependency's non-local ordering places any requirements on
the users of that code, those requirements need to be clearly documented.
It is of course better if the control dependency's non-local ordering
properties are local to the code containing those control dependencies
so that the callers don't need to worry about the resulting non-local
ordering.

> > But in the LKMM documentation, you are likely to find LKMM experts who
> > want to optimize all the way, particularly in cases like the one-time
> > init pattern where all the data is often local.  And the best basis for
> > READ_ONCE() in one-time init is not a control dependency, but rather
> > ordering of accesses to a single variable from a single task combined
> > with locking, both of which are quite robust and much easier to use,
> > especially in comparison to control dependencies.
> > 
> > My goal for LKMM is not that each and every developer have a full
> > understanding of every nook and cranny of that model, but instead that
> > people can find the primitives supporting the desired point in the
> > performance/simplicity tradoff space.  And yes, I have more writing
> > to do to make more progress towards that goal.
> 
> So are you saying people should use smp_load_acquire(), or are you saying people
> should use READ_ONCE()?

C'mon, you know the answer to that!  ;-)

The answer is that it depends on both the people and the situation.

In the specific case of crng, where you need address dependency
ordering but the pointed-to data is dynamically allocated and never
deallocated, READ_ONCE() now suffices [1].  Of course, smp_load_acquire()
also suffices, at the cost of extra/expensive instructions on some
architectures.  The cmpxchg() needs at least release semantics, but
presumably no one cares if this operation is a bit more expensive than
it needs to be.

So, is select_crng() used on a fastpath?  If so, READ_ONCE()
might be necessary.  If not, why bother with anything stronger than
smp_load_acquire()?  The usual approach is to run this both ways on ARM
or PowerPC and see if it makes a significant difference.  If there is
no significant difference, keep it simple and just use smp_load_acquire().

If the code was sufficiently performance-insensitive, even better would
be to just use locking.  My hope is that no one bothered with the atomics
without a good reason, but you never know.

I confess some uncertainty as to how the transition from the global
primary_crng and the per-NUMA-node locks is handled.  I hope that the
global primary_crng guards global state that is disjoint from the state
being allocated by do_numa_crng_init()!

Use the simplest thing that gets the job done.  Which in the Linux kernel
often won't be all that simple, but life is like that sometimes.

							Thanx, Paul

[1]	It used to be that READ_ONCE() did -not- suffice on DEC Alpha,
	but this has thankfully changed, so that lockless_dereference()
	is no more.
