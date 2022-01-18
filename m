Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2F2492BA3
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 17:54:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346450AbiARQxt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 11:53:49 -0500
Received: from bmailout1.hostsharing.net ([83.223.95.100]:57419 "EHLO
        bmailout1.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346718AbiARQxs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 11:53:48 -0500
X-Greylist: delayed 594 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Jan 2022 11:53:47 EST
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout1.hostsharing.net (Postfix) with ESMTPS id C2CCB300097BA;
        Tue, 18 Jan 2022 17:43:51 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id B4A3819385; Tue, 18 Jan 2022 17:43:51 +0100 (CET)
Date:   Tue, 18 Jan 2022 17:43:51 +0100
From:   Lukas Wunner <lukas@wunner.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux@armlinux.org.uk, jirislaby@kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.4 27/29] serial: pl010: Drop CR register reset
 on set_termios
Message-ID: <20220118164351.GA25478@wunner.de>
References: <20220118030822.1955469-1-sashal@kernel.org>
 <20220118030822.1955469-27-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220118030822.1955469-27-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 17, 2022 at 10:08:20PM -0500, Sasha Levin wrote:
> From: Lukas Wunner <lukas@wunner.de>
> 
> [ Upstream commit 08a0c6dff91c965e39905cf200d22db989203ccb ]
> 
> pl010_set_termios() briefly resets the CR register to zero.
> 
> Where does this register write come from?
> 
> The PL010 driver's IRQ handler ambauart_int() originally modified the CR
> register without holding the port spinlock.  ambauart_set_termios() also
> modified that register.  To prevent concurrent read-modify-writes by the
> IRQ handler and to prevent transmission while changing baudrate,
> ambauart_set_termios() had to disable interrupts.  That is achieved by
> writing zero to the CR register.
> 
> However in 2004 the PL010 driver was amended to acquire the port
> spinlock in the IRQ handler, obviating the need to disable interrupts in
> ->set_termios():
> https://git.kernel.org/history/history/c/157c0342e591
> 
> That rendered the CR register write obsolete.  Drop it.

I'd recommend against backporting this particular patch for pl010
as it's merely a cleanup that eases future work on the driver,
but doesn't actually fix anything.

You've also auto-selected a patch for the pl011 driver with the
same subject.  That other patch *does* actually fix an rs485
Transmit Enable glitch, so backporting it makes sense.

Thanks,

Lukas

> Cc: Russell King <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Lukas Wunner <lukas@wunner.de>
> Link: https://lore.kernel.org/r/fcaff16e5b1abb4cc3da5a2879ac13f278b99ed0.1641128728.git.lukas@wunner.de
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/tty/serial/amba-pl010.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/tty/serial/amba-pl010.c b/drivers/tty/serial/amba-pl010.c
> index 5d41d5b92619a..7f4ba92739663 100644
> --- a/drivers/tty/serial/amba-pl010.c
> +++ b/drivers/tty/serial/amba-pl010.c
> @@ -465,14 +465,11 @@ pl010_set_termios(struct uart_port *port, struct ktermios *termios,
>  	if ((termios->c_cflag & CREAD) == 0)
>  		uap->port.ignore_status_mask |= UART_DUMMY_RSR_RX;
>  
> -	/* first, disable everything */
>  	old_cr = readb(uap->port.membase + UART010_CR) & ~UART010_CR_MSIE;
>  
>  	if (UART_ENABLE_MS(port, termios->c_cflag))
>  		old_cr |= UART010_CR_MSIE;
>  
> -	writel(0, uap->port.membase + UART010_CR);
> -
>  	/* Set baud rate */
>  	quot -= 1;
>  	writel((quot & 0xf00) >> 8, uap->port.membase + UART010_LCRM);
> -- 
> 2.34.1
