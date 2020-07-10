Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D61E21B2C3
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 11:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728050AbgGJJys (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 05:54:48 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:35014 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728048AbgGJJyq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jul 2020 05:54:46 -0400
Received: by mail-lj1-f193.google.com with SMTP id q4so5776029lji.2;
        Fri, 10 Jul 2020 02:54:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=k3Kcp9tKsZ9UZgz57Z7n/yDq0NW3ryD3wlI7GXv6Mzo=;
        b=I5jv9fUGkBTu6z/c1/LU+ERn56UlL/I9FlKP0eBVtovk+We2Hd39vNGJpqwFA1jBiT
         lbHIzuu0lTSJcVtA/MQuzIlgYkNxZ/GRh2/KsXui7ywldqmqlSyU9DpWQfne1uybJgcb
         0vRH0AhFSUZDBG3dNMzkya/XVaDGXRy/7NDmDJY2LPRfrGmAUMl47GRl2VyKW05E2TUj
         9Vmm0I/RsP8oq21mKQa8+1XyB9wgYaiuPOrFRKYd0qj+5UM/4NPquC5cThMBMmEj8Qkb
         yBZ1c+TcVq2J9sb3y/GadwTi+8kNelralTy4fcsWsseVCeWBzz8jhaIlY83jyHKiKGXN
         TvNQ==
X-Gm-Message-State: AOAM531IGshhekKTufM6WWpEshQbWSDeqNbOo76M8yKmqNHSkE1jAhcP
        QbutJV9Vokb5O8FfdeKgE4+oJgAmnrQ=
X-Google-Smtp-Source: ABdhPJz5Ov+ZuRZJj+Pst2u2eDAHnzjyWj/drC0TWMPgLNLcpiBN0F6yv1PGyGTFEXlWT78meEIQww==
X-Received: by 2002:a2e:9050:: with SMTP id n16mr38348055ljg.376.1594374884286;
        Fri, 10 Jul 2020 02:54:44 -0700 (PDT)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id u5sm2915415lfm.81.2020.07.10.02.54.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2020 02:54:43 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1jtpjx-0005KI-Hg; Fri, 10 Jul 2020 11:54:46 +0200
Date:   Fri, 10 Jul 2020 11:54:45 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Joakim Tjernlund <joakim.tjernlund@infinera.com>
Cc:     "linux-usb @ vger . kernel . org" <linux-usb@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] cdc-acm: acm_init: Set initial BAUD to B0
Message-ID: <20200710095445.GS3453@localhost>
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
> 
> Signed-off-by: Joakim Tjernlund <joakim.tjernlund@infinera.com>
> Cc: stable@vger.kernel.org
> ---
> 
>  I hope this change makes sense to you, if so I belive
>  ttyUSB could do the same.

No, this doesn't make sense. B0 is used to hang up an already open tty.

Furthermore, this change only affects the initial terminal settings and
won't have any effect the next time you open the same port.

Why not fix your firmware so that it doesn't transmit before DTR is
asserted during open()?

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
>  		put_tty_driver(acm_tty_driver);
>  		return retval;
>  	}

Johan
