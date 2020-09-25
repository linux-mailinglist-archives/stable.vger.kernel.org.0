Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8767C277E8E
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 05:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbgIYDbF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Sep 2020 23:31:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:58326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726704AbgIYDbE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 24 Sep 2020 23:31:04 -0400
Received: from paulmck-ThinkPad-P72.home (unknown [50.45.173.55])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D433C21D7F;
        Fri, 25 Sep 2020 03:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601004662;
        bh=No0v42lTSVeOXLz1Vqcqp3DddJiLfwhHQr01fwsf+Jk=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=HDhzfZrE62zA+QyKAIGaUz/sK1IiNn9gxrGcfcni5ngwA+daJOriNlmrvAxLhR8yr
         0s/XMBsRqWTWkUCgn9VYWcUH65DK8zuFhWh+ILSYWJ9LVjjVn273qjYHbPH4p7f15J
         K594YTFRr1/7FG4ScXs47k7ZXtZQMJAAC9ykNToY=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 85C1935230AC; Thu, 24 Sep 2020 20:31:02 -0700 (PDT)
Date:   Thu, 24 Sep 2020 20:31:02 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>, tytso@mit.edu,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] random: use correct memory barriers for crng_node_pool
Message-ID: <20200925033102.GB29330@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20200921152714.GC29330@paulmck-ThinkPad-P72>
 <20200921221104.GA6556@gondor.apana.org.au>
 <20200921232639.GK29330@paulmck-ThinkPad-P72>
 <20200921235243.GA32959@sol.localdomain>
 <20200922183100.GZ29330@paulmck-ThinkPad-P72>
 <20200922190936.GB1616407@gmail.com>
 <20200922205628.GD29330@paulmck-ThinkPad-P72>
 <20200922215558.GA1833749@gmail.com>
 <20200925005934.GA29330@paulmck-ThinkPad-P72>
 <20200925020908.GB1266@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200925020908.GB1266@sol.localdomain>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 24, 2020 at 07:09:08PM -0700, Eric Biggers wrote:
> On Thu, Sep 24, 2020 at 05:59:34PM -0700, Paul E. McKenney wrote:
> > On Tue, Sep 22, 2020 at 02:55:58PM -0700, Eric Biggers wrote:
> > > On Tue, Sep 22, 2020 at 01:56:28PM -0700, Paul E. McKenney wrote:
> > > > > You're missing the point here.  b and c could easily be allocated by a function
> > > > > alloc_b() that's in another file.
> > > > 
> > > > I am still missing something.
> > > > 
> > > > If by "allocated" you mean something like kmalloc(), the compiler doesn't
> > > > know the address.  If you instead mean that there is a function that
> > > > returns the address of another translation unit's static variable, then
> > > > any needed ordering should preferably be built into that function's API.
> > > > Either way, one would hope for some documentation of anything the caller
> > > > needed to be careful of.
> > > > 
> > > > > > Besides which, control dependencies should be used only by LKMM experts
> > > > > > at this point.  
> > > > > 
> > > > > What does that even mean?  Control dependencies are everywhere.
> > > > 
> > > > Does the following work better for you?
> > > > 
> > > > "... the non-local ordering properties of control dependencies should be
> > > > relied on only by LKMM experts ...".
> > > 
> > > No.  I don't know what that means.  And I think very few people would know.
> > > 
> > > I just want to know if I use the one-time init pattern with a pointer to a data
> > > structure foo, are the readers using foo_use() supposed to use READ_ONCE() or
> > > are they supposed to use smp_load_acquire().
> > > 
> > > It seems the answer is that smp_load_acquire() is the only safe choice, since
> > > foo_use() *might* involve a control dependency, or might in the future since
> > > it's part of another kernel subsystem and its implementation could change.
> > 
> > First, the specific issue of one-time init.
> > 
> > If you are the one writing the code implementing one-time init, it is your
> > choice.  It seems like you prefer smp_load_acquire().  If someone sees
> > performance problems due to the resulting memory-barrier instructions,
> > they have the option of submitting a patch and either forking the
> > implementation or taking your implementation over from you, depending
> > on how that conversation goes.
> 
> It doesn't matter what I "prefer".  The question is, how to write code that is
> actually guaranteed to be correct on all supported Linux architectures, without
> assuming internal implementation details of other kernel subsystems.

