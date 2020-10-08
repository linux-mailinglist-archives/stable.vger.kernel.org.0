Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE012287D09
	for <lists+stable@lfdr.de>; Thu,  8 Oct 2020 22:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730304AbgJHUYp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Oct 2020 16:24:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32961 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730299AbgJHUYo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Oct 2020 16:24:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602188683;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=juQFOMH9dE2p8xOLnKEBSnl6iWukaOWDLTPaWnsLC+o=;
        b=e1AXrzrNQt7HjaSlnPQwugROjXxIze6XBKKb+YXshUJ2mnKcTnJiFXqR6IcUA4cQHbY7b8
        U87VPPiYyZ+RhcbiqTaQU8jdi1yMSVbZ9X++8TqPoh9GtqGdS3y0blScoaLyPXrliZtjDP
        ObjAxeWekPCdHAbfFuyblHHtrhGPPlc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-3-QbNd-Do7NWipcPQ3XgwCLQ-1; Thu, 08 Oct 2020 16:24:40 -0400
X-MC-Unique: QbNd-Do7NWipcPQ3XgwCLQ-1
Received: by mail-wm1-f72.google.com with SMTP id r19so3500604wmh.9
        for <stable@vger.kernel.org>; Thu, 08 Oct 2020 13:24:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=juQFOMH9dE2p8xOLnKEBSnl6iWukaOWDLTPaWnsLC+o=;
        b=gBBx9+nC2zVG6p5zciPysBBn/zvfoXZ9ljMtzaFX9kai7MjiZF1byIhUvfjxgMYSbW
         vQC4ILcdPcyB1O284VrKtvl+caCuSCEbP+SWvX3SuXCrQtzvyn8OmrBK6HJJuUfZZhhC
         iZrUlh51F/Phv5s8UcMtxvUdVykk5IOrTTZdxId4FuibY5r9T37NSmuRCOyognfYjvIf
         ZeVZWiSqyC8IgIv/2olBL8L+pj9w/j/Y2992PjxOx5oT2si6XZ4G+0InsGKX8h4MtU/d
         u6NVvV2KelJNGHWH/BQiDvgegE8xsBhjyfQVgNEQDjOqkZAhdxsyarB5wpW0P8CDpm+h
         am2A==
X-Gm-Message-State: AOAM532/Sl5j8gb46UiGhuIfPWE/c3qvB7rfnPuoX395hHiYXsx4dkeB
        1LIEkg++ffyq2RvfDLdb5anfgFFu40Ig1zwq1ClrzwdL9q8wvQPgBQDCW/EtjAFXqdAVA4ona87
        5e6Hvreve9ENebQIt
X-Received: by 2002:adf:b1cb:: with SMTP id r11mr11288705wra.339.1602188679374;
        Thu, 08 Oct 2020 13:24:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz0zutp4sbmwgxVvnc/6mlFYkwIqy4tqWMrqBnp4FuNBBRC6tgWuOZeJwG4AHMnrpjmvfj3JQ==
X-Received: by 2002:adf:b1cb:: with SMTP id r11mr11288685wra.339.1602188679120;
        Thu, 08 Oct 2020 13:24:39 -0700 (PDT)
Received: from steredhat (host-79-27-201-176.retail.telecomitalia.it. [79.27.201.176])
        by smtp.gmail.com with ESMTPSA id c4sm8699628wrp.85.2020.10.08.13.24.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 13:24:38 -0700 (PDT)
Date:   Thu, 8 Oct 2020 22:24:36 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>, stable@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH] vringh: fix __vringh_iov() when riov and wiov are
 different
Message-ID: <20201008202436.r33jqbbttqynfvhe@steredhat>
References: <20201008161311.114398-1-sgarzare@redhat.com>
 <20201008160035-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201008160035-mutt-send-email-mst@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 08, 2020 at 04:00:51PM -0400, Michael S. Tsirkin wrote:
> On Thu, Oct 08, 2020 at 06:13:11PM +0200, Stefano Garzarella wrote:
> > If riov and wiov are both defined and they point to different
> > objects, only riov is initialized. If the wiov is not initialized
> > by the caller, the function fails returning -EINVAL and printing
> > "Readable desc 0x... after writable" error message.
> > 
> > Let's replace the 'else if' clause with 'if' to initialize both
> > riov and wiov if they are not NULL.
> > 
> > As checkpatch pointed out, we also avoid crashing the kernel
> > when riov and wiov are both NULL, replacing BUG() with WARN_ON()
> > and returning -EINVAL.
> > 
> > Fixes: f87d0fbb5798 ("vringh: host-side implementation of virtio rings.")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> 
> Can you add more detail please? when does this trigger?

I'm developing vdpa_sim_blk and I'm using vringh_getdesc_iotlb()
to get readable and writable buffers.

With virtio-blk devices a descriptors has both readable and writable
buffers (eg. virtio_blk_outhdr in the readable buffer and status as last byte
of writable buffer).
So, I'm calling vringh_getdesc_iotlb() one time to get both type of buffer
and put them in 2 iovecs:

	ret = vringh_getdesc_iotlb(&vq->vring, &vq->riov, &vq->wiov,
				   &vq->head, GFP_ATOMIC);

With this patch applied it works well, without the function fails
returning -EINVAL and printing "Readable desc 0x... after writable".

Am I using vringh_getdesc_iotlb() in the wrong way?

Thanks,
Stefano

> 
> > ---
> >  drivers/vhost/vringh.c | 9 +++++----
> >  1 file changed, 5 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> > index e059a9a47cdf..8bd8b403f087 100644
> > --- a/drivers/vhost/vringh.c
> > +++ b/drivers/vhost/vringh.c
> > @@ -284,13 +284,14 @@ __vringh_iov(struct vringh *vrh, u16 i,
> >  	desc_max = vrh->vring.num;
> >  	up_next = -1;
> >  
> > +	/* You must want something! */
> > +	if (WARN_ON(!riov && !wiov))
> > +		return -EINVAL;
> > +
> >  	if (riov)
> >  		riov->i = riov->used = 0;
> > -	else if (wiov)
> > +	if (wiov)
> >  		wiov->i = wiov->used = 0;
> > -	else
> > -		/* You must want something! */
> > -		BUG();
> >  
> >  	for (;;) {
> >  		void *addr;
> > -- 
> > 2.26.2
> 

