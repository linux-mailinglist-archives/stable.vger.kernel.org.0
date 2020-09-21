Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17748272A04
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 17:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbgIUP1P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 11:27:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:48752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726830AbgIUP1P (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 11:27:15 -0400
Received: from paulmck-ThinkPad-P72.home (unknown [50.45.173.55])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5EA1320866;
        Mon, 21 Sep 2020 15:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600702034;
        bh=YJvzUB9leI7F/NEWLg34ssIzJCylohdw5W4A2beB+KQ=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=Xw6usfJAVa7s/FL5gt11m0r8FUfpZTI8o+RYkvXOykCQ0OxZfKq2liSv9RTt38L0h
         HfdR92BAnSC2ZN9wQk0nVEQV/2DZ+LhMIK3nwV3/23qpB+msV06KJPbxINj8CyV5EQ
         9OOlSw0I0v7p/BuhXr15rvFMVCa0r6jeh15sAWqk=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 28C6435227BD; Mon, 21 Sep 2020 08:27:14 -0700 (PDT)
Date:   Mon, 21 Sep 2020 08:27:14 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Eric Biggers <ebiggers@kernel.org>, tytso@mit.edu,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] random: use correct memory barriers for crng_node_pool
Message-ID: <20200921152714.GC29330@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20200916233042.51634-1-ebiggers@kernel.org>
 <20200917072644.GA5311@gondor.apana.org.au>
 <20200917165802.GC855@sol.localdomain>
 <20200921081939.GA4193@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200921081939.GA4193@gondor.apana.org.au>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 21, 2020 at 06:19:39PM +1000, Herbert Xu wrote:
> On Thu, Sep 17, 2020 at 09:58:02AM -0700, Eric Biggers wrote:
> >
> > smp_load_acquire() is obviously correct, whereas READ_ONCE() is an optimization
> > that is difficult to tell whether it's correct or not.  For trivial data
> > structures it's "easy" to tell.  But whenever there is a->b where b is an
> > internal implementation detail of another kernel subsystem, the use of which
> > could involve accesses to global or static data (for example, spin_lock()
> > accessing lockdep stuff), a control dependency can slip in.
> 
> If we're going to follow this line of reasoning, surely you should
> be converting the RCU derference first and foremost, no?

Agreed, rcu_dereference() is preferred over READ_ONCE() when reading
RCU-protected pointers.  Much better debugging support, if nothing else.

However, as part of making the kernel safe from DEC Alpha, READ_ONCE()
does protect against reading and dereferencing pointers to objects
concurrently being inserted into a linked data structure.  If they are
never removed (or are removed only when there are known to be no readers),
RCU is not required.

And to Eric's point, it is also true that when you have pointers to
static data, and when the compiler can guess this, you do need something
like smp_load_acquire().  But this is a problem only when you are (1)
using feedback-driven compiler optimization or (2) when you compare the
pointer to the address of the static data.

And yes, we are still working to be able to tell the compiler when
a pointer carries a dependency, but this continues to be slow going.  :-/

							Thanx, Paul
