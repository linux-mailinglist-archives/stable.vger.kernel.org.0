Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A726510D6FB
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 15:28:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbfK2O2g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Nov 2019 09:28:36 -0500
Received: from foss.arm.com ([217.140.110.172]:48486 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726808AbfK2O2g (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 29 Nov 2019 09:28:36 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BFDB71FB;
        Fri, 29 Nov 2019 06:28:35 -0800 (PST)
Received: from [10.1.194.43] (e112269-lin.cambridge.arm.com [10.1.194.43])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E03153F52E;
        Fri, 29 Nov 2019 06:28:34 -0800 (PST)
Subject: Re: [PATCH 4/8] drm/panfrost: Fix a race in
 panfrost_gem_free_object()
To:     Boris Brezillon <boris.brezillon@collabora.com>,
        Rob Herring <robh+dt@kernel.org>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>
Cc:     stable@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <20191129135908.2439529-1-boris.brezillon@collabora.com>
 <20191129135908.2439529-5-boris.brezillon@collabora.com>
From:   Steven Price <steven.price@arm.com>
Message-ID: <a30a18c7-e9de-a90d-97b5-f8f386b7f35d@arm.com>
Date:   Fri, 29 Nov 2019 14:28:33 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191129135908.2439529-5-boris.brezillon@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 29/11/2019 13:59, Boris Brezillon wrote:
> panfrost_gem_shrinker_scan() might purge a BO (release the sgt and
> kill the GPU mapping) that's being freed by panfrost_gem_free_object()
> if we don't remove the BO from the shrinker list at the beginning of
> panfrost_gem_free_object().
> 
> Fixes: 013b65101315 ("drm/panfrost: Add madvise and shrinker support")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>

Reviewed-by: Steven Price <steven.price@arm.com>

> ---
>  drivers/gpu/drm/panfrost/panfrost_gem.c | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/gpu/drm/panfrost/panfrost_gem.c b/drivers/gpu/drm/panfrost/panfrost_gem.c
> index acb07fe06580..daf4c55a2863 100644
> --- a/drivers/gpu/drm/panfrost/panfrost_gem.c
> +++ b/drivers/gpu/drm/panfrost/panfrost_gem.c
> @@ -19,6 +19,16 @@ static void panfrost_gem_free_object(struct drm_gem_object *obj)
>  	struct panfrost_gem_object *bo = to_panfrost_bo(obj);
>  	struct panfrost_device *pfdev = obj->dev->dev_private;
>  
> +	/*
> +	 * Make sure the BO is no longer inserted in the shrinker list before
> +	 * taking care of the destruction itself. If we don't do that we have a
> +	 * race condition between this function and what's done in
> +	 * panfrost_gem_shrinker_scan().
> +	 */
> +	mutex_lock(&pfdev->shrinker_lock);
> +	list_del_init(&bo->base.madv_list);
> +	mutex_unlock(&pfdev->shrinker_lock);
> +
>  	if (bo->sgts) {
>  		int i;
>  		int n_sgt = bo->base.base.size / SZ_2M;
> @@ -33,11 +43,6 @@ static void panfrost_gem_free_object(struct drm_gem_object *obj)
>  		kfree(bo->sgts);
>  	}
>  
> -	mutex_lock(&pfdev->shrinker_lock);
> -	if (!list_empty(&bo->base.madv_list))
> -		list_del(&bo->base.madv_list);
> -	mutex_unlock(&pfdev->shrinker_lock);
> -
>  	drm_gem_shmem_free_object(obj);
>  }
>  
> 

