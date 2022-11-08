Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A76B9621A60
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 18:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234435AbiKHRYL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 12:24:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234413AbiKHRYI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 12:24:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91F82BA7
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 09:24:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3DCF5B81BAC
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 17:24:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 539EBC433D6;
        Tue,  8 Nov 2022 17:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667928244;
        bh=Y6Ryl9oZa2ISdQBf49JkwE28vnGmSUeJ0iARZBq+FK4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Vq9Uvv9J4tUCm0hNqvMZIIwRsNSWyPCHwY3yc3w5LepROTghTUzEEu4XP1svCgUt3
         qRaWxtUhJ+J9Pe0qlSwNsgldrFWISU6kwJeDdyFGXujWHFqP58TOoe/fs11e5m3Q86
         CwEkQIHrtRX/xQ66hPp0kxJOo9Nuos/7VQo2ATvQ=
Date:   Tue, 8 Nov 2022 18:24:00 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Kevin Tian <kevin.tian@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, stable@vger.kernel.org,
        patches@lists.linux.dev, Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.0 003/197] drm/i915/gvt: Add missing
 vfio_unregister_group_dev() call
Message-ID: <Y2qQsNt6VAJBL9rU@kroah.com>
References: <20221108133354.787209461@linuxfoundation.org>
 <20221108133354.938359604@linuxfoundation.org>
 <20221108091651.716e3124.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108091651.716e3124.alex.williamson@redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 08, 2022 at 09:16:51AM -0700, Alex Williamson wrote:
> On Tue,  8 Nov 2022 14:37:21 +0100
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> 
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > 
> > [ Upstream commit f423fa1bc9fe1978e6b9f54927411b62cb43eb04 ]
> > 
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
> > Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > Link: https://lore.kernel.org/r/0-v1-013609965fe8+9d-vfio_gvt_unregister_jgg@nvidia.com
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  drivers/gpu/drm/i915/gvt/kvmgt.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
> > index e3cd58946477..dacd57732dbe 100644
> > --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> > +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> > @@ -1595,6 +1595,7 @@ static void intel_vgpu_remove(struct mdev_device *mdev)
> >  
> >  	if (WARN_ON_ONCE(vgpu->attached))
> >  		return;
> > +	vfio_unregister_group_dev(&vgpu->vfio_device);
> >  	intel_gvt_destroy_vgpu(vgpu);
> >  }
> >  
> 
> Nak, the v6.0 backport for this also needs to call
> vfio_uninit_group_dev().  kvmgt had missed both calls, but at the time
> of f423fa1bc9fe this latter missing call had already been replaced by
> vfio_put_device() in a5ddd2a99a7a, where cb9ff3f3b84c had implemented a
> device release function with this call.  The correct backport should be:
> 
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
> index e3cd58946477..2404d856f764 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -1595,6 +1595,8 @@ static void intel_vgpu_remove(struct mdev_device *mdev)
>  
>  	if (WARN_ON_ONCE(vgpu->attached))
>  		return;
> +	vfio_unregister_group_dev(&vgpu->vfio_device);
> +	vfio_uninit_group_dev(&vgpu->vfio_device);
>  	intel_gvt_destroy_vgpu(vgpu);
>  }
>  
> Kevin, Yi, please confirm.  Thanks,

Can you submit a real backport for this?  I'll go drop this one for now.

thanks,

greg k-h
