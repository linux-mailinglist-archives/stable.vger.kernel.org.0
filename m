Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9623263DA
	for <lists+stable@lfdr.de>; Fri, 26 Feb 2021 15:13:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbhBZOM5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Feb 2021 09:12:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230396AbhBZOMz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Feb 2021 09:12:55 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50FFEC061574
        for <stable@vger.kernel.org>; Fri, 26 Feb 2021 06:12:14 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id h98so8696015wrh.11
        for <stable@vger.kernel.org>; Fri, 26 Feb 2021 06:12:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=OLZmcrWCxeZ6c41xxieRiW431fw/N9XWlSm0QCK8aNA=;
        b=VOcdabzu8g4dgYtvD9enjeHhI2Qoyldr9w1hr7i8FkRX60efmkgnZb0bI1C2KeFlIM
         5RDTPqC6bKoEPNjwfA3wStXJhWUAGlJcnfH5Vstw9df1T5ooWK3uhbRtVT7aIjeUKMGx
         4YRoBWfaKY3fiwyGqlz40xxze4Gkl0mFMjgiE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=OLZmcrWCxeZ6c41xxieRiW431fw/N9XWlSm0QCK8aNA=;
        b=UGRhitm4MPDw9HQ3xzp8qIZnTwEsm3ktWQ724o2JH5CgfA9hfMPiNg785UaODNclay
         WcePWFC+kd1wXu4i8MxaqesVOPfxxjZ91kYozKg1jtI8Dga+qu3AafWQpdlXnEbrQk/q
         TUMaT6y8eIo8AUPKiVd35GizBwtJi5ot59rfqko4KArTU7c4ny7ODqEON/6TF5Iw7Qp3
         vkxhSnO+tQ4ntbRs+FiQtl4jJB4ZR3jMB7hYonJvXob9IK2nt11+37m1MbYGDKFNQC53
         8dQno6tg8yQugYYC2dFnnO0as9bfhGYlfKo10X/q9FeP3FTKlY9dZ759+2gcFLK1qsgF
         hNcw==
X-Gm-Message-State: AOAM532ewn6qfba/a0yhYQRZb3xZTeJRxie8Ow3V0XyE+Dm13SGeyRv0
        5B/DBkJ1MbdFxYGmdvVEhEOSOw==
X-Google-Smtp-Source: ABdhPJzYPmqGaNyqUXkiVVgbrvJb2KvCF2x7gu7Ydgs4PuNrKsP56kZG5lsKCB1mCP6CGGKNadmezQ==
X-Received: by 2002:a5d:5710:: with SMTP id a16mr3315733wrv.275.1614348733008;
        Fri, 26 Feb 2021 06:12:13 -0800 (PST)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id f14sm11335741wmf.7.2021.02.26.06.12.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 06:12:12 -0800 (PST)
Date:   Fri, 26 Feb 2021 15:12:10 +0100
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Thomas Zimmermann <tzimmermann@suse.de>
Cc:     daniel@ffwll.ch, airlied@linux.ie,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        sumit.semwal@linaro.org, christian.koenig@amd.com,
        gregkh@linuxfoundation.org, hdegoede@redhat.com, sean@poorly.run,
        noralf@tronnes.org, stern@rowland.harvard.edu,
        dri-devel@lists.freedesktop.org, Pavel Machek <pavel@ucw.cz>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org
Subject: Re: [PATCH v5] drm: Use USB controller's DMA mask when importing
 dmabufs
