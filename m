Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 869FF10DA26
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 20:32:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727010AbfK2TcX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Nov 2019 14:32:23 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:41094 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726980AbfK2TcX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Nov 2019 14:32:23 -0500
Received: from localhost (unknown [IPv6:2a01:e0a:2c:6930:5cf4:84a1:2763:fe0d])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bbrezillon)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 58A2D29269E;
        Fri, 29 Nov 2019 19:32:22 +0000 (GMT)
Date:   Fri, 29 Nov 2019 20:32:19 +0100
From:   Boris Brezillon <boris.brezillon@collabora.com>
To:     Steven Price <steven.price@arm.com>
Cc:     stable@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Rob Herring <robh+dt@kernel.org>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>
Subject: Re: [PATCH 1/8] drm/panfrost: Make panfrost_job_run() return an
 ERR_PTR() instead of NULL
Message-ID: <20191129203219.2d47d805@collabora.com>
In-Reply-To: <8bd2367c-00a9-bee0-a1a3-c0b9a5ac716f@arm.com>
References: <20191129135908.2439529-1-boris.brezillon@collabora.com>
        <20191129135908.2439529-2-boris.brezillon@collabora.com>
        <7444054c-52b4-32d1-70c2-52bf9c5f2871@arm.com>
        <20191129153155.78003c4e@collabora.com>
        <8bd2367c-00a9-bee0-a1a3-c0b9a5ac716f@arm.com>
Organization: Collabora
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 29 Nov 2019 14:38:50 +0000
Steven Price <steven.price@arm.com> wrote:

> On 29/11/2019 14:31, Boris Brezillon wrote:
> > On Fri, 29 Nov 2019 14:19:50 +0000
> > Steven Price <steven.price@arm.com> wrote:
> >   
> >> On 29/11/2019 13:59, Boris Brezillon wrote:  
> >>> If we don't do that, dma_fence_set_error() complains (called from
> >>> drm_sched_main()).
> >>>
> >>> Fixes: f3ba91228e8e ("drm/panfrost: Add initial panfrost driver")
> >>> Cc: <stable@vger.kernel.org>
> >>> Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>    
> >>
> >> This might be worth doing, but actually it's not Panfrost that is broken
> >> it's the callers, see [1] and [2]. So I don't think we want the
> >> Fixes/stable tag.  
> > 
> > Okay.
> >   
> >>
> >> [1] https://patchwork.kernel.org/patch/11218399/
> >> [2] https://patchwork.kernel.org/patch/11267073/
> >>  
> >>> ---
> >>>  drivers/gpu/drm/panfrost/panfrost_job.c | 4 ++--
> >>>  1 file changed, 2 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/drivers/gpu/drm/panfrost/panfrost_job.c b/drivers/gpu/drm/panfrost/panfrost_job.c
> >>> index 21f34d44aac2..cdd9448fbbdd 100644
> >>> --- a/drivers/gpu/drm/panfrost/panfrost_job.c
> >>> +++ b/drivers/gpu/drm/panfrost/panfrost_job.c
> >>> @@ -328,13 +328,13 @@ static struct dma_fence *panfrost_job_run(struct drm_sched_job *sched_job)
> >>>  	struct dma_fence *fence = NULL;
> >>>  
> >>>  	if (unlikely(job->base.s_fence->finished.error))
> >>> -		return NULL;
> >>> +		return ERR_PTR(job->base.s_fence->finished.error);  
> > 
> > Hm, so we can keep the return NULL here if [1] is applied (the error
> > is preserved), but I'm not sure it's clearer that way.
> >   
> >>>  
> >>>  	pfdev->jobs[slot] = job;
> >>>  
> >>>  	fence = panfrost_fence_create(pfdev, slot);
> >>>  	if (IS_ERR(fence))
> >>> -		return NULL;
> >>> +		return ERR_PTR(-ENOMEM);    
> > 
> > This one should be fixed though, otherwise the error is never updated,
> > so I'm wondering if it doesn't deserve a Fixes tag in the end...  
> 
> Good point, although this can't be back-ported before [3] (well unless
> that commit is considered stable material too), so this is only really
> relevant for v5.4. But worth fixing there.

IIRc, such constraints can be specified with:

Cc: <stable@vger.kernel.org> # v5.4+

Anyway, I'll drop this patch from the series and repost a new version
once [1] has landed.

Thanks for the heads up.

Boris
