Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03FF026B1A8
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 00:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727302AbgIOWeU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 18:34:20 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:34297 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726985AbgIOQQA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Sep 2020 12:16:00 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1600186506; h=In-Reply-To: Content-Type: MIME-Version:
 References: Message-ID: Subject: Cc: To: From: Date: Sender;
 bh=LPW/rirtvKoFkoPK7ylNUNujADEHSjJW3Q4PI3ebL6k=; b=SOPLC5k5ZrZKfjMnRCu405B3RIp7k9tE6ECyv55UDo12ggyu44x6nittz1+nilSCzE0JNWcI
 GZicqBDkzdUwz7RcN6pNBj0HvAyEQLWzhs7jkol5iGFSxmHbJO1bY4EFqCAT83Ox8KXkoDXl
 XtLN+kEI1KC+/voo/kFRV/7rbTU=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 5f60e5efcc683673f9d77609 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 15 Sep 2020 16:03:59
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 2C67CC433F0; Tue, 15 Sep 2020 16:03:59 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from jcrouse1-lnx.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: jcrouse)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A934FC433C8;
        Tue, 15 Sep 2020 16:03:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A934FC433C8
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=jcrouse@codeaurora.org
Date:   Tue, 15 Sep 2020 10:03:54 -0600
From:   Jordan Crouse <jcrouse@codeaurora.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.8 177/177] drm/msm: Enable expanded apriv support for
 a650
Message-ID: <20200915160354.GC22371@jcrouse1-lnx.qualcomm.com>
References: <20200915140653.610388773@linuxfoundation.org>
 <20200915140702.187099911@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200915140702.187099911@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 15, 2020 at 04:14:08PM +0200, Greg Kroah-Hartman wrote:
