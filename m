Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9567014FE5B
	for <lists+stable@lfdr.de>; Sun,  2 Feb 2020 17:42:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbgBBQmM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Feb 2020 11:42:12 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43235 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726885AbgBBQmM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Feb 2020 11:42:12 -0500
Received: by mail-wr1-f66.google.com with SMTP id z9so2672675wrs.10
        for <stable@vger.kernel.org>; Sun, 02 Feb 2020 08:42:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=B2z3mogKcy0xJhRngVdq+5os5lXZKpIatWVOL2fLzG8=;
        b=luu/SpSE04/8sOOPQCMT68BFHhhJWll3v0mesXR+eM76/2WqGezDN+cz5wr7IHDvOs
         gfXJAq3nbMrGQorcbtJm+/Z8t5ljp5Up/hzXiVXDR6kz3cNIVa8r3j39x2cgXA6N5T04
         evEEf6ln1sth8koPJG2J8pobYmoCYUHKPFbjM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=B2z3mogKcy0xJhRngVdq+5os5lXZKpIatWVOL2fLzG8=;
        b=BoXIVxyGEI2eU5YMHG80Ewzuzf5gTbLzCtFBKkscu30br9hsoSn6lJRRGFyO9pB7wM
         IFcQUuHyC0YYFmQSURtukXUFxoIO/7eSii0f8QwJBQMwt7vU9UllD9IAf5tqas3y7m0v
         1nmvMXc1TWDAqPD76vIRbihW/l8WWR8vqy+pkobYCfC43/3Srd6ReDgGjB0aPWQBjwms
         9qujQx5hybS5PrdDd31k1cxCDDQ0oPhtxqiAiJJfSVtWDtAJugRVGX77XKdsPtiuzM5H
         UikO9DoUThTzL2sIgZXtDKXkEDZBCRUBzrnTDZIAqHHQttgP+dykWXcIfTnN0Ov5QPSw
         E5hg==
X-Gm-Message-State: APjAAAVLkYLLG/wDEj5ks8ZSMgLoE1+7kucNxZeHj17PnHmqIFlsgpVU
        iziHxD0jCyUJ0Nr05FCRFe5+sw==
X-Google-Smtp-Source: APXvYqze0DZAhRmfkC5IRlmqXX/qBqys//AAmWc1M4GUPpdT3cKjU9I3dmFbKQ8PwG/y36iae995rQ==
X-Received: by 2002:adf:e746:: with SMTP id c6mr10238712wrn.323.1580661729637;
        Sun, 02 Feb 2020 08:42:09 -0800 (PST)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id k7sm19369213wmi.19.2020.02.02.08.42.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Feb 2020 08:42:08 -0800 (PST)
Date:   Sun, 2 Feb 2020 17:42:07 +0100
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Wean off drm_pci_alloc/drm_pci_free
Message-ID: <20200202164207.GP43062@phenom.ffwll.local>
References: <20200202153934.3899472-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200202153934.3899472-1-chris@chris-wilson.co.uk>
X-Operating-System: Linux phenom 5.3.0-3-amd64 
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 02, 2020 at 03:39:34PM +0000, Chris Wilson wrote:
> drm_pci_alloc and drm_pci_free are just very thin wrappers around
> dma_alloc_coherent, with a note that we should be removing them.
> Furthermore since
> 
> commit de09d31dd38a50fdce106c15abd68432eebbd014
> Author: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Date:   Fri Jan 15 16:51:42 2016 -0800
> 
>     page-flags: define PG_reserved behavior on compound pages
> 
>     As far as I can see there's no users of PG_reserved on compound pages.
>     Let's use PF_NO_COMPOUND here.
> 
> drm_pci_alloc has been declared broken since it mixes GFP_COMP and
> SetPageReserved. Avoid this conflict by weaning ourselves off using the
> abstraction and using the dma functions directly.
> 
> Reported-by: Taketo Kabe
> Closes: https://gitlab.freedesktop.org/drm/intel/issues/1027
> Fixes: de09d31dd38a ("page-flags: define PG_reserved behavior on compound pages")
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: <stable@vger.kernel.org> # v4.5+

Assuming i915gm or whatever phys_cursor machine you have around is still
happy with all that (not even sure we ever managed to create igts for
testing the cursor on these properly).

Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>

