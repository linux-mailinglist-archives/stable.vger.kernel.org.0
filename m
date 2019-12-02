Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE16810E7F5
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 10:50:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727318AbfLBJut (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 04:50:49 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:59312 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbfLBJut (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 04:50:49 -0500
Received: from localhost (unknown [IPv6:2a01:e0a:2c:6930:5cf4:84a1:2763:fe0d])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bbrezillon)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id DE55E28DE03;
        Mon,  2 Dec 2019 09:50:46 +0000 (GMT)
Date:   Mon, 2 Dec 2019 10:50:44 +0100
From:   Boris Brezillon <boris.brezillon@collabora.com>
To:     Daniel Vetter <daniel@ffwll.ch>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Steven Price <steven.price@arm.com>, stable@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 6/8] drm/panfrost: Make sure imported/exported BOs are
 never purged
Message-ID: <20191202105044.108549fa@collabora.com>
In-Reply-To: <20191202085243.GX624164@phenom.ffwll.local>
References: <20191129135908.2439529-1-boris.brezillon@collabora.com>
        <20191129135908.2439529-7-boris.brezillon@collabora.com>
        <20191129201213.GR624164@phenom.ffwll.local>
        <20191129220924.7982a350@collabora.com>
        <20191202085243.GX624164@phenom.ffwll.local>
Organization: Collabora
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2 Dec 2019 09:52:43 +0100
Daniel Vetter <daniel@ffwll.ch> wrote:

> On Fri, Nov 29, 2019 at 10:09:24PM +0100, Boris Brezillon wrote:
> > On Fri, 29 Nov 2019 21:12:13 +0100
> > Daniel Vetter <daniel@ffwll.ch> wrote:
> >   
> > > On Fri, Nov 29, 2019 at 02:59:06PM +0100, Boris Brezillon wrote:  
> > > > We don't want imported/exported BOs to be purges, as those are shared
> > > > with other processes that might still use them. We should also refuse
> > > > to export a BO if it's been marked purgeable or has already been purged.
> > > > 
> > > > Fixes: 013b65101315 ("drm/panfrost: Add madvise and shrinker support")
> > > > Cc: <stable@vger.kernel.org>
> > > > Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
> > > > ---
> > > >  drivers/gpu/drm/panfrost/panfrost_drv.c | 19 ++++++++++++++++-
> > > >  drivers/gpu/drm/panfrost/panfrost_gem.c | 27 +++++++++++++++++++++++++
> > > >  2 files changed, 45 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/drivers/gpu/drm/panfrost/panfrost_drv.c b/drivers/gpu/drm/panfrost/panfrost_drv.c
> > > > index 1c67ac434e10..751df975534f 100644
> > > > --- a/drivers/gpu/drm/panfrost/panfrost_drv.c
> > > > +++ b/drivers/gpu/drm/panfrost/panfrost_drv.c
> > > > @@ -343,6 +343,7 @@ static int panfrost_ioctl_madvise(struct drm_device *dev, void *data,
> > > >  	struct drm_panfrost_madvise *args = data;
> > > >  	struct panfrost_device *pfdev = dev->dev_private;
> > > >  	struct drm_gem_object *gem_obj;
> > > > +	int ret;
> > > >  
> > > >  	gem_obj = drm_gem_object_lookup(file_priv, args->handle);
> > > >  	if (!gem_obj) {
> > > > @@ -350,6 +351,19 @@ static int panfrost_ioctl_madvise(struct drm_device *dev, void *data,
> > > >  		return -ENOENT;
> > > >  	}
> > > >  
> > > > +	/*
> > > > +	 * We don't want to mark exported/imported BOs as purgeable: we're not
> > > > +	 * the only owner in that case.
> > > > +	 */
> > > > +	mutex_lock(&dev->object_name_lock);    
> > > 
> > > Kinda not awesome that you have to take this core lock here and encumber
> > > core drm locking with random driver stuff.  
> > 
> > Looks like drm_gem_shmem_is_purgeable() already does the !imported &&
> > !exported check. For the imported case, I think we're good, since
> > userspace can't change the madv value before ->import_attach has been
> > set. For the exporter case, we need to make sure there's no race
> > between the export and madvise operations, which I can probably do from
> > the gem->export() hook by taking the shrinker or bo->mappings lock.

Okay, I tried that, and I actually need an extra
panfrost_gem_object->exported field that's set to true from the
->export() hook with the mappings lock held, otherwise the code is
still racy (->dma_buf is assigned after ->export() returns).

> >   
> > > 
> > > Can't this be solved with your own locking only and some reasonable
> > > ordering of checks? big locks because it's easy is endless long-term pain.
> > > 
> > > Also exporting purgeable objects is kinda a userspace bug, all you have to
> > > do is not oops in dma_buf_attachment_map. No need to prevent the damage
> > > here imo.  
> > 
> > I feel like making sure an exported BO can't be purged or a purged BO
> > can't be exported would be much simpler than making sure all importers
> > are ready to have the sgt freed.  
> 
> If you free the sgt while someone is using it, that's kinda a different
> bug I think. You already have a pages refcount, that should be enough to
> prevent this?

My bad, I thought drm_gem_shmem_get_pages_sgt() was used as the
->get_sg_table() implem, but we actually use
drm_gem_shmem_get_sg_table() which allocates a new sgt. I still need to
make sure we're safe against sgt destruction in panfrost.
