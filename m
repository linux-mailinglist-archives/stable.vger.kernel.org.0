Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA1B864AF2F
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 06:12:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbiLMFMX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 00:12:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230188AbiLMFLk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 00:11:40 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0AF6633B;
        Mon, 12 Dec 2022 21:09:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=fiH/76g6bPuIC/PYVPpzSDB5yM8E61dsrJYLzWgn72c=; b=gnLo09ph42polR8Yt/15IevQoC
        KuDWpS8VfzOZ7NfXt8ym/UmhIoCAkOYZtlzZAJHRQEXIr3EKIhz6xBtu6GBFSbVzNDJ/R4J0+KPHt
        2cclqZz5Sykq9IDmyQ0drCkkyNMJfgc5D5q2f4r14utLw9qFuUT8R9d3JTYexPRKEaWnFiNgwsfrM
        RSWr5Mh/W6pNVkBEkARWjd9pF5DTw2kKvEX1Sy3T0RpWe1Rc4/Y7sNQ5hMEewmxyLpLQVZd3v/yYX
        Nm59DtJIVZCZpdQ4952RBc2uCxCnW5BS8T5XTAs/c29C7XRdq+GaSUwKEKJ51SGFyRZugM58BhoOO
        Z8bZmQBA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p4xXb-00B8v7-ID; Tue, 13 Dec 2022 05:09:19 +0000
Date:   Mon, 12 Dec 2022 21:09:19 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Petr Pavlu <petr.pavlu@suse.com>
Cc:     pmladek@suse.com, prarit@redhat.com, david@redhat.com,
        mwilck@suse.com, linux-modules@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] module: Don't wait for GOING modules