And that question allows ample room for personal preferences.

There are after all tradeoffs.  Do you want to live within the current
knowledge of your users, or are you willing to invest time and energy
into teaching them something new?  If someone wants a level of performance
that is accommodated only by a difficult-to-use pattern, will you choose
to accommodate them, or will you tell them to build write their own?

There are often a number of ways to make something work, and they all
have advantages and disadvantages.  There are tradeoffs, and preferences
have a role to play as well.

> > Third, your first pointer-based variant works with smp_load_acquire(),
> > but could instead use READ_ONCE() as long as it is reworked to something
> > like this:
> > 
> > 	static struct foo *foo;
> > 	static DEFINE_MUTEX(foo_init_mutex);
> > 
> > 	// The returned pointer must be handled carefully in the same
> > 	// way as would a pointer returned from rcu_derefeference().
> > 	// See Documentation/RCU/rcu_dereference.rst.
> > 	struct foo *init_foo_if_needed(void)
> > 	{
> > 		int err = 0;
> > 		struct foo *retp;
> > 
> > 		/* pairs with smp_store_release() below */
> > 		retp = READ_ONCE(foo);
> > 		if (retp)
> > 			return retp;
> > 
> > 		mutex_lock(&foo_init_mutex);
> > 		if (!foo) {
> > 			// The compiler doesn't know the address:
> > 			struct foo *p = alloc_foo();
> > 
> > 			if (p) /* pairs with smp_load_acquire() above */
> > 				smp_store_release(&foo, p);
> > 			else
> > 				err = -ENOMEM;
> > 		}
> > 		mutex_unlock(&foo_init_mutex);
> > 		return err;
> > 	}
> > 
> > There are more than 2,000 instances of the rcu_dereference() family of
> > primitives in the v5.8 kernel, so it should not be hard to find people
> > who are familiar with it.  TL;DR:  Just dereference the pointer and you
> > will be fine.
> 
> I don't understand why you are saying READ_ONCE() is safe here.  alloc_foo()
> could very well initialize some static data as well as foo itself, and after
> 'if (retp)', use_foo() can be called that happens to use the static data as well
> as foo itself.  That's a control dependency that would require
> smp_load_acquire(); is it not?  And if foo is some object managed by another
> kernel subsystem, that can easily happen without this code being specifically
> aware of the implementation detail that actually causes the control dependency.

If alloc_foo() also initializes static data, then it really should have
some name other than alloc_foo().

But yes, if it does initialize static data, you are back at the earlier
examples.  For this variant to work, either the initialization must
be confined to the foo pointer and the pointed-to data on the one hand,
or some additional synchronization is required for users wishing to
access the static data on the other.

So to reiterate, in order to correctly use the above pattern, you
must confine the initialization to the structure referenced by the
foo pointer.  Otherwise, you need to use some other pattern.

Apologies if that was not clear.

> Also just because there are 2000 instances of rcu_dereference() doesn't mean
> kernel developers understand the pitfalls of using it.  Especially since
> real-world problems would only be seen very rarely on specific CPU architectures
> and/or if some seemingly unrelated kernel code changes.

I would be more worried about the compiler than the CPU.  And yet these
instances do seem to work.

