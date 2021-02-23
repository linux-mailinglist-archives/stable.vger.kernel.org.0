Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 873B5322AD4
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 13:53:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232378AbhBWMxE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 07:53:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:46756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232299AbhBWMxD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Feb 2021 07:53:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA7B164DDC;
        Tue, 23 Feb 2021 12:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614084742;
        bh=nk0MQGqlsqXf8hpt1bhV9m3BbQcTCKjk5PbpvfehrOs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f3sF5vn1pfpxqhp5+3bdMbcVeHXEj4GkUZjgskbxLyiALkXrd1oAhrun8GuFoLKKA
         Mo4dRlIhGNsQ5OgkTiaqXyHUG3b1cY6JA/pM9oiGWtRAY8lZh4KrzzssdaBngbvO0D
         Kp0mqStCQq9RHdTYQpUHqOEag09FsZhmyU9yU5N4=
Date:   Tue, 23 Feb 2021 13:52:20 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Daniel Vetter <daniel@ffwll.ch>
Cc:     Thomas Zimmermann <tzimmermann@suse.de>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Dave Airlie <airlied@linux.ie>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Oliver Neukum <oneukum@suse.com>,
        Johan Hovold <johan@kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        stable <stable@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sean Paul <sean@poorly.run>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3] drm: Use USB controller's DMA mask when importing
 dmabufs
Message-ID: <YDT6hKde1OWQO9if@kroah.com>
References: <20210223105842.27011-1-tzimmermann@suse.de>
 <YDTk3L3gNxDE3YrC@kroah.com>
 <656a49c3-018e-9188-94bf-5f1270ea61e4@suse.de>
 <YDT4sHTFdkw3g8es@kroah.com>
 <CAKMK7uHHZQ_zEi6kH0Wk=oHRVkb+sygDbTzBTdo2jZ6cyHABaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uHHZQ_zEi6kH0Wk=oHRVkb+sygDbTzBTdo2jZ6cyHABaA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 23, 2021 at 01:49:50PM +0100, Daniel Vetter wrote:
