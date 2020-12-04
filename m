Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 092712CECB9
	for <lists+stable@lfdr.de>; Fri,  4 Dec 2020 12:07:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727518AbgLDLGs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Dec 2020 06:06:48 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:39530 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726999AbgLDLGs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Dec 2020 06:06:48 -0500
Received: by mail-lj1-f194.google.com with SMTP id o24so6138090ljj.6;
        Fri, 04 Dec 2020 03:06:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PTgn8cGmjx6KO+ClxPA7F//3s9QN/o87+O7mKbif/hE=;
        b=bXRDHmiusUjmj2GYCr8VKd6z2IKXhaEwtLeHf+x7JpN+IONztVMTRry2j5s4mbI1Cn
         7KPI7GaM/AJGzzRe/y2PRLx5CqR7+8aQWM71zXzDsnyjgCFeyJcMfguOiIZ5X28LCW4Z
         h+6f/fWWc6/rYAA8WDhE3VzodicWl4sb9pH656+tPF+VazLjMnkuScFhDQiX2okMmYyF
         hu7lHxv7nR7Nx0OG4M+akY8g2OzD1U61gpSr1n7ed0s97gMYNFSez88SJLmT44YpRlLs
         i4O7YF4iCiQmYBtIE9/qDNV/p7Z/Y8zYgr00Tf6VlAlNqmZb1PoycU9RQ+yO5KIVWFh9
         H2DQ==
X-Gm-Message-State: AOAM531RHVkDgebj339ZT09km+lNd6JqmMq3NECRnXRdCEzPaMUx1fDT
        /7/t1eUtkSyXx5nze+r885z5X4cGbaKjsQ==
X-Google-Smtp-Source: ABdhPJzkDZIa9NHDh0PaimLY9LZb3jr3gqzGj3lStPMm8fWQGhU+V9h5q9xuW2cGy6yrKtQAgRfhTQ==
X-Received: by 2002:a2e:2416:: with SMTP id k22mr3188160ljk.201.1607079966137;
        Fri, 04 Dec 2020 03:06:06 -0800 (PST)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id t6sm1544388lfc.231.2020.12.04.03.06.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Dec 2020 03:06:05 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1kl8v8-00056c-Ma; Fri, 04 Dec 2020 12:06:39 +0100
Date:   Fri, 4 Dec 2020 12:06:38 +0100
From:   Johan Hovold <johan@kernel.org>
To:     linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Himadri Pandya <himadrispandya@gmail.com>,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] USB: serial: kl5kusb105: fix memleak on open
Message-ID: <X8oYPir8HfGEoTzB@localhost>
References: <20201204085519.20230-1-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201204085519.20230-1-johan@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 04, 2020 at 09:55:19AM +0100, Johan Hovold wrote:
> Fix memory leak of control-message transfer buffer on successful open().
> 
> Fixes: 6774d5f53271 ("USB: serial: kl5kusb105: fix open error path")
> Cc: stable@vger.kernel.org
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
> 
> While reviewing Himadri's control-message series I noticed we have a
> related bug in klsi_105_open() that needs fixing.
> 
> 
>  drivers/usb/serial/kl5kusb105.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/usb/serial/kl5kusb105.c b/drivers/usb/serial/kl5kusb105.c
> index 5ee48b0650c4..5f6b82ebccc5 100644
> --- a/drivers/usb/serial/kl5kusb105.c
> +++ b/drivers/usb/serial/kl5kusb105.c
> @@ -276,12 +276,12 @@ static int  klsi_105_open(struct tty_struct *tty, struct usb_serial_port *port)
>  	priv->cfg.unknown2 = cfg->unknown2;
>  	spin_unlock_irqrestore(&priv->lock, flags);
>  
> +	kfree(cfg);
> +
>  	/* READ_ON and urb submission */
>  	rc = usb_serial_generic_open(tty, port);
> -	if (rc) {
> -		retval = rc;
> -		goto err_free_cfg;
> -	}
> +	if (rc)
> +		return rc;
>  
>  	rc = usb_control_msg(port->serial->dev,
>  			     usb_sndctrlpipe(port->serial->dev, 0),
> @@ -324,8 +324,6 @@ static int  klsi_105_open(struct tty_struct *tty, struct usb_serial_port *port)
>  			     KLSI_TIMEOUT);
>  err_generic_close:
>  	usb_serial_generic_close(port);
> -err_free_cfg:
> -	kfree(cfg);
>  
>  	return retval;
>  }

I've applied this one now so that I can include it in my pull-request
for -rc7.

Greg, just let me know if you think I should hold this one off for 5.11
instead.

Johan
