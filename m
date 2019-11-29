Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 071F810DAC6
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 22:09:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbfK2VJc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Nov 2019 16:09:32 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:41618 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727090AbfK2VJc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Nov 2019 16:09:32 -0500
Received: from localhost (unknown [IPv6:2a01:e0a:2c:6930:b93f:9fae:b276:a89a])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bbrezillon)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 18C6029299B;
        Fri, 29 Nov 2019 21:09:28 +0000 (GMT)
Date:   Fri, 29 Nov 2019 22:09:24 +0100
From:   Boris Brezillon <boris.brezillon@collabora.com>
To:     Daniel Vetter <daniel@ffwll.ch>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Steven Price <steven.price@arm.com>, stable@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 6/8] drm/panfrost: Make sure imported/exported BOs are
 never purged
Message-ID: <20191129220924.7982a350@collabora.com>
In-Reply-To: <20191129201213.GR624164@phenom.ffwll.local>
References: <20191129135908.2439529-1-boris.brezillon@collabora.com>
        <20191129135908.2439529-7-boris.brezillon@collabora.com>
        <20191129201213.GR624164@phenom.ffwll.local>
Organization: Collabora
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 29 Nov 2019 21:12:13 +0100
Daniel Vetter <daniel@ffwll.ch> wrote:

> On Fri, Nov 29, 2019 at 02:59:06PM +0100, Boris Brezillon wrote:
> > We don't want imported/exported BOs to be purges, as those are shared
> > with other processes that might still use them. We should also refuse
> > to export a BO if it's been marked purgeable or has already been purged.
> > 
> > Fixes: 013b65101315 ("drm/panfrost: Add madvise and shrinker support")
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
> > ---
> >  drivers/gpu/drm/panfrost/panfrost_drv.c | 19 ++++++++++++++++-
> >  drivers/gpu/drm/panfrost/panfrost_gem.c | 27 +++++++++++++++++++++++++
> >  2 files changed, 45 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/gpu/drm/panfrost/panfrost_drv.c b/drivers/gpu/drm/panfrost/panfrost_drv.c
> > index 1c67ac434e10..751df975534f 100644
> > --- a/drivers/gpu/drm/panfrost/panfrost_drv.c
> > +++ b/drivers/gpu/drm/panfrost/panfrost_drv.c
> > @@ -343,6 +343,7 @@ static int panfrost_ioctl_madvise(struct drm_device *dev, void *data,
> >  	struct drm_panfrost_madvise *args = data;
> >  	struct panfrost_device *pfdev = dev->dev_private;
> >  	struct drm_gem_object *gem_obj;
> > +	int ret;
> >  
> >  	gem_obj = drm_gem_object_lookup(file_priv, args->handle);
> >  	if (!gem_obj) {
> > @@ -350,6 +351,19 @@ static int panfrost_ioctl_madvise(struct drm_device *dev, void *data,
> >  		return -ENOENT;
> >  	}
> >  
> > +	/*
> > +	 * We don't want to mark exported/imported BOs as purgeable: we're not
> > +	 * the only owner in that case.
> > +	 */
> > +	mutex_lock(&dev->object_name_lock);  
> 
> Kinda not awesome that you have to take this core lock here and encumber
> core drm locking with random driver stuff.

Looks like drm_gem_shmem_is_purgeable() already does the !imported &&
!exported check. For the imported case, I think we're good, since
userspace can't change the madv value before ->import_attach has been
set. For the exporter case, we need to make sure there's no race
between the export and madvise operations, which I can probably do from
the gem->export() hook by taking the shrinker or bo->mappings lock.

> 
> Can't this be solved with your own locking only and some reasonable
> ordering of checks? big locks because it's easy is endless long-term pain.
> 
> Also exporting purgeable objects is kinda a userspace bug, all you have to
> do is not oops in dma_buf_attachment_map. No need to prevent the damage
> here imo.

I feel like making sure an exported BO can't be purged or a purged BO
can't be exported would be much simpler than making sure all importers
are ready to have the sgt freed.
