Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E537017F0C1
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 07:49:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726295AbgCJGtH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 02:49:07 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:32968 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbgCJGtH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 02:49:07 -0400
Received: by mail-pg1-f193.google.com with SMTP id m5so5897665pgg.0
        for <stable@vger.kernel.org>; Mon, 09 Mar 2020 23:49:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=n2Gsz1iOoHyb08ycor7XMtbacWuNzHazX81TA7myjng=;
        b=GGNqW+Bd4mS6mgUvZT3J5MYA7t/DgEUKLpsRvXfmWmInShvzLbXWjMBLnjPNbhVpGm
         UJP8fzXvzwNkvKMyb3BQrLDEkp4n823jcSbQ5LqV36jfN9dRNSxGFLVMzjWwf8uP3ZnJ
         KR2Em3v86m6s+2f8IJvdrPrn3lJ7zFjfptMm9OPgbcXTV0XS5dRoMKfQDaRkYy6OVuEb
         CJDhP1I87z5BzfeJ30+9GZqGNHXCzeQhTDc0ilBn/UH+EB0T/uLr3XbPrS7gXXNIft2U
         mHSH1eOAXkZgMdH8Fg3YyTwrV68dq9W8X6PReaFGrDgHwQP+hMefqtjpTSf/RHc7GFBL
         WNkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=n2Gsz1iOoHyb08ycor7XMtbacWuNzHazX81TA7myjng=;
        b=uRLIdlq1KNHud44A3QoXDXVQWz++oSExp7FcGXdwM8fMM/plDLd3K531r4gt6bnGp+
         8QgN74ZuAqe5SJW8ytbiZjuv02Tnn2TmFIwqzwCRmMN2DOu066XqGx/JBEtw/8nRJ0r6
         OiMCkicRTzyCILRTmHI33POIbo/RDZOwKwTV+SOLXe8cX5LEIw9MvZy/ZL6ZsxpOKKVR
         HSvU5GJip4v4n1EEORmN9ZdOzw5yf/YiXQjJ9DNTOYUIo8dWhLee3aQ1WWenqflBV0j9
         p5DJ8PRrgrowSc0HU+Nrxk9W5YuSbl6cYHMTWexgMIdD2XfopTLIPZCTeZqgviGb4vmT
         uj0w==
X-Gm-Message-State: ANhLgQ28VDxIRmIQugotO8zqab9K4MoibJI/uanyquJVOW4VYndUAThO
        2jXQGfhAHyUZZrAHZb4pSI+95a8fdCI=
X-Google-Smtp-Source: ADFU+vsluKRn1LnG5/W+4KuKkU6sU+toRpOqT58BRliNME0GE0OlsbsI0hqE3Gl11Z0KJ9Km/XFtXw==
X-Received: by 2002:a63:8c18:: with SMTP id m24mr20050564pgd.70.1583822946459;
        Mon, 09 Mar 2020 23:49:06 -0700 (PDT)
Received: from yoga (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id i2sm9817385pfr.151.2020.03.09.23.49.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 23:49:05 -0700 (PDT)
Date:   Mon, 9 Mar 2020 23:49:03 -0700
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     linux-gpio@vger.kernel.org, Brian Masney <masneyb@onstation.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] pinctrl: qcom: ssbi-gpio: Fix fwspec parsing bug
Message-ID: <20200310064903.GF264362@yoga>
References: <20200306143416.1476250-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200306143416.1476250-1-linus.walleij@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri 06 Mar 06:34 PST 2020, Linus Walleij wrote:

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
> ---
> ChangeLog v1->v2:
> - Renamed function pointer field to .populate_parent_alloc_arg
>   as it is named upstream.

Okay, let's try again then :)

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Regards,
Bjorn

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
> 
