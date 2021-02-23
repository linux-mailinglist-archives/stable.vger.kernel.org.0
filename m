Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21B8C322AC6
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 13:48:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232604AbhBWMsY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 07:48:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232473AbhBWMsW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Feb 2021 07:48:22 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDA6DC06174A
        for <stable@vger.kernel.org>; Tue, 23 Feb 2021 04:47:41 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id c16so15436440otp.0
        for <stable@vger.kernel.org>; Tue, 23 Feb 2021 04:47:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=UWbwIZiuB0vNqhDSjGIAmC63TRWp8yrtocIt1bsjpwY=;
        b=j+sNJwjY3DDI9P8LlD0Y0kk/GEqazlMovBg2Tyb27midrguJWAEnWb6fEQObEh1spZ
         xJ4vecxj6ZlndIFxUzSif8hAmvy6wywvwR5Of7oYoP5eQyWBI+zhCYunnyhnQgqFtwmx
         Y/zhYW+xsCj4Qu47uLm/ZHtR+V1MXD97CqN5g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=UWbwIZiuB0vNqhDSjGIAmC63TRWp8yrtocIt1bsjpwY=;
        b=khS8FYeN3C9z1fvtVh0hG0awqCbncy9pK+66pXSY/7FWF5Z3ZPry1CRnduSmHwbOYt
         nymjzGf/5Ot1SeHrV2YhyK/zFwAY5o+/yjsm73+ybPpXSLVR9U5UJYRIPHxCDJGcKHsO
         onSz+sF6F3CMFzKW/y028UukszD9Fc0CWpxKzANm+RrST6RDWvKyExobLmZCKfUmeyXK
         LFd7wOkNmxrIuqFBrTQGPRJDjEAdxOR0VurUA5WHeSYm2ZNZRYddwstFy+QnZDHcabPO
         22+3dz0XkqDNvjF2uVsjArFC34P5N7HQRaoIm4xUCTYM6d862BvuHssGt87TobYTJ+BN
         biOg==
X-Gm-Message-State: AOAM533+WSzhLrDDVcbHxH7dkN+c3ohDSZQe7OLwJghXyF6M27DaSHZT
        Yq5y0q1stgbz1LOnBh1NabkUZUp7XywBsjP6dfNyqA==
X-Google-Smtp-Source: ABdhPJxWK8y1GCLroELu+A8TMO4v/vRPY4KdliJbQAhqsYjiBrmy2csfTOcjMzC4XAVXx0cCmtWDlnpGOJ8vnHNkyv0=
X-Received: by 2002:a9d:b85:: with SMTP id 5mr20935991oth.281.1614084461194;
 Tue, 23 Feb 2021 04:47:41 -0800 (PST)
MIME-Version: 1.0
References: <20210223105842.27011-1-tzimmermann@suse.de> <YDTk3L3gNxDE3YrC@kroah.com>
 <656a49c3-018e-9188-94bf-5f1270ea61e4@suse.de>
In-Reply-To: <656a49c3-018e-9188-94bf-5f1270ea61e4@suse.de>
From:   Daniel Vetter <daniel@ffwll.ch>
Date:   Tue, 23 Feb 2021 13:47:30 +0100
Message-ID: <CAKMK7uFkE=XrYYOxjH=iQXtDurO+=jv=EFP12LO+htVV=PV1yw@mail.gmail.com>
Subject: Re: [PATCH v3] drm: Use USB controller's DMA mask when importing dmabufs
To:     Thomas Zimmermann <tzimmermann@suse.de>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Dave Airlie <airlied@linux.ie>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Oliver Neukum <oneukum@suse.com>,
        Johan Hovold <johan@kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        stable <stable@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sean Paul <sean@poorly.run>, Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 23, 2021 at 1:37 PM Thomas Zimmermann <tzimmermann@suse.de> wro=
