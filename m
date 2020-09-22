Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2EC2748A9
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 20:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbgIVS7e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 14:59:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:38378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726563AbgIVS7d (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Sep 2020 14:59:33 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A3DD206F4;
        Tue, 22 Sep 2020 18:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600801173;
        bh=T+ja20+KkhDc/68kT+bFCy5o4/aJH6M/ZBfoymLFxzg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=w7b1TIv64cEk9yVwIBRYvfjUzFFFmmlLGOCdd893DjTqMuwznP1nMRlivv0CzJuob
         +pxKc7odISQbQDQ5K7IPLaTvKAVRlXMvCy4q0/on9fMb34fU3ojSGNBFTUIxSHd9bc
         GetbtticD8jpr1MSvmVygpkzz9oqaM8/cNDwClFQ=
Date:   Tue, 22 Sep 2020 11:59:31 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>, tytso@mit.edu,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] random: use correct memory barriers for crng_node_pool
Message-ID: <20200922185931.GA1616407@gmail.com>
References: <20200916233042.51634-1-ebiggers@kernel.org>
 <20200917072644.GA5311@gondor.apana.org.au>
 <20200917165802.GC855@sol.localdomain>
 <20200921081939.GA4193@gondor.apana.org.au>
 <20200921152714.GC29330@paulmck-ThinkPad-P72>
 <20200921221104.GA6556@gondor.apana.org.au>
 <20200921232639.GK29330@paulmck-ThinkPad-P72>
 <20200921235136.GA6796@gondor.apana.org.au>
 <20200922184243.GA29330@paulmck-ThinkPad-P72>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200922184243.GA29330@paulmck-ThinkPad-P72>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 22, 2020 at 11:42:43AM -0700, Paul E. McKenney wrote:
> On Tue, Sep 22, 2020 at 09:51:36AM +1000, Herbert Xu wrote:
> > On Mon, Sep 21, 2020 at 04:26:39PM -0700, Paul E. McKenney wrote:
> > >
> > > > But this reasoning could apply to any data structure that contains
> > > > a spin lock, in particular ones that are dereferenced through RCU.
> > > 
> > > I lost you on this one.  What is special about a spin lock?
> > 
> > I don't know, that was Eric's concern.  He is inferring that
> > spin locks through lockdep debugging may trigger dependencies
> > that require smp_load_acquire.
> > 
> > Anyway, my point is if it applies to crng_node_pool then it
> > would equally apply to RCU in general.
> 
> Referring to the patch you call out below...
> 
> Huh.  The old cmpxchg() primitive is fully ordered, so the old mb()
> preceding it must have been for correctly interacting with hardware on
> !SMP systems.  If that is the case, then the use of cmpxchg_release()
> is incorrect.  This is not the purview of the memory model, but rather
> of device-driver semantics.  Or does crng not (or no longer, as the case
> might be) interact with hardware RNGs?

No hardware involved here.  The mb() is just unnecessary, as I noted in my patch
https://lore.kernel.org/lkml/20200916233042.51634-1-ebiggers@kernel.org/.

> What prevents either the old or the new code from kfree()ing the old
> state out from under another CPU that just now picked up a pointer to the
> old state?  The combination of cmpxchg_release() and smp_load_acquire()
> won't do anything to prevent this from happening.  This is after all not
> a memory-ordering issue, but instead an object-lifetime issue.  But maybe
> you have a lock or something that provides the needed protection.  I don't
> see how this can be the case and still require the cmpxchg_release()
> and smp_load_acquire(), but perhaps this is a failure of imagination on
> my part.

crng_node_pool is initialized only once, and never freed.

- Eric
