Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01A443265CE
	for <lists+stable@lfdr.de>; Fri, 26 Feb 2021 17:45:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbhBZQod (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Feb 2021 11:44:33 -0500
Received: from netrider.rowland.org ([192.131.102.5]:46363 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S230170AbhBZQo0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Feb 2021 11:44:26 -0500
Received: (qmail 1394367 invoked by uid 1000); 26 Feb 2021 11:43:42 -0500
Date:   Fri, 26 Feb 2021 11:43:42 -0500
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Thomas Zimmermann <tzimmermann@suse.de>
Cc:     daniel@ffwll.ch, airlied@linux.ie,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        sumit.semwal@linaro.org, christian.koenig@amd.com,
        gregkh@linuxfoundation.org, hdegoede@redhat.com, sean@poorly.run,
        noralf@tronnes.org, dri-devel@lists.freedesktop.org,
        Pavel Machek <pavel@ucw.cz>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org
Subject: Re: [PATCH v5] drm: Use USB controller's DMA mask when importing
 dmabufs
Message-ID: <20210226164342.GC1392547@rowland.harvard.edu>
References: <20210226092648.4584-1-tzimmermann@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210226092648.4584-1-tzimmermann@suse.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 26, 2021 at 10:26:47AM +0100, Thomas Zimmermann wrote:
> USB devices cannot perform DMA and hence have no dma_mask set in their
> device structure. Therefore importing dmabuf into a USB-based driver
> fails, which breaks joining and mirroring of display in X11.
> 
> For USB devices, pick the associated USB controller as attachment device.
> This allows the DRM import helpers to perform the DMA setup. If the DMA
> controller does not support DMA transfers, we're out of luck and cannot
> import. Our current USB-based DRM drivers don't use DMA, so the actual
> DMA device is not important.
> 
> Drivers should use DRM_GEM_SHMEM_DROVER_OPS_USB to initialize their
> instance of struct drm_driver.
> 
> Tested by joining/mirroring displays of udl and radeon un der Gnome/X11.
> 
> v5:
> 	* provide a helper for USB interfaces (Alan)
> 	* add FIXME item to documentation and TODO list (Daniel)

> --- a/drivers/usb/core/usb.c
> +++ b/drivers/usb/core/usb.c
> @@ -748,6 +748,37 @@ void usb_put_intf(struct usb_interface *intf)
>  }
>  EXPORT_SYMBOL_GPL(usb_put_intf);
>  
> +/**
> + * usb_get_dma_device - acquire a reference on the usb device's DMA endpoint
> + * @udev: usb device
> + *
> + * While a USB device cannot perform DMA operations by itself, many USB
> + * controllers can. A call to usb_get_dma_device() returns the DMA endpoint
> + * for the given USB device, if any. The returned device structure should be
> + * released with put_device().
> + *
> + * See also usb_intf_get_dma_device().
> + *
> + * Returns: A reference to the usb device's DMA endpoint; or NULL if none
> + *          exists.
> + */
> +struct device *usb_get_dma_device(struct usb_device *udev)
> +{
> +	struct device *dmadev;
> +
> +	if (!udev->bus)
> +		return NULL;
> +
> +	dmadev = get_device(udev->bus->sysdev);
> +	if (!dmadev || !dmadev->dma_mask) {
> +		put_device(dmadev);
> +		return NULL;
> +	}
> +
> +	return dmadev;
> +}
> +EXPORT_SYMBOL_GPL(usb_get_dma_device);

There's no point making this a separate function, since it has no
callers of its own.  Just make usb_intf_get_dma_device the only new
function.

> --- a/include/linux/usb.h
> +++ b/include/linux/usb.h
> @@ -711,6 +711,7 @@ struct usb_device {
>  	unsigned use_generic_driver:1;
>  };
>  #define	to_usb_device(d) container_of(d, struct usb_device, dev)
> +#define dev_is_usb(d)	((d)->bus == &usb_bus_type)
>  
>  static inline struct usb_device *interface_to_usbdev(struct usb_interface *intf)
>  {
> @@ -746,6 +747,29 @@ extern int usb_lock_device_for_reset(struct usb_device *udev,
>  extern int usb_reset_device(struct usb_device *dev);
>  extern void usb_queue_reset_device(struct usb_interface *dev);
>  
> +extern struct device *usb_get_dma_device(struct usb_device *udev);
> +
> +/**
> + * usb_intf_get_dma_device - acquire a reference on the usb interface's DMA endpoint
> + * @intf: the usb interface
> + *
> + * While a USB device cannot perform DMA operations by itself, many USB
> + * controllers can. A call to usb_intf_get_dma_device() returns the DMA endpoint
> + * for the given USB interface, if any. The returned device structure should be
> + * released with put_device().
> + *
> + * See also usb_get_dma_device().
> + *
> + * Returns: A reference to the usb interface's DMA endpoint; or NULL if none
> + *          exists.
> + */
> +static inline struct device *usb_intf_get_dma_device(struct usb_interface *intf)
> +{
> +	if (!intf)
> +		return NULL;

Why would intf ever be NULL?

> +	return usb_get_dma_device(interface_to_usbdev(intf));
> +}

Alan Stern
