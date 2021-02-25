Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EBB3324D1C
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 10:43:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234022AbhBYJmg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 04:42:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232310AbhBYJmN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Feb 2021 04:42:13 -0500
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8D50C061788
        for <stable@vger.kernel.org>; Thu, 25 Feb 2021 01:36:55 -0800 (PST)
Received: by mail-oi1-x22d.google.com with SMTP id i21so3195155oii.2
        for <stable@vger.kernel.org>; Thu, 25 Feb 2021 01:36:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W7MC3/QnDlOBciI7HO8xeix5Zlcj2JKBczxxvejpGvM=;
        b=lWVfsr9CjnfmWsbtgiQDe3qnCpNonlE1+yy6onxrYumeosbwmI5YZ1zc2PCcDmQys9
         YTNqDJBBicYF+nv26NUpn+0XLVwgm4vchwi60h3lH1i8USM7cW49N6d/f/TDPnZDQci5
         tIhKlFseJT9Isl7DaI/wfR2ucMNRXIwsvmQuM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W7MC3/QnDlOBciI7HO8xeix5Zlcj2JKBczxxvejpGvM=;
        b=IBVUTndHWxX3RTcSYiTsjAfBy6E+/9YhlfxF3CTnzNR92F6YIJu5SNQvWgKQ7pipsw
         ISnJzoo4vp4IK6J+C5f1u1OylFrTV00i1+9u3MKCUQSET3BPHR5q+hyUn/3kwTNyskWw
         EgtRmMxGc6Ha2dsckKtLL6bOhEtI3zZyQr2nIVWhgXg39s6yA08p8mCO9fdYzmzC40gN
         4LtH4bLNpDplov9MgYO/EQ3r8l9wJnbGGE2uGE/RDxTrUJVuKINsv8jdH2sRl9mbO5JC
         FUJacU/iKCl5iiN6uJ0Q07PkVPqSOtQ7KVqwdfaSIXxwS89hdykSIlB7cBxM0y3tYkNh
         q2KQ==
X-Gm-Message-State: AOAM532RsKlREEfWqxj/5h4r462AYUBVMeDuHIO7DpHftK84FqPgTdpD
        ko/oxR47KsfGaPLMeNz3s1+wnxc5ns5d0fnox5mXtw==
X-Google-Smtp-Source: ABdhPJxgMzBnZ6ZO00bpxTer9CP2+NvwZV0qXHayexi0FhKDb9yYPkpK6gRp93FaxCrJVUx6Zo3ApI85aRMgXGS1LZI=
X-Received: by 2002:a05:6808:aa6:: with SMTP id r6mr1324550oij.128.1614245815316;
 Thu, 25 Feb 2021 01:36:55 -0800 (PST)
MIME-Version: 1.0
References: <20210224092304.29932-1-tzimmermann@suse.de>
In-Reply-To: <20210224092304.29932-1-tzimmermann@suse.de>
From:   Daniel Vetter <daniel@ffwll.ch>
Date:   Thu, 25 Feb 2021 10:36:44 +0100
Message-ID: <CAKMK7uGi1j_7xt7XeSaUu6noq+UOsS5nNHBDQBp46uwWHOofnA@mail.gmail.com>
Subject: Re: [PATCH v4] drm: Use USB controller's DMA mask when importing dmabufs
To:     Thomas Zimmermann <tzimmermann@suse.de>
Cc:     Dave Airlie <airlied@linux.ie>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Sean Paul <sean@poorly.run>,
        =?UTF-8?Q?Noralf_Tr=C3=B8nnes?= <noralf@tronnes.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Christoph Hellwig <hch@lst.de>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 24, 2021 at 10:23 AM Thomas Zimmermann <tzimmermann@suse.de> wrote:
