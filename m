Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91E1C18B9D0
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 15:58:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727391AbgCSO6W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 10:58:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:37660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727347AbgCSO6W (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 10:58:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DEA320782;
        Thu, 19 Mar 2020 14:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584629900;
        bh=GVAeBATJZYQy0Z3DzA7NxDsKvZ9QS5yhnTeI6RUEkoI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ee4MGhmh3l69lT8NUU8vy664Kex9uVFBhqXVcOHHtQsAIZhrZbzJHc4KmcL2je0A6
         Ur/SsMX3GzWnrw8IY13bu/9d37EBJ1AtAg3E9+8B+B+2IJBQHrOMJRN3LUhcQyHhW0
         X8MXQLWDu6omcvdHQhYbhvIS36GiG4uY8Zq3bAb0=
Date:   Thu, 19 Mar 2020 15:58:16 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Kevin Hao <haokexin@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.5 01/65] gpiolib: Add support for the irqdomain which
 doesnt use irq_fwspec as arg
Message-ID: <20200319145816.GB92193@kroah.com>
References: <20200319123926.466988514@linuxfoundation.org>
 <20200319123926.902914624@linuxfoundation.org>
 <20200319133355.GB711692@pek-khao-d2.corp.ad.wrs.com>
 <20200319134710.GA4092809@kroah.com>
 <20200319144753.GD711692@pek-khao-d2.corp.ad.wrs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200319144753.GD711692@pek-khao-d2.corp.ad.wrs.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 19, 2020 at 10:47:53PM +0800, Kevin Hao wrote:
> On Thu, Mar 19, 2020 at 02:47:10PM +0100, Greg Kroah-Hartman wrote:
> > On Thu, Mar 19, 2020 at 09:33:55PM +0800, Kevin Hao wrote:
> > > On Thu, Mar 19, 2020 at 02:03:43PM +0100, Greg Kroah-Hartman wrote:
> > > > From: Kevin Hao <haokexin@gmail.com>
> > > > 
> > > > [ Upstream commit 242587616710576808dc8d7cdf18cfe0d7bf9831 ]
> > > > 
> > > > Some gpio's parent irqdomain may not use the struct irq_fwspec as
> > > > argument, such as msi irqdomain. So rename the callback
> > > > populate_parent_fwspec() to populate_parent_alloc_arg() and make it
> > > > allocate and populate the specific struct which is needed by the
> > > > parent irqdomain.
> > > 
> > > Hi Greg,
> > > 
> > > This commit shouldn't go to stable because it is not a bug fix. It is just a
> > > prerequisite of switching to general GPIOLIB_IRQCHIP for thunderx gpio driver
> > > (commit 7a9f4460f74d "gpio: thunderx: Switch to GPIOLIB_IRQCHIP").
> > 
> > This seems to be a prerequisite for f98371476f36 ("pinctrl: qcom:
> > ssbi-gpio: Fix fwspec parsing bug") to apply properly.  With that
> > information, is it ok to keep?
> 
> Yes, this commit does change the context of commit f98371476f36 ("pinctrl: qcom:
> ssbi-gpio: Fix fwspec parsing bug"). So I am fine to keep this in order to apply
> f98371476f36 cleanly. But there is no really logical dependency between these two
> commits, so another option is that we can adjust the commit f98371476f36 a bit in order
> to apply to v5.5.x cleanly without this commit, something like below. IMHO, it is more
> suitable for the stable kernel.
> 
> From 2678327511f77edd8692634e81ef04cd9ca4b249 Mon Sep 17 00:00:00 2001
> From: Linus Walleij <linus.walleij@linaro.org>
> Date: Fri, 6 Mar 2020 15:34:15 +0100
> Subject: [PATCH] pinctrl: qcom: ssbi-gpio: Fix fwspec parsing bug
> 
> [ Upstream commit f98371476f36359da2285d1807b43e5b17fd18de ]
> 
> We are parsing SSBI gpios as fourcell fwspecs but they are
> twocell. Probably a simple copy-and-paste bug.
> 
> Tested on the APQ8060 DragonBoard and after this ethernet
> and MMC card detection works again.
> 
> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> Cc: stable@vger.kernel.org
> Reviewed-by: Brian Masney <masneyb@onstation.org>
> Fixes: ae436fe81053 ("pinctrl: ssbi-gpio: convert to hierarchical IRQ helpers in gpio core")
> Link: https://lore.kernel.org/r/20200306143416.1476250-1-linus.walleij@linaro.org
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> [Kevin: Replace .populate_parent_alloc_arg with .populate_parent_fwspec]
> Signed-off-by: Kevin Hao <haokexin@gmail.com>
> ---
>  drivers/pinctrl/qcom/pinctrl-ssbi-gpio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/pinctrl/qcom/pinctrl-ssbi-gpio.c b/drivers/pinctrl/qcom/pinctrl-ssbi-gpio.c
> index dca86886b1f9..6b7f0d56a532 100644
> --- a/drivers/pinctrl/qcom/pinctrl-ssbi-gpio.c
> +++ b/drivers/pinctrl/qcom/pinctrl-ssbi-gpio.c
> @@ -794,7 +794,7 @@ static int pm8xxx_gpio_probe(struct platform_device *pdev)
>  	girq->fwnode = of_node_to_fwnode(pctrl->dev->of_node);
>  	girq->parent_domain = parent_domain;
>  	girq->child_to_parent_hwirq = pm8xxx_child_to_parent_hwirq;
> -	girq->populate_parent_fwspec = gpiochip_populate_parent_fwspec_fourcell;
> +	girq->populate_parent_fwspec = gpiochip_populate_parent_fwspec_twocell;
>  	girq->child_offset_to_irq = pm8xxx_child_offset_to_irq;
>  	girq->child_irq_domain_ops.translate = pm8xxx_domain_translate;
>  

Thank you, that worked, and I've dropped the other patch now.

Turns out it also broke the build :)

greg k-h
