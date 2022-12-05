Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52723643504
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:56:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233654AbiLETz6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:55:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231602AbiLETz2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:55:28 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40C7FE3;
        Mon,  5 Dec 2022 11:54:07 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 5C91621F77;
        Mon,  5 Dec 2022 19:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1670270046; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+CEPKOUcs58XcBBC3BmQTUM9eA7+p9pfmnjTyRe6bBU=;
        b=n9QqsjMXkjVk9c9DLv/RkVJfCO9dPih0612QxVCsDr+1PT8pnsh0nGyLwBKApivdlnEfqy
        qRTkgRdzdPx5gCagyJP2auvzxIf+WPv82F1jw1wpqdjg+Cfq9bsPSsUHobH6jqS8YDUdRx
        YsDiexm+yib29GBLyhET7yHwLiJNozg=
Received: from suse.cz (unknown [10.100.208.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 3F5722C141;
        Mon,  5 Dec 2022 19:54:06 +0000 (UTC)
Date:   Mon, 5 Dec 2022 20:54:05 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Petr Pavlu <petr.pavlu@suse.com>
Cc:     mcgrof@kernel.org, prarit@redhat.com, david@redhat.com,
        mwilck@suse.com, linux-modules@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] module: Don't wait for GOING modules
Message-ID: <Y45MXVrGNkY/bGSl@alley>
References: <20221205103557.18363-1-petr.pavlu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221205103557.18363-1-petr.pavlu@suse.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon 2022-12-05 11:35:57, Petr Pavlu wrote:
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
> 
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

There is a actually one more race.

This function is supposed to wait until load of a particular module
finishes. But we might find some another module of the same name here.

Maybe, it is not that bad. If many modules of the same name are loaded
in parallel then hopefully most of them would wait for the first one
in add_unformed_module(). And they will never appear in the @modules
list.

Anyway, to be on the safe side. We might want to pass the pointer
to the @old module found in add_unformed_module() and make sure
that we find the same module here. Something like:

/*
 * @pending_mod: pointer to module that we are waiting for
 * @name: name of the module; the string must stay even when
 *	the pending module goes away completely
 */
static bool finished_loading(const struct module *pending_mod,
			    const char *name)
{
	struct module *mod;
	bool ret = true;

	/*
	 * The module_mutex should not be a heavily contended lock;
	 * if we get the occasional sleep here, we'll go an extra iteration
	 * in the wait_event_interruptible(), which is harmless.
	 */
	sched_annotate_sleep();
	mutex_lock(&module_mutex);

	mod = find_module_all(name, strlen(name), true);
	/* Check if the pending module is still being loaded */
	if (mod == pending_mod &&
	    (mod->state == MODULE_STATE_UNFORMED ||
	       mod->state == MODULE_STATE_COMMING))
	       ret = false;
	mutex_unlock(&module_mutex);

	return ret;
}

Another advantage is that this is using the very same logic
(if condition) as add_formed_module() and not the inverted one ;-)

Otherwise, the patch looks good. I wonder how it works for Prarit.

Best Regards,
Petr
