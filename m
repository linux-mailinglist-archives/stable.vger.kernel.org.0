Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70EF925AD51
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 16:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728054AbgIBOej (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 10:34:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:56062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726536AbgIBOdb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Sep 2020 10:33:31 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B3B120767;
        Wed,  2 Sep 2020 14:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599057211;
        bh=GJvqew05Py7QV1HcYccezvT/3PxU9L2gfVZbPKDWrX8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m/jI/Yc3d9f1NBAQYd906X36mapA84DkPwAITxMP3wrJKl8WPASakCthYJDIyUKWy
         0KDxicBe9u7VndoWth8db5DfeVJ/cN6TKHAK/bGzJ9SeCwOo/a4fCDhmBWr2X/bgtI
         5Y649WtWEwF3IdxYDd7XGVnv8kacRU13EaxCLt9U=
Date:   Wed, 2 Sep 2020 16:33:56 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        syzbot+c2c3302f9c601a4b1be2@syzkaller.appspotmail.com
Subject: Re: [PATCH 4.19 108/125] USB: yurex: Fix bad gfp argument
Message-ID: <20200902143356.GA2024340@kroah.com>
References: <20200901150934.576210879@linuxfoundation.org>
 <20200901150939.905188730@linuxfoundation.org>
 <20200902125827.GA8817@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200902125827.GA8817@duo.ucw.cz>
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
> 
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

I can't take patches like this, you know that...
