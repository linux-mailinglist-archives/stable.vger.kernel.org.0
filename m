Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA484329B38
	for <lists+stable@lfdr.de>; Tue,  2 Mar 2021 11:59:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239832AbhCBBSF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 20:18:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240277AbhCAWrO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 17:47:14 -0500
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E169C061756;
        Mon,  1 Mar 2021 14:44:24 -0800 (PST)
Received: by mail-qv1-xf2c.google.com with SMTP id x13so3068663qvj.7;
        Mon, 01 Mar 2021 14:44:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RfrM1Gt/4AxISEmziFRStELMB/V11h0hLEUuUx3nN0Q=;
        b=kyGyBzOEJ+JH+xpbLxcwWrgFaNYicKV23xa7mUH/8VbWpzyERpy7SbjRkH50nStVfJ
         5k0KJVobqGVO8xay8zzA5g1ZBcyHcotVYp7wtJUsluUPZuiRho8Yh0uVb6dCwJt5fUHv
         H9YKvtsM0QMuI1hsQAwahPtrysxXm2BdXw2MI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RfrM1Gt/4AxISEmziFRStELMB/V11h0hLEUuUx3nN0Q=;
        b=RK6WtkjvzIaU69fQ/ZHg1D9HPQXSx82pu2s4PzqXt5XGOMwUzOL4K6DcOQfXiIJTqF
         jZkVIdVVCAcwl9fTRzU7L6ysVaLXFSAZx/EAH1An4pys8WEAiOs1NR5Qg5nxVoF7f6rm
         e9fsotjoWWUpvuviugpF8OrkThsWox68gOfueQDxHpyYnzWr/uDpAB4S5IOpYwkyWvX5
         MIQP7tOGlaeQsjlrkvbLA9L9UHGK1NohnTrFQ6i9nr7r51Fmn+z8K8n3IanK/Cpfgz0z
         J+xo8OU0S2JN0NM7Cbb6jpDW+q3nL/siooq08lTGybsUii1/sNufclqfPrTBmIFnxTg5
         sTOQ==
X-Gm-Message-State: AOAM533biW2b8+HX2IpUSeXwtPZK5GpWCOjzkxH0yOu/GbmmTSkztGHI
        CHOuWm3ASbAktXgP6jyCwAmuu9uaAP/RotqeNeE=
X-Google-Smtp-Source: ABdhPJzUj6HrVYMAffHRlDTEME1Je7ZnnDxVCtzcYrJEEnC1WprXtblP1CfSeIU4ofubaGcBwWKb8yMG3uhdsLAWwVU=
X-Received: by 2002:ad4:52e3:: with SMTP id p3mr877369qvu.61.1614638663120;
 Mon, 01 Mar 2021 14:44:23 -0800 (PST)
MIME-Version: 1.0
References: <20210301161031.684018251@linuxfoundation.org> <20210301161034.369309830@linuxfoundation.org>
In-Reply-To: <20210301161034.369309830@linuxfoundation.org>
From:   Joel Stanley <joel@jms.id.au>
Date:   Mon, 1 Mar 2021 22:44:11 +0000
Message-ID: <CACPK8XeoKfNCR9diNZoLCM04=G9BRVxY_VZhXr+XQcpq2+rCdQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 055/247] soc: aspeed: snoop: Add clock control logic
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Wang <wangzhiqiang.bj@bytedance.com>,
        Jae Hyun Yoo <jae.hyun.yoo@intel.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org,
        Vernon Mauery <vernon.mauery@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 1 Mar 2021 at 16:37, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Jae Hyun Yoo <jae.hyun.yoo@intel.com>
>
> [ Upstream commit 3f94cf15583be554df7aaa651b8ff8e1b68fbe51 ]
>
> If LPC SNOOP driver is registered ahead of lpc-ctrl module, LPC
> SNOOP block will be enabled without heart beating of LCLK until
> lpc-ctrl enables the LCLK. This issue causes improper handling on
> host interrupts when the host sends interrupt in that time frame.
> Then kernel eventually forcibly disables the interrupt with
> dumping stack and printing a 'nobody cared this irq' message out.
>
> To prevent this issue, all LPC sub-nodes should enable LCLK
> individually so this patch adds clock control logic into the LPC
> SNOOP driver.

