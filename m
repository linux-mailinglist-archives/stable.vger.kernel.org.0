Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0358E322B3E
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 14:11:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232712AbhBWNKv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 08:10:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:49396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232566AbhBWNKl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Feb 2021 08:10:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 60A1564E2E;
        Tue, 23 Feb 2021 13:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614085801;
        bh=3mKAFNLkex9Rng+D781XbEWwNMKo75V9EzlFCGYQRPU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TRmkM/Br+Adj4T5wVxONOIh/+EZVGz1egXxkXgVu1v7FtMT60JLp6dOMPnI+6f/ZF
         tnUH7ouKYef5zEfqHGa9XJuVOXiMJGe79IfqLI6sIastYLqnkjddrTiCBu/jNrHHeR
         I3lB4S3OCm3F4i+g2BQT3whZJRCznjOmrrXr5UQA=
Date:   Tue, 23 Feb 2021 14:09:58 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Thomas Zimmermann <tzimmermann@suse.de>
Cc:     Daniel Vetter <daniel@ffwll.ch>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Airlie <airlied@linux.ie>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Oliver Neukum <oneukum@suse.com>,
        Christoph Hellwig <hch@lst.de>,
        Hans de Goede <hdegoede@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        stable <stable@vger.kernel.org>, Johan Hovold <johan@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sean Paul <sean@poorly.run>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Subject: Re: [PATCH v3] drm: Use USB controller's DMA mask when importing
 dmabufs
Message-ID: <YDT+pusRy3/JpmRR@kroah.com>
References: <20210223105842.27011-1-tzimmermann@suse.de>
 <YDTk3L3gNxDE3YrC@kroah.com>
 <YDTrDAlcFH/7/7DD@phenom.ffwll.local>
 <YDTu4ugLo23APyaM@kroah.com>
 <CAKMK7uG67eHEFOCJBJCtwFbwoUWQsER4DNBKRp6e75uywvF1pw@mail.gmail.com>
 <YDT0GIJEhWRp0w5F@kroah.com>
 <9b1e0c9b-2337-d76b-4870-72fbe8495fd2@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b1e0c9b-2337-d76b-4870-72fbe8495fd2@suse.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 23, 2021 at 01:51:09PM +0100, Thomas Zimmermann wrote:
