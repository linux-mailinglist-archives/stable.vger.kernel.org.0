Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D9AC10DA79
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 21:12:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbfK2UMU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Nov 2019 15:12:20 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38806 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726926AbfK2UMU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Nov 2019 15:12:20 -0500
Received: by mail-wr1-f66.google.com with SMTP id i12so36645349wro.5
        for <stable@vger.kernel.org>; Fri, 29 Nov 2019 12:12:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3YI+d2NvmVkEloaZilnvp4D1sppM2GPkI8u4Su78MwI=;
        b=Q+yEJbTyD2DOywKyV/g4X6WA2kgZRfVCZGRrnfhlWF0THUjvvkC8uMHOJINEck592H
         wQ/VbaMPFlTuW4hSrXcRzdXfsGgJd1KUBkxA2nYMgm0g16cYKdP7nJVFcsMGPzuiwAWo
         L1gJheOZXJV9js+ormZoQDfJjOcxij0CytfqU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=3YI+d2NvmVkEloaZilnvp4D1sppM2GPkI8u4Su78MwI=;
        b=BFKV/qzp7xHr7Mma66ZRlrAN5PWp1iVwDoO80EN12ZWlVF/L98hlTz16tfzFIdlVmz
         ZLG1u+Lv6vL7mcD+E3zRllGrsVsDqnzMw5OWZzB/Q/I4xZuZqveTfbvEVE+Rot3VrWXg
         IWvGwP4eE9Su0q3pyh3GXvrYvpe3qx9IOZgRw5H4fSN4rUffsuv66AlThifPF3DNQECj
         VoKpCpoKwZLTkRgRwzblqvrDk80O0Yk6JdQvsE/3HdeD3zLYrihWMyj169pJUkO/+1oz
         sG+rME+yEQQYVz/L+lNlH/mhH+kzV29D4xuyyu6g8gXnH03DgJAoes8Ktp7co9G1Szcb
         QaMA==
X-Gm-Message-State: APjAAAVsiFquGYWS3iwKGmThHNidStl5JNKyHyaNrcVkaFWPZNwjX43A
        ykvRDUWoK9fo5lxP+d9ys3DeBg==
X-Google-Smtp-Source: APXvYqwtG45fdmkUsPnDsNlglM4M8netn7p3FnAXaWvyij1hujYYOR9XinVc43pwVOGYPw5BsC9qwg==
X-Received: by 2002:a5d:6408:: with SMTP id z8mr10832347wru.122.1575058336266;
        Fri, 29 Nov 2019 12:12:16 -0800 (PST)
Received: from phenom.ffwll.local (212-51-149-96.fiber7.init7.net. [212.51.149.96])
        by smtp.gmail.com with ESMTPSA id r6sm15353546wrq.92.2019.11.29.12.12.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2019 12:12:15 -0800 (PST)
Date:   Fri, 29 Nov 2019 21:12:13 +0100
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Boris Brezillon <boris.brezillon@collabora.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Steven Price <steven.price@arm.com>, stable@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 6/8] drm/panfrost: Make sure imported/exported BOs are
 never purged
Message-ID: <20191129201213.GR624164@phenom.ffwll.local>
References: <20191129135908.2439529-1-boris.brezillon@collabora.com>
 <20191129135908.2439529-7-boris.brezillon@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191129135908.2439529-7-boris.brezillon@collabora.com>
