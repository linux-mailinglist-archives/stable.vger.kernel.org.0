Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C87B58EBE4
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 14:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230438AbiHJMUR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Aug 2022 08:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231285AbiHJMT4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Aug 2022 08:19:56 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 036A66BD7E
        for <stable@vger.kernel.org>; Wed, 10 Aug 2022 05:19:55 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id l4so17503519wrm.13
        for <stable@vger.kernel.org>; Wed, 10 Aug 2022 05:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc;
        bh=RY2Ewo6bOI+v2XIS1ytjQN36YoqMz59NHMWH4OJMAHc=;
        b=RPF7rm/X78U5LLWWcqww7LvuWd7cnT3VyaR9t5pnnOHSSeNI6gaLK19VnuEZnr9Xxu
         ql2mH1jULHhHK1iyB7SY6LOaV20CaBEI88IbKOfcSvy1YZzsrzLxhW1BIOZxJuLPRJbs
         XjXYXe5HKztRcVBF0e+xdH0zXb2ZSpo4KihOg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=RY2Ewo6bOI+v2XIS1ytjQN36YoqMz59NHMWH4OJMAHc=;
        b=Si4E7iFtzjrk9ckYoUA+jhx/x9Gm5Lf844Bn5X5lod6+f87CT848YwP28dXWS/mqvC
         Ji7vwXyzVlsp91ac2oocpwVkWKOHECUzT4TemFQ1MEFHfnPi7O4EiBRgXPcZIsnZdMyF
         ayXx8C/1US/lijPn70c9TT/IYVZVsUGiNG2gzPbxUTPoR+a5ayO6ycWKuaQ7vwR/UHEh
         V994WN7m8LO7hsx56IreZzbMMjhzXcigDu/eYppeD4ENLbDS6UN/OhAjxvP5Z2dGpUN9
         VhknKklPqSzY0OvoUYqyWfojif27UOXNf2D3A7fwdA5meIZXjCJOAANGwiZm4sM1RB38
         UGkg==
X-Gm-Message-State: ACgBeo1qqoAeUQUqg/OTOIIfd13b2Mu3rVBKb7aFNyPt2JiQFMfUKFIV
        db+T8tWd/Cc56DbU4RFPeGx7yA==
X-Google-Smtp-Source: AA6agR4yZWOcUa33jynrJHs2cf/zf0goQtVxoIpzpPE5JePnnd3YXT9tMWXVXa6vunC8PfoLgNNPFQ==
X-Received: by 2002:a05:6000:1704:b0:220:69a7:ec2b with SMTP id n4-20020a056000170400b0022069a7ec2bmr17957746wrc.436.1660133993546;
        Wed, 10 Aug 2022 05:19:53 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id q3-20020a056000136300b0021b956da1dcsm15910553wrz.113.2022.08.10.05.19.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 05:19:53 -0700 (PDT)
Date:   Wed, 10 Aug 2022 14:19:51 +0200
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Yonghua Huang <yonghua.huang@intel.com>
Cc:     gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, reinette.chatre@intel.com,
        zhi.a.wang@intel.com, yu1.wang@intel.com, fei1.Li@intel.com,
        Linux MM <linux-mm@kvack.org>,
        DRI Development <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH] virt: acrn: obtain pa from VMA with PFNMAP flag
Message-ID: <YvOiZ2jp2Fv0Ex0J@phenom.ffwll.local>
Mail-Followup-To: Yonghua Huang <yonghua.huang@intel.com>,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, reinette.chatre@intel.com,
        zhi.a.wang@intel.com, yu1.wang@intel.com, fei1.Li@intel.com,
        Linux MM <linux-mm@kvack.org>,
        DRI Development <dri-devel@lists.freedesktop.org>
References: <20220228022212.419406-1-yonghua.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220228022212.419406-1-yonghua.huang@intel.com>
X-Operating-System: Linux phenom 5.10.0-8-amd64 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 28, 2022 at 05:22:12AM +0300, Yonghua Huang wrote:
>  acrn_vm_ram_map can't pin the user pages with VM_PFNMAP flag
>  by calling get_user_pages_fast(), the PA(physical pages)
>  may be mapped by kernel driver and set PFNMAP flag.
> 
>  This patch fixes logic to setup EPT mapping for PFN mapped RAM region
>  by checking the memory attribute before adding EPT mapping for them.
> 
> Fixes: 88f537d5e8dd ("virt: acrn: Introduce EPT mapping management")
> Signed-off-by: Yonghua Huang <yonghua.huang@intel.com>
> Signed-off-by: Fei Li <fei1.li@intel.com>
> ---
>  drivers/virt/acrn/mm.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/drivers/virt/acrn/mm.c b/drivers/virt/acrn/mm.c
> index c4f2e15c8a2b..3b1b1e7a844b 100644
> --- a/drivers/virt/acrn/mm.c
> +++ b/drivers/virt/acrn/mm.c
> @@ -162,10 +162,34 @@ int acrn_vm_ram_map(struct acrn_vm *vm, struct acrn_vm_memmap *memmap)
>  	void *remap_vaddr;
>  	int ret, pinned;
>  	u64 user_vm_pa;
> +	unsigned long pfn;
> +	struct vm_area_struct *vma;
>  
>  	if (!vm || !memmap)
>  		return -EINVAL;
>  
> +	mmap_read_lock(current->mm);
> +	vma = vma_lookup(current->mm, memmap->vma_base);
> +	if (vma && ((vma->vm_flags & VM_PFNMAP) != 0)) {
> +		if ((memmap->vma_base + memmap->len) > vma->vm_end) {
> +			mmap_read_unlock(current->mm);
> +			return -EINVAL;
> +		}
> +
> +		ret = follow_pfn(vma, memmap->vma_base, &pfn);

This races, don't use follow_pfn() and most definitely don't add new
users. In some cases follow_pte, but the pte/pfn is still only valid for
as long as you hold the pte spinlock.

> +		mmap_read_unlock(current->mm);

Definitely after here there's zero guarantees about this pfn and it could
point at anything.

Please fix, I tried pretty hard to get rid of follow_pfn(), but some of
them are just too hard to fix (e.g. kvm needs a pretty hug rewrite to get
it all sorted).

Cheers, Daniel

> +		if (ret < 0) {
> +			dev_dbg(acrn_dev.this_device,
> +				"Failed to lookup PFN at VMA:%pK.\n", (void *)memmap->vma_base);
> +			return ret;
> +		}
> +
> +		return acrn_mm_region_add(vm, memmap->user_vm_pa,
> +			 PFN_PHYS(pfn), memmap->len,
> +			 ACRN_MEM_TYPE_WB, memmap->attr);
> +	}
> +	mmap_read_unlock(current->mm);
> +
>  	/* Get the page number of the map region */
>  	nr_pages = memmap->len >> PAGE_SHIFT;
>  	pages = vzalloc(nr_pages * sizeof(struct page *));
> 
> base-commit: 73878e5eb1bd3c9656685ca60bc3a49d17311e0c
> -- 
> 2.25.1
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
