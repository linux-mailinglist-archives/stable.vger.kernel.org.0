Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8516C473A
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 11:07:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbjCVKHN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 06:07:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbjCVKHM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 06:07:12 -0400
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C28959E4E
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 03:07:10 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id l7so1157051qvh.5
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 03:07:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679479630;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=QnZosvUq8qzkgLxKKE/9sPWIfB/HU/AWtKSlc35tW34=;
        b=cMsBUuFOrqgW4w0tLieqeHBMLL41hmnKw7r8Fp9vPn1fChqVnwXV8aYmpJpZ/hT8fE
         ixgJ7yOsH9QUmpPf+cewXdGkRCHC8AgUosnRlVYEpIxyPfj2spF3Y4qEbY1XfyLGlz0s
         XIwKQwNpdvGo6mumkR4yE3dmIVip9uIWmqfTqJMKhnva6rzroVlp8gyU3xKlQRXBM7AU
         7jaYevdLxFFj7nl6Z7nw4yIbtxrqs6y+NnqUpWs6Jo9/s0SAuGeawoHJLOEca52HFkp3
         Cg7TXt2zsO46AwG19yCvTgqkT/Rr0dgtSN4TjcuRkBfZjUf7uQTW5RQ/i5hFdNzLGzq1
         BdwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679479630;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QnZosvUq8qzkgLxKKE/9sPWIfB/HU/AWtKSlc35tW34=;
        b=k5DGgJ4svy1syfi1cF96mz+0g0R5wbRVvATMbQIFY0W5A62tKqZoHOIWhbpwAC+Lxx
         xJbnY9sp/A/M9JDmMK/vLoRV7ncVOcIiYf3UbWt1RdUrRsH/oWNA2PR9s1IEfDinzT2/
         gbrumw3bsA8rNpj0oRwzFkXUlGCW0qJLwuOp9hx1fckC/h6x/LsAcoARXkqEJHofkD6l
         WTty3yhGa99A3NonR+RVcknN1bEbJ/lmlC5Kgk5vI/0gg7XYfSgK2guNQngsJcoTWZsd
         MSXoIpkLsVP3IZslGk7RZQYHg8AgQDdO1mkJOFxIrSDvF/yyoU0qDNL4VjwXRr1Ueski
         CbTg==
X-Gm-Message-State: AO0yUKWuHGay+wA6tyOSQUk9SIoWIWBUGJPDCovTogt9ymjxgsnghGhz
        uwkfI19xLq0k2oLOpoSExtULdtJRAN+u2bXmuIOc5w==
X-Google-Smtp-Source: AK7set8ZJjgsD0g8hB/7Rat/s/Hv8yPnY9iwyQc6Q23dgWte7vKx0c7Bwb+1pdWnuluDFJFx03CmZ7jldKPs+8eHFos=
X-Received: by 2002:ad4:4ba3:0:b0:56f:6b7:3a7b with SMTP id
 i3-20020ad44ba3000000b0056f06b73a7bmr621393qvw.7.1679479629674; Wed, 22 Mar
 2023 03:07:09 -0700 (PDT)
MIME-Version: 1.0
References: <20230321175758.26738-1-srinivas.kandagatla@linaro.org>
In-Reply-To: <20230321175758.26738-1-srinivas.kandagatla@linaro.org>
From:   Amit Pundir <amit.pundir@linaro.org>
Date:   Wed, 22 Mar 2023 15:36:33 +0530
Message-ID: <CAMi1Hd06QKQ3B_fSsvmP6pJOPCCv3J5ntd+VvHSA8u1Q8pJmCw@mail.gmail.com>
Subject: Re: [PATCH] clk: qcom: gfm-mux: use runtime pm while accessing registers
To:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc:     andersson@kernel.org, agross@kernel.org, konrad.dybcio@linaro.org,
        mturquette@baylibre.com, sboyd@kernel.org,
        linux-arm-msm@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 21 Mar 2023 at 23:28, Srinivas Kandagatla
<srinivas.kandagatla@linaro.org> wrote:
>
> gfm mux driver does support runtime pm but we never use it while
> accessing registers. Looks like this driver was getting lucky and
> totally depending on other drivers to leave the clk on.
>
> Fix this by doing runtime pm while accessing registers.

Thank you Srini, this fixes the boot regression I see on the RB5
booting v6.1.y and v6.3-rc kernel versions.

Tested-by: Amit Pundir <amit.pundir@linaro.org>

>
> Fixes: a2d8f507803e ("clk: qcom: Add support to LPASS AUDIO_CC Glitch Free Mux clocks")
> Cc: stable@vger.kernel.org
> Reported-by: Amit Pundir <amit.pundir@linaro.org>
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> ---
>  drivers/clk/qcom/lpass-gfm-sm8250.c | 29 ++++++++++++++++++++++++++++-
>  1 file changed, 28 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/clk/qcom/lpass-gfm-sm8250.c b/drivers/clk/qcom/lpass-gfm-sm8250.c
> index 96f476f24eb2..bcf0ea534f7f 100644
> --- a/drivers/clk/qcom/lpass-gfm-sm8250.c
> +++ b/drivers/clk/qcom/lpass-gfm-sm8250.c
> @@ -38,14 +38,37 @@ struct clk_gfm {
>  static u8 clk_gfm_get_parent(struct clk_hw *hw)
>  {
>         struct clk_gfm *clk = to_clk_gfm(hw);
> +       int ret;
> +       u8 parent;
> +
> +       ret = pm_runtime_resume_and_get(clk->priv->dev);
> +       if (ret < 0 && ret != -EACCES) {
> +               dev_err_ratelimited(clk->priv->dev,
> +                                   "pm_runtime_resume_and_get failed in %s, ret %d\n",
> +                                   __func__, ret);
> +               return ret;
> +       }
> +
> +       parent = readl(clk->gfm_mux) & clk->mux_mask;
> +
> +       pm_runtime_mark_last_busy(clk->priv->dev);
>
> -       return readl(clk->gfm_mux) & clk->mux_mask;
> +       return parent;
>  }
>
>  static int clk_gfm_set_parent(struct clk_hw *hw, u8 index)
>  {
>         struct clk_gfm *clk = to_clk_gfm(hw);
>         unsigned int val;
> +       int ret;
> +
> +       ret = pm_runtime_resume_and_get(clk->priv->dev);
> +       if (ret < 0 && ret != -EACCES) {
> +               dev_err_ratelimited(clk->priv->dev,
> +                                   "pm_runtime_resume_and_get failed in %s, ret %d\n",
> +                                   __func__, ret);
> +               return ret;
> +       }
>
>         val = readl(clk->gfm_mux);
>
> @@ -57,6 +80,8 @@ static int clk_gfm_set_parent(struct clk_hw *hw, u8 index)
>
>         writel(val, clk->gfm_mux);
>
> +       pm_runtime_mark_last_busy(clk->priv->dev);
> +
>         return 0;
>  }
>
> @@ -251,6 +276,8 @@ static int lpass_gfm_clk_driver_probe(struct platform_device *pdev)
>         if (IS_ERR(cc->base))
>                 return PTR_ERR(cc->base);
>
> +       cc->dev = dev;
> +
>         err = devm_pm_runtime_enable(dev);
>         if (err)
>                 return err;
> --
> 2.21.0
>