Jae, John; with this backported do we need to also provide a
corresponding device tree change for the stable tree, otherwise this
driver will no longer probe?

>
> Fixes: 3772e5da4454 ("drivers/misc: Aspeed LPC snoop output using misc chardev")
> Signed-off-by: Jae Hyun Yoo <jae.hyun.yoo@intel.com>
> Signed-off-by: Vernon Mauery <vernon.mauery@linux.intel.com>
> Signed-off-by: John Wang <wangzhiqiang.bj@bytedance.com>
> Reviewed-by: Joel Stanley <joel@jms.id.au>
> Link: https://lore.kernel.org/r/20201208091748.1920-1-wangzhiqiang.bj@bytedance.com
> Signed-off-by: Joel Stanley <joel@jms.id.au>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/misc/aspeed-lpc-snoop.c | 30 +++++++++++++++++++++++++++---
>  1 file changed, 27 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/misc/aspeed-lpc-snoop.c b/drivers/misc/aspeed-lpc-snoop.c
> index c10be21a1663d..b4a776bf44bc5 100644
> --- a/drivers/misc/aspeed-lpc-snoop.c
> +++ b/drivers/misc/aspeed-lpc-snoop.c
> @@ -15,6 +15,7 @@
>   */
>
>  #include <linux/bitops.h>
> +#include <linux/clk.h>
>  #include <linux/interrupt.h>
>  #include <linux/fs.h>
>  #include <linux/kfifo.h>
> @@ -71,6 +72,7 @@ struct aspeed_lpc_snoop_channel {
>  struct aspeed_lpc_snoop {
>         struct regmap           *regmap;
>         int                     irq;
> +       struct clk              *clk;
>         struct aspeed_lpc_snoop_channel chan[NUM_SNOOP_CHANNELS];
>  };
>
> @@ -286,22 +288,42 @@ static int aspeed_lpc_snoop_probe(struct platform_device *pdev)
>                 return -ENODEV;
>         }
>
> +       lpc_snoop->clk = devm_clk_get(dev, NULL);
> +       if (IS_ERR(lpc_snoop->clk)) {
> +               rc = PTR_ERR(lpc_snoop->clk);
> +               if (rc != -EPROBE_DEFER)
> +                       dev_err(dev, "couldn't get clock\n");
> +               return rc;
> +       }
> +       rc = clk_prepare_enable(lpc_snoop->clk);
> +       if (rc) {
> +               dev_err(dev, "couldn't enable clock\n");
> +               return rc;
> +       }
> +
>         rc = aspeed_lpc_snoop_config_irq(lpc_snoop, pdev);
>         if (rc)
> -               return rc;
> +               goto err;
>
>         rc = aspeed_lpc_enable_snoop(lpc_snoop, dev, 0, port);
>         if (rc)
> -               return rc;
> +               goto err;
>
>         /* Configuration of 2nd snoop channel port is optional */
>         if (of_property_read_u32_index(dev->of_node, "snoop-ports",
>                                        1, &port) == 0) {
>                 rc = aspeed_lpc_enable_snoop(lpc_snoop, dev, 1, port);
> -               if (rc)
> +               if (rc) {
>                         aspeed_lpc_disable_snoop(lpc_snoop, 0);
> +                       goto err;
> +               }
>         }
>
> +       return 0;
> +
> +err:
> +       clk_disable_unprepare(lpc_snoop->clk);
> +
>         return rc;
>  }
>
> @@ -313,6 +335,8 @@ static int aspeed_lpc_snoop_remove(struct platform_device *pdev)
>         aspeed_lpc_disable_snoop(lpc_snoop, 0);
>         aspeed_lpc_disable_snoop(lpc_snoop, 1);
>
> +       clk_disable_unprepare(lpc_snoop->clk);
> +
>         return 0;
>  }
>
> --
> 2.27.0
>
>
>
