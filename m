Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20B702748CF
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 21:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbgIVTJj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 15:09:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:49878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726563AbgIVTJj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Sep 2020 15:09:39 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C77D2311C;
        Tue, 22 Sep 2020 19:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600801778;
        bh=1Fpf8eJo8TwJEOCRt2MDpMSY1auJh2VGI5xd3lo4Hto=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=C9wihmF6R9vVO3Vmey2GbvWQsO1LdDECdDcw0l2Kk6tRwtuS0+fkraukdD8+F5GsA
         Km9X+3pa2yapmz7UQEzEukq5ZR10dJGYimdYwhYwBn7hlnF1Z9DJIvysAAcLk+FV6I
         imvBO3zR8umw4GKMIty+z7VmkuuXAEzCKa9UbGC0=
Date:   Tue, 22 Sep 2020 12:09:36 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>, tytso@mit.edu,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] random: use correct memory barriers for crng_node_pool
Message-ID: <20200922190936.GB1616407@gmail.com>
References: <20200916233042.51634-1-ebiggers@kernel.org>
 <20200917072644.GA5311@gondor.apana.org.au>
 <20200917165802.GC855@sol.localdomain>
 <20200921081939.GA4193@gondor.apana.org.au>
 <20200921152714.GC29330@paulmck-ThinkPad-P72>
 <20200921221104.GA6556@gondor.apana.org.au>
 <20200921232639.GK29330@paulmck-ThinkPad-P72>
 <20200921235243.GA32959@sol.localdomain>
 <20200922183100.GZ29330@paulmck-ThinkPad-P72>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200922183100.GZ29330@paulmck-ThinkPad-P72>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 22, 2020 at 11:31:00AM -0700, Paul E. McKenney wrote:
> > Also, it's not just the p == &global_variable case.  Consider:
> > 
> > struct a { struct b *b; };
> > struct b { ... };
> > 
> > Thread 1:
> > 
> > 	/* one-time initialized data shared by all instances of b */
> > 	static struct c *c;
> > 
> > 	void init_b(struct a *a)
> > 	{
> > 		if (!c)
> > 			c = alloc_c();
> > 
> > 		smp_store_release(&a->b, kzalloc(sizeof(struct b)));
> > 	}
> > 
> > Thread 2:
> > 
> > 	void use_b_if_present(struct a *a)
> > 	{
> > 		struct b *b = READ_ONCE(a->b);
> > 
> > 		if (b) {
> > 			c->... # crashes because c still appears to be NULL
> > 		}
> > 	}
> > 
> > 
> > So when the *first* "b" is allocated, the global data "c" is initialized.  Then
> > when using a "b", we expect to be able to access "c".  But there's no
> > data dependency from "b" to "c"; it's a control dependency only.
> > So smp_load_acquire() is needed, not READ_ONCE().
> > 
> > And it can be an internal implementation detail of "b"'s subsystem whether it
> > happens to use global data "c".
> 
> Given that "c" is static, these two subsystems must be in the same
> translation unit.  So I don't see how this qualifies as being internal to
> "b"'s subsystem.

You're missing the point here.  b and c could easily be allocated by a function
alloc_b() that's in another file.

> Besides which, control dependencies should be used only by LKMM experts
> at this point.  

What does that even mean?  Control dependencies are everywhere.

> > This sort of thing is why people objected to the READ_ONCE() optimization during
> > the discussion at
> > https://lkml.kernel.org/linux-fsdevel/20200717044427.68747-1-ebiggers@kernel.org/T/#u.
> > Most kernel developers aren't experts in the LKMM, and they want something
> > that's guaranteed to be correct without having to to think really hard about it
> > and make assumptions about the internal implementation details of other
> > subsystems, how compilers have implemented the C standard, and so on.
> 
> And smp_load_acquire()is provided for that reason.  Its name was
> even based on the nomenclature used in the C standard and elsewhere.
> And again, control dependencies are for LKMM experts, as they are very
> tricky to get right.

How does a developer know that the code they're calling in another subsystem
wasn't written by one of these "experts" and therefore has a control dependency?

> 
> But in the LKMM documentation, you are likely to find LKMM experts who
> want to optimize all the way, particularly in cases like the one-time
> init pattern where all the data is often local.  And the best basis for
> READ_ONCE() in one-time init is not a control dependency, but rather
> ordering of accesses to a single variable from a single task combined
> with locking, both of which are quite robust and much easier to use,
> especially in comparison to control dependencies.
> 
> My goal for LKMM is not that each and every developer have a full
> understanding of every nook and cranny of that model, but instead that
> people can find the primitives supporting the desired point in the
> performance/simplicity tradoff space.  And yes, I have more writing
> to do to make more progress towards that goal.

So are you saying people should use smp_load_acquire(), or are you saying people
should use READ_ONCE()?

- Eric
