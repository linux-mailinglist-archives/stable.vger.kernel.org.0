Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9750421B339
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 12:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbgGJKe7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 06:34:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:43554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726644AbgGJKez (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Jul 2020 06:34:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B41020748;
        Fri, 10 Jul 2020 10:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594377294;
        bh=uoo/kYGcEqSkFRDsbv9PdFntw+TKsZrIM8N9EZNzZ8M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FiUGy2uOanw/cRdJyiV6JrwDDXtZswDrk1UHsHFgfIiREPh08iemLtL9t93YsEAZ7
         2YZY4eUDT5xev5nAvY6Lu9Nmn4PAxkCiJ4wIvSZyJrZKUh2N6qrVMaEXyCfc3iwSJD
         j2wTJ4n5ZpoqnQD+Ysc0zk3yP9gjfWlcrMPUfLzE=
Date:   Fri, 10 Jul 2020 12:34:59 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Joakim Tjernlund <joakim.tjernlund@infinera.com>
Cc:     "linux-usb @ vger . kernel . org" <linux-usb@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] cdc-acm: acm_init: Set initial BAUD to B0
Message-ID: <20200710103459.GA1203263@kroah.com>
References: <20200710093518.22272-1-joakim.tjernlund@infinera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200710093518.22272-1-joakim.tjernlund@infinera.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 10, 2020 at 11:35:18AM +0200, Joakim Tjernlund wrote:
> BO will disable USB input until the device opens. This will
> avoid garbage chars waiting flood the TTY. This mimics a real UART
> device better.
> For initial termios to reach USB core, USB driver has to be
> registered before TTY driver.

You are doing two different things here, please break this up into 2
patches, with good documentation for both of them.

And any reason you didn't send this to the people listed in
scripts/get_maintainers.pl when run on this patch?

> 
> Signed-off-by: Joakim Tjernlund <joakim.tjernlund@infinera.com>
> Cc: stable@vger.kernel.org
> ---
> 
>  I hope this change makes sense to you, if so I belive
>  ttyUSB could do the same.
> 
>  drivers/usb/class/cdc-acm.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
> index 751f00285ee6..5680f71200e5 100644
> --- a/drivers/usb/class/cdc-acm.c
> +++ b/drivers/usb/class/cdc-acm.c
> @@ -1999,19 +1999,19 @@ static int __init acm_init(void)
>  	acm_tty_driver->subtype = SERIAL_TYPE_NORMAL,
>  	acm_tty_driver->flags = TTY_DRIVER_REAL_RAW | TTY_DRIVER_DYNAMIC_DEV;
>  	acm_tty_driver->init_termios = tty_std_termios;
> -	acm_tty_driver->init_termios.c_cflag = B9600 | CS8 | CREAD |
> +	acm_tty_driver->init_termios.c_cflag = B0 | CS8 | CREAD |
>  								HUPCL | CLOCAL;

Huh?  Are you sure this works?

>  	tty_set_operations(acm_tty_driver, &acm_ops);
>  
> -	retval = tty_register_driver(acm_tty_driver);
> +	retval = usb_register(&acm_driver);
>  	if (retval) {
>  		put_tty_driver(acm_tty_driver);
>  		return retval;
>  	}
>  
> -	retval = usb_register(&acm_driver);
> +	retval = tty_register_driver(acm_tty_driver);
>  	if (retval) {
> -		tty_unregister_driver(acm_tty_driver);
> +		usb_deregister(&acm_driver);

Why are you switching these around?  I think I know, but you don't
really say...

thanks,

greg k-h
