Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA8210D715
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 15:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726879AbfK2OfC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Nov 2019 09:35:02 -0500
Received: from foss.arm.com ([217.140.110.172]:48558 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726808AbfK2OfC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 29 Nov 2019 09:35:02 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 910E91FB;
        Fri, 29 Nov 2019 06:35:01 -0800 (PST)
Received: from [10.1.194.43] (e112269-lin.cambridge.arm.com [10.1.194.43])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C148F3F52E;
        Fri, 29 Nov 2019 06:35:00 -0800 (PST)
Subject: Re: [PATCH 5/8] drm/panfrost: Open/close the perfcnt BO
To:     Boris Brezillon <boris.brezillon@collabora.com>,
        Rob Herring <robh+dt@kernel.org>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>
Cc:     stable@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <20191129135908.2439529-1-boris.brezillon@collabora.com>
 <20191129135908.2439529-6-boris.brezillon@collabora.com>
From:   Steven Price <steven.price@arm.com>
Message-ID: <f2928095-c117-580a-ac3d-efe073429b65@arm.com>
Date:   Fri, 29 Nov 2019 14:34:59 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191129135908.2439529-6-boris.brezillon@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 29/11/2019 13:59, Boris Brezillon wrote:
> Commit a5efb4c9a562 ("drm/panfrost: Restructure the GEM object creation")
> moved the drm_mm_insert_node_generic() call to the gem->open() hook,
> but forgot to update perfcnt accordingly.
> 
> Patch the perfcnt logic to call panfrost_gem_open/close() where
> appropriate.
> 
> Fixes: a5efb4c9a562 ("drm/panfrost: Restructure the GEM object creation")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>

Reviewed-by: Steven Price <steven.price@arm.com>

Steve

> ---
>  drivers/gpu/drm/panfrost/panfrost_drv.c     |  2 +-
>  drivers/gpu/drm/panfrost/panfrost_gem.c     |  4 ++--
>  drivers/gpu/drm/panfrost/panfrost_gem.h     |  4 ++++
>  drivers/gpu/drm/panfrost/panfrost_perfcnt.c | 23 +++++++++++++--------
>  drivers/gpu/drm/panfrost/panfrost_perfcnt.h |  2 +-
>  5 files changed, 22 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/gpu/drm/panfrost/panfrost_drv.c b/drivers/gpu/drm/panfrost/panfrost_drv.c
> index 2630c5027c63..1c67ac434e10 100644
> --- a/drivers/gpu/drm/panfrost/panfrost_drv.c
> +++ b/drivers/gpu/drm/panfrost/panfrost_drv.c
> @@ -445,7 +445,7 @@ panfrost_postclose(struct drm_device *dev, struct drm_file *file)
>  {
>  	struct panfrost_file_priv *panfrost_priv = file->driver_priv;
>  
> -	panfrost_perfcnt_close(panfrost_priv);
> +	panfrost_perfcnt_close(file);
>  	panfrost_job_close(panfrost_priv);
>  
>  	panfrost_mmu_pgtable_free(panfrost_priv);
> diff --git a/drivers/gpu/drm/panfrost/panfrost_gem.c b/drivers/gpu/drm/panfrost/panfrost_gem.c
> index daf4c55a2863..92a95210a899 100644
> --- a/drivers/gpu/drm/panfrost/panfrost_gem.c
> +++ b/drivers/gpu/drm/panfrost/panfrost_gem.c
> @@ -46,7 +46,7 @@ static void panfrost_gem_free_object(struct drm_gem_object *obj)
>  	drm_gem_shmem_free_object(obj);
>  }
>  
> -static int panfrost_gem_open(struct drm_gem_object *obj, struct drm_file *file_priv)
> +int panfrost_gem_open(struct drm_gem_object *obj, struct drm_file *file_priv)
>  {
>  	int ret;
>  	size_t size = obj->size;
> @@ -85,7 +85,7 @@ static int panfrost_gem_open(struct drm_gem_object *obj, struct drm_file *file_p
>  	return ret;
>  }
>  
> -static void panfrost_gem_close(struct drm_gem_object *obj, struct drm_file *file_priv)
> +void panfrost_gem_close(struct drm_gem_object *obj, struct drm_file *file_priv)
>  {
>  	struct panfrost_gem_object *bo = to_panfrost_bo(obj);
>  	struct panfrost_file_priv *priv = file_priv->driver_priv;
> diff --git a/drivers/gpu/drm/panfrost/panfrost_gem.h b/drivers/gpu/drm/panfrost/panfrost_gem.h
> index 50920819cc16..4b17e7308764 100644
> --- a/drivers/gpu/drm/panfrost/panfrost_gem.h
> +++ b/drivers/gpu/drm/panfrost/panfrost_gem.h
> @@ -45,6 +45,10 @@ panfrost_gem_create_with_handle(struct drm_file *file_priv,
>  				u32 flags,
>  				uint32_t *handle);
>  
> +int panfrost_gem_open(struct drm_gem_object *obj, struct drm_file *file_priv);
> +void panfrost_gem_close(struct drm_gem_object *obj,
> +			struct drm_file *file_priv);
> +
>  void panfrost_gem_shrinker_init(struct drm_device *dev);
>  void panfrost_gem_shrinker_cleanup(struct drm_device *dev);
>  
> diff --git a/drivers/gpu/drm/panfrost/panfrost_perfcnt.c b/drivers/gpu/drm/panfrost/panfrost_perfcnt.c
> index 2dba192bf198..2c04e858c50a 100644
> --- a/drivers/gpu/drm/panfrost/panfrost_perfcnt.c
> +++ b/drivers/gpu/drm/panfrost/panfrost_perfcnt.c
> @@ -67,9 +67,10 @@ static int panfrost_perfcnt_dump_locked(struct panfrost_device *pfdev)
>  }
>  
>  static int panfrost_perfcnt_enable_locked(struct panfrost_device *pfdev,
> -					  struct panfrost_file_priv *user,
> +					  struct drm_file *file_priv,
>  					  unsigned int counterset)
>  {
> +	struct panfrost_file_priv *user = file_priv->driver_priv;
>  	struct panfrost_perfcnt *perfcnt = pfdev->perfcnt;
>  	struct drm_gem_shmem_object *bo;
>  	u32 cfg;
> @@ -91,14 +92,14 @@ static int panfrost_perfcnt_enable_locked(struct panfrost_device *pfdev,
>  	perfcnt->bo = to_panfrost_bo(&bo->base);
>  
>  	/* Map the perfcnt buf in the address space attached to file_priv. */
> -	ret = panfrost_mmu_map(perfcnt->bo);
> +	ret = panfrost_gem_open(&perfcnt->bo->base.base, file_priv);
>  	if (ret)
>  		goto err_put_bo;
>  
>  	perfcnt->buf = drm_gem_shmem_vmap(&bo->base);
>  	if (IS_ERR(perfcnt->buf)) {
>  		ret = PTR_ERR(perfcnt->buf);
> -		goto err_put_bo;
> +		goto err_close_bo;
>  	}
>  
>  	/*
> @@ -157,14 +158,17 @@ static int panfrost_perfcnt_enable_locked(struct panfrost_device *pfdev,
>  
>  err_vunmap:
>  	drm_gem_shmem_vunmap(&perfcnt->bo->base.base, perfcnt->buf);
> +err_close_bo:
> +	panfrost_gem_close(&perfcnt->bo->base.base, file_priv);
>  err_put_bo:
>  	drm_gem_object_put_unlocked(&bo->base);
>  	return ret;
>  }
>  
>  static int panfrost_perfcnt_disable_locked(struct panfrost_device *pfdev,
> -					   struct panfrost_file_priv *user)
> +					   struct drm_file *file_priv)
>  {
> +	struct panfrost_file_priv *user = file_priv->driver_priv;
>  	struct panfrost_perfcnt *perfcnt = pfdev->perfcnt;
>  
>  	if (user != perfcnt->user)
> @@ -180,6 +184,7 @@ static int panfrost_perfcnt_disable_locked(struct panfrost_device *pfdev,
>  	perfcnt->user = NULL;
>  	drm_gem_shmem_vunmap(&perfcnt->bo->base.base, perfcnt->buf);
>  	perfcnt->buf = NULL;
> +	panfrost_gem_close(&perfcnt->bo->base.base, file_priv);
>  	drm_gem_object_put_unlocked(&perfcnt->bo->base.base);
>  	perfcnt->bo = NULL;
>  	pm_runtime_mark_last_busy(pfdev->dev);
> @@ -191,7 +196,6 @@ static int panfrost_perfcnt_disable_locked(struct panfrost_device *pfdev,
>  int panfrost_ioctl_perfcnt_enable(struct drm_device *dev, void *data,
>  				  struct drm_file *file_priv)
>  {
> -	struct panfrost_file_priv *pfile = file_priv->driver_priv;
>  	struct panfrost_device *pfdev = dev->dev_private;
>  	struct panfrost_perfcnt *perfcnt = pfdev->perfcnt;
>  	struct drm_panfrost_perfcnt_enable *req = data;
> @@ -207,10 +211,10 @@ int panfrost_ioctl_perfcnt_enable(struct drm_device *dev, void *data,
>  
>  	mutex_lock(&perfcnt->lock);
>  	if (req->enable)
> -		ret = panfrost_perfcnt_enable_locked(pfdev, pfile,
> +		ret = panfrost_perfcnt_enable_locked(pfdev, file_priv,
>  						     req->counterset);
>  	else
> -		ret = panfrost_perfcnt_disable_locked(pfdev, pfile);
> +		ret = panfrost_perfcnt_disable_locked(pfdev, file_priv);
>  	mutex_unlock(&perfcnt->lock);
>  
>  	return ret;
> @@ -248,15 +252,16 @@ int panfrost_ioctl_perfcnt_dump(struct drm_device *dev, void *data,
>  	return ret;
>  }
>  
> -void panfrost_perfcnt_close(struct panfrost_file_priv *pfile)
> +void panfrost_perfcnt_close(struct drm_file *file_priv)
>  {
> +	struct panfrost_file_priv *pfile = file_priv->driver_priv;
>  	struct panfrost_device *pfdev = pfile->pfdev;
>  	struct panfrost_perfcnt *perfcnt = pfdev->perfcnt;
>  
>  	pm_runtime_get_sync(pfdev->dev);
>  	mutex_lock(&perfcnt->lock);
>  	if (perfcnt->user == pfile)
> -		panfrost_perfcnt_disable_locked(pfdev, pfile);
> +		panfrost_perfcnt_disable_locked(pfdev, file_priv);
>  	mutex_unlock(&perfcnt->lock);
>  	pm_runtime_mark_last_busy(pfdev->dev);
>  	pm_runtime_put_autosuspend(pfdev->dev);
> diff --git a/drivers/gpu/drm/panfrost/panfrost_perfcnt.h b/drivers/gpu/drm/panfrost/panfrost_perfcnt.h
> index 13b8fdaa1b43..8bbcf5f5fb33 100644
> --- a/drivers/gpu/drm/panfrost/panfrost_perfcnt.h
> +++ b/drivers/gpu/drm/panfrost/panfrost_perfcnt.h
> @@ -9,7 +9,7 @@ void panfrost_perfcnt_sample_done(struct panfrost_device *pfdev);
>  void panfrost_perfcnt_clean_cache_done(struct panfrost_device *pfdev);
>  int panfrost_perfcnt_init(struct panfrost_device *pfdev);
>  void panfrost_perfcnt_fini(struct panfrost_device *pfdev);
> -void panfrost_perfcnt_close(struct panfrost_file_priv *pfile);
> +void panfrost_perfcnt_close(struct drm_file *file_priv);
>  int panfrost_ioctl_perfcnt_enable(struct drm_device *dev, void *data,
>  				  struct drm_file *file_priv);
>  int panfrost_ioctl_perfcnt_dump(struct drm_device *dev, void *data,
> 

