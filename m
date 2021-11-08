Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC6D447CA5
	for <lists+stable@lfdr.de>; Mon,  8 Nov 2021 10:18:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238318AbhKHJUn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 04:20:43 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:50482 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238319AbhKHJUh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 04:20:37 -0500
Received: from tarshish (unknown [10.0.8.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id 3B9E6440F4F;
        Mon,  8 Nov 2021 11:17:35 +0200 (IST)
Authentication-Results: mx.tkos.co.il; dmarc=fail header.from=tkos.co.il
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tkos.co.il;
        s=default; t=1636363055;
        bh=EdySZS6fF+LC1Glq5J2sGIomHJdBAbbglhDfcVAI94Y=;
        h=References:From:To:Cc:Subject:Date:In-reply-to:From;
        b=KkyeSOVi0f2AoKNA6IKQOibNDlJtKmiy8EzpNL/w+6pOpz0AFm4rTqi/JEHmLPs7j
         JnOAPMXIOmf6zuIK8vSl3dAT5m9i9Wk028IKJdhnUHJQ8cbQLWTNhtIPbpCR3W9VmS
         i/A5yPnWJ57xWK9wSAh70in3prh6OOxcJ1zWDl7fO+CvL2wTdu9xBET7VSbM2cqJyf
         R2+sAICbyXNm46dxpkQ0BPS8dHSH067g1I8jLksXwSLUSvj/iH1HhVyhghpeXUjfhm
         CEkFPd80h80p2f4ckXycCrhYQJZ//1UIcnDr+x0u1rrpgaceIURROOLdVrkskvQO9J
         ZYF/HI+6TWeDg==
References: <20211108085431.12637-1-johan@kernel.org>
User-agent: mu4e 1.6.9; emacs 27.1
From:   Baruch Siach <baruch@tkos.co.il>
To:     Johan Hovold <johan@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Rob Herring <robh@kernel.org>
Subject: Re: [PATCH] serial: core: fix transmit-buffer reset and memleak
Date:   Mon, 08 Nov 2021 11:15:56 +0200
In-reply-to: <20211108085431.12637-1-johan@kernel.org>
Message-ID: <87mtmfuhtx.fsf@tarshish>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Johan,

On Mon, Nov 08 2021, Johan Hovold wrote:
> Commit 761ed4a94582 ("tty: serial_core: convert uart_close to use
> tty_port_close") converted serial core to use tty_port_close() but
> failed to notice that the transmit buffer still needs to be freed on
> final close.
>
> Not freeing the transmit buffer means that the buffer is no longer
> cleared on next open so that any ioctl() waiting for the buffer to drain
> might wait indefinitely (e.g. on termios changes) or that stale data can
> end up being transmitted in case tx is restarted.
>
> Furthermore, the buffer of any port that has been opened would leak on
> driver unbind.
>
> Note that the port lock is held when clearing the buffer pointer due to
> the ldisc race worked around by commit a5ba1d95e46e ("uart: fix race
> between uart_put_char() and uart_shutdown()").
>
> Also note that the tty-port shutdown() callback is not called for
> console ports so it is not strictly necessary to free the buffer page
> after releasing the lock (cf. d72402145ace ("tty/serial: do not free
> trasnmit buffer page under port lock")).
>
> Reported-by: Baruch Siach <baruch@tkos.co.il>
> Link: https://lore.kernel.org/r/319321886d97c456203d5c6a576a5480d07c3478.1635781688.git.baruch@tkos.co.il
> Fixes: 761ed4a94582 ("tty: serial_core: convert uart_close to use tty_port_close")
> Cc: stable@vger.kernel.org      # 4.9
> Cc: Rob Herring <robh@kernel.org>
> Signed-off-by: Johan Hovold <johan@kernel.org>

Thanks for the analysis and root cause fix. This patch also fixes the
issue for me.

Tested-by: Baruch Siach <baruch@tkos.co.il>

baruch

> ---
>  drivers/tty/serial/serial_core.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
> index 0e2e35ab64c7..58834698739c 100644
> --- a/drivers/tty/serial/serial_core.c
> +++ b/drivers/tty/serial/serial_core.c
> @@ -1542,6 +1542,7 @@ static void uart_tty_port_shutdown(struct tty_port *port)
>  {
>  	struct uart_state *state = container_of(port, struct uart_state, port);
>  	struct uart_port *uport = uart_port_check(state);
> +	char *buf;
>  
>  	/*
>  	 * At this point, we stop accepting input.  To do this, we
> @@ -1563,8 +1564,18 @@ static void uart_tty_port_shutdown(struct tty_port *port)
>  	 */
>  	tty_port_set_suspended(port, 0);
>  
> -	uart_change_pm(state, UART_PM_STATE_OFF);
> +	/*
> +	 * Free the transmit buffer.
> +	 */
> +	spin_lock_irq(&uport->lock);
> +	buf = state->xmit.buf;
> +	state->xmit.buf = NULL;
> +	spin_unlock_irq(&uport->lock);
>  
> +	if (buf)
> +		free_page((unsigned long)buf);
> +
> +	uart_change_pm(state, UART_PM_STATE_OFF);
>  }
>  
>  static void uart_wait_until_sent(struct tty_struct *tty, int timeout)


-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.52.368.4656, http://www.tkos.co.il -
