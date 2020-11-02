Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 382E22A2650
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 09:42:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727902AbgKBImw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 03:42:52 -0500
Received: from foss.arm.com ([217.140.110.172]:55970 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727806AbgKBImw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Nov 2020 03:42:52 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4A176101E;
        Mon,  2 Nov 2020 00:42:51 -0800 (PST)
Received: from [192.168.1.179] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 27BC73F718;
        Mon,  2 Nov 2020 00:42:50 -0800 (PST)
Subject: Re: [PATCH] drm/panfrost: Fix a deadlock between the shrinker and
 madvise path
To:     Boris Brezillon <boris.brezillon@collabora.com>,
        Rob Herring <robh+dt@kernel.org>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Robin Murphy <robin.murphy@arm.com>
Cc:     dri-devel@lists.freedesktop.org, stable@vger.kernel.org,
        Christian Hewitt <christianshewitt@gmail.com>
References: <20201101174016.839110-1-boris.brezillon@collabora.com>
From:   Steven Price <steven.price@arm.com>
Message-ID: <12019a24-239e-6d51-316c-b5438e5af892@arm.com>
Date:   Mon, 2 Nov 2020 08:42:49 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201101174016.839110-1-boris.brezillon@collabora.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 01/11/2020 17:40, Boris Brezillon wrote:
> panfrost_ioctl_madvise() and panfrost_gem_purge() acquire the mappings
> and shmem locks in different orders, thus leading to a potential
> the mappings lock first.
> 
> Fixes: bdefca2d8dc0 ("drm/panfrost: Add the panfrost_gem_mapping concept")
> Cc: <stable@vger.kernel.org>
> Cc: Christian Hewitt <christianshewitt@gmail.com>
> Reported-by: Christian Hewitt <christianshewitt@gmail.com>
> Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>

Reviewed-by: Steven Price <steven.price@arm.com>

> ---
>   drivers/gpu/drm/panfrost/panfrost_gem.c          |  4 +---
>   drivers/gpu/drm/panfrost/panfrost_gem.h          |  2 +-
>   drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c | 14 +++++++++++---
>   3 files changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/gpu/drm/panfrost/panfrost_gem.c b/drivers/gpu/drm/panfrost/panfrost_gem.c
> index cdf1a8754eba..0c0243eaee81 100644
> --- a/drivers/gpu/drm/panfrost/panfrost_gem.c
> +++ b/drivers/gpu/drm/panfrost/panfrost_gem.c
> @@ -105,14 +105,12 @@ void panfrost_gem_mapping_put(struct panfrost_gem_mapping *mapping)
>   	kref_put(&mapping->refcount, panfrost_gem_mapping_release);
>   }
>   
> -void panfrost_gem_teardown_mappings(struct panfrost_gem_object *bo)
> +void panfrost_gem_teardown_mappings_locked(struct panfrost_gem_object *bo)
>   {
>   	struct panfrost_gem_mapping *mapping;
>   
> -	mutex_lock(&bo->mappings.lock);
>   	list_for_each_entry(mapping, &bo->mappings.list, node)
>   		panfrost_gem_teardown_mapping(mapping);
> -	mutex_unlock(&bo->mappings.lock);
>   }
>   
>   int panfrost_gem_open(struct drm_gem_object *obj, struct drm_file *file_priv)
> diff --git a/drivers/gpu/drm/panfrost/panfrost_gem.h b/drivers/gpu/drm/panfrost/panfrost_gem.h
> index b3517ff9630c..8088d5fd8480 100644
> --- a/drivers/gpu/drm/panfrost/panfrost_gem.h
> +++ b/drivers/gpu/drm/panfrost/panfrost_gem.h
> @@ -82,7 +82,7 @@ struct panfrost_gem_mapping *
>   panfrost_gem_mapping_get(struct panfrost_gem_object *bo,
>   			 struct panfrost_file_priv *priv);
>   void panfrost_gem_mapping_put(struct panfrost_gem_mapping *mapping);
> -void panfrost_gem_teardown_mappings(struct panfrost_gem_object *bo);
> +void panfrost_gem_teardown_mappings_locked(struct panfrost_gem_object *bo);
>   
>   void panfrost_gem_shrinker_init(struct drm_device *dev);
>   void panfrost_gem_shrinker_cleanup(struct drm_device *dev);
> diff --git a/drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c b/drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c
> index 288e46c40673..1b9f68d8e9aa 100644
> --- a/drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c
> +++ b/drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c
> @@ -40,18 +40,26 @@ static bool panfrost_gem_purge(struct drm_gem_object *obj)
>   {
>   	struct drm_gem_shmem_object *shmem = to_drm_gem_shmem_obj(obj);
>   	struct panfrost_gem_object *bo = to_panfrost_bo(obj);
> +	bool ret = false;
>   
>   	if (atomic_read(&bo->gpu_usecount))
>   		return false;
>   
> -	if (!mutex_trylock(&shmem->pages_lock))
> +	if (!mutex_trylock(&bo->mappings.lock))
>   		return false;
>   
> -	panfrost_gem_teardown_mappings(bo);
> +	if (!mutex_trylock(&shmem->pages_lock))
> +		goto unlock_mappings;
> +
> +	panfrost_gem_teardown_mappings_locked(bo);
>   	drm_gem_shmem_purge_locked(obj);
> +	ret = true;
>   
>   	mutex_unlock(&shmem->pages_lock);
> -	return true;
> +
> +unlock_mappings:
> +	mutex_unlock(&bo->mappings.lock);
> +	return ret;
>   }
>   
>   static unsigned long
> 

