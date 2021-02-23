Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15786322DDA
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 16:47:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233369AbhBWPqV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 10:46:21 -0500
Received: from netrider.rowland.org ([192.131.102.5]:33917 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S233206AbhBWPpx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Feb 2021 10:45:53 -0500
Received: (qmail 1263331 invoked by uid 1000); 23 Feb 2021 10:45:07 -0500
Date:   Tue, 23 Feb 2021 10:45:07 -0500
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Thomas Zimmermann <tzimmermann@suse.de>, daniel@ffwll.ch,
        airlied@linux.ie, maarten.lankhorst@linux.intel.com,
        mripard@kernel.org, sumit.semwal@linaro.org,
        christian.koenig@amd.com, hdegoede@redhat.com, sean@poorly.run,
        noralf@tronnes.org, dri-devel@lists.freedesktop.org,
        Christoph Hellwig <hch@lst.de>,
        Johan Hovold <johan@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Oliver Neukum <oneukum@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
Subject: Re: [PATCH v3] drm: Use USB controller's DMA mask when importing
 dmabufs
Message-ID: <20210223154507.GA1261797@rowland.harvard.edu>
References: <20210223105842.27011-1-tzimmermann@suse.de>
 <YDTk3L3gNxDE3YrC@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YDTk3L3gNxDE3YrC@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 23, 2021 at 12:19:56PM +0100, Greg KH wrote:
> On Tue, Feb 23, 2021 at 11:58:42AM +0100, Thomas Zimmermann wrote:

> > --- a/drivers/gpu/drm/drm_prime.c
> > +++ b/drivers/gpu/drm/drm_prime.c
> > @@ -29,6 +29,7 @@
> >  #include <linux/export.h>
> >  #include <linux/dma-buf.h>
> >  #include <linux/rbtree.h>
> > +#include <linux/usb.h>
> > 
> >  #include <drm/drm.h>
> >  #include <drm/drm_drv.h>
> > @@ -1055,3 +1056,38 @@ void drm_prime_gem_destroy(struct drm_gem_object *obj, struct sg_table *sg)
> >  	dma_buf_put(dma_buf);
> >  }
> >  EXPORT_SYMBOL(drm_prime_gem_destroy);
> > +
> > +/**
> > + * drm_gem_prime_import_usb - helper library implementation of the import callback for USB devices
> > + * @dev: drm_device to import into
> > + * @dma_buf: dma-buf object to import
> > + *
> > + * This is an implementation of drm_gem_prime_import() for USB-based devices.
> > + * USB devices cannot perform DMA directly. This function selects the USB host
> > + * controller as DMA device instead. Drivers can use this as their
> > + * &drm_driver.gem_prime_import implementation.
> > + *
> > + * See also drm_gem_prime_import().
> > + */
> > +#ifdef CONFIG_USB
> > +struct drm_gem_object *drm_gem_prime_import_usb(struct drm_device *dev,
> > +						struct dma_buf *dma_buf)
> > +{
> > +	struct usb_device *udev;
> > +	struct device *usbhost;
> > +
> > +	if (dev->dev->bus != &usb_bus_type)
> > +		return ERR_PTR(-ENODEV);
> > +
> > +	udev = interface_to_usbdev(to_usb_interface(dev->dev));
> > +	if (!udev->bus)
> > +		return ERR_PTR(-ENODEV);
> > +
> > +	usbhost = udev->bus->controller;
> > +	if (!usbhost || !usbhost->dma_mask)
> > +		return ERR_PTR(-ENODEV);

Thomas, I doubt that you have to go through all of this.  The 
usb-storage driver, for instance, just uses the equivalent of 
dev->dev->dma_mask.  Even though USB devices don't do DMA themselves, 
the DMA mask value is inherited from the parent host controller's device 
struct.

Have you tried doing this?

> If individual USB drivers need access to this type of thing, shouldn't
> that be done in the USB core itself?
> 
> {hint, yes}
> 
> There shouldn't be anything "special" about a DRM driver that needs this
> vs. any other driver that might want to know about DMA things related to
> a specific USB device.  Why isn't this an issue with the existing
> storage or v4l USB devices?

If Thomas finds that the approach I outlined above works, then the rest 
of this email thread becomes moot.  :-)

Alan Stern
