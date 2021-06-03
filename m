Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6177E399C8A
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 10:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbhFCI3v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 04:29:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbhFCI3v (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Jun 2021 04:29:51 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD1CEC06174A
        for <stable@vger.kernel.org>; Thu,  3 Jun 2021 01:28:06 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id k7so7926438ejv.12
        for <stable@vger.kernel.org>; Thu, 03 Jun 2021 01:28:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=birOY8O+CqZv81ZE8iIciVC5E7r64gjeuicm0Fi1AVg=;
        b=jO4Arj98Qe+Vj/hmrpdOTIS0v6Otw56LjyY+GkHTRaxPtVOFuvWk4wO5yIvU2Nzr1h
         Yk+PJcUavyP0SEENZ+Z7rhdwUwK32+nZKSK7x/VmQ08b3clSjg7BNGahgogBGq6nLwum
         +1QXV8Z/5dLkI/7TBO32BydWuLS2fT5RgYqRo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=birOY8O+CqZv81ZE8iIciVC5E7r64gjeuicm0Fi1AVg=;
        b=hrphG68U82vYjuo6WR0Sb8cHHoh4k2fGKfduzVu6txJHYVCvitLn2hc+8likDX0EkS
         IRw1fceAYCL3Vc7qA6nQ9bca1i/Eb6S8GvhE2HWKG7od9g1RJf9MNnxaU7kN7UWS1EWY
         /FbsBHAB8Mjcy3vuSgUUPRlqWsiCDhEw6BcjfZHXL3d6nuqfrfn1WuQs4fB9UqVGurhb
         6Eg5vlMyFGfdyemakIG+rmluzeylokIM2S4Powqq4Q7g1IKqBIKIIbi0BCJgueFQRL6/
         om3y7/ra/Ts7521Kl9sxcb/Fq3eecaa2RcXMBTdpUGexyKC6jRVcx8VMvlr5dkYzeI/B
         vuOA==
X-Gm-Message-State: AOAM532W4TIEL6BTj2m5LH2XjySDHBR/k+1rqKDth9kzUDPpSlo8+rmc
        LRe8yYhCjLuLnJkh/Ssc6dgEdw==
X-Google-Smtp-Source: ABdhPJxHAIxOfP1gnldKHstun5H1abHdqHLb2X/T2JD2kAESUTgN5WNVHyV3Vu92Jqww+Vt7Kv+WGA==
X-Received: by 2002:a17:906:1848:: with SMTP id w8mr4611657eje.277.1622708885445;
        Thu, 03 Jun 2021 01:28:05 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id di16sm1351481edb.62.2021.06.03.01.28.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 01:28:04 -0700 (PDT)
Date:   Thu, 3 Jun 2021 10:28:03 +0200
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Jason Ekstrand <jason@jlekstrand.net>
Cc:     dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        Jason Ekstrand <jason.ekstrand@intel.com>,
        Marcin Slusarz <marcin.slusarz@intel.com>,
        stable@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jon Bloomfield <jon.bloomfield@intel.com>
Subject: Re: [PATCH 4/5] Revert "drm/i915: Propagate errors on awaiting
 already signaled fences"
Message-ID: <YLiSk5bTpt1ZJvYr@phenom.ffwll.local>
References: <20210602164149.391653-1-jason@jlekstrand.net>
 <20210602164149.391653-5-jason@jlekstrand.net>
 <YLiRtZUuloF0qy0b@phenom.ffwll.local>
 <YLiR3CKMYjE9u4+T@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YLiR3CKMYjE9u4+T@phenom.ffwll.local>
X-Operating-System: Linux phenom 5.10.32scarlett+ 
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 03, 2021 at 10:25:00AM +0200, Daniel Vetter wrote:
> On Thu, Jun 03, 2021 at 10:24:21AM +0200, Daniel Vetter wrote:
> > On Wed, Jun 02, 2021 at 11:41:48AM -0500, Jason Ekstrand wrote:
> > > This reverts commit 9e31c1fe45d555a948ff66f1f0e3fe1f83ca63f7.  Ever
> > > since that commit, we've been having issues where a hang in one client
> > > can propagate to another.  In particular, a hang in an app can propagate
> > > to the X server which causes the whole desktop to lock up.
> > 
> > I think we need a note to backporters here:
> > 
> > "For backporters: Please note that you _must_ have a backport of
> > https://lore.kernel.org/dri-devel/20210602164149.391653-2-jason@jlekstrand.net/
> > for otherwise backporting just this patch opens up a security bug."
> >  
> > Or something like that.
> 
> Oh also reordering the patch set so the 2 reverts which are cc: stable are
> first, then the other stuff on top that cleans up the fallout.

Oh also the longer commit message I've done would be nice to add. Or at
least link it or something like that.

https://lore.kernel.org/dri-devel/20210519101523.688398-1-daniel.vetter@ffwll.ch/

I think I mentioned this on irc, but got lost I guess.
-Daniel

> -Daniel
> 
> > -Daniel
> > 
> > > Signed-off-by: Jason Ekstrand <jason.ekstrand@intel.com>
> > > Reported-by: Marcin Slusarz <marcin.slusarz@intel.com>
> > > Cc: <stable@vger.kernel.org> # v5.6+
> > > Cc: Jason Ekstrand <jason.ekstrand@intel.com>
> > > Cc: Marcin Slusarz <marcin.slusarz@intel.com>
> > > Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/3080
> > > Fixes: 9e31c1fe45d5 ("drm/i915: Propagate errors on awaiting already signaled fences")
> > > Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> > > Reviewed-by: Jon Bloomfield <jon.bloomfield@intel.com>
> > > ---
> > >  drivers/gpu/drm/i915/i915_request.c | 8 ++------
> > >  1 file changed, 2 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/drivers/gpu/drm/i915/i915_request.c b/drivers/gpu/drm/i915/i915_request.c
> > > index 970d8f4986bbe..b796197c07722 100644
> > > --- a/drivers/gpu/drm/i915/i915_request.c
> > > +++ b/drivers/gpu/drm/i915/i915_request.c
> > > @@ -1426,10 +1426,8 @@ i915_request_await_execution(struct i915_request *rq,
> > >  
> > >  	do {
> > >  		fence = *child++;
> > > -		if (test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags)) {
> > > -			i915_sw_fence_set_error_once(&rq->submit, fence->error);
> > > +		if (test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags))
> > >  			continue;
> > > -		}
> > >  
> > >  		if (fence->context == rq->fence.context)
> > >  			continue;
> > > @@ -1527,10 +1525,8 @@ i915_request_await_dma_fence(struct i915_request *rq, struct dma_fence *fence)
> > >  
> > >  	do {
> > >  		fence = *child++;
> > > -		if (test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags)) {
> > > -			i915_sw_fence_set_error_once(&rq->submit, fence->error);
> > > +		if (test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags))
> > >  			continue;
> > > -		}
> > >  
> > >  		/*
> > >  		 * Requests on the same timeline are explicitly ordered, along
> > > -- 
> > > 2.31.1
> > > 
> > 
> > -- 
> > Daniel Vetter
> > Software Engineer, Intel Corporation
> > http://blog.ffwll.ch
> 
> -- 
> Daniel Vetter
> Software Engineer, Intel Corporation
> http://blog.ffwll.ch

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
