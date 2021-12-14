Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED89E4743C0
	for <lists+stable@lfdr.de>; Tue, 14 Dec 2021 14:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234519AbhLNNof (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 08:44:35 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52006 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234520AbhLNNof (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Dec 2021 08:44:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13F73B818AD;
        Tue, 14 Dec 2021 13:44:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4385AC34601;
        Tue, 14 Dec 2021 13:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639489472;
        bh=rMKi4DJ3Qt32QMZ9f4myvhx7rHRcEUJW26Wm3InvQQg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zld5hdCXn2QMc/cM31ft6Ns58UNgukvagI3PKADiXGkN40ex/9cUyy2/kJF46Qzjz
         6oywztC/T5MbGG2CgxdxwvowVWqEhFvBOUEtSOyWvxCDtT0vVRB0siXHwWo8UFOdor
         39DIjm0HGPsIIA9E0P4EeRzHUX3exq2lkRvcod2g=
Date:   Tue, 14 Dec 2021 14:44:30 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jens Wiklander <jens.wiklander@linaro.org>
Cc:     linux-kernel@vger.kernel.org, op-tee@lists.trustedfirmware.org,
        Sumit Garg <sumit.garg@linaro.org>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Rijo Thomas <Rijo-john.Thomas@amd.com>,
        Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>,
        stable@vger.kernel.org, Lars Persson <larper@axis.com>,
        Patrik Lantz <patrik.lantz@axis.com>
Subject: Re: [PATCH] tee: handle lookup of shm with reference count 0
Message-ID: <YbifvnSBjW5m19hZ@kroah.com>
References: <20211214123540.1789434-1-jens.wiklander@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211214123540.1789434-1-jens.wiklander@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 14, 2021 at 01:35:40PM +0100, Jens Wiklander wrote:
> Since the tee subsystem does not keep a strong reference to its idle
> shared memory buffers, it races with other threads that try to destroy a
> shared memory through a close of its dma-buf fd or by unmapping the
> memory.
> 
> In tee_shm_get_from_id() when a lookup in teedev->idr has been
> successful, it is possible that the tee_shm is in the dma-buf teardown
> path, but that path is blocked by the teedev mutex. Since we don't have
> an API to tell if the tee_shm is in the dma-buf teardown path or not we
> must find another way of detecting this condition.
> 
> Fix this by doing the reference counting directly on the tee_shm using a
> new refcount_t refcount field. dma-buf is replaced by using
> anon_inode_getfd() instead, this separates the life-cycle of the
> underlying file from the tee_shm. tee_shm_put() is updated to hold the
> mutex when decreasing the refcount to 0 and then remove the tee_shm from
> teedev->idr before releasing the mutex. This means that the tee_shm can
> never be found unless it has a refcount larger than 0.

So you are dropping dma-buf support entirely?  And anon_inode_getfd()
works instead?  Why do more people not do this as well?

> 
> Fixes: 967c9cca2cc5 ("tee: generic TEE subsystem")
> Cc: stable@vger.kernel.org
> Reviewed-by: Lars Persson <larper@axis.com>
> Reviewed-by: Sumit Garg <sumit.garg@linaro.org>
> Reported-by: Patrik Lantz <patrik.lantz@axis.com>
> Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
> ---
>  drivers/tee/tee_shm.c   | 174 +++++++++++++++-------------------------
>  include/linux/tee_drv.h |   2 +-
>  2 files changed, 67 insertions(+), 109 deletions(-)
> 
> diff --git a/drivers/tee/tee_shm.c b/drivers/tee/tee_shm.c
> index 8a8deb95e918..0c82cf981c46 100644
> --- a/drivers/tee/tee_shm.c
> +++ b/drivers/tee/tee_shm.c
> @@ -1,20 +1,17 @@
>  // SPDX-License-Identifier: GPL-2.0-only
>  /*
> - * Copyright (c) 2015-2016, Linaro Limited
> + * Copyright (c) 2015-2021, Linaro Limited

Nit, did Linaro really make a copyrightable change in 2017, 2018, 2019
and 2020 as well?  If not, please do not claim it.

>   */
> +#include <linux/anon_inodes.h>
>  #include <linux/device.h>
> -#include <linux/dma-buf.h>
> -#include <linux/fdtable.h>
>  #include <linux/idr.h>
> +#include <linux/mm.h>
>  #include <linux/sched.h>
>  #include <linux/slab.h>
>  #include <linux/tee_drv.h>
>  #include <linux/uio.h>
> -#include <linux/module.h>
>  #include "tee_private.h"
>  
> -MODULE_IMPORT_NS(DMA_BUF);
> -
>  static void release_registered_pages(struct tee_shm *shm)
>  {
>  	if (shm->pages) {
> @@ -31,16 +28,8 @@ static void release_registered_pages(struct tee_shm *shm)
>  	}
>  }
>  
> -static void tee_shm_release(struct tee_shm *shm)
> +static void tee_shm_release(struct tee_device *teedev, struct tee_shm *shm)
>  {
> -	struct tee_device *teedev = shm->ctx->teedev;
> -
> -	if (shm->flags & TEE_SHM_DMA_BUF) {
> -		mutex_lock(&teedev->mutex);
> -		idr_remove(&teedev->idr, shm->id);
> -		mutex_unlock(&teedev->mutex);
> -	}
> -
>  	if (shm->flags & TEE_SHM_POOL) {
>  		struct tee_shm_pool_mgr *poolm;
>  
> @@ -67,45 +56,6 @@ static void tee_shm_release(struct tee_shm *shm)
>  	tee_device_put(teedev);
>  }
>  
> -static struct sg_table *tee_shm_op_map_dma_buf(struct dma_buf_attachment
> -			*attach, enum dma_data_direction dir)
> -{
> -	return NULL;
> -}
> -
> -static void tee_shm_op_unmap_dma_buf(struct dma_buf_attachment *attach,
> -				     struct sg_table *table,
> -				     enum dma_data_direction dir)
> -{
> -}
> -
> -static void tee_shm_op_release(struct dma_buf *dmabuf)
> -{
> -	struct tee_shm *shm = dmabuf->priv;
> -
> -	tee_shm_release(shm);
> -}
> -
> -static int tee_shm_op_mmap(struct dma_buf *dmabuf, struct vm_area_struct *vma)
> -{
> -	struct tee_shm *shm = dmabuf->priv;
> -	size_t size = vma->vm_end - vma->vm_start;
> -
> -	/* Refuse sharing shared memory provided by application */
> -	if (shm->flags & TEE_SHM_USER_MAPPED)
> -		return -EINVAL;
> -
> -	return remap_pfn_range(vma, vma->vm_start, shm->paddr >> PAGE_SHIFT,
> -			       size, vma->vm_page_prot);
> -}
> -
> -static const struct dma_buf_ops tee_shm_dma_buf_ops = {
> -	.map_dma_buf = tee_shm_op_map_dma_buf,
> -	.unmap_dma_buf = tee_shm_op_unmap_dma_buf,
> -	.release = tee_shm_op_release,
> -	.mmap = tee_shm_op_mmap,
> -};
> -
>  struct tee_shm *tee_shm_alloc(struct tee_context *ctx, size_t size, u32 flags)
>  {
>  	struct tee_device *teedev = ctx->teedev;
> @@ -140,6 +90,7 @@ struct tee_shm *tee_shm_alloc(struct tee_context *ctx, size_t size, u32 flags)
>  		goto err_dev_put;
>  	}
>  
> +	refcount_set(&shm->refcount, 1);
>  	shm->flags = flags | TEE_SHM_POOL;
>  	shm->ctx = ctx;
>  	if (flags & TEE_SHM_DMA_BUF)
> @@ -153,10 +104,7 @@ struct tee_shm *tee_shm_alloc(struct tee_context *ctx, size_t size, u32 flags)
>  		goto err_kfree;
>  	}
>  
> -
>  	if (flags & TEE_SHM_DMA_BUF) {
> -		DEFINE_DMA_BUF_EXPORT_INFO(exp_info);
> -
>  		mutex_lock(&teedev->mutex);
>  		shm->id = idr_alloc(&teedev->idr, shm, 1, 0, GFP_KERNEL);
>  		mutex_unlock(&teedev->mutex);
> @@ -164,28 +112,11 @@ struct tee_shm *tee_shm_alloc(struct tee_context *ctx, size_t size, u32 flags)
>  			ret = ERR_PTR(shm->id);
>  			goto err_pool_free;
>  		}
> -
> -		exp_info.ops = &tee_shm_dma_buf_ops;
> -		exp_info.size = shm->size;
> -		exp_info.flags = O_RDWR;
> -		exp_info.priv = shm;
> -
> -		shm->dmabuf = dma_buf_export(&exp_info);
> -		if (IS_ERR(shm->dmabuf)) {
> -			ret = ERR_CAST(shm->dmabuf);
> -			goto err_rem;
> -		}
>  	}
>  
>  	teedev_ctx_get(ctx);
>  
>  	return shm;
> -err_rem:
> -	if (flags & TEE_SHM_DMA_BUF) {
> -		mutex_lock(&teedev->mutex);
> -		idr_remove(&teedev->idr, shm->id);
> -		mutex_unlock(&teedev->mutex);
> -	}
>  err_pool_free:
>  	poolm->ops->free(poolm, shm);
>  err_kfree:
> @@ -246,6 +177,7 @@ struct tee_shm *tee_shm_register(struct tee_context *ctx, unsigned long addr,
>  		goto err;
>  	}
>  
> +	refcount_set(&shm->refcount, 1);
>  	shm->flags = flags | TEE_SHM_REGISTER;
>  	shm->ctx = ctx;
>  	shm->id = -1;
> @@ -306,22 +238,6 @@ struct tee_shm *tee_shm_register(struct tee_context *ctx, unsigned long addr,
>  		goto err;
>  	}
>  
> -	if (flags & TEE_SHM_DMA_BUF) {
> -		DEFINE_DMA_BUF_EXPORT_INFO(exp_info);
> -
> -		exp_info.ops = &tee_shm_dma_buf_ops;
> -		exp_info.size = shm->size;
> -		exp_info.flags = O_RDWR;
> -		exp_info.priv = shm;
> -
> -		shm->dmabuf = dma_buf_export(&exp_info);
> -		if (IS_ERR(shm->dmabuf)) {
> -			ret = ERR_CAST(shm->dmabuf);
> -			teedev->desc->ops->shm_unregister(ctx, shm);
> -			goto err;
> -		}
> -	}
> -
>  	return shm;
>  err:
>  	if (shm) {
> @@ -339,6 +255,35 @@ struct tee_shm *tee_shm_register(struct tee_context *ctx, unsigned long addr,
>  }
>  EXPORT_SYMBOL_GPL(tee_shm_register);
>  
> +static int tee_shm_fop_release(struct inode *inode, struct file *filp)
> +{
> +	tee_shm_put(filp->private_data);
> +	return 0;
> +}
> +
> +static int tee_shm_fop_mmap(struct file *filp, struct vm_area_struct *vma)
> +{
> +	struct tee_shm *shm = filp->private_data;
> +	size_t size = vma->vm_end - vma->vm_start;
> +
> +	/* Refuse sharing shared memory provided by application */
> +	if (shm->flags & TEE_SHM_USER_MAPPED)
> +		return -EINVAL;
> +
> +	/* check for overflowing the buffer's size */
> +	if (vma->vm_pgoff + vma_pages(vma) > shm->size >> PAGE_SHIFT)
> +		return -EINVAL;
> +
> +	return remap_pfn_range(vma, vma->vm_start, shm->paddr >> PAGE_SHIFT,
> +			       size, vma->vm_page_prot);
> +}
> +
> +static const struct file_operations tee_shm_fops = {
> +	.owner = THIS_MODULE,
> +	.release = tee_shm_fop_release,
> +	.mmap = tee_shm_fop_mmap,
> +};
> +
>  /**
>   * tee_shm_get_fd() - Increase reference count and return file descriptor
>   * @shm:	Shared memory handle
> @@ -351,10 +296,11 @@ int tee_shm_get_fd(struct tee_shm *shm)
>  	if (!(shm->flags & TEE_SHM_DMA_BUF))
>  		return -EINVAL;
>  
> -	get_dma_buf(shm->dmabuf);
> -	fd = dma_buf_fd(shm->dmabuf, O_CLOEXEC);
> +	/* matched by tee_shm_put() in tee_shm_op_release() */
> +	refcount_inc(&shm->refcount);
> +	fd = anon_inode_getfd("tee_shm", &tee_shm_fops, shm, O_RDWR);
>  	if (fd < 0)
> -		dma_buf_put(shm->dmabuf);
> +		tee_shm_put(shm);
>  	return fd;
>  }
>  
> @@ -364,17 +310,7 @@ int tee_shm_get_fd(struct tee_shm *shm)
>   */
>  void tee_shm_free(struct tee_shm *shm)
>  {
> -	/*
> -	 * dma_buf_put() decreases the dmabuf reference counter and will
> -	 * call tee_shm_release() when the last reference is gone.
> -	 *
> -	 * In the case of driver private memory we call tee_shm_release
> -	 * directly instead as it doesn't have a reference counter.
> -	 */
> -	if (shm->flags & TEE_SHM_DMA_BUF)
> -		dma_buf_put(shm->dmabuf);
> -	else
> -		tee_shm_release(shm);
> +	tee_shm_put(shm);
>  }
>  EXPORT_SYMBOL_GPL(tee_shm_free);
>  
> @@ -481,10 +417,15 @@ struct tee_shm *tee_shm_get_from_id(struct tee_context *ctx, int id)
>  	teedev = ctx->teedev;
>  	mutex_lock(&teedev->mutex);
>  	shm = idr_find(&teedev->idr, id);
> +	/*
> +	 * If the tee_shm was found in the IDR it must have a refcount
> +	 * larger than 0 due to the guarantee in tee_shm_put() below. So
> +	 * it's safe to use refcount_inc().
> +	 */
>  	if (!shm || shm->ctx != ctx)
>  		shm = ERR_PTR(-EINVAL);
> -	else if (shm->flags & TEE_SHM_DMA_BUF)
> -		get_dma_buf(shm->dmabuf);
> +	else
> +		refcount_inc(&shm->refcount);
>  	mutex_unlock(&teedev->mutex);
>  	return shm;
>  }
> @@ -496,7 +437,24 @@ EXPORT_SYMBOL_GPL(tee_shm_get_from_id);
>   */
>  void tee_shm_put(struct tee_shm *shm)
>  {
> -	if (shm->flags & TEE_SHM_DMA_BUF)
> -		dma_buf_put(shm->dmabuf);
> +	struct tee_device *teedev = shm->ctx->teedev;
> +	bool do_release = false;
> +
> +	mutex_lock(&teedev->mutex);
> +	if (refcount_dec_and_test(&shm->refcount)) {
> +		/*
> +		 * refcount has reached 0, we must now remove it from the
> +		 * IDR before releasing the mutex. This will guarantee that
> +		 * the refcount_inc() in tee_shm_get_from_id() never starts
> +		 * from 0.
> +		 */
> +		if (shm->flags & TEE_SHM_DMA_BUF)
> +			idr_remove(&teedev->idr, shm->id);
> +		do_release = true;

As you are using a refcount in the "traditional" way, why not just use a
kref instead?  That solves your "do_release" mess here.

thanks,

greg k-h
