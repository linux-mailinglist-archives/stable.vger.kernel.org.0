Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC5427486A
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 20:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726629AbgIVSmp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 14:42:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:42160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726573AbgIVSmp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Sep 2020 14:42:45 -0400
Received: from paulmck-ThinkPad-P72.home (unknown [50.45.173.55])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1F5E20756;
        Tue, 22 Sep 2020 18:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600800163;
        bh=vWdBLoVbkQK0uBB8eLz4Qke3ppIS989P2MuC9zKvAMw=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=uejHr0y9cNmKAwGL07lfg133P1ZjGlWsE+gBUg3tZNpPPo/klhhbPYhlHosi022Mz
         1VPCueCo3XG3Kev1BDVX4ZcB7aOjEnToG2NZZrnxuoI0VwgPAQw54KchH1uUMaFAKM
         e3uJ4bcRi8aq4SWS/xasVIjPPiWOY8MvStpWdQ0s=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 8AFB335227BD; Tue, 22 Sep 2020 11:42:43 -0700 (PDT)
Date:   Tue, 22 Sep 2020 11:42:43 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Eric Biggers <ebiggers@kernel.org>, tytso@mit.edu,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] random: use correct memory barriers for crng_node_pool
Message-ID: <20200922184243.GA29330@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20200916233042.51634-1-ebiggers@kernel.org>
 <20200917072644.GA5311@gondor.apana.org.au>
 <20200917165802.GC855@sol.localdomain>
 <20200921081939.GA4193@gondor.apana.org.au>
 <20200921152714.GC29330@paulmck-ThinkPad-P72>
 <20200921221104.GA6556@gondor.apana.org.au>
 <20200921232639.GK29330@paulmck-ThinkPad-P72>
 <20200921235136.GA6796@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200921235136.GA6796@gondor.apana.org.au>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 22, 2020 at 09:51:36AM +1000, Herbert Xu wrote:
> On Mon, Sep 21, 2020 at 04:26:39PM -0700, Paul E. McKenney wrote:
> >
> > > But this reasoning could apply to any data structure that contains
> > > a spin lock, in particular ones that are dereferenced through RCU.
> > 
> > I lost you on this one.  What is special about a spin lock?
> 
> I don't know, that was Eric's concern.  He is inferring that
> spin locks through lockdep debugging may trigger dependencies
> that require smp_load_acquire.
> 
> Anyway, my point is if it applies to crng_node_pool then it
> would equally apply to RCU in general.

Referring to the patch you call out below...

Huh.  The old cmpxchg() primitive is fully ordered, so the old mb()
preceding it must have been for correctly interacting with hardware on
!SMP systems.  If that is the case, then the use of cmpxchg_release()
is incorrect.  This is not the purview of the memory model, but rather
of device-driver semantics.  Or does crng not (or no longer, as the case
might be) interact with hardware RNGs?

What prevents either the old or the new code from kfree()ing the old
state out from under another CPU that just now picked up a pointer to the
old state?  The combination of cmpxchg_release() and smp_load_acquire()
won't do anything to prevent this from happening.  This is after all not
a memory-ordering issue, but instead an object-lifetime issue.  But maybe
you have a lock or something that provides the needed protection.  I don't
see how this can be the case and still require the cmpxchg_release()
and smp_load_acquire(), but perhaps this is a failure of imagination on
my part.

I am guessing that this lifetime issue prompted RCU to be introduced
into this discussion.  This would be one way of handling the lifetime
of the pool[] array and the objects that its elements point to, but at
some cost in either latency or memory footprint for synchronize_rcu()
and call_rcu(), respectively.

Or am I missing something subtle here?

> > > So my question if this reasoning is valid, then why aren't we first
> > > converting rcu_dereference to use smp_load_acquire?
> > 
> > For LTO in ARM, rumor has it that Will is doing so.  Which was what
> > motivated the BoF on this topic at Linux Plumbers Conference.
> 
> Sure, if RCU switches over to smp_load_acquire then I would have
> no problems with everybody else following in its footsteps.

The x86 guys might well be OK with this change, but I would guess that
the ARM and PowerPC guys might have some heartburn.  ;-)

> Here is the original patch in question:
> 
> https://lore.kernel.org/lkml/20200916233042.51634-1-ebiggers@kernel.org/

Thank you for the pointer!  I freely confess that I was wondering what
this was all about.

							Thanx, Paul
