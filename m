Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E58527357B
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 00:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728423AbgIUWLN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 18:11:13 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:40618 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726457AbgIUWLM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 18:11:12 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kKU1Y-00067N-Dc; Tue, 22 Sep 2020 08:11:05 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 22 Sep 2020 08:11:04 +1000
Date:   Tue, 22 Sep 2020 08:11:04 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     Eric Biggers <ebiggers@kernel.org>, tytso@mit.edu,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] random: use correct memory barriers for crng_node_pool
Message-ID: <20200921221104.GA6556@gondor.apana.org.au>
References: <20200916233042.51634-1-ebiggers@kernel.org>
 <20200917072644.GA5311@gondor.apana.org.au>
 <20200917165802.GC855@sol.localdomain>
 <20200921081939.GA4193@gondor.apana.org.au>
 <20200921152714.GC29330@paulmck-ThinkPad-P72>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200921152714.GC29330@paulmck-ThinkPad-P72>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 21, 2020 at 08:27:14AM -0700, Paul E. McKenney wrote:
> On Mon, Sep 21, 2020 at 06:19:39PM +1000, Herbert Xu wrote:
> > On Thu, Sep 17, 2020 at 09:58:02AM -0700, Eric Biggers wrote:
> > >
> > > smp_load_acquire() is obviously correct, whereas READ_ONCE() is an optimization
> > > that is difficult to tell whether it's correct or not.  For trivial data
> > > structures it's "easy" to tell.  But whenever there is a->b where b is an
> > > internal implementation detail of another kernel subsystem, the use of which
> > > could involve accesses to global or static data (for example, spin_lock()
> > > accessing lockdep stuff), a control dependency can slip in.
> > 
> > If we're going to follow this line of reasoning, surely you should
> > be converting the RCU derference first and foremost, no?

...

> And to Eric's point, it is also true that when you have pointers to
> static data, and when the compiler can guess this, you do need something
> like smp_load_acquire().  But this is a problem only when you are (1)
> using feedback-driven compiler optimization or (2) when you compare the
> pointer to the address of the static data.

Let me restate what I think Eric is saying.  He is concerned about
the case where a->b and b is some opaque object that may in turn
dereference a global data structure unconnected to a.  The case
in question here is crng_node_pool in drivers/char/random.c which
in turn contains a spin lock.

But this reasoning could apply to any data structure that contains
a spin lock, in particular ones that are dereferenced through RCU.

So my question if this reasoning is valid, then why aren't we first
converting rcu_dereference to use smp_load_acquire?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
