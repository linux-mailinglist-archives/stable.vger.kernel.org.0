Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC2E58226E
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 10:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbiG0IvJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 04:51:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbiG0IvI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 04:51:08 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 436DFB1F8;
        Wed, 27 Jul 2022 01:51:07 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oGckr-004wDf-BI; Wed, 27 Jul 2022 18:50:58 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 27 Jul 2022 16:50:57 +0800
Date:   Wed, 27 Jul 2022 16:50:57 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-wireless@vger.kernel.org, kvalo@kernel.org,
        stable@vger.kernel.org, Gregory Erwin <gregerwin256@gmail.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        "Eric W . Biederman" <ebiederm@xmission.com>, vschneid@redhat.com
Subject: Re: [PATCH RESEND v11] hwrng: core - let sleep be interrupted when
 unregistering hwrng
Message-ID: <YuD8ccbQ/Oh68/5+@gondor.apana.org.au>
References: <20220725215536.767961-1-Jason@zx2c4.com>
 <Yt+3ic4YYpAsUHMF@gondor.apana.org.au>
 <Yt+/HvfC+OYRVrr+@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yt+/HvfC+OYRVrr+@zx2c4.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jason:

On Tue, Jul 26, 2022 at 12:17:02PM +0200, Jason A. Donenfeld wrote:
>
> Yea, I actually didn't consider this a bug, but just "nothing starts
> until everything else is totally done" semantics. Not wanting those
> semantics is understandable. I haven't looked in detail at how you've

The issue is when you switch from one hwrng to another, this could
cause a user-space reader to fail during the switch-over.  Granted
it's not a big deal but the fix isn't that onerous.

> done that safely without locking issues, but if you've tested it, then I
> trust it works. When I was playing around with different things, I
> encountered a number of locking issues, depending on what the last
> locker was - a user space thread, the rng kthread, or something opening
> up a reader afresh. So just be sure the various combinations still work.

Yes this is subtle and I don't plan on pushing this into mainline
right away.

> Specifically, Instead of doing all of this task interruption stuff and
> keeping track of readers and using RCU and all that fragile code, we
> can instead just use wait_completion_interruptible_timeout() inside of
> hwrng_msleep(), using a condition variable that's private to the hwrng.
> Then, when it's time for all the readers to quit, we just set the
> condition! Ta-da, no need for keeping track of who's reading, the
> difference between a kthread and a normal thread, and a variety of other
> concerns.

Yes, using a higher-level abstraction than wake_up_process/schedule
is always preferred.

> Unimportant nit: could call __rng_dying() instead so these don't diverge
> by accident.

Good idea, I will do this in the next repost.

> > @@ -269,6 +298,9 @@ static ssize_t rng_dev_read(struct file *filp, char __user *buf,
> >  		}
> >  	}
> >  out:
> > +	if (synch)
> > +		synchronize_rcu();
> 
> The synch usage no longer makes sense to me here. In my version,
> synchronize_rcu() would almost never be called. It's only purpose was to
> prevent rng_dev_read() from returning if the critical section inside of
> hwrng_unregister() was in flight. But now it looks like it will be
> called everytime there are no RNGs left? Or maybe I understood how this
> works. Either way, please don't feel that you have to write back an
> explanation; just make sure it has those same sorts of semantics when
> testing.

The purpose is still the same, prevent the current thread from going
away while the RCU critical-section in hwrng_unregister is ongoing.

With my code the synch is triggered if we obtained an rng, then
potentially went to sleep (wait == true), and upon finishing we
found that the rng is undergoing unregistration (rng_dying == true).

If we switch to completions then this issue goes away because we
will be using standard wait queues instead of our own
current_waiting_reader.
 
> Here you made a change whose utility I don't understand. My original
> hunk was:
> 
> +                       if (kthread_should_stop())
> +                               break;
> +                       schedule_timeout_interruptible(HZ * 10);
> 
> Which I think is a bit cleaner, as schedule_timeout_interruptible sets
> the state to INTERRUPTIBLE and such.

Valentin has already explained this.  This is the standard paradigm
for calling schedule_timeout when you need to ensure that a specific
condition wakes up the thread.  But as you suggested using a higher-
level mechanism such as completions will render this unnecessary.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
