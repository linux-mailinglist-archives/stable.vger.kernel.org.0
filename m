Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C9FA42EF8E
	for <lists+stable@lfdr.de>; Fri, 15 Oct 2021 13:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238448AbhJOLZr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Oct 2021 07:25:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:9586 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230169AbhJOLZq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Oct 2021 07:25:46 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10137"; a="215060069"
X-IronPort-AV: E=Sophos;i="5.85,375,1624345200"; 
   d="scan'208";a="215060069"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2021 04:23:39 -0700
X-IronPort-AV: E=Sophos;i="5.85,375,1624345200"; 
   d="scan'208";a="481663753"
Received: from smile.fi.intel.com (HELO smile) ([10.237.72.159])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2021 04:23:37 -0700
Received: from andy by smile with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1mbO7H-000Pr5-23;
        Fri, 15 Oct 2021 17:23:23 +0300
Date:   Fri, 15 Oct 2021 17:23:23 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Johan Hovold <johan@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/3] serial: 8250: fix racy uartclk update
Message-ID: <YWmO2+FNShY03fzo@smile.fi.intel.com>
References: <20211015111422.1027-1-johan@kernel.org>
 <20211015111422.1027-2-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211015111422.1027-2-johan@kernel.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 15, 2021 at 01:14:20PM +0200, Johan Hovold wrote:
> Commit 868f3ee6e452 ("serial: 8250: Add 8250 port clock update method")
> added a hack to support SoCs where the UART reference clock can
> change behind the back of the driver but failed to add the proper
> locking.
> 
> First, make sure to take a reference to the tty struct to avoid
> dereferencing a NULL pointer if the clock change races with a hangup.
> 
> Second, the termios semaphore must be held during the update to prevent
> a racing termios change.

Nice catch!
Thanks, Johan, for fixing this!
Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

> Fixes: 868f3ee6e452 ("serial: 8250: Add 8250 port clock update method")
> Fixes: c8dff3aa8241 ("serial: 8250: Skip uninitialized TTY port baud rate update")
> Cc: stable@vger.kernel.org      # 5.9
> Cc: Serge Semin <Sergey.Semin@baikalelectronics.ru>
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
>  drivers/tty/serial/8250/8250_port.c | 21 +++++++++++++++++----
>  1 file changed, 17 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
> index 66374704747e..e4dd82fd7c2a 100644
> --- a/drivers/tty/serial/8250/8250_port.c
> +++ b/drivers/tty/serial/8250/8250_port.c
> @@ -2696,21 +2696,32 @@ static unsigned int serial8250_get_baud_rate(struct uart_port *port,
>  void serial8250_update_uartclk(struct uart_port *port, unsigned int uartclk)
>  {
>  	struct uart_8250_port *up = up_to_u8250p(port);
> +	struct tty_port *tport = &port->state->port;
>  	unsigned int baud, quot, frac = 0;
>  	struct ktermios *termios;
> +	struct tty_struct *tty;
>  	unsigned long flags;
>  
> -	mutex_lock(&port->state->port.mutex);
> +	tty = tty_port_tty_get(tport);
> +	if (!tty) {
> +		mutex_lock(&tport->mutex);
> +		port->uartclk = uartclk;
> +		mutex_unlock(&tport->mutex);
> +		return;
> +	}
> +
> +	down_write(&tty->termios_rwsem);
> +	mutex_lock(&tport->mutex);
>  
>  	if (port->uartclk == uartclk)
>  		goto out_lock;
>  
>  	port->uartclk = uartclk;
>  
> -	if (!tty_port_initialized(&port->state->port))
> +	if (!tty_port_initialized(tport))
>  		goto out_lock;
>  
> -	termios = &port->state->port.tty->termios;
> +	termios = &tty->termios;
>  
>  	baud = serial8250_get_baud_rate(port, termios, NULL);
>  	quot = serial8250_get_divisor(port, baud, &frac);
> @@ -2727,7 +2738,9 @@ void serial8250_update_uartclk(struct uart_port *port, unsigned int uartclk)
>  	serial8250_rpm_put(up);
>  
>  out_lock:
> -	mutex_unlock(&port->state->port.mutex);
> +	mutex_unlock(&tport->mutex);
> +	up_write(&tty->termios_rwsem);
> +	tty_kref_put(tty);
>  }
>  EXPORT_SYMBOL_GPL(serial8250_update_uartclk);
>  
> -- 
> 2.32.0
> 

-- 
With Best Regards,
Andy Shevchenko


