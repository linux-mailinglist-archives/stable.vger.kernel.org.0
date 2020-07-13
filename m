Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F17AB21D392
	for <lists+stable@lfdr.de>; Mon, 13 Jul 2020 12:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729460AbgGMKJD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jul 2020 06:09:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:41586 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726523AbgGMKJC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Jul 2020 06:09:02 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 327C0B138;
        Mon, 13 Jul 2020 10:09:03 +0000 (UTC)
Message-ID: <1594634939.2541.3.camel@suse.de>
Subject: Re: [PATCH] cdc-acm: acm_init: Set initial BAUD to B0
From:   Oliver Neukum <oneukum@suse.de>
To:     Joakim Tjernlund <joakim.tjernlund@infinera.com>,
        "linux-usb @ vger . kernel . org" <linux-usb@vger.kernel.org>
Cc:     stable@vger.kernel.org
Date:   Mon, 13 Jul 2020 12:08:59 +0200
In-Reply-To: <20200710093518.22272-1-joakim.tjernlund@infinera.com>
References: <20200710093518.22272-1-joakim.tjernlund@infinera.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am Freitag, den 10.07.2020, 11:35 +0200 schrieb Joakim Tjernlund:
> 


Hi,

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


No,

you cannot do that. This means that probe() is now live.
Probe() in turn does this:

        tty_dev = tty_port_register_device(&acm->port, acm_tty_driver, minor,
                        &control_interface->dev);
        if (IS_ERR(tty_dev)) {
                rv = PTR_ERR(tty_dev);
                goto alloc_fail6;
        }


That is just not a good idea when the tty is not already registered.
You are opening up a race.

	Regards
		Oliver

