Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3A232690C
	for <lists+stable@lfdr.de>; Fri, 26 Feb 2021 22:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230345AbhBZVAe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Feb 2021 16:00:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbhBZVAe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Feb 2021 16:00:34 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEA59C061756
        for <stable@vger.kernel.org>; Fri, 26 Feb 2021 12:59:53 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id b10so10246609ybn.3
        for <stable@vger.kernel.org>; Fri, 26 Feb 2021 12:59:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OQ3uCqKtxHunbFIt0ruK6PxkQ3eNGZHTwV/YrcwIFXw=;
        b=uWV9w/YN3vsb+dJr7QVQ3p23vztqZdtyNRbHkb3+2I5teJCDcvw9IGB0Osc2cNjvtM
         lAdHxn8xMX/JTB6bGtsn5r5OPjSSIwO8xo0XL7phT9AVJbHgIXbTjxShGXa4ir+/x81a
         7zesy2B1Kw0IhcR8VE3Ig1KwnBzGBzOT5LNotQng2SE2R4jJeCOkNIVlbSzuKLSTIRvx
         vGMWAzMgrzwp5M9Lqw9wu7vFQbcfFLYpl/0LkhZR67HlmoWfvpI0BhwyZL470pMQXkxj
         BABYycc6MeaFvDH4xaLodDhTEpO5NmdiXuHTYjG+XhqCGBPQj8e9jnM3R2URPKEQuHAr
         bX2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OQ3uCqKtxHunbFIt0ruK6PxkQ3eNGZHTwV/YrcwIFXw=;
        b=mMT9HOpo667/gVz3R4rLwG+amC/eT5OLy9hXNCiJjd8YnqNjRKRW90gpgQQBzlb+dF
         5leLaTUJ9EKQVISOzcWPEuc441YJJXmceRb/mltSqj0LJXbylaSxo8MDqvJHL19PW22+
         O3vT8vhqD6mUN4zB9s9S2FP+nH/DFfWPnnIEpUVBCQQ+iVWYJ70ciBUAfr9Kq6gR1G9Z
         w2vZGyL5Xa6Z4TYmBMCrn+sPhHlC7iMgA3msNc6olaeTdUU5j3CPcDmvOhu/t/jTbwxg
         LXSnoa6IdUSEJzMcV3J4busoJb//k7JhRBFe5Q5dAMu8q/33WiTKYpsJpe2B1vQ7p7Lw
         DMGg==
X-Gm-Message-State: AOAM532R0R5wZLHr9ljDUNDvfPBGpG1WCRRGTIxXCz0i1r+TII0AR2gl
        SheuBY5mVpQ50E7BoNLi4EA5EBhSWNQFP0mx0xfjwhBw57I=
X-Google-Smtp-Source: ABdhPJwTS6ztKzPGi+b6i/fWrf0Ve/YSTf4gj+rLuWe5Ub370djTYP3Wb2hFphW7m6seH6RjpMxbI9S07o9Xv8qLs1E=
X-Received: by 2002:a25:ca8f:: with SMTP id a137mr7070683ybg.228.1614373192926;
 Fri, 26 Feb 2021 12:59:52 -0800 (PST)
MIME-Version: 1.0
References: <20210226145246.1171-1-johan@kernel.org> <20210226145246.1171-3-johan@kernel.org>
In-Reply-To: <20210226145246.1171-3-johan@kernel.org>
From:   Saravana Kannan <saravanak@google.com>
Date:   Fri, 26 Feb 2021 12:59:17 -0800
Message-ID: <CAGETcx--z+W4OHTOX-F73a3bvyDahivSB42kojOnzQh-WLmd7g@mail.gmail.com>
Subject: Re: [PATCH 2/2] gpio: fix gpio-device list corruption
To:     Johan Hovold <johan@kernel.org>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 26, 2021 at 6:55 AM Johan Hovold <johan@kernel.org> wrote:
>
> Make sure to hold the gpio_lock when removing the gpio device from the
> gpio_devices list (when dropping the last reference) to avoid corrupting
> the list when there are concurrent accesses.
>
> Fixes: ff2b13592299 ("gpio: make the gpiochip a real device")
> Cc: stable@vger.kernel.org      # 4.6
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
>  drivers/gpio/gpiolib.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index e1016bc8cf14..42bdc55a15f9 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -475,8 +475,12 @@ EXPORT_SYMBOL_GPL(gpiochip_line_is_valid);
>  static void gpiodevice_release(struct device *dev)
>  {
>         struct gpio_device *gdev = container_of(dev, struct gpio_device, dev);
> +       unsigned long flags;
>
> +       spin_lock_irqsave(&gpio_lock, flags);
>         list_del(&gdev->list);
> +       spin_unlock_irqrestore(&gpio_lock, flags);
> +

Reviewed-by: Saravana Kannan <saravanak@google.com>

-Saravana

>         ida_free(&gpio_ida, gdev->id);
>         kfree_const(gdev->label);
>         kfree(gdev->descs);
> --
> 2.26.2
>
