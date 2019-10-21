Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6A3DF50E
	for <lists+stable@lfdr.de>; Mon, 21 Oct 2019 20:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbfJUSaS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Oct 2019 14:30:18 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:34605 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727110AbfJUSaS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Oct 2019 14:30:18 -0400
Received: by mail-lj1-f195.google.com with SMTP id j19so14437258lja.1;
        Mon, 21 Oct 2019 11:30:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ts+6T0Vx6W3F2XGuWMeDvC9HfhWnz9E3GMgfVXKqPzU=;
        b=Xh0vRa1SUTsa5mon0D0odHCTz3qjmUG/i4uECjMHoMdQJ0gxmBaWuCQdoYZ3v+WgfL
         9D31h2qMA+jKMawzrqP1ZVPeNr9DrYSt0oqBJJEfySO/jbADutZTYsp0HnOK0RiM+ZeN
         YZ8Yxc4DCAd/8fvTKFLq9Ag5hjxfRunYPzzh7v+DK/AwCFM43j7ngsk+NK5NzG3qmN1b
         bKgiuzq2Wq2ZLhJRfQVhv0cfOUCkHJ+9EHmVpwzZG8jSWAkRR/Z0MgWggXYFh3pQ0dw0
         BFoysrSEJc4d7vXbRKG/S3JvRrEhIHYm/P4VHkOc0bbYlGHmselAlZSJZhUhNYAaRpnM
         +35g==
X-Gm-Message-State: APjAAAUw/BhVy9Rn+hpTU+hfnX07+TcoCV3hzwjWuLHSFrDS/LI+gDCQ
        /R9BW5Dz1zu5XdAl1KWbI0k=
X-Google-Smtp-Source: APXvYqypIus5VQMILkgXDjCXtHwwFtmkZfWifAW4OFA0PaZJTvPnERZNy5029fmXfI5d/oCydol5Ow==
X-Received: by 2002:a2e:a0d6:: with SMTP id f22mr16159186ljm.81.1571682614838;
        Mon, 21 Oct 2019 11:30:14 -0700 (PDT)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id 77sm7313934ljf.85.2019.10.21.11.30.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Oct 2019 11:30:13 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92.2)
        (envelope-from <johan@kernel.org>)
        id 1iMcRn-00032x-L2; Mon, 21 Oct 2019 20:30:27 +0200
Date:   Mon, 21 Oct 2019 20:30:27 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Oliver Neukum <oneukum@suse.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH RFC v2 2/2] USB: ldusb: fix ring-buffer locking
Message-ID: <20191021183027.GN24768@localhost>
References: <20191018151955.25135-3-johan@kernel.org>
 <Pine.LNX.4.44L0.1910211109400.1673-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1910211109400.1673-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 21, 2019 at 11:17:11AM -0400, Alan Stern wrote:
> On Fri, 18 Oct 2019, Johan Hovold wrote:
> 
> > The custom ring-buffer implementation was merged without any locking
> > whatsoever, but a spinlock was later added by commit 9d33efd9a791
> > ("USB: ldusb bugfix").
> > 
> > The lock did not cover the loads from the ring-buffer entry after
> > determining the buffer was non-empty, nor the update of the tail index
> > once the entry had been processed. The former could lead to stale data
> > being returned, while the latter could lead to memory corruption on
> > sufficiently weakly ordered architectures.
> 
> Let's see if I understand this correctly.
> 
> The completion routine stores a buffer-length value at the location 
> actual_buffer points to, and it stores the buffer contents themselves 
> in the immediately following bytes.  All this happens while the 
> dev->rbsl spinlock is held.

Right.

> Later on the read routine loads a value from *actual_buffer while
> holding the spinlock, but drops the spinlock before copying the
> immediately following buffer contents to userspace.

It doesn't currently hold the spinlock while reading *actual_buffer,
only when checking if the ring-buffer is non-empty. The patch below
extends the check to cover also the load from *actual_buffer.

> Your question is whether the read routine needs to call smp_rmb() after 
> dropping the spinlock and before doing copy_to_user(), right?

Right, or alternatively, if an smp_rmb() after dropping the spinlock and
before loading *actual_buffer is needed.

