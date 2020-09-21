Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F115C27369E
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 01:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728816AbgIUX0k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 19:26:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:43340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728704AbgIUX0k (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 19:26:40 -0400
Received: from paulmck-ThinkPad-P72.home (unknown [50.45.173.55])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02D7E239E5;
        Mon, 21 Sep 2020 23:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600730800;
        bh=PdtSI4PzV8ibEVyEopzSJggD0JPKAwMgjz6j615K62Q=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=LONBDLtA/0uYLnFlROFLDJ78+H6JWf4P5YJ7iJNv+98ZQJErzkI29lhHinUdCiATX
         YgiK9TnZAlgFAA+MXdFps0dQI1rBBtfMMgN4IfYCDgbztpq+hTwP8xHr7D7ucppWlr
         GJlZOIrbbNHB2oExkAEEOUXYD+Oa/DzHT995+Nvo=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id B240A35226C1; Mon, 21 Sep 2020 16:26:39 -0700 (PDT)
Date:   Mon, 21 Sep 2020 16:26:39 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Eric Biggers <ebiggers@kernel.org>, tytso@mit.edu,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] random: use correct memory barriers for crng_node_pool
Message-ID: <20200921232639.GK29330@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20200916233042.51634-1-ebiggers@kernel.org>
 <20200917072644.GA5311@gondor.apana.org.au>
 <20200917165802.GC855@sol.localdomain>
 <20200921081939.GA4193@gondor.apana.org.au>
 <20200921152714.GC29330@paulmck-ThinkPad-P72>
 <20200921221104.GA6556@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200921221104.GA6556@gondor.apana.org.au>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 22, 2020 at 08:11:04AM +1000, Herbert Xu wrote:
> On Mon, Sep 21, 2020 at 08:27:14AM -0700, Paul E. McKenney wrote:
> > On Mon, Sep 21, 2020 at 06:19:39PM +1000, Herbert Xu wrote:
> > > On Thu, Sep 17, 2020 at 09:58:02AM -0700, Eric Biggers wrote:
> > > >
> > > > smp_load_acquire() is obviously correct, whereas READ_ONCE() is an optimization
> > > > that is difficult to tell whether it's correct or not.  For trivial data
> > > > structures it's "easy" to tell.  But whenever there is a->b where b is an
> > > > internal implementation detail of another kernel subsystem, the use of which
> > > > could involve accesses to global or static data (for example, spin_lock()
> > > > accessing lockdep stuff), a control dependency can slip in.
> > > 
> > > If we're going to follow this line of reasoning, surely you should
> > > be converting the RCU derference first and foremost, no?
> 
> ...
> 
> > And to Eric's point, it is also true that when you have pointers to
> > static data, and when the compiler can guess this, you do need something
> > like smp_load_acquire().  But this is a problem only when you are (1)
> > using feedback-driven compiler optimization or (2) when you compare the
> > pointer to the address of the static data.
> 
> Let me restate what I think Eric is saying.  He is concerned about
> the case where a->b and b is some opaque object that may in turn
> dereference a global data structure unconnected to a.  The case
> in question here is crng_node_pool in drivers/char/random.c which
> in turn contains a spin lock.

As long as the compiler generates code that reaches that global via
pointer a, everything will work fine.  Which it will, unless the guy
writing the code makes the mistake of introducing a comparison between the
pointer to be dereferenced and the address of the global data structure.

So this is OK:

	p = rcu_dereference(a);
	do_something(p->b);

This is not OK:

	p = rcu_dereference(a);
	if (p == &some_global_variable)
		we_really_should_not_have_done_that_comparison();
	do_something(p->b);

The reason this last is not OK is because the compiler can transform
it as follows:

	p = rcu_dereference(a);
	if (p == &some_global_variable) {
		we_really_should_not_have_done_that_comparison();
		do_something(some_global_variable.b);
	} else {
		do_something(p->b);
	}

The compiler is not allowed to make up that sort of comparison, based
on my February 2020 discussion with the standards committee.

> But this reasoning could apply to any data structure that contains
> a spin lock, in particular ones that are dereferenced through RCU.

I lost you on this one.  What is special about a spin lock?

Here is what I think you mean:

	struct foo {
		spinlock_t lock;
		int a;
		char b;
		long c;
	};

	struct foo *a;

	...

	p = rcu_dereference(a);
	BUG_ON(!p);
	if (is_this_the_one(p)) {
		spin_lock(p->lock);
		do_something_else(p);
		spin_unlock(p->lock);
	}

This should be fine.  Or were you thinking of some other example?

> So my question if this reasoning is valid, then why aren't we first
> converting rcu_dereference to use smp_load_acquire?

For LTO in ARM, rumor has it that Will is doing so.  Which was what
motivated the BoF on this topic at Linux Plumbers Conference.

							Thanx, Paul
