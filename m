Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99520474CE6
	for <lists+stable@lfdr.de>; Tue, 14 Dec 2021 21:59:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237725AbhLNU7X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 15:59:23 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:45492 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230382AbhLNU7X (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Dec 2021 15:59:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0D5B5CE1AC9;
        Tue, 14 Dec 2021 20:59:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CFDEC34600;
        Tue, 14 Dec 2021 20:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639515559;
        bh=F9FpqQCUuqROeN7MGfGEWsuc2AaYu7oe3/xtK1BVm6k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j8KMBUMcmm52SnHzk12JCj8Rhj3RBmXEurFjJdH04aBrAImOKvP0glQSv2OIBqJgB
         BPlatdy5Tja1j3gOJVp7QWcPJ2QHpG2TOoze4l3Ry7ODhUhjQP2Sd/9cJF26SXGZ16
         2+DCSnx0SfH9HjuNGxA2CfYKllPD+cIazv36HDTY=
Date:   Tue, 14 Dec 2021 21:59:07 +0100
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
Message-ID: <YbkFm01+Qfy8T1dh@kroah.com>
References: <20211214123540.1789434-1-jens.wiklander@linaro.org>
 <YbifvnSBjW5m19hZ@kroah.com>
 <20211214145957.GA1800868@jade>
 <Ybi3Vx1UzJ/tpTHq@kroah.com>
 <20211214163144.GA1807724@jade>
 <YbjLrkTcveIqD8PL@kroah.com>
 <20211214185010.GA1816063@jade>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211214185010.GA1816063@jade>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 14, 2021 at 07:50:10PM +0100, Jens Wiklander wrote:
> On Tue, Dec 14, 2021 at 05:51:58PM +0100, Greg KH wrote:
> > On Tue, Dec 14, 2021 at 05:31:44PM +0100, Jens Wiklander wrote:
> > > On Tue, Dec 14, 2021 at 04:25:11PM +0100, Greg KH wrote:
> > > > On Tue, Dec 14, 2021 at 03:59:57PM +0100, Jens Wiklander wrote:
> > > > > On Tue, Dec 14, 2021 at 02:44:30PM +0100, Greg KH wrote:
> > > > > > On Tue, Dec 14, 2021 at 01:35:40PM +0100, Jens Wiklander wrote:
> > > > > > > Since the tee subsystem does not keep a strong reference to its idle
> > > > > > > shared memory buffers, it races with other threads that try to destroy a
> > > > > > > shared memory through a close of its dma-buf fd or by unmapping the
> > > > > > > memory.
> > > > > > > 
> > > > > > > In tee_shm_get_from_id() when a lookup in teedev->idr has been
> > > > > > > successful, it is possible that the tee_shm is in the dma-buf teardown
> > > > > > > path, but that path is blocked by the teedev mutex. Since we don't have
> > > > > > > an API to tell if the tee_shm is in the dma-buf teardown path or not we
> > > > > > > must find another way of detecting this condition.
> > > > > > > 
> > > > > > > Fix this by doing the reference counting directly on the tee_shm using a
> > > > > > > new refcount_t refcount field. dma-buf is replaced by using
> > > > > > > anon_inode_getfd() instead, this separates the life-cycle of the
> > > > > > > underlying file from the tee_shm. tee_shm_put() is updated to hold the
> > > > > > > mutex when decreasing the refcount to 0 and then remove the tee_shm from
> > > > > > > teedev->idr before releasing the mutex. This means that the tee_shm can
> > > > > > > never be found unless it has a refcount larger than 0.
> > > > > > 
> > > > > > So you are dropping dma-buf support entirely?  And anon_inode_getfd()
> > > > > > works instead?  Why do more people not do this as well?
> > > > > 
> > > > > I don't know, but it should be noted that we're not doing very much with
> > > > > this file descriptor. We're only using it with mmap() and close().
> > > > > 
> > > > > > 
> > > > > > > 
> > > > > > > Fixes: 967c9cca2cc5 ("tee: generic TEE subsystem")
> > > > > > > Cc: stable@vger.kernel.org
> > > > > > > Reviewed-by: Lars Persson <larper@axis.com>
> > > > > > > Reviewed-by: Sumit Garg <sumit.garg@linaro.org>
> > > > > > > Reported-by: Patrik Lantz <patrik.lantz@axis.com>
> > > > > > > Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
> > > > > > > ---
> > > > > > >  drivers/tee/tee_shm.c   | 174 +++++++++++++++-------------------------
> > > > > > >  include/linux/tee_drv.h |   2 +-
> > > > > > >  2 files changed, 67 insertions(+), 109 deletions(-)
> > > > > > > 
> > > > > > > diff --git a/drivers/tee/tee_shm.c b/drivers/tee/tee_shm.c
> > > > > > > index 8a8deb95e918..0c82cf981c46 100644
> > > > > > > --- a/drivers/tee/tee_shm.c
> > > > > > > +++ b/drivers/tee/tee_shm.c
> > > > > > > @@ -1,20 +1,17 @@
> > > > > > >  // SPDX-License-Identifier: GPL-2.0-only
> > > > > > >  /*
> > > > > > > - * Copyright (c) 2015-2016, Linaro Limited
> > > > > > > + * Copyright (c) 2015-2021, Linaro Limited
> > > > > > 
> > > > > > Nit, did Linaro really make a copyrightable change in 2017, 2018, 2019
> > > > > > and 2020 as well?  If not, please do not claim it.
> > > > > 
> > > > > Fair enough, I was a bit lazy 2018 shouldn't be there now that I've
> > > > > checked the log. I'll fix.
> > > > > 
> > > > > > 
> > > > > > >   */
> > > > > > > +#include <linux/anon_inodes.h>
> > > > > > >  #include <linux/device.h>
> > > > > > > -#include <linux/dma-buf.h>
> > > > > > > -#include <linux/fdtable.h>
> > > > > > >  #include <linux/idr.h>
> > > > > > > +#include <linux/mm.h>
> > > > > > >  #include <linux/sched.h>
> > > > > > >  #include <linux/slab.h>
> > > > > > >  #include <linux/tee_drv.h>
> > > > > > >  #include <linux/uio.h>
> > > > > > > -#include <linux/module.h>
> > > > > > >  #include "tee_private.h"
> > > > > > >  
> > > > > > > -MODULE_IMPORT_NS(DMA_BUF);
> > > > > > > -
> > > > > > >  static void release_registered_pages(struct tee_shm *shm)
> > > > > > >  {
> > > > > > >  	if (shm->pages) {
> > > > > > > @@ -31,16 +28,8 @@ static void release_registered_pages(struct tee_shm *shm)
> > > > > > >  	}
> > > > > > >  }
> > > > > > >  
> > > > > > > -static void tee_shm_release(struct tee_shm *shm)
> > > > > > > +static void tee_shm_release(struct tee_device *teedev, struct tee_shm *shm)
> > > > > > >  {
> > > > > > > -	struct tee_device *teedev = shm->ctx->teedev;
> > > > > > > -
> > > > > > > -	if (shm->flags & TEE_SHM_DMA_BUF) {
> > > > > > > -		mutex_lock(&teedev->mutex);
> > > > > > > -		idr_remove(&teedev->idr, shm->id);
> > > > > > > -		mutex_unlock(&teedev->mutex);
> > > > > > > -	}
> > > > > > > -
> > > > > > >  	if (shm->flags & TEE_SHM_POOL) {
> > > > > > >  		struct tee_shm_pool_mgr *poolm;
> > > > > > >  
> > > > > > > @@ -67,45 +56,6 @@ static void tee_shm_release(struct tee_shm *shm)
> > > > > > >  	tee_device_put(teedev);
> > > > > > >  }
> > > > > > >  
> > > > > > > -static struct sg_table *tee_shm_op_map_dma_buf(struct dma_buf_attachment
> > > > > > > -			*attach, enum dma_data_direction dir)
> > > > > > > -{
> > > > > > > -	return NULL;
> > > > > > > -}
> > > > > > > -
> > > > > > > -static void tee_shm_op_unmap_dma_buf(struct dma_buf_attachment *attach,
> > > > > > > -				     struct sg_table *table,
> > > > > > > -				     enum dma_data_direction dir)
> > > > > > > -{
> > > > > > > -}
> > > > > > > -
> > > > > > > -static void tee_shm_op_release(struct dma_buf *dmabuf)
> > > > > > > -{
> > > > > > > -	struct tee_shm *shm = dmabuf->priv;
> > > > > > > -
> > > > > > > -	tee_shm_release(shm);
> > > > > > > -}
> > > > > > > -
> > > > > > > -static int tee_shm_op_mmap(struct dma_buf *dmabuf, struct vm_area_struct *vma)
> > > > > > > -{
> > > > > > > -	struct tee_shm *shm = dmabuf->priv;
> > > > > > > -	size_t size = vma->vm_end - vma->vm_start;
> > > > > > > -
> > > > > > > -	/* Refuse sharing shared memory provided by application */
> > > > > > > -	if (shm->flags & TEE_SHM_USER_MAPPED)
> > > > > > > -		return -EINVAL;
> > > > > > > -
> > > > > > > -	return remap_pfn_range(vma, vma->vm_start, shm->paddr >> PAGE_SHIFT,
> > > > > > > -			       size, vma->vm_page_prot);
> > > > > > > -}
> > > > > > > -
> > > > > > > -static const struct dma_buf_ops tee_shm_dma_buf_ops = {
> > > > > > > -	.map_dma_buf = tee_shm_op_map_dma_buf,
> > > > > > > -	.unmap_dma_buf = tee_shm_op_unmap_dma_buf,
> > > > > > > -	.release = tee_shm_op_release,
> > > > > > > -	.mmap = tee_shm_op_mmap,
> > > > > > > -};
> > > > > > > -
> > > > > > >  struct tee_shm *tee_shm_alloc(struct tee_context *ctx, size_t size, u32 flags)
> > > > > > >  {
> > > > > > >  	struct tee_device *teedev = ctx->teedev;
> > > > > > > @@ -140,6 +90,7 @@ struct tee_shm *tee_shm_alloc(struct tee_context *ctx, size_t size, u32 flags)
> > > > > > >  		goto err_dev_put;
> > > > > > >  	}
> > > > > > >  
> > > > > > > +	refcount_set(&shm->refcount, 1);
> > > > > > >  	shm->flags = flags | TEE_SHM_POOL;
> > > > > > >  	shm->ctx = ctx;
> > > > > > >  	if (flags & TEE_SHM_DMA_BUF)
> > > > > > > @@ -153,10 +104,7 @@ struct tee_shm *tee_shm_alloc(struct tee_context *ctx, size_t size, u32 flags)
> > > > > > >  		goto err_kfree;
> > > > > > >  	}
> > > > > > >  
> > > > > > > -
> > > > > > >  	if (flags & TEE_SHM_DMA_BUF) {
> > > > > > > -		DEFINE_DMA_BUF_EXPORT_INFO(exp_info);
> > > > > > > -
> > > > > > >  		mutex_lock(&teedev->mutex);
> > > > > > >  		shm->id = idr_alloc(&teedev->idr, shm, 1, 0, GFP_KERNEL);
> > > > > > >  		mutex_unlock(&teedev->mutex);
> > > > > > > @@ -164,28 +112,11 @@ struct tee_shm *tee_shm_alloc(struct tee_context *ctx, size_t size, u32 flags)
> > > > > > >  			ret = ERR_PTR(shm->id);
> > > > > > >  			goto err_pool_free;
> > > > > > >  		}
> > > > > > > -
> > > > > > > -		exp_info.ops = &tee_shm_dma_buf_ops;
> > > > > > > -		exp_info.size = shm->size;
> > > > > > > -		exp_info.flags = O_RDWR;
> > > > > > > -		exp_info.priv = shm;
> > > > > > > -
> > > > > > > -		shm->dmabuf = dma_buf_export(&exp_info);
> > > > > > > -		if (IS_ERR(shm->dmabuf)) {
> > > > > > > -			ret = ERR_CAST(shm->dmabuf);
> > > > > > > -			goto err_rem;
> > > > > > > -		}
> > > > > > >  	}
> > > > > > >  
> > > > > > >  	teedev_ctx_get(ctx);
> > > > > > >  
> > > > > > >  	return shm;
> > > > > > > -err_rem:
> > > > > > > -	if (flags & TEE_SHM_DMA_BUF) {
> > > > > > > -		mutex_lock(&teedev->mutex);
> > > > > > > -		idr_remove(&teedev->idr, shm->id);
> > > > > > > -		mutex_unlock(&teedev->mutex);
> > > > > > > -	}
> > > > > > >  err_pool_free:
> > > > > > >  	poolm->ops->free(poolm, shm);
> > > > > > >  err_kfree:
> > > > > > > @@ -246,6 +177,7 @@ struct tee_shm *tee_shm_register(struct tee_context *ctx, unsigned long addr,
> > > > > > >  		goto err;
> > > > > > >  	}
> > > > > > >  
> > > > > > > +	refcount_set(&shm->refcount, 1);
> > > > > > >  	shm->flags = flags | TEE_SHM_REGISTER;
> > > > > > >  	shm->ctx = ctx;
> > > > > > >  	shm->id = -1;
> > > > > > > @@ -306,22 +238,6 @@ struct tee_shm *tee_shm_register(struct tee_context *ctx, unsigned long addr,
> > > > > > >  		goto err;
> > > > > > >  	}
> > > > > > >  
> > > > > > > -	if (flags & TEE_SHM_DMA_BUF) {
> > > > > > > -		DEFINE_DMA_BUF_EXPORT_INFO(exp_info);
> > > > > > > -
> > > > > > > -		exp_info.ops = &tee_shm_dma_buf_ops;
> > > > > > > -		exp_info.size = shm->size;
> > > > > > > -		exp_info.flags = O_RDWR;
> > > > > > > -		exp_info.priv = shm;
> > > > > > > -
> > > > > > > -		shm->dmabuf = dma_buf_export(&exp_info);
> > > > > > > -		if (IS_ERR(shm->dmabuf)) {
> > > > > > > -			ret = ERR_CAST(shm->dmabuf);
> > > > > > > -			teedev->desc->ops->shm_unregister(ctx, shm);
> > > > > > > -			goto err;
> > > > > > > -		}
> > > > > > > -	}
> > > > > > > -
> > > > > > >  	return shm;
> > > > > > >  err:
> > > > > > >  	if (shm) {
> > > > > > > @@ -339,6 +255,35 @@ struct tee_shm *tee_shm_register(struct tee_context *ctx, unsigned long addr,
> > > > > > >  }
> > > > > > >  EXPORT_SYMBOL_GPL(tee_shm_register);
> > > > > > >  
> > > > > > > +static int tee_shm_fop_release(struct inode *inode, struct file *filp)
> > > > > > > +{
> > > > > > > +	tee_shm_put(filp->private_data);
> > > > > > > +	return 0;
> > > > > > > +}
> > > > > > > +
> > > > > > > +static int tee_shm_fop_mmap(struct file *filp, struct vm_area_struct *vma)
> > > > > > > +{
> > > > > > > +	struct tee_shm *shm = filp->private_data;
> > > > > > > +	size_t size = vma->vm_end - vma->vm_start;
> > > > > > > +
> > > > > > > +	/* Refuse sharing shared memory provided by application */
> > > > > > > +	if (shm->flags & TEE_SHM_USER_MAPPED)
> > > > > > > +		return -EINVAL;
> > > > > > > +
> > > > > > > +	/* check for overflowing the buffer's size */
> > > > > > > +	if (vma->vm_pgoff + vma_pages(vma) > shm->size >> PAGE_SHIFT)
> > > > > > > +		return -EINVAL;
> > > > > > > +
> > > > > > > +	return remap_pfn_range(vma, vma->vm_start, shm->paddr >> PAGE_SHIFT,
> > > > > > > +			       size, vma->vm_page_prot);
> > > > > > > +}
> > > > > > > +
> > > > > > > +static const struct file_operations tee_shm_fops = {
> > > > > > > +	.owner = THIS_MODULE,
> > > > > > > +	.release = tee_shm_fop_release,
> > > > > > > +	.mmap = tee_shm_fop_mmap,
> > > > > > > +};
> > > > > > > +
> > > > > > >  /**
> > > > > > >   * tee_shm_get_fd() - Increase reference count and return file descriptor
> > > > > > >   * @shm:	Shared memory handle
> > > > > > > @@ -351,10 +296,11 @@ int tee_shm_get_fd(struct tee_shm *shm)
> > > > > > >  	if (!(shm->flags & TEE_SHM_DMA_BUF))
> > > > > > >  		return -EINVAL;
> > > > > > >  
> > > > > > > -	get_dma_buf(shm->dmabuf);
> > > > > > > -	fd = dma_buf_fd(shm->dmabuf, O_CLOEXEC);
> > > > > > > +	/* matched by tee_shm_put() in tee_shm_op_release() */
> > > > > > > +	refcount_inc(&shm->refcount);
> > > > > > > +	fd = anon_inode_getfd("tee_shm", &tee_shm_fops, shm, O_RDWR);
> > > > > > >  	if (fd < 0)
> > > > > > > -		dma_buf_put(shm->dmabuf);
> > > > > > > +		tee_shm_put(shm);
> > > > > > >  	return fd;
> > > > > > >  }
> > > > > > >  
> > > > > > > @@ -364,17 +310,7 @@ int tee_shm_get_fd(struct tee_shm *shm)
> > > > > > >   */
> > > > > > >  void tee_shm_free(struct tee_shm *shm)
> > > > > > >  {
> > > > > > > -	/*
> > > > > > > -	 * dma_buf_put() decreases the dmabuf reference counter and will
> > > > > > > -	 * call tee_shm_release() when the last reference is gone.
> > > > > > > -	 *
> > > > > > > -	 * In the case of driver private memory we call tee_shm_release
> > > > > > > -	 * directly instead as it doesn't have a reference counter.
> > > > > > > -	 */
> > > > > > > -	if (shm->flags & TEE_SHM_DMA_BUF)
> > > > > > > -		dma_buf_put(shm->dmabuf);
> > > > > > > -	else
> > > > > > > -		tee_shm_release(shm);
> > > > > > > +	tee_shm_put(shm);
> > > > > > >  }
> > > > > > >  EXPORT_SYMBOL_GPL(tee_shm_free);
> > > > > > >  
> > > > > > > @@ -481,10 +417,15 @@ struct tee_shm *tee_shm_get_from_id(struct tee_context *ctx, int id)
> > > > > > >  	teedev = ctx->teedev;
> > > > > > >  	mutex_lock(&teedev->mutex);
> > > > > > >  	shm = idr_find(&teedev->idr, id);
> > > > > > > +	/*
> > > > > > > +	 * If the tee_shm was found in the IDR it must have a refcount
> > > > > > > +	 * larger than 0 due to the guarantee in tee_shm_put() below. So
> > > > > > > +	 * it's safe to use refcount_inc().
> > > > > > > +	 */
> > > > > > >  	if (!shm || shm->ctx != ctx)
> > > > > > >  		shm = ERR_PTR(-EINVAL);
> > > > > > > -	else if (shm->flags & TEE_SHM_DMA_BUF)
> > > > > > > -		get_dma_buf(shm->dmabuf);
> > > > > > > +	else
> > > > > > > +		refcount_inc(&shm->refcount);
> > > > > > >  	mutex_unlock(&teedev->mutex);
> > > > > > >  	return shm;
> > > > > > >  }
> > > > > > > @@ -496,7 +437,24 @@ EXPORT_SYMBOL_GPL(tee_shm_get_from_id);
> > > > > > >   */
> > > > > > >  void tee_shm_put(struct tee_shm *shm)
> > > > > > >  {
> > > > > > > -	if (shm->flags & TEE_SHM_DMA_BUF)
> > > > > > > -		dma_buf_put(shm->dmabuf);
> > > > > > > +	struct tee_device *teedev = shm->ctx->teedev;
> > > > > > > +	bool do_release = false;
> > > > > > > +
> > > > > > > +	mutex_lock(&teedev->mutex);
> > > > > > > +	if (refcount_dec_and_test(&shm->refcount)) {
> > > > > > > +		/*
> > > > > > > +		 * refcount has reached 0, we must now remove it from the
> > > > > > > +		 * IDR before releasing the mutex. This will guarantee that
> > > > > > > +		 * the refcount_inc() in tee_shm_get_from_id() never starts
> > > > > > > +		 * from 0.
> > > > > > > +		 */
> > > > > > > +		if (shm->flags & TEE_SHM_DMA_BUF)
> > > > > > > +			idr_remove(&teedev->idr, shm->id);
> > > > > > > +		do_release = true;
> > > > > > 
> > > > > > As you are using a refcount in the "traditional" way, why not just use a
> > > > > > kref instead?  That solves your "do_release" mess here.
> > > > > 
> > > > > Yes, but it adds another problem. I don't want to hold the mutex when
> > > > > calling tee_shm_release() so that would mean moving idr_remove() to
> > > > > tee_shm_release() again and then use kref_get_unless_zero() in
> > > > > tee_shm_get_from_id() instead.
> > > > 
> > > > Why does the idr have anything to do with it here?  Once you are "done"
> > > > with the object, remove the entry from the idr and that's it.  You
> > > > should never have to mess with kref_get_unless_zero(), that's what locks
> > > > are for.
> > > 
> > > I hope it becomes more clear below.
> > > 
> > > > > With this approach the tee_shm is removed from the IDR so it cannot be
> > > > > seen any longer when the refcount is 0. I tried implementing it in both
> > > > > ways before and in my opinion this turned out better.
> > > > 
> > > > Really?  Something feels wrong here.  tee_release_device() should drop
> > > > the reference from the idr structure as then you know that userspace can
> > > > not grab any new references to it and should not need to look it up
> > > > again from anything.  Then in your final kref_put() call, in the release
> > > > callback for that, free the memory.
> > > 
> > > I assume you mean tee_shm_release().
> > > 
> > > As I understand it you're describing more or less how it worked before
> > > this patch, the only significant difference I see is that it was the
> > > release callback from the DMA-buf that called tee_shm_release() instead
> > > of kref_put() as you suggest. With that we have a window where the
> > > reference counter is 0, but the tee_shm is still in the IDR. If another
> > > thread, perhaps malicious, calls tee_shm_get_from_id() it may be able to
> > > grab the mutex before tee_shm_release(). If we just increase the
> > > reference counter without checking if it's 0 to start with or not then
> > > we're in trouble.
> > 
> > Your device has to have a lock outside of it in order for this to work
> > no matter what.  Your patch doesn't change that, you can't grab a lock
> > for yourself to then check if that pointer was valid or not :)
> 
> That's what teedev->mutex is for, to protect those small critical
> sections. Where not dealing with the life time of the tee_device here,
> only the tee_shm protocted with the outside teedev->mutex.
> 
> I'm afraid I'm maybe missing your point though.
> 
> > Why not properly reference count your shm objects in the tee object?
> 
> I thought that was what I was doing.
> 
> > That way when the last reference to a shm object is dropped, it cleans
> > itself up and gets rid of the idr entry (under the device mutex).  Then
> > it drops the reference to the tee object, and if that was the last
> > reference on the tee object, it too will be freed.
> 
> That would work well _if_ we could hold teedev->mutex while calling
> tee_shm_release(). Unfortunately that's not possible because that
> function calls teedev->desc->ops->shm_unregister() (pointing to for
> instance optee_shm_unregister() in drivers/tee/optee/smc_abi.c). We
> can't hold teedev->mutex while calling into OP-TEE in secure world
> because we may need to allocate a new temporary tee_shm as part of the
> call into secure world. Even if there was a way around that it would be
> to ask for problems to hold such a mutex while doing calls into secure
> world.
> 
> > That's what kobjects do, and while you probably don't want to use a full
> > kobject here, the same idea is relevant.
> > 
> > If people can randomly grab shm objects, then they need to be reference
> > counted properly.
> 
> That's what tee_shm_get_from_id() is for. There is no need for a pure
> get function, the combined one is the only one needed.
> tee_shm_get_from_id() is called on all involved tee_shm's during the
> start of the syscall and then put at the end of the syscall.

Ok, maybe I got this all wrong.  Let me look at this again...
