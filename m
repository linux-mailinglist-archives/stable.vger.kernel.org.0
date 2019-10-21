Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38550DF111
	for <lists+stable@lfdr.de>; Mon, 21 Oct 2019 17:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728183AbfJUPRM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Oct 2019 11:17:12 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51794 "HELO
        iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1727945AbfJUPRM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Oct 2019 11:17:12 -0400
Received: (qmail 4979 invoked by uid 2102); 21 Oct 2019 11:17:11 -0400
Received: from localhost (sendmail-bs@127.0.0.1)
  by localhost with SMTP; 21 Oct 2019 11:17:11 -0400
Date:   Mon, 21 Oct 2019 11:17:11 -0400 (EDT)
From:   Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To:     Johan Hovold <johan@kernel.org>
cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Oliver Neukum <oneukum@suse.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH RFC v2 2/2] USB: ldusb: fix ring-buffer locking
In-Reply-To: <20191018151955.25135-3-johan@kernel.org>
Message-ID: <Pine.LNX.4.44L0.1910211109400.1673-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 18 Oct 2019, Johan Hovold wrote:

> The custom ring-buffer implementation was merged without any locking
> whatsoever, but a spinlock was later added by commit 9d33efd9a791
> ("USB: ldusb bugfix").
> 
> The lock did not cover the loads from the ring-buffer entry after
> determining the buffer was non-empty, nor the update of the tail index
> once the entry had been processed. The former could lead to stale data
> being returned, while the latter could lead to memory corruption on
> sufficiently weakly ordered architectures.

Let's see if I understand this correctly.

The completion routine stores a buffer-length value at the location 
actual_buffer points to, and it stores the buffer contents themselves 
in the immediately following bytes.  All this happens while the 
dev->rbsl spinlock is held.

Later on the read routine loads a value from *actual_buffer while
holding the spinlock, but drops the spinlock before copying the
immediately following buffer contents to userspace.

Your question is whether the read routine needs to call smp_rmb() after 
dropping the spinlock and before doing copy_to_user(), right?

The answer is: No, smp_rmb() isn't needed.  All the data stored while
ld_usb_interrupt_in_callback() held the spinlock will be visible to
ld_usb_read() while it holds the spinlock and afterward (assuming the
critical section in ld_usb_read() runs after the critical section in 
ld_usb_interrupt_in_callback() -- but you know this is true because of 
the value you read from *actual_buffer).

Alan Stern

> Fixes: 2824bd250f0b ("[PATCH] USB: add ldusb driver")
> Fixes: 9d33efd9a791 ("USB: ldusb bugfix")
> Cc: stable <stable@vger.kernel.org>     # 2.6.13
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
>  drivers/usb/misc/ldusb.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/usb/misc/ldusb.c b/drivers/usb/misc/ldusb.c
> index 15b5f06fb0b3..6b5843b0071e 100644
> --- a/drivers/usb/misc/ldusb.c
> +++ b/drivers/usb/misc/ldusb.c
> @@ -477,11 +477,11 @@ static ssize_t ld_usb_read(struct file *file, char __user *buffer, size_t count,
>  
>  		spin_lock_irq(&dev->rbsl);
>  	}
> -	spin_unlock_irq(&dev->rbsl);
>  
>  	/* actual_buffer contains actual_length + interrupt_in_buffer */
>  	actual_buffer = (size_t *)(dev->ring_buffer + dev->ring_tail * (sizeof(size_t)+dev->interrupt_in_endpoint_size));
>  	if (*actual_buffer > dev->interrupt_in_endpoint_size) {
> +		spin_unlock_irq(&dev->rbsl);
>  		retval = -EIO;
>  		goto unlock_exit;
>  	}
> @@ -489,17 +489,26 @@ static ssize_t ld_usb_read(struct file *file, char __user *buffer, size_t count,
>  	if (bytes_to_read < *actual_buffer)
>  		dev_warn(&dev->intf->dev, "Read buffer overflow, %zd bytes dropped\n",
>  			 *actual_buffer-bytes_to_read);
> +	spin_unlock_irq(&dev->rbsl);
> +
> +	/*
> +	 * Pairs with spin_unlock_irqrestore() in
> +	 * ld_usb_interrupt_in_callback() and makes sure the ring-buffer entry
> +	 * has been updated before copy_to_user().
> +	 */
> +	smp_rmb();
>  
>  	/* copy one interrupt_in_buffer from ring_buffer into userspace */
>  	if (copy_to_user(buffer, actual_buffer+1, bytes_to_read)) {
>  		retval = -EFAULT;
>  		goto unlock_exit;
>  	}
> -	dev->ring_tail = (dev->ring_tail+1) % ring_buffer_size;
> -
>  	retval = bytes_to_read;
>  
>  	spin_lock_irq(&dev->rbsl);
> +
> +	dev->ring_tail = (dev->ring_tail + 1) % ring_buffer_size;
> +
>  	if (dev->buffer_overflow) {
>  		dev->buffer_overflow = 0;
>  		spin_unlock_irq(&dev->rbsl);
> 