> On Tue, Feb 23, 2021 at 1:44 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Tue, Feb 23, 2021 at 01:37:09PM +0100, Thomas Zimmermann wrote:
> > > Hi
> > >
> > > Am 23.02.21 um 12:19 schrieb Greg KH:
> > > > On Tue, Feb 23, 2021 at 11:58:42AM +0100, Thomas Zimmermann wrote:
> > > > > USB devices cannot perform DMA and hence have no dma_mask set in their
> > > > > device structure. Importing dmabuf into a USB-based driver fails, which
> > > > > break joining and mirroring of display in X11.
> > > > >
> > > > > For USB devices, pick the associated USB controller as attachment device,
> > > > > so that it can perform DMA. If the DMa controller does not support DMA
> > > > > transfers, we're aout of luck and cannot import.
> > > > >
> > > > > Drivers should use DRM_GEM_SHMEM_DROVER_OPS_USB to initialize their
> > > > > instance of struct drm_driver.
> > > > >
> > > > > Tested by joining/mirroring displays of udl and radeon un der Gnome/X11.
> > > > >
> > > > > v3:
> > > > >   * drop gem_create_object
> > > > >   * use DMA mask of USB controller, if any (Daniel, Christian, Noralf)
> > > > > v2:
> > > > >   * move fix to importer side (Christian, Daniel)
> > > > >   * update SHMEM and CMA helpers for new PRIME callbacks
> > > > >
> > > > > Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> > > > > Fixes: 6eb0233ec2d0 ("usb: don't inherity DMA properties for USB devices")
> > > > > Cc: Christoph Hellwig <hch@lst.de>
> > > > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > > Cc: Johan Hovold <johan@kernel.org>
> > > > > Cc: Alan Stern <stern@rowland.harvard.edu>
> > > > > Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > > > > Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> > > > > Cc: Mathias Nyman <mathias.nyman@linux.intel.com>
> > > > > Cc: Oliver Neukum <oneukum@suse.com>
> > > > > Cc: Thomas Gleixner <tglx@linutronix.de>
> > > > > Cc: <stable@vger.kernel.org> # v5.10+
> > > > > ---
> > > > >   drivers/gpu/drm/drm_prime.c        | 36 ++++++++++++++++++++++++++++++
> > > > >   drivers/gpu/drm/tiny/gm12u320.c    |  2 +-
> > > > >   drivers/gpu/drm/udl/udl_drv.c      |  2 +-
> > > > >   include/drm/drm_gem_shmem_helper.h | 13 +++++++++++
> > > > >   include/drm/drm_prime.h            |  5 +++++
> > > > >   5 files changed, 56 insertions(+), 2 deletions(-)
> > > > >
> > > > > diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
> > > > > index 2a54f86856af..9015850f2160 100644
> > > > > --- a/drivers/gpu/drm/drm_prime.c
> > > > > +++ b/drivers/gpu/drm/drm_prime.c
> > > > > @@ -29,6 +29,7 @@
> > > > >   #include <linux/export.h>
> > > > >   #include <linux/dma-buf.h>
> > > > >   #include <linux/rbtree.h>
> > > > > +#include <linux/usb.h>
> > > > >
> > > > >   #include <drm/drm.h>
> > > > >   #include <drm/drm_drv.h>
> > > > > @@ -1055,3 +1056,38 @@ void drm_prime_gem_destroy(struct drm_gem_object *obj, struct sg_table *sg)
> > > > >           dma_buf_put(dma_buf);
> > > > >   }
> > > > >   EXPORT_SYMBOL(drm_prime_gem_destroy);
> > > > > +
> > > > > +/**
> > > > > + * drm_gem_prime_import_usb - helper library implementation of the import callback for USB devices
> > > > > + * @dev: drm_device to import into
> > > > > + * @dma_buf: dma-buf object to import
> > > > > + *
> > > > > + * This is an implementation of drm_gem_prime_import() for USB-based devices.
> > > > > + * USB devices cannot perform DMA directly. This function selects the USB host
> > > > > + * controller as DMA device instead. Drivers can use this as their
> > > > > + * &drm_driver.gem_prime_import implementation.
> > > > > + *
> > > > > + * See also drm_gem_prime_import().
> > > > > + */
> > > > > +#ifdef CONFIG_USB
> > > > > +struct drm_gem_object *drm_gem_prime_import_usb(struct drm_device *dev,
> > > > > +                                         struct dma_buf *dma_buf)
> > > > > +{
> > > > > + struct usb_device *udev;
> > > > > + struct device *usbhost;
> > > > > +
> > > > > + if (dev->dev->bus != &usb_bus_type)
> > > > > +         return ERR_PTR(-ENODEV);
> > > > > +
> > > > > + udev = interface_to_usbdev(to_usb_interface(dev->dev));
> > > > > + if (!udev->bus)
> > > > > +         return ERR_PTR(-ENODEV);
> > > > > +
> > > > > + usbhost = udev->bus->controller;
> > > > > + if (!usbhost || !usbhost->dma_mask)
> > > > > +         return ERR_PTR(-ENODEV);
> > > >
> > > > If individual USB drivers need access to this type of thing, shouldn't
> > > > that be done in the USB core itself?
> > > >
> > > > {hint, yes}
> > > >
> > > > There shouldn't be anything "special" about a DRM driver that needs this
> > > > vs. any other driver that might want to know about DMA things related to
> > > > a specific USB device.  Why isn't this an issue with the existing
> > > > storage or v4l USB devices?
> > >
> > > I don't know about vc4 or storage. My guess is that they don't call
> > > dma_map_sgtable() for devices with dma_mask. Ideally, USB DRM devices
> > > wouldn't do that either, but, as Daniel explained, DRM's PRIME framework
> > > expects a dma_mask on the importing device.
> > >
> > > The real fix would move this from framework to drivers, so that each driver
> > > can import the dmabuf according to its capabilities. I tried to do this with
> > > v2 of this patch, but I was not feasible at this time.
> > >
> > > For this to work, we'd have rework at least 3 drivers, the PRIME framework
> > > and the dmabuf framework. I don't think the stable maintainer would be keen
> > > on merging that. ;)
> >
> > Why not?  If it fixes an issue that has been reported, we've taken
> > bigger for smaller bugs :)
> 
> The problem is also that I can't just invent a bunch of people out of
> thin are to make it happen. If you have them, please send them over,
> there's lots to do here :-)
> 
> > > Wrt your question about the USB core: what we do here is a workaround for
> > > dmabuf importing. The DRM USB drivers don't even use the resulting page
> > > mapping directly. Putting the workaround into the USB core is maybe not
> > > useful. If we ever use DMA directly for streaming framebuffers to the
> > > device, thinks might be different.
> >
> > Then I really do not understand the issue here.  Why are you wanting to
> > grab a "naked" reference to the usb host controller device here?  What
> > ensures that it is correct (hint, lots of host controllers do not handle
> > dma), and what prevents it from going away underneath you?
> 
> We know it's not correct, it's just a hack. We never use this even,
> it's just there to not have to rewrite/audit large chunks of drm code.

If you don't need the device, then why do you need a pointer to it?

Now I'm totally lost and confused what this patch is even supposed to be
doing in the first place :(

Is all you need that magic "mask"?  Something else?

Again, passing around "naked" pointers is going to cause problems, what
happens when the bus is removed from the system?

thanks,

greg k-h
