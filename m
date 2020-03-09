Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD06B17E2C6
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 15:54:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbgCIOy1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Mar 2020 10:54:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:43522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726695AbgCIOy0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Mar 2020 10:54:26 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8206222D9;
        Mon,  9 Mar 2020 14:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583765665;
        bh=C1cXE+shbxK5n3fyrkPtztfK5LTlFOl3pAD64gHyFSA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=i/DOvxuINdxlUMAZeNCWHguF45SpZBNMymonF3jKcRtH//+hgoHtRcGF4nAjahxLz
         dzLX+V39ZRwypZsbr0esNBmDk5h0A0iH1ebaQibZ05vziD6pWaS2LKb4ANHJosWT09
         BfDHO3yEeGC7qh/ECZxnf0eErvGt0hMDUeuxAFJg=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jBJnU-00BJ8t-3t; Mon, 09 Mar 2020 14:54:24 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 09 Mar 2020 14:54:24 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     linux-gpio@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Lina Iyer <ilina@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>, stable@vger.kernel.org
Subject: Re: [PATCH v2] pinctrl: qcom: Assign irq_disable/eoi conditionally
In-Reply-To: <20200309125207.571840-1-linus.walleij@linaro.org>
References: <20200309125207.571840-1-linus.walleij@linaro.org>
Message-ID: <1be9151d00160ef26a3900e0e6a5fd14@kernel.org>
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

On 2020-03-09 12:52, Linus Walleij wrote:
> The hierarchical parts of MSM pinctrl/GPIO is only
> used when the device tree has a "wakeup-parent" as
> a phandle, but the .irq_disable and .irq_eoi are anyway
> assigned leading to semantic problems on elder
> Qualcomm chipsets.
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
> If we solve this crash by avoiding to call up to
> irq_chip_eoi_parent(), the machine will hang and get
> reset by the watchdog, because of semantic issues,
> probably inside irq_chip.
> 
> As a solution, just assign the .irq_disable and .irq_eoi
> condtionally if we are actually using a wakeup parent.
> 
> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> Cc: Lina Iyer <ilina@codeaurora.org>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Stephen Boyd <swboyd@chromium.org>
> Cc: stable@vger.kernel.org
> Fixes: e35a6ae0eb3a ("pinctrl/msm: Setup GPIO chip in hierarchy")
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> ChangeLog v1->v2:
> - Noticed that the previous solution doesn't actually work,
>   the machine hangs and reboots intead (even if it got rid of
>   the most obvious crash). Make a more thorough solution that
>   completely avoids using these callbacks if we don't have
>   a parent.

What is the problem with disable exactly?

> - v1 was called "Guard irq_eoi()"
> ---
>  drivers/pinctrl/qcom/pinctrl-msm.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/pinctrl/qcom/pinctrl-msm.c
> b/drivers/pinctrl/qcom/pinctrl-msm.c
> index 9a8daa256a32..fe3c53ae25f4 100644
> --- a/drivers/pinctrl/qcom/pinctrl-msm.c
> +++ b/drivers/pinctrl/qcom/pinctrl-msm.c
> @@ -1100,11 +1100,9 @@ static int msm_gpio_init(struct msm_pinctrl 
> *pctrl)
> 
>  	pctrl->irq_chip.name = "msmgpio";
>  	pctrl->irq_chip.irq_enable = msm_gpio_irq_enable;
> -	pctrl->irq_chip.irq_disable = msm_gpio_irq_disable;

I find it really odd to have the enable callback, but not the disable.
What is the rational for that? Can we drop the enable as well for old
platforms and only use mask/unmask instead?

>  	pctrl->irq_chip.irq_mask = msm_gpio_irq_mask;
>  	pctrl->irq_chip.irq_unmask = msm_gpio_irq_unmask;
>  	pctrl->irq_chip.irq_ack = msm_gpio_irq_ack;
> -	pctrl->irq_chip.irq_eoi = irq_chip_eoi_parent;
>  	pctrl->irq_chip.irq_set_type = msm_gpio_irq_set_type;
>  	pctrl->irq_chip.irq_set_wake = msm_gpio_irq_set_wake;
>  	pctrl->irq_chip.irq_request_resources = msm_gpio_irq_reqres;
> @@ -1118,7 +1116,8 @@ static int msm_gpio_init(struct msm_pinctrl 
> *pctrl)
>  		if (!chip->irq.parent_domain)
>  			return -EPROBE_DEFER;
>  		chip->irq.child_to_parent_hwirq = msm_gpio_wakeirq;
> -
> +		pctrl->irq_chip.irq_disable = msm_gpio_irq_disable;
> +		pctrl->irq_chip.irq_eoi = irq_chip_eoi_parent;
>  		/*
>  		 * Let's skip handling the GPIOs, if the parent irqchip
>  		 * is handling the direct connect IRQ of the GPIO.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