Message-ID: <Y5gI/3crANzRv22J@bombadil.infradead.org>
References: <20221205103557.18363-1-petr.pavlu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221205103557.18363-1-petr.pavlu@suse.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 05, 2022 at 11:35:57AM +0100, Petr Pavlu wrote:
> During a system boot, it can happen that the kernel receives a burst of
> requests to insert the same module but loading it eventually fails
> during its init call. For instance, udev can make a request to insert
> a frequency module for each individual CPU when another frequency module
> is already loaded which causes the init function of the new module to
> return an error.
> 
> Since commit 6e6de3dee51a ("kernel/module.c: Only return -EEXIST for
> modules that have finished loading"), the kernel waits for modules in
> MODULE_STATE_GOING state to finish unloading before making another
> attempt to load the same module.
> 
> This creates unnecessary work in the described scenario and delays the
> boot. In the worst case, it can prevent udev from loading drivers for
> other devices and might cause timeouts of services waiting on them and
> subsequently a failed boot.
> 
> This patch attempts a different solution for the problem 6e6de3dee51a
> was trying to solve. Rather than waiting for the unloading to complete,
> it returns a different error code (-EBUSY) for modules in the GOING
> state. This should avoid the error situation that was described in
> 6e6de3dee51a (user space attempting to load a dependent module because
> the -EEXIST error code would suggest to user space that the first module
> had been loaded successfully), while avoiding the delay situation too.
> 
> Fixes: 6e6de3dee51a ("kernel/module.c: Only return -EEXIST for modules that have finished loading")
> Co-developed-by: Martin Wilck <mwilck@suse.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
> Cc: stable@vger.kernel.org
> ---
> 
> Changes since v1 [1]:
> - Don't attempt a new module initialization when a same-name module
>   completely disappeared while waiting on it, which means it went
>   through the GOING state implicitly already.
> 
> [1] https://lore.kernel.org/linux-modules/20221123131226.24359-1-petr.pavlu@suse.com/
> 
>  kernel/module/main.c | 26 +++++++++++++++++++++-----
>  1 file changed, 21 insertions(+), 5 deletions(-)

So sorry for the late review but these ideas only came to me as I
drafted my pull request to Linus.

Let's recap the issue from the start as this is why I ended having
to pause for a second and couldn't believe myself as I wrote that
we had merged this.

The old commit which broke things is old, that has been in the kerne
since since v5.3-rc1, May 2019, over 2 years ago!

The original issue was seeing "Unknown symbols" on the kernel logs for
Linux guests on Microsoft HyperV as it disables the X86_FEATURE_SMCA bit on
AMD systems. That's nothing to scream about as the error message in this
case was bogus and could be ignored. The *fix* to this not-big-deal-issue,
however, it was applied on v5.3-rc1 (May 2019), and in the end though
created a modern real tux-pain-screaming-worthy regression which in some
cases creates failed boots on systems with many CPUs.

The issue is that the fix triggered multiple same module requests to
eventually return a failure even though the same module may be creeping
up, and boot is also delayed by hammering on this check over and over again,
instead of informing userspace that the kernel is busy. So this new fix
limits these checks, it bounds it, and we pretty much return -EBUSY if
we see the same module for which we sent a request for twice in a row.

The issue is fatal for large systems given that for each CPU udev stupidly
requests the same stupid frequency module, and eventually it runs into
the unformed case the fix boobie trapped us into and fails. The series
of failures will eventually trigger a full boot failure.

> diff --git a/kernel/module/main.c b/kernel/module/main.c
> index d02d39c7174e..7a627345d4fd 100644
> --- a/kernel/module/main.c
> +++ b/kernel/module/main.c
> @@ -2386,7 +2386,8 @@ static bool finished_loading(const char *name)
>  	sched_annotate_sleep();
>  	mutex_lock(&module_mutex);
>  	mod = find_module_all(name, strlen(name), true);
> -	ret = !mod || mod->state == MODULE_STATE_LIVE;
> +	ret = !mod || mod->state == MODULE_STATE_LIVE
> +		|| mod->state == MODULE_STATE_GOING;
>  	mutex_unlock(&module_mutex);
>  
>  	return ret;
> @@ -2562,20 +2563,35 @@ static int add_unformed_module(struct module *mod)
>  
>  	mod->state = MODULE_STATE_UNFORMED;
>  
> -again:

So this is part of my biggest concern for regression, the removal of
this tag and its use.

Before this we always looped back to trying again and again.

>  	mutex_lock(&module_mutex);
>  	old = find_module_all(mod->name, strlen(mod->name), true);
>  	if (old != NULL) {
> -		if (old->state != MODULE_STATE_LIVE) {
> +		if (old->state == MODULE_STATE_COMING
> +		    || old->state == MODULE_STATE_UNFORMED) {
>  			/* Wait in case it fails to load. */
>  			mutex_unlock(&module_mutex);
>  			err = wait_event_interruptible(module_wq,
>  					       finished_loading(mod->name));
>  			if (err)
>  				goto out_unlocked;
> -			goto again;

We essentially bound this now, and before we didn't.

Yes we we wait for finished_loading() of the module -- but if udev is
hammering tons of same requests, well, we *will* surely hit this, as
many requests managed to get in before userspace saw the module present.

While this typically can be useful, it means *quite a bit* of conditions which
definitely *did* happen before will now *bail out* fast, to the extent
that I'm not even sure why we just re-try once now. If we're going to
just re-check *once* why not do something graceful like *at least*
cond_resched() to let the system breathe for a *tiny bit*. Because
otherwise we it would seem we can end up in similar situations as before
except we now deal with that condition differently. And let's see what
that looks like now.

> +
> +			/* The module might have gone in the meantime. */
> +			mutex_lock(&module_mutex);
> +			old = find_module_all(mod->name, strlen(mod->name),
> +					      true);
>  		}
> -		err = -EEXIST;
> +
> +		/*
> +		 * We are here only when the same module was being loaded. Do
> +		 * not try to load it again right now. It prevents long delays
> +		 * caused by serialized module load failures. It might happen
> +		 * when more devices of the same type trigger load of
> +		 * a particular module.
> +		 */
> +		if (old && old->state == MODULE_STATE_LIVE)
> +			err = -EEXIST;
> +		else
> +			err = -EBUSY;

And for all those use cases we end up here now, with -EBUSY. So udev
before was not bounded, and kept busy-looping on the retry in-kernel,
and we now immediately bound its condition to just 2 tries to see if the
old module existed and now *return* a new value to userspace.

My main concerns are:

0) Why not use cond_resched() if we're just going to check twice?

1) How are we sure we are not regressing userspace by removing the boundless
loop there? (even if the endless loop was stupid)

2) How is it we expect that we won't resgress userspace now by bounding
that check and pretty much returning -EBUSY right away? This last part
seems dangerous, in that if userspace did not expect -EBUSY and if an
error before caused a module to fail and fail boot, why wouldn't we fail
boot now by bailing out faster??

3) *Fixing* a kernel regression by adding new expected API for testing
against -EBUSY seems not ideal.

  Luis
