Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A32C322AAC
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 13:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232753AbhBWMh6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 07:37:58 -0500
Received: from mx2.suse.de ([195.135.220.15]:49050 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232754AbhBWMhx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Feb 2021 07:37:53 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 8EBEAAC1D;
        Tue, 23 Feb 2021 12:37:11 +0000 (UTC)
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Mathias Nyman <mathias.nyman@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, airlied@linux.ie,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Oliver Neukum <oneukum@suse.com>,
        Christoph Hellwig <hch@lst.de>, hdegoede@redhat.com,
        Alan Stern <stern@rowland.harvard.edu>,
        dri-devel@lists.freedesktop.org, stable@vger.kernel.org,
        Johan Hovold <johan@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        sean@poorly.run, christian.koenig@amd.com
References: <20210223105842.27011-1-tzimmermann@suse.de>
 <YDTk3L3gNxDE3YrC@kroah.com>
From:   Thomas Zimmermann <tzimmermann@suse.de>
Subject: Re: [PATCH v3] drm: Use USB controller's DMA mask when importing
 dmabufs
Message-ID: <656a49c3-018e-9188-94bf-5f1270ea61e4@suse.de>
Date:   Tue, 23 Feb 2021 13:37:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YDTk3L3gNxDE3YrC@kroah.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="OIHVxjk4hVnXkGdqByDLdoXrzIKpGuhDl"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--OIHVxjk4hVnXkGdqByDLdoXrzIKpGuhDl
Content-Type: multipart/mixed; boundary="kjapg5qJnhvdmGKHfwqO4ajdMRJv51cGi";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>,
 Thomas Gleixner <tglx@linutronix.de>, airlied@linux.ie,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Oliver Neukum <oneukum@suse.com>, Christoph Hellwig <hch@lst.de>,
 hdegoede@redhat.com, Alan Stern <stern@rowland.harvard.edu>,
 dri-devel@lists.freedesktop.org, stable@vger.kernel.org,
 Johan Hovold <johan@kernel.org>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>, sean@poorly.run,
 christian.koenig@amd.com
Message-ID: <656a49c3-018e-9188-94bf-5f1270ea61e4@suse.de>
Subject: Re: [PATCH v3] drm: Use USB controller's DMA mask when importing
 dmabufs
References: <20210223105842.27011-1-tzimmermann@suse.de>
 <YDTk3L3gNxDE3YrC@kroah.com>
In-Reply-To: <YDTk3L3gNxDE3YrC@kroah.com>

--kjapg5qJnhvdmGKHfwqO4ajdMRJv51cGi
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi

Am 23.02.21 um 12:19 schrieb Greg KH:
> On Tue, Feb 23, 2021 at 11:58:42AM +0100, Thomas Zimmermann wrote:
>> USB devices cannot perform DMA and hence have no dma_mask set in their=

>> device structure. Importing dmabuf into a USB-based driver fails, whic=
h
>> break joining and mirroring of display in X11.
>>
>> For USB devices, pick the associated USB controller as attachment devi=
ce,
>> so that it can perform DMA. If the DMa controller does not support DMA=

>> transfers, we're aout of luck and cannot import.
>>
>> Drivers should use DRM_GEM_SHMEM_DROVER_OPS_USB to initialize their
>> instance of struct drm_driver.
>>
>> Tested by joining/mirroring displays of udl and radeon un der Gnome/X1=
1.
>>
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
>> Cc: Christoph Hellwig <hch@lst.de>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: Johan Hovold <johan@kernel.org>
>> Cc: Alan Stern <stern@rowland.harvard.edu>
>> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>> Cc: Mathias Nyman <mathias.nyman@linux.intel.com>
>> Cc: Oliver Neukum <oneukum@suse.com>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: <stable@vger.kernel.org> # v5.10+
>> ---
>>   drivers/gpu/drm/drm_prime.c        | 36 ++++++++++++++++++++++++++++=
++
>>   drivers/gpu/drm/tiny/gm12u320.c    |  2 +-
>>   drivers/gpu/drm/udl/udl_drv.c      |  2 +-
>>   include/drm/drm_gem_shmem_helper.h | 13 +++++++++++
>>   include/drm/drm_prime.h            |  5 +++++
>>   5 files changed, 56 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c=

>> index 2a54f86856af..9015850f2160 100644
>> --- a/drivers/gpu/drm/drm_prime.c
>> +++ b/drivers/gpu/drm/drm_prime.c
>> @@ -29,6 +29,7 @@
>>   #include <linux/export.h>
>>   #include <linux/dma-buf.h>
>>   #include <linux/rbtree.h>
>> +#include <linux/usb.h>
>>
>>   #include <drm/drm.h>
>>   #include <drm/drm_drv.h>
>> @@ -1055,3 +1056,38 @@ void drm_prime_gem_destroy(struct drm_gem_objec=
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
>> + */
>> +#ifdef CONFIG_USB
>> +struct drm_gem_object *drm_gem_prime_import_usb(struct drm_device *de=
v,
>> +						struct dma_buf *dma_buf)
>> +{
>> +	struct usb_device *udev;
>> +	struct device *usbhost;
>> +
>> +	if (dev->dev->bus !=3D &usb_bus_type)
>> +		return ERR_PTR(-ENODEV);
>> +
>> +	udev =3D interface_to_usbdev(to_usb_interface(dev->dev));
>> +	if (!udev->bus)
>> +		return ERR_PTR(-ENODEV);
>> +
>> +	usbhost =3D udev->bus->controller;
>> +	if (!usbhost || !usbhost->dma_mask)
>> +		return ERR_PTR(-ENODEV);
>=20
> If individual USB drivers need access to this type of thing, shouldn't
> that be done in the USB core itself?
>=20
> {hint, yes}
>=20
> There shouldn't be anything "special" about a DRM driver that needs thi=
s
> vs. any other driver that might want to know about DMA things related t=
o
> a specific USB device.  Why isn't this an issue with the existing
> storage or v4l USB devices?

I don't know about vc4 or storage. My guess is that they don't call=20
dma_map_sgtable() for devices with dma_mask. Ideally, USB DRM devices=20
wouldn't do that either, but, as Daniel explained, DRM's PRIME framework =

expects a dma_mask on the importing device.

The real fix would move this from framework to drivers, so that each=20
driver can import the dmabuf according to its capabilities. I tried to=20
do this with v2 of this patch, but I was not feasible at this time.

For this to work, we'd have rework at least 3 drivers, the PRIME=20
framework and the dmabuf framework. I don't think the stable maintainer=20
would be keen on merging that. ;)

Wrt your question about the USB core: what we do here is a workaround=20
for dmabuf importing. The DRM USB drivers don't even use the resulting=20
page mapping directly. Putting the workaround into the USB core is maybe =

not useful. If we ever use DMA directly for streaming framebuffers to=20
the device, thinks might be different.

Best regards
Thomas

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


--kjapg5qJnhvdmGKHfwqO4ajdMRJv51cGi--

--OIHVxjk4hVnXkGdqByDLdoXrzIKpGuhDl
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEExndm/fpuMUdwYFFolh/E3EQov+AFAmA09vUFAwAAAAAACgkQlh/E3EQov+CU
bw//UcFwu6WaD5jSqfAYnGfjKNpZ+FnoOH9CXs260StWRpnThtwrLha59lC9Xapl/sTkZtKQ7R5C
Z5tsAnVRV2W+Fel7i5x2frsodFM3RB/qbleDkZbfeMM0bGbQRjxY/ItextjbTKU9qqNGqBahzxgl
mSuGQersdkOb61hw2Sbp83LsgDfAZd6LyPVeH5n5C9g9+MmIO2eQencVbYH1JKJX0HjD/WYN5wR8
9UpXh//NOnAsqnommPVs3zayuQcA5Q0sJruTSYghDpBneDiedESHK3tESY6m9Lp75LmUWZtAoirj
lRvusnf697BbKnYTAbLjsTpIuOUWyOnTmJDR0LFc14dzmNjbvoTsSnx1fyPbgd0qsZsPyXpn2dGR
/3kuhQzK48zFE2/vEm1EkBlbg8mg1/hseJ7TdGC4u4PyAwTRmr+bBSJ0ND6oYGaUVE3evTfjBAuK
XyU7OSVhP5xK7dZJtTInaLfL/9qFXICjp1ud60Ca/9/5eJFvxBNKatIkgotc4qs1YNnQ+NLv24Ud
nDwyfG7ezFJeY0u7adMZcxjiSM3+h2b477WJlYvAQcmztJt/rHrJo9LRwXMx92/EjyMsR3AHhL2b
IvnZHR34dyk2G88ne6Tr2WYnbjcT3okxcmOD6ph8vyjsnkzVvwW9eEF6QLDc/NImzdV5wKF1jU1P
c+o=
=XvPX
-----END PGP SIGNATURE-----

--OIHVxjk4hVnXkGdqByDLdoXrzIKpGuhDl--