> The answer is: No, smp_rmb() isn't needed.  All the data stored while
> ld_usb_interrupt_in_callback() held the spinlock will be visible to
> ld_usb_read() while it holds the spinlock and afterward (assuming the
> critical section in ld_usb_read() runs after the critical section in 
> ld_usb_interrupt_in_callback() -- but you know this is true because of 
> the value you read from *actual_buffer).

Did you mean the value "read from dev->ring_head" (which tells us the
ring-buffer has been updated) here?

We currently have something like this in ld_usb_read():

	spin_lock_irq(&lock);
	while (head == tail) {
		spin_unlock(&lock);
		wait_event(event);
		spin_lock(&lock);
	}
	spin_unlock_irq(&lock);

	entry = &buffer[tail];
	len = *entry;
	copy_to_user(buf, entry + 1, len);

	/* update tail */

And without an smp_rmb() after dropping the spinlock, what prevents the
load from *entry from being done before the load from head? Nothing,
right (the spin_unlock_irq() is only a compiler barrier for later
loads)? But that's fine because all stores done by the completion
handler under the spinlock would of course be visible at that point.

So the current code is fine wrt to copy_to_user(), and only the tail
bits below are actually needed.

Thanks, Alan! Had myself confused there.

Johan

> > Fixes: 2824bd250f0b ("[PATCH] USB: add ldusb driver")
> > Fixes: 9d33efd9a791 ("USB: ldusb bugfix")
> > Cc: stable <stable@vger.kernel.org>     # 2.6.13
> > Signed-off-by: Johan Hovold <johan@kernel.org>
> > ---
> >  drivers/usb/misc/ldusb.c | 15 ++++++++++++---
> >  1 file changed, 12 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/usb/misc/ldusb.c b/drivers/usb/misc/ldusb.c
> > index 15b5f06fb0b3..6b5843b0071e 100644
> > --- a/drivers/usb/misc/ldusb.c
> > +++ b/drivers/usb/misc/ldusb.c
> > @@ -477,11 +477,11 @@ static ssize_t ld_usb_read(struct file *file, char __user *buffer, size_t count,
> >  
> >  		spin_lock_irq(&dev->rbsl);
> >  	}
> > -	spin_unlock_irq(&dev->rbsl);
> >  
> >  	/* actual_buffer contains actual_length + interrupt_in_buffer */
> >  	actual_buffer = (size_t *)(dev->ring_buffer + dev->ring_tail * (sizeof(size_t)+dev->interrupt_in_endpoint_size));
> >  	if (*actual_buffer > dev->interrupt_in_endpoint_size) {
> > +		spin_unlock_irq(&dev->rbsl);
> >  		retval = -EIO;
> >  		goto unlock_exit;
> >  	}
> > @@ -489,17 +489,26 @@ static ssize_t ld_usb_read(struct file *file, char __user *buffer, size_t count,
> >  	if (bytes_to_read < *actual_buffer)
> >  		dev_warn(&dev->intf->dev, "Read buffer overflow, %zd bytes dropped\n",
> >  			 *actual_buffer-bytes_to_read);
> > +	spin_unlock_irq(&dev->rbsl);
> > +
> > +	/*
> > +	 * Pairs with spin_unlock_irqrestore() in
> > +	 * ld_usb_interrupt_in_callback() and makes sure the ring-buffer entry
> > +	 * has been updated before copy_to_user().
> > +	 */
> > +	smp_rmb();
> >  
> >  	/* copy one interrupt_in_buffer from ring_buffer into userspace */
> >  	if (copy_to_user(buffer, actual_buffer+1, bytes_to_read)) {
> >  		retval = -EFAULT;
> >  		goto unlock_exit;
> >  	}
> > -	dev->ring_tail = (dev->ring_tail+1) % ring_buffer_size;
> > -
> >  	retval = bytes_to_read;
> >  
> >  	spin_lock_irq(&dev->rbsl);
> > +
> > +	dev->ring_tail = (dev->ring_tail + 1) % ring_buffer_size;
> > +
> >  	if (dev->buffer_overflow) {
> >  		dev->buffer_overflow = 0;
> >  		spin_unlock_irq(&dev->rbsl);
> > 
> 
> 
