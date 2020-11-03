Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3782A43BF
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 12:11:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727709AbgKCLIw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 06:08:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgKCLIw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 06:08:52 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A131FC0613D1
        for <stable@vger.kernel.org>; Tue,  3 Nov 2020 03:08:51 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id v5so12295588wmh.1
        for <stable@vger.kernel.org>; Tue, 03 Nov 2020 03:08:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XeBi6ALE7giUjkja8M9G6EY6GTINE8ijRP7xdqDtyEc=;
        b=W6/6CBR9dGL9xtQMFIHuFY2u3TUbz/9anygbLkyU0JtbGaUErnNGiRl/xho40GiNdE
         iz0DIL1Fa17239Iuq29Kt6WAycT8wNg7Q0aA8zblTXRBF9CoRsS9qI3S7/Gr4od1KC8F
         nU57IAUNe1zJOgkhoQ7PO8031dlUWlP+I0/wg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XeBi6ALE7giUjkja8M9G6EY6GTINE8ijRP7xdqDtyEc=;
        b=SaZE6bY16Kg4CrXYaXMdXvycT0fMJHCKofzWbHMkniPKb96QWZauiA98TCZaM1SwJj
         qVeqFGqvTKVoiNAtEMZ0eydxnmxrYD9/uWAYCRp/pNF+i/I9lOXwd8SmUfif2RmeAwAh
         FtFNj405Udcv88sJ7JZqj5px5AFbmMvg14CrYhaRqY4/FlG9rs5KZntl9QQeWdET5Brm
         /towiGOLbW9z6ZY5iiNeCXP56wROaPIJFTnGDO+RvzLwMRTlVqjxkzajKMtex/WkAfPD
         HMGLBcefW/N9qVSa64DrE6zg+RMk9POpJ99akZHLojaFkpo0XOooDbymffhc6DJ3iZGh
         qISg==
X-Gm-Message-State: AOAM5309l3AI+Wl9MdBFYyzmbHvcMXszRcVKzG7XMWfhWMXK7YPRvHZP
        KyjLOX1ihBVpj8gyvZ55qZes8g==
X-Google-Smtp-Source: ABdhPJzqCrMIt19shYM7yXoul6WALo/kJKLEzcJYdefyUaCZ9Pm7J9+b3bH4HAOYyaBdgukK3QNhfg==
X-Received: by 2002:a7b:c3d5:: with SMTP id t21mr2842222wmj.37.1604401730371;
        Tue, 03 Nov 2020 03:08:50 -0800 (PST)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id o184sm2534443wmo.37.2020.11.03.03.08.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 03:08:49 -0800 (PST)
Date:   Tue, 3 Nov 2020 12:08:47 +0100
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Boris Brezillon <boris.brezillon@collabora.com>
Cc:     Daniel Vetter <daniel@ffwll.ch>, Rob Herring <robh+dt@kernel.org>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Steven Price <steven.price@arm.com>,
        Robin Murphy <robin.murphy@arm.com>, stable@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH v3] drm/panfrost: Move the GPU reset bits outside the
 timeout handler
Message-ID: <20201103110847.GG401619@phenom.ffwll.local>
References: <20201103081347.1000139-1-boris.brezillon@collabora.com>
 <20201103102540.GB401619@phenom.ffwll.local>
 <20201103120326.10037005@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201103120326.10037005@collabora.com>
X-Operating-System: Linux phenom 5.7.0-1-amd64 
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 03, 2020 at 12:03:26PM +0100, Boris Brezillon wrote:
> On Tue, 3 Nov 2020 11:25:40 +0100
> Daniel Vetter <daniel@ffwll.ch> wrote:
> 
> > On Tue, Nov 03, 2020 at 09:13:47AM +0100, Boris Brezillon wrote:
> > > We've fixed many races in panfrost_job_timedout() but some remain.
> > > Instead of trying to fix it again, let's simplify the logic and move
> > > the reset bits to a separate work scheduled when one of the queue
> > > reports a timeout.
> > > 
> > > v3:
> > > - Replace the atomic_cmpxchg() by an atomic_xchg() (Robin Murphy)
> > > - Add Steven's R-b
> > > 
> > > v2:
> > > - Use atomic_cmpxchg() to conditionally schedule the reset work (Steven Price)
> > > 
> > > Fixes: 1a11a88cfd9a ("drm/panfrost: Fix job timeout handling")
> > > Cc: <stable@vger.kernel.org>
> > > Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
> > > Reviewed-by: Steven Price <steven.price@arm.com>  
> > 
> > Sprinkling the dma_fence annotations over this would be really nice ...
> 
> You mean something like that?

That's just the irq annotations, i.e. the one that's already guaranteed by
the irq vs. locks checks. So this does nothing.

What I mean is annotating your new reset work (it's part of the critical
path to complete batches, since it's holding up other batches that are
stuck in the scheduler still), and the drm/scheduler annotations I've
floated a while ago. The drm/scheduler annotations are stuck somewhat for
lack of feedback from any of the driver teams using it though :-/

The thing is pulling something out into a worker of it's own generally
doesn't fix any deadlocks, it just hides them from lockdep. So it would be
good to make sure lockdep can see through your maze again.
-Daniel

> 
> --->8---
> From 4f90ee2972eaec0332833ff6f9ea078acbfa899a Mon Sep 17 00:00:00 2001
> From: Boris Brezillon <boris.brezillon@collabora.com>
> Date: Tue, 3 Nov 2020 12:01:09 +0100
> Subject: [PATCH] drm/panfrost: Annotate dma_fence signalling
> 
> Annotate dma_fence signalling to help lockdep catch deadlocks.
> 
> Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
> ---
>  drivers/gpu/drm/panfrost/panfrost_job.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/gpu/drm/panfrost/panfrost_job.c b/drivers/gpu/drm/panfrost/panfrost_job.c
> index 569a099dc10e..046cb3677332 100644
> --- a/drivers/gpu/drm/panfrost/panfrost_job.c
> +++ b/drivers/gpu/drm/panfrost/panfrost_job.c
> @@ -482,7 +482,9 @@ static irqreturn_t panfrost_job_irq_handler(int irq, void *data)
>  
>  		if (status & JOB_INT_MASK_DONE(j)) {
>  			struct panfrost_job *job;
> +			bool cookie;
>  
> +			cookie = dma_fence_begin_signalling();
>  			spin_lock(&pfdev->js->job_lock);
>  			job = pfdev->jobs[j];
>  			/* Only NULL if job timeout occurred */
> @@ -496,6 +498,7 @@ static irqreturn_t panfrost_job_irq_handler(int irq, void *data)
>  				pm_runtime_put_autosuspend(pfdev->dev);
>  			}
>  			spin_unlock(&pfdev->js->job_lock);
> +			dma_fence_end_signalling(cookie);
>  		}
>  
>  		status &= ~mask;

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
