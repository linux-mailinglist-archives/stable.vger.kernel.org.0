Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61B8D49370A
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 10:19:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352956AbiASJSL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jan 2022 04:18:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20404 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1352955AbiASJSL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jan 2022 04:18:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642583890;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PtP9Iz6xHgK8mpeAVkx8NjBKePAszJ/UHQqLGQj4py8=;
        b=SC4s/M4ehcr11Fw7FNdGd4dDFca8632FRjuzKd1u/Xi3LZW2eDSYATCBKPPzhIh6O6thmz
        YHol5ZC9irbpp39MceDQQz3DIE8QCiN4ttWTR+rkERFmm8Pg+886qzI9bKOmXXpB5X3DSx
        KhwVDbMpQ3lo7GmQ/GV9UqxFJtzlzAU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-558-8Dczm-GdOKaevMPDDrAkyg-1; Wed, 19 Jan 2022 04:18:09 -0500
X-MC-Unique: 8Dczm-GdOKaevMPDDrAkyg-1
Received: by mail-wm1-f72.google.com with SMTP id f188-20020a1c1fc5000000b0034d79edde84so894194wmf.0
        for <stable@vger.kernel.org>; Wed, 19 Jan 2022 01:18:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PtP9Iz6xHgK8mpeAVkx8NjBKePAszJ/UHQqLGQj4py8=;
        b=bNG+9EEh+6xP6/5lg+vpO/Wb+l2om9xXWFNYD0A/0TGemnix3o0BGOWqOJyr7881K3
         pRl0H6Hyirv4wJkFggkl/cd6evX9GehRgWEQ+BgYNBo6kYi92zbzuZlYrfUYvqYTd//G
         v98JYcrwEnhccciHwOnovN/SqDLwpDdUhZT8bQDTQ9gbPHfM/3YFg/v3OnkZxD/h81Jd
         OavWYX7WKAD4iHTRJQJSjjsiNNzw1SS57G7vt9CT12OF9MbbHomqe8Q3LB1Ag6PJHgr3
         BG570F9gfCuFW/jDQTP2EAJgyxHifHCK8KYpoLJqRH9BOJgW3pSx9mBSX058elnjrk5M
         tT+w==
X-Gm-Message-State: AOAM530awJ/sDKG0UPLBiS3gbuyk2BtokVU5H78GxvDOA9oo3J2vSbh7
        GDZudMUc/xPibcnk46Uwz94t1Ud7WAQb16oGQyk11bzR461Wf+qHjfqBUZlngC+l1IR5s0aYMu6
        NRx1AbAoFeDrJEFrE
X-Received: by 2002:a1c:a5d4:: with SMTP id o203mr2424970wme.43.1642583887744;
        Wed, 19 Jan 2022 01:18:07 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzNONKGHOTAFJF5G1x97BSccLbhtafxrPkf8JhnJiBYP3SHxWpJQF3HD4Wypo5gsmCWaWxBIQ==
X-Received: by 2002:a1c:a5d4:: with SMTP id o203mr2424959wme.43.1642583887489;
        Wed, 19 Jan 2022 01:18:07 -0800 (PST)
Received: from redhat.com ([2a10:8008:4454:0:bb37:a05d:7459:8682])
        by smtp.gmail.com with ESMTPSA id n32sm4860459wms.8.2022.01.19.01.18.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 01:18:06 -0800 (PST)
Date:   Wed, 19 Jan 2022 04:18:04 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org,
        virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH v2 2/2] virtio: acknowledge all features before access
Message-ID: <20220119041343-mutt-send-email-mst@kernel.org>
References: <20220118170225.30620-1-mst@redhat.com>
 <20220118170225.30620-2-mst@redhat.com>
 <CACGkMEt-Q7baDDUM8aC_Lki1aeO36xi02AE7kEapi5NVqkGErg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGkMEt-Q7baDDUM8aC_Lki1aeO36xi02AE7kEapi5NVqkGErg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 19, 2022 at 10:52:34AM +0800, Jason Wang wrote:
