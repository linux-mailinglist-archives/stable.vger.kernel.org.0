Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18472399C79
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 10:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbhFCI0s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 04:26:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbhFCI0s (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Jun 2021 04:26:48 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9673C06174A
        for <stable@vger.kernel.org>; Thu,  3 Jun 2021 01:25:03 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id b9so7908176ejc.13
        for <stable@vger.kernel.org>; Thu, 03 Jun 2021 01:25:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pLB0AHNkPuC0xacQMQ49Xc5Eg0xlyzXKx/dWT+EAjyA=;
        b=FXs8XDFwZVGSsCZEwOlQugxQWNSYWAmKcyerO9/CxGuTuQQr+1TFgaRiGhkciLm2np
         dzuzOe7xqtbz89U/L5NNqJLP3IfZNEdf1M4Gwy3v/Hka0zLcVaHeSJf9aV6ag7b2xvSV
         pYAmkSnq6uBOJUj7GXITQV7pcoHvua54eNsXE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pLB0AHNkPuC0xacQMQ49Xc5Eg0xlyzXKx/dWT+EAjyA=;
        b=Uk7VxZjUsH+hDxTZ4LKy2Or77bsDVlyWXykETJBWnPzq1PBvHIqZuR2+Vt2C/iLAJ3
         SxdMDqg+WniuZScw0NWvRZbOP/97L+d7bEhWZmqLlY5ZtL1btlOgjD8GkHJsnUEUt4L8
         lnRUPyX1+GhQChYOQ3aOfwWLZGhDz9AW22HAwRveBsopST4DpuAJAnCQvoJcvOo5j53l
         jYulaYdxBEnwImYU1z/JKmS/CAZgS7vy1U61d+3BrjzH19vVpLt3mWx2qlqwHO1106Me
         iMDG3yl2LtgX1fRpJZo7ESeRZKwSCpWAgrh969E3ykX2wpg7he3X1OoZsfNISIG9KWEf
         uXkQ==
X-Gm-Message-State: AOAM531j6mlFgHn3ls2BF7c3lrdn6CFRYqQ6F7es5Ek8HgmGfmD2URin
        WEN3Y4EVGNq05wgygGWVnlrtdg==
X-Google-Smtp-Source: ABdhPJx/2UdPhdQe8d0TR3Zs2+ONOrz7OP88w0jJxl9puFX31DuatOZsoOLqg6mED9dlKhOlA0W/lw==
X-Received: by 2002:a17:906:1986:: with SMTP id g6mr37805723ejd.265.1622708702421;
        Thu, 03 Jun 2021 01:25:02 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id b15sm1321252ede.66.2021.06.03.01.25.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 01:25:02 -0700 (PDT)
Date:   Thu, 3 Jun 2021 10:25:00 +0200
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Jason Ekstrand <jason@jlekstrand.net>
Cc:     dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        Jason Ekstrand <jason.ekstrand@intel.com>,
        Marcin Slusarz <marcin.slusarz@intel.com>,
        stable@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jon Bloomfield <jon.bloomfield@intel.com>
Subject: Re: [PATCH 4/5] Revert "drm/i915: Propagate errors on awaiting
 already signaled fences"
Message-ID: <YLiR3CKMYjE9u4+T@phenom.ffwll.local>
References: <20210602164149.391653-1-jason@jlekstrand.net>
 <20210602164149.391653-5-jason@jlekstrand.net>
 <YLiRtZUuloF0qy0b@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YLiRtZUuloF0qy0b@phenom.ffwll.local>
X-Operating-System: Linux phenom 5.10.32scarlett+ 
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 03, 2021 at 10:24:21AM +0200, Daniel Vetter wrote:
> On Wed, Jun 02, 2021 at 11:41:48AM -0500, Jason Ekstrand wrote:
> > This reverts commit 9e31c1fe45d555a948ff66f1f0e3fe1f83ca63f7.  Ever
> > since that commit, we've been having issues where a hang in one client
> > can propagate to another.  In particular, a hang in an app can propagate
> > to the X server which causes the whole desktop to lock up.
> 
> I think we need a note to backporters here:
> 
> "For backporters: Please note that you _must_ have a backport of
> https://lore.kernel.org/dri-devel/20210602164149.391653-2-jason@jlekstrand.net/
> for otherwise backporting just this patch opens up a security bug."
>  
> Or something like that.

Oh also reordering the patch set so the 2 reverts which are cc: stable are
first, then the other stuff on top that cleans up the fallout.
-Daniel

> -Daniel
> 
> > Signed-off-by: Jason Ekstrand <jason.ekstrand@intel.com>
> > Reported-by: Marcin Slusarz <marcin.slusarz@intel.com>
> > Cc: <stable@vger.kernel.org> # v5.6+
> > Cc: Jason Ekstrand <jason.ekstrand@intel.com>
> > Cc: Marcin Slusarz <marcin.slusarz@intel.com>
> > Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/3080
> > Fixes: 9e31c1fe45d5 ("drm/i915: Propagate errors on awaiting already signaled fences")
> > Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> > Reviewed-by: Jon Bloomfield <jon.bloomfield@intel.com>
> > ---
> >  drivers/gpu/drm/i915/i915_request.c | 8 ++------
> >  1 file changed, 2 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/gpu/drm/i915/i915_request.c b/drivers/gpu/drm/i915/i915_request.c
> > index 970d8f4986bbe..b796197c07722 100644
> > --- a/drivers/gpu/drm/i915/i915_request.c
> > +++ b/drivers/gpu/drm/i915/i915_request.c
> > @@ -1426,10 +1426,8 @@ i915_request_await_execution(struct i915_request *rq,
> >  
> >  	do {
> >  		fence = *child++;
> > -		if (test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags)) {
> > -			i915_sw_fence_set_error_once(&rq->submit, fence->error);
> > +		if (test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags))
> >  			continue;
> > -		}
> >  
> >  		if (fence->context == rq->fence.context)
> >  			continue;
> > @@ -1527,10 +1525,8 @@ i915_request_await_dma_fence(struct i915_request *rq, struct dma_fence *fence)
> >  
> >  	do {
> >  		fence = *child++;
> > -		if (test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags)) {
> > -			i915_sw_fence_set_error_once(&rq->submit, fence->error);
> > +		if (test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags))
> >  			continue;
> > -		}
> >  
> >  		/*
> >  		 * Requests on the same timeline are explicitly ordered, along
> > -- 
> > 2.31.1
> > 
> 
> -- 
> Daniel Vetter
> Software Engineer, Intel Corporation
> http://blog.ffwll.ch

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
