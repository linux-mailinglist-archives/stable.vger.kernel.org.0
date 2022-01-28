Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7ACB49FDC4
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 17:15:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237858AbiA1QPT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jan 2022 11:15:19 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:44062 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231809AbiA1QPT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jan 2022 11:15:19 -0500
Date:   Fri, 28 Jan 2022 17:15:16 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1643386518;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VBViI4uY6fc6A9UyuARwG6HNG03Ob1A8pMIqU4tpHvY=;
        b=aO4q3d3xLLpgFgFIPUQYAHc4wL+JvN3+E9qIbhBUAviG401Yy7/q/hS3r/4C8DQPI9WbHV
        2sPWKITrcjs7iThP0gpUuKi8OCi+Ok3G6Bjv1A0Zw7CZbRE4+d/a9Fw22LdK1i+kYYTIZc
        DeYz5DTwPCvTI4JB5Hxrh1JMoKwLmw832w6xutFVmR89EbT1HZ+9a0DUT9vg1ph3pxMbpx
        6GWLQSN1jJugvc1Kchx01gEfQenK4cJwC7FiNYzP6gu7gwom0EUIyPEPPwCIwBArI+/mw4
        a9X+lYo20f/htbWUJczPkC9oqW0kPuVef8l08LuvQzH8SXGJCK+6jJ5T6YZmYA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1643386518;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VBViI4uY6fc6A9UyuARwG6HNG03Ob1A8pMIqU4tpHvY=;
        b=2TmNd0GUXxQfSi4Q6BFiM0FDo0GV6ihhfw9o0bWhyXpJrozCYLr7ElZfquWQ6qHYBNh0bH
        F0pJvpy7iNyv+pCg==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Jonathan =?utf-8?Q?Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        Theodore Ts'o <tytso@mit.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Andy Lutomirski <luto@kernel.org>,
        stable <stable@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] random: remove batched entropy locking
Message-ID: <YfQWlM9b4l2IO43l@linutronix.de>
References: <CAHmME9pb9A4SN6TTjNvvxKqw1L3gXVOX7KKihfEH4AgKGNGZ2A@mail.gmail.com>
 <20220128153344.34211-1-Jason@zx2c4.com>
 <YfQPVp8TULSq3V+l@linutronix.de>
 <CAHmME9pmdeLBKJbTaVQv-z9J81qKA=R4uoZ1DeXABy6Lt3bXuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHmME9pmdeLBKJbTaVQv-z9J81qKA=R4uoZ1DeXABy6Lt3bXuA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022-01-28 16:54:06 [+0100], Jason A. Donenfeld wrote:
> Hi Sebastian,
Hi Jason,

> On Fri, Jan 28, 2022 at 4:44 PM Sebastian Andrzej Siewior
> <bigeasy@linutronix.de> wrote:
> > NO. Could we please look at my RANDOM patches first?
> > I can repost my rebased patched if there no objection.
> 
> I did, and my reply is here:
> https://lore.kernel.org/lkml/CAHmME9pzdXyD0oRYyCoVUSqqsA9h03-oR7kcNhJuPEcEMTJYgw@mail.gmail.com/
> 
> I was hoping for a series that addresses these issues. As I mentioned
> before, I'm not super keen on deferring that processing in a
> conditional case and having multiple entry ways into that same
> functionality. I don't think that's worth it, especially if your
> actual concern is just userspace calling RNDADDTOENTCNT too often
> (which can be safely ratelimited). I don't think that thread needs to

And what do you do in ratelimiting? As I explained, you get 20 that
"enter" and the following are block. The first 20 are already
problematic and you need a plan-B for those that can't enter.
So I suggested a mutex_t around the ioctl() which would act as a rate
limiting. You did not not follow up on that idea.

> spill over here, though, so feel free to follow up with a v+1 on that
> series and I'll happily take a look. Alternatively, if you'd like to
> approach this by providing a patch for Jonathan's issue, that makes
> sense too. So far, the things in front of me are: 1) your patchset
> from last month that has unresolved issues, and 2) Andy's thing, which
> maybe will solve the problem (or it won't?). A third alternative from
> you would be most welcome too.

I made a reply yesterday I think with some numbers yesterday. From my
point of view it is an in-IRQ context/ code that can be avoided. The
RNDADDTOENTCNT is a simple way to hammer on the lock and see how bad it
gets. Things like add_hwgenerator_randomness() don't appear so often so
it is hard to figure out what the worst case can be.

Please ignore Jonathan report for now. As I tried to explain: This
lockdep report shows a serious problem on PREEMPT_RT. There is _no_ need
to be concerned on a non-PREEMPT_RT kernel. But it should be addressed.
If this gets merged as-is then thanks to the stable tag it will get
backported (again no change for !RT) and will collide with PREEMPT_RT
patch. And as I mentioned, the locking is not working on PREEMPT_RT.

> Jason

Sebastian
