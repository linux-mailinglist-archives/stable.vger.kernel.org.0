Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C418817CA24
	for <lists+stable@lfdr.de>; Sat,  7 Mar 2020 02:06:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbgCGBGV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Mar 2020 20:06:21 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:40073 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbgCGBGV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Mar 2020 20:06:21 -0500
Received: by mail-pg1-f193.google.com with SMTP id t24so1857310pgj.7
        for <stable@vger.kernel.org>; Fri, 06 Mar 2020 17:06:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=eha/3t/Nl/37JaVjTXdHVttvWzeJqLhse3w4Y4CfY1U=;
        b=s3FK1sWjMiqYn/5R6j2/8+zzS3x7QW+TwCzplcjjNN32WCWllh7Wnl9rdP3uRno0zM
         ygdP6j4mLBeONEXGau09I1wceggrBEeCQI2HSHICxPVR7Qs7l1+RwkWVMfSuvigQQqtY
         tXvL2qeZlIh+elw5Lo+bw7pnfLmaRYiDLR/PDL6p8HAFUWfOoHDuiO2fD4vTtH3NHZ70
         EucsOze2ECwskN0B4uw8zbuxithIDGVjEN84RbCaH1XEGT0JjmM4ZP6G0uVrlMQIbb9Y
         lBJpbV/eeTOXoBOxjx9XPKJN2Uz04hQHygsCaKg7jF9rBF/9EgecHEq31QX2cmkgFapF
         3tNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=eha/3t/Nl/37JaVjTXdHVttvWzeJqLhse3w4Y4CfY1U=;
        b=s9mGKUuZDwBoxCuSnN5vYJvcFjDkIOH2qQhT2RjkdbXfNSJMvVjvvNKdiCqVjAV6Bt
         NdlxR1NHuUufS1rJemVUYrfeYbad1L/LvLP4dBddfKYonC9JYic6b2hTMbIf8WFb+J7d
         NPrNw5ae7aivfDvNth5/sAhk4eAHvV3OPwk+tuAcOumfRnxtZjZnz2Ly2+fpVaGyVd8W
         kqjiXW7rwR4w1ykGoFlqWfIIB7Tc5MsVCvzrffWLmT29y02o6ngLx84SpAKaqN3Y0zJT
         W/ep5Bb4RnaLQy+KRT5LY4x6lrizSSl3PziNnWyJNREYP2iwE7Ur/WKPiB/6Hl7ZG0e9
         tvkA==
X-Gm-Message-State: ANhLgQ009AGlvnC3G6nlkR6poEgwR6CLSghAeJI5cZGfBp1T0/D0bXZn
        dSVnN5yA3C4akmQNFceyXS3LJg==
X-Google-Smtp-Source: ADFU+vse0pJAkH0287Ya2RoEJdKaUlVyrF6LnvFHGtoJ8Hhc3UVuBij7D8WMysKvagz52yrVR60P/g==
X-Received: by 2002:a63:5f13:: with SMTP id t19mr5619923pgb.265.1583543180523;
        Fri, 06 Mar 2020 17:06:20 -0800 (PST)
Received: from minitux (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id w14sm35863270pgi.22.2020.03.06.17.06.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 17:06:19 -0800 (PST)
Date:   Fri, 6 Mar 2020 17:06:17 -0800
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     linux-gpio@vger.kernel.org, Lina Iyer <ilina@codeaurora.org>,
        Marc Zyngier <maz@kernel.org>,
        Stephen Boyd <swboyd@chromium.org>, stable@vger.kernel.org
Subject: Re: [PATCH] pinctrl: qcom: Guard irq_eoi()
Message-ID: <20200307010617.GV1214176@minitux>
References: <20200306121221.1231296-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200306121221.1231296-1-linus.walleij@linaro.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri 06 Mar 04:12 PST 2020, Linus Walleij wrote:

> In the commit setting up the qcom/msm pin controller to
> be hierarchical some callbacks were careful to check that
> d->parent_data on irq_data was valid before calling the
> parent function, however irq_chip_eoi_parent() was called
> unconditionally which doesn't work with elder Qualcomm
> platforms such as APQ8060.
> 
> When the drivers/mfd/qcom-pm8xxx.c driver calls
> chained_irq_exit() that call will in turn call chip->irq_eoi()
> which is set to irq_chip_eoi_parent() by default on a
> hierachical IRQ chip, and the parent is pinctrl-msm.c
> so that will in turn unconditionally call
> irq_chip_eoi_parent() again, but its parent is invalid
> so we get the following crash:
> 
>  Unnable to handle kernel NULL pointer dereference at
>  virtual address 00000010
>  pgd = (ptrval)
>  [00000010] *pgd=00000000
>  Internal error: Oops: 5 [#1] PREEMPT SMP ARM
>  (...)
>  PC is at irq_chip_eoi_parent+0x4/0x10
>  LR is at pm8xxx_irq_handler+0x1b4/0x2d8
> 
> Implement a local stub just avoiding to call down to
> irq_chip_eoi_parent() if d->parent_data is not set.
> 
> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> Cc: Lina Iyer <ilina@codeaurora.org>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Stephen Boyd <swboyd@chromium.org>
> Cc: stable@vger.kernel.org
> Fixes: e35a6ae0eb3a ("pinctrl/msm: Setup GPIO chip in hierarchy")
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/pinctrl/qcom/pinctrl-msm.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/pinctrl/qcom/pinctrl-msm.c b/drivers/pinctrl/qcom/pinctrl-msm.c
> index 9a8daa256a32..511f596cf2c3 100644
> --- a/drivers/pinctrl/qcom/pinctrl-msm.c
> +++ b/drivers/pinctrl/qcom/pinctrl-msm.c
> @@ -828,6 +828,12 @@ static void msm_gpio_irq_unmask(struct irq_data *d)
>  	msm_gpio_irq_clear_unmask(d, false);
>  }
>  
> +static void msm_gpio_irq_eoi(struct irq_data *d)

I find it odd that the pinctrl-msm driver would be the only place that
needs this. But let's start with this.

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Regards,
Bjorn

> +{
> +	if (d->parent_data)
> +		irq_chip_eoi_parent(d);
> +}
> +
>  static void msm_gpio_irq_ack(struct irq_data *d)
>  {
>  	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
> @@ -1104,7 +1110,7 @@ static int msm_gpio_init(struct msm_pinctrl *pctrl)
>  	pctrl->irq_chip.irq_mask = msm_gpio_irq_mask;
>  	pctrl->irq_chip.irq_unmask = msm_gpio_irq_unmask;
>  	pctrl->irq_chip.irq_ack = msm_gpio_irq_ack;
> -	pctrl->irq_chip.irq_eoi = irq_chip_eoi_parent;
> +	pctrl->irq_chip.irq_eoi = msm_gpio_irq_eoi;
>  	pctrl->irq_chip.irq_set_type = msm_gpio_irq_set_type;
>  	pctrl->irq_chip.irq_set_wake = msm_gpio_irq_set_wake;
>  	pctrl->irq_chip.irq_request_resources = msm_gpio_irq_reqres;
> -- 
> 2.24.1
> 
