Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46F24645D65
	for <lists+stable@lfdr.de>; Wed,  7 Dec 2022 16:15:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbiLGPPY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Dec 2022 10:15:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiLGPPY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Dec 2022 10:15:24 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 504765FB96;
        Wed,  7 Dec 2022 07:15:23 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id ED1DE21E8C;
        Wed,  7 Dec 2022 15:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1670426121; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=doN8OAAvm/Kul2jr/dWYi2PVymsfdKhPapqin9FX5hk=;
        b=mMG6q1ALjgO/KA7H5MVoSFAxPUtwgcc1JVntKEZUHrNOApEsYDD5V3e9vXjJMKD5Ei9cqs
        h8IAYK+d1J8TVa0xLQ2Pd+eMVBRRJwecuFEHegxhQCu+mOK16qbKNlGk89uLF3SqmRBhTY
        d8aVGdSJaLd2qWS9jmLyjY6ST8AIwQg=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id D20782C141;
        Wed,  7 Dec 2022 15:15:21 +0000 (UTC)
Date:   Wed, 7 Dec 2022 16:15:21 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Petr Pavlu <petr.pavlu@suse.com>
Cc:     mcgrof@kernel.org, prarit@redhat.com, david@redhat.com,
        mwilck@suse.com, linux-modules@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] module: Don't wait for GOING modules
Message-ID: <Y5CuCVe02W5Ni/Fc@alley>
References: <20221205103557.18363-1-petr.pavlu@suse.com>
 <Y45MXVrGNkY/bGSl@alley>
 <d528111b-4caa-e292-59f4-4ce1eab1f27c@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d528111b-4caa-e292-59f4-4ce1eab1f27c@suse.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 2022-12-06 17:57:30, Petr Pavlu wrote:
> On 12/5/22 20:54, Petr Mladek wrote:
> > On Mon 2022-12-05 11:35:57, Petr Pavlu wrote:
> >> During a system boot, it can happen that the kernel receives a burst of
> >> requests to insert the same module but loading it eventually fails
> >> during its init call. For instance, udev can make a request to insert
> >> a frequency module for each individual CPU when another frequency module
> >> is already loaded which causes the init function of the new module to
> >> return an error.
> >>
> >> Since commit 6e6de3dee51a ("kernel/module.c: Only return -EEXIST for
> >> modules that have finished loading"), the kernel waits for modules in
> >> MODULE_STATE_GOING state to finish unloading before making another
> >> attempt to load the same module.
> >>
> >> This creates unnecessary work in the described scenario and delays the
> >> boot. In the worst case, it can prevent udev from loading drivers for
> >> other devices and might cause timeouts of services waiting on them and
> >> subsequently a failed boot.
> >>
> >> This patch attempts a different solution for the problem 6e6de3dee51a
> >> was trying to solve. Rather than waiting for the unloading to complete,
> >> it returns a different error code (-EBUSY) for modules in the GOING
> >> state. This should avoid the error situation that was described in
> >> 6e6de3dee51a (user space attempting to load a dependent module because
> >> the -EEXIST error code would suggest to user space that the first module
> >> had been loaded successfully), while avoiding the delay situation too.
> >>
> >> --- a/kernel/module/main.c
> >> +++ b/kernel/module/main.c
> >> @@ -2386,7 +2386,8 @@ static bool finished_loading(const char *name)
> >>  	sched_annotate_sleep();
> >>  	mutex_lock(&module_mutex);
> >>  	mod = find_module_all(name, strlen(name), true);
> >> -	ret = !mod || mod->state == MODULE_STATE_LIVE;
> >> +	ret = !mod || mod->state == MODULE_STATE_LIVE
> >> +		|| mod->state == MODULE_STATE_GOING;
> > 
> > There is a actually one more race.
> > 
> > This function is supposed to wait until load of a particular module
> > finishes. But we might find some another module of the same name here.
> > 
> > Maybe, it is not that bad. If many modules of the same name are loaded
> > in parallel then hopefully most of them would wait for the first one
> > in add_unformed_module(). And they will never appear in the @modules
> > list.
> 
> Good point, a load waiting in add_unformed_module() could miss that its older
> parallel load already finished if another insert of the same module appears in
> the modules list in the meantime. This requires that the new load happens to
> arrive just after the old one finishes and before the waiting load makes its
> check.
>
> This is somewhat similar to the current state where new same-name insert
> requests can skip and starve the ones already waiting in
> add_unformed_module().
> 
> I think in practice the situation should occur very rarely and be cleared
> soon, as long one doesn't continuously try to insert the same module.

I am not completely sure how rare it is. Anyway, the conditions are
rather complex so it feels rare ;-)

Anyway, the important part of this race is that the new module
found in finished_loading() did not see the previously loaded
module and did not wait in add_unformed_module(). It means
that the load was not parallel enough. It means that the
optimization added by this patch was not used.

By other words, if the multiple loads are not parallel enough
then the optimization added by this patch will not help.

And the other way. If this patch helps in practice then
this race is not important.

> > Anyway, to be on the safe side. We might want to pass the pointer
> > to the @old module found in add_unformed_module() and make sure
> > that we find the same module here. Something like:
> > 
> > /*
> >  * @pending_mod: pointer to module that we are waiting for
> >  * @name: name of the module; the string must stay even when
> >  *	the pending module goes away completely
> >  */
> > static bool finished_loading(const struct module *pending_mod,
> > 			    const char *name)
> > {
> > 	struct module *mod;
> > 	bool ret = true;
> > 
> > 	/*
> > 	 * The module_mutex should not be a heavily contended lock;
> > 	 * if we get the occasional sleep here, we'll go an extra iteration
> > 	 * in the wait_event_interruptible(), which is harmless.
> > 	 */
> > 	sched_annotate_sleep();
> > 	mutex_lock(&module_mutex);
> > 
> > 	mod = find_module_all(name, strlen(name), true);
> > 	/* Check if the pending module is still being loaded */
> > 	if (mod == pending_mod &&
> > 	    (mod->state == MODULE_STATE_UNFORMED ||
> > 	       mod->state == MODULE_STATE_COMMING))
> > 	       ret = false;
> > 	mutex_unlock(&module_mutex);
> > 
> > 	return ret;
> > }
> 
> The new pending_mod pointer has no ownership of the target module which can be
> then destroyed at any time. While no dereference of pending_mod is made in
> finished_loading(), this looks still problematic to me.
> 
> I think it is generally good to treat a pointer as invalid and its value as
> indeterminate when the object it points to reaches the end of its lifetime.
> One specific problem here is that nothing guarantees that a new module doesn't
> get allocated at the exactly same address as the old one that got released and
> the code is actually waiting on.
>
> Improving this case then likely results in a more complex solution, similar
> to the one that was discussed originally.

Fair enough. Let's ignore the race in finished_loading().

Otherwise, the patch looks good to me. It is easy enough.
IMHO, it makes sense to use it if it helps in practice
(multiple loads are parallel enough[*]). Feel free to use:

Reviewed-by: Petr Mladek <pmladek@suse.com>

Of course, the ideal solution would be to avoid the multiple
loads in the first place. AFAIK, everything starts in the kernel
that sends the same udev events for each CPU...

Best Regards,
Petr
