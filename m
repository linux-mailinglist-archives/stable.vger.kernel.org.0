Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58CB73C7152
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 15:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236596AbhGMNlL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Jul 2021 09:41:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236222AbhGMNlK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Jul 2021 09:41:10 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE680C0613DD
        for <stable@vger.kernel.org>; Tue, 13 Jul 2021 06:38:20 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id m11-20020a05600c3b0bb0290228f19cb433so1674890wms.0
        for <stable@vger.kernel.org>; Tue, 13 Jul 2021 06:38:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JXgLaEMV9AycbR+aBsr1GEHEZTKsPIe+O8bYHgn0+8A=;
        b=No9W2eV0gFGsdgaro083xZsih7wNstPq317G3RZvMpcFHmxf+pyZR97e3sdDZPr5wQ
         f6MnmfXpXs3IPPIkrYmd/nJSHVq2Hh1s8VHYZ2RiBZM+J1MscUgt3ntRRPyWX3coys6A
         55WmXn1nAjqEbJEy0iBM+f3mK82hSB2zmQxCs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JXgLaEMV9AycbR+aBsr1GEHEZTKsPIe+O8bYHgn0+8A=;
        b=NbuCx2WAviDcb4gWLp/XBUel8tNT+qmakodDArip23Fx/qUksdp3lC1vZsVATXq1QS
         R6LFd6X6/eqpLqg9zWO6oe62t0Hz/dI1zdqBquowzrVT+sOFXuxjrmYNCLr1dLALZd9V
         hvJYCBvvN5JCt1HQiXc9I/bRAPxtnE6cTdQfEYhLHHdeCnRYOSVUCn+VnGQt6yCSAPaO
         TYnDWlxzU7AereAwNf2tP8L58Ck/D0ibzKqqYydcgyNzM1fufWKptMl9Ms7fZ8bmukzH
         ZnabADDT1hcB9eoao+j5E+muESBcgG/36Vv7CMY3+wYKFHuKvPmljW0FG/4LSkwokLix
         v69Q==
X-Gm-Message-State: AOAM531lmxeRPVkXIY1IsfTbNJw4tjq485xv8/hpKPvx0hxz9lnDg4xm
        0/muq5WULk967WzG1iJ9ASIR4Q==
X-Google-Smtp-Source: ABdhPJwKGByb0HrM4b/cEyIP5bovAUjTfz49C8V5J0SWHVircUw7X9KjQ7WgW7xM6dnU5pGOBEJrdw==
X-Received: by 2002:a1c:9d8f:: with SMTP id g137mr72380wme.13.1626183499233;
        Tue, 13 Jul 2021 06:38:19 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id d24sm2408801wmb.42.2021.07.13.06.38.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jul 2021 06:38:18 -0700 (PDT)
Date:   Tue, 13 Jul 2021 15:38:16 +0200
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Matthew Auld <matthew.auld@intel.com>
Cc:     intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        Jon Bloomfield <jon.bloomfield@intel.com>,
        Chris Wilson <chris.p.wilson@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>, stable@vger.kernel.org
Subject: Re: [PATCH] drm/i915/gtt: drop the page table optimisation
Message-ID: <YO2XSKyCe5FIBwYS@phenom.ffwll.local>
References: <20210713130431.2392740-1-matthew.auld@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210713130431.2392740-1-matthew.auld@intel.com>
X-Operating-System: Linux phenom 5.10.0-7-amd64 
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 13, 2021 at 02:04:31PM +0100, Matthew Auld wrote:
> We skip filling out the pt with scratch entries if the va range covers
> the entire pt, since we later have to fill it with the PTEs for the
> object pages anyway. However this might leave open a small window where
> the PTEs don't point to anything valid for the HW to consume.
> 
> When for example using 2M GTT pages this fill_px() showed up as being
> quite significant in perf measurements, and ends up being completely
> wasted since we ignore the pt and just use the pde directly.
> 
> Anyway, currently we have our PTE construction split between alloc and
> insert, which is probably slightly iffy nowadays, since the alloc
> doesn't actually allocate anything anymore, instead it just sets up the
> page directories and points the PTEs at the scratch page. Later when we
> do the insert step we re-program the PTEs again. Better might be to
> squash the alloc and insert into a single step, then bringing back this
> optimisation(along with some others) should be possible.
> 
> Fixes: 14826673247e ("drm/i915: Only initialize partially filled pagetables")
> Signed-off-by: Matthew Auld <matthew.auld@intel.com>
> Cc: Jon Bloomfield <jon.bloomfield@intel.com>
> Cc: Chris Wilson <chris.p.wilson@intel.com>
> Cc: Daniel Vetter <daniel@ffwll.ch>
> Cc: <stable@vger.kernel.org> # v4.15+

This is some impressively convoluted code, and I'm scared.

But as far as I managed to convince myself, your story here checks out.
Problem will be a bit that this code moved around a _lot_ so we'll need a
lot of dedicated backports :-(

Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>

> ---
>  drivers/gpu/drm/i915/gt/gen8_ppgtt.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/gt/gen8_ppgtt.c b/drivers/gpu/drm/i915/gt/gen8_ppgtt.c
> index 3d02c726c746..6e0e52eeb87a 100644
> --- a/drivers/gpu/drm/i915/gt/gen8_ppgtt.c
> +++ b/drivers/gpu/drm/i915/gt/gen8_ppgtt.c
> @@ -303,10 +303,7 @@ static void __gen8_ppgtt_alloc(struct i915_address_space * const vm,
>  			__i915_gem_object_pin_pages(pt->base);
>  			i915_gem_object_make_unshrinkable(pt->base);
>  
> -			if (lvl ||
> -			    gen8_pt_count(*start, end) < I915_PDES ||
> -			    intel_vgpu_active(vm->i915))
> -				fill_px(pt, vm->scratch[lvl]->encode);
> +			fill_px(pt, vm->scratch[lvl]->encode);
>  
>  			spin_lock(&pd->lock);
>  			if (likely(!pd->entry[idx])) {
> -- 
> 2.26.3
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
