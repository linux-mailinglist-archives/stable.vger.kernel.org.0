Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E82BE1707C8
	for <lists+stable@lfdr.de>; Wed, 26 Feb 2020 19:34:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbgBZSep (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Feb 2020 13:34:45 -0500
Received: from pio-pvt-msa2.bahnhof.se ([79.136.2.41]:37554 "EHLO
        pio-pvt-msa2.bahnhof.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726789AbgBZSeo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Feb 2020 13:34:44 -0500
X-Greylist: delayed 587 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Feb 2020 13:34:44 EST
Received: from localhost (localhost [127.0.0.1])
        by pio-pvt-msa2.bahnhof.se (Postfix) with ESMTP id 5038D3F99D;
        Wed, 26 Feb 2020 19:24:55 +0100 (CET)
Authentication-Results: pio-pvt-msa2.bahnhof.se;
        dkim=pass (1024-bit key; unprotected) header.d=shipmail.org header.i=@shipmail.org header.b=EfstPGpZ;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at bahnhof.se
X-Spam-Flag: NO
X-Spam-Score: -2.099
X-Spam-Level: 
X-Spam-Status: No, score=-2.099 tagged_above=-999 required=6.31
        tests=[BAYES_00=-1.9, DKIM_SIGNED=0.1, DKIM_VALID=-0.1,
        DKIM_VALID_AU=-0.1, DKIM_VALID_EF=-0.1, URIBL_BLOCKED=0.001]
        autolearn=ham autolearn_force=no
Received: from pio-pvt-msa2.bahnhof.se ([127.0.0.1])
        by localhost (pio-pvt-msa2.bahnhof.se [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id motlGi_xZ2hD; Wed, 26 Feb 2020 19:24:50 +0100 (CET)
Received: from mail1.shipmail.org (h-205-35.A357.priv.bahnhof.se [155.4.205.35])
        (Authenticated sender: mb878879)
        by pio-pvt-msa2.bahnhof.se (Postfix) with ESMTPA id 050CC3F971;
        Wed, 26 Feb 2020 19:24:48 +0100 (CET)
Received: from localhost.localdomain (h-205-35.A357.priv.bahnhof.se [155.4.205.35])
        by mail1.shipmail.org (Postfix) with ESMTPSA id 409C8360093;
        Wed, 26 Feb 2020 19:24:48 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=shipmail.org; s=mail;
        t=1582741488; bh=te/8IotpQEnl0o4n3vw2nGQFI/zVy4BNRconbR+LM4o=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=EfstPGpZpHtME6/a9f1AtAN+w3pJUClLCPuMW8qkPq/xbXVzrWpilFsvjN7HBNE9g
         gGxQfQ6pJ0wTBXqODOLs+AENYvNgFWE/sVhbRkZXw+bmTtExcAvzX0IfO+dbWsZOFZ
         Bgn5FG1CZvdQ53+LpDE9QA513jSr16J63LLReVqo=
Subject: Re: [PATCH v5 1/3] drm/shmem: add support for per object caching
 flags.
To:     Gerd Hoffmann <kraxel@redhat.com>, dri-devel@lists.freedesktop.org
Cc:     Guillaume.Gardet@arm.com, David Airlie <airlied@linux.ie>,
        open list <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, gurchetansingh@chromium.org,
        tzimmermann@suse.de
References: <20200226154752.24328-1-kraxel@redhat.com>
 <20200226154752.24328-2-kraxel@redhat.com>
From:   =?UTF-8?Q?Thomas_Hellstr=c3=b6m_=28VMware=29?= 
        <thomas_os@shipmail.org>
Organization: VMware Inc.
Message-ID: <f1afba4b-9c06-48a3-42c7-046695947e91@shipmail.org>
Date:   Wed, 26 Feb 2020 19:24:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200226154752.24328-2-kraxel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Gerd,

While looking at this patchset I came across some stuff that seems 
strange but that was merged in a previous patchset.

(please refer to 
https://lists.freedesktop.org/archives/dri-devel/2018-September/190001.html. 
Forgive me if I've missed any discussion leading up to this).


On 2/26/20 4:47 PM, Gerd Hoffmann wrote:
> Add map_cached bool to drm_gem_shmem_object, to request cached mappings
> on a per-object base.  Check the flag before adding writecombine to
> pgprot bits.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
> ---
>   include/drm/drm_gem_shmem_helper.h     |  5 +++++
>   drivers/gpu/drm/drm_gem_shmem_helper.c | 15 +++++++++++----
>   2 files changed, 16 insertions(+), 4 deletions(-)
>
> diff --git a/include/drm/drm_gem_shmem_helper.h b/include/drm/drm_gem_shmem_helper.h
> index e34a7b7f848a..294b2931c4cc 100644
> --- a/include/drm/drm_gem_shmem_helper.h
> +++ b/include/drm/drm_gem_shmem_helper.h
> @@ -96,6 +96,11 @@ struct drm_gem_shmem_object {
>   	 * The address are un-mapped when the count reaches zero.
>   	 */
>   	unsigned int vmap_use_count;
> +
> +	/**
> +	 * @map_cached: map object cached (instead of using writecombine).
> +	 */
> +	bool map_cached;
>   };
>   
>   #define to_drm_gem_shmem_obj(obj) \
> diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
> index a421a2eed48a..aad9324dcf4f 100644
> --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
> +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
> @@ -254,11 +254,16 @@ static void *drm_gem_shmem_vmap_locked(struct drm_gem_shmem_object *shmem)
>   	if (ret)
>   		goto err_zero_use;
>   
> -	if (obj->import_attach)
> +	if (obj->import_attach) {
>   		shmem->vaddr = dma_buf_vmap(obj->import_attach->dmabuf);
> -	else
> +	} else {
> +		pgprot_t prot = PAGE_KERNEL;
> +
> +		if (!shmem->map_cached)
> +			prot = pgprot_writecombine(prot);
>   		shmem->vaddr = vmap(shmem->pages, obj->size >> PAGE_SHIFT,
> -				    VM_MAP, pgprot_writecombine(PAGE_KERNEL));
> +				    VM_MAP, prot)


Wouldn't a vmap with pgprot_writecombine() create conflicting mappings 
with the linear kernel map which is not write-combined? Or do you change 
the linear kernel map of the shmem pages somewhere? vmap bypassess at 
least the x86 PAT core mapping consistency check and this could 
potentially cause spuriously overwritten memory.


> +	}
>   
>   	if (!shmem->vaddr) {
>   		DRM_DEBUG_KMS("Failed to vmap pages\n");
> @@ -540,7 +545,9 @@ int drm_gem_shmem_mmap(struct drm_gem_object *obj, struct vm_area_struct *vma)
>   	}
>   
>   	vma->vm_flags |= VM_MIXEDMAP | VM_DONTEXPAND;
> -	vma->vm_page_prot = pgprot_writecombine(vm_get_page_prot(vma->vm_flags));
> +	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
> +	if (!shmem->map_cached)
> +		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);

Same thing here. Note that vmf_insert_page() which is used by the fault 
handler also bypasses the x86 PAT  consistency check, whereas 
vmf_insert_mixed() doesn't.

>   	vma->vm_page_prot = pgprot_decrypted(vma->vm_page_prot);

At least with SME or SEV encryption, where shmem memory has its kernel 
map set to encrypted, creating conflicting mappings is explicitly 
disallowed.
BTW, why is mmap mapping decrypted while vmap isn't?

>   	vma->vm_ops = &drm_gem_shmem_vm_ops;
>   

Thanks,
Thomas