> Hi
> 
> Am 23.02.21 um 13:24 schrieb Greg KH:
> > On Tue, Feb 23, 2021 at 01:14:30PM +0100, Daniel Vetter wrote:
> > > On Tue, Feb 23, 2021 at 1:02 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> > > > 
> > > > On Tue, Feb 23, 2021 at 12:46:20PM +0100, Daniel Vetter wrote:
> > > > > On Tue, Feb 23, 2021 at 12:19:56PM +0100, Greg KH wrote:
> > > > > > On Tue, Feb 23, 2021 at 11:58:42AM +0100, Thomas Zimmermann wrote:
> > > > > > > USB devices cannot perform DMA and hence have no dma_mask set in their
> > > > > > > device structure. Importing dmabuf into a USB-based driver fails, which
> > > > > > > break joining and mirroring of display in X11.
> > > > > > > 
> > > > > > > For USB devices, pick the associated USB controller as attachment device,
> > > > > > > so that it can perform DMA. If the DMa controller does not support DMA
> > > > > > > transfers, we're aout of luck and cannot import.
> > > > > > > 
> > > > > > > Drivers should use DRM_GEM_SHMEM_DROVER_OPS_USB to initialize their
> > > > > > > instance of struct drm_driver.
> > > > > > > 
> > > > > > > Tested by joining/mirroring displays of udl and radeon un der Gnome/X11.
> > > > > > > 
> > > > > > > v3:
> > > > > > >    * drop gem_create_object
> > > > > > >    * use DMA mask of USB controller, if any (Daniel, Christian, Noralf)
> > > > > > > v2:
> > > > > > >    * move fix to importer side (Christian, Daniel)
> > > > > > >    * update SHMEM and CMA helpers for new PRIME callbacks
> > > > > > > 
> > > > > > > Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> > > > > > > Fixes: 6eb0233ec2d0 ("usb: don't inherity DMA properties for USB devices")
> > > > > > > Cc: Christoph Hellwig <hch@lst.de>
> > > > > > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > > > > Cc: Johan Hovold <johan@kernel.org>
> > > > > > > Cc: Alan Stern <stern@rowland.harvard.edu>
> > > > > > > Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > > > > > > Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> > > > > > > Cc: Mathias Nyman <mathias.nyman@linux.intel.com>
> > > > > > > Cc: Oliver Neukum <oneukum@suse.com>
> > > > > > > Cc: Thomas Gleixner <tglx@linutronix.de>
> > > > > > > Cc: <stable@vger.kernel.org> # v5.10+
> > > > > > > ---
> > > > > > >   drivers/gpu/drm/drm_prime.c        | 36 ++++++++++++++++++++++++++++++
> > > > > > >   drivers/gpu/drm/tiny/gm12u320.c    |  2 +-
> > > > > > >   drivers/gpu/drm/udl/udl_drv.c      |  2 +-
> > > > > > >   include/drm/drm_gem_shmem_helper.h | 13 +++++++++++
> > > > > > >   include/drm/drm_prime.h            |  5 +++++
> > > > > > >   5 files changed, 56 insertions(+), 2 deletions(-)
> > > > > > > 
> > > > > > > diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
> > > > > > > index 2a54f86856af..9015850f2160 100644
> > > > > > > --- a/drivers/gpu/drm/drm_prime.c
> > > > > > > +++ b/drivers/gpu/drm/drm_prime.c
> > > > > > > @@ -29,6 +29,7 @@
> > > > > > >   #include <linux/export.h>
> > > > > > >   #include <linux/dma-buf.h>
> > > > > > >   #include <linux/rbtree.h>
> > > > > > > +#include <linux/usb.h>
> > > > > > > 
> > > > > > >   #include <drm/drm.h>
> > > > > > >   #include <drm/drm_drv.h>
> > > > > > > @@ -1055,3 +1056,38 @@ void drm_prime_gem_destroy(struct drm_gem_object *obj, struct sg_table *sg)
> > > > > > >    dma_buf_put(dma_buf);
> > > > > > >   }
> > > > > > >   EXPORT_SYMBOL(drm_prime_gem_destroy);
> > > > > > > +
> > > > > > > +/**
> > > > > > > + * drm_gem_prime_import_usb - helper library implementation of the import callback for USB devices
> > > > > > > + * @dev: drm_device to import into
> > > > > > > + * @dma_buf: dma-buf object to import
> > > > > > > + *
> > > > > > > + * This is an implementation of drm_gem_prime_import() for USB-based devices.
> > > > > > > + * USB devices cannot perform DMA directly. This function selects the USB host
> > > > > > > + * controller as DMA device instead. Drivers can use this as their
> > > > > > > + * &drm_driver.gem_prime_import implementation.
> > > > > > > + *
> > > > > > > + * See also drm_gem_prime_import().
> > > > > > > + */
> > > > > > > +#ifdef CONFIG_USB
> > > > > > > +struct drm_gem_object *drm_gem_prime_import_usb(struct drm_device *dev,
> > > > > > > +                                         struct dma_buf *dma_buf)
> > > > > > > +{
> > > > > > > + struct usb_device *udev;
> > > > > > > + struct device *usbhost;
> > > > > > > +
> > > > > > > + if (dev->dev->bus != &usb_bus_type)
> > > > > > > +         return ERR_PTR(-ENODEV);
> > > > > > > +
> > > > > > > + udev = interface_to_usbdev(to_usb_interface(dev->dev));
> > > > > > > + if (!udev->bus)
> > > > > > > +         return ERR_PTR(-ENODEV);
> > > > > > > +
> > > > > > > + usbhost = udev->bus->controller;
> > > > > > > + if (!usbhost || !usbhost->dma_mask)
> > > > > > > +         return ERR_PTR(-ENODEV);
> > > > > > 
> > > > > > If individual USB drivers need access to this type of thing, shouldn't
> > > > > > that be done in the USB core itself?
> > > > > > 
> > > > > > {hint, yes}
> > > > > > 
> > > > > > There shouldn't be anything "special" about a DRM driver that needs this
> > > > > > vs. any other driver that might want to know about DMA things related to
> > > > > > a specific USB device.  Why isn't this an issue with the existing
> > > > > > storage or v4l USB devices?
> > > > > 
> > > > > The trouble is that this is a regression fix for 5.9, because the dma-api
> > > > > got more opinionated about what it allows. The proper fix is a lot more
> > > > > invasive (we essentially need to rework the drm_prime.c to allow dma-buf
> > > > > importing for just cpu access), and that's a ton more invasive than just a
> > > > > small patch with can stuff into stable kernels.
> > > > > 
> > > > > This here is ugly, but it should at least get rid of black screens again.
> > > > > 
> > > > > I think solid FIXME comment explaining the situation would be good.
> > > > 
> > > > Why can't I take a USB patch for a regression fix?  Is drm somehow
> > > > stand-alone that you make changes here that should belong in other
> > > > subsystems?
> > > > 
> > > > {hint, it shouldn't be}
> > > > 
> > > > When you start poking in the internals of usb controller structures,
> > > > that logic belongs in the USB core for all drivers to use, not in a
> > > > random tiny subsystem where no USB developer will ever notice it?  :)
> > > 
> > > Because the usb fix isn't the right fix here, it's just the duct-tape.
> > > We don't want to dig around in these internals, it's just a convenient
> > > way to shut up the dma-api until drm has sorted out its confusion.
> > > 
> > > We can polish the turd if you want, but the thing is, it's still a turd ...
> > > 
> > > The right fix is to change drm_prime.c code to not call dma_map_sg
> > > when we don't need it. The problem is that roughly 3 layers of code
> > > (drm_prime, dma-buf, gem shmem helpers) are involved. Plus, since
> > > drm_prime is shared by all drm drivers, all other drm drivers are
> > > impacted too. We're not going to be able to cc: stable that kind of
> > > stuff. Thomas actually started with that series, until I pointed out
> > > how bad things really are.
> > > 
> > > And before you ask: The dma-api change makes sense, and dma-api vs drm
> > > relations are strained since years, so we're not going ask for some
> > > hack there for our abuse to paper over the regression. I've been in
> > > way too many of those threads, only result is shouting and failed
> > > anger management.
> > 
> > Let's do it right.  If this is a regression from 5.9, it isn't a huge
> > one as that kernel was released last October.  I don't like to see this
> > messing around with USB internals in non-USB-core code please.
> 
> I get
> 
>  > git tag --contains 6eb0233ec2d0
>  ...
>  v5.10-rc1
>  ...

Ah, I thought you said 5.9 was when the problem happened, ok, yes, 5.10
is slow to get out to a lot of distros that do not update frequently :(

thanks,

greg k-h
