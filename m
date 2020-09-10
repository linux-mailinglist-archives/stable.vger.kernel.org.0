Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A302A263ED4
	for <lists+stable@lfdr.de>; Thu, 10 Sep 2020 09:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726746AbgIJHfl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Sep 2020 03:35:41 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:33216 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729135AbgIJHff (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Sep 2020 03:35:35 -0400
Received: by mail-lf1-f67.google.com with SMTP id x77so3053527lfa.0;
        Thu, 10 Sep 2020 00:35:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fshanOoZEbXfh2wzkzEbd7aeXs9RjWFS3jNx1xf0WE4=;
        b=RqTDOp4XG5wM03koJZFVVKn+WvFeYg5N0/Ss0VXAH3zJYHwcPIaoMaBVy8sbZhawqu
         HL712snAUnx7gZaTFtHmQmUN2gEhy0YPgE/NG8A+V4W704N/WXl/dYq/K05Xz5vciyTy
         L4JO3yLPRwLreIDiYdV80NUV8MEUIXoUNY7nH5cEM39taM/vLOq6d/DrRzRYhDXYtP0Q
         itI7YB7Q/b8w6ETGnTxMFSSTadtZ2THtUcmEm0P4dv4/a/UC7X0Pwf1V8YG8sLCIikoQ
         ztNwFkXdLSoM1Iv+YgDA/xGpPOO1uAZf/Tao/DZCLVVYg8uIYrONBCbClmLiUWnSEfix
         LiLQ==
X-Gm-Message-State: AOAM531F/UsqqcXrn74sXWM+oAxikRNdUHtJaQZDNUk0+ZDeLQaNe03P
        Oit9J0ejiOqbCHCZCp8XCUg=
X-Google-Smtp-Source: ABdhPJy8m6LygSl7HMxtzakpu88W+WmiS92wExIdiFB7dR3zHltDxVhPBhP4S8n5sk57q1OAjc7E7g==
X-Received: by 2002:a19:d95:: with SMTP id 143mr3361008lfn.4.1599723332027;
        Thu, 10 Sep 2020 00:35:32 -0700 (PDT)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id v14sm1140974lfe.79.2020.09.10.00.35.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 00:35:31 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1kGH79-0005dT-10; Thu, 10 Sep 2020 09:35:27 +0200
Date:   Thu, 10 Sep 2020 09:35:27 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH 2/2] serial: core: fix console port-lock regression
Message-ID: <20200910073527.GC24441@localhost>
References: <20200909143101.15389-1-johan@kernel.org>
 <20200909143101.15389-3-johan@kernel.org>
 <20200909154815.GD1891694@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200909154815.GD1891694@smile.fi.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 09, 2020 at 06:48:15PM +0300, Andy Shevchenko wrote:
