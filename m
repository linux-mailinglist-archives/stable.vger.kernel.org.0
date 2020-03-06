Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF8817BC9B
	for <lists+stable@lfdr.de>; Fri,  6 Mar 2020 13:18:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727212AbgCFMSa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Mar 2020 07:18:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:42958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726378AbgCFMSa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Mar 2020 07:18:30 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39FA420866;
        Fri,  6 Mar 2020 12:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583497109;
        bh=6h6y2vs5rjLKL5RwvxTAWpj0alaGXXXmtOtVKeSMsz8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LJ+gfmcp4QC+SHZ66TnABrPufMeEBA10v6soGKYgeL+m1f9UfOy5Zx+4HAbfLEH4I
         PzHGJP9CJTAhyDH9i0mk1/cr3jbaou3KW9ZtiGHQQNn9SZtbdXHLQY9QkyXT9h63Dm
         aOQUCxRwu3USD6uXn4nz9zTPXXzHCKuLhEfY3XcA=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jABvu-00AYhU-Qq; Fri, 06 Mar 2020 12:18:26 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 06 Mar 2020 12:18:26 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     linux-gpio@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Lina Iyer <ilina@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>, stable@vger.kernel.org
Subject: Re: [PATCH] pinctrl: qcom: Guard irq_eoi()
In-Reply-To: <20200306121221.1231296-1-linus.walleij@linaro.org>
References: <20200306121221.1231296-1-linus.walleij@linaro.org>
Message-ID: <bf5be11de00a4d32c31bfc122704c5b0@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: linus.walleij@linaro.org, linux-gpio@vger.kernel.org, bjorn.andersson@linaro.org, ilina@codeaurora.org, swboyd@chromium.org, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Linus,

On 2020-03-06 12:12, Linus Walleij wrote:
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
> diff --git a/drivers/pinctrl/qcom/pinctrl-msm.c
> b/drivers/pinctrl/qcom/pinctrl-msm.c
> index 9a8daa256a32..511f596cf2c3 100644
> --- a/drivers/pinctrl/qcom/pinctrl-msm.c
> +++ b/drivers/pinctrl/qcom/pinctrl-msm.c
> @@ -828,6 +828,12 @@ static void msm_gpio_irq_unmask(struct irq_data 
> *d)
>  	msm_gpio_irq_clear_unmask(d, false);
>  }
> 
> +static void msm_gpio_irq_eoi(struct irq_data *d)
> +{
> +	if (d->parent_data)
> +		irq_chip_eoi_parent(d);
> +}
> +
>  static void msm_gpio_irq_ack(struct irq_data *d)
>  {
>  	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
> @@ -1104,7 +1110,7 @@ static int msm_gpio_init(struct msm_pinctrl 
> *pctrl)
>  	pctrl->irq_chip.irq_mask = msm_gpio_irq_mask;
>  	pctrl->irq_chip.irq_unmask = msm_gpio_irq_unmask;
>  	pctrl->irq_chip.irq_ack = msm_gpio_irq_ack;
> -	pctrl->irq_chip.irq_eoi = irq_chip_eoi_parent;
> +	pctrl->irq_chip.irq_eoi = msm_gpio_irq_eoi;
>  	pctrl->irq_chip.irq_set_type = msm_gpio_irq_set_type;
>  	pctrl->irq_chip.irq_set_wake = msm_gpio_irq_set_wake;
>  	pctrl->irq_chip.irq_request_resources = msm_gpio_irq_reqres;

Long term, it may me better to offer a different set of callbacks
for interrupts that are terminated at the pinctrl level.

In the meantime, and as a fix:

Acked-by: Marc Zyngier <maz@kernel.org>

I assume you'll take this via the pinctrl tree?

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
