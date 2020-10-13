Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7C6128CC47
	for <lists+stable@lfdr.de>; Tue, 13 Oct 2020 13:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731014AbgJMLKT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Oct 2020 07:10:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:44194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726662AbgJMLKS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Oct 2020 07:10:18 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49EFF214DB;
        Tue, 13 Oct 2020 11:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602587417;
        bh=QM+nvI722PuUaCbJjwtF4VtruSHvxnlMXoRt5pyjiIc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MNCTYpBtgN5rwgqV64fESdMTkMO3SXBldohkqvVSaMG+SE8H51511hmPidRonjKPm
         fyddFGNix2Qos55yYTQk2CCxEK4Mhr0PhkTTwC8RDuoEyiypTd4PnE/mOkeuCbEOds
         CKLU+0NkQ1qH+6fTM8OovISWzIofHRg6jpiW9u4E=
Date:   Tue, 13 Oct 2020 13:10:55 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pratham Pratap <prathampratap@codeaurora.org>
Cc:     stern@rowland.harvard.edu, rafael.j.wysocki@intel.com,
        mathias.nyman@linux.intel.com, andriy.shevchenko@linux.intel.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        sallenki@codeaurora.org, mgautam@codeaurora.org,
        jackp@codeaurora.org, stable@vger.kernel.org
Subject: Re: [PATCH] usb: core: Don't wait for completion of urbs
Message-ID: <20201013111055.GA1942304@kroah.com>
References: <1602586022-13239-1-git-send-email-prathampratap@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1602586022-13239-1-git-send-email-prathampratap@codeaurora.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 13, 2020 at 04:17:02PM +0530, Pratham Pratap wrote:
> Consider a case where host is trying to submit urbs to the
> connected device while holding the us->dev_mutex and due to
> some reason it is stuck while waiting for the completion of
> the urbs. Now the scsi error mechanism kicks in and it calls
> the device reset handler which is trying to acquire the same
> mutex causing a deadlock situation.
> 
> Below is the call stack of the task which acquired the mutex
> (0xFFFFFFC660447460) and waiting for completion.
> 
> B::v.f_/task_0xFFFFFFC6604DB280
> -000|__switch_to(prev = 0xFFFFFFC6604DB280, ?)
> -001|prepare_lock_switch(inline)
> -001|context_switch(inline)
> -001|__schedule(?)
> -002|schedule()
> -003|schedule_timeout(timeout = 9223372036854775807)
> -004|do_wait_for_common(x = 0xFFFFFFC660447570,
> action = 0xFFFFFF98ED5A7398, timeout = 9223372036854775807, ?)
> -005|spin_unlock_irq(inline)
> -005|__wait_for_common(inline)
> -005|wait_for_common(inline)
> -005|wait_for_completion(x = 0xFFFFFFC660447570)
> -006|sg_clean(inline)
> -006|usb_sg_wait()
> -007|atomic64_andnot(inline)
> -007|atomic_long_andnot(inline)
> -007|clear_bit(inline)
> -007|usb_stor_bulk_transfer_sglist(us = 0xFFFFFFC660447460,
> pipe = 3221291648, sg = 0xFFFFFFC65D6415D0, ?, length = 512,
> act_len = 0xFFFFFF801258BC90)

No need to line-wrap for stuff like this.



> -008|scsi_bufflen(inline)
> -008|usb_stor_bulk_srb(inline)
> -008|usb_stor_Bulk_transport(srb = 0xFFFFFFC65D641438,
> us = 0xFFFFFFC660447460)
> -009|test_bit(inline)
> -009|usb_stor_invoke_transport(srb = 0xFFFFFFC65D641438,
> us = 0xFFFFFFC660447460)
> -010|usb_stor_transparent_scsi_command(?, ?)
> -011|usb_stor_control_thread(__us = 0xFFFFFFC660447460)  //us->dev_mutex
> -012|kthread(_create = 0xFFFFFFC6604C5E80)
> -013|ret_from_fork(asm)
>  ---|end of frame
> 
> Below is the call stack of the task which trying to acquire the same
> mutex(0xFFFFFFC660447460) in the error handling path.
> 
> B::v.f_/task_0xFFFFFFC6609AA1C0
> -000|__switch_to(prev = 0xFFFFFFC6609AA1C0, ?)
> -001|prepare_lock_switch(inline)
> -001|context_switch(inline)
> -001|__schedule(?)
> -002|schedule()
> -003|schedule_preempt_disabled()
> -004|__mutex_lock_common(lock = 0xFFFFFFC660447460, state = 2, ?, ?, ?,
> ?, ?)
> -005|__mutex_lock_slowpath(?)
> -006|__cmpxchg_acq(inline)
> -006|__mutex_trylock_fast(inline)
> -006|mutex_lock(lock = 0xFFFFFFC660447460)   //us->dev_mutex
> -007|device_reset(?)
> -008|scsi_try_bus_device_reset(inline)
> -008|scsi_eh_bus_device_reset(inline)
> -008|scsi_eh_ready_devs(shost = 0xFFFFFFC660446C80,
> work_q = 0xFFFFFF80191C3DE8, done_q = 0xFFFFFF80191C3DD8)
> -009|scsi_error_handler(data = 0xFFFFFFC660446C80)
> -010|kthread(_create = 0xFFFFFFC66042C080)
> -011|ret_from_fork(asm)
>  ---|end of frame
> 
> Fix this by adding 5 seconds timeout while waiting for completion.
> 
> Fixes: 3e35bf39e (USB: fix codingstyle issues in drivers/usb/core/message.c)

Please read the documentation for how to properly add a Fixes: line
(hint, your sha1 isn't big enough.)

And does this really "fix" a commit that chnaged the coding style?  I
doubt that...

> Cc: stable@vger.kernel.org
> Signed-off-by: Pratham Pratap <prathampratap@codeaurora.org>
> ---
>  drivers/usb/core/message.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
> index ae1de9c..b1e839c 100644
> --- a/drivers/usb/core/message.c
> +++ b/drivers/usb/core/message.c
> @@ -515,15 +515,13 @@ EXPORT_SYMBOL_GPL(usb_sg_init);
>   */
>  void usb_sg_wait(struct usb_sg_request *io)
>  {
> -	int i;
> +	int i, retval;
>  	int entries = io->entries;
>  
>  	/* queue the urbs.  */
>  	spin_lock_irq(&io->lock);
>  	i = 0;
>  	while (i < entries && !io->status) {
> -		int retval;
> -
>  		io->urbs[i]->dev = io->dev;
>  		spin_unlock_irq(&io->lock);
>  
> @@ -569,7 +567,13 @@ void usb_sg_wait(struct usb_sg_request *io)
>  	 * So could the submit loop above ... but it's easier to
>  	 * solve neither problem than to solve both!
>  	 */
> -	wait_for_completion(&io->complete);
> +	retval = wait_for_completion_timeout(&io->complete,
> +						msecs_to_jiffies(5000));

Where did you pick 5 seconds from?  Are you sure that will work
properly?  What about devices with very long i/o stalls when data is
being flushed out, are you sure this will not trigger there?

> +	if (retval == 0) {
> +		dev_err(&io->dev->dev, "%s, timed out while waiting for io_complete\n",
> +				__func__);
> +		usb_sg_cancel(io);

So this is cancelled, but how does userspace know the error happened and
it was a timeout?

thanks,

greg k-h
