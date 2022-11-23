Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3036363AC
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 16:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238896AbiKWPa0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 10:30:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238816AbiKWPaA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 10:30:00 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DB6C7665;
        Wed, 23 Nov 2022 07:29:06 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 2E2E91F88D;
        Wed, 23 Nov 2022 15:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1669217345; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QpW5/43SDhPsYac/DGPcgp+HRWanDglkFBDiPk9Aubo=;
        b=tBTY1GG47MoYjwDFR9Z6UCoz0Q9N1YiEtgSK3Jhp5RK/IrTM0/iV+4GUilsJqWHKIUCOqi
        LdIk6WlIgiI1fvXFB+ER5X/rT9XOUztfQ7YWC18bPqLzD2ia8/FGl2fXNbL1KiqN6pcsSs
        X7frWVineEqa1zfnsb4c2X6kk4vM7XE=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 138F02C142;
        Wed, 23 Nov 2022 15:29:05 +0000 (UTC)
Date:   Wed, 23 Nov 2022 16:29:04 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Petr Pavlu <petr.pavlu@suse.com>
Cc:     mcgrof@kernel.org, prarit@redhat.com, david@redhat.com,
        mwilck@suse.com, linux-modules@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] module: Don't wait for GOING modules
Message-ID: <Y348QNmO2AHh3eNr@alley>
References: <20221123131226.24359-1-petr.pavlu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123131226.24359-1-petr.pavlu@suse.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed 2022-11-23 14:12:26, Petr Pavlu wrote:
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
> Notes:
>     Sending this alternative patch per the discussion in
>     https://lore.kernel.org/linux-modules/20220919123233.8538-1-petr.pavlu@suse.com/.
>     The initial version comes internally from Martin, hence the co-developed tag.
> 
>  kernel/module/main.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/module/main.c b/kernel/module/main.c
> index d02d39c7174e..b7e08d1edc27 100644
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
> @@ -2566,7 +2567,8 @@ static int add_unformed_module(struct module *mod)
>  	mutex_lock(&module_mutex);
>  	old = find_module_all(mod->name, strlen(mod->name), true);
>  	if (old != NULL) {
> -		if (old->state != MODULE_STATE_LIVE) {
> +		if (old->state == MODULE_STATE_COMING
> +		    || old->state == MODULE_STATE_UNFORMED) {
>  			/* Wait in case it fails to load. */
>  			mutex_unlock(&module_mutex);
>  			err = wait_event_interruptible(module_wq,
> @@ -2575,7 +2577,7 @@ static int add_unformed_module(struct module *mod)
>  				goto out_unlocked;
>  			goto again;
>  		}
> -		err = -EEXIST;
> +		err = old->state != MODULE_STATE_LIVE ? -EBUSY : -EEXIST;

Hmm, this is not much reliable. It helps only when we manage to read
the old module state before it is gone.

A better solution would be to always return when there was a parallel
load. The older patch from Petr Pavlu was more precise because it
stored result of the exact parallel load. The below code is easier
and might be good enough.

static int add_unformed_module(struct module *mod)
{
	int err;
	struct module *old;

	mod->state = MODULE_STATE_UNFORMED;

	mutex_lock(&module_mutex);
	old = find_module_all(mod->name, strlen(mod->name), true);
	if (old != NULL) {
		if (old->state == MODULE_STATE_COMING
		    || old->state == MODULE_STATE_UNFORMED) {
			/* Wait for the result of the parallel load. */
			mutex_unlock(&module_mutex);
			err = wait_event_interruptible(module_wq,
					       finished_loading(mod->name));
			if (err)
				goto out_unlocked;
		}

		/* The module might have gone in the meantime. */
		mutex_lock(&module_mutex);
		old = find_module_all(mod->name, strlen(mod->name), true);

		/*
		 * We are here only when the same module was being loaded.
		 * Do not try to load it again right now. It prevents
		 * long delays caused by serialized module load failures.
		 * It might happen when more devices of the same type trigger
		 * load of a particular module.
		 */
		if (old && old->state == MODULE_STATE_LIVE)
			err = -EXIST;
		else
			err = -EBUSY;
		goto out;
	}
	mod_update_bounds(mod);
	list_add_rcu(&mod->list, &modules);
	mod_tree_insert(mod);
	err = 0;

out:
	mutex_unlock(&module_mutex);
out_unlocked:
	return err;
}

Best Regards,
Petr
