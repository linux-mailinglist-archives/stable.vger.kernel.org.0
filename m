Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59FB717F0BB
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 07:47:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726258AbgCJGrt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 02:47:49 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:37141 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbgCJGrt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 02:47:49 -0400
Received: by mail-pj1-f66.google.com with SMTP id ca13so18454pjb.2
        for <stable@vger.kernel.org>; Mon, 09 Mar 2020 23:47:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zKuJhKBZTwaNZPYviw4IxeKyZ9kXX7xZk6ARfUj0zuI=;
        b=fkD2/PmqyrWJzrBfQTZt9YfRnKeGji1fQbovY1UdHBci2itxQetsFysECZr3tlld3F
         aO7xREQbkLG8SMmrZIT29N0W7d8R6bdCmIJdgfqHIvcEey6kwE3wKV1jbrZOhfb/sKxS
         g4MUIqDmcx7PdjZ55ZbWdC+q/vXAoSHE1crL+6sf9jIXCkBtg+HJ3wFbFTLsXZvi6WDc
         q4+pJzcqI4mC9Dzw9xNFdm16Y7HfeChoKGKrHUZK/9+wzZswS0wxN+htvNT3p4gl4XQW
         YhoC2hL7KbJP0VZPyJZcr2Ipdt+yoTGemli04pIPT6I4c4j4IUNiHGXxgsXc9vjtFt/b
         KNjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zKuJhKBZTwaNZPYviw4IxeKyZ9kXX7xZk6ARfUj0zuI=;
        b=L3Jk24EQHu8fN8ATGOJDk/dSAtSYhhrgJxfsz+ZRMklhwwpcEVjZRLMrhk7QVm40z2
         WqcPDftMl72GmtqsCAyU4t9yg4pPqE1b7Cm9iUm6o8V5N2hQL2ceugNjOcXv55ZhHvru
         pIhJD2TDqAwKIdTun98fZ7x8/cUhP1bDWRrcDsj4X8+muz/esBLu4LuzXo6/1Mr3O1+P
         AVRNrzsaXdc1eIn/jXp1NSN3OT6JWTqqTMmFDX2pZMBGWt0Fx9hni+6vCZ4vaL1JkLx6
         bQr4cGxfJKTa0hQMIyPSo1kBUSoZo0rQieaDZxMkxEgiuSFFAG1cigRO0nkU4fMrFGIO
         /sdQ==
X-Gm-Message-State: ANhLgQ2h7nnpb2ouVcqNQexG0sdmFNUad8GFZLGEQUxZyidDbeYiI0TL
        CLVYJsf/A+Mv1HUrLYjMA7EcElhbSYI=
X-Google-Smtp-Source: ADFU+vtCMENV6Tx6Em84/AIq0y6qJi+EKWtJ2GIza/HK+lf5Sy6Se/p7m7vSmFW0TmScK35JcK9uaA==
X-Received: by 2002:a17:902:a611:: with SMTP id u17mr19097974plq.343.1583822868909;
        Mon, 09 Mar 2020 23:47:48 -0700 (PDT)
Received: from yoga (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id l21sm1417304pjt.7.2020.03.09.23.47.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 23:47:48 -0700 (PDT)
Date:   Mon, 9 Mar 2020 23:47:45 -0700
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     linux-gpio@vger.kernel.org, Brian Masney <masneyb@onstation.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] pinctrl: qcom: ssbi-gpio: Fix fwspec parsing bug
Message-ID: <20200310064745.GE264362@yoga>
References: <20200306141637.1434388-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200306141637.1434388-1-linus.walleij@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri 06 Mar 06:16 PST 2020, Linus Walleij wrote:

> We are parsing SSBI gpios as fourcell fwspecs but they are
> twocell. Probably a simple copy-and-paste bug.
> 
> Tested on the APQ8060 DragonBoard and after this ethernet
> and MMC card detection works again.
> 
> Cc: Brian Masney <masneyb@onstation.org>
> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

> Cc: stable@vger.kernel.org
> Fixes: ae436fe81053 ("pinctrl: ssbi-gpio: convert to hierarchical IRQ helpers in gpio core")
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
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
> -- 
> 2.24.1
> 
