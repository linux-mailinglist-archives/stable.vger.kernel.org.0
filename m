Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2930B30A759
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 13:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbhBAMOY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 07:14:24 -0500
Received: from foss.arm.com ([217.140.110.172]:58288 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229524AbhBAMOW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Feb 2021 07:14:22 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D5B0213D5;
        Mon,  1 Feb 2021 04:13:35 -0800 (PST)
Received: from [192.168.1.179] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C3A813F718;
        Mon,  1 Feb 2021 04:13:34 -0800 (PST)
Subject: Re: [PATCH 2/3] drm/panfrost: Don't try to map pages that are already
 mapped
To:     Boris Brezillon <boris.brezillon@collabora.com>,
        Rob Herring <robh+dt@kernel.org>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Robin Murphy <robin.murphy@arm.com>
Cc:     dri-devel@lists.freedesktop.org, stable@vger.kernel.org
References: <20210201082116.267208-1-boris.brezillon@collabora.com>
 <20210201082116.267208-3-boris.brezillon@collabora.com>
From:   Steven Price <steven.price@arm.com>
Message-ID: <b65e630d-1913-ccfd-56cb-10b96f9052cc@arm.com>
Date:   Mon, 1 Feb 2021 12:13:42 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210201082116.267208-3-boris.brezillon@collabora.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 01/02/2021 08:21, Boris Brezillon wrote:
> We allocate 2MB chunks at a time, so it might appear that a page fault
> has already been handled by a previous page fault when we reach
> panfrost_mmu_map_fault_addr(). Bail out in that case to avoid mapping the
> same area twice.
> 
> Cc: <stable@vger.kernel.org>
> Fixes: 187d2929206e ("drm/panfrost: Add support for GPU heap allocations")
> Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>

Reviewed-by: Steven Price <steven.price@arm.com>

> ---
>   drivers/gpu/drm/panfrost/panfrost_mmu.c | 9 ++++++++-
>   1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/panfrost/panfrost_mmu.c b/drivers/gpu/drm/panfrost/panfrost_mmu.c
> index 904d63450862..21e552d1ac71 100644
> --- a/drivers/gpu/drm/panfrost/panfrost_mmu.c
> +++ b/drivers/gpu/drm/panfrost/panfrost_mmu.c
> @@ -488,8 +488,14 @@ static int panfrost_mmu_map_fault_addr(struct panfrost_device *pfdev, int as,
>   		}
>   		bo->base.pages = pages;
>   		bo->base.pages_use_count = 1;
> -	} else
> +	} else {
>   		pages = bo->base.pages;
> +		if (pages[page_offset]) {
> +			/* Pages are already mapped, bail out. */
> +			mutex_unlock(&bo->base.pages_lock);
> +			goto out;
> +		}
> +	}
>   
>   	mapping = bo->base.base.filp->f_mapping;
>   	mapping_set_unevictable(mapping);
> @@ -522,6 +528,7 @@ static int panfrost_mmu_map_fault_addr(struct panfrost_device *pfdev, int as,
>   
>   	dev_dbg(pfdev->dev, "mapped page fault @ AS%d %llx", as, addr);
>   
> +out:
>   	panfrost_gem_mapping_put(bomapping);
>   
>   	return 0;
> 

