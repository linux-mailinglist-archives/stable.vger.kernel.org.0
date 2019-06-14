Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E09B6461AD
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 16:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728074AbfFNOwh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 10:52:37 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:32922 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727560AbfFNOwh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jun 2019 10:52:37 -0400
Received: by mail-lj1-f196.google.com with SMTP id h10so2726532ljg.0;
        Fri, 14 Jun 2019 07:52:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Ox1ytek2Ewr6dIgPAIgjaAwtpKDa4UCju/I1aR8SGC8=;
        b=K4Zl6pB5KcMOkSf0hS+dXlXms6JErmD8lBB5hfdkDwOg8I2EWA3jf5Jx3B3PWUxHw+
         zv1TFZnXydUuiCiExvUVe7kmmKjAi0krzQEdEZY6CvZriVTmmfFCdifcec3S8wEpMKOs
         osofm0NN+Jl9wdIWq/ke8v8/VnqVMQ5+L/8KUWADqvSDZeGtKvI6tyNNvGXAzDS8vGPB
         dXy/YjcKIXWmifdJBcUjU7pBtr/3iNSgG/Fo2a2jgUm3KpSCKeQ0re+gFpdL0MIcosUk
         qWOfOetJayzCJ53+cWMIrgxqnGVwbN4Cq+8P+6aua111b4qb0GXOP7ykUax/zKdgw96K
         V91A==
X-Gm-Message-State: APjAAAX5VQByCvqVYFUKph2Iv5BSLwD8AWApIjap2R7CbBHcgCvLPSMl
        0VFy96e6NVNuJDJ8ALX4P0i6Y5vcGIE=
X-Google-Smtp-Source: APXvYqzi8mp1xBpe/3MMqx4IaSv42a1ZGuCA3mbhUUdKaf/FjOTqtisMwkcFTMpfkcdgsiOVoylYUA==
X-Received: by 2002:a2e:868e:: with SMTP id l14mr10036799lji.16.1560523954447;
        Fri, 14 Jun 2019 07:52:34 -0700 (PDT)
Received: from xi.terra (c-74bee655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.190.116])
        by smtp.gmail.com with ESMTPSA id d16sm521155lfl.26.2019.06.14.07.52.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Jun 2019 07:52:33 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92)
        (envelope-from <johan@kernel.org>)
        id 1hbnZE-0003Ct-UA; Fri, 14 Jun 2019 16:52:36 +0200
Date:   Fri, 14 Jun 2019 16:52:36 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Felipe Balbi <felipe.balbi@linux.intel.com>
Cc:     Mathias Nyman <mathias.nyman@linux.intel.com>,
        linux-usb@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] usb: xhci: dbc: get rid of global pointer
Message-ID: <20190614145236.GB3849@localhost>
References: <20190611172416.12473-1-felipe.balbi@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190611172416.12473-1-felipe.balbi@linux.intel.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 11, 2019 at 08:24:16PM +0300, Felipe Balbi wrote:
> If we happen to have two XHCI controllers with DbC capability, then
> there's no hope this will ever work as the global pointer will be
> overwritten by the controller that probes last.
> 
> Avoid this problem by keeping the tty_driver struct pointer inside
> struct xhci_dbc.

How did you test this patch?

