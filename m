Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1108879A79
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729732AbfG2U5u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 16:57:50 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:44390 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729460AbfG2U5j (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jul 2019 16:57:39 -0400
Received: by mail-io1-f65.google.com with SMTP id s7so123020089iob.11
        for <stable@vger.kernel.org>; Mon, 29 Jul 2019 13:57:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L5RytHit4X08n6jV2HyhhKaqqveeyW/HhS3yo6ZQZxA=;
        b=oCGXNmDyinpTmd9klgACk0j3gYC3EA/phxvdIGEb+7GHGNGkeQgwJ/3qpWzGwzmVXA
         vcz6DwxYyzqZ38l9poXNsbkghuny2W7pIgVrm1NYeq2ci7dk539kWngx/lb6NRfSZcNn
         ula6LEq37/7TZIm1b5cx6Zz07eI+KvJgqAuPsAMsBKAu244LV/DEPyMLt/RNRqU+Y6cg
         z+YJvBbyV2kuZAcGxsFChstu1Ey/IeOL4JbfJTIM+oMPyYzVOiywwmGtdvJIlJujO4Qp
         ixVLy+xDetJU1eC1ZbHssP/bVsaP97eo4W7iFfi5F8v/1+hr7/Kh2OLudWA8rYUvHjaY
         c0LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L5RytHit4X08n6jV2HyhhKaqqveeyW/HhS3yo6ZQZxA=;
        b=KII5E9C7NyvZKWRpTQKST8MJPmyR9nPMavtLyHEy2G4RwDEZylvb4c/08hjVFOXcwI
         6fysDkhhATPi4z+2PVwHWKjsWjcZOImUnFHGRgq3QtlOiUuxO61ft11BGOlnPsFCD+AS
         FB6dwcQRra42iTsl5zH8xxtlSpcaOr8n2hwKv5iPVLj/t2op/Z/x2b4x2xE3VWhcEcUf
         +1TG9adcbgUuislKpdquy/eFGF9Pre5E4/RzLBicfHstAVSbn7kN3INnRTD33yBrHwXl
         TSp5Cia/cMmFrS9OJrSsDNaVDR9YWS4IRp8EAvCXiqJB+1mQSOooNxtM0WvAvzVXemdy
         azXA==
X-Gm-Message-State: APjAAAXVgv5u+x92cTWdEX3rg8JKFW1CZsxX+txZI8C+AtpFF3qBV1Lj
        rmClVv0SawqU3+2Fn5oy1qUURRM+920sLOacfCEyXA==
X-Google-Smtp-Source: APXvYqzWhbH/ya1U+ih5k+zjUE6/2JnWKBOf++47grpNBrBmZEpw0zs82iTtBAoTjw/EpBT8LyGHx9MH4FiLDeGZnVY=
X-Received: by 2002:a02:85c7:: with SMTP id d65mr2198918jai.8.1564433858079;
 Mon, 29 Jul 2019 13:57:38 -0700 (PDT)
MIME-Version: 1.0
References: <20190729204954.25510-1-briannorris@chromium.org>
In-Reply-To: <20190729204954.25510-1-briannorris@chromium.org>
From:   Enrico Granata <egranata@google.com>
Date:   Mon, 29 Jul 2019 13:57:26 -0700
Message-ID: <CAPR809tL8nB=gfgSoS7gvJw_-igx84pzN4rrnDEMLiyAZ-G_GA@mail.gmail.com>
Subject: Re: [PATCH] driver core: platform: return -ENXIO for missing GpioInt
To:     Brian Norris <briannorris@chromium.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Salvatore Bellizzi <salvatore.bellizzi@linux.seppia.net>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Enrico Granata <egranata@chromium.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Gwendal Grignou <gwendal@chromium.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Benson Leung <bleung@chromium.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 29, 2019 at 1:50 PM Brian Norris <briannorris@chromium.org> wrote:
>
> Commit daaef255dc96 ("driver: platform: Support parsing GpioInt 0 in
> platform_get_irq()") broke the Embedded Controller driver on most LPC
> Chromebooks (i.e., most x86 Chromebooks), because cros_ec_lpc expects
> platform_get_irq() to return -ENXIO for non-existent IRQs.
> Unfortunately, acpi_dev_gpio_irq_get() doesn't follow this convention
> and returns -ENOENT instead. So we get this error from cros_ec_lpc:
>
>    couldn't retrieve IRQ number (-2)
>
> I see a variety of drivers that treat -ENXIO specially, so rather than
> fix all of them, let's fix up the API to restore its previous behavior.
>
> I reported this on v2 of this patch:
>
> https://lore.kernel.org/lkml/20190220180538.GA42642@google.com/
>
> but apparently the patch had already been merged before v3 got sent out:
>
> https://lore.kernel.org/lkml/20190221193429.161300-1-egranata@chromium.org/
>
> and the result is that the bug landed and remains unfixed.
>
> I differ from the v3 patch by:
>  * allowing for ret==0, even though acpi_dev_gpio_irq_get() specifically
>    documents (and enforces) that 0 is not a valid return value (noted on
>    the v3 review)
>  * adding a small comment
>
> Reported-by: Brian Norris <briannorris@chromium.org>
> Reported-by: Salvatore Bellizzi <salvatore.bellizzi@linux.seppia.net>
> Cc: Enrico Granata <egranata@chromium.org>
> Cc: <stable@vger.kernel.org>
> Fixes: daaef255dc96 ("driver: platform: Support parsing GpioInt 0 in platform_get_irq()")
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> ---
> Side note: it might have helped alleviate some of this pain if there
> were email notifications to the mailing list when a patch gets applied.
> I didn't realize (and I'm not sure if Enrico did) that v2 was already
> merged by the time I noted its mistakes. If I had known, I would have
> suggested a follow-up patch, not a v3.
>
> I know some maintainers' "tip bots" do this, but not all apparently.
>
>  drivers/base/platform.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> index 506a0175a5a7..ec974ba9c0c4 100644
> --- a/drivers/base/platform.c
> +++ b/drivers/base/platform.c
> @@ -157,8 +157,13 @@ int platform_get_irq(struct platform_device *dev, unsigned int num)
>          * the device will only expose one IRQ, and this fallback
>          * allows a common code path across either kind of resource.
>          */
> -       if (num == 0 && has_acpi_companion(&dev->dev))
> -               return acpi_dev_gpio_irq_get(ACPI_COMPANION(&dev->dev), num);
> +       if (num == 0 && has_acpi_companion(&dev->dev)) {
> +               int ret = acpi_dev_gpio_irq_get(ACPI_COMPANION(&dev->dev), num);
> +
> +               /* Our callers expect -ENXIO for missing IRQs. */
> +               if (ret >= 0 || ret == -EPROBE_DEFER)
> +                       return ret;
> +       }
>
>         return -ENXIO;
>  #endif
> --
> 2.22.0.709.g102302147b-goog
>

Acked-by: Enrico Granata <egranata@google.com>