> On Wed, Sep 09, 2020 at 04:31:01PM +0200, Johan Hovold wrote:
> > Fix the port-lock initialisation regression introduced by commit
> > a3cb39d258ef ("serial: core: Allow detach and attach serial device for
> > console") by making sure that the lock is again initialised during
> > console setup.
> > 
> > The console may be registered before the serial controller has been
> > probed in which case the port lock needs to be initialised during
> > console setup by a call to uart_set_options(). The console-detach
> > changes introduced a regression in several drivers by effectively
> > removing that initialisation by not initialising the lock when the port
> > is used as a console (which is always the case during console setup).
> > 
> > Add back the early lock initialisation and instead use a new
> > console-reinit flag to handle the case where a console is being
> > re-attached through sysfs.
> > 
> > The question whether the console-detach interface should have been added
> > in the first place is left for another discussion.
> 
> It was discussed in [1]. TL;DR: OMAP would like to keep runtime PM available
> for UART while at the same time we disable it for kernel consoles in
> bedb404e91bb.
> 
> [1]: https://lists.openwall.net/linux-kernel/2018/09/29/65

Yeah, I remember that. My fear is just that the new interface opens up a
can of worms as it removes the earlier assumption that the console would
essentially never be deregistered without really fixing all those
drivers, and core functions, written under that assumption. Just to
mention a few issues; we have drivers enabling clocks and other
resources during console setup which can now be done repeatedly, and
several drivers whose setup callbacks are marked __init and will oops
the minute you reattach the console. And what about power management
which was the reason for wanting this on OMAP in the first place; tty
core never calls shutdown() for a console port, not even when it's been
detached using the new interface.

I know, the console setup is all a mess, but this still seems a little
rushed to me. I'm even inclined to suggest a revert until the above and
similar issues have been addressed properly rather keeping a known buggy
interface.

> > Note that the console-enabled check in uart_set_options() is not
> > redundant because of kgdboc, which can end up reinitialising an already
> > enabled console (see commit 42b6a1baa3ec ("serial_core: Don't
> > re-initialize a previously initialized spinlock.")).
> 
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Thank you!
> 
> One question below, though.
> 
> > Fixes: a3cb39d258ef ("serial: core: Allow detach and attach serial device for console")
> > Cc: stable <stable@vger.kernel.org>     # 5.7
> > Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > Signed-off-by: Johan Hovold <johan@kernel.org>
> > ---
> >  drivers/tty/serial/serial_core.c | 32 +++++++++++++++-----------------
> >  include/linux/serial_core.h      |  1 +
> >  2 files changed, 16 insertions(+), 17 deletions(-)
> > 
> > diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
> > index 53b79e1fcbc8..124524ecfe26 100644
> > --- a/drivers/tty/serial/serial_core.c
> > +++ b/drivers/tty/serial/serial_core.c
> > @@ -1916,24 +1916,12 @@ static inline bool uart_console_enabled(struct uart_port *port)
> >  	return uart_console(port) && (port->cons->flags & CON_ENABLED);
> >  }
> >  
> > -static void __uart_port_spin_lock_init(struct uart_port *port)
> > +static void uart_port_spin_lock_init(struct uart_port *port)
> >  {
> >  	spin_lock_init(&port->lock);
> >  	lockdep_set_class(&port->lock, &port_lock_key);
> >  }
> >  
> > -/*
> > - * Ensure that the serial console lock is initialised early.
> > - * If this port is a console, then the spinlock is already initialised.
> > - */
> > -static inline void uart_port_spin_lock_init(struct uart_port *port)
> > -{
> 
> > -	if (uart_console(port))
> 
> I'm wondering if we may revert this line to be uart_console_enabled() and use a
> helper below twice.

I didn't do that on purpose as the rationale for why the
uart_console_enabled() check is there is different in the two paths so
merging the two comments, and moving it away from the call sites, wasn't
really a good idea to begin with.

> > -		return;
> > -
> > -	__uart_port_spin_lock_init(port);
> > -}
> > -
> >  #if defined(CONFIG_SERIAL_CORE_CONSOLE) || defined(CONFIG_CONSOLE_POLL)
> >  /**
> >   *	uart_console_write - write a console message to a serial port
> > @@ -2086,7 +2074,15 @@ uart_set_options(struct uart_port *port, struct console *co,
> >  	struct ktermios termios;
> >  	static struct ktermios dummy;
> >  
> > -	uart_port_spin_lock_init(port);
> > +	/*
> > +	 * Ensure that the serial-console lock is initialised early.
> > +	 *
> > +	 * Note that the console-enabled check is needed because of kgdboc,
> > +	 * which can end up calling uart_set_options() for an already enabled
> > +	 * console via tty_find_polling_driver() and uart_poll_init().
> > +	 */
> > +	if (!uart_console_enabled(port) && !port->console_reinit)
> > +		uart_port_spin_lock_init(port);
> >  
> >  	memset(&termios, 0, sizeof(struct ktermios));
> >  
> > @@ -2794,10 +2790,12 @@ static ssize_t console_store(struct device *dev,
> >  		if (oldconsole && !newconsole) {
> >  			ret = unregister_console(uport->cons);
> >  		} else if (!oldconsole && newconsole) {
> > -			if (uart_console(uport))
> > +			if (uart_console(uport)) {
> > +				uport->console_reinit = 1;
> >  				register_console(uport->cons);
> > -			else
> > +			} else {
> >  				ret = -ENOENT;
> > +			}
> >  		}
> >  	} else {
> >  		ret = -ENXIO;
> > @@ -2898,7 +2896,7 @@ int uart_add_one_port(struct uart_driver *drv, struct uart_port *uport)
> >  	 * initialised.
> >  	 */
> >  	if (!uart_console_enabled(uport))
> > -		__uart_port_spin_lock_init(uport);
> > +		uart_port_spin_lock_init(uport);
> >  
> >  	if (uport->cons && uport->dev)
> >  		of_console_check(uport->dev->of_node, uport->cons->name, uport->line);
> > diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
> > index 01fc4d9c9c54..8a99279a579b 100644
> > --- a/include/linux/serial_core.h
> > +++ b/include/linux/serial_core.h
> > @@ -248,6 +248,7 @@ struct uart_port {
> >  
> >  	unsigned char		hub6;			/* this should be in the 8250 driver */
> >  	unsigned char		suspended;
> > +	unsigned char		console_reinit;
> >  	const char		*name;			/* port name */
> >  	struct attribute_group	*attr_group;		/* port specific attributes */
> >  	const struct attribute_group **tty_groups;	/* all attributes (serial core use only) */
> > -- 
> > 2.26.2

Johan
