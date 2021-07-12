Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 071133C5908
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 13:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356123AbhGLIzm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:55:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:36184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1379685AbhGLIux (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:50:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF8D66101D;
        Mon, 12 Jul 2021 08:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626079685;
        bh=Gep8n4gDRouIseZEw8skFrrXdqP5Ql3CwPXbwW7pO7o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EofYjnJDGfNnJ6gpYFP/13naWKLaghUhEwRmu4tpCNDp4T4nYNJ+6o47J0npRiC4K
         8jLwyx9aW02hV15DhjV9osaWg0D9g8qhhd3IMgQWZFRUCoXfxVwKnvLQS1rszPUH8p
         21PYygnwrvgTnO7ZmlueX43YSycQdKoKla1UrZvceBb5xX3vtQfe/zBrw9T0yqsejr
         4U4fbo3MPZ5hTPf6VXKVzRw15zxFm+Gx/DWGWHiB1YO3hl5+3V4CmoqR1c4aeHDNR4
         zb9Lum+6sY0g+2hirL/sGV5Dj0YVEl1SsPwDwciLiUtCrcbi5EcbDPcoknh9zwC3si
         Ovyf05DIcr5RA==
Received: by pali.im (Postfix)
        id 92CDB820; Mon, 12 Jul 2021 10:48:02 +0200 (CEST)
Date:   Mon, 12 Jul 2021 10:48:02 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] serial: mvebu-uart: fix calculation of
 clock divisor" failed to apply to 4.19-stable tree
Message-ID: <20210712084802.xhggfwia3l4vaeel@pali>
References: <16260085611907@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <16260085611907@kroah.com>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sunday 11 July 2021 15:02:41 gregkh@linuxfoundation.org wrote:
> The patch below does not apply to the 4.19-stable tree.

Hello Greg!

I have tested this it and it applies cleanly. I have just called
following commands on top of linux-4.19.y branch without any manual
backporting and there were no issues.

git cherry-pick 0e4cf69ede87
git cherry-pick 9078204ca5c3

Could you look at it, why it is failing for you?

> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From 9078204ca5c33ba20443a8623a41a68a9995a70d Mon Sep 17 00:00:00 2001
> From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
> Date: Fri, 25 Jun 2021 00:49:00 +0200
> Subject: [PATCH] serial: mvebu-uart: fix calculation of clock divisor
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
> The clock divisor should be rounded to the closest value.
> 
> Signed-off-by: Pali Rohár <pali@kernel.org>
> Fixes: 68a0db1d7da2 ("serial: mvebu-uart: add function to change baudrate")
> Cc: stable@vger.kernel.org # 0e4cf69ede87 ("serial: mvebu-uart: clarify the baud rate derivation")
> Link: https://lore.kernel.org/r/20210624224909.6350-2-pali@kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> diff --git a/drivers/tty/serial/mvebu-uart.c b/drivers/tty/serial/mvebu-uart.c
> index 04c41689d81c..f3ecbcf495ee 100644
> --- a/drivers/tty/serial/mvebu-uart.c
> +++ b/drivers/tty/serial/mvebu-uart.c
> @@ -463,7 +463,7 @@ static int mvebu_uart_baud_rate_set(struct uart_port *port, unsigned int baud)
>  	 * makes use of D to configure the desired baudrate.
>  	 */
>  	m_divisor = OSAMP_DEFAULT_DIVISOR;
> -	d_divisor = DIV_ROUND_UP(port->uartclk, baud * m_divisor);
> +	d_divisor = DIV_ROUND_CLOSEST(port->uartclk, baud * m_divisor);
>  
>  	brdv = readl(port->membase + UART_BRDV);
>  	brdv &= ~BRDV_BAUD_MASK;
> 