> Fixes: dfba2174dc42 usb: xhci: Add DbC support in xHCI driver
> Cc: <stable@vger.kernel.org> # v4.16+
> Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
> ---
>  drivers/usb/host/xhci-dbgcap.c |  4 +--
>  drivers/usb/host/xhci-dbgcap.h |  3 +-
>  drivers/usb/host/xhci-dbgtty.c | 54 +++++++++++++++++-----------------
>  3 files changed, 31 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/usb/host/xhci-dbgcap.c b/drivers/usb/host/xhci-dbgcap.c
> index 52e32644a4b2..5f56b650c0ea 100644
> --- a/drivers/usb/host/xhci-dbgcap.c
> +++ b/drivers/usb/host/xhci-dbgcap.c
> @@ -948,7 +948,7 @@ int xhci_dbc_init(struct xhci_hcd *xhci)
>  	return 0;
>  
>  init_err1:
> -	xhci_dbc_tty_unregister_driver();
> +	xhci_dbc_tty_unregister_driver(xhci);
>  init_err2:
>  	xhci_do_dbc_exit(xhci);
>  init_err3:
> @@ -963,7 +963,7 @@ void xhci_dbc_exit(struct xhci_hcd *xhci)
>  		return;
>  
>  	device_remove_file(dev, &dev_attr_dbc);
> -	xhci_dbc_tty_unregister_driver();
> +	xhci_dbc_tty_unregister_driver(xhci);
>  	xhci_dbc_stop(xhci);
>  	xhci_do_dbc_exit(xhci);
>  }
> diff --git a/drivers/usb/host/xhci-dbgcap.h b/drivers/usb/host/xhci-dbgcap.h
> index ce0c6072bd48..30dedf36c566 100644
> --- a/drivers/usb/host/xhci-dbgcap.h
> +++ b/drivers/usb/host/xhci-dbgcap.h
> @@ -151,6 +151,7 @@ struct xhci_dbc {
>  	struct dbc_ep			eps[2];
>  
>  	struct dbc_port			port;
> +	struct tty_driver		*tty_driver;
>  };
>  
>  #define dbc_bulkout_ctx(d)		\
> @@ -196,7 +197,7 @@ static inline struct dbc_ep *get_out_ep(struct xhci_hcd *xhci)
>  int xhci_dbc_init(struct xhci_hcd *xhci);
>  void xhci_dbc_exit(struct xhci_hcd *xhci);
>  int xhci_dbc_tty_register_driver(struct xhci_hcd *xhci);
> -void xhci_dbc_tty_unregister_driver(void);
> +void xhci_dbc_tty_unregister_driver(struct xhci_hcd *xhci);
>  int xhci_dbc_tty_register_device(struct xhci_hcd *xhci);
>  void xhci_dbc_tty_unregister_device(struct xhci_hcd *xhci);
>  struct dbc_request *dbc_alloc_request(struct dbc_ep *dep, gfp_t gfp_flags);
> diff --git a/drivers/usb/host/xhci-dbgtty.c b/drivers/usb/host/xhci-dbgtty.c
> index aff79ff5aba4..300fc770a0d5 100644
> --- a/drivers/usb/host/xhci-dbgtty.c
> +++ b/drivers/usb/host/xhci-dbgtty.c
> @@ -279,52 +279,52 @@ static const struct tty_operations dbc_tty_ops = {
>  	.unthrottle		= dbc_tty_unthrottle,
>  };
>  
> -static struct tty_driver *dbc_tty_driver;
> -
>  int xhci_dbc_tty_register_driver(struct xhci_hcd *xhci)
>  {
>  	int			status;
>  	struct xhci_dbc		*dbc = xhci->dbc;
>  
> -	dbc_tty_driver = tty_alloc_driver(1, TTY_DRIVER_REAL_RAW |
> +	dbc->tty_driver = tty_alloc_driver(1, TTY_DRIVER_REAL_RAW |
>  					  TTY_DRIVER_DYNAMIC_DEV);
> -	if (IS_ERR(dbc_tty_driver)) {
> -		status = PTR_ERR(dbc_tty_driver);
> -		dbc_tty_driver = NULL;
> +	if (IS_ERR(dbc->tty_driver)) {
> +		status = PTR_ERR(dbc->tty_driver);
> +		dbc->tty_driver = NULL;
>  		return status;
>  	}
>  
> -	dbc_tty_driver->driver_name = "dbc_serial";
> -	dbc_tty_driver->name = "ttyDBC";
> +	dbc->tty_driver->driver_name = "dbc_serial";
> +	dbc->tty_driver->name = "ttyDBC";

You're now registering multiple drivers for the same thing (and wasting
a major number for each) and specifically using the same name, which
should lead to name clashes when registering the second port.

Possibly better than the current situation, but why not fix this
properly instead? Register the driver once, and just pick a new minor
number for each controller.

> -	dbc_tty_driver->type = TTY_DRIVER_TYPE_SERIAL;
> -	dbc_tty_driver->subtype = SERIAL_TYPE_NORMAL;
> -	dbc_tty_driver->init_termios = tty_std_termios;
> -	dbc_tty_driver->init_termios.c_cflag =
> +	dbc->tty_driver->type = TTY_DRIVER_TYPE_SERIAL;
> +	dbc->tty_driver->subtype = SERIAL_TYPE_NORMAL;
> +	dbc->tty_driver->init_termios = tty_std_termios;
> +	dbc->tty_driver->init_termios.c_cflag =
>  			B9600 | CS8 | CREAD | HUPCL | CLOCAL;
> -	dbc_tty_driver->init_termios.c_ispeed = 9600;
> -	dbc_tty_driver->init_termios.c_ospeed = 9600;
> -	dbc_tty_driver->driver_state = &dbc->port;
> +	dbc->tty_driver->init_termios.c_ispeed = 9600;
> +	dbc->tty_driver->init_termios.c_ospeed = 9600;
> +	dbc->tty_driver->driver_state = &dbc->port;
>  
> -	tty_set_operations(dbc_tty_driver, &dbc_tty_ops);
> +	tty_set_operations(dbc->tty_driver, &dbc_tty_ops);
>  
> -	status = tty_register_driver(dbc_tty_driver);
> +	status = tty_register_driver(dbc->tty_driver);
>  	if (status) {
>  		xhci_err(xhci,
>  			 "can't register dbc tty driver, err %d\n", status);
> -		put_tty_driver(dbc_tty_driver);
> -		dbc_tty_driver = NULL;
> +		put_tty_driver(dbc->tty_driver);
> +		dbc->tty_driver = NULL;
>  	}
>  
>  	return status;
>  }

Johan
