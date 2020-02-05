Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC907153481
	for <lists+stable@lfdr.de>; Wed,  5 Feb 2020 16:46:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbgBEPps (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Feb 2020 10:45:48 -0500
Received: from foss.arm.com ([217.140.110.172]:48902 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726748AbgBEPps (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Feb 2020 10:45:48 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DDF9A328;
        Wed,  5 Feb 2020 07:45:46 -0800 (PST)
Received: from [10.1.196.37] (e121345-lin.cambridge.arm.com [10.1.196.37])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8D6903F68E;
        Wed,  5 Feb 2020 07:45:45 -0800 (PST)
Subject: Re: [PATCH 1/2] drm/panfrost: Make sure MMU context lifetime is not
 bound to panfrost_priv
To:     Boris Brezillon <boris.brezillon@collabora.com>,
        Rob Herring <robh+dt@kernel.org>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Steven Price <steven.price@arm.com>
Cc:     dri-devel@lists.freedesktop.org, Icecream95 <ixn@keemail.me>,
        stable@vger.kernel.org
References: <20200204143504.135388-1-boris.brezillon@collabora.com>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <987637cb-c7c9-a763-d727-a89f3c73f681@arm.com>
Date:   Wed, 5 Feb 2020 15:45:44 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200204143504.135388-1-boris.brezillon@collabora.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 04/02/2020 2:35 pm, Boris Brezillon wrote:
> Jobs can be in-flight when the file descriptor is closed (either because
> the process did not terminate properly, or because it didn't wait for
> all GPU jobs to be finished), and apparently panfrost_job_close() does
> not cancel already running jobs. Let's refcount the MMU context object
> so it's lifetime is no longer bound to the FD lifetime and running jobs
> can finish properly without generating spurious page faults.

Yup, this remedies what I've been seeing for ages, where - given a 
sufficiently slow GPU - merely exiting kmscube generates a pile of 
translation faults. With this patch applied that no longer happens 
(yay!), however after a few tries I did now manage to hit this:

[  539.190908] WARNING: CPU: 0 PID: 0 at 
drivers/gpu/drm/panfrost/panfrost_mmu.c:200 panfrost_mmu_as_put+0x38/0x40

after which something apparently deadlocked because some weird SCMI 
mailbox errors and continual RCU stalls in __switch_to() followed. Those 
exact symptoms are probably particular to the Juno FPGA setup, but it 
does seem to point to the GPU getting into an unhappy state.

Robin.

> Reported-by: Icecream95 <ixn@keemail.me>
> Fixes: 7282f7645d06 ("drm/panfrost: Implement per FD address spaces")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
> ---
>   drivers/gpu/drm/panfrost/panfrost_device.h |   8 +-
>   drivers/gpu/drm/panfrost/panfrost_drv.c    |  50 ++-----
>   drivers/gpu/drm/panfrost/panfrost_gem.c    |  20 ++-
>   drivers/gpu/drm/panfrost/panfrost_job.c    |   4 +-
>   drivers/gpu/drm/panfrost/panfrost_mmu.c    | 158 ++++++++++++++-------
>   drivers/gpu/drm/panfrost/panfrost_mmu.h    |   5 +-
>   6 files changed, 135 insertions(+), 110 deletions(-)
> 
> diff --git a/drivers/gpu/drm/panfrost/panfrost_device.h b/drivers/gpu/drm/panfrost/panfrost_device.h
> index 06713811b92c..3f19288e8375 100644
> --- a/drivers/gpu/drm/panfrost/panfrost_device.h
> +++ b/drivers/gpu/drm/panfrost/panfrost_device.h
> @@ -94,8 +94,12 @@ struct panfrost_device {
>   };
>   
>   struct panfrost_mmu {
> +	struct panfrost_device *pfdev;
> +	struct kref refcount;
>   	struct io_pgtable_cfg pgtbl_cfg;
>   	struct io_pgtable_ops *pgtbl_ops;
> +	struct drm_mm mm;
> +	spinlock_t mm_lock;
>   	int as;
>   	atomic_t as_count;
>   	struct list_head list;
> @@ -106,9 +110,7 @@ struct panfrost_file_priv {
>   
>   	struct drm_sched_entity sched_entity[NUM_JOB_SLOTS];
>   
> -	struct panfrost_mmu mmu;
> -	struct drm_mm mm;
> -	spinlock_t mm_lock;
> +	struct panfrost_mmu *mmu;
>   };
>   
>   static inline struct panfrost_device *to_panfrost_device(struct drm_device *ddev)
> diff --git a/drivers/gpu/drm/panfrost/panfrost_drv.c b/drivers/gpu/drm/panfrost/panfrost_drv.c
> index 273d67e251c2..41e574742a3c 100644
> --- a/drivers/gpu/drm/panfrost/panfrost_drv.c
> +++ b/drivers/gpu/drm/panfrost/panfrost_drv.c
> @@ -418,7 +418,7 @@ static int panfrost_ioctl_madvise(struct drm_device *dev, void *data,
>   		 * anyway, so let's not bother.
>   		 */
>   		if (!list_is_singular(&bo->mappings.list) ||
> -		    WARN_ON_ONCE(first->mmu != &priv->mmu)) {
> +		    WARN_ON_ONCE(first->mmu != priv->mmu)) {
>   			ret = -EINVAL;
>   			goto out_unlock_mappings;
>   		}
> @@ -450,32 +450,6 @@ int panfrost_unstable_ioctl_check(void)
>   	return 0;
>   }
>   
> -#define PFN_4G		(SZ_4G >> PAGE_SHIFT)
> -#define PFN_4G_MASK	(PFN_4G - 1)
> -#define PFN_16M		(SZ_16M >> PAGE_SHIFT)
> -
> -static void panfrost_drm_mm_color_adjust(const struct drm_mm_node *node,
> -					 unsigned long color,
> -					 u64 *start, u64 *end)
> -{
> -	/* Executable buffers can't start or end on a 4GB boundary */
> -	if (!(color & PANFROST_BO_NOEXEC)) {
> -		u64 next_seg;
> -
> -		if ((*start & PFN_4G_MASK) == 0)
> -			(*start)++;
> -
> -		if ((*end & PFN_4G_MASK) == 0)
> -			(*end)--;
> -
> -		next_seg = ALIGN(*start, PFN_4G);
> -		if (next_seg - *start <= PFN_16M)
> -			*start = next_seg + 1;
> -
> -		*end = min(*end, ALIGN(*start, PFN_4G) - 1);
> -	}
> -}
> -
>   static int
>   panfrost_open(struct drm_device *dev, struct drm_file *file)
>   {
> @@ -490,15 +464,11 @@ panfrost_open(struct drm_device *dev, struct drm_file *file)
>   	panfrost_priv->pfdev = pfdev;
>   	file->driver_priv = panfrost_priv;
>   
> -	spin_lock_init(&panfrost_priv->mm_lock);
> -
> -	/* 4G enough for now. can be 48-bit */
> -	drm_mm_init(&panfrost_priv->mm, SZ_32M >> PAGE_SHIFT, (SZ_4G - SZ_32M) >> PAGE_SHIFT);
> -	panfrost_priv->mm.color_adjust = panfrost_drm_mm_color_adjust;
> -
> -	ret = panfrost_mmu_pgtable_alloc(panfrost_priv);
> -	if (ret)
> -		goto err_pgtable;
> +	panfrost_priv->mmu = panfrost_mmu_ctx_create(pfdev);
> +	if (IS_ERR(panfrost_priv->mmu)) {
> +		ret = PTR_ERR(panfrost_priv->mmu);
> +		goto err_free;
> +	}
>   
>   	ret = panfrost_job_open(panfrost_priv);
>   	if (ret)
> @@ -507,9 +477,8 @@ panfrost_open(struct drm_device *dev, struct drm_file *file)
>   	return 0;
>   
>   err_job:
> -	panfrost_mmu_pgtable_free(panfrost_priv);
> -err_pgtable:
> -	drm_mm_takedown(&panfrost_priv->mm);
> +	panfrost_mmu_ctx_put(panfrost_priv->mmu);
> +err_free:
>   	kfree(panfrost_priv);
>   	return ret;
>   }
> @@ -522,8 +491,7 @@ panfrost_postclose(struct drm_device *dev, struct drm_file *file)
>   	panfrost_perfcnt_close(file);
>   	panfrost_job_close(panfrost_priv);
>   
> -	panfrost_mmu_pgtable_free(panfrost_priv);
> -	drm_mm_takedown(&panfrost_priv->mm);
> +	panfrost_mmu_ctx_put(panfrost_priv->mmu);
>   	kfree(panfrost_priv);
>   }
>   
> diff --git a/drivers/gpu/drm/panfrost/panfrost_gem.c b/drivers/gpu/drm/panfrost/panfrost_gem.c
> index 17b654e1eb94..406e595f99e4 100644
> --- a/drivers/gpu/drm/panfrost/panfrost_gem.c
> +++ b/drivers/gpu/drm/panfrost/panfrost_gem.c
> @@ -60,7 +60,7 @@ panfrost_gem_mapping_get(struct panfrost_gem_object *bo,
>   
>   	mutex_lock(&bo->mappings.lock);
>   	list_for_each_entry(iter, &bo->mappings.list, node) {
> -		if (iter->mmu == &priv->mmu) {
> +		if (iter->mmu == priv->mmu) {
>   			kref_get(&iter->refcount);
>   			mapping = iter;
>   			break;
> @@ -74,16 +74,13 @@ panfrost_gem_mapping_get(struct panfrost_gem_object *bo,
>   static void
>   panfrost_gem_teardown_mapping(struct panfrost_gem_mapping *mapping)
>   {
> -	struct panfrost_file_priv *priv;
> -
>   	if (mapping->active)
>   		panfrost_mmu_unmap(mapping);
>   
> -	priv = container_of(mapping->mmu, struct panfrost_file_priv, mmu);
> -	spin_lock(&priv->mm_lock);
> +	spin_lock(&mapping->mmu->mm_lock);
>   	if (drm_mm_node_allocated(&mapping->mmnode))
>   		drm_mm_remove_node(&mapping->mmnode);
> -	spin_unlock(&priv->mm_lock);
> +	spin_unlock(&mapping->mmu->mm_lock);
>   }
>   
>   static void panfrost_gem_mapping_release(struct kref *kref)
> @@ -94,6 +91,7 @@ static void panfrost_gem_mapping_release(struct kref *kref)
>   
>   	panfrost_gem_teardown_mapping(mapping);
>   	drm_gem_object_put_unlocked(&mapping->obj->base.base);
> +	panfrost_mmu_ctx_put(mapping->mmu);
>   	kfree(mapping);
>   }
>   
> @@ -145,11 +143,11 @@ int panfrost_gem_open(struct drm_gem_object *obj, struct drm_file *file_priv)
>   	else
>   		align = size >= SZ_2M ? SZ_2M >> PAGE_SHIFT : 0;
>   
> -	mapping->mmu = &priv->mmu;
> -	spin_lock(&priv->mm_lock);
> -	ret = drm_mm_insert_node_generic(&priv->mm, &mapping->mmnode,
> +	mapping->mmu = panfrost_mmu_ctx_get(priv->mmu);
> +	spin_lock(&mapping->mmu->mm_lock);
> +	ret = drm_mm_insert_node_generic(&mapping->mmu->mm, &mapping->mmnode,
>   					 size >> PAGE_SHIFT, align, color, 0);
> -	spin_unlock(&priv->mm_lock);
> +	spin_unlock(&mapping->mmu->mm_lock);
>   	if (ret)
>   		goto err;
>   
> @@ -178,7 +176,7 @@ void panfrost_gem_close(struct drm_gem_object *obj, struct drm_file *file_priv)
>   
>   	mutex_lock(&bo->mappings.lock);
>   	list_for_each_entry(iter, &bo->mappings.list, node) {
> -		if (iter->mmu == &priv->mmu) {
> +		if (iter->mmu == priv->mmu) {
>   			mapping = iter;
>   			list_del(&iter->node);
>   			break;
> diff --git a/drivers/gpu/drm/panfrost/panfrost_job.c b/drivers/gpu/drm/panfrost/panfrost_job.c
> index 4d383831c1fc..b0716e49eeca 100644
> --- a/drivers/gpu/drm/panfrost/panfrost_job.c
> +++ b/drivers/gpu/drm/panfrost/panfrost_job.c
> @@ -154,7 +154,7 @@ static void panfrost_job_hw_submit(struct panfrost_job *job, int js)
>   		return;
>   	}
>   
> -	cfg = panfrost_mmu_as_get(pfdev, &job->file_priv->mmu);
> +	cfg = panfrost_mmu_as_get(pfdev, job->file_priv->mmu);
>   	panfrost_devfreq_record_busy(pfdev);
>   
>   	job_write(pfdev, JS_HEAD_NEXT_LO(js), jc_head & 0xFFFFFFFF);
> @@ -481,7 +481,7 @@ static irqreturn_t panfrost_job_irq_handler(int irq, void *data)
>   			if (job) {
>   				pfdev->jobs[j] = NULL;
>   
> -				panfrost_mmu_as_put(pfdev, &job->file_priv->mmu);
> +				panfrost_mmu_as_put(pfdev, job->file_priv->mmu);
>   				panfrost_devfreq_record_idle(pfdev);
>   
>   				dma_fence_signal_locked(job->done_fence);
> diff --git a/drivers/gpu/drm/panfrost/panfrost_mmu.c b/drivers/gpu/drm/panfrost/panfrost_mmu.c
> index 763cfca886a7..f70d5a75cbd5 100644
> --- a/drivers/gpu/drm/panfrost/panfrost_mmu.c
> +++ b/drivers/gpu/drm/panfrost/panfrost_mmu.c
> @@ -1,5 +1,8 @@
>   // SPDX-License-Identifier:	GPL-2.0
>   /* Copyright 2019 Linaro, Ltd, Rob Herring <robh@kernel.org> */
> +
> +#include <drm/panfrost_drm.h>
> +
>   #include <linux/atomic.h>
>   #include <linux/bitfield.h>
>   #include <linux/delay.h>
> @@ -332,7 +335,7 @@ static void mmu_tlb_inv_context_s1(void *cookie)
>   
>   static void mmu_tlb_sync_context(void *cookie)
>   {
> -	//struct panfrost_device *pfdev = cookie;
> +	//struct panfrost_mmu *mmu = cookie;
>   	// TODO: Wait 1000 GPU cycles for HW_ISSUE_6367/T60X
>   }
>   
> @@ -354,56 +357,10 @@ static const struct iommu_flush_ops mmu_tlb_ops = {
>   	.tlb_flush_leaf = mmu_tlb_flush_leaf,
>   };
>   
> -int panfrost_mmu_pgtable_alloc(struct panfrost_file_priv *priv)
> -{
> -	struct panfrost_mmu *mmu = &priv->mmu;
> -	struct panfrost_device *pfdev = priv->pfdev;
> -
> -	INIT_LIST_HEAD(&mmu->list);
> -	mmu->as = -1;
> -
> -	mmu->pgtbl_cfg = (struct io_pgtable_cfg) {
> -		.pgsize_bitmap	= SZ_4K | SZ_2M,
> -		.ias		= FIELD_GET(0xff, pfdev->features.mmu_features),
> -		.oas		= FIELD_GET(0xff00, pfdev->features.mmu_features),
> -		.tlb		= &mmu_tlb_ops,
> -		.iommu_dev	= pfdev->dev,
> -	};
> -
> -	mmu->pgtbl_ops = alloc_io_pgtable_ops(ARM_MALI_LPAE, &mmu->pgtbl_cfg,
> -					      priv);
> -	if (!mmu->pgtbl_ops)
> -		return -EINVAL;
> -
> -	return 0;
> -}
> -
> -void panfrost_mmu_pgtable_free(struct panfrost_file_priv *priv)
> -{
> -	struct panfrost_device *pfdev = priv->pfdev;
> -	struct panfrost_mmu *mmu = &priv->mmu;
> -
> -	spin_lock(&pfdev->as_lock);
> -	if (mmu->as >= 0) {
> -		pm_runtime_get_noresume(pfdev->dev);
> -		if (pm_runtime_active(pfdev->dev))
> -			panfrost_mmu_disable(pfdev, mmu->as);
> -		pm_runtime_put_autosuspend(pfdev->dev);
> -
> -		clear_bit(mmu->as, &pfdev->as_alloc_mask);
> -		clear_bit(mmu->as, &pfdev->as_in_use_mask);
> -		list_del(&mmu->list);
> -	}
> -	spin_unlock(&pfdev->as_lock);
> -
> -	free_io_pgtable_ops(mmu->pgtbl_ops);
> -}
> -
>   static struct panfrost_gem_mapping *
>   addr_to_mapping(struct panfrost_device *pfdev, int as, u64 addr)
>   {
>   	struct panfrost_gem_mapping *mapping = NULL;
> -	struct panfrost_file_priv *priv;
>   	struct drm_mm_node *node;
>   	u64 offset = addr >> PAGE_SHIFT;
>   	struct panfrost_mmu *mmu;
> @@ -416,11 +373,10 @@ addr_to_mapping(struct panfrost_device *pfdev, int as, u64 addr)
>   	goto out;
>   
>   found_mmu:
> -	priv = container_of(mmu, struct panfrost_file_priv, mmu);
>   
> -	spin_lock(&priv->mm_lock);
> +	spin_lock(&mmu->mm_lock);
>   
> -	drm_mm_for_each_node(node, &priv->mm) {
> +	drm_mm_for_each_node(node, &mmu->mm) {
>   		if (offset >= node->start &&
>   		    offset < (node->start + node->size)) {
>   			mapping = drm_mm_node_to_panfrost_mapping(node);
> @@ -430,7 +386,7 @@ addr_to_mapping(struct panfrost_device *pfdev, int as, u64 addr)
>   		}
>   	}
>   
> -	spin_unlock(&priv->mm_lock);
> +	spin_unlock(&mmu->mm_lock);
>   out:
>   	spin_unlock(&pfdev->as_lock);
>   	return mapping;
> @@ -537,6 +493,106 @@ static int panfrost_mmu_map_fault_addr(struct panfrost_device *pfdev, int as,
>   	return ret;
>   }
>   
> +static void panfrost_mmu_release_ctx(struct kref *kref)
> +{
> +	struct panfrost_mmu *mmu = container_of(kref, struct panfrost_mmu,
> +						refcount);
> +	struct panfrost_device *pfdev = mmu->pfdev;
> +
> +	spin_lock(&pfdev->as_lock);
> +	if (mmu->as >= 0) {
> +		pm_runtime_get_noresume(pfdev->dev);
> +		if (pm_runtime_active(pfdev->dev))
> +			panfrost_mmu_disable(pfdev, mmu->as);
> +		pm_runtime_put_autosuspend(pfdev->dev);
> +
> +		clear_bit(mmu->as, &pfdev->as_alloc_mask);
> +		clear_bit(mmu->as, &pfdev->as_in_use_mask);
> +		list_del(&mmu->list);
> +	}
> +	spin_unlock(&pfdev->as_lock);
> +
> +	free_io_pgtable_ops(mmu->pgtbl_ops);
> +	drm_mm_takedown(&mmu->mm);
> +	kfree(mmu);
> +}
> +
> +void panfrost_mmu_ctx_put(struct panfrost_mmu *mmu)
> +{
> +	kref_put(&mmu->refcount, panfrost_mmu_release_ctx);
> +}
> +
> +struct panfrost_mmu *panfrost_mmu_ctx_get(struct panfrost_mmu *mmu)
> +{
> +	kref_get(&mmu->refcount);
> +
> +	return mmu;
> +}
> +
> +#define PFN_4G		(SZ_4G >> PAGE_SHIFT)
> +#define PFN_4G_MASK	(PFN_4G - 1)
> +#define PFN_16M		(SZ_16M >> PAGE_SHIFT)
> +
> +static void panfrost_drm_mm_color_adjust(const struct drm_mm_node *node,
> +					 unsigned long color,
> +					 u64 *start, u64 *end)
> +{
> +	/* Executable buffers can't start or end on a 4GB boundary */
> +	if (!(color & PANFROST_BO_NOEXEC)) {
> +		u64 next_seg;
> +
> +		if ((*start & PFN_4G_MASK) == 0)
> +			(*start)++;
> +
> +		if ((*end & PFN_4G_MASK) == 0)
> +			(*end)--;
> +
> +		next_seg = ALIGN(*start, PFN_4G);
> +		if (next_seg - *start <= PFN_16M)
> +			*start = next_seg + 1;
> +
> +		*end = min(*end, ALIGN(*start, PFN_4G) - 1);
> +	}
> +}
> +
> +struct panfrost_mmu *panfrost_mmu_ctx_create(struct panfrost_device *pfdev)
> +{
> +	struct panfrost_mmu *mmu;
> +
> +	mmu = kzalloc(sizeof(*mmu), GFP_KERNEL);
> +	if (!mmu)
> +		return ERR_PTR(-ENOMEM);
> +
> +	mmu->pfdev = pfdev;
> +	spin_lock_init(&mmu->mm_lock);
> +
> +	/* 4G enough for now. can be 48-bit */
> +	drm_mm_init(&mmu->mm, SZ_32M >> PAGE_SHIFT, (SZ_4G - SZ_32M) >> PAGE_SHIFT);
> +	mmu->mm.color_adjust = panfrost_drm_mm_color_adjust;
> +
> +	INIT_LIST_HEAD(&mmu->list);
> +	mmu->as = -1;
> +
> +	mmu->pgtbl_cfg = (struct io_pgtable_cfg) {
> +		.pgsize_bitmap	= SZ_4K | SZ_2M,
> +		.ias		= FIELD_GET(0xff, pfdev->features.mmu_features),
> +		.oas		= FIELD_GET(0xff00, pfdev->features.mmu_features),
> +		.tlb		= &mmu_tlb_ops,
> +		.iommu_dev	= pfdev->dev,
> +	};
> +
> +	mmu->pgtbl_ops = alloc_io_pgtable_ops(ARM_MALI_LPAE, &mmu->pgtbl_cfg,
> +					      mmu);
> +	if (!mmu->pgtbl_ops) {
> +		kfree(mmu);
> +		return ERR_PTR(-EINVAL);
> +	}
> +
> +	kref_init(&mmu->refcount);
> +
> +	return mmu;
> +}
> +
>   static const char *access_type_name(struct panfrost_device *pfdev,
>   		u32 fault_status)
>   {
> diff --git a/drivers/gpu/drm/panfrost/panfrost_mmu.h b/drivers/gpu/drm/panfrost/panfrost_mmu.h
> index 44fc2edf63ce..cc2a0d307feb 100644
> --- a/drivers/gpu/drm/panfrost/panfrost_mmu.h
> +++ b/drivers/gpu/drm/panfrost/panfrost_mmu.h
> @@ -18,7 +18,8 @@ void panfrost_mmu_reset(struct panfrost_device *pfdev);
>   u32 panfrost_mmu_as_get(struct panfrost_device *pfdev, struct panfrost_mmu *mmu);
>   void panfrost_mmu_as_put(struct panfrost_device *pfdev, struct panfrost_mmu *mmu);
>   
> -int panfrost_mmu_pgtable_alloc(struct panfrost_file_priv *priv);
> -void panfrost_mmu_pgtable_free(struct panfrost_file_priv *priv);
> +struct panfrost_mmu *panfrost_mmu_ctx_get(struct panfrost_mmu *mmu);
> +void panfrost_mmu_ctx_put(struct panfrost_mmu *mmu);
> +struct panfrost_mmu *panfrost_mmu_ctx_create(struct panfrost_device *pfdev);
>   
>   #endif
> 
