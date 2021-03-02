Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB8B32AEE9
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:12:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233126AbhCCAIA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:08:00 -0500
Received: from mx2.suse.de ([195.135.220.15]:43284 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1577706AbhCBJqx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 04:46:53 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A53BEAAC5;
        Tue,  2 Mar 2021 09:45:56 +0000 (UTC)
Subject: Re: [PATCH v6] drm: Use USB controller's DMA mask when importing
 dmabufs
To:     daniel@ffwll.ch, airlied@linux.ie,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        sumit.semwal@linaro.org, christian.koenig@amd.com,
        gregkh@linuxfoundation.org, hdegoede@redhat.com, sean@poorly.run,
        noralf@tronnes.org, stern@rowland.harvard.edu
Cc:     dri-devel@lists.freedesktop.org, Pavel Machek <pavel@ucw.cz>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org
References: <20210301093127.11028-1-tzimmermann@suse.de>
From:   Thomas Zimmermann <tzimmermann@suse.de>
Message-ID: <eaddb25d-e569-82f6-33c4-804b1f691535@suse.de>
Date:   Tue, 2 Mar 2021 10:45:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210301093127.11028-1-tzimmermann@suse.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="jAN3046BJvBl99A6ehUASpUlABhZKJgkT"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--jAN3046BJvBl99A6ehUASpUlABhZKJgkT
Content-Type: multipart/mixed; boundary="wuqWf1Vvk2UsFn7xGVk1xftQRu5iWgNxx";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: daniel@ffwll.ch, airlied@linux.ie, maarten.lankhorst@linux.intel.com,
 mripard@kernel.org, sumit.semwal@linaro.org, christian.koenig@amd.com,
 gregkh@linuxfoundation.org, hdegoede@redhat.com, sean@poorly.run,
 noralf@tronnes.org, stern@rowland.harvard.edu
Cc: dri-devel@lists.freedesktop.org, Pavel Machek <pavel@ucw.cz>,
 Daniel Vetter <daniel.vetter@ffwll.ch>, Christoph Hellwig <hch@lst.de>,
 stable@vger.kernel.org
Message-ID: <eaddb25d-e569-82f6-33c4-804b1f691535@suse.de>
Subject: Re: [PATCH v6] drm: Use USB controller's DMA mask when importing
 dmabufs
References: <20210301093127.11028-1-tzimmermann@suse.de>
In-Reply-To: <20210301093127.11028-1-tzimmermann@suse.de>

--wuqWf1Vvk2UsFn7xGVk1xftQRu5iWgNxx
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi,

if there are no further comments on this patch, I intend to merge it via =

drm-misc.

Best regards
Thomas

Am 01.03.21 um 10:31 schrieb Thomas Zimmermann:
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
> v6:
> 	* implement workaround in DRM drivers and hold reference to
> 	  DMA device while USB device is in use
> 	* remove dev_is_usb() (Greg)
> 	* collapse USB helper into usb_intf_get_dma_device() (Alan)
> 	* integrate Daniel's TODO statement (Daniel)
> 	* fix typos (Greg)
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
>=20
> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> Fixes: 6eb0233ec2d0 ("usb: don't inherity DMA properties for USB device=
s")
> Tested-by: Pavel Machek <pavel@ucw.cz>
> Acked-by: Christian K=C3=B6nig <christian.koenig@amd.com>
> Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: <stable@vger.kernel.org> # v5.10+
> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> ---
>   Documentation/gpu/todo.rst      | 21 +++++++++++++++++++++
>   drivers/gpu/drm/tiny/gm12u320.c | 25 +++++++++++++++++++++++++
>   drivers/gpu/drm/udl/udl_drv.c   | 17 +++++++++++++++++
>   drivers/gpu/drm/udl/udl_drv.h   |  1 +
>   drivers/gpu/drm/udl/udl_main.c  |  9 +++++++++
>   drivers/usb/core/usb.c          | 32 ++++++++++++++++++++++++++++++++=

>   include/linux/usb.h             |  2 ++
>   7 files changed, 107 insertions(+)
>=20
> diff --git a/Documentation/gpu/todo.rst b/Documentation/gpu/todo.rst
> index 0631b9b323d5..fdfd6a1081ec 100644
> --- a/Documentation/gpu/todo.rst
> +++ b/Documentation/gpu/todo.rst
> @@ -571,6 +571,27 @@ Contact: Daniel Vetter
>  =20
>   Level: Intermediate
>  =20
> +Remove automatic page mapping from dma-buf importing
> +----------------------------------------------------
> +
> +When importing dma-bufs, the dma-buf and PRIME frameworks automaticall=
y map
> +imported pages into the importer's DMA area. drm_gem_prime_fd_to_handl=
e() and
> +drm_gem_prime_handle_to_fd() require that importers call dma_buf_attac=
h()
> +even if they never do actual device DMA, but only CPU access through
> +dma_buf_vmap(). This is a problem for USB devices, which do not suppor=
t DMA
> +operations.
> +
> +To fix the issue, automatic page mappings should be removed from the
> +buffer-sharing code. Fixing this is a bit more involved, since the imp=
ort/export
> +cache is also tied to &drm_gem_object.import_attach. Meanwhile we pape=
r over
> +this problem for USB devices by fishing out the USB host controller de=
vice, as
> +long as that supports DMA. Otherwise importing can still needlessly fa=
il.
> +
> +Contact: Thomas Zimmermann <tzimmermann@suse.de>, Daniel Vetter
> +
> +Level: Advanced
> +
> +
>   Better Testing
>   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>  =20
> diff --git a/drivers/gpu/drm/tiny/gm12u320.c b/drivers/gpu/drm/tiny/gm1=
2u320.c
> index 0b4f4f2af1ef..48b5b06f70e8 100644
> --- a/drivers/gpu/drm/tiny/gm12u320.c
> +++ b/drivers/gpu/drm/tiny/gm12u320.c
> @@ -84,6 +84,7 @@ MODULE_PARM_DESC(eco_mode, "Turn on Eco mode (less br=
ight, more silent)");
>  =20
>   struct gm12u320_device {
>   	struct drm_device	         dev;
> +	struct device                   *dmadev;
>   	struct drm_simple_display_pipe   pipe;
>   	struct drm_connector	         conn;
>   	unsigned char                   *cmd_buf;
> @@ -599,6 +600,22 @@ static const uint64_t gm12u320_pipe_modifiers[] =3D=
 {
>   	DRM_FORMAT_MOD_INVALID
>   };
>  =20
> +/*
> + * FIXME: Dma-buf sharing requires DMA support by the importing device=
=2E
> + *        This function is a workaround to make USB devices work as we=
ll.
> + *        See todo.rst for how to fix the issue in the dma-buf framewo=
rk.
> + */
> +static struct drm_gem_object *gm12u320_gem_prime_import(struct drm_dev=
ice *dev,
> +							struct dma_buf *dma_buf)
> +{
> +	struct gm12u320_device *gm12u320 =3D to_gm12u320(dev);
> +
> +	if (!gm12u320->dmadev)
> +		return ERR_PTR(-ENODEV);
> +
> +	return drm_gem_prime_import_dev(dev, dma_buf, gm12u320->dmadev);
> +}
> +
>   DEFINE_DRM_GEM_FOPS(gm12u320_fops);
>  =20
>   static const struct drm_driver gm12u320_drm_driver =3D {
> @@ -612,6 +629,7 @@ static const struct drm_driver gm12u320_drm_driver =
=3D {
>  =20
>   	.fops		 =3D &gm12u320_fops,
>   	DRM_GEM_SHMEM_DRIVER_OPS,
> +	.gem_prime_import =3D gm12u320_gem_prime_import,
>   };
>  =20
>   static const struct drm_mode_config_funcs gm12u320_mode_config_funcs =
=3D {
> @@ -639,6 +657,10 @@ static int gm12u320_usb_probe(struct usb_interface=
 *interface,
>   	if (IS_ERR(gm12u320))
>   		return PTR_ERR(gm12u320);
>  =20
> +	gm12u320->dmadev =3D usb_intf_get_dma_device(to_usb_interface(dev->de=
v));
> +	if (!gm12u320->dmadev)
> +		drm_warn(dev, "buffer sharing not supported"); /* not an error */
> +
>   	INIT_DELAYED_WORK(&gm12u320->fb_update.work, gm12u320_fb_update_work=
);
>   	mutex_init(&gm12u320->fb_update.lock);
>  =20
> @@ -691,7 +713,10 @@ static int gm12u320_usb_probe(struct usb_interface=
 *interface,
>   static void gm12u320_usb_disconnect(struct usb_interface *interface)
>   {
>   	struct drm_device *dev =3D usb_get_intfdata(interface);
> +	struct gm12u320_device *gm12u320 =3D to_gm12u320(dev);
>  =20
> +	put_device(gm12u320->dmadev);
> +	gm12u320->dmadev =3D NULL;
>   	drm_dev_unplug(dev);
>   	drm_atomic_helper_shutdown(dev);
>   }
> diff --git a/drivers/gpu/drm/udl/udl_drv.c b/drivers/gpu/drm/udl/udl_dr=
v.c
> index 9269092697d8..5703277c6f52 100644
> --- a/drivers/gpu/drm/udl/udl_drv.c
> +++ b/drivers/gpu/drm/udl/udl_drv.c
> @@ -32,6 +32,22 @@ static int udl_usb_resume(struct usb_interface *inte=
rface)
>   	return drm_mode_config_helper_resume(dev);
>   }
>  =20
> +/*
> + * FIXME: Dma-buf sharing requires DMA support by the importing device=
=2E
> + *        This function is a workaround to make USB devices work as we=
ll.
> + *        See todo.rst for how to fix the issue in the dma-buf framewo=
rk.
> + */
> +static struct drm_gem_object *udl_driver_gem_prime_import(struct drm_d=
evice *dev,
> +							  struct dma_buf *dma_buf)
> +{
> +	struct udl_device *udl =3D to_udl(dev);
> +
> +	if (!udl->dmadev)
> +		return ERR_PTR(-ENODEV);
> +
> +	return drm_gem_prime_import_dev(dev, dma_buf, udl->dmadev);
> +}
> +
>   DEFINE_DRM_GEM_FOPS(udl_driver_fops);
>  =20
>   static const struct drm_driver driver =3D {
> @@ -40,6 +56,7 @@ static const struct drm_driver driver =3D {
>   	/* GEM hooks */
>   	.fops =3D &udl_driver_fops,
>   	DRM_GEM_SHMEM_DRIVER_OPS,
> +	.gem_prime_import =3D udl_driver_gem_prime_import,
>  =20
>   	.name =3D DRIVER_NAME,
>   	.desc =3D DRIVER_DESC,
> diff --git a/drivers/gpu/drm/udl/udl_drv.h b/drivers/gpu/drm/udl/udl_dr=
v.h
> index 875e73551ae9..cc16a13316e4 100644
> --- a/drivers/gpu/drm/udl/udl_drv.h
> +++ b/drivers/gpu/drm/udl/udl_drv.h
> @@ -50,6 +50,7 @@ struct urb_list {
>   struct udl_device {
>   	struct drm_device drm;
>   	struct device *dev;
> +	struct device *dmadev;
>  =20
>   	struct drm_simple_display_pipe display_pipe;
>  =20
> diff --git a/drivers/gpu/drm/udl/udl_main.c b/drivers/gpu/drm/udl/udl_m=
ain.c
> index 0e2a376cb075..7c0338bcadea 100644
> --- a/drivers/gpu/drm/udl/udl_main.c
> +++ b/drivers/gpu/drm/udl/udl_main.c
> @@ -315,6 +315,10 @@ int udl_init(struct udl_device *udl)
>  =20
>   	DRM_DEBUG("\n");
>  =20
> +	udl->dmadev =3D usb_intf_get_dma_device(to_usb_interface(dev->dev));
> +	if (!udl->dmadev)
> +		drm_warn(dev, "buffer sharing not supported"); /* not an error */
> +
>   	mutex_init(&udl->gem_lock);
>  =20
>   	if (!udl_parse_vendor_descriptor(udl)) {
> @@ -349,6 +353,11 @@ int udl_init(struct udl_device *udl)
>  =20
>   int udl_drop_usb(struct drm_device *dev)
>   {
> +	struct udl_device *udl =3D to_udl(dev);
> +
>   	udl_free_urb_list(dev);
> +	put_device(udl->dmadev);
> +	udl->dmadev =3D NULL;
> +
>   	return 0;
>   }
> diff --git a/drivers/usb/core/usb.c b/drivers/usb/core/usb.c
> index 8f07b0516100..a566bb494e24 100644
> --- a/drivers/usb/core/usb.c
> +++ b/drivers/usb/core/usb.c
> @@ -748,6 +748,38 @@ void usb_put_intf(struct usb_interface *intf)
>   }
>   EXPORT_SYMBOL_GPL(usb_put_intf);
>  =20
> +/**
> + * usb_intf_get_dma_device - acquire a reference on the usb interface'=
s DMA endpoint
> + * @intf: the usb interface
> + *
> + * While a USB device cannot perform DMA operations by itself, many US=
B
> + * controllers can. A call to usb_intf_get_dma_device() returns the DM=
A endpoint
> + * for the given USB interface, if any. The returned device structure =
must be
> + * released with put_device().
> + *
> + * See also usb_get_dma_device().
> + *
> + * Returns: A reference to the usb interface's DMA endpoint; or NULL i=
f none
> + *          exists.
> + */
> +struct device *usb_intf_get_dma_device(struct usb_interface *intf)
> +{
> +	struct usb_device *udev =3D interface_to_usbdev(intf);
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
> +EXPORT_SYMBOL_GPL(usb_intf_get_dma_device);
> +
>   /*			USB device locking
>    *
>    * USB devices and interfaces are locked using the semaphore in their=

> diff --git a/include/linux/usb.h b/include/linux/usb.h
> index 7d72c4e0713c..d6a41841b93e 100644
> --- a/include/linux/usb.h
> +++ b/include/linux/usb.h
> @@ -746,6 +746,8 @@ extern int usb_lock_device_for_reset(struct usb_dev=
ice *udev,
>   extern int usb_reset_device(struct usb_device *dev);
>   extern void usb_queue_reset_device(struct usb_interface *dev);
>  =20
> +extern struct device *usb_intf_get_dma_device(struct usb_interface *in=
tf);
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


--wuqWf1Vvk2UsFn7xGVk1xftQRu5iWgNxx--

--jAN3046BJvBl99A6ehUASpUlABhZKJgkT
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEExndm/fpuMUdwYFFolh/E3EQov+AFAmA+CVMFAwAAAAAACgkQlh/E3EQov+AY
PA//aUS+kIrCaN3iXGWsVzpzoJx2lT2m+2AmgqA6rzkB5ij7F9rkFdm9ofa0fT74m7mdiDBn1fZP
LvDTw6HArjCbWk4IxP8nbxhIcxiHWtvXyK39voXoF8BA/HEcA5cF6rNrDMSJp4WYqbCD03C1uchb
D8a2XUwW/yLXe0v525iUxXy7xQwVTGZnpEQrYqHMKvnDQx21Jwl1NUrp0JkRtC9h+WhPGdz0QDMC
vGJAR5Co9tEsblaCdNcUKMZLyQw1vgAMwdAyWt2j7Y5Ycd5tbA08V5z0QGbymmwAjSuGHBp1u40+
sn9AAvMLsFdvJTz/AEXHW5q+oRk7VB4Sb+zkKbH1Hduopsp8imUR/3kKevkC9PAybuBCA1ZgS39v
IdRv+7HPRLeHrNPHxVrAXEeJUcGr2I5TCiF4cYOhfH7dvR57GLft4o4e6nvb3k75TDX//64kq9Yf
JreOy1cJwhvIW3H5ygHYXa0FQYh2pmR+oZXX52Y9DHXoMFNbpKMgPrLhik2h236yAtAOijxcUbtO
5LO51u8fjbNmxAO5UNWi2G3JeahjCl7go1n9xVmJw6h1l/4Vr/cWNjFInYKg8LN4VrYiI3NfnhzC
OSbCoC58/z2rtMIgsVCqP3+YLn+AlElC757mVkfoFhOcjV3qsoq8ZI9q0P5AZCSsyKKw+K7bnOEm
+EM=
=C3jw
-----END PGP SIGNATURE-----

--jAN3046BJvBl99A6ehUASpUlABhZKJgkT--
