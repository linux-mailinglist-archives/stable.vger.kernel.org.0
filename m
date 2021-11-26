Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F07A945EEEB
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 14:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244559AbhKZNQJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 08:16:09 -0500
Received: from fieber.vanmierlo.com ([84.243.197.177]:38073 "EHLO
        kerio9.vanmierlo.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S237341AbhKZNOJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Nov 2021 08:14:09 -0500
X-Greylist: delayed 1936 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Nov 2021 08:14:08 EST
X-Footer: dmFubWllcmxvLmNvbQ==
Received: from roundcube.vanmierlo.com ([192.168.37.37])
        (authenticated user m.brock@vanmierlo.com)
        by kerio9.vanmierlo.com (Kerio Connect 9.3.1 patch 1) with ESMTPA;
        Fri, 26 Nov 2021 13:37:55 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 26 Nov 2021 13:37:55 +0100
From:   Maarten Brock <m.brock@vanmierlo.com>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Karoly Pados <pados@pados.hu>
Subject: Re: [PATCH] USB: serial: cp210x: fix CP2105 GPIO registration
In-Reply-To: <20211126094348.31698-1-johan@kernel.org>
References: <20211126094348.31698-1-johan@kernel.org>
Message-ID: <bbc0c26db175ec8ec6c10cc695c45f6c@vanmierlo.com>
X-Sender: m.brock@vanmierlo.com
User-Agent: Roundcube Webmail/1.3.3
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-11-26 10:43, Johan Hovold wrote:
> When generalising GPIO support and adding support for CP2102N, the GPIO
> registration for some CP2105 devices accidentally broke. Specifically,
> when all the pins of a port are in "modem" mode, and thus unavailable
> for GPIO use, the GPIO chip would now be registered without having
> initialised the number of GPIO lines. This would in turn be rejected by
> gpiolib and some errors messages would be printed (but importantly 
> probe
> would still succeed).
> 
> Fix this by initialising the number of GPIO lines before registering 
> the
> GPIO chip.
> 
> Note that as for the other device types, and as when all CP2105 pins 
> are
> muxed for LED function, the GPIO chip is registered also when no pins
> are available for GPIO use.
> 
> Reported-by: Maarten Brock <m.brock@vanmierlo.com>
> Link: 
> https://lore.kernel.org/r/5eb560c81d2ea1a2b4602a92d9f48a89@vanmierlo.com
> Fixes: c8acfe0aadbe ("USB: serial: cp210x: implement GPIO support for 
> CP2102N")
> Cc: stable@vger.kernel.org      # 4.19
> Cc: Karoly Pados <pados@pados.hu>
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
>  drivers/usb/serial/cp210x.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
> index 7705328034ca..8a60c0d56863 100644
> --- a/drivers/usb/serial/cp210x.c
> +++ b/drivers/usb/serial/cp210x.c
> @@ -1635,6 +1635,8 @@ static int cp2105_gpioconf_init(struct usb_serial 
> *serial)
> 
>  	/*  2 banks of GPIO - One for the pins taken from each serial port */
>  	if (intf_num == 0) {
> +		priv->gc.ngpio = 2;
> +
>  		if (mode.eci == CP210X_PIN_MODE_MODEM) {
>  			/* mark all GPIOs of this interface as reserved */
>  			priv->gpio_altfunc = 0xff;
> @@ -1645,8 +1647,9 @@ static int cp2105_gpioconf_init(struct usb_serial 
> *serial)
>  		priv->gpio_pushpull = (u8)((le16_to_cpu(config.gpio_mode) &
>  						CP210X_ECI_GPIO_MODE_MASK) >>
>  						CP210X_ECI_GPIO_MODE_OFFSET);
> -		priv->gc.ngpio = 2;
>  	} else if (intf_num == 1) {
> +		priv->gc.ngpio = 3;
> +
>  		if (mode.sci == CP210X_PIN_MODE_MODEM) {
>  			/* mark all GPIOs of this interface as reserved */
>  			priv->gpio_altfunc = 0xff;
> @@ -1657,7 +1660,6 @@ static int cp2105_gpioconf_init(struct usb_serial 
> *serial)
>  		priv->gpio_pushpull = (u8)((le16_to_cpu(config.gpio_mode) &
>  						CP210X_SCI_GPIO_MODE_MASK) >>
>  						CP210X_SCI_GPIO_MODE_OFFSET);
> -		priv->gc.ngpio = 3;
>  	} else {
>  		return -ENODEV;
>  	}

Tested-by: Maarten Brock <m.brock@vanmierlo.com>