te:
>
> Hi
>
> Am 23.02.21 um 12:19 schrieb Greg KH:
> > On Tue, Feb 23, 2021 at 11:58:42AM +0100, Thomas Zimmermann wrote:
> >> USB devices cannot perform DMA and hence have no dma_mask set in their
> >> device structure. Importing dmabuf into a USB-based driver fails, whic=
h
> >> break joining and mirroring of display in X11.
> >>
> >> For USB devices, pick the associated USB controller as attachment devi=
ce,
> >> so that it can perform DMA. If the DMa controller does not support DMA
> >> transfers, we're aout of luck and cannot import.
> >>
> >> Drivers should use DRM_GEM_SHMEM_DROVER_OPS_USB to initialize their
> >> instance of struct drm_driver.
> >>
> >> Tested by joining/mirroring displays of udl and radeon un der Gnome/X1=
1.
> >>
> >> v3:
> >>      * drop gem_create_object
> >>      * use DMA mask of USB controller, if any (Daniel, Christian, Nora=
lf)
> >> v2:
> >>      * move fix to importer side (Christian, Daniel)
> >>      * update SHMEM and CMA helpers for new PRIME callbacks
> >>
> >> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> >> Fixes: 6eb0233ec2d0 ("usb: don't inherity DMA properties for USB devic=
es")
> >> Cc: Christoph Hellwig <hch@lst.de>
> >> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >> Cc: Johan Hovold <johan@kernel.org>
> >> Cc: Alan Stern <stern@rowland.harvard.edu>
> >> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> >> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> >> Cc: Mathias Nyman <mathias.nyman@linux.intel.com>
> >> Cc: Oliver Neukum <oneukum@suse.com>
> >> Cc: Thomas Gleixner <tglx@linutronix.de>
> >> Cc: <stable@vger.kernel.org> # v5.10+
> >> ---
> >>   drivers/gpu/drm/drm_prime.c        | 36 ++++++++++++++++++++++++++++=
++
> >>   drivers/gpu/drm/tiny/gm12u320.c    |  2 +-
> >>   drivers/gpu/drm/udl/udl_drv.c      |  2 +-
> >>   include/drm/drm_gem_shmem_helper.h | 13 +++++++++++
> >>   include/drm/drm_prime.h            |  5 +++++
> >>   5 files changed, 56 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
> >> index 2a54f86856af..9015850f2160 100644
> >> --- a/drivers/gpu/drm/drm_prime.c
> >> +++ b/drivers/gpu/drm/drm_prime.c
> >> @@ -29,6 +29,7 @@
> >>   #include <linux/export.h>
> >>   #include <linux/dma-buf.h>
> >>   #include <linux/rbtree.h>
> >> +#include <linux/usb.h>
> >>
> >>   #include <drm/drm.h>
> >>   #include <drm/drm_drv.h>
> >> @@ -1055,3 +1056,38 @@ void drm_prime_gem_destroy(struct drm_gem_objec=
t *obj, struct sg_table *sg)
> >>      dma_buf_put(dma_buf);
> >>   }
> >>   EXPORT_SYMBOL(drm_prime_gem_destroy);
> >> +
> >> +/**
> >> + * drm_gem_prime_import_usb - helper library implementation of the im=
port callback for USB devices
> >> + * @dev: drm_device to import into
> >> + * @dma_buf: dma-buf object to import
> >> + *
> >> + * This is an implementation of drm_gem_prime_import() for USB-based =
devices.
> >> + * USB devices cannot perform DMA directly. This function selects the=
 USB host
> >> + * controller as DMA device instead. Drivers can use this as their
> >> + * &drm_driver.gem_prime_import implementation.
> >> + *
> >> + * See also drm_gem_prime_import().
> >> + */
> >> +#ifdef CONFIG_USB
> >> +struct drm_gem_object *drm_gem_prime_import_usb(struct drm_device *de=
v,
> >> +                                            struct dma_buf *dma_buf)
> >> +{
> >> +    struct usb_device *udev;
> >> +    struct device *usbhost;
> >> +
> >> +    if (dev->dev->bus !=3D &usb_bus_type)
> >> +            return ERR_PTR(-ENODEV);
> >> +
> >> +    udev =3D interface_to_usbdev(to_usb_interface(dev->dev));
> >> +    if (!udev->bus)
> >> +            return ERR_PTR(-ENODEV);
> >> +
> >> +    usbhost =3D udev->bus->controller;
> >> +    if (!usbhost || !usbhost->dma_mask)
> >> +            return ERR_PTR(-ENODEV);
> >
> > If individual USB drivers need access to this type of thing, shouldn't
> > that be done in the USB core itself?
> >
> > {hint, yes}
> >
> > There shouldn't be anything "special" about a DRM driver that needs thi=
s
> > vs. any other driver that might want to know about DMA things related t=
o
> > a specific USB device.  Why isn't this an issue with the existing
> > storage or v4l USB devices?
>
> I don't know about vc4 or storage. My guess is that they don't call
> dma_map_sgtable() for devices with dma_mask. Ideally, USB DRM devices
> wouldn't do that either, but, as Daniel explained, DRM's PRIME framework
> expects a dma_mask on the importing device.
>
> The real fix would move this from framework to drivers, so that each
> driver can import the dmabuf according to its capabilities. I tried to
> do this with v2 of this patch, but I was not feasible at this time.
>
> For this to work, we'd have rework at least 3 drivers, the PRIME
> framework and the dmabuf framework. I don't think the stable maintainer
> would be keen on merging that. ;)
>
> Wrt your question about the USB core: what we do here is a workaround
> for dmabuf importing. The DRM USB drivers don't even use the resulting
> page mapping directly. Putting the workaround into the USB core is maybe
> not useful. If we ever use DMA directly for streaming framebuffers to
> the device, thinks might be different.

Yeah if we ever do this (direct dma from dma-buf to usb devices) then
a clean interface would need the usb subsystem to take care of the
dma-buf attachment, dma setup and everything in the usb host driver.
So even in that hypothetical world, none of this is anything that usb
ever will want, we'd need an interface at a slightly higher level.
Essentially urb transfer function that can receive/send into/from
dma-buf.
-Daniel

>
> Best regards
> Thomas
>
> >
> > thanks,
> >
> > greg k-h
> > _______________________________________________
> > dri-devel mailing list
> > dri-devel@lists.freedesktop.org
> > https://lists.freedesktop.org/mailman/listinfo/dri-devel
> >
>
> --
> Thomas Zimmermann
> Graphics Driver Developer
> SUSE Software Solutions Germany GmbH
> Maxfeldstr. 5, 90409 N=C3=BCrnberg, Germany
> (HRB 36809, AG N=C3=BCrnberg)
> Gesch=C3=A4ftsf=C3=BChrer: Felix Imend=C3=B6rffer
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel



--=20
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
