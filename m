Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0010D28AF21
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 09:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727380AbgJLHjC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 12 Oct 2020 03:39:02 -0400
Received: from mailout10.rmx.de ([94.199.88.75]:38395 "EHLO mailout10.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727360AbgJLHjC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 03:39:02 -0400
Received: from kdin02.retarus.com (kdin02.dmz1.retloc [172.19.17.49])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout10.rmx.de (Postfix) with ESMTPS id 4C8rCP4PKSz2yW7;
        Mon, 12 Oct 2020 09:38:57 +0200 (CEST)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin02.retarus.com (Postfix) with ESMTPS id 4C8rC26hgGz2TTMN;
        Mon, 12 Oct 2020 09:38:38 +0200 (CEST)
Received: from n95hx1g2.localnet (192.168.54.137) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.408.0; Mon, 12 Oct
 2020 09:38:31 +0200
From:   Christian Eggers <ceggers@arri.de>
To:     <gregkh@linuxfoundation.org>
CC:     <u.kleine-koenig@pengutronix.de>, <wsa@kernel.org>,
        <stable-commits@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: Patch "i2c: imx: Fix reset of I2SR_IAL flag" has been added to the 5.8-stable tree
Date:   Mon, 12 Oct 2020 09:38:30 +0200
Message-ID: <6827529.2cDsNes8Pd@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <1602406113214120@kroah.com>
References: <1602406113214120@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Originating-IP: [192.168.54.137]
X-RMX-ID: 20201012-093842-4C8rC26hgGz2TTMN-0@kdin02
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

the patch below has meanwhile been reverted by Wolfram Sang [1], because it has
been superseded. Although the patch itself is not wrong, you also may want to
revert it in order to avoid conflicts with the next version.

Best regards
Christian

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=5a02e7c429cb5e082e5d7be6e5b768828014ba70

On Sunday, 11 October 2020, 10:48:33 CEST, gregkh@linuxfoundation.org wrote:
> This is a note to let you know that I've just added the patch titled
> 
>     i2c: imx: Fix reset of I2SR_IAL flag
> 
> to the 5.8-stable tree which can be found at:
>    
> http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=sum
> mary
> 
> The filename of the patch is:
>      i2c-imx-fix-reset-of-i2sr_ial-flag.patch
> and it can be found in the queue-5.8 subdirectory.
> 
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.
> 
> 
> From fa4d30556883f2eaab425b88ba9904865a4d00f3 Mon Sep 17 00:00:00 2001
> From: Christian Eggers <ceggers@arri.de>
> Date: Wed, 7 Oct 2020 10:45:22 +0200
> Subject: i2c: imx: Fix reset of I2SR_IAL flag
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
> From: Christian Eggers <ceggers@arri.de>
> 
> commit fa4d30556883f2eaab425b88ba9904865a4d00f3 upstream.
> 
> According to the "VFxxx Controller Reference Manual" (and the comment
> block starting at line 97), Vybrid requires writing a one for clearing
> an interrupt flag. Syncing the method for clearing I2SR_IIF in
> i2c_imx_isr().
> 
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> Fixes: 4b775022f6fd ("i2c: imx: add struct to hold more configurable
> quirks") Reviewed-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Cc: stable@vger.kernel.org
> Signed-off-by: Wolfram Sang <wsa@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>  drivers/i2c/busses/i2c-imx.c |   20 +++++++++++++++-----
>  1 file changed, 15 insertions(+), 5 deletions(-)
> 
> --- a/drivers/i2c/busses/i2c-imx.c
> +++ b/drivers/i2c/busses/i2c-imx.c
> @@ -412,6 +412,19 @@ static void i2c_imx_dma_free(struct imx_
>  	dma->chan_using = NULL;
>  }
> 
> +static void i2c_imx_clear_irq(struct imx_i2c_struct *i2c_imx, unsigned int
> bits) +{
> +	unsigned int temp;
> +
> +	/*
> +	 * i2sr_clr_opcode is the value to clear all interrupts. Here we want to
> +	 * clear only <bits>, so we write ~i2sr_clr_opcode with just <bits>
> +	 * toggled. This is required because i.MX needs W1C and Vybrid uses W0C.
> +	 */
> +	temp = ~i2c_imx->hwdata->i2sr_clr_opcode ^ bits;
> +	imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2SR);
> +}
> +
>  static int i2c_imx_bus_busy(struct imx_i2c_struct *i2c_imx, int for_busy,
> bool atomic) {
>  	unsigned long orig_jiffies = jiffies;
> @@ -424,8 +437,7 @@ static int i2c_imx_bus_busy(struct imx_i
> 
>  		/* check for arbitration lost */
>  		if (temp & I2SR_IAL) {
> -			temp &= ~I2SR_IAL;
> -			imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2SR);
> +			i2c_imx_clear_irq(i2c_imx, I2SR_IAL);
>  			return -EAGAIN;
>  		}
> 
> @@ -623,9 +635,7 @@ static irqreturn_t i2c_imx_isr(int irq,
>  	if (temp & I2SR_IIF) {
>  		/* save status register */
>  		i2c_imx->i2csr = temp;
> -		temp &= ~I2SR_IIF;
> -		temp |= (i2c_imx->hwdata->i2sr_clr_opcode & I2SR_IIF);
> -		imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2SR);
> +		i2c_imx_clear_irq(i2c_imx, I2SR_IIF);
>  		wake_up(&i2c_imx->queue);
>  		return IRQ_HANDLED;
>  	}
> 
> 
> Patches currently in stable-queue which might be from ceggers@arri.de are
> 
> queue-5.8/i2c-imx-fix-reset-of-i2sr_ial-flag.patch