Message-ID: <YDkBuu0AhZy+C/Y/@phenom.ffwll.local>
References: <20210226092648.4584-1-tzimmermann@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210226092648.4584-1-tzimmermann@suse.de>
X-Operating-System: Linux phenom 5.7.0-1-amd64 
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
> v4:
> 	* implement workaround with USB helper functions (Greg)
> 	* use struct usb_device->bus->sysdev as DMA device (Takashi)
> v3:
> 	* drop gem_create_object
> 	* use DMA mask of USB controller, if any (Daniel, Christian, Noralf)
> v2:
> 	* move fix to importer side (Christian, Daniel)
> 	* update SHMEM and CMA helpers for new PRIME callbacks
> 
> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> Fixes: 6eb0233ec2d0 ("usb: don't inherity DMA properties for USB devices")
> Tested-by: Pavel Machek <pavel@ucw.cz>
> Acked-by: Christian König <christian.koenig@amd.com>
> Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: <stable@vger.kernel.org> # v5.10+
> ---
>  Documentation/gpu/todo.rst         | 15 ++++++++++
>  drivers/gpu/drm/drm_prime.c        | 45 ++++++++++++++++++++++++++++++
>  drivers/gpu/drm/tiny/gm12u320.c    |  2 +-
>  drivers/gpu/drm/udl/udl_drv.c      |  2 +-
>  drivers/usb/core/usb.c             | 31 ++++++++++++++++++++
>  include/drm/drm_gem_shmem_helper.h | 16 +++++++++++
>  include/drm/drm_prime.h            |  5 ++++
>  include/linux/usb.h                | 24 ++++++++++++++++
>  8 files changed, 138 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/gpu/todo.rst b/Documentation/gpu/todo.rst
> index f872d3d33218..c185e0a2951e 100644
> --- a/Documentation/gpu/todo.rst
> +++ b/Documentation/gpu/todo.rst
> @@ -617,6 +617,21 @@ Contact: Daniel Vetter
>  
>  Level: Intermediate
>  
> +Remove automatic page mapping from dma-buf importing
> +----------------------------------------------------
> +
> +When importing dma-bufs, the dma-buf and PRIME frameworks automatically map
> +imported pages into the importer's DMA area. This is a problem for USB devices,
> +which do not support DMA operations. By default, importing fails for USB
> +devices. USB-based drivers work around this problem by employing
> +drm_gem_prime_import_usb(). To fix the issue, automatic page mappings should
> +be removed from the buffer-sharing code.
> +
> +Contact: Thomas Zimmermann <tzimmermann@suse.de>, Daniel Vetter
> +
> +Level: Advanced
> +
> +
>  Better Testing
>  ==============
>  
> diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
> index 2a54f86856af..59013bb1cd4b 100644
> --- a/drivers/gpu/drm/drm_prime.c
> +++ b/drivers/gpu/drm/drm_prime.c
> @@ -29,6 +29,7 @@
>  #include <linux/export.h>
>  #include <linux/dma-buf.h>
>  #include <linux/rbtree.h>
> +#include <linux/usb.h>
>  
>  #include <drm/drm.h>
>  #include <drm/drm_drv.h>
> @@ -1055,3 +1056,47 @@ void drm_prime_gem_destroy(struct drm_gem_object *obj, struct sg_table *sg)
>  	dma_buf_put(dma_buf);
>  }
>  EXPORT_SYMBOL(drm_prime_gem_destroy);
> +
> +/**
> + * drm_gem_prime_import_usb - helper library implementation of the import callback for USB devices
> + * @dev: drm_device to import into
> + * @dma_buf: dma-buf object to import
> + *
> + * This is an implementation of drm_gem_prime_import() for USB-based devices.
> + * USB devices cannot perform DMA directly. This function selects the USB host
> + * controller as DMA device instead. Drivers can use this as their
> + * &drm_driver.gem_prime_import implementation.
> + *
> + * See also drm_gem_prime_import().
> + *
> + * FIXME: The dma-buf framework expects to map the exported pages into
> + *        the importer's DMA area. USB devices don't support DMA, and
> + *        importing would fail. Foir the time being, this function provides
> + *        a workaround by using the USB controller's DMA area. The real
> + *        solution is to remove page-mapping operations from the dma-buf
> + *        framework.
> + *
> + * Returns: A GEM object on success, or a pointer-encoder errno value otherwise.
> + */
> +#ifdef CONFIG_USB
> +struct drm_gem_object *drm_gem_prime_import_usb(struct drm_device *dev,
> +						struct dma_buf *dma_buf)
> +{
> +	struct device *dmadev;
> +	struct drm_gem_object *obj;
> +
> +	if (!dev_is_usb(dev->dev))
> +		return ERR_PTR(-ENODEV);
> +
> +	dmadev = usb_intf_get_dma_device(to_usb_interface(dev->dev));
> +	if (drm_WARN_ONCE(dev, !dmadev, "buffer sharing not supported"))
> +		return ERR_PTR(-ENODEV);
> +
> +	obj = drm_gem_prime_import_dev(dev, dma_buf, dmadev);
> +
> +	put_device(dmadev);

Just realized there's another can of worms here because dma_buf_attach
does not refcount the struct device. But the dma_buf can easily outlive
the underlying device, at least right now.

We should probably require that devices get rid of all their mappings in
their hotunplug code.

Ofc now that we pick some random other device struct this gets kinda
worse.

Anyway, also just another pre-existing condition that we should worry
about here. It's all still a very bad hack.
-Daniel

> +
> +	return obj;
> +}
> +EXPORT_SYMBOL(drm_gem_prime_import_usb);
> +#endif
> diff --git a/drivers/gpu/drm/tiny/gm12u320.c b/drivers/gpu/drm/tiny/gm12u320.c
> index 0b4f4f2af1ef..99e7bd36a220 100644
> --- a/drivers/gpu/drm/tiny/gm12u320.c
> +++ b/drivers/gpu/drm/tiny/gm12u320.c
> @@ -611,7 +611,7 @@ static const struct drm_driver gm12u320_drm_driver = {
>  	.minor		 = DRIVER_MINOR,
>  
>  	.fops		 = &gm12u320_fops,
> -	DRM_GEM_SHMEM_DRIVER_OPS,
> +	DRM_GEM_SHMEM_DRIVER_OPS_USB,
>  };
>  
>  static const struct drm_mode_config_funcs gm12u320_mode_config_funcs = {
> diff --git a/drivers/gpu/drm/udl/udl_drv.c b/drivers/gpu/drm/udl/udl_drv.c
> index 9269092697d8..2db483b2b199 100644
> --- a/drivers/gpu/drm/udl/udl_drv.c
> +++ b/drivers/gpu/drm/udl/udl_drv.c
> @@ -39,7 +39,7 @@ static const struct drm_driver driver = {
>  
>  	/* GEM hooks */
>  	.fops = &udl_driver_fops,
> -	DRM_GEM_SHMEM_DRIVER_OPS,
> +	DRM_GEM_SHMEM_DRIVER_OPS_USB,
>  
>  	.name = DRIVER_NAME,
>  	.desc = DRIVER_DESC,
> diff --git a/drivers/usb/core/usb.c b/drivers/usb/core/usb.c
> index 8f07b0516100..5e07921e87ba 100644
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
> +
>  /*			USB device locking
>   *
>   * USB devices and interfaces are locked using the semaphore in their
> diff --git a/include/drm/drm_gem_shmem_helper.h b/include/drm/drm_gem_shmem_helper.h
> index 434328d8a0d9..ea8144f33c1f 100644
> --- a/include/drm/drm_gem_shmem_helper.h
> +++ b/include/drm/drm_gem_shmem_helper.h
> @@ -162,4 +162,20 @@ struct sg_table *drm_gem_shmem_get_pages_sgt(struct drm_gem_object *obj);
>  	.gem_prime_mmap		= drm_gem_prime_mmap, \
>  	.dumb_create		= drm_gem_shmem_dumb_create
>  
> +#ifdef CONFIG_USB
> +/**
> + * DRM_GEM_SHMEM_DRIVER_OPS_USB - Default shmem GEM operations for USB devices
> + *
> + * This macro provides a shortcut for setting the shmem GEM operations in
> + * the &drm_driver structure. Drivers for USB-based devices should use this
> + * macro instead of &DRM_GEM_SHMEM_DRIVER_OPS.
> + *
> + * FIXME: Support USB devices with default SHMEM driver ops. See the
> + *        documentation of drm_gem_prime_import_usb() for details.
> + */
> +#define DRM_GEM_SHMEM_DRIVER_OPS_USB \
> +	DRM_GEM_SHMEM_DRIVER_OPS, \
> +	.gem_prime_import = drm_gem_prime_import_usb
> +#endif
> +
>  #endif /* __DRM_GEM_SHMEM_HELPER_H__ */
> diff --git a/include/drm/drm_prime.h b/include/drm/drm_prime.h
> index 54f2c58305d2..b42e07edd9e6 100644
> --- a/include/drm/drm_prime.h
> +++ b/include/drm/drm_prime.h
> @@ -110,4 +110,9 @@ int drm_prime_sg_to_page_array(struct sg_table *sgt, struct page **pages,
>  int drm_prime_sg_to_dma_addr_array(struct sg_table *sgt, dma_addr_t *addrs,
>  				   int max_pages);
>  
> +#ifdef CONFIG_USB
> +struct drm_gem_object *drm_gem_prime_import_usb(struct drm_device *dev,
> +						struct dma_buf *dma_buf);
> +#endif
> +
>  #endif /* __DRM_PRIME_H__ */
> diff --git a/include/linux/usb.h b/include/linux/usb.h
> index 7d72c4e0713c..e6e0acf6a193 100644
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
> +	return usb_get_dma_device(interface_to_usbdev(intf));
> +}
> +
>  #ifdef CONFIG_ACPI
>  extern int usb_acpi_set_power_state(struct usb_device *hdev, int index,
>  	bool enable);
> -- 
> 2.30.1
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
