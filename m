Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0A6915473A
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 16:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727309AbgBFPLT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 10:11:19 -0500
Received: from foss.arm.com ([217.140.110.172]:59824 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727138AbgBFPLT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Feb 2020 10:11:19 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 16AAF1FB;
        Thu,  6 Feb 2020 07:11:19 -0800 (PST)
Received: from [10.1.195.32] (e112269-lin.cambridge.arm.com [10.1.195.32])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ED3BD3F52E;
        Thu,  6 Feb 2020 07:11:17 -0800 (PST)
Subject: Re: [PATCH] drm/panfrost: perfcnt: Reserve/use the AS attached to the
 perfcnt MMU context
To:     Boris Brezillon <boris.brezillon@collabora.com>,
        Rob Herring <robh+dt@kernel.org>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Robin Murphy <robin.murphy@arm.com>
Cc:     stable@vger.kernel.org, Icecream95 <ixn@keemail.me>,
        Antonio Caggiano <antonio.caggiano@collabora.com>,
        dri-devel@lists.freedesktop.org
References: <20200206141327.446127-1-boris.brezillon@collabora.com>
From:   Steven Price <steven.price@arm.com>
Message-ID: <f22a7570-a054-c5ca-ce5a-1792f54b729f@arm.com>
Date:   Thu, 6 Feb 2020 15:11:16 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200206141327.446127-1-boris.brezillon@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06/02/2020 14:13, Boris Brezillon wrote:
> We need to use the AS attached to the opened FD when dumping counters.

Indeed we do!

Reviewed-by: Steven Price <steven.price@arm.com>

> 
> Reported-by: Antonio Caggiano <antonio.caggiano@collabora.com>
> Fixes: 7282f7645d06 ("drm/panfrost: Implement per FD address spaces")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
> ---
>  drivers/gpu/drm/panfrost/panfrost_mmu.c     |  7 ++++++-
>  drivers/gpu/drm/panfrost/panfrost_perfcnt.c | 11 ++++-------
>  2 files changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/gpu/drm/panfrost/panfrost_mmu.c b/drivers/gpu/drm/panfrost/panfrost_mmu.c
> index 763cfca886a7..3107b0738e40 100644
> --- a/drivers/gpu/drm/panfrost/panfrost_mmu.c
> +++ b/drivers/gpu/drm/panfrost/panfrost_mmu.c
> @@ -151,7 +151,12 @@ u32 panfrost_mmu_as_get(struct panfrost_device *pfdev, struct panfrost_mmu *mmu)
>  	as = mmu->as;
>  	if (as >= 0) {
>  		int en = atomic_inc_return(&mmu->as_count);
> -		WARN_ON(en >= NUM_JOB_SLOTS);
> +
> +		/*
> +		 * AS can be retained by active jobs or a perfcnt context,
> +		 * hence the '+ 1' here.
> +		 */
> +		WARN_ON(en >= (NUM_JOB_SLOTS + 1));
>  
>  		list_move(&mmu->list, &pfdev->as_lru_list);
>  		goto out;
> diff --git a/drivers/gpu/drm/panfrost/panfrost_perfcnt.c b/drivers/gpu/drm/panfrost/panfrost_perfcnt.c
> index 684820448be3..6913578d5aa7 100644
> --- a/drivers/gpu/drm/panfrost/panfrost_perfcnt.c
> +++ b/drivers/gpu/drm/panfrost/panfrost_perfcnt.c
> @@ -73,7 +73,7 @@ static int panfrost_perfcnt_enable_locked(struct panfrost_device *pfdev,
>  	struct panfrost_file_priv *user = file_priv->driver_priv;
>  	struct panfrost_perfcnt *perfcnt = pfdev->perfcnt;
>  	struct drm_gem_shmem_object *bo;
> -	u32 cfg;
> +	u32 cfg, as;
>  	int ret;
>  
>  	if (user == perfcnt->user)
> @@ -126,12 +126,8 @@ static int panfrost_perfcnt_enable_locked(struct panfrost_device *pfdev,
>  
>  	perfcnt->user = user;
>  
> -	/*
> -	 * Always use address space 0 for now.
> -	 * FIXME: this needs to be updated when we start using different
> -	 * address space.
> -	 */
> -	cfg = GPU_PERFCNT_CFG_AS(0) |
> +	as = panfrost_mmu_as_get(pfdev, perfcnt->mapping->mmu);
> +	cfg = GPU_PERFCNT_CFG_AS(as) |
>  	      GPU_PERFCNT_CFG_MODE(GPU_PERFCNT_CFG_MODE_MANUAL);
>  
>  	/*
> @@ -195,6 +191,7 @@ static int panfrost_perfcnt_disable_locked(struct panfrost_device *pfdev,
>  	drm_gem_shmem_vunmap(&perfcnt->mapping->obj->base.base, perfcnt->buf);
>  	perfcnt->buf = NULL;
>  	panfrost_gem_close(&perfcnt->mapping->obj->base.base, file_priv);
> +	panfrost_mmu_as_put(pfdev, perfcnt->mapping->mmu);
>  	panfrost_gem_mapping_put(perfcnt->mapping);
>  	perfcnt->mapping = NULL;
>  	pm_runtime_mark_last_busy(pfdev->dev);
> 