> On Wed, Jan 19, 2022 at 1:04 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > The feature negotiation was designed in a way that
> > makes it possible for devices to know which config
> > fields will be accessed by drivers.
> >
> > This is broken since commit 404123c2db79 ("virtio: allow drivers to
> > validate features") with fallout in at least block and net.  We have a
> > partial work-around in commit 2f9a174f918e ("virtio: write back
> > F_VERSION_1 before validate") which at least lets devices find out which
> > format should config space have, but this is a partial fix: guests
> > should not access config space without acknowledging features since
> > otherwise we'll never be able to change the config space format.
> 
> So I guess this is for this part of the spec 3.1.1:
> 
> """
> 4. Read device feature bits, and write the subset of feature bits
> understood by the OS and driver to the device. During this step the
> driver MAY read (but MUST NOT write) the device-specific configuration
> fields to check that it can support the device before accepting it.
> """
> 
> If it is, is this better to quote in the change log?

I don't think this spec actually clarifies anything.
Sent some spec patches to improve the situation.

> Other than this,
> 
> Acked-by: Jason Wang <jasowang@redhat.com>
> 
> >
> > To fix, split finalize_features from virtio_finalize_features and
> > call finalize_features with all feature bits before validation,
> > and then - if validation changed any bits - once again after.
> >
> > Since virtio_finalize_features no longer writes out features
> > rename it to virtio_features_ok - since that is what it does:
> > checks that features are ok with the device.
> >
> > As a side effect, this also reduces the amount of hypervisor accesses -
> > we now only acknowledge features once unless we are clearing any
> > features when validating (which is uncommon).
> >
> > Cc: stable@vger.kernel.org
> > Fixes: 404123c2db79 ("virtio: allow drivers to validate features")
> > Fixes: 2f9a174f918e ("virtio: write back F_VERSION_1 before validate")
> > Cc: "Halil Pasic" <pasic@linux.ibm.com>
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> >
> > fixup! virtio: acknowledge all features before access
> > ---
> >  drivers/virtio/virtio.c       | 39 ++++++++++++++++++++---------------
> >  include/linux/virtio_config.h |  3 ++-
> >  2 files changed, 24 insertions(+), 18 deletions(-)
> >
> > diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
> > index d891b0a354b0..d6396be0ea83 100644
> > --- a/drivers/virtio/virtio.c
> > +++ b/drivers/virtio/virtio.c
> > @@ -166,14 +166,13 @@ void virtio_add_status(struct virtio_device *dev, unsigned int status)
> >  }
> >  EXPORT_SYMBOL_GPL(virtio_add_status);
> >
> > -static int virtio_finalize_features(struct virtio_device *dev)
> > +/* Do some validation, then set FEATURES_OK */
> > +static int virtio_features_ok(struct virtio_device *dev)
> >  {
> > -       int ret = dev->config->finalize_features(dev);
> >         unsigned status;
> > +       int ret;
> >
> >         might_sleep();
> > -       if (ret)
> > -               return ret;
> >
> >         ret = arch_has_restricted_virtio_memory_access();
> >         if (ret) {
> > @@ -244,17 +243,6 @@ static int virtio_dev_probe(struct device *_d)
> >                 driver_features_legacy = driver_features;
> >         }
> >
> > -       /*
> > -        * Some devices detect legacy solely via F_VERSION_1. Write
> > -        * F_VERSION_1 to force LE config space accesses before FEATURES_OK for
> > -        * these when needed.
> > -        */
> > -       if (drv->validate && !virtio_legacy_is_little_endian()
> > -                         && device_features & BIT_ULL(VIRTIO_F_VERSION_1)) {
> > -               dev->features = BIT_ULL(VIRTIO_F_VERSION_1);
> > -               dev->config->finalize_features(dev);
> > -       }
> > -
> >         if (device_features & (1ULL << VIRTIO_F_VERSION_1))
> >                 dev->features = driver_features & device_features;
> >         else
> > @@ -265,13 +253,26 @@ static int virtio_dev_probe(struct device *_d)
> >                 if (device_features & (1ULL << i))
> >                         __virtio_set_bit(dev, i);
> >
> > +       err = dev->config->finalize_features(dev);
> > +       if (err)
> > +               goto err;
> > +
> >         if (drv->validate) {
> > +               u64 features = dev->features;
> > +
> >                 err = drv->validate(dev);
> >                 if (err)
> >                         goto err;
> > +
> > +               /* Did validation change any features? Then write them again. */
> > +               if (features != dev->features) {
> > +                       err = dev->config->finalize_features(dev);
> > +                       if (err)
> > +                               goto err;
> > +               }
> >         }
> >
> > -       err = virtio_finalize_features(dev);
> > +       err = virtio_features_ok(dev);
> >         if (err)
> >                 goto err;
> >
> > @@ -495,7 +496,11 @@ int virtio_device_restore(struct virtio_device *dev)
> >         /* We have a driver! */
> >         virtio_add_status(dev, VIRTIO_CONFIG_S_DRIVER);
> >
> > -       ret = virtio_finalize_features(dev);
> > +       ret = dev->config->finalize_features(dev);
> > +       if (ret)
> > +               goto err;
> > +
> > +       ret = virtio_features_ok(dev);
> >         if (ret)
> >                 goto err;
> >
> > diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
> > index 4d107ad31149..dafdc7f48c01 100644
> > --- a/include/linux/virtio_config.h
> > +++ b/include/linux/virtio_config.h
> > @@ -64,8 +64,9 @@ struct virtio_shm_region {
> >   *     Returns the first 64 feature bits (all we currently need).
> >   * @finalize_features: confirm what device features we'll be using.
> >   *     vdev: the virtio_device
> > - *     This gives the final feature bits for the device: it can change
> > + *     This sends the driver feature bits to the device: it can change
> >   *     the dev->feature bits if it wants.
> > + * Note: despite the name this can be called any number of times.
> >   *     Returns 0 on success or error status
> >   * @bus_name: return the bus name associated with the device (optional)
> >   *     vdev: the virtio_device
> > --
> > MST
> >
> 
> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/virtualization
> 

