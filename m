Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02B741E60A7
	for <lists+stable@lfdr.de>; Thu, 28 May 2020 14:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389143AbgE1MZG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 May 2020 08:25:06 -0400
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:51471 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388767AbgE1MZF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 May 2020 08:25:05 -0400
Received: from cust-b5b5937f ([IPv6:fc0c:c16d:66b8:757f:c639:739b:9d66:799d])
        by smtp-cloud8.xs4all.net with ESMTPA
        id eHakjUpxvdPgTeHaoj478f; Thu, 28 May 2020 14:25:02 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=xs4all.nl; s=s1;
        t=1590668702; bh=WVFfaZIn5QnA0qbS65lvMP/+eso39myqUsnVOV3e2q4=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type:From:
         Subject;
        b=RX2sVgvjcfHKXvTzyW7W3m+7426ngZ4K1eO5P1CkGlKMtKcRehoQShSGcDgiJ3Z7M
         tHrE7/YtWwbU/XHIfEcc0XYmP3c7UdP2Vy8P64CAmPuHL53tAnOz/oRNR5BbB9fU97
         zJFlzF3NUB///QOidIRdxABAwvpJzacuVO7MWe3r2YfcnyGhOzcwurS22ovuymYxO9
         ij/fX36z4XWMqRa2eeWYJu/P2uYeODAbYnbib2gJ2gAI70F/XQy8/N2i97M20uy4Yb
         Ey8H3yFhXbiy9DRMB0UHhusVjG54LanS9Dc7IxhOvhhmKHHsG9dIKEEGZBPz382iQ/
         0n6UANiY7E7aA==
Subject: Re: [PATCH] gpio: fix locking open drain IRQ lines
To:     Linus Walleij <linus.walleij@linaro.org>,
        linux-gpio@vger.kernel.org
Cc:     Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Russell King <linux@armlinux.org.uk>, stable@vger.kernel.org
References: <20200527140758.162280-1-linus.walleij@linaro.org>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <79d89e93-4e40-089c-606d-e7787013bc80@xs4all.nl>
Date:   Thu, 28 May 2020 14:24:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200527140758.162280-1-linus.walleij@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfPVPBOwdtXJXTKCJAyD/VtiL93Qu66NRpMdbGbdGAqXfI7WBdaocjhDy1e2Xx7/F874B5RxuNg0rgq/pdN+7hQSLYfbsAf9DPGJOxbnKwgNreMuGIqJG
 mUw9huylk26PVuxOMZ6VeueqGQVKZzu7LKqeDtVIEIXwPAcAZ0ZaOZ5tXiVW4BRGrH+KdpSO2nFfCEtO4djl4OZuBkqB1YXJjzsFdk3wrT0H7YOv11EKKOis
 hXS+hrL1i4lyJSuxXcyUY015Jx8z0emmPLUHIBV4vP3cL2u8kZqv844q8O7Ze0UY9wO0MuDyxhZ7JXCxD8LvyA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 27/05/2020 16:07, Linus Walleij wrote:
> We provided the right semantics on open drain lines being
> by definition output but incidentally the irq set up function
> would only allow IRQs on lines that were "not output".
> 
> Fix the semantics to allow output open drain lines to be used
> for IRQs.
> 
> Reported-by: Hans Verkuil <hverkuil@xs4all.nl>

Tested-by: Hans Verkuil <hverkuil@xs4all.nl>

Whether this is the right/best fix or not, I cannot tell, but it certainly
fixes the cec-gpio driver!

Regards,

	Hans

> Cc: Russell King <linux@armlinux.org.uk>
> Cc: stable@vger.kernel.org
> Fixes: 256efaea1fdc ("gpiolib: fix up emulated open drain outputs")
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
> 

