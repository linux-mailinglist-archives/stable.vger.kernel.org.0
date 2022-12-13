Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C10964B30D
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 11:17:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235111AbiLMKRv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 05:17:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234753AbiLMKRs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 05:17:48 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C96EB485;
        Tue, 13 Dec 2022 02:17:47 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 358511FE90;
        Tue, 13 Dec 2022 10:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1670926665; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tWdApeddYiMYXB8pmHjPXlFof6sqZG2lI5ncWpQKXcI=;
        b=hoRrXygslHjny+uwKR2kFMu+k1f8vpCZftGqeMF8I/Y5/lQepUhIumx8Zo3XeYbxkb0CR9
        PLLaYj1pa1Hpp11YQ9NfXtE7a4PqlFMmNH7Up8pnhAmPZWzY/wYzVfwIpupSS9cbkv1F/L
        nMYA7NXBuyQCN9BmViL0dx1Vjypg3rY=
Received: from suse.cz (unknown [10.100.208.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 140322C141;
        Tue, 13 Dec 2022 10:17:45 +0000 (UTC)
Date:   Tue, 13 Dec 2022 11:17:42 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Petr Pavlu <petr.pavlu@suse.com>, prarit@redhat.com,
        david@redhat.com, mwilck@suse.com, linux-modules@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] module: Don't wait for GOING modules
Message-ID: <Y5hRRnBGYaPby/RS@alley>
References: <20221205103557.18363-1-petr.pavlu@suse.com>
 <Y5gI/3crANzRv22J@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5gI/3crANzRv22J@bombadil.infradead.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon 2022-12-12 21:09:19, Luis Chamberlain wrote:
> On Mon, Dec 05, 2022 at 11:35:57AM +0100, Petr Pavlu wrote:
> > During a system boot, it can happen that the kernel receives a burst of
> > requests to insert the same module but loading it eventually fails
> > during its init call. For instance, udev can make a request to insert
> > a frequency module for each individual CPU when another frequency module
> > is already loaded which causes the init function of the new module to
> > return an error.
> > 
> > This patch attempts a different solution for the problem 6e6de3dee51a
> > was trying to solve. Rather than waiting for the unloading to complete,
> > it returns a different error code (-EBUSY) for modules in the GOING
> > state. This should avoid the error situation that was described in
> > 6e6de3dee51a (user space attempting to load a dependent module because
> > the -EEXIST error code would suggest to user space that the first module
> > had been loaded successfully), while avoiding the delay situation too.
> > 
> 
> So sorry for the late review but these ideas only came to me as I
> drafted my pull request to Linus.
> 
> Let's recap the issue from the start as this is why I ended having
> to pause for a second and couldn't believe myself as I wrote that
> we had merged this.

IMHO, it is perfectly fine to delay this. The problem is not trivial.
It always made my head spin. There is a risk of regression. The change
spent in linux next only one week. And this particular merge window is
not good for risking because of the holiday season.


> > diff --git a/kernel/module/main.c b/kernel/module/main.c
> > index d02d39c7174e..7a627345d4fd 100644
> > --- a/kernel/module/main.c
> > +++ b/kernel/module/main.c
> > @@ -2386,7 +2386,8 @@ static bool finished_loading(const char *name)
> >  	sched_annotate_sleep();
> >  	mutex_lock(&module_mutex);
> >  	mod = find_module_all(name, strlen(name), true);
> > -	ret = !mod || mod->state == MODULE_STATE_LIVE;
> > +	ret = !mod || mod->state == MODULE_STATE_LIVE
> > +		|| mod->state == MODULE_STATE_GOING;
> >  	mutex_unlock(&module_mutex);
> >  
> >  	return ret;
> > @@ -2562,20 +2563,35 @@ static int add_unformed_module(struct module *mod)
> >  
> >  	mod->state = MODULE_STATE_UNFORMED;
> >  
> > -again:
> 
> So this is part of my biggest concern for regression, the removal of
> this tag and its use.
> 
> Before this we always looped back to trying again and again.

Just to be sure that we are on the same page.

The loop was _not_ infinite. It serialized all attempts to load
the same module. In our case, it serialized all failures and
prolonged the pain.


> >  	mutex_lock(&module_mutex);
> >  	old = find_module_all(mod->name, strlen(mod->name), true);
> >  	if (old != NULL) {
> > -		if (old->state != MODULE_STATE_LIVE) {
> > +		if (old->state == MODULE_STATE_COMING
> > +		    || old->state == MODULE_STATE_UNFORMED) {
> >  			/* Wait in case it fails to load. */
> >  			mutex_unlock(&module_mutex);
> >  			err = wait_event_interruptible(module_wq,
> >  					       finished_loading(mod->name));
> >  			if (err)
> >  				goto out_unlocked;
> > -			goto again;
> 
> We essentially bound this now, and before we didn't.
> 
> Yes we we wait for finished_loading() of the module -- but if udev is
> hammering tons of same requests, well, we *will* surely hit this, as
> many requests managed to get in before userspace saw the module present.
> 
> While this typically can be useful, it means *quite a bit* of conditions which
> definitely *did* happen before will now *bail out* fast, to the extent
> that I'm not even sure why we just re-try once now.

I do not understand this. We do _not_ re-try the load in the new
version. We just wait for the result of the parallel attempt to
load the module.

Maybe, you are confused that we repeat find_module_all(). But it is
the way how to find the result of the parallel load.


> If we're going to 
> just re-check *once* why not do something graceful like *at least*
> cond_resched() to let the system breathe for a *tiny bit*.

We must check the result under module_mutex. We have to take this
sleeping lock. There is actually a rescheduling. I do not think that
cond_resched() would do any difference.


> > +
> > +			/* The module might have gone in the meantime. */
> > +			mutex_lock(&module_mutex);
> > +			old = find_module_all(mod->name, strlen(mod->name),
> > +					      true);
> >  		}
> > -		err = -EEXIST;
> > +
> > +		/*
> > +		 * We are here only when the same module was being loaded. Do
> > +		 * not try to load it again right now. It prevents long delays
> > +		 * caused by serialized module load failures. It might happen
> > +		 * when more devices of the same type trigger load of
> > +		 * a particular module.
> > +		 */
> > +		if (old && old->state == MODULE_STATE_LIVE)
> > +			err = -EEXIST;
> > +		else
> > +			err = -EBUSY;
> 
> And for all those use cases we end up here now, with -EBUSY. So udev
> before was not bounded, and kept busy-looping on the retry in-kernel,
> and we now immediately bound its condition to just 2 tries to see if the
> old module existed and now *return* a new value to userspace.
> 
> My main concerns are:
> 
> 0) Why not use cond_resched() if we're just going to check twice?

We take module_mutex. It should cause even bigger delay than cond_resched().


> 1) How are we sure we are not regressing userspace by removing the boundless
> loop there? (even if the endless loop was stupid)

We could not be sure. On the other hand, if more attempts help to load
the module then it is racy and not reliable. The new approach would
make it better reproducible and fix the race.


> 2) How is it we expect that we won't resgress userspace now by bounding
> that check and pretty much returning -EBUSY right away? This last part
> seems dangerous, in that if userspace did not expect -EBUSY and if an
> error before caused a module to fail and fail boot, why wouldn't we fail
> boot now by bailing out faster??

Same answer as for 1)


> 3) *Fixing* a kernel regression by adding new expected API for testing
> against -EBUSY seems not ideal.

IMHO, the right solution is to fix the subsystems so that they send
only one uevent.

The question is how the module loader would deal with "broken"
subsystems. Petr Pavlu, please, fixme. I think that there are
more subsystems doing this ugly thing.

I personally thing that returning -EBUSY is better than serializing
all the loads. It makes eventual problem easier to reproduce and fix.

Best Regards,
Petr