>
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
> v4:
>         * implement workaround with USB helper functions (Greg)
>         * use struct usb_device->bus->sysdev as DMA device (Takashi)
> v3:
>         * drop gem_create_object
>         * use DMA mask of USB controller, if any (Daniel, Christian, Noralf)
> v2:
>         * move fix to importer side (Christian, Daniel)
>         * update SHMEM and CMA helpers for new PRIME callbacks
>
> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> Fixes: 6eb0233ec2d0 ("usb: don't inherity DMA properties for USB devices")
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: <stable@vger.kernel.org> # v5.10+
> ---
>  drivers/gpu/drm/drm_prime.c        | 38 ++++++++++++++++++++++++++++++
>  drivers/gpu/drm/tiny/gm12u320.c    |  2 +-
>  drivers/gpu/drm/udl/udl_drv.c      |  2 +-
>  drivers/usb/core/usb.c             | 29 +++++++++++++++++++++++
>  include/drm/drm_gem_shmem_helper.h | 13 ++++++++++
>  include/drm/drm_prime.h            |  5 ++++
>  include/linux/usb.h                |  3 +++
>  7 files changed, 90 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
> index 2a54f86856af..15c82088ab4c 100644
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
> @@ -1055,3 +1056,40 @@ void drm_prime_gem_destroy(struct drm_gem_object *obj, struct sg_table *sg)
>         dma_buf_put(dma_buf);
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

We're still just papering over drm_prime.c here, and this kerneldoc
here is sounding way too much like this is a sensible thing to do and
doesn't mention the fundamental problem.

I'd do something like the below as the entire kerneldoc:

<doc>
FIXME:

drm_gem_prime_fd_to_handle() and drm_gem_prime_handle_to_fd() require
that importers call dma_buf_attach() even if they never do actual
device DMA, but only CPU access through dma_buf_vmap(). Fixing this is
a bit more involved, since the import/export cache is also tied to
&drm_gem_object.import_attach.

Meanwhile this function here can be used to paper over this problem
for USB devices by fishing out the USB host controller device, as long
as that supports DMA. Otherwise importing can still needlessly fail.
</doc>
Since we do not actually have usb drm drivers that do dma I don't want
to give people wrong impressions about what's going on here. I still
think the better approach would be to copypaste this hack into each of
the tree drivers, with the above as a comment, since sharing bad code
isn't a good idea imo - all that does is hide the problem and make the
next person feel like it's all peachy. But also ok if there's a
giantic warning label on the shared code.

With that: Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>


