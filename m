Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 971EA31AA5
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 10:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726142AbfFAIzv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 04:55:51 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:46224 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbfFAIzv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 Jun 2019 04:55:51 -0400
Received: from localhost (unknown [IPv6:2a01:e0a:2c:6930:5cf4:84a1:2763:fe0d])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bbrezillon)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 42A662612A0;
        Sat,  1 Jun 2019 09:55:50 +0100 (BST)
Date:   Sat, 1 Jun 2019 10:55:47 +0200
From:   Boris Brezillon <boris.brezillon@collabora.com>
To:     Tomeu Vizoso <tomeu@tomeuvizoso.net>
Cc:     Rob Herring <robh+dt@kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] drm/panfrost: Make sure a BO is only unmapped when
 appropriate
Message-ID: <20190601105547.5efe481d@collabora.com>
In-Reply-To: <CAAObsKBYvVKVTJf6ZwSarAVr6FSCz-NDYNhEqrDhBWUM3q57Nw@mail.gmail.com>
References: <20190529091836.22060-1-boris.brezillon@collabora.com>
        <CAAObsKBYvVKVTJf6ZwSarAVr6FSCz-NDYNhEqrDhBWUM3q57Nw@mail.gmail.com>
Organization: Collabora
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 31 May 2019 14:54:54 +0200
Tomeu Vizoso <tomeu@tomeuvizoso.net> wrote:

> On Wed, 29 May 2019 at 11:18, Boris Brezillon
> <boris.brezillon@collabora.com> wrote:
> >
> > mmu_ops->unmap() will fail when called on a BO that has not been
> > previously mapped, and the error path in panfrost_ioctl_create_bo()
> > can call drm_gem_object_put_unlocked() (which in turn calls
> > panfrost_mmu_unmap()) on a BO that has not been mapped yet.
> >
> > Keep track of the mapped/unmapped state to avoid such issues.
> >
> > Fixes: f3ba91228e8e ("drm/panfrost: Add initial panfrost driver")
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
> > ---
> >  drivers/gpu/drm/panfrost/panfrost_gem.h | 1 +
> >  drivers/gpu/drm/panfrost/panfrost_mmu.c | 8 ++++++++
> >  2 files changed, 9 insertions(+)
> >
> > diff --git a/drivers/gpu/drm/panfrost/panfrost_gem.h b/drivers/gpu/drm/panfrost/panfrost_gem.h
> > index 045000eb5fcf..6dbcaba020fc 100644
> > --- a/drivers/gpu/drm/panfrost/panfrost_gem.h
> > +++ b/drivers/gpu/drm/panfrost/panfrost_gem.h
> > @@ -11,6 +11,7 @@ struct panfrost_gem_object {
> >         struct drm_gem_shmem_object base;
> >
> >         struct drm_mm_node node;
> > +       bool is_mapped;
> >  };
> >
> >  static inline
> > diff --git a/drivers/gpu/drm/panfrost/panfrost_mmu.c b/drivers/gpu/drm/panfrost/panfrost_mmu.c
> > index 762b1bd2a8c2..fb556aa89203 100644
> > --- a/drivers/gpu/drm/panfrost/panfrost_mmu.c
> > +++ b/drivers/gpu/drm/panfrost/panfrost_mmu.c
> > @@ -156,6 +156,9 @@ int panfrost_mmu_map(struct panfrost_gem_object *bo)
> >         struct sg_table *sgt;
> >         int ret;
> >
> > +       if (bo->is_mapped)
> > +               return 0;  
> 
> In what circumstances we want to silently go on? I would expect that
> for this function to be called when the BO has been mapped already
> would mean that we have a bug in the kernel, so why not a WARN?
> 
> > +
> >         sgt = drm_gem_shmem_get_pages_sgt(obj);
> >         if (WARN_ON(IS_ERR(sgt)))
> >                 return PTR_ERR(sgt);
> > @@ -189,6 +192,7 @@ int panfrost_mmu_map(struct panfrost_gem_object *bo)
> >
> >         pm_runtime_mark_last_busy(pfdev->dev);
> >         pm_runtime_put_autosuspend(pfdev->dev);
> > +       bo->is_mapped = true;
> >
> >         return 0;
> >  }
> > @@ -203,6 +207,9 @@ void panfrost_mmu_unmap(struct panfrost_gem_object *bo)
> >         size_t unmapped_len = 0;
> >         int ret;
> >
> > +       if (!bo->is_mapped)
> > +               return;  
> 
> Similarly, I think that what we should do is not to call
> panfrost_mmu_unmap when a BO is freed if we know it isn't mapped. And
> probably add a WARN here if it still gets called when the BO isn't
> mapped.

Okay, will add WARN_ON()s and add a check in the caller.

