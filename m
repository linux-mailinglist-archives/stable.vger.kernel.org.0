Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C2E726A924
	for <lists+stable@lfdr.de>; Tue, 15 Sep 2020 17:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727521AbgIOPzL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 11:55:11 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:13115 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727470AbgIOPzA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 11:55:00 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1600185299; h=In-Reply-To: Content-Type: MIME-Version:
 References: Message-ID: Subject: Cc: To: From: Date: Sender;
 bh=QpUGNIr/jF6kgQq0YrPqmOxm1WxZPk5WINz0ZO/1jn4=; b=C9WvsByneORQ0XcwZjHU7hHeGdyUky1Qp1S8gdA0GIlJz9gV30RaqXFfJYxDWpn2KzZRjvBH
 7RNJxyhyXRQsbP9380wT/IOjMvdhS7912GrGfHRmkzoR09w8YcTM8eiD76DVUzbFGAV57eFT
 N+BefuIdB0qkRAOJCmUzTn08BcY=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 5f60e3c49bdf68cc030dd4f2 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 15 Sep 2020 15:54:44
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D1BABC433FE; Tue, 15 Sep 2020 15:54:43 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from jcrouse1-lnx.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: jcrouse)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C6C01C433F0;
        Tue, 15 Sep 2020 15:54:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C6C01C433F0
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=jcrouse@codeaurora.org
Date:   Tue, 15 Sep 2020 09:54:39 -0600
From:   Jordan Crouse <jcrouse@codeaurora.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Rob Clark <robdclark@chromium.org>
Subject: Re: [PATCH 5.4 105/132] drm/msm: Split the a5xx preemption record
Message-ID: <20200915155439.GA22371@jcrouse1-lnx.qualcomm.com>
References: <20200915140644.037604909@linuxfoundation.org>
 <20200915140649.400517956@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200915140649.400517956@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 15, 2020 at 04:13:27PM +0200, Greg Kroah-Hartman wrote:
> From: Jordan Crouse <jcrouse@codeaurora.org>
> 
> commit 34221545d2069dc947131f42392fd4cebabe1b39 upstream.
> 
> The main a5xx preemption record can be marked as privileged to
> protect it from user access but the counters storage needs to be
> remain unprivileged. Split the buffers and mark the critical memory
> as privileged.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Jordan Crouse <jcrouse@codeaurora.org>
> Signed-off-by: Rob Clark <robdclark@chromium.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Hi. The MSM_BO_MAP_PRIV feature was added after 5.4. 

Since we are pulling in 7b3f3948c8b7 ("drm/msm: Disable preemption on all
5xx targets)" preemption will be disabled in the 5.4 stable tree which is enough
to cover the security concern that this patch helped address.

This patch can be dropped.

Jordan

> ---
>  drivers/gpu/drm/msm/adreno/a5xx_gpu.h     |    1 +
>  drivers/gpu/drm/msm/adreno/a5xx_preempt.c |   25 ++++++++++++++++++++-----
>  2 files changed, 21 insertions(+), 5 deletions(-)
> 
> --- a/drivers/gpu/drm/msm/adreno/a5xx_gpu.h
> +++ b/drivers/gpu/drm/msm/adreno/a5xx_gpu.h
> @@ -31,6 +31,7 @@ struct a5xx_gpu {
>  	struct msm_ringbuffer *next_ring;
>  
>  	struct drm_gem_object *preempt_bo[MSM_GPU_MAX_RINGS];
> +	struct drm_gem_object *preempt_counters_bo[MSM_GPU_MAX_RINGS];
>  	struct a5xx_preempt_record *preempt[MSM_GPU_MAX_RINGS];
>  	uint64_t preempt_iova[MSM_GPU_MAX_RINGS];
>  
> --- a/drivers/gpu/drm/msm/adreno/a5xx_preempt.c
> +++ b/drivers/gpu/drm/msm/adreno/a5xx_preempt.c
> @@ -226,19 +226,31 @@ static int preempt_init_ring(struct a5xx
>  	struct adreno_gpu *adreno_gpu = &a5xx_gpu->base;
>  	struct msm_gpu *gpu = &adreno_gpu->base;
>  	struct a5xx_preempt_record *ptr;
> -	struct drm_gem_object *bo = NULL;
> -	u64 iova = 0;
> +	void *counters;
> +	struct drm_gem_object *bo = NULL, *counters_bo = NULL;
> +	u64 iova = 0, counters_iova = 0;
>  
>  	ptr = msm_gem_kernel_new(gpu->dev,
>  		A5XX_PREEMPT_RECORD_SIZE + A5XX_PREEMPT_COUNTER_SIZE,
> -		MSM_BO_UNCACHED, gpu->aspace, &bo, &iova);
> +		MSM_BO_UNCACHED | MSM_BO_MAP_PRIV, gpu->aspace, &bo, &iova);
>  
>  	if (IS_ERR(ptr))
>  		return PTR_ERR(ptr);
>  
> +	/* The buffer to store counters needs to be unprivileged */
> +	counters = msm_gem_kernel_new(gpu->dev,
> +		A5XX_PREEMPT_COUNTER_SIZE,
> +		MSM_BO_UNCACHED, gpu->aspace, &counters_bo, &counters_iova);
> +	if (IS_ERR(counters)) {
> +		msm_gem_kernel_put(bo, gpu->aspace, true);
> +		return PTR_ERR(counters);
> +	}
> +
>  	msm_gem_object_set_name(bo, "preempt");
> +	msm_gem_object_set_name(counters_bo, "preempt_counters");
>  
>  	a5xx_gpu->preempt_bo[ring->id] = bo;
> +	a5xx_gpu->preempt_counters_bo[ring->id] = counters_bo;
>  	a5xx_gpu->preempt_iova[ring->id] = iova;
>  	a5xx_gpu->preempt[ring->id] = ptr;
>  
> @@ -249,7 +261,7 @@ static int preempt_init_ring(struct a5xx
>  	ptr->data = 0;
>  	ptr->cntl = MSM_GPU_RB_CNTL_DEFAULT;
>  	ptr->rptr_addr = rbmemptr(ring, rptr);
> -	ptr->counter = iova + A5XX_PREEMPT_RECORD_SIZE;
> +	ptr->counter = counters_iova;
>  
>  	return 0;
>  }
> @@ -260,8 +272,11 @@ void a5xx_preempt_fini(struct msm_gpu *g
>  	struct a5xx_gpu *a5xx_gpu = to_a5xx_gpu(adreno_gpu);
>  	int i;
>  
> -	for (i = 0; i < gpu->nr_rings; i++)
> +	for (i = 0; i < gpu->nr_rings; i++) {
>  		msm_gem_kernel_put(a5xx_gpu->preempt_bo[i], gpu->aspace, true);
> +		msm_gem_kernel_put(a5xx_gpu->preempt_counters_bo[i],
> +			gpu->aspace, true);
> +	}
>  }
>  
>  void a5xx_preempt_init(struct msm_gpu *gpu)
> 
> 

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
