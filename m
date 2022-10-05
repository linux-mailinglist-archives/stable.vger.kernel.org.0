Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E87B05F5C56
	for <lists+stable@lfdr.de>; Thu,  6 Oct 2022 00:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbiJEWEG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 18:04:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiJEWEE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 18:04:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0DF65A15C
        for <stable@vger.kernel.org>; Wed,  5 Oct 2022 15:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665007441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J9nH6SAe2p+4G72Hb/60qeaydYa0VcigbbhPU+GvRYc=;
        b=bvTMxNjk3nKRN4OQ88kKOMLZ5Fqyv5y1QuwSAYWz9sZfchYu1s/It0zr0HYcE3C+ZWdORv
        1L5+lONufG3EZ8SsjS5++PQSQmvYzWjJPbH3Vwj72pCnLCxlrhxJ476vfAzFXGhTJrP82g
        wHZRfCd8yygURCE2To/sjtcAGZ5u95k=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-168-f7zheraaNo2-dUURMMapyA-1; Wed, 05 Oct 2022 18:04:00 -0400
X-MC-Unique: f7zheraaNo2-dUURMMapyA-1
Received: by mail-io1-f71.google.com with SMTP id r144-20020a6b8f96000000b006b498754be8so3111824iod.9
        for <stable@vger.kernel.org>; Wed, 05 Oct 2022 15:04:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date;
        bh=J9nH6SAe2p+4G72Hb/60qeaydYa0VcigbbhPU+GvRYc=;
        b=VSyxF2dRG0Easme3jPcbggFFKs3AZ4otj7TEoFY55C8EP1p+fsPtGpkOcQ1gAiRxpX
         4Fd9mBrILbenxGxhtHgddI82XTP82CYRgP7CR8s2XWZYZpulxwLDVZo+6eJ18ZcYTdTA
         +hMkEaar8xw5OtUIZmOVten77qnvbemEtF//7oDw6pqg5/0Nt0bv7ygq6LBz+vAw0aMk
         o7nuYod6+7MAIE7+BL+J8VUObmnNcvZ/bv7bPlSuIegUzSZVdpGUqQyuZ3KYwy4Pfbya
         x3lbbBO5MhVaCSXbJbZ4+yW3YIDPMJg9CVgt/D7FBrFTUncpruWieWa536vG4bYtGGS3
         WTMg==
X-Gm-Message-State: ACrzQf0qlj9UuzqFoTd5HhZI4uGnBg4IdgzXS3pNYOyutkQxHeYPgK8R
        6RTrFSdOlLAofWjkpK2ztvBueBaMASV3i+tENy6TQ06kO5TEQb6vBEHUxxRQ2/vNVDCkrQwtV9m
        BXVsXykCX6JfGwRbT
X-Received: by 2002:a05:6e02:1785:b0:2fa:2428:a37b with SMTP id y5-20020a056e02178500b002fa2428a37bmr800233ilu.312.1665007440092;
        Wed, 05 Oct 2022 15:04:00 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM54tO6NXBc78ZQZvuhnh2uwZGv6Nq26Wj8onM9ymY8rQSrnmcaGBAN7T7WDiA6bSu4ubQQJEA==
X-Received: by 2002:a05:6e02:1785:b0:2fa:2428:a37b with SMTP id y5-20020a056e02178500b002fa2428a37bmr800221ilu.312.1665007439878;
        Wed, 05 Oct 2022 15:03:59 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id n10-20020a02a90a000000b0035b6b21c21fsm4474450jam.17.2022.10.05.15.03.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 15:03:58 -0700 (PDT)
Date:   Wed, 5 Oct 2022 16:03:56 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org,
        Zhi Wang <zhi.a.wang@intel.com>
Subject: Re: [PATCH] drm/i915/gvt: Add missing vfio_unregister_group_dev()
 call
Message-ID: <20221005160356.52d6428c.alex.williamson@redhat.com>
In-Reply-To: <20221005141717.234c215e.alex.williamson@redhat.com>
References: <0-v1-013609965fe8+9d-vfio_gvt_unregister_jgg@nvidia.com>
        <20221005141717.234c215e.alex.williamson@redhat.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 5 Oct 2022 14:17:17 -0600
Alex Williamson <alex.williamson@redhat.com> wrote:

> On Thu, 29 Sep 2022 14:48:35 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > When converting to directly create the vfio_device the mdev driver has to
> > put a vfio_register_emulated_iommu_dev() in the probe() and a pairing
> > vfio_unregister_group_dev() in the remove.
> > 
> > This was missed for gvt, add it.
> > 
> > Cc: stable@vger.kernel.org
> > Fixes: 978cf586ac35 ("drm/i915/gvt: convert to use vfio_register_emulated_iommu_dev")
> > Reported-by: Alex Williamson <alex.williamson@redhat.com>
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> >  drivers/gpu/drm/i915/gvt/kvmgt.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > Should go through Alex's tree.
> > 
> > diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
> > index 41bba40feef8f4..9003145adb5a93 100644
> > --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> > +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> > @@ -1615,6 +1615,7 @@ static void intel_vgpu_remove(struct mdev_device *mdev)
> >  	if (WARN_ON_ONCE(vgpu->attached))
> >  		return;

Actually, what's the purpose of this ^^^^ ?

We can't have a .remove callback that does nothing, this breaks
removing the device while it's in use.  Once we have the
vfio_unregister_group_dev() fix below, we'll block until the device is
unused, at which point vgpu->attached becomes false.  Unless I'm
missing something, I think we should also follow-up with a patch to
remove that bogus warn-on branch, right?  Thanks,

Alex

> >  
> > +	vfio_unregister_group_dev(&vgpu->vfio_device);
> >  	vfio_put_device(&vgpu->vfio_device);
> >  }
> >  
> > 
> > base-commit: c72e0034e6d4c36322d958b997d11d2627c6056c  
> 
> This is marked for stable, but I think the stable backport for
> existing kernels is actually:
> 
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
> index e3cd58946477..de89946c4817 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -1595,6 +1595,9 @@ static void intel_vgpu_remove(struct mdev_device *mdev)
>  
>  	if (WARN_ON_ONCE(vgpu->attached))
>  		return;
> +
> +	vfio_unregister_group_dev(&vgpu->vfio_device);
> +	vfio_uninit_group_dev(&vgpu->vfio_device);
>  	intel_gvt_destroy_vgpu(vgpu);
>  }

