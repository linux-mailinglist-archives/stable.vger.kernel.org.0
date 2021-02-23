Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAD40322AD1
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 13:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232655AbhBWMum (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 07:50:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232489AbhBWMul (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Feb 2021 07:50:41 -0500
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90A24C061574
        for <stable@vger.kernel.org>; Tue, 23 Feb 2021 04:50:01 -0800 (PST)
Received: by mail-ot1-x332.google.com with SMTP id s6so15389344otk.4
        for <stable@vger.kernel.org>; Tue, 23 Feb 2021 04:50:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FPAKrMAvr76ZZ2eF/lLL6+MFWv7Fffkz5PR5oq0CnsE=;
        b=i+Km/RJ7ouxi6GrymFrt2Bq2vi5onRxWAmiVOyRvABxjtsxY/Pw5pwHmYdqnhM9qGj
         fB58zBBgen4KcIktI/usVBqpSRsE0wIVsk0hG+2DZxxSR2xovqxxn8lJbTSeukl/1Atb
         ngV8odDAVFWT7kHsSMCCTa00LLmxN4ZkO+ZV8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FPAKrMAvr76ZZ2eF/lLL6+MFWv7Fffkz5PR5oq0CnsE=;
        b=PbZgBYskTRw9C9Q+KN4dEkue6w+DR1KR1Vj76AvCGHyYq5FUyJ+2ho4dZhZ4ImBWIb
         F44XrprN6HlTuEluzNKnWSyA6ycMU9ETMm5EPerGFUqOxLimDvfzMb0iinZ1I0utJiYS
         Ap1aiVZavNsoZzqpzgF49jLzrsQdjlR1qEHmTe9DJ3pwFypYaO5QHcOJAU03ZucSNoeR
         7TOETvZjDnoiZ3FLPezKLpaaJWHbObfZV+Vye9odikCwi0tT7M/5LT2w0LOv+bgYLxvU
         pXH3qlO9w3aGoaMk93/UyPfrm7PFwENpEJYOd65KyowHu/DzKPL+yk3IgjsUVvfZQ6Xg
         aoAg==
X-Gm-Message-State: AOAM533XhLl8Nn8kiDUZ1pWgYTk4ZOtt2htmeYZfX6A+9UYB16FoogqO
        8V0fbpH+CiNB4BpN9D/DZox0uL8tzX86mZUVCoe0lA==
X-Google-Smtp-Source: ABdhPJxMWwzAdP0Ar4zB4RRh27c6CRCZt4SBrUu++3wVbCFCi6sLpStosscbVsoBP9gY4kl/vel7Y5C+F2van7OWnj0=
X-Received: by 2002:a9d:2270:: with SMTP id o103mr19992286ota.303.1614084601033;
 Tue, 23 Feb 2021 04:50:01 -0800 (PST)
MIME-Version: 1.0
References: <20210223105842.27011-1-tzimmermann@suse.de> <YDTk3L3gNxDE3YrC@kroah.com>
 <656a49c3-018e-9188-94bf-5f1270ea61e4@suse.de> <YDT4sHTFdkw3g8es@kroah.com>
In-Reply-To: <YDT4sHTFdkw3g8es@kroah.com>
From:   Daniel Vetter <daniel@ffwll.ch>
Date:   Tue, 23 Feb 2021 13:49:50 +0100
Message-ID: <CAKMK7uHHZQ_zEi6kH0Wk=oHRVkb+sygDbTzBTdo2jZ6cyHABaA@mail.gmail.com>
Subject: Re: [PATCH v3] drm: Use USB controller's DMA mask when importing dmabufs
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Thomas Zimmermann <tzimmermann@suse.de>,
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
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 23, 2021 at 1:44 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, Feb 23, 2021 at 01:37:09PM +0100, Thomas Zimmermann wrote:
> > Hi
> >
> > Am 23.02.21 um 12:19 schrieb Greg KH:
> > > On Tue, Feb 23, 2021 at 11:58:42AM +0100, Thomas Zimmermann wrote:
> > > > USB devices cannot perform DMA and hence have no dma_mask set in their
> > > > device structure. Importing dmabuf into a USB-based driver fails, which
> > > > break joining and mirroring of display in X11.
> > > >
> > > > For USB devices, pick the associated USB controller as attachment device,
> > > > so that it can perform DMA. If the DMa controller does not support DMA
> > > > transfers, we're aout of luck and cannot import.
> > > >
> > > > Drivers should use DRM_GEM_SHMEM_DROVER_OPS_USB to initialize their
> > > > instance of struct drm_driver.
> > > >
> > > > Tested by joining/mirroring displays of udl and radeon un der Gnome/X11.
> > > >
> > > > v3:
> > > >   * drop gem_create_object
> > > >   * use DMA mask of USB controller, if any (Daniel, Christian, Noralf)
> > > > v2:
> > > >   * move fix to importer side (Christian, Daniel)
> > > >   * update SHMEM and CMA helpers for new PRIME callbacks
> > > >
> > > > Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> > > > Fixes: 6eb0233ec2d0 ("usb: don't inherity DMA properties for USB devices")
> > > > Cc: Christoph Hellwig <hch@lst.de>
> > > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > Cc: Johan Hovold <johan@kernel.org>
> > > > Cc: Alan Stern <stern@rowland.harvard.edu>
> > > > Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > > > Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> > > > Cc: Mathias Nyman <mathias.nyman@linux.intel.com>
> > > > Cc: Oliver Neukum <oneukum@suse.com>
> > > > Cc: Thomas Gleixner <tglx@linutronix.de>
> > > > Cc: <stable@vger.kernel.org> # v5.10+
> > > > ---
> > > >   drivers/gpu/drm/drm_prime.c        | 36 ++++++++++++++++++++++++++++++
> > > >   drivers/gpu/drm/tiny/gm12u320.c    |  2 +-
> > > >   drivers/gpu/drm/udl/udl_drv.c      |  2 +-
> > > >   include/drm/drm_gem_shmem_helper.h | 13 +++++++++++
> > > >   include/drm/drm_prime.h            |  5 +++++
> > > >   5 files changed, 56 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
> > > > index 2a54f86856af..9015850f2160 100644
> > > > --- a/drivers/gpu/drm/drm_prime.c
> > > > +++ b/drivers/gpu/drm/drm_prime.c
> > > > @@ -29,6 +29,7 @@
> > > >   #include <linux/export.h>
> > > >   #include <linux/dma-buf.h>
> > > >   #include <linux/rbtree.h>
> > > > +#include <linux/usb.h>
> > > >
> > > >   #include <drm/drm.h>
> > > >   #include <drm/drm_drv.h>
> > > > @@ -1055,3 +1056,38 @@ void drm_prime_gem_destroy(struct drm_gem_object *obj, struct sg_table *sg)
> > > >           dma_buf_put(dma_buf);
> > > >   }
> > > >   EXPORT_SYMBOL(drm_prime_gem_destroy);
> > > > +
> > > > +/**
> > > > + * drm_gem_prime_import_usb - helper library implementation of the import callback for USB devices
> > > > + * @dev: drm_device to import into
> > > > + * @dma_buf: dma-buf object to import
> > > > + *
> > > > + * This is an implementation of drm_gem_prime_import() for USB-based devices.
> > > > + * USB devices cannot perform DMA directly. This function selects the USB host
> > > > + * controller as DMA device instead. Drivers can use this as their
> > > > + * &drm_driver.gem_prime_import implementation.
> > > > + *
> > > > + * See also drm_gem_prime_import().
> > > > + */
> > > > +#ifdef CONFIG_USB
> > > > +struct drm_gem_object *drm_gem_prime_import_usb(struct drm_device *dev,
> > > > +                                         struct dma_buf *dma_buf)
> > > > +{
> > > > + struct usb_device *udev;
> > > > + struct device *usbhost;
> > > > +
> > > > + if (dev->dev->bus != &usb_bus_type)
> > > > +         return ERR_PTR(-ENODEV);
> > > > +
> > > > + udev = interface_to_usbdev(to_usb_interface(dev->dev));
> > > > + if (!udev->bus)
> > > > +         return ERR_PTR(-ENODEV);
> > > > +
> > > > + usbhost = udev->bus->controller;
> > > > + if (!usbhost || !usbhost->dma_mask)
> > > > +         return ERR_PTR(-ENODEV);
> > >
> > > If individual USB drivers need access to this type of thing, shouldn't
> > > that be done in the USB core itself?
> > >
> > > {hint, yes}
> > >
> > > There shouldn't be anything "special" about a DRM driver that needs this
> > > vs. any other driver that might want to know about DMA things related to
> > > a specific USB device.  Why isn't this an issue with the existing
> > > storage or v4l USB devices?
> >
> > I don't know about vc4 or storage. My guess is that they don't call
> > dma_map_sgtable() for devices with dma_mask. Ideally, USB DRM devices
> > wouldn't do that either, but, as Daniel explained, DRM's PRIME framework
> > expects a dma_mask on the importing device.
> >
> > The real fix would move this from framework to drivers, so that each driver
> > can import the dmabuf according to its capabilities. I tried to do this with
> > v2 of this patch, but I was not feasible at this time.
> >
> > For this to work, we'd have rework at least 3 drivers, the PRIME framework
> > and the dmabuf framework. I don't think the stable maintainer would be keen
> > on merging that. ;)
>
> Why not?  If it fixes an issue that has been reported, we've taken
> bigger for smaller bugs :)

The problem is also that I can't just invent a bunch of people out of
thin are to make it happen. If you have them, please send them over,
there's lots to do here :-)

> > Wrt your question about the USB core: what we do here is a workaround for
> > dmabuf importing. The DRM USB drivers don't even use the resulting page
> > mapping directly. Putting the workaround into the USB core is maybe not
> > useful. If we ever use DMA directly for streaming framebuffers to the
> > device, thinks might be different.
>
> Then I really do not understand the issue here.  Why are you wanting to
> grab a "naked" reference to the usb host controller device here?  What
> ensures that it is correct (hint, lots of host controllers do not handle
> dma), and what prevents it from going away underneath you?

We know it's not correct, it's just a hack. We never use this even,
it's just there to not have to rewrite/audit large chunks of drm code.

> And if storage doesn't have this problem, I can't see that it would be
> that difficult for DRM to solve it correctly :)

Give me infinite people, and there's no problem.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
