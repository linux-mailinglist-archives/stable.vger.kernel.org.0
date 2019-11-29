Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E62810D6F2
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 15:24:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbfK2OYv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Nov 2019 09:24:51 -0500
Received: from foss.arm.com ([217.140.110.172]:48434 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726824AbfK2OYv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 29 Nov 2019 09:24:51 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8A0BD1FB;
        Fri, 29 Nov 2019 06:24:50 -0800 (PST)
Received: from [10.1.194.43] (e112269-lin.cambridge.arm.com [10.1.194.43])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BEF803F52E;
        Fri, 29 Nov 2019 06:24:49 -0800 (PST)
Subject: Re: [PATCH 2/8] drm/panfrost: Fix a race in panfrost_ioctl_madvise()
To:     Boris Brezillon <boris.brezillon@collabora.com>,
        Rob Herring <robh+dt@kernel.org>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>
Cc:     stable@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <20191129135908.2439529-1-boris.brezillon@collabora.com>
 <20191129135908.2439529-3-boris.brezillon@collabora.com>
From:   Steven Price <steven.price@arm.com>
Message-ID: <dd8a946c-5666-a7b8-f7bc-06647e0d0bbc@arm.com>
Date:   Fri, 29 Nov 2019 14:24:48 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191129135908.2439529-3-boris.brezillon@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 29/11/2019 13:59, Boris Brezillon wrote:
> If 2 threads change the MADVISE property of the same BO in parallel we
> might end up with an shmem->madv value that's inconsistent with the
> presence of the BO in the shrinker list.

I'm a bit worried from the point of view of user space sanity that you
observed this - but clearly the kernel should be robust!

> 
> The easiest solution to fix that is to protect the
> drm_gem_shmem_madvise() call with the shrinker lock.
> 
> Fixes: 013b65101315 ("drm/panfrost: Add madvise and shrinker support")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>

Reviewed-by: Steven Price <steven.price@arm.com>

> ---
>  drivers/gpu/drm/panfrost/panfrost_drv.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/gpu/drm/panfrost/panfrost_drv.c b/drivers/gpu/drm/panfrost/panfrost_drv.c
> index f21bc8a7ee3a..efc0a24d1f4c 100644
> --- a/drivers/gpu/drm/panfrost/panfrost_drv.c
> +++ b/drivers/gpu/drm/panfrost/panfrost_drv.c
> @@ -347,20 +347,19 @@ static int panfrost_ioctl_madvise(struct drm_device *dev, void *data,
>  		return -ENOENT;
>  	}
>  
> +	mutex_lock(&pfdev->shrinker_lock);
>  	args->retained = drm_gem_shmem_madvise(gem_obj, args->madv);
>  
>  	if (args->retained) {
>  		struct panfrost_gem_object *bo = to_panfrost_bo(gem_obj);
>  
> -		mutex_lock(&pfdev->shrinker_lock);
> -
>  		if (args->madv == PANFROST_MADV_DONTNEED)
> -			list_add_tail(&bo->base.madv_list, &pfdev->shrinker_list);
> +			list_add_tail(&bo->base.madv_list,
> +				      &pfdev->shrinker_list);
>  		else if (args->madv == PANFROST_MADV_WILLNEED)
>  			list_del_init(&bo->base.madv_list);
> -
> -		mutex_unlock(&pfdev->shrinker_lock);
>  	}
> +	mutex_unlock(&pfdev->shrinker_lock);
>  
>  	drm_gem_object_put_unlocked(gem_obj);
>  	return 0;
> 

