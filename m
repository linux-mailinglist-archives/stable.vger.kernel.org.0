Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD3C47B5C2
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 23:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbhLTWKR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 17:10:17 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48738 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbhLTWKQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 17:10:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D9DCB80EF5;
        Mon, 20 Dec 2021 22:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DFF0C36AE2;
        Mon, 20 Dec 2021 22:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640038214;
        bh=6S3AoJ0V2rPFudu6++OIYnOvCuu4iVaVPU/J0pTLGww=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AS30vpO3aG7VYjY30+uwwqGOMvkID5LAmMKUbfmAWZ5rX12C7tn4ZLNpUJR4kqftr
         bGOS17vPXN7neIhzKV4zpSzV7L2NP4DTH2GbKv4RKUeAzWAwOGUYMa1oIDlu8b6CX1
         c2FsS9A5dTTV5W+3IwbqzoI+hUXnSoRADzTcZh8zKRSgLW5VJYtLfZ6o4NEocAJFOH
         M6sjToOX6HK5uVL26ux9oR2pm8s4N07us1DbJhW8JS8uwBtflv2s8fAnhj3KLTE083
         BRujLRZuwQxNjrPQUtwAYCNlVswrQ1VkcxweUB/siIKX2hVXSXl7YrjvoIVsho2ecV
         PM5s85yx3Y9cQ==
Date:   Mon, 20 Dec 2021 16:10:11 -0600
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     "Paul E . McKenney" <paulmck@kernel.org>,
        Theodore Ts'o <tytso@mit.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH RESEND] random: use correct memory barriers for
 crng_node_pool
Message-ID: <YcD/QyNrhzs7kxBg@quark>
References: <20211219025139.31085-1-ebiggers@kernel.org>
 <CAHmME9pQ4vp0jHpOyQXHRbJ-xQKYapQUsWPrLouK=dMO56y1zA@mail.gmail.com>
 <20211220181115.GZ641268@paulmck-ThinkPad-P17-Gen-1>
 <CAHmME9qZDNz2uxPa13ZtBMT2RR+sP1OU=b73tcZ9BTD1T_MJOg@mail.gmail.com>
 <20211220183140.GC641268@paulmck-ThinkPad-P17-Gen-1>
 <YcDM2cpwiGCb56Gp@quark>
 <20211220190004.GD641268@paulmck-ThinkPad-P17-Gen-1>
 <CAHmME9rv9RZai-0diV6kdc9yfXRog29QiStEzDpC9v25OWY81Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9rv9RZai-0diV6kdc9yfXRog29QiStEzDpC9v25OWY81Q@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 20, 2021 at 10:45:15PM +0100, Jason A. Donenfeld wrote:
> Hi Paul,
> 
> On Mon, Dec 20, 2021 at 8:00 PM Paul E. McKenney <paulmck@kernel.org> wrote:
> > This assumes that the various crng_node_pool[i] pointers never change
> > while accessible to readers (and that some sort of synchronization applies
> > to the values in the pointed-to structure).  If these pointers do change,
> > then there also needs to be a READ_ONCE(pool[nid]) in select_crng(), where
> > the value returned from this READ_ONCE() is both tested and returned.
> > (As in assign this value to a temporary.)
> >
> > But if the various crng_node_pool[i] pointers really are constant
> > while readers can access them, then the cmpxchg_release() suffices.
> > The loads from pool[nid] are then data-race free, and because they
> > are unmarked, the compiler is prohibited from hoisting them out from
> > within the "if" statement.  The address dependency prohibits the
> > CPU from reordering them.
> 
> Right, this is just an initialization-time allocation and assignment,
> never updated or freed again after.
> 
> > So READ_ONCE() should be just fine.  Which answers Jason's question.  ;-)
> 
> Great. So v2 of this patch can use READ_ONCE then. Thanks!

Sure, I really don't care anymore.  If people want READ_ONCE() here, I'll use
it.  It seems that the people who really prefer smp_load_acquire() aren't on
this thread (unlike on
https://lore.kernel.org/linux-fsdevel/20200713033330.205104-1-ebiggers@kernel.org/T/#u
for example, where READ_ONCE() was rejected), so I guess that is what people are
going to agree on in this particular case.

- Eric
