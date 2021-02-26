Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1561325E8B
	for <lists+stable@lfdr.de>; Fri, 26 Feb 2021 09:01:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbhBZIAl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Feb 2021 03:00:41 -0500
Received: from mx2.suse.de ([195.135.220.15]:52370 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229526AbhBZIAd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Feb 2021 03:00:33 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id DD4F3AAAE;
        Fri, 26 Feb 2021 07:59:51 +0000 (UTC)
Subject: Re: [PATCH v4] drm: Use USB controller's DMA mask when importing
 dmabufs
To:     daniel@ffwll.ch, airlied@linux.ie,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        sumit.semwal@linaro.org, christian.koenig@amd.com,
        gregkh@linuxfoundation.org, hdegoede@redhat.com, sean@poorly.run,
        noralf@tronnes.org, stern@rowland.harvard.edu
Cc:     stable@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Christoph Hellwig <hch@lst.de>
References: <20210224092304.29932-1-tzimmermann@suse.de>
From:   Thomas Zimmermann <tzimmermann@suse.de>
Message-ID: <ab79a3a7-2659-2dd2-889d-e2356a1b8176@suse.de>
Date:   Fri, 26 Feb 2021 08:59:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210224092304.29932-1-tzimmermann@suse.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="6e9K8dMXU0lJ77IHXdrcRYc7Zhg3KhCLW"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6e9K8dMXU0lJ77IHXdrcRYc7Zhg3KhCLW
Content-Type: multipart/mixed; boundary="Dq8wcrgO1lNZQieHaRiYicMoWZ1kNSVEY";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: daniel@ffwll.ch, airlied@linux.ie, maarten.lankhorst@linux.intel.com,
 mripard@kernel.org, sumit.semwal@linaro.org, christian.koenig@amd.com,
 gregkh@linuxfoundation.org, hdegoede@redhat.com, sean@poorly.run,
 noralf@tronnes.org, stern@rowland.harvard.edu
Cc: stable@vger.kernel.org, dri-devel@lists.freedesktop.org,
 Christoph Hellwig <hch@lst.de>
Message-ID: <ab79a3a7-2659-2dd2-889d-e2356a1b8176@suse.de>
Subject: Re: [PATCH v4] drm: Use USB controller's DMA mask when importing
 dmabufs
References: <20210224092304.29932-1-tzimmermann@suse.de>
In-Reply-To: <20210224092304.29932-1-tzimmermann@suse.de>

--Dq8wcrgO1lNZQieHaRiYicMoWZ1kNSVEY
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Greg, do you have comments on this patch?

Am 24.02.21 um 10:23 schrieb Thomas Zimmermann:
> USB devices cannot perform DMA and hence have no dma_mask set in their
> device structure. Therefore importing dmabuf into a USB-based driver
> fails, which breaks joining and mirroring of display in X11.
>=20
> For USB devices, pick the associated USB controller as attachment devic=
e.
> This allows the DRM import helpers to perform the DMA setup. If the DMA=

> controller does not support DMA transfers, we're out of luck and cannot=

> import. Our current USB-based DRM drivers don't use DMA, so the actual
> DMA device is not important.
>=20
> Drivers should use DRM_GEM_SHMEM_DROVER_OPS_USB to initialize their
> instance of struct drm_driver.
>=20
> Tested by joining/mirroring displays of udl and radeon un der Gnome/X11=
=2E
>=20
> v4:
> 	* implement workaround with USB helper functions (Greg)
> 	* use struct usb_device->bus->sysdev as DMA device (Takashi)
> v3:
> 	* drop gem_create_object
> 	* use DMA mask of USB controller, if any (Daniel, Christian, Noralf)
> v2:
> 	* move fix to importer side (Christian, Daniel)
> 	* update SHMEM and CMA helpers for new PRIME callbacks
>=20
> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> Fixes: 6eb0233ec2d0 ("usb: don't inherity DMA properties for USB device=
s")
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: <stable@vger.kernel.org> # v5.10+
> ---
>   drivers/gpu/drm/drm_prime.c        | 38 +++++++++++++++++++++++++++++=
+
>   drivers/gpu/drm/tiny/gm12u320.c    |  2 +-
>   drivers/gpu/drm/udl/udl_drv.c      |  2 +-
>   drivers/usb/core/usb.c             | 29 +++++++++++++++++++++++
>   include/drm/drm_gem_shmem_helper.h | 13 ++++++++++
>   include/drm/drm_prime.h            |  5 ++++
>   include/linux/usb.h                |  3 +++
>   7 files changed, 90 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
> index 2a54f86856af..15c82088ab4c 100644
> --- a/drivers/gpu/drm/drm_prime.c
> +++ b/drivers/gpu/drm/drm_prime.c
> @@ -29,6 +29,7 @@
>   #include <linux/export.h>
>   #include <linux/dma-buf.h>
>   #include <linux/rbtree.h>
> +#include <linux/usb.h>
>  =20
>   #include <drm/drm.h>
>   #include <drm/drm_drv.h>
> @@ -1055,3 +1056,40 @@ void drm_prime_gem_destroy(struct drm_gem_object=
 *obj, struct sg_table *sg)
>   	dma_buf_put(dma_buf);
>   }
>   EXPORT_SYMBOL(drm_prime_gem_destroy);
> +
> +/**
> + * drm_gem_prime_import_usb - helper library implementation of the imp=
ort callback for USB devices
> + * @dev: drm_device to import into
> + * @dma_buf: dma-buf object to import
> + *
> + * This is an implementation of drm_gem_prime_import() for USB-based d=
evices.
> + * USB devices cannot perform DMA directly. This function selects the =
USB host
> + * controller as DMA device instead. Drivers can use this as their
> + * &drm_driver.gem_prime_import implementation.
> + *
> + * See also drm_gem_prime_import().
> + */
> +#ifdef CONFIG_USB
> +struct drm_gem_object *drm_gem_prime_import_usb(struct drm_device *dev=
,
> +						struct dma_buf *dma_buf)
> +{
> +	struct usb_device *udev;
> +	struct device *dmadev;
> +	struct drm_gem_object *obj;
> +
> +	if (!dev_is_usb(dev->dev))
> +		return ERR_PTR(-ENODEV);
> +	udev =3D interface_to_usbdev(to_usb_interface(dev->dev));
> +
> +	dmadev =3D usb_get_dma_device(udev);
> +	if (drm_WARN_ONCE(dev, !dmadev, "buffer sharing not supported"))
> +		return ERR_PTR(-ENODEV);
> +
> +	obj =3D drm_gem_prime_import_dev(dev, dma_buf, dmadev);
> +
> +	put_device(dmadev);
> +
> +	return obj;
> +}
> +EXPORT_SYMBOL(drm_gem_prime_import_usb);
> +#endif
> diff --git a/drivers/gpu/drm/tiny/gm12u320.c b/drivers/gpu/drm/tiny/gm1=
2u320.c
> index 0b4f4f2af1ef..99e7bd36a220 100644
> --- a/drivers/gpu/drm/tiny/gm12u320.c
> +++ b/drivers/gpu/drm/tiny/gm12u320.c
> @@ -611,7 +611,7 @@ static const struct drm_driver gm12u320_drm_driver =
=3D {
>   	.minor		 =3D DRIVER_MINOR,
>  =20
>   	.fops		 =3D &gm12u320_fops,
> -	DRM_GEM_SHMEM_DRIVER_OPS,
> +	DRM_GEM_SHMEM_DRIVER_OPS_USB,
>   };
>  =20
>   static const struct drm_mode_config_funcs gm12u320_mode_config_funcs =
=3D {
> diff --git a/drivers/gpu/drm/udl/udl_drv.c b/drivers/gpu/drm/udl/udl_dr=
v.c
> index 9269092697d8..2db483b2b199 100644
> --- a/drivers/gpu/drm/udl/udl_drv.c
> +++ b/drivers/gpu/drm/udl/udl_drv.c
> @@ -39,7 +39,7 @@ static const struct drm_driver driver =3D {
>  =20
>   	/* GEM hooks */
>   	.fops =3D &udl_driver_fops,
> -	DRM_GEM_SHMEM_DRIVER_OPS,
> +	DRM_GEM_SHMEM_DRIVER_OPS_USB,
>  =20
>   	.name =3D DRIVER_NAME,
>   	.desc =3D DRIVER_DESC,
> diff --git a/drivers/usb/core/usb.c b/drivers/usb/core/usb.c
> index 8f07b0516100..253bf71780fd 100644
> --- a/drivers/usb/core/usb.c
> +++ b/drivers/usb/core/usb.c
> @@ -748,6 +748,35 @@ void usb_put_intf(struct usb_interface *intf)
>   }
>   EXPORT_SYMBOL_GPL(usb_put_intf);
>  =20
> +/**
> + * usb_get_dma_device - acquire a reference on the usb device's DMA en=
dpoint
> + * @udev: usb device
> + *
> + * While a USB device cannot perform DMA operations by itself, many US=
B
> + * controllers can. A call to usb_get_dma_device() returns the DMA end=
point
> + * for the given USB device, if any. The returned device structure sho=
uld be
> + * released with put_device().
> + *
> + * Returns: A reference to the usb device's DMA endpoint; or NULL if n=
one
> + *          exists.
> + */
> +struct device *usb_get_dma_device(struct usb_device *udev)
> +{
> +	struct device *dmadev;
> +
> +	if (!udev->bus)
> +		return NULL;
> +
> +	dmadev =3D get_device(udev->bus->sysdev);
> +	if (!dmadev || !dmadev->dma_mask) {
> +		put_device(dmadev);
> +		return NULL;
> +	}
> +
> +	return dmadev;
> +}
> +EXPORT_SYMBOL_GPL(usb_get_dma_device);
> +
>   /*			USB device locking
>    *
>    * USB devices and interfaces are locked using the semaphore in their=

> diff --git a/include/drm/drm_gem_shmem_helper.h b/include/drm/drm_gem_s=
hmem_helper.h
> index 434328d8a0d9..09d12f632cad 100644
> --- a/include/drm/drm_gem_shmem_helper.h
> +++ b/include/drm/drm_gem_shmem_helper.h
> @@ -162,4 +162,17 @@ struct sg_table *drm_gem_shmem_get_pages_sgt(struc=
t drm_gem_object *obj);
>   	.gem_prime_mmap		=3D drm_gem_prime_mmap, \
>   	.dumb_create		=3D drm_gem_shmem_dumb_create
>  =20
> +#ifdef CONFIG_USB
> +/**
> + * DRM_GEM_SHMEM_DRIVER_OPS_USB - Default shmem GEM operations for USB=
 devices
> + *
> + * This macro provides a shortcut for setting the shmem GEM operations=
 in
> + * the &drm_driver structure. Drivers for USB-based devices should use=
 this
> + * macro instead of &DRM_GEM_SHMEM_DRIVER_OPS.
> + */
> +#define DRM_GEM_SHMEM_DRIVER_OPS_USB \
> +	DRM_GEM_SHMEM_DRIVER_OPS, \
> +	.gem_prime_import =3D drm_gem_prime_import_usb
> +#endif
> +
>   #endif /* __DRM_GEM_SHMEM_HELPER_H__ */
> diff --git a/include/drm/drm_prime.h b/include/drm/drm_prime.h
> index 54f2c58305d2..b42e07edd9e6 100644
> --- a/include/drm/drm_prime.h
> +++ b/include/drm/drm_prime.h
> @@ -110,4 +110,9 @@ int drm_prime_sg_to_page_array(struct sg_table *sgt=
, struct page **pages,
>   int drm_prime_sg_to_dma_addr_array(struct sg_table *sgt, dma_addr_t *=
addrs,
>   				   int max_pages);
>  =20
> +#ifdef CONFIG_USB
> +struct drm_gem_object *drm_gem_prime_import_usb(struct drm_device *dev=
,
> +						struct dma_buf *dma_buf);
> +#endif
> +
>   #endif /* __DRM_PRIME_H__ */
> diff --git a/include/linux/usb.h b/include/linux/usb.h
> index 7d72c4e0713c..a9bd698c8839 100644
> --- a/include/linux/usb.h
> +++ b/include/linux/usb.h
> @@ -711,6 +711,7 @@ struct usb_device {
>   	unsigned use_generic_driver:1;
>   };
>   #define	to_usb_device(d) container_of(d, struct usb_device, dev)
> +#define dev_is_usb(d)	((d)->bus =3D=3D &usb_bus_type)
>  =20
>   static inline struct usb_device *interface_to_usbdev(struct usb_inter=
face *intf)
>   {
> @@ -746,6 +747,8 @@ extern int usb_lock_device_for_reset(struct usb_dev=
ice *udev,
>   extern int usb_reset_device(struct usb_device *dev);
>   extern void usb_queue_reset_device(struct usb_interface *dev);
>  =20
> +extern struct device *usb_get_dma_device(struct usb_device *udev);
> +
>   #ifdef CONFIG_ACPI
>   extern int usb_acpi_set_power_state(struct usb_device *hdev, int inde=
x,
>   	bool enable);
>=20

--=20
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Maxfeldstr. 5, 90409 N=C3=BCrnberg, Germany
(HRB 36809, AG N=C3=BCrnberg)
Gesch=C3=A4ftsf=C3=BChrer: Felix Imend=C3=B6rffer


--Dq8wcrgO1lNZQieHaRiYicMoWZ1kNSVEY--

--6e9K8dMXU0lJ77IHXdrcRYc7Zhg3KhCLW
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEExndm/fpuMUdwYFFolh/E3EQov+AFAmA4qnYFAwAAAAAACgkQlh/E3EQov+An
hQ/+KwccQGtHg+1C4ng+lrWHQimvio7WKE6DnapDgBOeusDM6xOUB17hfkSjQpU2D/kmzwqTIxNK
6v6baIBrI3QSXuX8+4I5W/tngl+41zFNMYE2tld6u+8MkXqNf4M9d2E4OH37Bhy2MfD2omavYPMg
AY9JQz/tiOkim7O2E31xChmaTQ2zB9dinZI/ze1E8JWyr9s98AGTPV5q8ZJ2khlpRZjCNzSGZh1F
5D5768pDqFYb6sRbmDwl+IPit5n97hOT2PUoNY1EOQ7dRkhg0GrsSD6GKKvVmQiaYu2KCY9aDaqu
djmVHUKOC1eNOxR5Ep2zeYbLkPDIebzQ9oFownH5FPBsjvLpl85j0U68CbNe0p6Eh9AUM91UMWVD
BghvL3jfbzjE2LaG6jMtWivSMW2B3peRRab6JQcrqdzwGrMKDamqkdc5l804ojoOBxRHLobvCI4g
O9rbFvWhxI2Zf5wV5flknu1b7PUiBe53hJHZoszcihVtXQvi/xiReNnBMZZ2KEY1nHx/PJADekKp
sNC7o2bn2F32d3EobKDJRD6tLEv9CdSQnDOK2aIZg53hgxSWc/VYDPPQoFSfysuN9UsBgj1YQfbr
8rXFvzZH+hfP3N+iZ4AKKttSWTEUUHPFvoxG+ijgg7K91UQyM+FTz+VYCN0C7ZrBFTuXV3tneij4
Lbg=
=SEjD
-----END PGP SIGNATURE-----

--6e9K8dMXU0lJ77IHXdrcRYc7Zhg3KhCLW--
