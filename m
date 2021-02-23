Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D01D83229A4
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 12:47:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232318AbhBWLrK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 06:47:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232250AbhBWLrG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Feb 2021 06:47:06 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0532CC061574
        for <stable@vger.kernel.org>; Tue, 23 Feb 2021 03:46:25 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id i7so1483117wmb.0
        for <stable@vger.kernel.org>; Tue, 23 Feb 2021 03:46:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Uu2O+jvmoR/3goPcAqoOLwCaPuOjBClG0PSKwD6W/PE=;
        b=AbRVTcvuYodR0Xiw6WIaZ2aVWaiOdjtuPb6ro6L32CyRfhM9MohEtmV5MthZJLFVLo
         6QgtuH4VpF6FjyCQ8UOhl0YTCOjgLEPcQjsvTKBwi5GRnPxWwBpIkFXkXjIcQkUw70Ek
         LpCFhFcloDIFtQnXjlqBlJksB2yucyZmn4sSo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Uu2O+jvmoR/3goPcAqoOLwCaPuOjBClG0PSKwD6W/PE=;
        b=Kgj1FoTpVd/uK6bD4aF3GHFKg/gLhiTdBmRXqdrNvaIyt5W82+cgpUG1NNn8fXC4qx
         q102zIrl6Q0WSKu3BXkq9pJZNhr80t5kZYyxbHj+/0D2L624yIsDHRJgEa+Cgfs4pbWO
         TQoqfj9qR+Bo5tUFxuxhN4SKg6Ediz4i8lf8g29Qdl3vTv6JFi/pUCYYg/aH4vZQ6ZJM
         sIYP6+h4kwKk8TYp+aRs+Ta52B8ioyEZMJUFkgnfGKGR+3xTQbfVf+ceFdnpQjFpB5Ar
         hNw4sZxinkJoORnAzCE8vQUyP2Fr/X4494jb1DV0CsG07BsW9gnwjy1iWIDTeRi8iy8p
         En5w==
X-Gm-Message-State: AOAM530jblim0LlFHveanLDFhOUMLJDtKmJW5gD/wm4rrtmiY1Zr2Ldn
        qZrJxRJ0R0apYan1giBypt8Z8g==
X-Google-Smtp-Source: ABdhPJzqT7KWCtTZ2r4nWoDsuoLvlayynWzCrC+hsyuff6mGAP5b3h1JPrP1jRHWo0lMNFXFxAUmsQ==
X-Received: by 2002:a7b:c1c4:: with SMTP id a4mr14336306wmj.123.1614080783609;
        Tue, 23 Feb 2021 03:46:23 -0800 (PST)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id l15sm2431797wmh.21.2021.02.23.03.46.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 03:46:23 -0800 (PST)
Date:   Tue, 23 Feb 2021 12:46:20 +0100
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Thomas Zimmermann <tzimmermann@suse.de>, daniel@ffwll.ch,
        airlied@linux.ie, maarten.lankhorst@linux.intel.com,
        mripard@kernel.org, sumit.semwal@linaro.org,
        christian.koenig@amd.com, hdegoede@redhat.com, sean@poorly.run,
        noralf@tronnes.org, dri-devel@lists.freedesktop.org,
        Christoph Hellwig <hch@lst.de>,
        Johan Hovold <johan@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Oliver Neukum <oneukum@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
Subject: Re: [PATCH v3] drm: Use USB controller's DMA mask when importing
 dmabufs
Message-ID: <YDTrDAlcFH/7/7DD@phenom.ffwll.local>
References: <20210223105842.27011-1-tzimmermann@suse.de>
 <YDTk3L3gNxDE3YrC@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YDTk3L3gNxDE3YrC@kroah.com>
X-Operating-System: Linux phenom 5.7.0-1-amd64 
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 23, 2021 at 12:19:56PM +0100, Greg KH wrote:
> On Tue, Feb 23, 2021 at 11:58:42AM +0100, Thomas Zimmermann wrote:
> > USB devices cannot perform DMA and hence have no dma_mask set in their
> > device structure. Importing dmabuf into a USB-based driver fails, which
> > break joining and mirroring of display in X11.
> > 
> > For USB devices, pick the associated USB controller as attachment device,
> > so that it can perform DMA. If the DMa controller does not support DMA
> > transfers, we're aout of luck and cannot import.
> > 
> > Drivers should use DRM_GEM_SHMEM_DROVER_OPS_USB to initialize their
> > instance of struct drm_driver.
> > 
> > Tested by joining/mirroring displays of udl and radeon un der Gnome/X11.
> > 
> > v3:
> > 	* drop gem_create_object
> > 	* use DMA mask of USB controller, if any (Daniel, Christian, Noralf)
> > v2:
> > 	* move fix to importer side (Christian, Daniel)
> > 	* update SHMEM and CMA helpers for new PRIME callbacks
> > 
> > Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> > Fixes: 6eb0233ec2d0 ("usb: don't inherity DMA properties for USB devices")
> > Cc: Christoph Hellwig <hch@lst.de>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: Johan Hovold <johan@kernel.org>
> > Cc: Alan Stern <stern@rowland.harvard.edu>
> > Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> > Cc: Mathias Nyman <mathias.nyman@linux.intel.com>
> > Cc: Oliver Neukum <oneukum@suse.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: <stable@vger.kernel.org> # v5.10+
> > ---
> >  drivers/gpu/drm/drm_prime.c        | 36 ++++++++++++++++++++++++++++++
> >  drivers/gpu/drm/tiny/gm12u320.c    |  2 +-
> >  drivers/gpu/drm/udl/udl_drv.c      |  2 +-
> >  include/drm/drm_gem_shmem_helper.h | 13 +++++++++++
> >  include/drm/drm_prime.h            |  5 +++++
> >  5 files changed, 56 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
> > index 2a54f86856af..9015850f2160 100644
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
> 
> If individual USB drivers need access to this type of thing, shouldn't
> that be done in the USB core itself?
> 
> {hint, yes}
> 
> There shouldn't be anything "special" about a DRM driver that needs this
> vs. any other driver that might want to know about DMA things related to
> a specific USB device.  Why isn't this an issue with the existing
> storage or v4l USB devices?

The trouble is that this is a regression fix for 5.9, because the dma-api
got more opinionated about what it allows. The proper fix is a lot more
invasive (we essentially need to rework the drm_prime.c to allow dma-buf
importing for just cpu access), and that's a ton more invasive than just a
small patch with can stuff into stable kernels.

This here is ugly, but it should at least get rid of black screens again.

I think solid FIXME comment explaining the situation would be good.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
