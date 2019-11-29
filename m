Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC4A10D6F4
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 15:26:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbfK2O0L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Nov 2019 09:26:11 -0500
Received: from foss.arm.com ([217.140.110.172]:48458 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726824AbfK2O0L (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 29 Nov 2019 09:26:11 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AE0471FB;
        Fri, 29 Nov 2019 06:26:10 -0800 (PST)
Received: from [10.1.194.43] (e112269-lin.cambridge.arm.com [10.1.194.43])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E421B3F52E;
        Fri, 29 Nov 2019 06:26:09 -0800 (PST)
Subject: Re: [PATCH 3/8] drm/panfrost: Fix a BO leak in
 panfrost_ioctl_mmap_bo()
To:     Boris Brezillon <boris.brezillon@collabora.com>,
        Rob Herring <robh+dt@kernel.org>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>
Cc:     stable@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <20191129135908.2439529-1-boris.brezillon@collabora.com>
 <20191129135908.2439529-4-boris.brezillon@collabora.com>
From:   Steven Price <steven.price@arm.com>
Message-ID: <ef2cb594-ade3-0f86-c17b-60917ac1e6b4@arm.com>
Date:   Fri, 29 Nov 2019 14:26:08 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191129135908.2439529-4-boris.brezillon@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 29/11/2019 13:59, Boris Brezillon wrote:
> We should release the reference we grabbed when an error occurs.
> 
> Fixes: 187d2929206e ("drm/panfrost: Add support for GPU heap allocations")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>

Reviewed-by: Steven Price <steven.price@arm.com>

> ---
>  drivers/gpu/drm/panfrost/panfrost_drv.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/gpu/drm/panfrost/panfrost_drv.c b/drivers/gpu/drm/panfrost/panfrost_drv.c
> index efc0a24d1f4c..2630c5027c63 100644
> --- a/drivers/gpu/drm/panfrost/panfrost_drv.c
> +++ b/drivers/gpu/drm/panfrost/panfrost_drv.c
> @@ -303,14 +303,17 @@ static int panfrost_ioctl_mmap_bo(struct drm_device *dev, void *data,
>  	}
>  
>  	/* Don't allow mmapping of heap objects as pages are not pinned. */
> -	if (to_panfrost_bo(gem_obj)->is_heap)
> -		return -EINVAL;
> +	if (to_panfrost_bo(gem_obj)->is_heap) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
>  
>  	ret = drm_gem_create_mmap_offset(gem_obj);
>  	if (ret == 0)
>  		args->offset = drm_vma_node_offset_addr(&gem_obj->vma_node);
> -	drm_gem_object_put_unlocked(gem_obj);
>  
> +out:
> +	drm_gem_object_put_unlocked(gem_obj);
>  	return ret;
>  }
>  
> 

