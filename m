Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2B85810F8
	for <lists+stable@lfdr.de>; Tue, 26 Jul 2022 12:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232849AbiGZKRQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jul 2022 06:17:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238389AbiGZKRO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jul 2022 06:17:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0975225EA6;
        Tue, 26 Jul 2022 03:17:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 639B7B811C6;
        Tue, 26 Jul 2022 10:17:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 103FDC341D0;
        Tue, 26 Jul 2022 10:17:07 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="M7ZoEezg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1658830625;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MpDOk1GScqopQf+kC+V0RbnLSraVH8JVg6WqMIaw9BM=;
        b=M7ZoEezgN1Sim7p/YL/H/gk7RP9tL5d5+may1OrUFjoIrf8CCNKxY24nUpZS/P5XqkfmfB
        ranpCy23glhNWo1adUIW5u588K0H4PEofrx3nimpSYbQRlJe5YyudBqmwxGjI3S1csk2WI
        eH3wf3gfqK8LYgq3HSCO9tudJdXrQeg=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 0d6d35c7 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 26 Jul 2022 10:17:04 +0000 (UTC)
Date:   Tue, 26 Jul 2022 12:17:02 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-wireless@vger.kernel.org, kvalo@kernel.org,
        stable@vger.kernel.org, Gregory Erwin <gregerwin256@gmail.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        "Eric W . Biederman" <ebiederm@xmission.com>, vschneid@redhat.com
Subject: Re: [PATCH RESEND v11] hwrng: core - let sleep be interrupted when
 unregistering hwrng
Message-ID: <Yt+/HvfC+OYRVrr+@zx2c4.com>
References: <20220725215536.767961-1-Jason@zx2c4.com>
 <Yt+3ic4YYpAsUHMF@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Yt+3ic4YYpAsUHMF@gondor.apana.org.au>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Herbert,

On Tue, Jul 26, 2022 at 05:44:41PM +0800, Herbert Xu wrote:
> Thanks for all your effort in resolving this issue.
> 
> I think Valentin's concern is valid though.  The sleep/wakeup paradigm
> in this patch-set is slightly unusual.
> 
> So what I've done is taken your latest patch, and incorporated
> Valentin's suggestions on top of it.  I don't think there is an
> issue with other drivers as neither approach really changes them.

Thanks so much for taking charge of this patch. I really, really
appreciate it. I'm also glad that we now have a working implementation
of Valentin's suggestion.

Just two small notes:
- I had a hard time testing everything because I don't actually have an
  ath9k, so I wound up playing with variations on
  https://xn--4db.cc/vnRj8zQw/diff in case that helps. I assume you've
  got your own way of testing things, but in case not, maybe that diff
  is useful.
- I'll mark this patch as "other tree" in the wireless tree's patchwork
  now that you're on board so Kalle doesn't have to deal with it.

> In between the setting and clearing of current_waiting_reader,
> a reader that gets a new RNG may fail simply because it detected
> the value of UNREGITERING_READER.

Yea, I actually didn't consider this a bug, but just "nothing starts
until everything else is totally done" semantics. Not wanting those
semantics is understandable. I haven't looked in detail at how you've
done that safely without locking issues, but if you've tested it, then I
trust it works. When I was playing around with different things, I
encountered a number of locking issues, depending on what the last
locker was - a user space thread, the rng kthread, or something opening
up a reader afresh. So just be sure the various combinations still work.

Also, I like the encapsulation you did with hwrng_msleep(). That's a
very clean way of accomplishing what Valentin suggested, a lot cleaner
than the gunk I had in mind would be required. It also opens up a
different approach for fixing this, which is what I would have preferred
from the beginning, but the prereq kernel work hadn't landed yet.

Specifically, Instead of doing all of this task interruption stuff and
keeping track of readers and using RCU and all that fragile code, we
can instead just use wait_completion_interruptible_timeout() inside of
hwrng_msleep(), using a condition variable that's private to the hwrng.
Then, when it's time for all the readers to quit, we just set the
condition! Ta-da, no need for keeping track of who's reading, the
difference between a kthread and a normal thread, and a variety of other
concerns.

