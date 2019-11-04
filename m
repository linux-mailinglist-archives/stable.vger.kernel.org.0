Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1061EE09A
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 14:07:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbfKDNHc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 08:07:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:34278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727663AbfKDNHc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 08:07:32 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 986C221D7F;
        Mon,  4 Nov 2019 13:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572872850;
        bh=FfELiOoQvfUbIWMhJoD/pEAF8GWVFPBUowt1XMR0nKU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q2jg7uvzRWkHqlyCy2GPut1bfwRpQx2TBwry42+zszcJVIYGKsLZTWpgW10ZMvBAH
         iYHtBsGrhqXONXzeyQXVXCPaj6wnIYvpWH7QZaNFvoRslfNmklEkKarfq0nu8tbCHC
         YTYZBsVU9k8WUwaDuDZzwvJmT3lHOihjoJ8wONw8=
Date:   Mon, 4 Nov 2019 14:07:25 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 4.19] spi: spi-gpio: fix crash when num-chipselects is 0
Message-ID: <20191104130725.GA2128343@kroah.com>
References: <20191104124403.13502-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191104124403.13502-1-dqfext@gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 04, 2019 at 08:44:03PM +0800, DENG Qingfang wrote:
> Commit 249e2632dcd0509b8f8f296f5aabf4d48dfd6da8 upstream.
> 
> If an spi-gpio was specified with num-chipselects = <0> in dts, kernel will crash:
> 
> Unable to handle kernel paging request at virtual address 32697073
> pgd = (ptrval)
> [32697073] *pgd=00000000
> Internal error: Oops: 5 [#1] SMP ARM
> Modules linked in:
> CPU: 2 PID: 1 Comm: swapper/0 Not tainted 4.19.72 #0
> Hardware name: Generic DT based system
> PC is at validate_desc+0x28/0x80
> LR is at gpiod_direction_output+0x14/0x128
> ...
> [<c0544db4>] (validate_desc) from [<c0545228>] (gpiod_direction_output+0x14/0x128)
> [<c0545228>] (gpiod_direction_output) from [<c05fa714>] (spi_gpio_setup+0x58/0x64)
> [<c05fa714>] (spi_gpio_setup) from [<c05f7258>] (spi_setup+0x12c/0x148)
> [<c05f7258>] (spi_setup) from [<c05f7330>] (spi_add_device+0xbc/0x12c)
> [<c05f7330>] (spi_add_device) from [<c05f7f74>] (spi_register_controller+0x838/0x924)
> [<c05f7f74>] (spi_register_controller) from [<c05fa494>] (spi_bitbang_start+0x108/0x120)
> [<c05fa494>] (spi_bitbang_start) from [<c05faa34>] (spi_gpio_probe+0x314/0x338)
> [<c05faa34>] (spi_gpio_probe) from [<c05a844c>] (platform_drv_probe+0x34/0x70)
> 
> The cause is spi_gpio_setup() did not check if the spi-gpio has chipselect pins
> before setting their direction and results in derefing an invalid pointer.
> 
> The bug is spotted in kernel 4.19.72 on OpenWrt, and does not occur in 4.14.
> 
> Fixes: 9b00bc7b901ff ("spi: spi-gpio: Rewrite to use GPIO descriptors")
> 
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> ---
>  drivers/spi/spi-gpio.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/spi/spi-gpio.c b/drivers/spi/spi-gpio.c
> index 77838d8fd..3b7f0d077 100644
> --- a/drivers/spi/spi-gpio.c
> +++ b/drivers/spi/spi-gpio.c
> @@ -242,10 +242,12 @@ static int spi_gpio_setup(struct spi_device *spi)
>  	 * The CS GPIOs have already been
>  	 * initialized from the descriptor lookup.
>  	 */
> -	cs = spi_gpio->cs_gpios[spi->chip_select];
> -	if (!spi->controller_state && cs)
> -		status = gpiod_direction_output(cs,
> -						!(spi->mode & SPI_CS_HIGH));
> +	if (spi_gpio->has_cs) {
> +		cs = spi_gpio->cs_gpios[spi->chip_select];
> +		if (!spi->controller_state && cs)
> +			status = gpiod_direction_output(cs,
> +						  !(spi->mode & SPI_CS_HIGH));
> +	}
>  
>  	if (!status)
>  		status = spi_bitbang_setup(spi);
> -- 
> 2.23.0
> 

This is a very different verison of the commit id that you said this is
from.  Can you please backport the "whole" thing instead?  What is wrong
with taking all of it?

thanks,

greg k-h
