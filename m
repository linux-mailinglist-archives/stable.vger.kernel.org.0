Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C57B96B3EC9
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 13:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbjCJMKA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 07:10:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbjCJMJO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 07:09:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 430D42FCCD;
        Fri, 10 Mar 2023 04:08:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EECC76130C;
        Fri, 10 Mar 2023 12:07:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED2DAC433EF;
        Fri, 10 Mar 2023 12:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678450053;
        bh=di2j3nQbkXRg2ckj9GOfhfAoU2Sqk7XeV5n5iWf9XCM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ez83VQzmNe6Ghgmg5skqmKhAgrh72ajFWeZEVj9PVQ/t/cb/PRyfpklhJQfnkwb6T
         N38JZhvwiWtmvGEm0qm8udenPMBb4Am3xl5P9t8p4LcfDcsEPed2XzoBJahE2cFC0g
         HUGccem8IOCBKwemr7mtckYztsZgW5KVaNJn2mYQ=
Date:   Fri, 10 Mar 2023 13:07:30 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dmitry Osipenko <dmitry.osipenko@collabora.com>
Cc:     Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        stable@vger.kernel.org, kraxel@redhat.com,
        linux-kernel@vger.kernel.org, emil.l.velikov@gmail.com,
        airlied@linux.ie, error27@gmail.com, darren.kenny@oracle.com,
        vegard.nossum@oracle.com
Subject: Re: [PATCH 5.15.y] drm/virtio: Fix error code in
 virtio_gpu_object_shmem_init()
Message-ID: <ZAsdguMTwKIRdVBn@kroah.com>
References: <20230302172538.3508747-1-harshit.m.mogalapalli@oracle.com>
 <d2cf9564-3b0c-b9e4-6066-8e8e6eb854f0@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d2cf9564-3b0c-b9e4-6066-8e8e6eb854f0@collabora.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 04, 2023 at 12:32:22AM +0300, Dmitry Osipenko wrote:
> On 3/2/23 20:25, Harshit Mogalapalli wrote:
> > In virtio_gpu_object_shmem_init() we are passing NULL to PTR_ERR, which
> > is returning 0/success.
> > 
> > Fix this by storing error value in 'ret' variable before assigning
> > shmem->pages to NULL.
> > 
> > Found using static analysis with Smatch.
> > 
> > Fixes: 64b88afbd92f ("drm/virtio: Correct drm_gem_shmem_get_sg_table() error handling")
> > Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
> > ---
> > Only compile tested.
> > 
> > Upstream commit b5c9ed70d1a9 ("drm/virtio: Improve DMA API usage for shmem BOs")
> > deleted this code, so this patch is not necessary in linux-6.1.y and
> > linux-6.2.y.
> > ---
> >  drivers/gpu/drm/virtio/virtgpu_object.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/gpu/drm/virtio/virtgpu_object.c b/drivers/gpu/drm/virtio/virtgpu_object.c
> > index 7e75fb0fc7bd..25d399b00404 100644
> > --- a/drivers/gpu/drm/virtio/virtgpu_object.c
> > +++ b/drivers/gpu/drm/virtio/virtgpu_object.c
> > @@ -169,8 +169,9 @@ static int virtio_gpu_object_shmem_init(struct virtio_gpu_device *vgdev,
> >  	shmem->pages = drm_gem_shmem_get_sg_table(&bo->base);
> >  	if (IS_ERR(shmem->pages)) {
> >  		drm_gem_shmem_unpin(&bo->base);
> > +		ret = PTR_ERR(shmem->pages);
> >  		shmem->pages = NULL;
> > -		return PTR_ERR(shmem->pages);
> > +		return ret;
> >  	}
> >  
> >  	if (use_dma_api) {
> 
> Reviewed-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>

Both fixes now queued up, thanks.

greg k-h
