Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB3F324250
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 17:44:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235483AbhBXQmL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 11:42:11 -0500
Received: from foss.arm.com ([217.140.110.172]:39334 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235518AbhBXQkI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 11:40:08 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1077731B;
        Wed, 24 Feb 2021 08:39:17 -0800 (PST)
Received: from [192.168.1.179] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0028D3F70D;
        Wed, 24 Feb 2021 08:39:15 -0800 (PST)
Subject: Re: [PATCH 1/2] drm/shmem-helper: Check for purged buffers in fault
 handler
To:     Neil Roberts <nroberts@igalia.com>,
        Rob Herring <robh+dt@kernel.org>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Robin Murphy <robin.murphy@arm.com>
Cc:     dri-devel@lists.freedesktop.org, stable@vger.kernel.org
References: <20210223155125.199577-1-nroberts@igalia.com>
 <20210223155125.199577-2-nroberts@igalia.com>
From:   Steven Price <steven.price@arm.com>
Message-ID: <3b720672-d21d-dde5-4d7d-c2c8cd00c4b5@arm.com>
Date:   Wed, 24 Feb 2021 16:39:32 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210223155125.199577-2-nroberts@igalia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 23/02/2021 15:51, Neil Roberts wrote:
> When a buffer is madvised as not needed and then purged, any attempts to
> access the buffer from user-space should cause a bus fault. This patch
> adds a check for that.
> 
> Cc: stable@vger.kernel.org
> Fixes: 17acb9f35ed7 ("drm/shmem: Add madvise state and purge helpers")
> Signed-off-by: Neil Roberts <nroberts@igalia.com>

Reviewed-by: Steven Price <steven.price@arm.com>

> ---
>   drivers/gpu/drm/drm_gem_shmem_helper.c | 18 ++++++++++++++----
>   1 file changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
> index 9825c378dfa6..b26139b1dc35 100644
> --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
> +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
> @@ -525,14 +525,24 @@ static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
>   	struct drm_gem_object *obj = vma->vm_private_data;
>   	struct drm_gem_shmem_object *shmem = to_drm_gem_shmem_obj(obj);
>   	loff_t num_pages = obj->size >> PAGE_SHIFT;
> +	vm_fault_t ret;
>   	struct page *page;
>   
> -	if (vmf->pgoff >= num_pages || WARN_ON_ONCE(!shmem->pages))
> -		return VM_FAULT_SIGBUS;
> +	mutex_lock(&shmem->pages_lock);
> +
> +	if (vmf->pgoff >= num_pages ||
> +	    WARN_ON_ONCE(!shmem->pages) ||
> +	    shmem->madv < 0) {
> +		ret = VM_FAULT_SIGBUS;
> +	} else {
> +		page = shmem->pages[vmf->pgoff];
>   
> -	page = shmem->pages[vmf->pgoff];
> +		ret = vmf_insert_page(vma, vmf->address, page);
> +	}
>   
> -	return vmf_insert_page(vma, vmf->address, page);
> +	mutex_unlock(&shmem->pages_lock);
> +
> +	return ret;
>   }
>   
>   static void drm_gem_shmem_vm_open(struct vm_area_struct *vma)
> 

