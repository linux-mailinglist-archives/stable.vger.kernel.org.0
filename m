Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C6FB287BBA
	for <lists+stable@lfdr.de>; Thu,  8 Oct 2020 20:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728965AbgJHSb5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Oct 2020 14:31:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:47546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725874AbgJHSb4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Oct 2020 14:31:56 -0400
Received: from paulmck-ThinkPad-P72.home (50-39-104-11.bvtn.or.frontiernet.net [50.39.104.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E6B322200;
        Thu,  8 Oct 2020 18:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602181915;
        bh=/aAfecfkmBKYBL/aBElW9UNRrslMtRkvllHeRPBoY5c=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=O/gYXpLVEgxa4L/VW0Ijz+TgEzSUNQ6BEPog+r0onxxsPfbh65LKcKGrSxtzHUfQI
         zoNi1JZb0kdfxRE0ofg9DJ0uvVh8i66qSKUS1Y3TpkRSns4sfJkNktp/fq1TRx75ox
         3vqecFAIm+BktPNi8Y1c5UY5ZURMDstxxX/ePfzw=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 1B25635228D5; Thu,  8 Oct 2020 11:31:55 -0700 (PDT)
Date:   Thu, 8 Oct 2020 11:31:55 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>, tytso@mit.edu,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] random: use correct memory barriers for crng_node_pool
Message-ID: <20201008183155.GY29330@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20200921232639.GK29330@paulmck-ThinkPad-P72>
 <20200921235243.GA32959@sol.localdomain>
 <20200922183100.GZ29330@paulmck-ThinkPad-P72>
 <20200922190936.GB1616407@gmail.com>
 <20200922205628.GD29330@paulmck-ThinkPad-P72>
 <20200922215558.GA1833749@gmail.com>
 <20200925005934.GA29330@paulmck-ThinkPad-P72>
 <20200925020908.GB1266@sol.localdomain>
 <20200925033102.GB29330@paulmck-ThinkPad-P72>
 <20201002030731.GA78003@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201002030731.GA78003@sol.localdomain>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 01, 2020 at 08:07:31PM -0700, Eric Biggers wrote:
> On Thu, Sep 24, 2020 at 08:31:02PM -0700, Paul E. McKenney wrote:
> > On Thu, Sep 24, 2020 at 07:09:08PM -0700, Eric Biggers wrote:
> > > On Thu, Sep 24, 2020 at 05:59:34PM -0700, Paul E. McKenney wrote:
> > > > On Tue, Sep 22, 2020 at 02:55:58PM -0700, Eric Biggers wrote:
> > > > > On Tue, Sep 22, 2020 at 01:56:28PM -0700, Paul E. McKenney wrote:
> > > > > > > You're missing the point here.  b and c could easily be allocated by a function
> > > > > > > alloc_b() that's in another file.
> > > > > > 
> > > > > > I am still missing something.
> > > > > > 
> > > > > > If by "allocated" you mean something like kmalloc(), the compiler doesn't
> > > > > > know the address.  If you instead mean that there is a function that
> > > > > > returns the address of another translation unit's static variable, then
> > > > > > any needed ordering should preferably be built into that function's API.
> > > > > > Either way, one would hope for some documentation of anything the caller
> > > > > > needed to be careful of.
> > > > > > 
> > > > > > > > Besides which, control dependencies should be used only by LKMM experts
> > > > > > > > at this point.  
> > > > > > > 
> > > > > > > What does that even mean?  Control dependencies are everywhere.
> > > > > > 
> > > > > > Does the following work better for you?
> > > > > > 
> > > > > > "... the non-local ordering properties of control dependencies should be
> > > > > > relied on only by LKMM experts ...".
> > > > > 
> > > > > No.  I don't know what that means.  And I think very few people would know.
> > > > > 
> > > > > I just want to know if I use the one-time init pattern with a pointer to a data
> > > > > structure foo, are the readers using foo_use() supposed to use READ_ONCE() or
> > > > > are they supposed to use smp_load_acquire().
> > > > > 
> > > > > It seems the answer is that smp_load_acquire() is the only safe choice, since
> > > > > foo_use() *might* involve a control dependency, or might in the future since
> > > > > it's part of another kernel subsystem and its implementation could change.
> > > > 
> > > > First, the specific issue of one-time init.
> > > > 
> > > > If you are the one writing the code implementing one-time init, it is your
> > > > choice.  It seems like you prefer smp_load_acquire().  If someone sees
> > > > performance problems due to the resulting memory-barrier instructions,
> > > > they have the option of submitting a patch and either forking the
> > > > implementation or taking your implementation over from you, depending
> > > > on how that conversation goes.
> > > 
> > > It doesn't matter what I "prefer".  The question is, how to write code that is
> > > actually guaranteed to be correct on all supported Linux architectures, without
> > > assuming internal implementation details of other kernel subsystems.
> > 
> > And that question allows ample room for personal preferences.
> > 
> > There are after all tradeoffs.  Do you want to live within the current
> > knowledge of your users, or are you willing to invest time and energy
> > into teaching them something new?  If someone wants a level of performance
> > that is accommodated only by a difficult-to-use pattern, will you choose
> > to accommodate them, or will you tell them to build write their own?
> > 
> > There are often a number of ways to make something work, and they all
> > have advantages and disadvantages.  There are tradeoffs, and preferences
> > have a role to play as well.
> 
> Having options doesn't matter if no one can agree on which one to use.  This is
> the second bug fix that I can't get accepted due to bikeshedding over how to
> implement "one-time init":

I understand that this situation could be quite frustrating, but we
can only expect a memory model to model memory.  Its job is to help us
understand what can work and what will not work from a memory-ordering
perspective, which at best will provide you with the options that you
seem to be so dissatisfied with.  The memory model is quite incapable of
browbeating intransigent human beings into agreeing on which option should
be used in a given situation.  This last never was a requirement of the
LKMM project.  Please rest assured that it will remain a non-requirement.

> First patch:
> v1: https://lkml.kernel.org/linux-fsdevel/20200713033330.205104-1-ebiggers@kernel.org
> v2: https://lkml.kernel.org/linux-fsdevel/20200717050510.95832-1-ebiggers@kernel.org
> Related thread: https://lkml.kernel.org/lkml/20200717044427.68747-1-ebiggers@kernel.org
> 
> Second patch (this one):
> https://lkml.kernel.org/lkml/20200916233042.51634-1-ebiggers@kernel.org
> 
> The problem is identical in both cases.  In both cases, the code currently
> implements "one-time init" using a plain load on the reader side, which is
> undefined behavior and isn't sufficient on all supported Linux architectures
> (even *if* there is no control dependency, which is something that usually is
> hard to determine, as I've explained several times).

For this particular problem, please forget about control dependencies.
In theory, yes, you can construct situations in which control dependencies
would be useful for one-time init, but in practice all of the situations
I can think of are extremely strange, even my my standards.

> However in both cases, no one can agree on what to replace the broken code with.
> And the opinions were conflicting.  In the first patch, people were advocating
> for smp_load_acquire() over READ_ONCE() because it's too hard to determine when
> READ_ONCE() is safe.  And even after I switched to smp_load_acquire(), the patch
> was still rejected, with conflicting reasons.

Been there, done that.  Still there, still doing that, actually.

So welcome to my world!

> Now in the second patch, people are instead advocating for READ_ONCE() over
> smp_load_acquire().  And you're claiming that all kernel developers are expected
> to read Documentation/RCU/rcu_dereference.rst and design all allocation
> functions to be usable in combination with rcu_dereference() or READ_ONCE().
> (Tough luck if anyone didn't do that, I guess!)

Not quite.

I will suspend disbelief for the moment, and for the remainder of this
email I will act as if I am absolutely certain that you are not making
an especially clumsy attempt to troll me.

What I am claiming is that -if- a particular kernel developer wishes to
-fully- explore -all- of the possible implementations of one-time init,
-then-, and only then -that- -particular- kernel developer will need to
know a great deal about the Linux-kernel memory model.  That particular
kernel developer might (as you suggest above) carefully read a bunch
of documentation in the kernel source tree.  I would advise that kernel
developer to also learn to use the herd7 tool, but different developers
will have different preferences.  Which is OK.

But most kernel developers will not need any understanding at all of the
Linux-kernel memory model.  Most will be able to continue to use APIs that
hide this memory-ordering complexity.  In fact, hiding this complexity
is an advantage of a well-designed and agreed-upon one-time init API.

> So what actually happens is that no one agrees on a fix, so the obviously broken
> code just gets left as-is.
> 
> Now, I don't have unlimited patience, so in the end I'm just going to let that
> happen, and let it be Someone Else's problem to fix these bugs months/years down
> the line when they happen to cause a "real" problem, or are detected by KCSAN,
> etc.  It certainly seems like a bad outcome, though.

My plate is quite full at the moment, so I will not be doing this work.

But yes, it does appear that you are suffering the consequences
of C. Northcote Parkinson's Law of Triviality, from which the term
"bikeshedding" arose.  I am sorry, but I do not have a general solution
to the bikeshedding problem, other than the usual recommendations of
patience, persistence, and taking care to fully understand the mindsets
of the people making all the conflicting recommendations and objections.

Besides, the ability to deal with this sort of thing will be quite
valuable to you, and you cannot learn it any younger!

> > If alloc_foo() also initializes static data, then it really should have
> > some name other than alloc_foo().
> 
> Not necessarily.  It could do one-time-init of static data, e.g. a workqueue or
> a mempool.  See fscrypt_initialize() (called by fscrypt_get_encryption_info())
> for a real-world example of this.  The fscrypt_bounce_page_pool uses a
> significant amount of memory, so we only allocate it if someone actually is
> going to need it.

There is no reason you cannot place the corresponding pointers, handles,
or whatever into the dynamically allocated block of memory, and do so
before doing the store-release of the pointer.  Then the users access
the workqueue, mempool, or whatever via this same pointer and everything
works out.

And if "someone actually is going to need it" means that different
portions of the initialization happen at different times, then there is
no reason why you cannot just use multiple instances of the one-time
init pattern, with the always-initialized data being handled by the
first instance and the only-somtimes-initialized data being handled by
the other instances.

> Are you disputing that that's a reasonable thing to do?  There's a lot of kernel
> code that does something like this.

If you wish to actually solve this problem, you are going to have to face
up to the fact that you are going to have to make some choices, and no
matter what set of choices you make, there will be people who are unhappy.
You will then either need to convince a critical mass of people of the
wisdom of your choices or adjust your choices to get a critical mass
on board.  If you do not wish to take on this particular challenge, your
best strategy is of course to stop complaining about it and take up other
challenges that are more technical and less people-oriented in nature.

On the off-chance that you wish to continue with one-time init, I am
reiterating your choices:

1.	Fully locked.  Acquire the lock every time the one-time init
	primitive is invoked.  The biggest advantage of this approach
	is that almost all kernel developers will easily understand
	how this works, in happy contrast with the developers back in
	the 1980s and 1990s.  Too bad about the lack of scalability,
	but if used infrequently enough, so what?

2.	Release and acquire, as discussed earlier in this thread.  Great
	scalability once initialization has completed, OK performance.
	The set of kernel developers who understand this is somewhat
	smaller than that for locking, but there is still no shortage
	of kernel developers who could successfully develop and maintain
	a one-time init facility based on release and acquire.

	Both #1 and #2 have the advantage of handling the case where
	the initialized data is scattered and completely disorganized.

3.	Like #2, but use either rcu_dereference() or READ_ONCE() in place
	of the smp_load_acquire(), replace the flag with a pointer to the
	to-be-initialized data, dynamically allocate memory for this data,
	and make very sure that -all- of the data resides in this memory.

	The payoff for #3's requirement that the developers abide by
	all of these restrictions is improved performance compared to
	#2 and especially to #1.  On all architectures, the compiler
	will have greater freedom to optimize.	On some architectures,
	the explicit memory-barrier instructions required for #1 and #2
	may be omitted for #3.

4.	Strange approaches (even by my standards) that I will ignore
	unless they are proven to be necessary.

All the memory model can do is to tell you that these approaches all work,
at least assuming everyone follows the corresponding rules.

Figuring out which of these options to actually use required reviewing
all of the use cases, determining the performance and scalability
requirements, and figuring out whether the affected developers are
willing and able to abide by the corresponding usage restrictions.
And, perhaps hardest, convincing a critical mass of developers to
actually agree on something.

It is quite possible that more than one of the options will be required.
For example, it might turn out that both #2 and #3 are needed.

This is actually the common case.  Just look at all the locking primitives
in the kernel if you doubt this.  Which is of course yet another way
to make people unhappy.  But again, no matter what you do in this area,
there will be unhappy people.  ;-)

							Thanx, Paul
