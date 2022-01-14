Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E724548EE57
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 17:39:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243449AbiANQiv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 11:38:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239265AbiANQiu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 11:38:50 -0500
Received: from mail-ua1-x92d.google.com (mail-ua1-x92d.google.com [IPv6:2607:f8b0:4864:20::92d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A9C2C061574
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 08:38:50 -0800 (PST)
Received: by mail-ua1-x92d.google.com with SMTP id x33so17840005uad.12
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 08:38:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kqh5lKYwnkN37kX/95ffH9A9xkW766WBUrIjfUiOtBY=;
        b=qYb0+aQJEJ0rzV5FWH45IVRX0rF7G6xG4H5zBgLJ5BQ0nYX8VUyDo1exod8NR+G70c
         uUhCkJ1oPjPsyO7yF5Xh+a2x8aWliDLS7AQahujnGlxHXRypN4/MRZu99b7pyB3Rrg5b
         eth+QoX5sOzDN8SgD3pxxH44+AK960G12fGA6WBa3UoXqRhf/9TgeD0hNVj1gNnkBMfz
         8jGFnRU1nbOK5/NmPWgCO/S977btAOFBJy7GsekugUpkWpQqzt5UUUTnBciNQwSuEFMx
         0qS7i4Vl7yHs4iKnthxTpjs3jdN1aJ2cr1k4+UtrielOfEPtCEM9NVxww1fD9eaeyqIj
         EFhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kqh5lKYwnkN37kX/95ffH9A9xkW766WBUrIjfUiOtBY=;
        b=g5ml/WsUsVaGzL5O0agl5KpIMSfhwMPG1R6GWlzlTZkEHH2vmdclDKOeCTQZ67/Y9u
         4wMjMHg5bTucyPuGgl6ETX8F7JBq9ZN0LyeJH53p+DCh1XjM7SGGwCBn8jtd/I4UL+di
         vbEvQmC3QCd5O45bypo8EMyrl2Ut7hzqTgAHk1ow8nPPXc8KtRz0ApfD2r+xiu/1fhG1
         ovnHuOSMjLrzEewVEG7X3JpseTSXcxV1Bxnh7//ncXT2xZq4yltkyJb7DdUh+//w3mC/
         LFgih7oXI4GT2A6LwEh5S+Gq3odt/YsMAFGpfnAh/qIn6x47UywBRWgVef+tk1Xu5nB3
         04PQ==
X-Gm-Message-State: AOAM531iLhFI8xGqxtNLzgZsNRiSExHky3vd88IlQuYD/5NVgeA4Jf45
        dS6jMIhc95NddcuoRBBVzWrpcQ8B6suYU/fPx1KLOA==
X-Google-Smtp-Source: ABdhPJyAOisMhvKMOns8BJKxp2lPM/5PjFuxHnM4pqpl5scSi2WoU18z/odQ7iI4CCAzffQuqDyyJOPkpKUdMicgwNc=
X-Received: by 2002:a05:6102:108c:: with SMTP id s12mr4465397vsr.20.1642178329640;
 Fri, 14 Jan 2022 08:38:49 -0800 (PST)
MIME-Version: 1.0
References: <20220111201426.326777-1-krzysztof.kozlowski@canonical.com> <20220111201426.326777-2-krzysztof.kozlowski@canonical.com>
In-Reply-To: <20220111201426.326777-2-krzysztof.kozlowski@canonical.com>
From:   Sam Protsenko <semen.protsenko@linaro.org>
Date:   Fri, 14 Jan 2022 18:38:37 +0200
Message-ID: <CAPLW+4k18Gz8-CEX_YjgS9tOxMq8xHk9GaUvfHWnPXkOnkinqw@mail.gmail.com>
Subject: Re: [PATCH v2 01/28] pinctrl: samsung: drop pin banks references on
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
        Chanho Park <chanho61.park@samsung.com>,
        Alim Akhtar <alim.akhtar@gmail.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 11 Jan 2022 at 22:15, Krzysztof Kozlowski
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

Reviewed-by: Sam Protsenko <semen.protsenko@linaro.org>

>  drivers/pinctrl/samsung/pinctrl-samsung.c | 30 +++++++++++++++++------
>  1 file changed, 23 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/pinctrl/samsung/pinctrl-samsung.c b/drivers/pinctrl/samsung/pinctrl-samsung.c
> index 8941f658e7f1..b19ebc43d886 100644
> --- a/drivers/pinctrl/samsung/pinctrl-samsung.c
> +++ b/drivers/pinctrl/samsung/pinctrl-samsung.c
> @@ -1002,6 +1002,16 @@ samsung_pinctrl_get_soc_data_for_of_alias(struct platform_device *pdev)
>         return &(of_data->ctrl[id]);
>  }
>
> +static void samsung_banks_of_node_put(struct samsung_pinctrl_drv_data *d)
> +{
> +       struct samsung_pin_bank *bank;
> +       unsigned int i;
> +
> +       bank = d->pin_banks;
> +       for (i = 0; i < d->nr_banks; ++i, ++bank)
> +               of_node_put(bank->of_node);
> +}
> +
>  /* retrieve the soc specific data */
>  static const struct samsung_pin_ctrl *
>  samsung_pinctrl_get_soc_data(struct samsung_pinctrl_drv_data *d,
> @@ -1116,19 +1126,19 @@ static int samsung_pinctrl_probe(struct platform_device *pdev)
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
> @@ -1138,6 +1148,12 @@ static int samsung_pinctrl_probe(struct platform_device *pdev)
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
