Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 650981675C
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 18:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbfEGQEf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 12:04:35 -0400
Received: from smtp.domeneshop.no ([194.63.252.55]:52668 "EHLO
        smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726558AbfEGQEf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 May 2019 12:04:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=tronnes.org; s=ds201810;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject; bh=lyGqipjiRCFmDOF/jq1bWm79I2+7T2ZtPR/0i8mXddY=;
        b=IsqaXW2x6yNVicJf1fLXuGfuvILaGB7wFWDik/c4y/nnQTbU8V78zlO0KYpqXDmuEJPVE0udortb/OT5c5MBka8uzjA2S95TFBNKysAKKjmmt9GI1LSC6Erv64vLgXEo17ND0k1EYAfB7KjDu6q54WkfX8SNqSdVVVnb3t2dxzx7y3CChFIJYoE2I4Y44AVCZPX+up5eXZHo4vMZR6IDgCNirdoyKdA0lwuCaJSnRLpHcengdHTmh2UJh8RywG9YvjY086iwAXLPUh5GveFX8szFvtfMCiSQoxPCf5aIUAAO80xpVhKd7DnEnARr0Ij8cHrmYOJklqqkjiEK8KLx/A==;
Received: from 211.81-166-168.customer.lyse.net ([81.166.168.211]:54033 helo=[192.168.10.178])
        by smtp.domeneshop.no with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.84_2)
        (envelope-from <noralf@tronnes.org>)
        id 1hO2a0-0000wP-Fw; Tue, 07 May 2019 18:04:32 +0200
Subject: Re: [PATCH] drm/cma-helper: Fix drm_gem_cma_free_object()
To:     dri-devel@lists.freedesktop.org
Cc:     stable@vger.kernel.org, "Li, Tingqian" <tingqian.li@intel.com>
References: <20190426124753.53722-1-noralf@tronnes.org>
From:   =?UTF-8?Q?Noralf_Tr=c3=b8nnes?= <noralf@tronnes.org>
Message-ID: <67fc69cc-7db3-968e-2492-acd01dc3def5@tronnes.org>
Date:   Tue, 7 May 2019 18:04:20 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190426124753.53722-1-noralf@tronnes.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Could someone please have a look at this one?

Noralf.

Den 26.04.2019 14.47, skrev Noralf Trønnes:
> The logic for freeing an imported buffer with a virtual address is
> broken. It will free the buffer instead of unmapping the dma buf.
> Fix by reversing the if ladder and first check if the buffer is imported.
> 
> Fixes: b9068cde51ee ("drm/cma-helper: Add DRM_GEM_CMA_VMAP_DRIVER_OPS")
> Cc: stable@vger.kernel.org
> Reported-by: "Li, Tingqian" <tingqian.li@intel.com>
> Signed-off-by: Noralf Trønnes <noralf@tronnes.org>
> ---
> 
>  drivers/gpu/drm/drm_gem_cma_helper.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_gem_cma_helper.c b/drivers/gpu/drm/drm_gem_cma_helper.c
> index cc26625b4b33..e01ceed09e67 100644
> --- a/drivers/gpu/drm/drm_gem_cma_helper.c
> +++ b/drivers/gpu/drm/drm_gem_cma_helper.c
> @@ -186,13 +186,13 @@ void drm_gem_cma_free_object(struct drm_gem_object *gem_obj)
>  
>  	cma_obj = to_drm_gem_cma_obj(gem_obj);
>  
> -	if (cma_obj->vaddr) {
> -		dma_free_wc(gem_obj->dev->dev, cma_obj->base.size,
> -			    cma_obj->vaddr, cma_obj->paddr);
> -	} else if (gem_obj->import_attach) {
> +	if (gem_obj->import_attach) {
>  		if (cma_obj->vaddr)
>  			dma_buf_vunmap(gem_obj->import_attach->dmabuf, cma_obj->vaddr);
>  		drm_prime_gem_destroy(gem_obj, cma_obj->sgt);
> +	} else if (cma_obj->vaddr) {
> +		dma_free_wc(gem_obj->dev->dev, cma_obj->base.size,
> +			    cma_obj->vaddr, cma_obj->paddr);
>  	}
>  
>  	drm_gem_object_release(gem_obj);
> 
