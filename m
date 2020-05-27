Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D31271E459B
	for <lists+stable@lfdr.de>; Wed, 27 May 2020 16:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389011AbgE0OSP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 May 2020 10:18:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387800AbgE0OSO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 May 2020 10:18:14 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FC9CC08C5C1;
        Wed, 27 May 2020 07:18:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=nvbgExlKt43awWywUu8qxX20KyHgTMb97ohU1ntCrW4=; b=FYWYOR/forC3Pt1dzyFWcSms+
        TIyPPkkgMclTfDj0A9YdvDlltL6+/khpPqtrzOgjSHgFeWXqy9RD9k9kllAMZvQEcDPMn7fh9iAdY
        b422kb3O521bemo2bgXrMWnRQJWnl4iydLCozN31HskvBrpAahobXyCww7frn8+iYoNBsKBg7nUmK
        FedEZCODmP3RRxHUKtHNFSqGaKbg18sHeJwsSgVlftZ4mlYXq5Ox5OppPdouQHVN0V8B456Vuxkt4
        XXpWxKSxzpi+KxcnKKSowY/STUX7TOEV5uLJnbkHI+NvDm3YPURlagCBcoooe1MUlTuziLlFfw1EQ
        Bxh8FSmxw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:37702)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jdwsi-0002hA-Sz; Wed, 27 May 2020 15:18:09 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jdwsh-0006VD-7o; Wed, 27 May 2020 15:18:07 +0100
Date:   Wed, 27 May 2020 15:18:07 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     linux-gpio@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, stable@vger.kernel.org
Subject: Re: [PATCH] gpio: fix locking open drain IRQ lines
Message-ID: <20200527141807.GQ1551@shell.armlinux.org.uk>
References: <20200527140758.162280-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200527140758.162280-1-linus.walleij@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 27, 2020 at 04:07:58PM +0200, Linus Walleij wrote:
> We provided the right semantics on open drain lines being
> by definition output but incidentally the irq set up function
> would only allow IRQs on lines that were "not output".
> 
> Fix the semantics to allow output open drain lines to be used
> for IRQs.
> 
> Reported-by: Hans Verkuil <hverkuil@xs4all.nl>
> Cc: Russell King <linux@armlinux.org.uk>
> Cc: stable@vger.kernel.org
> Fixes: 256efaea1fdc ("gpiolib: fix up emulated open drain outputs")

As I've pointed out in the reporting thread, I don't think it can be
justified as a regression - it's a bug in its own right that has been
discovered by unifying the gpiolib semantics, since the cec-gpio code
will fail on hardware that can provide real open-drain outputs
irrespective of that commit.

So, you're really fixing a deeper problem that was never discovered
until gpiolib's semantics were fixed to be more uniform.

> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/gpio/gpiolib.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index b4b5792fe2ff..edd74ff31cea 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -4220,7 +4220,9 @@ int gpiochip_lock_as_irq(struct gpio_chip *gc, unsigned int offset)
>  		}
>  	}
>  
> -	if (test_bit(FLAG_IS_OUT, &desc->flags)) {
> +	/* To be valid for IRQ the line needs to be input or open drain */
> +	if (test_bit(FLAG_IS_OUT, &desc->flags) &&
> +	    !test_bit(FLAG_OPEN_DRAIN, &desc->flags)) {
>  		chip_err(gc,
>  			 "%s: tried to flag a GPIO set as output for IRQ\n",
>  			 __func__);
> -- 
> 2.25.4
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 424kbps up