> + *
> + * See also drm_gem_prime_import().
> + */
> +#ifdef CONFIG_USB
> +struct drm_gem_object *drm_gem_prime_import_usb(struct drm_device *dev,
> +                                               struct dma_buf *dma_buf)
> +{
> +       struct usb_device *udev;
> +       struct device *dmadev;
> +       struct drm_gem_object *obj;
> +
> +       if (!dev_is_usb(dev->dev))
> +               return ERR_PTR(-ENODEV);
> +       udev = interface_to_usbdev(to_usb_interface(dev->dev));
> +
> +       dmadev = usb_get_dma_device(udev);
> +       if (drm_WARN_ONCE(dev, !dmadev, "buffer sharing not supported"))
> +               return ERR_PTR(-ENODEV);
> +
> +       obj = drm_gem_prime_import_dev(dev, dma_buf, dmadev);
> +
> +       put_device(dmadev);
> +
> +       return obj;
> +}
> +EXPORT_SYMBOL(drm_gem_prime_import_usb);
> +#endif
> diff --git a/drivers/gpu/drm/tiny/gm12u320.c b/drivers/gpu/drm/tiny/gm12u320.c
> index 0b4f4f2af1ef..99e7bd36a220 100644
> --- a/drivers/gpu/drm/tiny/gm12u320.c
> +++ b/drivers/gpu/drm/tiny/gm12u320.c
> @@ -611,7 +611,7 @@ static const struct drm_driver gm12u320_drm_driver = {
>         .minor           = DRIVER_MINOR,
>
>         .fops            = &gm12u320_fops,
> -       DRM_GEM_SHMEM_DRIVER_OPS,
> +       DRM_GEM_SHMEM_DRIVER_OPS_USB,
>  };
>
>  static const struct drm_mode_config_funcs gm12u320_mode_config_funcs = {
> diff --git a/drivers/gpu/drm/udl/udl_drv.c b/drivers/gpu/drm/udl/udl_drv.c
> index 9269092697d8..2db483b2b199 100644
> --- a/drivers/gpu/drm/udl/udl_drv.c
> +++ b/drivers/gpu/drm/udl/udl_drv.c
> @@ -39,7 +39,7 @@ static const struct drm_driver driver = {
>
>         /* GEM hooks */
>         .fops = &udl_driver_fops,
> -       DRM_GEM_SHMEM_DRIVER_OPS,
> +       DRM_GEM_SHMEM_DRIVER_OPS_USB,
>
>         .name = DRIVER_NAME,
>         .desc = DRIVER_DESC,
> diff --git a/drivers/usb/core/usb.c b/drivers/usb/core/usb.c
> index 8f07b0516100..253bf71780fd 100644
> --- a/drivers/usb/core/usb.c
> +++ b/drivers/usb/core/usb.c
> @@ -748,6 +748,35 @@ void usb_put_intf(struct usb_interface *intf)
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
> + * Returns: A reference to the usb device's DMA endpoint; or NULL if none
> + *          exists.
> + */
> +struct device *usb_get_dma_device(struct usb_device *udev)
> +{
> +       struct device *dmadev;
> +
> +       if (!udev->bus)
> +               return NULL;
> +
> +       dmadev = get_device(udev->bus->sysdev);
> +       if (!dmadev || !dmadev->dma_mask) {
> +               put_device(dmadev);
> +               return NULL;
> +       }
> +
> +       return dmadev;
> +}
> +EXPORT_SYMBOL_GPL(usb_get_dma_device);
> +
>  /*                     USB device locking
>   *
>   * USB devices and interfaces are locked using the semaphore in their
> diff --git a/include/drm/drm_gem_shmem_helper.h b/include/drm/drm_gem_shmem_helper.h
> index 434328d8a0d9..09d12f632cad 100644
> --- a/include/drm/drm_gem_shmem_helper.h
> +++ b/include/drm/drm_gem_shmem_helper.h
> @@ -162,4 +162,17 @@ struct sg_table *drm_gem_shmem_get_pages_sgt(struct drm_gem_object *obj);
>         .gem_prime_mmap         = drm_gem_prime_mmap, \
>         .dumb_create            = drm_gem_shmem_dumb_create
>
> +#ifdef CONFIG_USB
> +/**
> + * DRM_GEM_SHMEM_DRIVER_OPS_USB - Default shmem GEM operations for USB devices
> + *
> + * This macro provides a shortcut for setting the shmem GEM operations in
> + * the &drm_driver structure. Drivers for USB-based devices should use this
> + * macro instead of &DRM_GEM_SHMEM_DRIVER_OPS.
> + */
> +#define DRM_GEM_SHMEM_DRIVER_OPS_USB \
> +       DRM_GEM_SHMEM_DRIVER_OPS, \
> +       .gem_prime_import = drm_gem_prime_import_usb
> +#endif
> +
>  #endif /* __DRM_GEM_SHMEM_HELPER_H__ */
> diff --git a/include/drm/drm_prime.h b/include/drm/drm_prime.h
> index 54f2c58305d2..b42e07edd9e6 100644
> --- a/include/drm/drm_prime.h
> +++ b/include/drm/drm_prime.h
> @@ -110,4 +110,9 @@ int drm_prime_sg_to_page_array(struct sg_table *sgt, struct page **pages,
>  int drm_prime_sg_to_dma_addr_array(struct sg_table *sgt, dma_addr_t *addrs,
>                                    int max_pages);
>
> +#ifdef CONFIG_USB
> +struct drm_gem_object *drm_gem_prime_import_usb(struct drm_device *dev,
> +                                               struct dma_buf *dma_buf);
> +#endif
> +
>  #endif /* __DRM_PRIME_H__ */
> diff --git a/include/linux/usb.h b/include/linux/usb.h
> index 7d72c4e0713c..a9bd698c8839 100644
> --- a/include/linux/usb.h
> +++ b/include/linux/usb.h
> @@ -711,6 +711,7 @@ struct usb_device {
>         unsigned use_generic_driver:1;
>  };
>  #define        to_usb_device(d) container_of(d, struct usb_device, dev)
> +#define dev_is_usb(d)  ((d)->bus == &usb_bus_type)
>
>  static inline struct usb_device *interface_to_usbdev(struct usb_interface *intf)
>  {
> @@ -746,6 +747,8 @@ extern int usb_lock_device_for_reset(struct usb_device *udev,
>  extern int usb_reset_device(struct usb_device *dev);
>  extern void usb_queue_reset_device(struct usb_interface *dev);
>
> +extern struct device *usb_get_dma_device(struct usb_device *udev);
> +
>  #ifdef CONFIG_ACPI
>  extern int usb_acpi_set_power_state(struct usb_device *hdev, int index,
>         bool enable);
> --
> 2.30.1
>


-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