X-Operating-System: Linux phenom 5.3.0-2-amd64 
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 29, 2019 at 02:59:06PM +0100, Boris Brezillon wrote:
> We don't want imported/exported BOs to be purges, as those are shared
> with other processes that might still use them. We should also refuse
> to export a BO if it's been marked purgeable or has already been purged.
> 
> Fixes: 013b65101315 ("drm/panfrost: Add madvise and shrinker support")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
> ---
>  drivers/gpu/drm/panfrost/panfrost_drv.c | 19 ++++++++++++++++-
>  drivers/gpu/drm/panfrost/panfrost_gem.c | 27 +++++++++++++++++++++++++
>  2 files changed, 45 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/panfrost/panfrost_drv.c b/drivers/gpu/drm/panfrost/panfrost_drv.c
> index 1c67ac434e10..751df975534f 100644
> --- a/drivers/gpu/drm/panfrost/panfrost_drv.c
> +++ b/drivers/gpu/drm/panfrost/panfrost_drv.c
> @@ -343,6 +343,7 @@ static int panfrost_ioctl_madvise(struct drm_device *dev, void *data,
>  	struct drm_panfrost_madvise *args = data;
>  	struct panfrost_device *pfdev = dev->dev_private;
>  	struct drm_gem_object *gem_obj;
> +	int ret;
>  
>  	gem_obj = drm_gem_object_lookup(file_priv, args->handle);
>  	if (!gem_obj) {
> @@ -350,6 +351,19 @@ static int panfrost_ioctl_madvise(struct drm_device *dev, void *data,
>  		return -ENOENT;
>  	}
>  
> +	/*
> +	 * We don't want to mark exported/imported BOs as purgeable: we're not
> +	 * the only owner in that case.
> +	 */
> +	mutex_lock(&dev->object_name_lock);

Kinda not awesome that you have to take this core lock here and encumber
core drm locking with random driver stuff.

Can't this be solved with your own locking only and some reasonable
ordering of checks? big locks because it's easy is endless long-term pain.

Also exporting purgeable objects is kinda a userspace bug, all you have to
do is not oops in dma_buf_attachment_map. No need to prevent the damage
here imo.
-Daniel

> +	if (gem_obj->dma_buf)
> +		ret = -EINVAL;
> +	else
> +		ret = 0;
> +
> +	if (ret)
> +		goto out_unlock_object_name;
> +
>  	mutex_lock(&pfdev->shrinker_lock);
>  	args->retained = drm_gem_shmem_madvise(gem_obj, args->madv);
>  
> @@ -364,8 +378,11 @@ static int panfrost_ioctl_madvise(struct drm_device *dev, void *data,
>  	}
>  	mutex_unlock(&pfdev->shrinker_lock);
>  
> +out_unlock_object_name:
> +	mutex_unlock(&dev->object_name_lock);
> +
>  	drm_gem_object_put_unlocked(gem_obj);
> -	return 0;
> +	return ret;
>  }
>  
>  int panfrost_unstable_ioctl_check(void)
> diff --git a/drivers/gpu/drm/panfrost/panfrost_gem.c b/drivers/gpu/drm/panfrost/panfrost_gem.c
> index 92a95210a899..31d6417dd21c 100644
> --- a/drivers/gpu/drm/panfrost/panfrost_gem.c
> +++ b/drivers/gpu/drm/panfrost/panfrost_gem.c
> @@ -99,6 +99,32 @@ void panfrost_gem_close(struct drm_gem_object *obj, struct drm_file *file_priv)
>  	spin_unlock(&priv->mm_lock);
>  }
>  
> +static struct dma_buf *
> +panfrost_gem_export(struct drm_gem_object *obj, int flags)
> +{
> +	struct panfrost_gem_object *bo = to_panfrost_bo(obj);
> +	int ret;
> +
> +	/*
> +	 * We must make sure the BO has not been marked purgeable/purged before
> +	 * adding the mapping.
> +	 * Note that we don't need to protect this test with a lock because
> +	 * &drm_gem_object_funcs.export() is called with
> +	 * &drm_device.object_lock held, and panfrost_ioctl_madvise() takes
> +	 * this lock before calling drm_gem_shmem_madvise() (the function that
> +	 * modifies bo->base.madv).
> +	 */
> +	if (bo->base.madv == PANFROST_MADV_WILLNEED)
> +		ret = -EINVAL;
> +	else
> +		ret = 0;
> +
> +	if (ret)
> +		return ERR_PTR(ret);
> +
> +	return drm_gem_prime_export(obj, flags);
> +}
> +
>  static int panfrost_gem_pin(struct drm_gem_object *obj)
>  {
>  	if (to_panfrost_bo(obj)->is_heap)
> @@ -112,6 +138,7 @@ static const struct drm_gem_object_funcs panfrost_gem_funcs = {
>  	.open = panfrost_gem_open,
>  	.close = panfrost_gem_close,
>  	.print_info = drm_gem_shmem_print_info,
> +	.export = panfrost_gem_export,
>  	.pin = panfrost_gem_pin,
>  	.unpin = drm_gem_shmem_unpin,
>  	.get_sg_table = drm_gem_shmem_get_sg_table,
> -- 
> 2.23.0
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
