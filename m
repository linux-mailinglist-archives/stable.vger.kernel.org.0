Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D07512B43A6
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 13:26:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbgKPMZo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 07:25:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59742 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728269AbgKPMZo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Nov 2020 07:25:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605529542;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=twYAjgtjeEtP7dme/B3MtQN8LFC4b+SiLV0pksaCw+Q=;
        b=beiNO0zmf1qEofoM6i6EUb8FXyRKDHCv7whNvQKSQhkrAYGpW54JifkHafQdEAICko/pXf
        4WvB6vWtD8nIvhuymQ2Y5gRLq+QjQNWgJmYgZ+hIEFg46/Rnau/imd2Ao66txutxC1NsBe
        hPIizj0dXXZl6onCyHNQWjMCxL1wa88=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-375-kpc-s-6BPgGqcYgIIRr0gg-1; Mon, 16 Nov 2020 07:25:40 -0500
X-MC-Unique: kpc-s-6BPgGqcYgIIRr0gg-1
Received: by mail-wm1-f69.google.com with SMTP id h9so8918535wmf.8
        for <stable@vger.kernel.org>; Mon, 16 Nov 2020 04:25:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=twYAjgtjeEtP7dme/B3MtQN8LFC4b+SiLV0pksaCw+Q=;
        b=rOVkIFvHH9HvnZJztfdz2ul3xIqEB0XPCaOtPFrz4RlpPf+WlltVJkeoTnxGltndbd
         chSJAnEeZa3cflzY870QuWWL6ZwKJIDp4DFsrcaN0XAGjgRBCbJ10u/9iUpVoJNKr52+
         PhWA9D0kbUt7UvBtMPYDPi82EwFhg1TiFbUQRoutdvan1A8zjonjx9UYQVgF/98l3z9m
         olxHXQMO1mXSHPkSHk92nW5aZYog68UUz6oW+5AO2p+AII98VasqERSCsV4tvZw1YR6U
         LY9gYijSuX5bUnBvpS5BWz7ENVCsO1rwmV6MH/J2sRzLBXKL002c3lLyuSK/06CatmRi
         z9qQ==
X-Gm-Message-State: AOAM533KLipdYr3mRnehycFoI6Ohrd+3hcsk2VkuOYqxdRAGYnrUyOLM
        uC+eTpkm//SU02jW0ym+Z7O+I+dHOWkP7vISMdH/5hFTLl5L6VVkzqX2CmRXBvaL0jBg5xm6lGD
        XTSpcSO57SRFXSvoL
X-Received: by 2002:adf:a551:: with SMTP id j17mr20868539wrb.217.1605529539627;
        Mon, 16 Nov 2020 04:25:39 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzTpJY9zGC+xn6xq+CTHXLTZWqhazVhhm46QQKKwl8uV2NZSejldsTJ5sdUDy6obYAtroP4Vw==
X-Received: by 2002:adf:a551:: with SMTP id j17mr20868522wrb.217.1605529539401;
        Mon, 16 Nov 2020 04:25:39 -0800 (PST)
Received: from redhat.com ([147.161.8.56])
        by smtp.gmail.com with ESMTPSA id i10sm22686923wrs.22.2020.11.16.04.25.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 04:25:38 -0800 (PST)
Date:   Mon, 16 Nov 2020 07:25:31 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Alexander Lobakin <alobakin@pm.me>, Amit Shah <amit@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnaud Pouliquen <arnaud.pouliquen@st.com>,
        Suman Anna <s-anna@ti.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-remoteproc@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH virtio] virtio: virtio_console: fix DMA memory allocation
 for rproc serial
Message-ID: <20201116071910-mutt-send-email-mst@kernel.org>
References: <AOKowLclCbOCKxyiJ71WeNyuAAj2q8EUtxrXbyky5E@cp7-web-042.plabs.ch>
 <20201116091950.GA30524@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201116091950.GA30524@infradead.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 16, 2020 at 09:19:50AM +0000, Christoph Hellwig wrote:
> I just noticed this showing up in Linus' tree and I'm not happy.

Are you sure? I think it's in next.

