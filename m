Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8D14274828
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 20:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726629AbgIVSbC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 14:31:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:32770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726526AbgIVSbC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Sep 2020 14:31:02 -0400
Received: from paulmck-ThinkPad-P72.home (unknown [50.45.173.55])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF8842065D;
        Tue, 22 Sep 2020 18:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600799461;
        bh=ereZaQWFcbMl4ja5mHMSHcgn49wMxqEQqu40GRB+s6g=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=MjW4gCQkLV3BGHnVSuQJqRS3UFo85MCYRNQC4e5/X3OWQGz1BIC/hA1JHdfS8HFOv
         sXqHgjZx3qVNXLpk8QHiEBJfWqK4sGlPyULate4wlyTDF+lrYhPbiJZLiw0pIlspSU
         SLHL+/Un6dpNjbcEXfa1za0MIZQvRZ5wlm5K05sM=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id A9CC835227BD; Tue, 22 Sep 2020 11:31:00 -0700 (PDT)
Date:   Tue, 22 Sep 2020 11:31:00 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>, tytso@mit.edu,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] random: use correct memory barriers for crng_node_pool
Message-ID: <20200922183100.GZ29330@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20200916233042.51634-1-ebiggers@kernel.org>
 <20200917072644.GA5311@gondor.apana.org.au>
 <20200917165802.GC855@sol.localdomain>
 <20200921081939.GA4193@gondor.apana.org.au>
 <20200921152714.GC29330@paulmck-ThinkPad-P72>
 <20200921221104.GA6556@gondor.apana.org.au>
 <20200921232639.GK29330@paulmck-ThinkPad-P72>
 <20200921235243.GA32959@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200921235243.GA32959@sol.localdomain>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 21, 2020 at 04:52:43PM -0700, Eric Biggers wrote:
> On Mon, Sep 21, 2020 at 04:26:39PM -0700, Paul E. McKenney wrote:
> > On Tue, Sep 22, 2020 at 08:11:04AM +1000, Herbert Xu wrote:
> > > On Mon, Sep 21, 2020 at 08:27:14AM -0700, Paul E. McKenney wrote:
> > > > On Mon, Sep 21, 2020 at 06:19:39PM +1000, Herbert Xu wrote:
> > > > > On Thu, Sep 17, 2020 at 09:58:02AM -0700, Eric Biggers wrote:
> > > > > >
> > > > > > smp_load_acquire() is obviously correct, whereas READ_ONCE() is an optimization
> > > > > > that is difficult to tell whether it's correct or not.  For trivial data
> > > > > > structures it's "easy" to tell.  But whenever there is a->b where b is an
> > > > > > internal implementation detail of another kernel subsystem, the use of which
> > > > > > could involve accesses to global or static data (for example, spin_lock()
> > > > > > accessing lockdep stuff), a control dependency can slip in.
> > > > > 
> > > > > If we're going to follow this line of reasoning, surely you should
> > > > > be converting the RCU derference first and foremost, no?
> > > 
> > > ...
> > > 
> > > > And to Eric's point, it is also true that when you have pointers to
> > > > static data, and when the compiler can guess this, you do need something
> > > > like smp_load_acquire().  But this is a problem only when you are (1)
> > > > using feedback-driven compiler optimization or (2) when you compare the
> > > > pointer to the address of the static data.
> > > 
> > > Let me restate what I think Eric is saying.  He is concerned about
> > > the case where a->b and b is some opaque object that may in turn
> > > dereference a global data structure unconnected to a.  The case
> > > in question here is crng_node_pool in drivers/char/random.c which
> > > in turn contains a spin lock.
> > 
> > As long as the compiler generates code that reaches that global via
> > pointer a, everything will work fine.  Which it will, unless the guy
> > writing the code makes the mistake of introducing a comparison between the
> > pointer to be dereferenced and the address of the global data structure.
> > 
> > So this is OK:
> > 
> > 	p = rcu_dereference(a);
> > 	do_something(p->b);
> > 
> > This is not OK:
> > 
> > 	p = rcu_dereference(a);
> > 	if (p == &some_global_variable)
> > 		we_really_should_not_have_done_that_comparison();
> > 	do_something(p->b);
> 
> If you call some function that's an internal implementation detail of some other
> kernel subsystem, how do you know it doesn't do that?

If the only globals I insert into my linked data structure are local to my
compilation unit, then the internal implementation details of some other
kernel subsystem in some other translation unit cannot do that comparison.

> Also, it's not just the p == &global_variable case.  Consider:
> 
> struct a { struct b *b; };
> struct b { ... };
> 
> Thread 1:
> 
> 	/* one-time initialized data shared by all instances of b */
> 	static struct c *c;
> 
> 	void init_b(struct a *a)
> 	{
> 		if (!c)
> 			c = alloc_c();
> 
> 		smp_store_release(&a->b, kzalloc(sizeof(struct b)));
> 	}
> 
> Thread 2:
> 
> 	void use_b_if_present(struct a *a)
> 	{
> 		struct b *b = READ_ONCE(a->b);
> 
> 		if (b) {
> 			c->... # crashes because c still appears to be NULL
> 		}
> 	}
> 
> 
> So when the *first* "b" is allocated, the global data "c" is initialized.  Then
> when using a "b", we expect to be able to access "c".  But there's no
> data dependency from "b" to "c"; it's a control dependency only.
> So smp_load_acquire() is needed, not READ_ONCE().
> 
> And it can be an internal implementation detail of "b"'s subsystem whether it
> happens to use global data "c".

Given that "c" is static, these two subsystems must be in the same
translation unit.  So I don't see how this qualifies as being internal to
"b"'s subsystem.

Besides which, control dependencies should be used only by LKMM experts
at this point.  Yes, we are trying to get the compiler people to give us
a way to tell the compiler about dependencies that we need to preserve,
but in the meantime, you beed to be really careful how you use them,
and you need to make sure that your external API can be used without
creating traps like the one you are driving at.

> This sort of thing is why people objected to the READ_ONCE() optimization during
> the discussion at
> https://lkml.kernel.org/linux-fsdevel/20200717044427.68747-1-ebiggers@kernel.org/T/#u.
> Most kernel developers aren't experts in the LKMM, and they want something
> that's guaranteed to be correct without having to to think really hard about it
> and make assumptions about the internal implementation details of other
> subsystems, how compilers have implemented the C standard, and so on.

And smp_load_acquire()is provided for that reason.  Its name was
even based on the nomenclature used in the C standard and elsewhere.
And again, control dependencies are for LKMM experts, as they are very
tricky to get right.

But in the LKMM documentation, you are likely to find LKMM experts who
want to optimize all the way, particularly in cases like the one-time
init pattern where all the data is often local.  And the best basis for
READ_ONCE() in one-time init is not a control dependency, but rather
ordering of accesses to a single variable from a single task combined
with locking, both of which are quite robust and much easier to use,
especially in comparison to control dependencies.

My goal for LKMM is not that each and every developer have a full
understanding of every nook and cranny of that model, but instead that
people can find the primitives supporting the desired point in the
performance/simplicity tradoff space.  And yes, I have more writing
to do to make more progress towards that goal.

							Thanx, Paul
