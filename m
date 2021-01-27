Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53F1F306265
	for <lists+stable@lfdr.de>; Wed, 27 Jan 2021 18:45:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236030AbhA0Roh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jan 2021 12:44:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344112AbhA0RoY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jan 2021 12:44:24 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95DECC061574
        for <stable@vger.kernel.org>; Wed, 27 Jan 2021 09:43:43 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id f63so1641352pfa.13
        for <stable@vger.kernel.org>; Wed, 27 Jan 2021 09:43:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7sj7pim5IetR456CHcvRdOi+mjzmrDoe/hWhqa9Dot0=;
        b=nZn951upXHINIYPKAhqqnA0gSx9fm6BFVM/jP6hftSq00DD9x0fQ79puVIjzJIf+Wy
         iz9lW1hiLD0uRu0nh13kS4yHg7O3hEcaW0s59nyCqYBxc053a/nqV04OX2KJSn7J44g+
         V8moEFcNU3aSxiW1iWkOW/VanCas20nn/jHn9FJLLkkkc2maImUnd6Ldl7xHRe4sU/lS
         GjaY2uNfKEAvsh2J9AP/NRQp/iqK17FHew7+NCrz1GulAxqmMrqdpVNtJk6QyHIP20U6
         NiRec482FiU3hQ8fIjjs06E1pqCY2G3DBMZqGbJBGe6TmcSLPnjcz+EIwl7eQWVhT1ll
         84cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7sj7pim5IetR456CHcvRdOi+mjzmrDoe/hWhqa9Dot0=;
        b=kv8wehPRbil0RoE2xX1JedYaUAXNTogGTsxsrpSirIB/dS+sGovoi8n6C3Gyf+iceS
         KDOVj3NgJmohsRPrEUET6nr0xnTpyFni0DRj0SCX64preK6HFHDNTblugbzpMuEM4bXi
         u3QR9GYJk5BvePh66pDRxFeiW+5r8tY3bnRZxASbQ4sGJG/46wcxDps0PTbmWkX3CPMT
         D5c7Ou0FJr2RdEOmP0aHY0hqwNGlarKVHADkpBpUr0KaACaRz75nnBouL7oY8eQeh5cu
         6eRQJ1ITTBUnP6CmOWyBpXTF9km8nnG13RwwZjSZaJhvrbMxf4HtG4ii0IXbECGQmzc0
         QHZQ==
X-Gm-Message-State: AOAM530is5SaZrZMQkh9Hqy+Q8pDSUqpoUirj1hiii7zSvhukoh94S5L
        uDTXF2SUUybhU14JVQ3VwOM7oA==
X-Google-Smtp-Source: ABdhPJwjvSKmNhCa/kWyqmBXH7mVKkYXDuapfT2VYBLLHkHVh7PWO3Yk6lwHCS5IEBayb3JboBIycw==
X-Received: by 2002:a05:6a00:2286:b029:1ae:6c7f:31ce with SMTP id f6-20020a056a002286b02901ae6c7f31cemr11645761pfe.6.1611769423153;
        Wed, 27 Jan 2021 09:43:43 -0800 (PST)
Received: from xps15 (S0106889e681aac74.cg.shawcable.net. [68.147.0.187])
        by smtp.gmail.com with ESMTPSA id 6sm2918057pfz.34.2021.01.27.09.43.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 09:43:42 -0800 (PST)
Date:   Wed, 27 Jan 2021 10:43:40 -0700
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
To:     Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, coresight@lists.linaro.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Leo Yan <leo.yan@linaro.org>,
        Mike Leach <mike.leach@linaro.org>
Subject: Re: [PATCH v2] coresight: etm4x: Handle accesses to TRCSTALLCTLR
Message-ID: <20210127174340.GA1162729@xps15>
References: <20210126145614.3607093-1-suzuki.poulose@arm.com>
 <20210127120032.3611851-1-suzuki.poulose@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210127120032.3611851-1-suzuki.poulose@arm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Good day,

