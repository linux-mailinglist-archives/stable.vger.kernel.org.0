Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3189810EA38
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 13:50:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727354AbfLBMuv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 07:50:51 -0500
Received: from foss.arm.com ([217.140.110.172]:54056 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727362AbfLBMuv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Dec 2019 07:50:51 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 45F0A30E;
        Mon,  2 Dec 2019 04:50:50 -0800 (PST)
Received: from [10.1.196.37] (e121345-lin.cambridge.arm.com [10.1.196.37])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5C83A3F68E;
        Mon,  2 Dec 2019 04:50:49 -0800 (PST)
Subject: Re: [PATCH 8/8] drm/panfrost: Make sure the shrinker does not reclaim
 referenced BOs
To:     Boris Brezillon <boris.brezillon@collabora.com>,
        Rob Herring <robh+dt@kernel.org>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Steven Price <steven.price@arm.com>
Cc:     stable@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <20191129135908.2439529-1-boris.brezillon@collabora.com>
 <20191129135908.2439529-9-boris.brezillon@collabora.com>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <7258aca4-115d-d511-4c0a-fb3ba142f382@arm.com>
Date:   Mon, 2 Dec 2019 12:50:20 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191129135908.2439529-9-boris.brezillon@collabora.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 29/11/2019 1:59 pm, Boris Brezillon wrote:
> Userspace might tag a BO purgeable while it's still referenced by GPU
> jobs. We need to make sure the shrinker does not purge such BOs until
> all jobs referencing it are finished.

Nit: for extra robustness, perhaps it's worth using the refcount_t API 
rather than bare atomic_t?

Robin.

> Fixes: 013b65101315 ("drm/panfrost: Add madvise and shrinker support")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
> ---
>   drivers/gpu/drm/panfrost/panfrost_drv.c          | 1 +
>   drivers/gpu/drm/panfrost/panfrost_gem.h          | 6 ++++++
>   drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c | 2 ++
>   drivers/gpu/drm/panfrost/panfrost_job.c          | 7 ++++++-
>   4 files changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/panfrost/panfrost_drv.c b/drivers/gpu/drm/panfrost/panfrost_drv.c
> index b406b5243b40..297c0e7304d2 100644
> --- a/drivers/gpu/drm/panfrost/panfrost_drv.c
> +++ b/drivers/gpu/drm/panfrost/panfrost_drv.c
> @@ -166,6 +166,7 @@ panfrost_lookup_bos(struct drm_device *dev,
>   			break;
>   		}
>   
> +		atomic_inc(&bo->gpu_usecount);
>   		job->mappings[i] = mapping;
>   	}
>   
> diff --git a/drivers/gpu/drm/panfrost/panfrost_gem.h b/drivers/gpu/drm/panfrost/panfrost_gem.h
> index ca1bc9019600..b3517ff9630c 100644
> --- a/drivers/gpu/drm/panfrost/panfrost_gem.h
> +++ b/drivers/gpu/drm/panfrost/panfrost_gem.h
> @@ -30,6 +30,12 @@ struct panfrost_gem_object {
>   		struct mutex lock;
>   	} mappings;
>   
> +	/*
> +	 * Count the number of jobs referencing this BO so we don't let the
> +	 * shrinker reclaim this object prematurely.
> +	 */
> +	atomic_t gpu_usecount;
> +
>   	bool noexec		:1;
>   	bool is_heap		:1;
>   };
> diff --git a/drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c b/drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c
> index b36df326c860..288e46c40673 100644
> --- a/drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c
> +++ b/drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c
> @@ -41,6 +41,8 @@ static bool panfrost_gem_purge(struct drm_gem_object *obj)
>   	struct drm_gem_shmem_object *shmem = to_drm_gem_shmem_obj(obj);
>   	struct panfrost_gem_object *bo = to_panfrost_bo(obj);
>   
> +	if (atomic_read(&bo->gpu_usecount))
> +		return false;
>   
>   	if (!mutex_trylock(&shmem->pages_lock))
>   		return false;
> diff --git a/drivers/gpu/drm/panfrost/panfrost_job.c b/drivers/gpu/drm/panfrost/panfrost_job.c
> index c85d45be3b5e..2b12aa87ff32 100644
> --- a/drivers/gpu/drm/panfrost/panfrost_job.c
> +++ b/drivers/gpu/drm/panfrost/panfrost_job.c
> @@ -270,8 +270,13 @@ static void panfrost_job_cleanup(struct kref *ref)
>   	dma_fence_put(job->render_done_fence);
>   
>   	if (job->mappings) {
> -		for (i = 0; i < job->bo_count; i++)
> +		for (i = 0; i < job->bo_count; i++) {
> +			if (!job->mappings[i])
> +				break;
> +
> +			atomic_dec(&job->mappings[i]->obj->gpu_usecount);
>   			panfrost_gem_mapping_put(job->mappings[i]);
> +		}
>   		kvfree(job->mappings);
>   	}
>   
> 
