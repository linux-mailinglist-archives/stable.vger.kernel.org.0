Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1773399C81
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 10:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbhFCI1X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 04:27:23 -0400
Received: from mail-ej1-f46.google.com ([209.85.218.46]:46057 "EHLO
        mail-ej1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbhFCI1W (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Jun 2021 04:27:22 -0400
Received: by mail-ej1-f46.google.com with SMTP id k7so7911511ejv.12
        for <stable@vger.kernel.org>; Thu, 03 Jun 2021 01:25:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=o5kw+//VKIV37NgUU8wnmMDxCrt1xJBfaT2OcQb5jmY=;
        b=HwePD0yuklUKjr79BnSZIco6VX+WGTu+HoObY1IfqheNz9RFW3He0JEzFE3xSogSMH
         c5ZLoP6FaKZOCrVU0u0JYWiuzpe5sIRL/Udyunk1j1jKHDxvWr+FO/s2rURfr0HAGO89
         0VKv2sc1F1D/mzb0AgmjlL/C7qS0K3A2HD+cg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=o5kw+//VKIV37NgUU8wnmMDxCrt1xJBfaT2OcQb5jmY=;
        b=i7l9m/wPtMxK11T9FfYnN6X43AhRSh2JTUASu05vXHY/cRH+ApuemFDeUx4eSlwiIm
         JU5JPoGWeJiVBHOHlgcos3n6O3Yz5neu0A1cWVz19stG+3YL4sWYpakwXcwvUL+5f5Rr
         D0rw3j94YL5Go7wvcn2AYi0E1FrfxtrWRwcm2cP2KReQDQMv88ycJLgo6Qf6KqC+oxqr
         uc7C/DhpzVz6j+s3sjR0MHKl+pOAd7OLOTRYI7Hzf6Xy8BYd1wxppTnoykSwt6csdXcl
         56Q5qKmvJs3dNvVkviMO9rnRV5vRhO/lrheuvzJ5L4YbZGGS2/ur5aNd+//bd5HiOaXH
         qgOQ==
X-Gm-Message-State: AOAM531+vXgHgLvn4DvzrzKlRS6n8LPdDOziJdNaqlkx/aCehVZj14YY
        TI5+EtUQsPoA9B/7fgiy10HxHtzKADyJxg==
X-Google-Smtp-Source: ABdhPJyoowUPQmDFu4llPYKbjkkVb3iq/NgCwmOUL6l4PJA5WX11nE+fiyjr4bx7EwbTnwVE7ck8qw==
X-Received: by 2002:a17:906:489:: with SMTP id f9mr19691933eja.508.1622708664167;
        Thu, 03 Jun 2021 01:24:24 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id r12sm1317922edv.82.2021.06.03.01.24.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 01:24:23 -0700 (PDT)
Date:   Thu, 3 Jun 2021 10:24:21 +0200
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Jason Ekstrand <jason@jlekstrand.net>
Cc:     dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        Jason Ekstrand <jason.ekstrand@intel.com>,
        Marcin Slusarz <marcin.slusarz@intel.com>,
        stable@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jon Bloomfield <jon.bloomfield@intel.com>
Subject: Re: [PATCH 4/5] Revert "drm/i915: Propagate errors on awaiting
 already signaled fences"
Message-ID: <YLiRtZUuloF0qy0b@phenom.ffwll.local>
References: <20210602164149.391653-1-jason@jlekstrand.net>
 <20210602164149.391653-5-jason@jlekstrand.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210602164149.391653-5-jason@jlekstrand.net>
X-Operating-System: Linux phenom 5.10.32scarlett+ 
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 02, 2021 at 11:41:48AM -0500, Jason Ekstrand wrote:
> This reverts commit 9e31c1fe45d555a948ff66f1f0e3fe1f83ca63f7.  Ever
> since that commit, we've been having issues where a hang in one client
> can propagate to another.  In particular, a hang in an app can propagate
> to the X server which causes the whole desktop to lock up.

I think we need a note to backporters here:

"For backporters: Please note that you _must_ have a backport of
https://lore.kernel.org/dri-devel/20210602164149.391653-2-jason@jlekstrand.net/
for otherwise backporting just this patch opens up a security bug."
 
Or something like that.
-Daniel

> Signed-off-by: Jason Ekstrand <jason.ekstrand@intel.com>
> Reported-by: Marcin Slusarz <marcin.slusarz@intel.com>
> Cc: <stable@vger.kernel.org> # v5.6+
> Cc: Jason Ekstrand <jason.ekstrand@intel.com>
> Cc: Marcin Slusarz <marcin.slusarz@intel.com>
> Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/3080
> Fixes: 9e31c1fe45d5 ("drm/i915: Propagate errors on awaiting already signaled fences")
> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> Reviewed-by: Jon Bloomfield <jon.bloomfield@intel.com>
> ---
>  drivers/gpu/drm/i915/i915_request.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/i915_request.c b/drivers/gpu/drm/i915/i915_request.c
> index 970d8f4986bbe..b796197c07722 100644
> --- a/drivers/gpu/drm/i915/i915_request.c
> +++ b/drivers/gpu/drm/i915/i915_request.c
> @@ -1426,10 +1426,8 @@ i915_request_await_execution(struct i915_request *rq,
>  
>  	do {
>  		fence = *child++;
> -		if (test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags)) {
> -			i915_sw_fence_set_error_once(&rq->submit, fence->error);
> +		if (test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags))
>  			continue;
> -		}
>  
>  		if (fence->context == rq->fence.context)
>  			continue;
> @@ -1527,10 +1525,8 @@ i915_request_await_dma_fence(struct i915_request *rq, struct dma_fence *fence)
>  
>  	do {
>  		fence = *child++;
> -		if (test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags)) {
> -			i915_sw_fence_set_error_once(&rq->submit, fence->error);
> +		if (test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags))
>  			continue;
> -		}
>  
>  		/*
>  		 * Requests on the same timeline are explicitly ordered, along
> -- 
> 2.31.1
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