> > > Let me give an example using spinlock_t, since that's used in crng_node_pool.
> > > However, it could be any other data structure too; this is *just an example*.
> > > And it doesn't matter if the implementation is currently different; the point is
> > > that it's an *implementation*.
> > > 
> > > The allocation side uses spin_lock_init(), while the read side uses spin_lock().
> > > Let's say that some debugging feature is enabled where spin locks use some
> > > global debugging information (say, a list of all locks) that gets allocated the
> > > first time a spin lock is initialized:
> > > 
> > > 	static struct spin_lock_debug_info *debug_info;
> > > 	static DEFINE_MUTEX(debug_info_alloc_mutex);
> > > 
> > > 	void spin_lock_init(spinlock_t *lock)
> > > 	{
> > > 	#ifdef CONFIG_DEBUG_SPIN_LOCKS
> > > 		mutex_lock(&debug_info_alloc_mutex);
> > > 		if (!debug_info)
> > > 			debug_info = alloc_debug_info();
> > > 		add_lock(debug_info, lock);
> > > 		mutex_unlock(&debug_info_alloc_mutex);
> > > 	#endif
> > > 		real_spin_lock_init(lock);
> > > 	}
> > > 
> > > 	void spin_lock(spinlock_t *lock)
> > > 	{
> > > 	#ifdef CONFIG_DEBUG_SPIN_LOCKS
> > > 		debug_info->...; # use the debug info
> > > 	#endif
> > > 		real_spin_lock(lock);
> > > 	}
> > > 
> > > In that case, readers would have a control dependency between the condition of
> > > the data struct containing the spinlock_t being non-NULL, and the dereference of
> > > debug_info by spin_lock().  So anyone "receiving" a data structure containing a
> > > spinlock_t would need to use smp_load_acquire(), not READ_ONCE().
> > 
> > Sorry, no.
> > 
> > The user had jolly well better make -very- sure that the call to
> > spin_lock_init() is ordered before any call to spin_lock().  Running
> > spin_lock() concurrently with spin_lock_init() will bring you nothing
> > but sorrow, even without that debug_info control-dependency issue.
> 
> The example was one-time init of a data structure containing a spin lock.
> Like the patch this thread is about:
> https://lkml.kernel.org/lkml/20200916233042.51634-1-ebiggers@kernel.org
> 
> So you're saying that smp_load_acquire() is needed, since otherwise
> spin_lock_init() won't be fully ordered before spin_lock()?

I am absolutely not, repeat, -not-, saying that.

Let's assume that my variation on your alloc_foo() example is used.
For simplicity, let's assume the first one using the lock.  A very
similar line of reasoning works for the cmpxchg().

And I -am- assuming that the spinlock is in the newly allocated structure
(and I cannot tell whether or not this is the case from your patch).
I am also assuming that the pointer is stored with smp_store_release()
or stronger, and that all of the initialization (including that of the
spinlock) is carried out by code preceding the smp_store_release().
I am also assuming that users get the foo pointer only by calling 
init_foo_if_needed(), and have no sort of "side-channel" access
to the spinlock.

Then the pointer is not in memory until after the foo structure is
initialized (including the spinlock) and the user picks up the pointer
before using the spinlock.  As noted in in my paragraph immediately
below, this provides the needed ordering so that spin_lock() and
spin_lock_init() never run concurrently.

But a key point is that all of these usage patterns come with restrictions.
If you want to make use of a given pattern, you will need to abide by
its restrictions.

Which should be no surprise.  There are also restrictions when using
things like locking, it is just that a lot of people are very accustomed
to abiding by those restrictions.  But fail to acquire the lock where
you should have or acquire a pair of locks in the wrong order and life
will get very bad.

> > In the various one-time init examples, the required ordering would be
> > correctly supplied if spin_lock_init() was invoked by init_foo() or
> > alloc_foo(), depending on the example, and used only after a successful
> > return from init_foo_if_needed().  None of these examples rely on control
> > dependencies.
> 
> ... or are you saying that READ_ONCE() provides the required full ordering
> between spin_lock_init() and spin_lock()?  If so, why, and is it guaranteed
> independent of the implementation of these functions?

Single operations do not provide ordering, instead pairs of operations
provide ordering.  Hence the phrase "memory-barrier pairing".

If the pointer returned by the READ_ONCE() is handled properly
(rcu_dereference.rst again), then the combination of that READ_ONCE()
and the proper handling on the one hand and the ordering of foo_alloc()
and the smp_store_release() on the other provides the needed ordering.

Which makes sense when you think about it.  If either side fails to do
its part to provide the needed ordering, then there won't be ordering.

So you do need to think about both sides to reason about ordering.

In theory, you also need to do this with locking, but most people use
shortcuts of the form "I hold this lock, so nothing can change unless I
change it."  Which is an excellent way to think about locks, at least
until such time as you are the guy who is implementing the locking
primitive itself.

> Please explain in English.

Oh.  My apologies.  What language have I been writing in?

							Thanx, Paul
