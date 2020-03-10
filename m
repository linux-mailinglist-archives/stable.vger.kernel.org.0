Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 961711809D1
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 22:04:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbgCJVEN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 17:04:13 -0400
Received: from mail-ua1-f65.google.com ([209.85.222.65]:41901 "EHLO
        mail-ua1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbgCJVEN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 17:04:13 -0400
Received: by mail-ua1-f65.google.com with SMTP id l7so539351uap.8
        for <stable@vger.kernel.org>; Tue, 10 Mar 2020 14:04:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sdbG+NqozjHb3DuLnEyD+xmAePEHTJeITgREUaZPMNg=;
        b=CngUwdr3bxoD5iC/5lI0WCL6Mqn6nSmpoMEK83K3xN0v08ISyBSVyXb/zcm5ZDQeCb
         PgmUesXLiCxl6wmzOs5WtQIdvBMj/VSdElpEMXjRzX85yI28VD7T7jVb0ccczckgBQ34
         Lm/tL7AYk/ec8oVUMbXgOswT0jyxukaC0XZqc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sdbG+NqozjHb3DuLnEyD+xmAePEHTJeITgREUaZPMNg=;
        b=h1YQ55lXyUBKGZLA8FGLLd3XEoC4rVCNJmYWNpioKd8t2CnutlRG3qKO8ejrXvUlE8
         WM1wa6xEuX1wL05urDdsktcR/ynogqEKCvFZ5cFj49t/qI5Ktjg1B5gkHA9rVfJBrJbT
         E5Sj3bKSL8eurd5g1PaAiZNct16nmRDmNdgthJJ0Y8NXbFgQz2Qe5LOhMzgfw0K0T0iV
         znUiL0SrQ7gTETFig35zjoOvurIBYYDzl4EeSJbcILSHUK8XueJ/in452ljuIfPQGZpX
         u5sFweVU/Ba7kVthP9Z2tLaEPSu5WuUn9joVEPT1FKu6+a+ZMoIUiaVuAT4QRhzYwUb+
         GJQQ==
X-Gm-Message-State: ANhLgQ30YMaLgJ+gajqJS5+Hq0AtTECvf3Y8Qmi9ZsOkCbAY09iV9NbC
        7JVMCf3cDAMxKkmijs9iNXGckj6rkiQ=
X-Google-Smtp-Source: ADFU+vsiKWZLro1yN2jo+oRvmkufr8ABv6iyuj40jV4YdnJDmWLWq7WJLWKitnFOQ3kjkBcmRoOUQA==
X-Received: by 2002:ab0:496d:: with SMTP id a42mr1869898uad.90.1583874249583;
        Tue, 10 Mar 2020 14:04:09 -0700 (PDT)
Received: from mail-ua1-f47.google.com (mail-ua1-f47.google.com. [209.85.222.47])
        by smtp.gmail.com with ESMTPSA id i5sm5958538vsb.1.2020.03.10.14.04.08
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2020 14:04:08 -0700 (PDT)
Received: by mail-ua1-f47.google.com with SMTP id g21so2847792uaj.1
        for <stable@vger.kernel.org>; Tue, 10 Mar 2020 14:04:08 -0700 (PDT)
X-Received: by 2002:ab0:a90:: with SMTP id d16mr8706162uak.22.1583874247823;
 Tue, 10 Mar 2020 14:04:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200303174349.075101355@linuxfoundation.org> <20200303174349.401386271@linuxfoundation.org>
 <20200304151316.GA2367@duo.ucw.cz> <20200304171817.GC1852712@kroah.com> <20200309101410.GA18031@duo.ucw.cz>
In-Reply-To: <20200309101410.GA18031@duo.ucw.cz>
From:   Doug Anderson <dianders@chromium.org>
Date:   Tue, 10 Mar 2020 14:03:55 -0700
X-Gmail-Original-Message-ID: <CAD=FV=X4u90Q3-QLHqUSGQkNZOXO4HZ_euVXCSUncQj0bhH3dw@mail.gmail.com>
Message-ID: <CAD=FV=X4u90Q3-QLHqUSGQkNZOXO4HZ_euVXCSUncQj0bhH3dw@mail.gmail.com>
Subject: Re: [PATCH] drm/msm: fix leaks if initialization fails
To:     Pavel Machek <pavel@denx.de>, Rob Clark <robdclark@gmail.com>,
        Sean Paul <seanpaul@chromium.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "# 4.0+" <stable@vger.kernel.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Mon, Mar 9, 2020 at 3:14 AM Pavel Machek <pavel@denx.de> wrote:
>
> We should free resources in unlikely case of allocation failure.
>
> Signed-off-by: Pavel Machek <pavel@denx.de>
>
> ---
>
> > Can you submit a patch to fix it?
>
> Here it is.
>
> Best regards,
>                                                                 Pavel
>
>
> diff --git a/drivers/gpu/drm/msm/msm_drv.c b/drivers/gpu/drm/msm/msm_drv.c
> index 83a0000eecb3..f5c1495cc4b9 100644
> --- a/drivers/gpu/drm/msm/msm_drv.c
> +++ b/drivers/gpu/drm/msm/msm_drv.c
> @@ -444,8 +444,10 @@ static int msm_drm_init(struct device *dev, struct drm_driver *drv)
>         if (!dev->dma_parms) {
>                 dev->dma_parms = devm_kzalloc(dev, sizeof(*dev->dma_parms),
>                                               GFP_KERNEL);
> -               if (!dev->dma_parms)
> -                       return -ENOMEM;
> +               if (!dev->dma_parms) {
> +                       ret = -ENOMEM;
> +                       goto err_msm_uninit;
> +               }
>         }
>         dma_set_max_seg_size(dev, DMA_BIT_MASK(32));

Looks good.  Error cases both above and below your "goto" both already
go to err_msm_uninit(), so it makes sense it would also be the
appropriate place for you to go to.  ...and no extra cleanup was
needed for dma_parms allocation since it was devm.  Thus:

Fixes: db735fc4036b ("drm/msm: Set dma maximum segment size for mdss")
Reviewed-by: Douglas Anderson <dianders@chromium.org>

Thanks for noticing and fixing!

-Doug
