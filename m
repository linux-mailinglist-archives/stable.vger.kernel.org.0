Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A13F10D6D2
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 15:19:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbfK2OTy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Nov 2019 09:19:54 -0500
Received: from foss.arm.com ([217.140.110.172]:48356 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726608AbfK2OTy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 29 Nov 2019 09:19:54 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C23EE1FB;
        Fri, 29 Nov 2019 06:19:51 -0800 (PST)
Received: from [10.1.194.43] (e112269-lin.cambridge.arm.com [10.1.194.43])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 027963F52E;
        Fri, 29 Nov 2019 06:19:50 -0800 (PST)
Subject: Re: [PATCH 1/8] drm/panfrost: Make panfrost_job_run() return an
 ERR_PTR() instead of NULL
To:     Boris Brezillon <boris.brezillon@collabora.com>,
        Rob Herring <robh+dt@kernel.org>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>
Cc:     stable@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <20191129135908.2439529-1-boris.brezillon@collabora.com>
 <20191129135908.2439529-2-boris.brezillon@collabora.com>
From:   Steven Price <steven.price@arm.com>
Message-ID: <7444054c-52b4-32d1-70c2-52bf9c5f2871@arm.com>
Date:   Fri, 29 Nov 2019 14:19:50 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191129135908.2439529-2-boris.brezillon@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 29/11/2019 13:59, Boris Brezillon wrote:
> If we don't do that, dma_fence_set_error() complains (called from
> drm_sched_main()).
> 
> Fixes: f3ba91228e8e ("drm/panfrost: Add initial panfrost driver")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>

This might be worth doing, but actually it's not Panfrost that is broken
it's the callers, see [1] and [2]. So I don't think we want the
Fixes/stable tag.

[1] https://patchwork.kernel.org/patch/11218399/
[2] https://patchwork.kernel.org/patch/11267073/

> ---
>  drivers/gpu/drm/panfrost/panfrost_job.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/panfrost/panfrost_job.c b/drivers/gpu/drm/panfrost/panfrost_job.c
> index 21f34d44aac2..cdd9448fbbdd 100644
> --- a/drivers/gpu/drm/panfrost/panfrost_job.c
> +++ b/drivers/gpu/drm/panfrost/panfrost_job.c
> @@ -328,13 +328,13 @@ static struct dma_fence *panfrost_job_run(struct drm_sched_job *sched_job)
>  	struct dma_fence *fence = NULL;
>  
>  	if (unlikely(job->base.s_fence->finished.error))
> -		return NULL;
> +		return ERR_PTR(job->base.s_fence->finished.error);
>  
>  	pfdev->jobs[slot] = job;
>  
>  	fence = panfrost_fence_create(pfdev, slot);
>  	if (IS_ERR(fence))
> -		return NULL;
> +		return ERR_PTR(-ENOMEM);

Why override the error from panfrost_fence_create? In this case we can just:

	return fence;

Steve

>  
>  	if (job->done_fence)
>  		dma_fence_put(job->done_fence);
> 

