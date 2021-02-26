Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B58B1326140
	for <lists+stable@lfdr.de>; Fri, 26 Feb 2021 11:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbhBZK3v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Feb 2021 05:29:51 -0500
Received: from mx2.suse.de ([195.135.220.15]:53230 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230087AbhBZK3t (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Feb 2021 05:29:49 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E03F4AF33;
        Fri, 26 Feb 2021 10:29:06 +0000 (UTC)
Subject: Re: [PATCH v5] drm: Use USB controller's DMA mask when importing
 dmabufs
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Pavel Machek <pavel@ucw.cz>, airlied@linux.ie,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>, hdegoede@redhat.com,
        stern@rowland.harvard.edu, dri-devel@lists.freedesktop.org,
        stable@vger.kernel.org, sean@poorly.run, christian.koenig@amd.com
References: <20210226092648.4584-1-tzimmermann@suse.de>
 <YDjLIfVqbQzAgBE+@kroah.com>
From:   Thomas Zimmermann <tzimmermann@suse.de>
Message-ID: <e92fe4ca-fc19-fc11-f885-468a762e3d0d@suse.de>
Date:   Fri, 26 Feb 2021 11:29:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YDjLIfVqbQzAgBE+@kroah.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Ka51UMrhRX3Q7wBPfiGi7co0k5ehlDHW2"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Ka51UMrhRX3Q7wBPfiGi7co0k5ehlDHW2
Content-Type: multipart/mixed; boundary="niiVUacHvMrCZGM32Gt833sWhlX62HGD1";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Pavel Machek <pavel@ucw.cz>, airlied@linux.ie,
 Daniel Vetter <daniel.vetter@ffwll.ch>, Christoph Hellwig <hch@lst.de>,
 hdegoede@redhat.com, stern@rowland.harvard.edu,
 dri-devel@lists.freedesktop.org, stable@vger.kernel.org, sean@poorly.run,
 christian.koenig@amd.com
Message-ID: <e92fe4ca-fc19-fc11-f885-468a762e3d0d@suse.de>
Subject: Re: [PATCH v5] drm: Use USB controller's DMA mask when importing
 dmabufs
References: <20210226092648.4584-1-tzimmermann@suse.de>
 <YDjLIfVqbQzAgBE+@kroah.com>
In-Reply-To: <YDjLIfVqbQzAgBE+@kroah.com>

--niiVUacHvMrCZGM32Gt833sWhlX62HGD1
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi

Am 26.02.21 um 11:19 schrieb Greg KH:
> On Fri, Feb 26, 2021 at 10:26:47AM +0100, Thomas Zimmermann wrote:
>> USB devices cannot perform DMA and hence have no dma_mask set in their=

>> device structure. Therefore importing dmabuf into a USB-based driver
>> fails, which breaks joining and mirroring of display in X11.
>>
>> For USB devices, pick the associated USB controller as attachment devi=
ce.
>> This allows the DRM import helpers to perform the DMA setup. If the DM=
A
>> controller does not support DMA transfers, we're out of luck and canno=
t
>> import. Our current USB-based DRM drivers don't use DMA, so the actual=

>> DMA device is not important.
>>
>> Drivers should use DRM_GEM_SHMEM_DROVER_OPS_USB to initialize their
>> instance of struct drm_driver.
>>
>> Tested by joining/mirroring displays of udl and radeon un der Gnome/X1=
1.
>>
>> v5:
>> 	* provide a helper for USB interfaces (Alan)
>> 	* add FIXME item to documentation and TODO list (Daniel)
>> v4:
>> 	* implement workaround with USB helper functions (Greg)
>> 	* use struct usb_device->bus->sysdev as DMA device (Takashi)
>> v3:
>> 	* drop gem_create_object
>> 	* use DMA mask of USB controller, if any (Daniel, Christian, Noralf)
>> v2:
>> 	* move fix to importer side (Christian, Daniel)
>> 	* update SHMEM and CMA helpers for new PRIME callbacks
>>
>> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
>> Fixes: 6eb0233ec2d0 ("usb: don't inherity DMA properties for USB devic=
es")
>> Tested-by: Pavel Machek <pavel@ucw.cz>
>> Acked-by: Christian K=C3=B6nig <christian.koenig@amd.com>
>> Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
>> Cc: Christoph Hellwig <hch@lst.de>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: <stable@vger.kernel.org> # v5.10+
>> ---
>>   Documentation/gpu/todo.rst         | 15 ++++++++++
>>   drivers/gpu/drm/drm_prime.c        | 45 ++++++++++++++++++++++++++++=
++
>>   drivers/gpu/drm/tiny/gm12u320.c    |  2 +-
>>   drivers/gpu/drm/udl/udl_drv.c      |  2 +-
>>   drivers/usb/core/usb.c             | 31 ++++++++++++++++++++
>>   include/drm/drm_gem_shmem_helper.h | 16 +++++++++++
>>   include/drm/drm_prime.h            |  5 ++++
>>   include/linux/usb.h                | 24 ++++++++++++++++
>>   8 files changed, 138 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/gpu/todo.rst b/Documentation/gpu/todo.rst
>> index f872d3d33218..c185e0a2951e 100644
>> --- a/Documentation/gpu/todo.rst
>> +++ b/Documentation/gpu/todo.rst
>> @@ -617,6 +617,21 @@ Contact: Daniel Vetter
>>  =20
>>   Level: Intermediate
>>  =20
>> +Remove automatic page mapping from dma-buf importing
>> +----------------------------------------------------
>> +
>> +When importing dma-bufs, the dma-buf and PRIME frameworks automatical=
ly map
>> +imported pages into the importer's DMA area. This is a problem for US=
B devices,
>> +which do not support DMA operations. By default, importing fails for =
USB
>> +devices. USB-based drivers work around this problem by employing
>> +drm_gem_prime_import_usb(). To fix the issue, automatic page mappings=
 should
>> +be removed from the buffer-sharing code.
>> +
>> +Contact: Thomas Zimmermann <tzimmermann@suse.de>, Daniel Vetter
>> +
>> +Level: Advanced
>> +
>> +
>>   Better Testing
>>   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>  =20
>> diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c=

>> index 2a54f86856af..59013bb1cd4b 100644
>> --- a/drivers/gpu/drm/drm_prime.c
>> +++ b/drivers/gpu/drm/drm_prime.c
>> @@ -29,6 +29,7 @@
>>   #include <linux/export.h>
>>   #include <linux/dma-buf.h>
>>   #include <linux/rbtree.h>
>> +#include <linux/usb.h>
>>  =20
>>   #include <drm/drm.h>
>>   #include <drm/drm_drv.h>
>> @@ -1055,3 +1056,47 @@ void drm_prime_gem_destroy(struct drm_gem_objec=
t *obj, struct sg_table *sg)
>>   	dma_buf_put(dma_buf);
>>   }
>>   EXPORT_SYMBOL(drm_prime_gem_destroy);
>> +
>> +/**
>> + * drm_gem_prime_import_usb - helper library implementation of the im=
port callback for USB devices
>> + * @dev: drm_device to import into
>> + * @dma_buf: dma-buf object to import
>> + *
>> + * This is an implementation of drm_gem_prime_import() for USB-based =
devices.
>> + * USB devices cannot perform DMA directly. This function selects the=
 USB host
>> + * controller as DMA device instead. Drivers can use this as their
>> + * &drm_driver.gem_prime_import implementation.
>> + *
>> + * See also drm_gem_prime_import().
>> + *
>> + * FIXME: The dma-buf framework expects to map the exported pages int=
o
>> + *        the importer's DMA area. USB devices don't support DMA, and=

>> + *        importing would fail. Foir the time being, this function pr=
ovides
>> + *        a workaround by using the USB controller's DMA area. The re=
al
>> + *        solution is to remove page-mapping operations from the dma-=
buf
>> + *        framework.
>> + *
>> + * Returns: A GEM object on success, or a pointer-encoder errno value=
 otherwise.
>> + */
>> +#ifdef CONFIG_USB
>> +struct drm_gem_object *drm_gem_prime_import_usb(struct drm_device *de=
v,
>> +						struct dma_buf *dma_buf)
>> +{
>> +	struct device *dmadev;
>> +	struct drm_gem_object *obj;
>> +
>> +	if (!dev_is_usb(dev->dev))
>> +		return ERR_PTR(-ENODEV);
>=20
> I have resisted the "dev_is_*()" type of function for USB for a long
> time now, and I really don't want to add it now.
>=20
> The driver core explicitly was not created with RTI (run type
> identification), but over time it has been slowly added on a per-bus
> basis for various reasons, some good and others not good.
>=20
> In this function, why would a drm device that was NOT a usb device ever=

> call it?  Because of that, I don't think dev_is_usb() is needed at all,=

> just don't call this function unless it really is a USB device.

It was simply a safety measure. There's really no reason a non-USB=20
device would ever call this function. So not using dev_is_usb() is fine. =

It'll be gone in v6.

Best regards
Thomas

>=20
> If you need help enforcing it, add a 'struct usb_interface *' to the
> function parameters but please don't create this function.
>=20
> Hm, looks like we have 2 extern definitions of usb_bus_type in differen=
t
> .h files, I should go fix that up now to try to prevent this type of
> thing in the first place...
>=20
> thanks,
>=20
> greg k-h
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel
>=20

--=20
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Maxfeldstr. 5, 90409 N=C3=BCrnberg, Germany
(HRB 36809, AG N=C3=BCrnberg)
Gesch=C3=A4ftsf=C3=BChrer: Felix Imend=C3=B6rffer


--niiVUacHvMrCZGM32Gt833sWhlX62HGD1--

--Ka51UMrhRX3Q7wBPfiGi7co0k5ehlDHW2
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEExndm/fpuMUdwYFFolh/E3EQov+AFAmA4zXEFAwAAAAAACgkQlh/E3EQov+Cl
URAAhqLGpJEeIkcJJa9F9h1rh5z1CWPJWB2lDD00GBIc/yN6S57dF4XNiT4s06BXDS1TXB/d5Z4Q
ALUJwPUX3wkg0wdOaOotTRtfDZgabD9NmgT9xGKoXsJTDZhNNzZ6Oo0gRfuM2VtXOuxaHIdiQp1v
tDcp5bkBMMLiXFK5aWvjd7Si9lNihnFalxV9VLEd2z05ZXTQjaVNYcQsgNhYUCL+3NgxeL5fy0+l
p8GOwNPxrCbwlrRCa/wHGsc6LsNL4glsfwc0C9vpxDaTds/iFPp8WuRlYi2q8vIyPTrRAfWLerFI
0A6o+h+zC7VGvgR11Xvz9FQfpBeCkEN6LPALAZj97ql4KVs1Rrda/HQAJiyB1QbBeKbg2hVqTqIV
gb0rr33pFq2oUSOzFUDkVoH2ZeJHgPHFdKNMhMOURTIuiOFit1KXJWfXZQGABaiZchhhClXUkgs5
OqOK0R+wsmz8PZiw+U2BclbcQtph0hzoEbj0owFVoRaMgf7wpw4A4UnW2yRzA6+blnMSwdrgDWqF
YchBNIxszibwjQ+3oLyczVmbZVjI7EC9LznC6RZaz14xYEGr5z9cMFrz0BCgg8x4CcHl69Rd0jni
tG0Md5kwIoVsFznFE4/hPMQzY/JgE6lXYG2LHiek54reNGkmkiIr8NvQGE4PxUZ/QI3gHGvQFYQb
kbY=
=IF3w
-----END PGP SIGNATURE-----

--Ka51UMrhRX3Q7wBPfiGi7co0k5ehlDHW2--
