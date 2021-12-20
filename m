Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F83B47B354
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 20:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233889AbhLTTAJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 14:00:09 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:38936 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240632AbhLTTAJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 14:00:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 394C7CE1257;
        Mon, 20 Dec 2021 19:00:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5486AC36AE8;
        Mon, 20 Dec 2021 19:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640026805;
        bh=rwYeJ/de83n49NCu9Q3vsserOc6YR2pZGMXISJrudiw=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=dXhNCD2xXVvBQSGAz3la62v/bCIV7bf4CEZC3/CKFE+Y1uJn9XeORWmh/V+Vp9Oc1
         hJRX7be53GZICEOgdrrMjiC8l28b02ShdGP8z+9C4Nu4wUiSkVxI6TP8nP4+mR0APP
         9YRuBHL0Kp15NHHuy7clsaijsEX8btVNn0vt+THza5Mp0E2IFAXE6q/zW87ONmZGsT
         exW6mUmvSVyEKyRrJzVNUBb+XWvPxvSH49kbGlnJNqHyeYdKny2hVZUaCE33JVyL+z
         FRA8uGmGOwxK/Gf/9a6muZtvBhKjSAGY5f649yQxK+Ehrgpx/HPyMEf0ijmXyBaDEF
         TV54SqI7kqTJA==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 01D3D5C1610; Mon, 20 Dec 2021 11:00:04 -0800 (PST)
Date:   Mon, 20 Dec 2021 11:00:04 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Theodore Ts'o <tytso@mit.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH RESEND] random: use correct memory barriers for
 crng_node_pool
Message-ID: <20211220190004.GD641268@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20211219025139.31085-1-ebiggers@kernel.org>
 <CAHmME9pQ4vp0jHpOyQXHRbJ-xQKYapQUsWPrLouK=dMO56y1zA@mail.gmail.com>
 <20211220181115.GZ641268@paulmck-ThinkPad-P17-Gen-1>
 <CAHmME9qZDNz2uxPa13ZtBMT2RR+sP1OU=b73tcZ9BTD1T_MJOg@mail.gmail.com>
 <20211220183140.GC641268@paulmck-ThinkPad-P17-Gen-1>
 <YcDM2cpwiGCb56Gp@quark>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YcDM2cpwiGCb56Gp@quark>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 20, 2021 at 12:35:05PM -0600, Eric Biggers wrote:
> On Mon, Dec 20, 2021 at 10:31:40AM -0800, Paul E. McKenney wrote:
> > On Mon, Dec 20, 2021 at 07:16:48PM +0100, Jason A. Donenfeld wrote:
> > > On Mon, Dec 20, 2021 at 7:11 PM Paul E. McKenney <paulmck@kernel.org> wrote:
> > > > First I would want
> > > 
> > > It looks like you've answered my question with four other questions,
> > > which seem certainly technically warranted, but also indicates we're
> > > probably not going to get to the nice easy resting place of, "it is
> > > safe; go for it" that I was hoping for. In light of that, it seems
> > > like merging Eric's patch is reasonable.
> > 
> > My hope would be that the questions can be quickly answered by the
> > developers and maintainers.  But yes, hope springs eternal.
> > 
> > 							Thanx, Paul
> 
> I wouldn't expect READ_ONCE() to provide a noticable performance improvement
> here, as it would be lost in the noise of the other work done, especially
> chacha20_block().
> 
> The data structures in question are never freed, so your other questions are
> irrelevant, if I understand correctly.

Very good, and thank you!  You are correct, if the structures never are
freed, there is no use-after-free issue.  And that also explains why I
was not able to find the free path.  ;-)

So the main issue is the race between insertion and lookup.  So yes,
READ_ONCE() suffices.

This assumes that the various crng_node_pool[i] pointers never change
while accessible to readers (and that some sort of synchronization applies
to the values in the pointed-to structure).  If these pointers do change,
then there also needs to be a READ_ONCE(pool[nid]) in select_crng(), where
the value returned from this READ_ONCE() is both tested and returned.
(As in assign this value to a temporary.)

But if the various crng_node_pool[i] pointers really are constant
while readers can access them, then the cmpxchg_release() suffices.
The loads from pool[nid] are then data-race free, and because they
are unmarked, the compiler is prohibited from hoisting them out from
within the "if" statement.  The address dependency prohibits the
CPU from reordering them.

So READ_ONCE() should be just fine.  Which answers Jason's question.  ;-)

Looking at _extract_crng(), if this was my code, I would use READ_ONCE()
in the checks, but that might be my misunderstanding boot-time constraints
or some such.  Without some sort of constraint, I don't see how the code
avoids confusion from reloads of crng->init_time if two CPUs concurrently
see the expiration of CRNG_RESEED_INTERVAL, but I could easily be missing
something that makes this safe.  (And this is irrelevant to this patch.)

You do appear to have ->lock guarding the pointed-to data, so that
is good.

							Thanx, Paul