> From: Jordan Crouse <jcrouse@codeaurora.org>
> 
> [ Upstream commit 604234f33658cdd72f686be405a99646b397d0b3 ]
> 
> a650 supports expanded apriv support that allows us to map critical buffers
> (ringbuffer and memstore) as as privileged to protect them from corruption.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Jordan Crouse <jcrouse@codeaurora.org>
> Signed-off-by: Rob Clark <robdclark@chromium.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Hi. A bug was reported in this patch with a fix just posted to the list [1].
Since the RPTR shadow is being disabled universally by f6828e0c4045 ("drm/msm:
Disable the RPTR shadow") that will address the security concern and we won't
need the extra protection from this patch. I suggest that you drop it for the
stable trees and we can merge the fix into 5.9 to re-enable APRIV for newer
kernels.

[1] https://lists.freedesktop.org/archives/freedreno/2020-September/008376.html

Jordan
> ---
>  drivers/gpu/drm/msm/adreno/a6xx_gpu.c |  6 +++++-
>  drivers/gpu/drm/msm/msm_gpu.c         |  2 +-
>  drivers/gpu/drm/msm/msm_gpu.h         | 11 +++++++++++
>  drivers/gpu/drm/msm/msm_ringbuffer.c  |  4 ++--
>  4 files changed, 19 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
> index b7dc350d96fc8..ee99cdeb449ca 100644
> --- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
> +++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
> @@ -541,7 +541,8 @@ static int a6xx_hw_init(struct msm_gpu *gpu)
>  			A6XX_PROTECT_RDONLY(0x980, 0x4));
>  	gpu_write(gpu, REG_A6XX_CP_PROTECT(25), A6XX_PROTECT_RW(0xa630, 0x0));
>  
> -	if (adreno_is_a650(adreno_gpu)) {
> +	/* Enable expanded apriv for targets that support it */
> +	if (gpu->hw_apriv) {
>  		gpu_write(gpu, REG_A6XX_CP_APRIV_CNTL,
>  			(1 << 6) | (1 << 5) | (1 << 3) | (1 << 2) | (1 << 1));
>  	}
> @@ -926,6 +927,9 @@ struct msm_gpu *a6xx_gpu_init(struct drm_device *dev)
>  	adreno_gpu->registers = NULL;
>  	adreno_gpu->reg_offsets = a6xx_register_offsets;
>  
> +	if (adreno_is_a650(adreno_gpu))
> +		adreno_gpu->base.hw_apriv = true;
> +
>  	ret = adreno_gpu_init(dev, pdev, adreno_gpu, &funcs, 1);
>  	if (ret) {
>  		a6xx_destroy(&(a6xx_gpu->base.base));
> diff --git a/drivers/gpu/drm/msm/msm_gpu.c b/drivers/gpu/drm/msm/msm_gpu.c
> index a22d306223068..9b839d6f4692a 100644
> --- a/drivers/gpu/drm/msm/msm_gpu.c
> +++ b/drivers/gpu/drm/msm/msm_gpu.c
> @@ -905,7 +905,7 @@ int msm_gpu_init(struct drm_device *drm, struct platform_device *pdev,
>  
>  	memptrs = msm_gem_kernel_new(drm,
>  		sizeof(struct msm_rbmemptrs) * nr_rings,
> -		MSM_BO_UNCACHED, gpu->aspace, &gpu->memptrs_bo,
> +		check_apriv(gpu, MSM_BO_UNCACHED), gpu->aspace, &gpu->memptrs_bo,
>  		&memptrs_iova);
>  
>  	if (IS_ERR(memptrs)) {
> diff --git a/drivers/gpu/drm/msm/msm_gpu.h b/drivers/gpu/drm/msm/msm_gpu.h
> index 429cb40f79315..f22e0f67ba40e 100644
> --- a/drivers/gpu/drm/msm/msm_gpu.h
> +++ b/drivers/gpu/drm/msm/msm_gpu.h
> @@ -14,6 +14,7 @@
>  #include "msm_drv.h"
>  #include "msm_fence.h"
>  #include "msm_ringbuffer.h"
> +#include "msm_gem.h"
>  
>  struct msm_gem_submit;
>  struct msm_gpu_perfcntr;
> @@ -138,6 +139,8 @@ struct msm_gpu {
>  	} devfreq;
>  
>  	struct msm_gpu_state *crashstate;
> +	/* True if the hardware supports expanded apriv (a650 and newer) */
> +	bool hw_apriv;
>  };
>  
>  /* It turns out that all targets use the same ringbuffer size */
> @@ -326,4 +329,12 @@ static inline void msm_gpu_crashstate_put(struct msm_gpu *gpu)
>  	mutex_unlock(&gpu->dev->struct_mutex);
>  }
>  
> +/*
> + * Simple macro to semi-cleanly add the MAP_PRIV flag for targets that can
> + * support expanded privileges
> + */
> +#define check_apriv(gpu, flags) \
> +	(((gpu)->hw_apriv ? MSM_BO_MAP_PRIV : 0) | (flags))
> +
> +
>  #endif /* __MSM_GPU_H__ */
> diff --git a/drivers/gpu/drm/msm/msm_ringbuffer.c b/drivers/gpu/drm/msm/msm_ringbuffer.c
> index 39ecb5a18431e..935bf9b1d9418 100644
> --- a/drivers/gpu/drm/msm/msm_ringbuffer.c
> +++ b/drivers/gpu/drm/msm/msm_ringbuffer.c
> @@ -27,8 +27,8 @@ struct msm_ringbuffer *msm_ringbuffer_new(struct msm_gpu *gpu, int id,
>  	ring->id = id;
>  
>  	ring->start = msm_gem_kernel_new(gpu->dev, MSM_GPU_RINGBUFFER_SZ,
> -		MSM_BO_WC | MSM_BO_GPU_READONLY, gpu->aspace, &ring->bo,
> -		&ring->iova);
> +		check_apriv(gpu, MSM_BO_WC | MSM_BO_GPU_READONLY),
> +		gpu->aspace, &ring->bo, &ring->iova);
>  
>  	if (IS_ERR(ring->start)) {
>  		ret = PTR_ERR(ring->start);
> -- 
> 2.25.1
> 
> 
> 

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
