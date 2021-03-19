Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8603B3425D3
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 20:10:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbhCSTKT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 15:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230273AbhCSTKF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Mar 2021 15:10:05 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADA87C06174A
        for <stable@vger.kernel.org>; Fri, 19 Mar 2021 12:10:03 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id b9so10168212wrt.8
        for <stable@vger.kernel.org>; Fri, 19 Mar 2021 12:10:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jZpUFw5riLd0C9+mvdtvugCUovm7ZDUvByCOa9/76ZQ=;
        b=QhR+4KSqTHgaKnWXgqZDaD4oyvTkcghD7MmZhFA4mM/vgZNq/zvisfJ4lTbhpNMaDk
         WuvekNJUiEA/uWdTT1o59OVsNAcXORuTDKyS6drhuWf8q4bLYMPF208DZ7sK3aB2JtLo
         dQde/mDhVwjY5i7YnPoiQJN6FQ7596ueC8wIA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jZpUFw5riLd0C9+mvdtvugCUovm7ZDUvByCOa9/76ZQ=;
        b=XRk6n8J55Z+bAeEj4nIctdewm1ph/7/UnJ3DTSovfHZWbJdLoSFbK9YWbTHn51z2XJ
         o0GFhXjLZcJ2P1Ye24tXQ3OFKBfkf+QEv/Ku9XLGrDdMyXeejjTf2VyvJ84SmAEiR9u3
         ykg18VZZYvWX6zajaBVKRCv6xI7JRq8ou5XrlcJPj23+v9NI/jGoTiTaS/y3PsEv+4sP
         2wkqyK+sYBEvP1K2dN33vHbgLy5A3ZP7xoQoAlPQ62Rln7ohmdtEAfwXLy9wSuCqc3At
         ToWJOH/QLHM5HMDnBtdH2EQ4hkIW1LrzQUuO8UHzgN4hFs9b/MoqHq4rvM1/3ly58sW+
         jXxA==
X-Gm-Message-State: AOAM531B61vp+SiYFmFzGY6vVQEWncbecxAcURndYaWSX0Cxr7Ovbj18
        sf01LVHbDoiXR7x8sagKmQqEyw==
X-Google-Smtp-Source: ABdhPJzFO9WN+CgE2/RgrKtksHm0n51FPIRyY4UczFIou1uJWBnUN6p6hqCHNzK6RXb0lDvwSgUmfw==
X-Received: by 2002:a05:6000:120f:: with SMTP id e15mr5802818wrx.129.1616181002238;
        Fri, 19 Mar 2021 12:10:02 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id z2sm9085005wrv.47.2021.03.19.12.10.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 12:10:01 -0700 (PDT)
Date:   Fri, 19 Mar 2021 20:09:59 +0100
From:   Daniel Vetter <daniel@ffwll.ch>
To:     DRI Development <dri-devel@lists.freedesktop.org>
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>, stable@vger.kernel.org,
        John Hubbard <jhubbard@nvidia.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Russell King <linux+etnaviv@armlinux.org.uk>,
        Christian Gmeiner <christian.gmeiner@gmail.com>,
        etnaviv@lists.freedesktop.org
Subject: Re: [PATCH 1/2] drm/etnaviv: Use FOLL_FORCE for userptr
Message-ID: <YFT3B9fRldXI470m@phenom.ffwll.local>
References: <20210301095254.1946084-1-daniel.vetter@ffwll.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210301095254.1946084-1-daniel.vetter@ffwll.ch>
X-Operating-System: Linux phenom 5.7.0-1-amd64 
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 01, 2021 at 10:52:53AM +0100, Daniel Vetter wrote:
> Nothing checks userptr.ro except this call to pup_fast, which means
> there's nothing actually preventing userspace from writing to this.
> Which means you can just read-only mmap any file you want, userptr it
> and then write to it with the gpu. Not good.
> 
> The right way to handle this is FOLL_WRITE | FOLL_FORCE, which will
> break any COW mappings and update tracking for MAY_WRITE mappings so
> there's no exploit and the vm isn't confused about what's going on.
> For any legit use case there's no difference from what userspace can
> observe and do.
> 
> Cc: stable@vger.kernel.org
> Cc: John Hubbard <jhubbard@nvidia.com>
> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> Cc: Lucas Stach <l.stach@pengutronix.de>
> Cc: Russell King <linux+etnaviv@armlinux.org.uk>
> Cc: Christian Gmeiner <christian.gmeiner@gmail.com>
> Cc: etnaviv@lists.freedesktop.org

Can I please have an ack on this so I can apply it? It's stuck.

Thanks, Daniel

> ---
>  drivers/gpu/drm/etnaviv/etnaviv_gem.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/etnaviv/etnaviv_gem.c b/drivers/gpu/drm/etnaviv/etnaviv_gem.c
> index 6d38c5c17f23..a9e696d05b33 100644
> --- a/drivers/gpu/drm/etnaviv/etnaviv_gem.c
> +++ b/drivers/gpu/drm/etnaviv/etnaviv_gem.c
> @@ -689,7 +689,7 @@ static int etnaviv_gem_userptr_get_pages(struct etnaviv_gem_object *etnaviv_obj)
>  		struct page **pages = pvec + pinned;
>  
>  		ret = pin_user_pages_fast(ptr, num_pages,
> -					  !userptr->ro ? FOLL_WRITE : 0, pages);
> +					  FOLL_WRITE | FOLL_FORCE, pages);
>  		if (ret < 0) {
>  			unpin_user_pages(pvec, pinned);
>  			kvfree(pvec);
> -- 
> 2.30.0
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
