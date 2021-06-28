Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC90F3B6B24
	for <lists+stable@lfdr.de>; Tue, 29 Jun 2021 01:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236057AbhF1XFp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 19:05:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235955AbhF1XFn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Jun 2021 19:05:43 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E341C061760
        for <stable@vger.kernel.org>; Mon, 28 Jun 2021 16:03:16 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id q192so15517664pfc.7
        for <stable@vger.kernel.org>; Mon, 28 Jun 2021 16:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iLspJSghrCkbgf8p7iG1LAo/y9Hs2YHuqribtBfJaGE=;
        b=ViDEpfftwWlYN3gTHH0p/vrOoCKPjCh2uMlJgwGc42KUr2xyrR0qGXNXanAly84UA8
         RRT3mciFZ53F1EOTv5p3gXOlIM2ZIyxEftY2OOR4NAOg9PcOq1EyajSTeu5jlv0QvOph
         ZpkP1DA79sExwQ1QadYqNdTmXEw1BP0L49BdY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iLspJSghrCkbgf8p7iG1LAo/y9Hs2YHuqribtBfJaGE=;
        b=FspRFovRrVLXTAmvLLyw4Z25Id0VgDtHEy06xauf8yJWq2R48UG7CkkP1XJPhpd4g2
         b+042rg3GVn1BAGwIuhyN2Suhi0RmT0VzdMMwklDVnWo78Use+RKCB8oWFiWqBblbZVY
         kkSgBut216R9K9HeD4wIOzqNWw+fiPttjSnYszA2J6qEL5RYqEYV8LlBn3tFzX1itzH/
         gtrzjajz6eT6wfuoRf/czdyyUrTYFjVQX0pduu/jn7vXGz3Fjy8B3szSS+7xesmo3kza
         pL0DajpfeookDGQ4Ccu5VpnX86C991ExYgxtDJ6+NkogeKKk00xhoSV9tyiUjanCrZQH
         E9sQ==
X-Gm-Message-State: AOAM53094vSikQLUl6Yi3guuol8tffSlrqMlE0uyGXZ1HRkeh8PbnmQ7
        TTfKmVgTQxyzFU9WIIW5xMOWVw==
X-Google-Smtp-Source: ABdhPJx5OGI1L08PP7HKbtuiQCKk789X+QCA2dz5n1pYEwEzDMY8DH63/5PpoeChkwlYufNW5MxhGg==
X-Received: by 2002:a65:44ca:: with SMTP id g10mr13471176pgs.89.1624921396164;
        Mon, 28 Jun 2021 16:03:16 -0700 (PDT)
Received: from localhost ([2620:15c:202:201:df70:d2d8:b384:35cf])
        by smtp.gmail.com with UTF8SMTPSA id i20sm15264361pfo.130.2021.06.28.16.03.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Jun 2021 16:03:15 -0700 (PDT)
Date:   Mon, 28 Jun 2021 16:03:14 -0700
From:   Matthias Kaehlcke <mka@chromium.org>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     bjorn.andersson@linaro.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, thara.gopinath@linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] soc: qcom: aoss: Fix the out of bound usage of
 cooling_devs
Message-ID: <YNpVMvhEfrz9EqyO@google.com>
References: <20210628172741.16894-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210628172741.16894-1-manivannan.sadhasivam@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 28, 2021 at 10:57:41PM +0530, Manivannan Sadhasivam wrote:
> In "qmp_cooling_devices_register", the count value is initially
> QMP_NUM_COOLING_RESOURCES, which is 2. Based on the initial count value,
> the memory for cooling_devs is allocated. Then while calling the
> "qmp_cooling_device_add" function, count value is post-incremented for
> each child node.
> 
> This makes the out of bound access to the cooling_dev array. Fix it by
> resetting the count value to zero before adding cooling devices.
> 
> While at it, let's also free the memory allocated to cooling_dev if no
> cooling device is found in DT and during unroll phase.
> 
> Cc: stable@vger.kernel.org # 5.4
> Fixes: 05589b30b21a ("soc: qcom: Extend AOSS QMP driver to support resources that are used to wake up the SoC.")
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> ---
> 
> Bjorn: I've just compile tested this patch.
> 
>  drivers/soc/qcom/qcom_aoss.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/soc/qcom/qcom_aoss.c b/drivers/soc/qcom/qcom_aoss.c
> index 934fcc4d2b05..98c665411768 100644
> --- a/drivers/soc/qcom/qcom_aoss.c
> +++ b/drivers/soc/qcom/qcom_aoss.c
> @@ -488,6 +488,7 @@ static int qmp_cooling_devices_register(struct qmp *qmp)
>  	if (!qmp->cooling_devs)
>  		return -ENOMEM;
>  
> +	count = 0;
>  	for_each_available_child_of_node(np, child) {
>  		if (!of_find_property(child, "#cooling-cells", NULL))
>  			continue;
> @@ -497,12 +498,16 @@ static int qmp_cooling_devices_register(struct qmp *qmp)
>  			goto unroll;
>  	}
>  
> +	if (!count)
> +		devm_kfree(qmp->dev, qmp->cooling_devs);
> +
>  	return 0;
>  
>  unroll:
>  	while (--count >= 0)
>  		thermal_cooling_device_unregister
>  			(qmp->cooling_devs[count].cdev);
> +	devm_kfree(qmp->dev, qmp->cooling_devs);
>  
>  	return ret;
>  }


A few more previous lines of code for context:

  int count = QMP_NUM_COOLING_RESOURCES;

  qmp->cooling_devs = devm_kcalloc(qmp->dev, count,
                                   sizeof(*qmp->cooling_devs),
                                   GFP_KERNEL);

I would suggest to initialize 'count' to 0 from the start and pass
QMP_NUM_COOLING_RESOURCES to devm_kcalloc() rather than 'count',
instead of resetting 'count' afterwards.
