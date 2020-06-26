Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E24BD20B26F
	for <lists+stable@lfdr.de>; Fri, 26 Jun 2020 15:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728306AbgFZNY0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jun 2020 09:24:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725864AbgFZNY0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jun 2020 09:24:26 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0537CC03E979
        for <stable@vger.kernel.org>; Fri, 26 Jun 2020 06:24:26 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id i14so9350895ejr.9
        for <stable@vger.kernel.org>; Fri, 26 Jun 2020 06:24:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tjgpLIeFDAUiFcn3O1uMF3bzTcfrQw5iKCt6Q1RB/zs=;
        b=VH2xmQ7xOUVzvi1Bpr0+81VUngWtaSOPYYj/vYlCEGjnhgrfpJQVlt1wsJpc0Z74Zs
         KMmstZQNvRrv2YuO00MpMI0ZstSIcy52IlgQS6uCddaZLiM5qgFWcher6siajvG0raHz
         Erk87DzS/WYSUZmNBkP7Yc7b3X5dU9khMW6rc78l4N2ABGCAfk4gc9ICSn/Rhi6fOY2a
         aacbzHjewM7t0ozKlAojFNLkLaJFdQaGJA0Z7uOonV2otiK2Q9voimP2zRINBysP++ZO
         KTevp3SIlf4NHjpvgPson4z/2YNPdTWhisKmpeoYiIYKVV86ZzpZLuHdCaZCn4eLPllV
         bkAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tjgpLIeFDAUiFcn3O1uMF3bzTcfrQw5iKCt6Q1RB/zs=;
        b=l2Nh/jYwBaEp4u6RgU0yd210SibZf478GnM+45wl6qQTsAakY8tGbof0bQN/7LdWCP
         ymu1LVwsGHGSHTzFcmiy2nekhD/mimM36PYdUiB3/GrA34M+pSY2x31slu6guOdsRVUC
         DsX/UIGsIVTVCtbg6DF+z6wd8ESsZOzLgv4klsQIT9InaLQFVZi7ZvdIvRgDvllpccru
         t2kZBfEMq/DNRnufkXrwaJH5QkzcbzlwdsRQRWGFchY1vcDC1OcJ3Vqs0FmXkptyJy69
         jEQXe3qGe/S0MToYzYu8dIu9Vg/OGaNsxyDkNZ0NuPUZ9dXP3m/4RF+fc3hHsx2Dw/ZN
         vcfg==
X-Gm-Message-State: AOAM533VI8BOBRGK+8f6n7/yh5OOulvNFrNdtbm7nbwt+8n9sNCH0qxO
        F5A9DelH4d22WkpIfHvWLTcjbY4g5udxE9FOmV9X6w==
X-Google-Smtp-Source: ABdhPJzCxIM+KdZNlOFJTljDVtD3oYCwf1Pcnq2gyu3IIzH/fmaKmDYmd7Bx8Nve1yopWdonkPBGDz2w6P4EkjGNn8I=
X-Received: by 2002:a17:906:7283:: with SMTP id b3mr2653962ejl.163.1593177864478;
 Fri, 26 Jun 2020 06:24:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200626124808.1886430-1-darekm@google.com>
In-Reply-To: <20200626124808.1886430-1-darekm@google.com>
From:   Guenter Roeck <groeck@google.com>
Date:   Fri, 26 Jun 2020 06:24:13 -0700
Message-ID: <CABXOdTevmLk9-Zwj+xCM2BN-QFHcmn-UE0ZPmrzUpQpk_QhhfQ@mail.gmail.com>
Subject: Re: [PATCH v3] media: cros-ec-cec: do not bail on device_init_wakeup failure
To:     Dariusz Marcinkiewicz <darekm@google.com>
Cc:     linux-media@vger.kernel.org,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Gwendal Grignou <gwendal@chromium.org>,
        "# v4 . 10+" <stable@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Benson Leung <bleung@chromium.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Guenter Roeck <groeck@chromium.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sebastian Reichel <sre@kernel.org>,
        Dariusz Marcinkiewicz <darekm@chromium.org>,
        Lee Jones <lee.jones@linaro.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 26, 2020 at 5:50 AM Dariusz Marcinkiewicz <darekm@google.com> wrote:
>
> Do not fail probing when device_init_wakeup fails. Also clear wakeup
> on remove.
>
> device_init_wakeup fails when the device is already enabled as wakeup
> device. Hence, the driver fails to probe the device if:
> - The device has already been enabled for wakeup (via /proc/acpi/wakeup)
> - The driver has been unloaded and is being loaded again.
>
> This goal of the patch is to fix the above cases.
>
> Overwhelming majority of the drivers do not consider device_init_wakeup
> failure as a fatal error and proceed regardless of whether it succeeds
> or not.
>
> Changes since v2:
>  - disabled wakeup in remove
>  - CC'ing stable
>  - description fixed
> Changes since v1:
>  - added Fixes tag
>
> Fixes: cd70de2d356ee ("media: platform: Add ChromeOS EC CEC driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Dariusz Marcinkiewicz <darekm@google.com>

Reviewed-by: Guenter Roeck <groeck@chromium.org>

> ---
>  drivers/media/cec/platform/cros-ec/cros-ec-cec.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/media/cec/platform/cros-ec/cros-ec-cec.c b/drivers/media/cec/platform/cros-ec/cros-ec-cec.c
> index 0e7e2772f08f..3881ed7bc3d9 100644
> --- a/drivers/media/cec/platform/cros-ec/cros-ec-cec.c
> +++ b/drivers/media/cec/platform/cros-ec/cros-ec-cec.c
> @@ -277,12 +277,6 @@ static int cros_ec_cec_probe(struct platform_device *pdev)
>         platform_set_drvdata(pdev, cros_ec_cec);
>         cros_ec_cec->cros_ec = cros_ec;
>
> -       ret = device_init_wakeup(&pdev->dev, 1);
> -       if (ret) {
> -               dev_err(&pdev->dev, "failed to initialize wakeup\n");
> -               return ret;
> -       }
> -
>         cros_ec_cec->adap = cec_allocate_adapter(&cros_ec_cec_ops, cros_ec_cec,
>                                                  DRV_NAME,
>                                                  CEC_CAP_DEFAULTS |
> @@ -310,6 +304,8 @@ static int cros_ec_cec_probe(struct platform_device *pdev)
>         if (ret < 0)
>                 goto out_probe_notify;
>
> +       device_init_wakeup(&pdev->dev, 1);
> +
>         return 0;
>
>  out_probe_notify:
> @@ -339,6 +335,8 @@ static int cros_ec_cec_remove(struct platform_device *pdev)
>                                          cros_ec_cec->adap);
>         cec_unregister_adapter(cros_ec_cec->adap);
>
> +       device_init_wakeup(&pdev->dev, 0);
> +
>         return 0;
>  }
>
> --
> 2.27.0.212.ge8ba1cc988-goog
>
