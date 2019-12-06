Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C488114D32
	for <lists+stable@lfdr.de>; Fri,  6 Dec 2019 09:08:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726088AbfLFIIO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Dec 2019 03:08:14 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:37552 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbfLFIIO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Dec 2019 03:08:14 -0500
Received: from localhost (unknown [IPv6:2a01:e0a:2c:6930:5cf4:84a1:2763:fe0d])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bbrezillon)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 5D8992925B0;
        Fri,  6 Dec 2019 08:08:12 +0000 (GMT)
Date:   Fri, 6 Dec 2019 09:08:09 +0100
From:   Boris Brezillon <boris.brezillon@collabora.com>
To:     Rob Herring <robh+dt@kernel.org>
Cc:     Steven Price <steven.price@arm.com>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        stable <stable@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH 2/8] drm/panfrost: Fix a race in
 panfrost_ioctl_madvise()
Message-ID: <20191206090809.0832f4aa@collabora.com>
In-Reply-To: <20191206085327.66a8c479@collabora.com>
References: <20191129135908.2439529-1-boris.brezillon@collabora.com>
        <20191129135908.2439529-3-boris.brezillon@collabora.com>
        <dd8a946c-5666-a7b8-f7bc-06647e0d0bbc@arm.com>
        <20191129153310.2f9c80e1@collabora.com>
        <CAL_JsqK_+U4G-EZXfBo+NhwZRsSyyndxuuh8LH88im0C5EKzeA@mail.gmail.com>
        <20191206085327.66a8c479@collabora.com>
Organization: Collabora
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 6 Dec 2019 08:53:27 +0100
Boris Brezillon <boris.brezillon@collabora.com> wrote:

> On Thu, 5 Dec 2019 17:08:02 -0600
> Rob Herring <robh+dt@kernel.org> wrote:
> 
> > On Fri, Nov 29, 2019 at 8:33 AM Boris Brezillon
> > <boris.brezillon@collabora.com> wrote:  
> > >
> > > On Fri, 29 Nov 2019 14:24:48 +0000
> > > Steven Price <steven.price@arm.com> wrote:
> > >    
> > > > On 29/11/2019 13:59, Boris Brezillon wrote:    
> > > > > If 2 threads change the MADVISE property of the same BO in parallel we
> > > > > might end up with an shmem->madv value that's inconsistent with the
> > > > > presence of the BO in the shrinker list.    
> > > >
> > > > I'm a bit worried from the point of view of user space sanity that you
> > > > observed this - but clearly the kernel should be robust!    
> > >
> > > It's not something I observed, just found the race by inspecting the
> > > code, and I thought it was worth fixing it.    
> > 
> > I'm not so sure there's a race.  
> 
> I'm pretty sure there's one:
> 
> T0				T1
> 
> lock(pages)
> madv = 1
> unlock(pages)
> 
> 				lock(pages)
> 				madv = 0
> 				unlock(pages)
> 
> 				lock(shrinker)
> 				remove_from_list(bo)
> 				unlock(shrinker)
> 
> lock(shrinker)
> add_to_list(bo)
> unlock(shrinker)
> 
> You end up with madv = 0 and the BO is added to the list.
> 
> > If there is, we still check madv value
> > when purging, so it would be harmless even if the state is
> > inconsistent.  
> 
> Indeed. Note that you could also have this other situation where the BO
> is marked purgeable but not present in the list. In that case it will
> never be purged, but it's kinda user space fault anyway. I agree, none
> of this problems are critical, and I'm fine leaving it unfixed as long
> as it's documented somewhere that the race exist and is harmless.
> 
> >   
> > > > > The easiest solution to fix that is to protect the
> > > > > drm_gem_shmem_madvise() call with the shrinker lock.
> > > > >
> > > > > Fixes: 013b65101315 ("drm/panfrost: Add madvise and shrinker support")
> > > > > Cc: <stable@vger.kernel.org>
> > > > > Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>    
> > > >
> > > > Reviewed-by: Steven Price <steven.price@arm.com>    
> > >
> > > Thanks.
> > >    
> > > >    
> > > > > ---
> > > > >  drivers/gpu/drm/panfrost/panfrost_drv.c | 9 ++++-----
> > > > >  1 file changed, 4 insertions(+), 5 deletions(-)
> > > > >
> > > > > diff --git a/drivers/gpu/drm/panfrost/panfrost_drv.c b/drivers/gpu/drm/panfrost/panfrost_drv.c
> > > > > index f21bc8a7ee3a..efc0a24d1f4c 100644
> > > > > --- a/drivers/gpu/drm/panfrost/panfrost_drv.c
> > > > > +++ b/drivers/gpu/drm/panfrost/panfrost_drv.c
> > > > > @@ -347,20 +347,19 @@ static int panfrost_ioctl_madvise(struct drm_device *dev, void *data,
> > > > >             return -ENOENT;
> > > > >     }
> > > > >
> > > > > +   mutex_lock(&pfdev->shrinker_lock);
> > > > >     args->retained = drm_gem_shmem_madvise(gem_obj, args->madv);    
> > 
> > This means we now hold the shrinker_lock while we take the pages_lock.
> > Is lockdep happy with this change? I suspect not given all the fun I
> > had getting lockdep happy.  
> 
> I have tested with lockdep enabled and it's all good from lockdep PoV
> because the locks are taken in the same order in the madvise() and
> schinker_scan() path (first the shrinker lock, then the pages lock).
> 
> Note that patch 7 introduces a deadlock in the shrinker path, but this
> is unrelated to this shrinker lock being taken earlier in madvise
> (drm_gem_put_pages() is called while the pages lock is already held).

My bad, there's no deadlock in this version, because we don't use
->pages_use_count to retain the page table (we just use a gpu_usecount
in patch 8 to prevent the purge). But I started working on a version
that uses ->pages_use_count instead of introducing yet another
refcount, and in this version I take/release a ref on the page table in
the mmu_map()/mmu_unmap() path. This causes a deadlock when GEM mappings
are teared down by the shrinker logic (because the pages lock is already
taken in panfrost_gem_purge())...


