Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34C3B423B3B
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 12:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237885AbhJFKIy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 06:08:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:59408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237851AbhJFKIx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Oct 2021 06:08:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF0FB60F9E;
        Wed,  6 Oct 2021 10:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633514822;
        bh=nOOF4YLWBiXhevUt6Vd3TwpA1r313kmZLGqkn3CNjxw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sjxcnEkavf6OaKEnFcwjtBQb7rtQjR8ZfE1jaOB31ZumMGYprVESNdNzAHETh53ac
         MWxHrtB61YUUpQyGLtyG8fwGjAC4/aTt2N3YtQ/ColA8w8iUIJoT+3q8GAR8BfvfgU
         /fhbChpCKVuNNqz19xdPWmmQ3VFpP3Ja8yoKxYKf9WKRFSnmJLSCCbHuKuprF+bQwy
         8CUWn9fIrTUNZQOuIEW40JBAOsO3gXVkLvXxOfnfwIqEm8NFeAXwHcOF4JZt4lD3Qd
         H2KLWCjTTzSRFrL4UuJ15z72+a10PDJg9afOEgcxrBq4JxbMaiCJPrF9L9QvqNOfeC
         L76O95w+HqAQw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mY3pG-0005c1-4x; Wed, 06 Oct 2021 12:07:02 +0200
Date:   Wed, 6 Oct 2021 12:07:02 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Ogness <john.ogness@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fabio Estevam <festevam@denx.de>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] workqueue: fix state-dump console deadlock
Message-ID: <YV11RhWOroeHjbyU@hovoldconsulting.com>
References: <YV1Z8JslFiBSFGJF@hovoldconsulting.com>
 <20211006081115.20451-1-johan@kernel.org>
 <YV1qBZiXx/IADcb6@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YV1qBZiXx/IADcb6@alley>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 06, 2021 at 11:19:01AM +0200, Petr Mladek wrote:
> On Wed 2021-10-06 10:11:15, Johan Hovold wrote:
> > Console drivers often queue work while holding locks also taken in their
> > console write paths, something which can lead to deadlocks on SMP when
> > dumping workqueue state (e.g. sysrq-t or on suspend failures).
> > 
> > For serial console drivers this could look like:
> > 
> > 	CPU0				CPU1
> > 	----				----
> > 
> > 	show_workqueue_state();
> > 	  lock(&pool->lock);		<IRQ>
> > 	  				  lock(&port->lock);
> > 					  schedule_work();
> > 					    lock(&pool->lock);
> > 	  printk();
> > 	    lock(console_owner);
> > 	    lock(&port->lock);
> > 
> > where workqueues are, for example, used to push data to the line
> > discipline, process break signals and handle modem-status changes. Line
> > disciplines and serdev drivers can also queue work on write-wakeup
> > notifications, etc.
> > 
> > Reworking every console driver to avoid queuing work while holding locks
> > also taken in their write paths would complicate drivers and is neither
> > desirable or feasible.
> > 
> > Instead use the deferred-printk mechanism to avoid printing while
> > holding pool locks when dumping workqueue state.
> > 
> > Note that there are a few WARN_ON() assertions in the workqueue code
> > which could potentially also trigger a deadlock. Hopefully the ongoing
> > printk rework will provide a general solution for this eventually.
> > 
> > This was originally reported after a lockdep splat when executing
> > sysrq-t with the imx serial driver.
> > 
> > Fixes: 3494fc30846d ("workqueue: dump workqueues on sysrq-t")
> > Cc: stable@vger.kernel.org	# 4.0
> > Reported-by: Fabio Estevam <festevam@denx.de>
> > Signed-off-by: Johan Hovold <johan@kernel.org>
> > ---
> >  kernel/workqueue.c | 10 +++++++++-
> >  1 file changed, 9 insertions(+), 1 deletion(-)
> > 
> > diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> > index 33a6b4a2443d..fded64b48b96 100644
> > --- a/kernel/workqueue.c
> > +++ b/kernel/workqueue.c
> > @@ -4830,8 +4830,16 @@ void show_workqueue_state(void)
> >  
> >  		for_each_pwq(pwq, wq) {
> >  			raw_spin_lock_irqsave(&pwq->pool->lock, flags);
> > -			if (pwq->nr_active || !list_empty(&pwq->inactive_works))
> > +			if (pwq->nr_active || !list_empty(&pwq->inactive_works)) {
> > +				/*
> > +				 * Defer printing to avoid deadlocks in console
> > +				 * drivers that queue work while holding locks
> > +				 * also taken in their write paths.
> > +				 */
> > +				printk_deferred_enter();
> >  				show_pwq(pwq);
> > +				printk_deferred_exit();
> > +			}
> >  			raw_spin_unlock_irqrestore(&pwq->pool->lock, flags);
> >  			/*
> >  			 * We could be printing a lot from atomic context, e.g.
> 
> This handles only one printk() caller. But there are many more callers
> under pool->lock, for example in the next for-cycle in this function:
> 
> 	for_each_pool(pool, pi) {
> 		raw_spin_lock_irqsave(&pool->lock, flags);
> [...]
> 		pr_info("pool %d:", pool->id);
> 		pr_cont_pool_info(pool);
> 		pr_cont(" hung=%us workers=%d",

Heh, thanks for catching that one. As noted above, I did look through
the other instances, which are mostly asserts, but missed this obvious
one.

There does not seem to be "many more callers" under the pool lock when
not counting the WARN_ON()s (which we also have in the scheduler code).

> And this is the problem with printk_deferred() and printk_deferred_enter().
> It is a "catch a mole" approach. It might end up with switching half
> of the kernel into printk_deferred().

The workqueue implementation is core infrastructure where, like in the
scheduler, some extra care can be justified.
 
> John Ogness is working on a generic solution where any printk() will
> be deferred out of box. consoles will be called from a dedicated
> kthreads.
> 
> John has already worked on reworking printk() two years or so. It gets
> slowly because we need to be careful. Also we started with
> implementing lockless ringbuffer which was a big challenge. Anyway, there
> is a stable progress. The lockless ringbuffer is done. And the
> kthreads are the very next step.
> 
> printk_deferred() is currently used only in the scheduler code where
> the deadlocks really happened in the past. 

It's actually used in a few places outside of the scheduler already to
prevent deadlocks and suppress lockdep warnings.

> printk_deferred_enter()
> is used only in printk() because it would be otherwise hard to debug
> and lockdep would always report problems there.

printk_deferred_enter() is also used in a couple of places outside of
printk already.

> From this perspective, I suggest to ignore this possible deadlock if
> they do not happen in the real life.
> 
> If you really want to avoid the lockdep report. Alternative and
> probably easier workaround is to temporary disable lockdep around
> queuing the work in the console code.

Now *that* would be playing whack-a-mole. As I alluded to in the commit
message there are ton of places where we queue work under the serial
driver port lock and its generally not done explicitly in the drivers
themselves but rather in the tty layer helpers, line disciplines, serdev
drivers, etc.

Disabling lockdep is not an option here.

> I do not see any reason
> why workqueue code would call back to console code directly.
> So the only source of a possible deadlock is the printk() path.
> But I think that it is not worth it. It is better to concentrate
> on the printk() rework.

Right, it's only printk, and it's only in show_workqueue_state() (when
ignoring the assertions). Since we can't suppress the lockdep warning in
the console drivers, and since this function is called outside of sysrq
handling too (e.g. on suspend failures), I'd say the workaround is
warranted until the printk rework is done.

Johan