> ---
>  drivers/gpu/drm/i915/display/intel_display.c  |  2 +-
>  .../gpu/drm/i915/gem/i915_gem_object_types.h  |  3 -
>  drivers/gpu/drm/i915/gem/i915_gem_phys.c      | 98 ++++++++++---------
>  drivers/gpu/drm/i915/i915_gem.c               |  8 +-
>  4 files changed, 55 insertions(+), 56 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/drm/i915/display/intel_display.c
> index b0af37fb6d4a..1f584263aa97 100644
> --- a/drivers/gpu/drm/i915/display/intel_display.c
> +++ b/drivers/gpu/drm/i915/display/intel_display.c
> @@ -11234,7 +11234,7 @@ static u32 intel_cursor_base(const struct intel_plane_state *plane_state)
>  	u32 base;
>  
>  	if (INTEL_INFO(dev_priv)->display.cursor_needs_physical)
> -		base = obj->phys_handle->busaddr;
> +		base = sg_dma_address(obj->mm.pages->sgl);
>  	else
>  		base = intel_plane_ggtt_offset(plane_state);
>  
> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_object_types.h b/drivers/gpu/drm/i915/gem/i915_gem_object_types.h
> index f64ad77e6b1e..c2174da35bb0 100644
> --- a/drivers/gpu/drm/i915/gem/i915_gem_object_types.h
> +++ b/drivers/gpu/drm/i915/gem/i915_gem_object_types.h
> @@ -285,9 +285,6 @@ struct drm_i915_gem_object {
>  
>  		void *gvt_info;
>  	};
> -
> -	/** for phys allocated objects */
> -	struct drm_dma_handle *phys_handle;
>  };
>  
>  static inline struct drm_i915_gem_object *
> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_phys.c b/drivers/gpu/drm/i915/gem/i915_gem_phys.c
> index b1b7c1b3038a..b07bb40edd5a 100644
> --- a/drivers/gpu/drm/i915/gem/i915_gem_phys.c
> +++ b/drivers/gpu/drm/i915/gem/i915_gem_phys.c
> @@ -22,88 +22,87 @@
>  static int i915_gem_object_get_pages_phys(struct drm_i915_gem_object *obj)
>  {
>  	struct address_space *mapping = obj->base.filp->f_mapping;
> -	struct drm_dma_handle *phys;
> -	struct sg_table *st;
>  	struct scatterlist *sg;
> -	char *vaddr;
> +	struct sg_table *st;
> +	dma_addr_t dma;
> +	void *vaddr;
> +	void *dst;
>  	int i;
> -	int err;
>  
>  	if (WARN_ON(i915_gem_object_needs_bit17_swizzle(obj)))
>  		return -EINVAL;
>  
> -	/* Always aligning to the object size, allows a single allocation
> +	/*
> +	 * Always aligning to the object size, allows a single allocation
>  	 * to handle all possible callers, and given typical object sizes,
>  	 * the alignment of the buddy allocation will naturally match.
>  	 */
> -	phys = drm_pci_alloc(obj->base.dev,
> -			     roundup_pow_of_two(obj->base.size),
> -			     roundup_pow_of_two(obj->base.size));
> -	if (!phys)
> +	vaddr = dma_alloc_coherent(&obj->base.dev->pdev->dev,
> +				   roundup_pow_of_two(obj->base.size),
> +				   &dma, GFP_KERNEL);
> +	if (!vaddr)
>  		return -ENOMEM;
>  
> -	vaddr = phys->vaddr;
> +	st = kmalloc(sizeof(*st), GFP_KERNEL);
> +	if (!st)
> +		goto err_pci;
> +
> +	if (sg_alloc_table(st, 1, GFP_KERNEL))
> +		goto err_st;
> +
> +	sg = st->sgl;
> +	sg->offset = 0;
> +	sg->length = obj->base.size;
> +
> +	sg_assign_page(sg, (struct page *)vaddr);
> +	sg_dma_address(sg) = dma;
> +	sg_dma_len(sg) = obj->base.size;
> +
> +	dst = vaddr;
>  	for (i = 0; i < obj->base.size / PAGE_SIZE; i++) {
>  		struct page *page;
> -		char *src;
> +		void *src;
>  
>  		page = shmem_read_mapping_page(mapping, i);
> -		if (IS_ERR(page)) {
> -			err = PTR_ERR(page);
> -			goto err_phys;
> -		}
> +		if (IS_ERR(page))
> +			goto err_st;
>  
>  		src = kmap_atomic(page);
> -		memcpy(vaddr, src, PAGE_SIZE);
> -		drm_clflush_virt_range(vaddr, PAGE_SIZE);
> +		memcpy(dst, src, PAGE_SIZE);
> +		drm_clflush_virt_range(dst, PAGE_SIZE);
>  		kunmap_atomic(src);
>  
>  		put_page(page);
> -		vaddr += PAGE_SIZE;
> +		dst += PAGE_SIZE;
>  	}
>  
>  	intel_gt_chipset_flush(&to_i915(obj->base.dev)->gt);
>  
> -	st = kmalloc(sizeof(*st), GFP_KERNEL);
> -	if (!st) {
> -		err = -ENOMEM;
> -		goto err_phys;
> -	}
> -
> -	if (sg_alloc_table(st, 1, GFP_KERNEL)) {
> -		kfree(st);
> -		err = -ENOMEM;
> -		goto err_phys;
> -	}
> -
> -	sg = st->sgl;
> -	sg->offset = 0;
> -	sg->length = obj->base.size;
> -
> -	sg_dma_address(sg) = phys->busaddr;
> -	sg_dma_len(sg) = obj->base.size;
> -
> -	obj->phys_handle = phys;
> -
>  	__i915_gem_object_set_pages(obj, st, sg->length);
>  
>  	return 0;
>  
> -err_phys:
> -	drm_pci_free(obj->base.dev, phys);
> -
> -	return err;
> +err_st:
> +	kfree(st);
> +err_pci:
> +	dma_free_coherent(&obj->base.dev->pdev->dev,
> +			  roundup_pow_of_two(obj->base.size),
> +			  vaddr, dma);
> +	return -ENOMEM;
>  }
>  
>  static void
>  i915_gem_object_put_pages_phys(struct drm_i915_gem_object *obj,
>  			       struct sg_table *pages)
>  {
> +	dma_addr_t dma = sg_dma_address(pages->sgl);
> +	void *vaddr = sg_page(pages->sgl);
> +
>  	__i915_gem_object_release_shmem(obj, pages, false);
>  
>  	if (obj->mm.dirty) {
>  		struct address_space *mapping = obj->base.filp->f_mapping;
> -		char *vaddr = obj->phys_handle->vaddr;
> +		void *src = vaddr;
>  		int i;
>  
>  		for (i = 0; i < obj->base.size / PAGE_SIZE; i++) {
> @@ -115,15 +114,16 @@ i915_gem_object_put_pages_phys(struct drm_i915_gem_object *obj,
>  				continue;
>  
>  			dst = kmap_atomic(page);
> -			drm_clflush_virt_range(vaddr, PAGE_SIZE);
> -			memcpy(dst, vaddr, PAGE_SIZE);
> +			drm_clflush_virt_range(src, PAGE_SIZE);
> +			memcpy(dst, src, PAGE_SIZE);
>  			kunmap_atomic(dst);
>  
>  			set_page_dirty(page);
>  			if (obj->mm.madv == I915_MADV_WILLNEED)
>  				mark_page_accessed(page);
>  			put_page(page);
> -			vaddr += PAGE_SIZE;
> +
> +			src += PAGE_SIZE;
>  		}
>  		obj->mm.dirty = false;
>  	}
> @@ -131,7 +131,9 @@ i915_gem_object_put_pages_phys(struct drm_i915_gem_object *obj,
>  	sg_free_table(pages);
>  	kfree(pages);
>  
> -	drm_pci_free(obj->base.dev, obj->phys_handle);
> +	dma_free_coherent(&obj->base.dev->pdev->dev,
> +			  roundup_pow_of_two(obj->base.size),
> +			  vaddr, dma);
>  }
>  
>  static void phys_release(struct drm_i915_gem_object *obj)
> diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
> index 7245e056ce77..a712e60b016a 100644
> --- a/drivers/gpu/drm/i915/i915_gem.c
> +++ b/drivers/gpu/drm/i915/i915_gem.c
> @@ -180,7 +180,7 @@ i915_gem_phys_pwrite(struct drm_i915_gem_object *obj,
>  		     struct drm_i915_gem_pwrite *args,
>  		     struct drm_file *file)
>  {
> -	void *vaddr = obj->phys_handle->vaddr + args->offset;
> +	void *vaddr = sg_page(obj->mm.pages->sgl) + args->offset;
>  	char __user *user_data = u64_to_user_ptr(args->data_ptr);
>  
>  	/*
> @@ -844,10 +844,10 @@ i915_gem_pwrite_ioctl(struct drm_device *dev, void *data,
>  		ret = i915_gem_gtt_pwrite_fast(obj, args);
>  
>  	if (ret == -EFAULT || ret == -ENOSPC) {
> -		if (obj->phys_handle)
> -			ret = i915_gem_phys_pwrite(obj, args, file);
> -		else
> +		if (i915_gem_object_has_struct_page(obj))
>  			ret = i915_gem_shmem_pwrite(obj, args);
> +		else
> +			ret = i915_gem_phys_pwrite(obj, args, file);
>  	}
>  
>  	i915_gem_object_unpin_pages(obj);
> -- 
> 2.25.0
> 
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/intel-gfx

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