> This whole model of the DMA subdevices in remoteproc is simply broken.
> 
> We really need to change the virtio code pass an expicit DMA device (
> similar to what e.g. the USB and RDMA code does), instead of faking up
> devices with broken adhoc inheritance of DMA properties and magic poking
> into device parent relationships.

OK but we do have a regression since 5.7 and this looks like
a fix appropriate for e.g. stable, right?

> Bjorn, I thought you were going to look into this a while ago?
> 
> 
> On Wed, Nov 04, 2020 at 03:31:36PM +0000, Alexander Lobakin wrote:
> > Since commit 086d08725d34 ("remoteproc: create vdev subdevice with
> > specific dma memory pool"), every remoteproc has a DMA subdevice
> > ("remoteprocX#vdevYbuffer") for each virtio device, which inherits
> > DMA capabilities from the corresponding platform device. This allowed
> > to associate different DMA pools with each vdev, and required from
> > virtio drivers to perform DMA operations with the parent device
> > (vdev->dev.parent) instead of grandparent (vdev->dev.parent->parent).
> > 
> > virtio_rpmsg_bus was already changed in the same merge cycle with
> > commit d999b622fcfb ("rpmsg: virtio: allocate buffer from parent"),
> > but virtio_console did not. In fact, operations using the grandparent
> > worked fine while the grandparent was the platform device, but since
> > commit c774ad010873 ("remoteproc: Fix and restore the parenting
> > hierarchy for vdev") this was changed, and now the grandparent device
> > is the remoteproc device without any DMA capabilities.
> > So, starting v5.8-rc1 the following warning is observed:
> > 
> > [    2.483925] ------------[ cut here ]------------
> > [    2.489148] WARNING: CPU: 3 PID: 101 at kernel/dma/mapping.c:427 0x80e7eee8
> > [    2.489152] Modules linked in: virtio_console(+)
> > [    2.503737]  virtio_rpmsg_bus rpmsg_core
> > [    2.508903]
> > [    2.528898] <Other modules, stack and call trace here>
> > [    2.913043]
> > [    2.914907] ---[ end trace 93ac8746beab612c ]---
> > [    2.920102] virtio-ports vport1p0: Error allocating inbufs
> > 
> > kernel/dma/mapping.c:427 is:
> > 
> > WARN_ON_ONCE(!dev->coherent_dma_mask);
> > 
> > obviously because the grandparent now is remoteproc dev without any
> > DMA caps:
> > 
> > [    3.104943] Parent: remoteproc0#vdev1buffer, grandparent: remoteproc0
> > 
> > Fix this the same way as it was for virtio_rpmsg_bus, using just the
> > parent device (vdev->dev.parent, "remoteprocX#vdevYbuffer") for DMA
> > operations.
> > This also allows now to reserve DMA pools/buffers for rproc serial
> > via Device Tree.
> > 
> > Fixes: c774ad010873 ("remoteproc: Fix and restore the parenting hierarchy for vdev")
> > Cc: stable@vger.kernel.org # 5.1+
> > Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> > ---
> >  drivers/char/virtio_console.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
> > index a2da8f768b94..1836cc56e357 100644
> > --- a/drivers/char/virtio_console.c
> > +++ b/drivers/char/virtio_console.c
> > @@ -435,12 +435,12 @@ static struct port_buffer *alloc_buf(struct virtio_device *vdev, size_t buf_size
> >  		/*
> >  		 * Allocate DMA memory from ancestor. When a virtio
> >  		 * device is created by remoteproc, the DMA memory is
> > -		 * associated with the grandparent device:
> > -		 * vdev => rproc => platform-dev.
> > +		 * associated with the parent device:
> > +		 * virtioY => remoteprocX#vdevYbuffer.
> >  		 */
> > -		if (!vdev->dev.parent || !vdev->dev.parent->parent)
> > +		buf->dev = vdev->dev.parent;
> > +		if (!buf->dev)
> >  			goto free_buf;
> > -		buf->dev = vdev->dev.parent->parent;
> >  
> >  		/* Increase device refcnt to avoid freeing it */
> >  		get_device(buf->dev);
> > -- 
> > 2.29.2
> > 
> > 
> ---end quoted text---

