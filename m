Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF0ED25AE80
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 17:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgIBPNH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 11:13:07 -0400
Received: from netrider.rowland.org ([192.131.102.5]:42903 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1727921AbgIBPMk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Sep 2020 11:12:40 -0400
Received: (qmail 626110 invoked by uid 1000); 2 Sep 2020 11:12:33 -0400
Date:   Wed, 2 Sep 2020 11:12:33 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+c2c3302f9c601a4b1be2@syzkaller.appspotmail.com
Subject: Re: [PATCH 4.19 108/125] USB: yurex: Fix bad gfp argument
Message-ID: <20200902151233.GC624583@rowland.harvard.edu>
References: <20200901150934.576210879@linuxfoundation.org>
 <20200901150939.905188730@linuxfoundation.org>
 <20200902125827.GA8817@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200902125827.GA8817@duo.ucw.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 02, 2020 at 02:58:27PM +0200, Pavel Machek wrote:
> Hi!
> 
> > The syzbot fuzzer identified a bug in the yurex driver: It passes
> > GFP_KERNEL as a memory-allocation flag to usb_submit_urb() at a time
> > when its state is TASK_INTERRUPTIBLE, not TASK_RUNNING:
> 
> Yeah, and instead of fixing the bug, patch papers over it, reducing
> reliability of the driver in the process.
> 
> > This patch changes the call to use GFP_ATOMIC instead of GFP_KERNEL.
> 
> Fixing it properly should be as simple as moving prepare_to_wait down,
> no?

Sigh.  That never occurred to me, but of course it is right.

Acked-by: Alan Stern <stern@rowland.harvard.edu>

Alan Stern

> Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>
> 
> diff --git a/drivers/usb/misc/yurex.c b/drivers/usb/misc/yurex.c
> index 785080f79073..5fbbb57e6e95 100644
> --- a/drivers/usb/misc/yurex.c
> +++ b/drivers/usb/misc/yurex.c
> @@ -489,10 +489,10 @@ static ssize_t yurex_write(struct file *file, const char __user *user_buffer,
>  	}
>  
>  	/* send the data as the control msg */
> -	prepare_to_wait(&dev->waitq, &wait, TASK_INTERRUPTIBLE);
>  	dev_dbg(&dev->interface->dev, "%s - submit %c\n", __func__,
>  		dev->cntl_buffer[0]);
> -	retval = usb_submit_urb(dev->cntl_urb, GFP_ATOMIC);
> +	retval = usb_submit_urb(dev->cntl_urb, GFP_KERNEL);
> +	prepare_to_wait(&dev->waitq, &wait, TASK_INTERRUPTIBLE);
>  	if (retval >= 0)
>  		timeout = schedule_timeout(YUREX_WRITE_TIMEOUT);
>  	finish_wait(&dev->waitq, &wait);
> 
> 
> Best regards,
> 									Pavel
> 
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html


