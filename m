Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1076517C1B3
	for <lists+stable@lfdr.de>; Fri,  6 Mar 2020 16:26:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727174AbgCFP0j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Mar 2020 10:26:39 -0500
Received: from onstation.org ([52.200.56.107]:38468 "EHLO onstation.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725835AbgCFP0i (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Mar 2020 10:26:38 -0500
Received: from localhost (c-98-239-145-235.hsd1.wv.comcast.net [98.239.145.235])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: masneyb)
        by onstation.org (Postfix) with ESMTPSA id 5E03F3EA2F;
        Fri,  6 Mar 2020 15:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=onstation.org;
        s=default; t=1583508397;
        bh=O+r8VQF4XCl7Fiwv3/FRAInQGKr7a7TAhlPP1lLiB5w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Kz2w2nk0xMH0lQUaFSboFrx8+8MIeJ9tKVC7RbgDzVIKgpdTIe2vAs2ZCNDrg2UAA
         hp7ZpRiMiMl7TzyhfxKjbOttrULM/n8t9RrJPY6kzLjQ7K5nhJ1WlZeewCReBT/tVs
         KgddGQQW500QfgDdxZo9irx4oEtT3jAz0437Ax8M=
Date:   Fri, 6 Mar 2020 10:26:37 -0500
From:   Brian Masney <masneyb@onstation.org>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     linux-gpio@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] pinctrl: qcom: ssbi-gpio: Fix fwspec parsing bug
Message-ID: <20200306152637.GA13000@onstation.org>
References: <20200306143416.1476250-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200306143416.1476250-1-linus.walleij@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 06, 2020 at 03:34:15PM +0100, Linus Walleij wrote:
> We are parsing SSBI gpios as fourcell fwspecs but they are
> twocell. Probably a simple copy-and-paste bug.
> 
> Tested on the APQ8060 DragonBoard and after this ethernet
> and MMC card detection works again.
> 
> Cc: Brian Masney <masneyb@onstation.org>
> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> Cc: stable@vger.kernel.org
> Fixes: ae436fe81053 ("pinctrl: ssbi-gpio: convert to hierarchical IRQ helpers in gpio core")
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Reviewed-by: Brian Masney <masneyb@onstation.org>

That was a copy and paste error on my part that originated from
spmi-gpio.

Brian


> ---
> ChangeLog v1->v2:
> - Renamed function pointer field to .populate_parent_alloc_arg
>   as it is named upstream.
> ---
>  drivers/pinctrl/qcom/pinctrl-ssbi-gpio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/pinctrl/qcom/pinctrl-ssbi-gpio.c b/drivers/pinctrl/qcom/pinctrl-ssbi-gpio.c
> index fba1d41d20ec..338a15d08629 100644
> --- a/drivers/pinctrl/qcom/pinctrl-ssbi-gpio.c
> +++ b/drivers/pinctrl/qcom/pinctrl-ssbi-gpio.c
> @@ -794,7 +794,7 @@ static int pm8xxx_gpio_probe(struct platform_device *pdev)
>  	girq->fwnode = of_node_to_fwnode(pctrl->dev->of_node);
>  	girq->parent_domain = parent_domain;
>  	girq->child_to_parent_hwirq = pm8xxx_child_to_parent_hwirq;
> -	girq->populate_parent_alloc_arg = gpiochip_populate_parent_fwspec_fourcell;
> +	girq->populate_parent_alloc_arg = gpiochip_populate_parent_fwspec_twocell;
>  	girq->child_offset_to_irq = pm8xxx_child_offset_to_irq;
>  	girq->child_irq_domain_ops.translate = pm8xxx_domain_translate;
>  
> -- 
> 2.24.1
