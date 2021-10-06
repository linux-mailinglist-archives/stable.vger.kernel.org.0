Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43A1742467D
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 21:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239069AbhJFTLC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 15:11:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231807AbhJFTLC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Oct 2021 15:11:02 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B89BDC061746;
        Wed,  6 Oct 2021 12:09:09 -0700 (PDT)
From:   John Ogness <john.ogness@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1633547347;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Fz5ph9zRK6litvw0SKDVU/0ZKzmd9blsLfQbDEUhygs=;
        b=n8pZUvjNI9FOHoBwXKQ+DmbKtHl133nsV1RzGJS7qRCL1XFMfYgp5kplRfRCowGXo9tRvX
        tK+5ohqLXguuKm6uuAkYk5ex3b5uaD4ej8WivTnvV9GfTkjy53YlpmseNYMcy8+mY7XhSh
        e/qOUIBfRPUXKc9u41TN5AF9/rtT1mYCOCizg9oMPuqzYDDRXXIcYTX4LeBsiiErw1hw0M
        Hd+BktvlmYQbcY/lgybGq+Yj9IJyOAoiRUMekn98ZCHynELpziSz7mPy0+X1e8iRaxi9bv
        ygmJTHM0uWsWDFZkGU0tdmzQUFiFXNwvZyCNSuY1ev6CTBGBR3yPsbLCJ72crw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1633547347;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Fz5ph9zRK6litvw0SKDVU/0ZKzmd9blsLfQbDEUhygs=;
        b=akeZGlZ6rN+kmwPyKueUPX3xNTfv51IbD6oTLZ/6RsJI10ZKWDcAOOOBkq12A61jMDqBqB
        T2Hy4G+DC1234wDA==
To:     Johan Hovold <johan@kernel.org>, Tejun Heo <tj@kernel.org>
Cc:     Lai Jiangshan <jiangshanlai@gmail.com>,
        Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fabio Estevam <festevam@denx.de>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] workqueue: fix state-dump console deadlock
In-Reply-To: <20211006115852.16986-1-johan@kernel.org>
References: <20211006115852.16986-1-johan@kernel.org>
Date:   Wed, 06 Oct 2021 21:15:06 +0206
Message-ID: <87ee8yug19.fsf@jogness.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-10-06, Johan Hovold <johan@kernel.org> wrote:
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

When I introduced the printk_deferred_enter/exit functions, I kind of
expected patches like this to start showing up. The functions make it
really convenient to establish general sections of console print
deferring.

When we move to kthread-printers, all printk calls will be deferred
automatically. However, that is only during normal operation. The
various printk_deferred sites may still be significant and will continue
to have special meaning during startup and shutdown states, when the
kthreads will not be active and direct printing will exist as it is now.

FWIW, I am OK with this patch. It will be re-evaluated once we have
kthread-printers, but I suspect even then it will remain.

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
> Tested-by: Fabio Estevam <festevam@denx.de>
> Signed-off-by: Johan Hovold <johan@kernel.org>

Reviewed-by: John Ogness <john.ogness@linutronix.de>

> ---
>
> Changes in v2
>  - defer printing also of worker pool state (Peter Mladek)
>  - add Fabio's tested-by tag
>
>
>  kernel/workqueue.c | 18 ++++++++++++++++--
>  1 file changed, 16 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 33a6b4a2443d..1b3eb1e9531f 100644
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
> @@ -4849,7 +4857,12 @@ void show_workqueue_state(void)
>  		raw_spin_lock_irqsave(&pool->lock, flags);
>  		if (pool->nr_workers == pool->nr_idle)
>  			goto next_pool;
> -
> +		/*
> +		 * Defer printing to avoid deadlocks in console drivers that
> +		 * queue work while holding locks also taken in their write
> +		 * paths.
> +		 */
> +		printk_deferred_enter();
>  		pr_info("pool %d:", pool->id);
>  		pr_cont_pool_info(pool);
>  		pr_cont(" hung=%us workers=%d",
> @@ -4864,6 +4877,7 @@ void show_workqueue_state(void)
>  			first = false;
>  		}
>  		pr_cont("\n");
> +		printk_deferred_exit();
>  	next_pool:
>  		raw_spin_unlock_irqrestore(&pool->lock, flags);
>  		/*
> -- 
> 2.32.0
