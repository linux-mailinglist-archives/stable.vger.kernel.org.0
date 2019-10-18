Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 945E8DC803
	for <lists+stable@lfdr.de>; Fri, 18 Oct 2019 17:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2634229AbfJRPDW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 11:03:22 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:45116 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2634203AbfJRPDW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Oct 2019 11:03:22 -0400
Received: by mail-lj1-f195.google.com with SMTP id q64so6531590ljb.12;
        Fri, 18 Oct 2019 08:03:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=XFN5CU9XZuSVc2bYbY/HDqoKRZEKGUyQPQg3On2l0sE=;
        b=gBkToDaoKGRVwJreDGo607Fv70ru++/1xO32/vIMRQhKLqTYQ7kahpEbeCj8Di84as
         63/7G6dKfn3FRVVa29BE6NwahNXhuruXe1k4tVqjjD/q9CiEw1n1XOPnTrUvjmZ6KVf3
         6wWscf7tiT662US35hZfwOqHA5jyJk9V1tAKKO9aHwcU0dj8IQKm0Nqb84bP6yN5D50q
         kZ6ZFFB+F/h4AD3/yVlo+FkeiOj3B4cJ2gLJNDwYdaa9Gk5n6t66BnBek24ZifmP0REZ
         3LeUgbu3K9D12FrLLa9z+CcchT+KTVllIgjWM0YbQegN/ku3/xfDSvXqDbUQ7OD+0ZeT
         2Ovg==
X-Gm-Message-State: APjAAAUEpIBkH7Fz+o7IYvyxHBvYs8kCiHitk1bZzKfeqRjiOc8LIhXO
        NNtzyq/0g/SSTykpOx/jWmg=
X-Google-Smtp-Source: APXvYqwxdjJ+MtoBj9uhvCnlqOpwlR/Dxd78cC1h8ehsF5PmgDyA+G27aJtxy1wsDyFkxYXymLe/1g==
X-Received: by 2002:a2e:481a:: with SMTP id v26mr4158614lja.41.1571410998012;
        Fri, 18 Oct 2019 08:03:18 -0700 (PDT)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id j7sm2690715lfc.16.2019.10.18.08.03.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Oct 2019 08:03:17 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92.2)
        (envelope-from <johan@kernel.org>)
        id 1iLTmq-0006YT-9P; Fri, 18 Oct 2019 17:03:29 +0200
Date:   Fri, 18 Oct 2019 17:03:28 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>,
        syzbot+6fe95b826644f7f12b0b@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/2] USB: ldusb: fix read info leaks
Message-ID: <20191018150328.GC24768@localhost>
References: <20191018141750.23756-1-johan@kernel.org>
 <20191018141750.23756-2-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191018141750.23756-2-johan@kernel.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 18, 2019 at 04:17:49PM +0200, Johan Hovold wrote:
> Fix broken read implementation, which could be used to trigger slab info
> leaks.
> 
> The driver failed to check if the custom ring buffer was still empty
> when waking up after having waited for more data. This would happen on
> every interrupt-in completion, even if no data had been added to the
> ring buffer (e.g. on disconnect events).
> 
> Due to missing sanity checks and uninitialised (kmalloced) ring-buffer
> entries, this meant that huge slab info leaks could easily be triggered.
> 
> Note that the empty-buffer check after wakeup is enough to fix the info
> leak on disconnect, but let's clear the buffer on allocation and add a
> sanity check to read() to prevent further leaks.
> 
> Fixes: 2824bd250f0b ("[PATCH] USB: add ldusb driver")
> Cc: stable <stable@vger.kernel.org>     # 2.6.13
> Reported-by: syzbot+6fe95b826644f7f12b0b@syzkaller.appspotmail.com
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
>  drivers/usb/misc/ldusb.c | 18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/usb/misc/ldusb.c b/drivers/usb/misc/ldusb.c
> index 147c90c2a4e5..94780e14e95d 100644
> --- a/drivers/usb/misc/ldusb.c
> +++ b/drivers/usb/misc/ldusb.c
> @@ -464,7 +464,7 @@ static ssize_t ld_usb_read(struct file *file, char __user *buffer, size_t count,
>  
>  	/* wait for data */
>  	spin_lock_irq(&dev->rbsl);
> -	if (dev->ring_head == dev->ring_tail) {
> +	while (dev->ring_head == dev->ring_tail) {
>  		dev->interrupt_in_done = 0;
>  		spin_unlock_irq(&dev->rbsl);
>  		if (file->f_flags & O_NONBLOCK) {
> @@ -474,12 +474,17 @@ static ssize_t ld_usb_read(struct file *file, char __user *buffer, size_t count,
>  		retval = wait_event_interruptible(dev->read_wait, dev->interrupt_in_done);
>  		if (retval < 0)
>  			goto unlock_exit;
> -	} else {
> -		spin_unlock_irq(&dev->rbsl);
> +
> +		spin_lock_irq(&dev->rbsl);
>  	}
> +	spin_unlock_irq(&dev->rbsl);
>  
>  	/* actual_buffer contains actual_length + interrupt_in_buffer */
>  	actual_buffer = (size_t *)(dev->ring_buffer + dev->ring_tail * (sizeof(size_t)+dev->interrupt_in_endpoint_size));
> +	if (*actual_buffer > sizeof(size_t) + dev->interrupt_in_endpoint_size) {

Bah, this should have been just

	if (*actual_buffer > dev->interrupt_in_endpoint_size)

will send a v2.
	
> +		retval = -EIO;
> +		goto unlock_exit;
> +	}
>  	bytes_to_read = min(count, *actual_buffer);
>  	if (bytes_to_read < *actual_buffer)
>  		dev_warn(&dev->intf->dev, "Read buffer overflow, %zd bytes dropped\n",

Johan
