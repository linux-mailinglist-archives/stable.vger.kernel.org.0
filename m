Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB73E10E715
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 09:52:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726079AbfLBIwu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 03:52:50 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33598 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbfLBIwu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 03:52:50 -0500
Received: by mail-wr1-f66.google.com with SMTP id b6so13486413wrq.0
        for <stable@vger.kernel.org>; Mon, 02 Dec 2019 00:52:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Z0MLJ1lDR7bVZ0PIp3pKq+TiqzPMdPZDCt8wWgy9uT8=;
        b=FKE2gGEZt1xdOh4pITvuoVWQNIfRgyoGSQQ0c++2SbwTCEUxzjzA+BF9RMPL3A2d67
         1aso1neLVHten21dhwrr4Bg2sx1Fq1SwnxPS2ZvMgNH0r8045oUo20RjH4DljNxFdW3j
         8iLN3jNylTt8pyhUed8X/GtGRbMsQBYv4Rrkc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Z0MLJ1lDR7bVZ0PIp3pKq+TiqzPMdPZDCt8wWgy9uT8=;
        b=pnyKi+Zmy1ETRXm9OGoveH1oVuip2lJVFfsxPE/oDvDwQRGnz8oOn+lGv7zy74v2fG
         4zmNqTeaXj8YgCSqyKdpX/mbrSv5fI8VH8v/nJOwuKsf/Ua2hwIxe6cu5fO2WYrVqVTs
         Xuys7eumSVFUloin2oSAtNyrZwxVbHnmfVGjLgl69FiVvOUpDc+9B3Xe9a5SOJknZ7sY
         AV7ZCgyRTQicSQ7YpawxIjWrCLj3NcVS0g3jlqorXPwB+E8BeirtCkcvqMWWhJ/A9+JV
         Ank763yoQiL/ADe5JWiqwaM5j4N4NHLTXnWZ3issncDv8H3b5CUbQRxz8Dk5TgO81E0X
         cNKQ==
X-Gm-Message-State: APjAAAVp6pjy6gpcXf3rHqCc89/R7ImnIYNx7SH2kuYkTKkOjtJ2OquJ
        cyKgM+8DM994KSHg6OU7gPkKPg==
X-Google-Smtp-Source: APXvYqy8s8egn9cXDKjzeBprcWvs9qgPaH/3c9HZFV/Yh0QMw5AxH89PISxxXh51P4XHoT8FaD1Luw==
X-Received: by 2002:adf:9dc1:: with SMTP id q1mr2174480wre.20.1575276766331;
        Mon, 02 Dec 2019 00:52:46 -0800 (PST)
Received: from phenom.ffwll.local (212-51-149-96.fiber7.init7.net. [212.51.149.96])
        by smtp.gmail.com with ESMTPSA id 76sm23458234wma.0.2019.12.02.00.52.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 00:52:45 -0800 (PST)
Date:   Mon, 2 Dec 2019 09:52:43 +0100
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Boris Brezillon <boris.brezillon@collabora.com>
Cc:     Daniel Vetter <daniel@ffwll.ch>, Rob Herring <robh+dt@kernel.org>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Steven Price <steven.price@arm.com>, stable@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 6/8] drm/panfrost: Make sure imported/exported BOs are
 never purged
Message-ID: <20191202085243.GX624164@phenom.ffwll.local>
References: <20191129135908.2439529-1-boris.brezillon@collabora.com>
 <20191129135908.2439529-7-boris.brezillon@collabora.com>
 <20191129201213.GR624164@phenom.ffwll.local>
 <20191129220924.7982a350@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191129220924.7982a350@collabora.com>
X-Operating-System: Linux phenom 5.3.0-2-amd64 
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 29, 2019 at 10:09:24PM +0100, Boris Brezillon wrote:
> On Fri, 29 Nov 2019 21:12:13 +0100
> Daniel Vetter <daniel@ffwll.ch> wrote:
> 
> > On Fri, Nov 29, 2019 at 02:59:06PM +0100, Boris Brezillon wrote:
> > > We don't want imported/exported BOs to be purges, as those are shared
> > > with other processes that might still use them. We should also refuse
> > > to export a BO if it's been marked purgeable or has already been purged.
> > > 
> > > Fixes: 013b65101315 ("drm/panfrost: Add madvise and shrinker support")
> > > Cc: <stable@vger.kernel.org>
> > > Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
> > > ---
> > >  drivers/gpu/drm/panfrost/panfrost_drv.c | 19 ++++++++++++++++-
> > >  drivers/gpu/drm/panfrost/panfrost_gem.c | 27 +++++++++++++++++++++++++
> > >  2 files changed, 45 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/gpu/drm/panfrost/panfrost_drv.c b/drivers/gpu/drm/panfrost/panfrost_drv.c
> > > index 1c67ac434e10..751df975534f 100644
> > > --- a/drivers/gpu/drm/panfrost/panfrost_drv.c
> > > +++ b/drivers/gpu/drm/panfrost/panfrost_drv.c
> > > @@ -343,6 +343,7 @@ static int panfrost_ioctl_madvise(struct drm_device *dev, void *data,
> > >  	struct drm_panfrost_madvise *args = data;
> > >  	struct panfrost_device *pfdev = dev->dev_private;
> > >  	struct drm_gem_object *gem_obj;
> > > +	int ret;
> > >  
> > >  	gem_obj = drm_gem_object_lookup(file_priv, args->handle);
> > >  	if (!gem_obj) {
> > > @@ -350,6 +351,19 @@ static int panfrost_ioctl_madvise(struct drm_device *dev, void *data,
> > >  		return -ENOENT;
> > >  	}
> > >  
> > > +	/*
> > > +	 * We don't want to mark exported/imported BOs as purgeable: we're not
> > > +	 * the only owner in that case.
> > > +	 */
> > > +	mutex_lock(&dev->object_name_lock);  
> > 
> > Kinda not awesome that you have to take this core lock here and encumber
> > core drm locking with random driver stuff.
> 
> Looks like drm_gem_shmem_is_purgeable() already does the !imported &&
> !exported check. For the imported case, I think we're good, since
> userspace can't change the madv value before ->import_attach has been
> set. For the exporter case, we need to make sure there's no race
> between the export and madvise operations, which I can probably do from
> the gem->export() hook by taking the shrinker or bo->mappings lock.
> 
> > 
> > Can't this be solved with your own locking only and some reasonable
> > ordering of checks? big locks because it's easy is endless long-term pain.
> > 
> > Also exporting purgeable objects is kinda a userspace bug, all you have to
> > do is not oops in dma_buf_attachment_map. No need to prevent the damage
> > here imo.
> 
> I feel like making sure an exported BO can't be purged or a purged BO
> can't be exported would be much simpler than making sure all importers
> are ready to have the sgt freed.

If you free the sgt while someone is using it, that's kinda a different
bug I think. You already have a pages refcount, that should be enough to
prevent this?
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