That won't be possible until 5.20, though, and this patch is needed to
fix earlier kernels, so the intermediate step here is still required.
But please keep this on the back burner of your mind. The 5.20
enablement patch for that is here:

https://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git/commit/?h=for-next&id=a7c01fa93aeb03ab76cd3cb2107990dd160498e6

When developing that patch, I had used my little test harness above and
hwrng to test that it worked as intended. But I hadn't thought of an
elegant way of plumbing the condition through without changing up tons
of callsites. However, now you've come up with this hwrng_msleep()
solution to that. So now all the puzzle pieces are ready for a 5.20 fix
moving this toward the nicer condition setup.

A few odd unimportant comments below:

> +/* rng_dying without a barrier.  Use this if there is a barrier elsewhere. */
> +static inline bool __rng_dying(struct hwrng *rng)
> +{
> +	return list_empty(&rng->list);
> +}
> +
> +static inline bool rng_dying(struct hwrng *rng)
> +{
> +	/*
> +	 * This barrier pairs with the one in
> +	 * hwrng_unregister.  This ensures that
> +	 * we see any attempt to unregister rng.
> +	 */
> +	smp_mb();
> +	return list_empty(&rng->list);

Unimportant nit: could call __rng_dying() instead so these don't diverge
by accident.

> +}
> +
>  static size_t rng_buffer_size(void)
>  {
>  	return SMP_CACHE_BYTES < 32 ? 32 : SMP_CACHE_BYTES;
> @@ -204,6 +225,7 @@ static inline int rng_get_data(struct hwrng *rng, u8 *buffer, size_t size,
>  static ssize_t rng_dev_read(struct file *filp, char __user *buf,
>  			    size_t size, loff_t *offp)
>  {
> +	int synch = false;
>  	ssize_t ret = 0;
>  	int err = 0;
>  	int bytes_read, len;
> @@ -225,9 +247,16 @@ static ssize_t rng_dev_read(struct file *filp, char __user *buf,
>  			goto out_put;
>  		}
>  		if (!data_avail) {
> +			bool wait = !(filp->f_flags & O_NONBLOCK);
> +
> +			if (wait)
> +				current_waiting_reader = current;
>  			bytes_read = rng_get_data(rng, rng_buffer,
> -				rng_buffer_size(),
> -				!(filp->f_flags & O_NONBLOCK));
> +				rng_buffer_size(), wait);
> +			if (wait) {
> +				current_waiting_reader = NULL;
> +				synch |= rng_dying(rng);
> +			}
>  			if (bytes_read < 0) {
>  				err = bytes_read;
>  				goto out_unlock_reading;
> @@ -269,6 +298,9 @@ static ssize_t rng_dev_read(struct file *filp, char __user *buf,
>  		}
>  	}
>  out:
> +	if (synch)
> +		synchronize_rcu();

The synch usage no longer makes sense to me here. In my version,
synchronize_rcu() would almost never be called. It's only purpose was to
prevent rng_dev_read() from returning if the critical section inside of
hwrng_unregister() was in flight. But now it looks like it will be
called everytime there are no RNGs left? Or maybe I understood how this
works. Either way, please don't feel that you have to write back an
explanation; just make sure it has those same sorts of semantics when
testing.

>                 if (rc <= 0) {
> -                       pr_warn("hwrng: no data available\n");
> -                       msleep_interruptible(10000);
> +                       set_current_state(TASK_INTERRUPTIBLE);
> +                       if (kthread_should_stop())
> +                               __set_current_state(TASK_RUNNING);
> +                       schedule_timeout(10 * HZ);
>                         continue;
>                 }

Here you made a change whose utility I don't understand. My original
hunk was:

+                       if (kthread_should_stop())
+                               break;
+                       schedule_timeout_interruptible(HZ * 10);

Which I think is a bit cleaner, as schedule_timeout_interruptible sets
the state to INTERRUPTIBLE and such.

Regards,
Jason