On Wed, Jan 27, 2021 at 12:00:32PM +0000, Suzuki K Poulose wrote:
> TRCSTALLCTLR register is only implemented if
> 
>    TRCIDR3.STALLCTL == 0b1
> 
> Make sure the driver touches the register only it is implemented.
> 
> Cc: stable@vger.kernel.org
> Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
> Cc: Leo Yan <leo.yan@linaro.org>
> Cc: Mike Leach <mike.leach@linaro.org>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
> Changes since v1:
>   - No change to the patch, fixed the stable email address and
>     added usual reviewers.
> ---
>  drivers/hwtracing/coresight/coresight-etm4x-core.c  | 9 ++++++---
>  drivers/hwtracing/coresight/coresight-etm4x-sysfs.c | 3 +++
>  2 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/hwtracing/coresight/coresight-etm4x-core.c b/drivers/hwtracing/coresight/coresight-etm4x-core.c
> index b40e3c2bf818..814b49dae0c7 100644
> --- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
> +++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
> @@ -367,7 +367,8 @@ static int etm4_enable_hw(struct etmv4_drvdata *drvdata)
>  	etm4x_relaxed_write32(csa, 0x0, TRCAUXCTLR);
>  	etm4x_relaxed_write32(csa, config->eventctrl0, TRCEVENTCTL0R);
>  	etm4x_relaxed_write32(csa, config->eventctrl1, TRCEVENTCTL1R);
> -	etm4x_relaxed_write32(csa, config->stall_ctrl, TRCSTALLCTLR);
> +	if (drvdata->stallctl)
> +		etm4x_relaxed_write32(csa, config->stall_ctrl, TRCSTALLCTLR);
>  	etm4x_relaxed_write32(csa, config->ts_ctrl, TRCTSCTLR);
>  	etm4x_relaxed_write32(csa, config->syncfreq, TRCSYNCPR);
>  	etm4x_relaxed_write32(csa, config->ccctlr, TRCCCCTLR);
> @@ -1545,7 +1546,8 @@ static int etm4_cpu_save(struct etmv4_drvdata *drvdata)
>  	state->trcauxctlr = etm4x_read32(csa, TRCAUXCTLR);
>  	state->trceventctl0r = etm4x_read32(csa, TRCEVENTCTL0R);
>  	state->trceventctl1r = etm4x_read32(csa, TRCEVENTCTL1R);
> -	state->trcstallctlr = etm4x_read32(csa, TRCSTALLCTLR);
> +	if (drvdata->stallctl)
> +		state->trcstallctlr = etm4x_read32(csa, TRCSTALLCTLR);
>  	state->trctsctlr = etm4x_read32(csa, TRCTSCTLR);
>  	state->trcsyncpr = etm4x_read32(csa, TRCSYNCPR);
>  	state->trcccctlr = etm4x_read32(csa, TRCCCCTLR);
> @@ -1657,7 +1659,8 @@ static void etm4_cpu_restore(struct etmv4_drvdata *drvdata)
>  	etm4x_relaxed_write32(csa, state->trcauxctlr, TRCAUXCTLR);
>  	etm4x_relaxed_write32(csa, state->trceventctl0r, TRCEVENTCTL0R);
>  	etm4x_relaxed_write32(csa, state->trceventctl1r, TRCEVENTCTL1R);
> -	etm4x_relaxed_write32(csa, state->trcstallctlr, TRCSTALLCTLR);
> +	if (drvdata->stallctl)
> +		etm4x_relaxed_write32(csa, state->trcstallctlr, TRCSTALLCTLR);
>  	etm4x_relaxed_write32(csa, state->trctsctlr, TRCTSCTLR);
>  	etm4x_relaxed_write32(csa, state->trcsyncpr, TRCSYNCPR);
>  	etm4x_relaxed_write32(csa, state->trcccctlr, TRCCCCTLR);
> diff --git a/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c b/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c
> index 1c490bcef3ad..cd9249fbf913 100644
> --- a/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c
> +++ b/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c
> @@ -296,6 +296,9 @@ static ssize_t mode_store(struct device *dev,
>  	if (kstrtoul(buf, 16, &val))
>  		return -EINVAL;
>  
> +	if ((val & ETM_MODE_ISTALL_EN) && !drvdata->stallctl)
> +		return -EINVAL;
> +

We have two choices here:

1) Follow what is already done in this function for implementation define
options like ETM_MODE_BB, ETMv4_MODE_CTXID, ETM_MODE_RETURNSTACK and others.  In
that case we would have:

        /* bit[8], Instruction stall bit */
        if ((config->mode & ETM_MODE_ISTALL_EN) && drvdata->stallctl == true))
                config->stall_ctrl |= BIT(8);
        else    
                config->stall_ctrl &= ~BIT(8); 

2) Return -EINVAL when something is not supported, like you have above.  In that
case we'd have to enact the same behavior for all the options, which has the
potential of breaking user space.

I think option 1 is best.

Thanks,
Mathieu

>  	spin_lock(&drvdata->spinlock);
>  	config->mode = val & ETMv4_MODE_ALL;
>  
> -- 
> 2.24.1
> 
