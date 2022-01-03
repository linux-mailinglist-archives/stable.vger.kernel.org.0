Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93DD94833C1
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:49:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233117AbiACOtW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:49:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbiACOtW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:49:22 -0500
Received: from mail-vk1-xa2f.google.com (mail-vk1-xa2f.google.com [IPv6:2607:f8b0:4864:20::a2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9B0AC061761
        for <stable@vger.kernel.org>; Mon,  3 Jan 2022 06:49:21 -0800 (PST)
Received: by mail-vk1-xa2f.google.com with SMTP id h67so18960368vkh.1
        for <stable@vger.kernel.org>; Mon, 03 Jan 2022 06:49:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HWc6kMGP/M+msoEBTnVD+/VQ6/IgWEBExdaLxDbpI5U=;
        b=g7BmJBPMjxPW+Ba565Ck5u6y91erR7ajoBfz1K+6UZzNMaTYgdU3/604VSjUrNipbO
         9EAkF9uG2AZh4L737doHouNA2ZGiF88vxfu0M1/PZMQ2bH6ujlfo+wVjh/vVlY2PA2P1
         I6YMP2/a4KlaBTvUqZWYA8RCZXqekivT4NkoTh9BrghF5zKxG27tnCLddGi6P+dZln4m
         Hf1ka8DNBu2YiXHgP46BFlyKsFVeS9AKoAp1/B0vmLm3SiWV6tyJ7gaXIHh9fbYIpKGj
         aJGJTtWNCJHn94Xd1IU91DBVrN955TTJE8d3oSGqxqFfGk07/RFKlqZxLa2w9b8ar1k1
         6Y1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HWc6kMGP/M+msoEBTnVD+/VQ6/IgWEBExdaLxDbpI5U=;
        b=nt1/pQcRQrtn9gfB4E+M/ZhvDgYnKFBVRDmnxQ3wzGiF8tPTSY5mQvZf8Tc08O0GIT
         CHDfeGs45Tw/egMZ6+mAFR94E316FN7kwD3OnFjlnCltUyrH327ZX3tvicdHphJgw1uL
         1Y3UaxzJcOSZxxxmR5Sl1SqqTC7vzKorLMgsKXb0yOog3Q2WYa3lxDBPpDMqbq/DbjZN
         F+ePqntvk3vJwkh+9clLdI5rWb8d63C4raGcImPdWBcuEGW0CFITob/CAKLXAwulAdLw
         Mz4oi41+4Sk/RCiYLBpRTV7qOH5EbbSGbFeH1dEns4DvBfHC6/1tgkshXJ4MjZCow2v0
         FRCQ==
X-Gm-Message-State: AOAM532CzPi+3sclQ0NfO2xymm5nRrV1s7WhmAL3DMMmPexGJz+rnQp2
        373Ohv7PoT3nLeoI8fmxgB573EQl46plgK0xi4KoDg==
X-Google-Smtp-Source: ABdhPJwwIA/IfQvilN4fRR9XaYaLNL5dYfW/SyPMBHLI4fmxOM14YyT+pKiuH/zq7OrOqH4hy71kD0yP359HgsUko0g=
X-Received: by 2002:ac5:cb72:: with SMTP id l18mr15057905vkn.1.1641221361003;
 Mon, 03 Jan 2022 06:49:21 -0800 (PST)
MIME-Version: 1.0
References: <20211231161930.256733-1-krzysztof.kozlowski@canonical.com> <20211231161930.256733-2-krzysztof.kozlowski@canonical.com>
In-Reply-To: <20211231161930.256733-2-krzysztof.kozlowski@canonical.com>
From:   Sam Protsenko <semen.protsenko@linaro.org>
Date:   Mon, 3 Jan 2022 16:49:08 +0200
Message-ID: <CAPLW+4mosbk2_NPFFP=sUmKjBoZOG3vNcmT+7sMtTunhbVqcxA@mail.gmail.com>
Subject: Re: [PATCH 01/24] pinctrl: samsung: drop pin banks references on
 error paths
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     Tomasz Figa <tomasz.figa@gmail.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-gpio@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <snawrocki@kernel.org>,
        Chanho Park <chanho61.park@samsung.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 31 Dec 2021 at 18:20, Krzysztof Kozlowski
<krzysztof.kozlowski@canonical.com> wrote:
>
> The driver iterates over its devicetree children with
> for_each_child_of_node() and stores for later found node pointer.  This
> has to be put in error paths to avoid leak during re-probing.
>
> Fixes: ab663789d697 ("pinctrl: samsung: Match pin banks with their device nodes")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> ---
>  drivers/pinctrl/samsung/pinctrl-samsung.c | 29 +++++++++++++++++------
>  1 file changed, 22 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/pinctrl/samsung/pinctrl-samsung.c b/drivers/pinctrl/samsung/pinctrl-samsung.c
> index 8941f658e7f1..f2864a7869b3 100644
> --- a/drivers/pinctrl/samsung/pinctrl-samsung.c
> +++ b/drivers/pinctrl/samsung/pinctrl-samsung.c
> @@ -1002,6 +1002,15 @@ samsung_pinctrl_get_soc_data_for_of_alias(struct platform_device *pdev)
>         return &(of_data->ctrl[id]);
>  }
>
> +static void samsung_banks_of_node_put(struct samsung_pinctrl_drv_data *d)
> +{
> +       struct samsung_pin_bank *bank;
> +       unsigned int i;
> +
> +       for (i = 0; i < d->nr_banks; ++i, ++bank)
> +               of_node_put(bank->of_node);

But "bank" variable wasn't actually assigned before, only declared?

> +}
> +
>  /* retrieve the soc specific data */
>  static const struct samsung_pin_ctrl *
>  samsung_pinctrl_get_soc_data(struct samsung_pinctrl_drv_data *d,
> @@ -1116,19 +1125,19 @@ static int samsung_pinctrl_probe(struct platform_device *pdev)
>         if (ctrl->retention_data) {
>                 drvdata->retention_ctrl = ctrl->retention_data->init(drvdata,
>                                                           ctrl->retention_data);
> -               if (IS_ERR(drvdata->retention_ctrl))
> -                       return PTR_ERR(drvdata->retention_ctrl);
> +               if (IS_ERR(drvdata->retention_ctrl)) {
> +                       ret = PTR_ERR(drvdata->retention_ctrl);
> +                       goto err_put_banks;
> +               }
>         }
>
>         ret = samsung_pinctrl_register(pdev, drvdata);
>         if (ret)
> -               return ret;
> +               goto err_put_banks;
>
>         ret = samsung_gpiolib_register(pdev, drvdata);
> -       if (ret) {
> -               samsung_pinctrl_unregister(pdev, drvdata);
> -               return ret;
> -       }
> +       if (ret)
> +               goto err_unregister;
>
>         if (ctrl->eint_gpio_init)
>                 ctrl->eint_gpio_init(drvdata);
> @@ -1138,6 +1147,12 @@ static int samsung_pinctrl_probe(struct platform_device *pdev)
>         platform_set_drvdata(pdev, drvdata);
>
>         return 0;
> +
> +err_unregister:
> +       samsung_pinctrl_unregister(pdev, drvdata);
> +err_put_banks:
> +       samsung_banks_of_node_put(drvdata);
> +       return ret;
>  }
>
>  /*
> --
> 2.32.0
>
