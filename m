Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F54A3B7E69
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 09:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233022AbhF3IAi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 04:00:38 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:42640 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232788AbhF3IAh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Jun 2021 04:00:37 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 6E9881FE49;
        Wed, 30 Jun 2021 07:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625039888; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UYwudJQvE/P1/JgBMyFI0UJyzcBpmhJEU0VqB/kinxI=;
        b=aGWAmdBp69e9o+mZojP67Bo5yQFF4Wt56wZxe3gChcxQ28ZO4asaecShm48LPdwtvX2nu8
        ZaMpGfEOU7oNSTjOvzb2t01HeOORwg50F0LNWesV8ngy5488xsJvc6q3VQ+0zJqSAfvqTs
        Cp/VsBpUX0+KCA4mzvnC61XsYozu2ms=
Received: from suse.cz (unknown [10.100.224.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 1FFE7A3B8F;
        Wed, 30 Jun 2021 07:58:08 +0000 (UTC)
Date:   Wed, 30 Jun 2021 09:58:07 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Sergey Senozhatsky <senozhatsky@chromium.org>
Cc:     John Ogness <john.ogness@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] printk/console: Check consistent sequence number when
 handling race in console_unlock()
Message-ID: <YNwkD3bTikepZr+k@alley>
References: <20210629143341.19284-1-pmladek@suse.com>
 <YNs/Vbi2Yt0s10Ye@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YNs/Vbi2Yt0s10Ye@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed 2021-06-30 00:42:13, Sergey Senozhatsky wrote:
> On (21/06/29 16:33), Petr Mladek wrote:
> > The standard printk() tries to flush the message to the console
> > immediately. It tries to take the console lock. If the lock is
> > already taken then the current owner is responsible for flushing
> > even the new message.
> > 
> > There is a small race window between checking whether a new message is
> > available and releasing the console lock. It is solved by re-checking
> > the state after releasing the console lock. If the check is positive
> > then console_unlock() tries to take the lock again and process the new
> > message as well.
> [..]
> > diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> > index 142a58d124d9..87411084075e 100644
> > --- a/kernel/printk/printk.c
> > +++ b/kernel/printk/printk.c
> > @@ -2545,6 +2545,7 @@ void console_unlock(void)
> >  	bool do_cond_resched, retry;
> >  	struct printk_info info;
> >  	struct printk_record r;
> > +	u64 next_seq;
> >  
> >  	if (console_suspended) {
> >  		up_console_sem();
> > @@ -2654,8 +2655,10 @@ void console_unlock(void)
> >  			cond_resched();
> >  	}
> >  
> > -	console_locked = 0;
> > +	/* Get consistent value of the next-to-be-used sequence number. */
> > +	next_seq = console_seq;
> >  
> > +	console_locked = 0;
> >  	up_console_sem();
> >  
> >  	/*
> > @@ -2664,7 +2667,7 @@ void console_unlock(void)
> >  	 * there's a new owner and the console_unlock() from them will do the
> >  	 * flush, no worries.
> >  	 */
> > -	retry = prb_read_valid(prb, console_seq, NULL);
> > +	retry = prb_read_valid(prb, next_seq, NULL);
> >  	printk_safe_exit_irqrestore(flags);
> >  
> >  	if (retry && console_trylock())
> 
> Maybe it's too late here in my time zone, but what are the consequences
> of this race?
> 
> `retry` can be falsely set, console_trylock() does not spin on owner,
> so the context that just released the lock can grab it again only if
> it's unlocked. For the context that just has released the console_sem
> and then acquired it again, because of the race, - console_seq will be
> valid after it acquires the lock, then it'll jump to `retry` and
> re-validated the console_seq - prb_read_valid(). If it's valid, it'll
> print the message; and should another CPU printk that CPU will spin on
> owner and then the current console_sem owner will yield to it via
> console_lock_spinning branch.

I am not sure that I follow it correctly. IMHO, there are two possible
races. I believe that you are talking about the 2nd scenario:

1st scenario: console_unlock() retries but the message has been proceed
   in the meantime:

CPU0				CPU1

console_unlock()

  // process all pending messages
  next_seq = 100;
  up_console_sem();

				printk()
				  vprintk_store()
				    // storing message with seq = 100;

				  console_trylock_spinning()
				     //succees
				  console_unlock()
				    // show message with seq == 100
				    console_seq++; (101)

				  next_seq = 101;
				  up_consle_sem()

   retry = prb_read_valid(prb, next_seq, NULL);
     // true because next_seq == 100
   goto retry;

   if (!prb_read_valid(prb, console_seq, &r))
     break;
     // breaks because console_seq == 101

Result: CPU0 retired just to realize that the message
	has already been procceed.


2nd scenario: printk() caller spins when other process is already
	processing it's message


CPU0				CPU1

printk()
  vprintk_store()
     // storing message with seq == 100

  console_trylock_spinning()
     // succees
  console_unlock()
    // show message with seq == 100
      console_seq++; (=> 101)

      next_seq = 101;
      up_console_sem();

			       printk()
				  vprintk_store()
				  // storing message with seq == 101

     retry = prb_read_valid(prb, next_seq, NULL);
     // true because next_seq == 101
     goto retry

     if (!prb_read_valid(prb, console_seq, &r))
       // read messages with seq == 101

     console_seq++;  (=> 102)

     console_lock_spinning_enable();
     call_console_drivers();

				  console_trylock_spinning()
				    // spinning

     if (console_lock_spinning_disable_and_check())
	return;

     // returns because there is a waiter

				  // got the console lock
				  console_unlock()
				    if (!prb_read_valid(prb, console_seq, &r))
				      break;
				     // breaks because console_seq == 102


Result: CPU1 was spinning just to realize that the message has already
	been proceed.


It is not ideal. But the result is always correct.

The races have been there already before. Only the race window in 1st
scenario was a bit smaller.

Anyway, thanks for the review.

Best Regards,
Petr
