Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE580280C72
	for <lists+stable@lfdr.de>; Fri,  2 Oct 2020 05:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387496AbgJBDHv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Oct 2020 23:07:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:56834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727780AbgJBDHu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 1 Oct 2020 23:07:50 -0400
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 693F4206FA;
        Fri,  2 Oct 2020 03:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601608070;
        bh=p+jy9vFdrMGf1fygPPsXK+kHuK5POrDvBTFckF58Op0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Lqd2ia1k7H16BMmxT9sAKMYZybuZH+G1KlKKdCZPX3W4tcyPLBqOPYBTgCQtX1Ghn
         zRYdDrCxH8qpmPyBDmOih8jXREDRE8GZeqHkfdxtf0TpPjRyAwcqvxMfISwcWNBZQn
         97B7bI9Rm6M74Pif37q8bBtnmKFqpLZUz3icAtTc=
Date:   Thu, 1 Oct 2020 20:07:31 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>, tytso@mit.edu,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] random: use correct memory barriers for crng_node_pool
Message-ID: <20201002030731.GA78003@sol.localdomain>
References: <20200921221104.GA6556@gondor.apana.org.au>
 <20200921232639.GK29330@paulmck-ThinkPad-P72>
 <20200921235243.GA32959@sol.localdomain>
 <20200922183100.GZ29330@paulmck-ThinkPad-P72>
 <20200922190936.GB1616407@gmail.com>
 <20200922205628.GD29330@paulmck-ThinkPad-P72>
 <20200922215558.GA1833749@gmail.com>
 <20200925005934.GA29330@paulmck-ThinkPad-P72>
 <20200925020908.GB1266@sol.localdomain>
 <20200925033102.GB29330@paulmck-ThinkPad-P72>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200925033102.GB29330@paulmck-ThinkPad-P72>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 24, 2020 at 08:31:02PM -0700, Paul E. McKenney wrote:
> On Thu, Sep 24, 2020 at 07:09:08PM -0700, Eric Biggers wrote:
> > On Thu, Sep 24, 2020 at 05:59:34PM -0700, Paul E. McKenney wrote:
> > > On Tue, Sep 22, 2020 at 02:55:58PM -0700, Eric Biggers wrote:
> > > > On Tue, Sep 22, 2020 at 01:56:28PM -0700, Paul E. McKenney wrote:
> > > > > > You're missing the point here.  b and c could easily be allocated by a function
> > > > > > alloc_b() that's in another file.
> > > > > 
> > > > > I am still missing something.
> > > > > 
> > > > > If by "allocated" you mean something like kmalloc(), the compiler doesn't
> > > > > know the address.  If you instead mean that there is a function that
> > > > > returns the address of another translation unit's static variable, then
> > > > > any needed ordering should preferably be built into that function's API.
> > > > > Either way, one would hope for some documentation of anything the caller
> > > > > needed to be careful of.
> > > > > 
> > > > > > > Besides which, control dependencies should be used only by LKMM experts
> > > > > > > at this point.  
> > > > > > 
> > > > > > What does that even mean?  Control dependencies are everywhere.
> > > > > 
> > > > > Does the following work better for you?
> > > > > 
> > > > > "... the non-local ordering properties of control dependencies should be
> > > > > relied on only by LKMM experts ...".
> > > > 
> > > > No.  I don't know what that means.  And I think very few people would know.
> > > > 
> > > > I just want to know if I use the one-time init pattern with a pointer to a data
> > > > structure foo, are the readers using foo_use() supposed to use READ_ONCE() or
> > > > are they supposed to use smp_load_acquire().
> > > > 
> > > > It seems the answer is that smp_load_acquire() is the only safe choice, since
> > > > foo_use() *might* involve a control dependency, or might in the future since
> > > > it's part of another kernel subsystem and its implementation could change.
> > > 
> > > First, the specific issue of one-time init.
> > > 
> > > If you are the one writing the code implementing one-time init, it is your
> > > choice.  It seems like you prefer smp_load_acquire().  If someone sees
> > > performance problems due to the resulting memory-barrier instructions,
> > > they have the option of submitting a patch and either forking the
> > > implementation or taking your implementation over from you, depending
> > > on how that conversation goes.
> > 
> > It doesn't matter what I "prefer".  The question is, how to write code that is
> > actually guaranteed to be correct on all supported Linux architectures, without
> > assuming internal implementation details of other kernel subsystems.
> 
> And that question allows ample room for personal preferences.
> 
> There are after all tradeoffs.  Do you want to live within the current
> knowledge of your users, or are you willing to invest time and energy
> into teaching them something new?  If someone wants a level of performance
> that is accommodated only by a difficult-to-use pattern, will you choose
> to accommodate them, or will you tell them to build write their own?
> 
> There are often a number of ways to make something work, and they all
> have advantages and disadvantages.  There are tradeoffs, and preferences
> have a role to play as well.

Having options doesn't matter if no one can agree on which one to use.  This is
the second bug fix that I can't get accepted due to bikeshedding over how to
implement "one-time init":

First patch:
v1: https://lkml.kernel.org/linux-fsdevel/20200713033330.205104-1-ebiggers@kernel.org
v2: https://lkml.kernel.org/linux-fsdevel/20200717050510.95832-1-ebiggers@kernel.org
Related thread: https://lkml.kernel.org/lkml/20200717044427.68747-1-ebiggers@kernel.org

Second patch (this one):
https://lkml.kernel.org/lkml/20200916233042.51634-1-ebiggers@kernel.org

The problem is identical in both cases.  In both cases, the code currently
implements "one-time init" using a plain load on the reader side, which is
undefined behavior and isn't sufficient on all supported Linux architectures
(even *if* there is no control dependency, which is something that usually is
hard to determine, as I've explained several times).

However in both cases, no one can agree on what to replace the broken code with.
And the opinions were conflicting.  In the first patch, people were advocating
for smp_load_acquire() over READ_ONCE() because it's too hard to determine when
READ_ONCE() is safe.  And even after I switched to smp_load_acquire(), the patch
was still rejected, with conflicting reasons.

Now in the second patch, people are instead advocating for READ_ONCE() over
smp_load_acquire().  And you're claiming that all kernel developers are expected
to read Documentation/RCU/rcu_dereference.rst and design all allocation
functions to be usable in combination with rcu_dereference() or READ_ONCE().
(Tough luck if anyone didn't do that, I guess!)

So what actually happens is that no one agrees on a fix, so the obviously broken
code just gets left as-is.

Now, I don't have unlimited patience, so in the end I'm just going to let that
happen, and let it be Someone Else's problem to fix these bugs months/years down
the line when they happen to cause a "real" problem, or are detected by KCSAN,
etc.  It certainly seems like a bad outcome, though.

> If alloc_foo() also initializes static data, then it really should have
> some name other than alloc_foo().

Not necessarily.  It could do one-time-init of static data, e.g. a workqueue or
a mempool.  See fscrypt_initialize() (called by fscrypt_get_encryption_info())
for a real-world example of this.  The fscrypt_bounce_page_pool uses a
significant amount of memory, so we only allocate it if someone actually is
going to need it.

Are you disputing that that's a reasonable thing to do?  There's a lot of kernel
code that does something like this.

- Eric
