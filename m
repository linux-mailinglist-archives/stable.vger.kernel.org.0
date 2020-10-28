Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0D5629D303
	for <lists+stable@lfdr.de>; Wed, 28 Oct 2020 22:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727162AbgJ1VkX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 28 Oct 2020 17:40:23 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:35134 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727150AbgJ1VkW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Oct 2020 17:40:22 -0400
Received: from localhost (unknown [IPv6:2a01:e0a:2c:6930:5cf4:84a1:2763:fe0d])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bbrezillon)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id AC78B1F447F5;
        Wed, 28 Oct 2020 08:44:18 +0000 (GMT)
Date:   Wed, 28 Oct 2020 09:44:15 +0100
From:   Boris Brezillon <boris.brezillon@collabora.com>
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        Christian =?UTF-8?B?S8O2bmln?= <christian.koenig@amd.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Lucas Stach <l.stach@pengutronix.de>,
        Russell King <linux+etnaviv@armlinux.org.uk>,
        Christian Gmeiner <christian.gmeiner@gmail.com>,
        Inki Dae <inki.dae@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Rob Herring <robh@kernel.org>, linux-media@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org, stable@vger.kernel.org,
        piotr.oniszczuk@gmail.com, Daniel Vetter <daniel.vetter@intel.com>
Subject: Re: [PATCH] drm/shme-helpers: Fix dma_buf_mmap forwarding bug
Message-ID: <20201028094415.7a7782b8@collabora.com>
In-Reply-To: <20201027214922.3566743-1-daniel.vetter@ffwll.ch>
References: <20201027214922.3566743-1-daniel.vetter@ffwll.ch>
Organization: Collabora
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 27 Oct 2020 22:49:22 +0100
Daniel Vetter <daniel.vetter@ffwll.ch> wrote:

> When we forward an mmap to the dma_buf exporter, they get to own
> everything. Unfortunately drm_gem_mmap_obj() overwrote
> vma->vm_private_data after the driver callback, wreaking the
> exporter complete. This was noticed because vb2_common_vm_close blew
> up on mali gpu with panfrost after commit 26d3ac3cb04d
> ("drm/shmem-helpers: Redirect mmap for imported dma-buf").
> 
> Unfortunately drm_gem_mmap_obj also acquires a surplus reference that
> we need to drop in shmem helpers, which is a bit of a mislayer
> situation. Maybe the entire dma_buf_mmap forwarding should be pulled
> into core gem code.
> 
> Note that the only two other drivers which forward mmap in their own
> code (etnaviv and exynos) get this somewhat right by overwriting the
> gem mmap code. But they seem to still have the leak. This might be a
> good excuse to move these drivers over to shmem helpers completely.
> 
> Note to stable team: There's a trivial context conflict with
> d693def4fd1c ("drm: Remove obsolete GEM and PRIME callbacks from
> struct drm_driver"). I'm assuming it's clear where to put the first
> hunk, otherwise I can send a 5.9 version of this.
> 
> Cc: Christian König <christian.koenig@amd.com>
> Cc: Sumit Semwal <sumit.semwal@linaro.org>
> Cc: Lucas Stach <l.stach@pengutronix.de>
> Cc: Russell King <linux+etnaviv@armlinux.org.uk>
> Cc: Christian Gmeiner <christian.gmeiner@gmail.com>
> Cc: Inki Dae <inki.dae@samsung.com>
> Cc: Joonyoung Shim <jy0922.shim@samsung.com>
> Cc: Seung-Woo Kim <sw0312.kim@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Fixes: 26d3ac3cb04d ("drm/shmem-helpers: Redirect mmap for imported dma-buf")
> Cc: Boris Brezillon <boris.brezillon@collabora.com>

Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>

> Cc: Thomas Zimmermann <tzimmermann@suse.de>
> Cc: Gerd Hoffmann <kraxel@redhat.com>
> Cc: Rob Herring <robh@kernel.org>
> Cc: dri-devel@lists.freedesktop.org
> Cc: linux-media@vger.kernel.org
> Cc: linaro-mm-sig@lists.linaro.org
> Cc: <stable@vger.kernel.org> # v5.9+
> Reported-and-tested-by: piotr.oniszczuk@gmail.com
> Cc: piotr.oniszczuk@gmail.com
> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> ---
>  drivers/gpu/drm/drm_gem.c              | 4 ++--
>  drivers/gpu/drm/drm_gem_shmem_helper.c | 7 ++++++-
>  2 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
> index 1da67d34e55d..d586068f5509 100644
> --- a/drivers/gpu/drm/drm_gem.c
> +++ b/drivers/gpu/drm/drm_gem.c
> @@ -1076,6 +1076,8 @@ int drm_gem_mmap_obj(struct drm_gem_object *obj, unsigned long obj_size,
>  	 */
>  	drm_gem_object_get(obj);
>  
> +	vma->vm_private_data = obj;
> +
>  	if (obj->funcs->mmap) {
>  		ret = obj->funcs->mmap(obj, vma);
>  		if (ret) {
> @@ -1096,8 +1098,6 @@ int drm_gem_mmap_obj(struct drm_gem_object *obj, unsigned long obj_size,
>  		vma->vm_page_prot = pgprot_decrypted(vma->vm_page_prot);
>  	}
>  
> -	vma->vm_private_data = obj;
> -
>  	return 0;
>  }
>  EXPORT_SYMBOL(drm_gem_mmap_obj);
> diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
> index fb11df7aced5..8233bda4692f 100644
> --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
> +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
> @@ -598,8 +598,13 @@ int drm_gem_shmem_mmap(struct drm_gem_object *obj, struct vm_area_struct *vma)
>  	/* Remove the fake offset */
>  	vma->vm_pgoff -= drm_vma_node_start(&obj->vma_node);
>  
> -	if (obj->import_attach)
> +	if (obj->import_attach) {
> +		/* Drop the reference drm_gem_mmap_obj() acquired.*/
> +		drm_gem_object_put(obj);
> +		vma->vm_private_data = NULL;
> +
>  		return dma_buf_mmap(obj->dma_buf, vma, 0);
> +	}
>  
>  	shmem = to_drm_gem_shmem_obj(obj);
>  

