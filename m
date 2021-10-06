Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0025423A71
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 11:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237812AbhJFJUz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 05:20:55 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:51294 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbhJFJUy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Oct 2021 05:20:54 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id F215F1FE97;
        Wed,  6 Oct 2021 09:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1633511942; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hSmhfjw1mLDaDCCDvg5TTsk9tqS4UlBnVsDx65zDjn4=;
        b=ie7CMRORf/PlMjidNm/bt6Uz5B4S0u0VANnWR/NV3jmg+15ruD02otk4HRrISQMg+6rseP
        uESeS8g43No/r2oF+nsFkdUGu3nwhP8UUw6xItq/T7aP4rGqnehAiDqG8HxDkHSLeE2kGm
        aqo1KlUvYDCVK36N0BVpjHL/29mj+V4=
Received: from suse.cz (unknown [10.100.216.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id D4BCDA3B81;
        Wed,  6 Oct 2021 09:19:01 +0000 (UTC)
Date:   Wed, 6 Oct 2021 11:19:01 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Johan Hovold <johan@kernel.org>
Cc:     Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Ogness <john.ogness@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fabio Estevam <festevam@denx.de>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] workqueue: fix state-dump console deadlock
Message-ID: <YV1qBZiXx/IADcb6@alley>
References: <YV1Z8JslFiBSFGJF@hovoldconsulting.com>
 <20211006081115.20451-1-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211006081115.20451-1-johan@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed 2021-10-06 10:11:15, Johan Hovold wrote:
> Console drivers often queue work while holding locks also taken in their
> console write paths, something which can lead to deadlocks on SMP when
> dumping workqueue state (e.g. sysrq-t or on suspend failures).
> 
> For serial console drivers this could look like:
> 
> 	CPU0				CPU1
> 	----				----
> 
> 	show_workqueue_state();
> 	  lock(&pool->lock);		<IRQ>
> 	  				  lock(&port->lock);
> 					  schedule_work();
> 					    lock(&pool->lock);
> 	  printk();
> 	    lock(console_owner);
> 	    lock(&port->lock);
> 
> where workqueues are, for example, used to push data to the line
> discipline, process break signals and handle modem-status changes. Line
> disciplines and serdev drivers can also queue work on write-wakeup
> notifications, etc.
> 
> Reworking every console driver to avoid queuing work while holding locks
> also taken in their write paths would complicate drivers and is neither
> desirable or feasible.
> 
> Instead use the deferred-printk mechanism to avoid printing while
> holding pool locks when dumping workqueue state.
> 
> Note that there are a few WARN_ON() assertions in the workqueue code
> which could potentially also trigger a deadlock. Hopefully the ongoing
> printk rework will provide a general solution for this eventually.
> 
> This was originally reported after a lockdep splat when executing
> sysrq-t with the imx serial driver.
> 
> Fixes: 3494fc30846d ("workqueue: dump workqueues on sysrq-t")
> Cc: stable@vger.kernel.org	# 4.0
> Reported-by: Fabio Estevam <festevam@denx.de>
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
>  kernel/workqueue.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 33a6b4a2443d..fded64b48b96 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -4830,8 +4830,16 @@ void show_workqueue_state(void)
>  
>  		for_each_pwq(pwq, wq) {
>  			raw_spin_lock_irqsave(&pwq->pool->lock, flags);
> -			if (pwq->nr_active || !list_empty(&pwq->inactive_works))
> +			if (pwq->nr_active || !list_empty(&pwq->inactive_works)) {
> +				/*
> +				 * Defer printing to avoid deadlocks in console
> +				 * drivers that queue work while holding locks
> +				 * also taken in their write paths.
> +				 */
> +				printk_deferred_enter();
>  				show_pwq(pwq);
> +				printk_deferred_exit();
> +			}
>  			raw_spin_unlock_irqrestore(&pwq->pool->lock, flags);
>  			/*
>  			 * We could be printing a lot from atomic context, e.g.

This handles only one printk() caller. But there are many more callers
under pool->lock, for example in the next for-cycle in this function:

	for_each_pool(pool, pi) {
		raw_spin_lock_irqsave(&pool->lock, flags);
[...]
		pr_info("pool %d:", pool->id);
		pr_cont_pool_info(pool);
		pr_cont(" hung=%us workers=%d",

And this is the problem with printk_deferred() and printk_deferred_enter().
It is a "catch a mole" approach. It might end up with switching half
of the kernel into printk_deferred().

John Ogness is working on a generic solution where any printk() will
be deferred out of box. consoles will be called from a dedicated
kthreads.

John has already worked on reworking printk() two years or so. It gets
slowly because we need to be careful. Also we started with
implementing lockless ringbuffer which was a big challenge. Anyway, there
is a stable progress. The lockless ringbuffer is done. And the
kthreads are the very next step.

printk_deferred() is currently used only in the scheduler code where
the deadlocks really happened in the past. printk_deferred_enter()
is used only in printk() because it would be otherwise hard to debug
and lockdep would always report problems there.

From this perspective, I suggest to ignore this possible deadlock if
they do not happen in the real life.

If you really want to avoid the lockdep report. Alternative and
probably easier workaround is to temporary disable lockdep around
queuing the work in the console code. I do not see any reason
why workqueue code would call back to console code directly.
So the only source of a possible deadlock is the printk() path.
But I think that it is not worth it. It is better to concentrate
on the printk() rework.

Best Regards,
Petr
