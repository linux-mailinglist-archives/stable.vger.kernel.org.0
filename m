Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C117E323719
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 07:03:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234029AbhBXGDH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 01:03:07 -0500
Received: from mx2.suse.de ([195.135.220.15]:56212 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233997AbhBXGDG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 01:03:06 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 37B9BADCD;
        Wed, 24 Feb 2021 06:02:25 +0000 (UTC)
Subject: Re: [PATCH v3] drm: Use USB controller's DMA mask when importing
 dmabufs
To:     Alan Stern <stern@rowland.harvard.edu>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     Mathias Nyman <mathias.nyman@linux.intel.com>, airlied@linux.ie,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Oliver Neukum <oneukum@suse.com>,
        Christoph Hellwig <hch@lst.de>, christian.koenig@amd.com,
        hdegoede@redhat.com, Thomas Gleixner <tglx@linutronix.de>,
        dri-devel@lists.freedesktop.org, stable@vger.kernel.org,
        Johan Hovold <johan@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        sean@poorly.run
References: <20210223105842.27011-1-tzimmermann@suse.de>
 <YDTk3L3gNxDE3YrC@kroah.com> <20210223154507.GA1261797@rowland.harvard.edu>
From:   Thomas Zimmermann <tzimmermann@suse.de>
Message-ID: <c89dd869-917c-1842-2173-f582edd02a8f@suse.de>
Date:   Wed, 24 Feb 2021 07:02:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210223154507.GA1261797@rowland.harvard.edu>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="9R1rP065BsfpzaNZwDlog0BklX7NyfEXg"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--9R1rP065BsfpzaNZwDlog0BklX7NyfEXg
Content-Type: multipart/mixed; boundary="LTzFOk77qcvmY6gh1Piqj2tQH9AdjwTOW";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: Alan Stern <stern@rowland.harvard.edu>,
 Greg KH <gregkh@linuxfoundation.org>
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>, airlied@linux.ie,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Oliver Neukum <oneukum@suse.com>, Christoph Hellwig <hch@lst.de>,
 christian.koenig@amd.com, hdegoede@redhat.com,
 Thomas Gleixner <tglx@linutronix.de>, dri-devel@lists.freedesktop.org,
 stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>, sean@poorly.run
Message-ID: <c89dd869-917c-1842-2173-f582edd02a8f@suse.de>
Subject: Re: [PATCH v3] drm: Use USB controller's DMA mask when importing
 dmabufs
References: <20210223105842.27011-1-tzimmermann@suse.de>
 <YDTk3L3gNxDE3YrC@kroah.com> <20210223154507.GA1261797@rowland.harvard.edu>
In-Reply-To: <20210223154507.GA1261797@rowland.harvard.edu>

--LTzFOk77qcvmY6gh1Piqj2tQH9AdjwTOW
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi

Am 23.02.21 um 16:45 schrieb Alan Stern:
> On Tue, Feb 23, 2021 at 12:19:56PM +0100, Greg KH wrote:
>> On Tue, Feb 23, 2021 at 11:58:42AM +0100, Thomas Zimmermann wrote:
>=20
>>> --- a/drivers/gpu/drm/drm_prime.c
>>> +++ b/drivers/gpu/drm/drm_prime.c
>>> @@ -29,6 +29,7 @@
>>>   #include <linux/export.h>
>>>   #include <linux/dma-buf.h>
>>>   #include <linux/rbtree.h>
>>> +#include <linux/usb.h>
>>>
>>>   #include <drm/drm.h>
>>>   #include <drm/drm_drv.h>
>>> @@ -1055,3 +1056,38 @@ void drm_prime_gem_destroy(struct drm_gem_obje=
ct *obj, struct sg_table *sg)
>>>   	dma_buf_put(dma_buf);
>>>   }
>>>   EXPORT_SYMBOL(drm_prime_gem_destroy);
>>> +
>>> +/**
>>> + * drm_gem_prime_import_usb - helper library implementation of the i=
mport callback for USB devices
>>> + * @dev: drm_device to import into
>>> + * @dma_buf: dma-buf object to import
>>> + *
>>> + * This is an implementation of drm_gem_prime_import() for USB-based=
 devices.
>>> + * USB devices cannot perform DMA directly. This function selects th=
e USB host
>>> + * controller as DMA device instead. Drivers can use this as their
>>> + * &drm_driver.gem_prime_import implementation.
>>> + *
>>> + * See also drm_gem_prime_import().
>>> + */
>>> +#ifdef CONFIG_USB
>>> +struct drm_gem_object *drm_gem_prime_import_usb(struct drm_device *d=
ev,
>>> +						struct dma_buf *dma_buf)
>>> +{
>>> +	struct usb_device *udev;
>>> +	struct device *usbhost;
>>> +
>>> +	if (dev->dev->bus !=3D &usb_bus_type)
>>> +		return ERR_PTR(-ENODEV);
>>> +
>>> +	udev =3D interface_to_usbdev(to_usb_interface(dev->dev));
>>> +	if (!udev->bus)
>>> +		return ERR_PTR(-ENODEV);
>>> +
>>> +	usbhost =3D udev->bus->controller;
>>> +	if (!usbhost || !usbhost->dma_mask)
>>> +		return ERR_PTR(-ENODEV);
>=20
> Thomas, I doubt that you have to go through all of this.  The
> usb-storage driver, for instance, just uses the equivalent of
> dev->dev->dma_mask.  Even though USB devices don't do DMA themselves,
> the DMA mask value is inherited from the parent host controller's devic=
e
> struct.
>=20
> Have you tried doing this?

But it's the field that is now NULL, isn't it? :S How does usb-storage=20
get away with this?

Best regards
Thomas

>=20
>> If individual USB drivers need access to this type of thing, shouldn't=

>> that be done in the USB core itself?
>>
>> {hint, yes}
>>
>> There shouldn't be anything "special" about a DRM driver that needs th=
is
>> vs. any other driver that might want to know about DMA things related =
to
>> a specific USB device.  Why isn't this an issue with the existing
>> storage or v4l USB devices?
>=20
> If Thomas finds that the approach I outlined above works, then the rest=

> of this email thread becomes moot.  :-)
>=20
> Alan Stern
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


--LTzFOk77qcvmY6gh1Piqj2tQH9AdjwTOW--

--9R1rP065BsfpzaNZwDlog0BklX7NyfEXg
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEExndm/fpuMUdwYFFolh/E3EQov+AFAmA16+8FAwAAAAAACgkQlh/E3EQov+CX
zw/9H1giViFUGZ+0IB/8QsFFclpkiS67GMyI+1cxaO1LACfXNcAhruQkyxuiWST4TpKeErGrx1HO
b/HJe4yC4wvqnUyKyLpH1uizkZ0WhjYJdgjKsJX+VSlbLm9E216tiw05EYlseR3zerGWys6H60J8
n8JZ6A/PH55BuvkFxbcsW7TNJyzZOvFvyauM4NOCIxHQhZGjaifDhif6/8WsK/9Tscz0vIUv7int
GNAePinNOTkjc4aMQy0NPp2SpajrPHAJFVKL6/A6TJVpp081joLFMNiLymavv9qjF+aD3aXCYZJo
D8o5S2VGyRz8uJ6wFt8mqVRCqL58Qn2J2oFbQIKkrbkHNBjolQRs7AJApNH3m8jN/VQScdyZweJO
J2y9n8qBN6wGM+Vko53KD5kHRLSKqVnbuWuyK0rVT/w53ru2xLdSOe6xjXw4IKm0T0SVYJEfGm1b
agmanWU9PBKCGF+xIDBKq4M037F3a+Si7eh0SUdI4IO4YDCsVJbH8K+rZfaRUbkB222HiE+/ZOPD
Yw3jQCVLQ1L53eKTq6HkN43vCXJl9oOoCRx6skbe0QU/GcRmdNygpQfAATJqNpT610DYvSMpoeza
9xU9MKsY8aNo/S/7LyksTPZVaEht4ocVttCB/xxYSGaB4jQ52TIqkl4leVyLRaCG9PafY/03ifOJ
+zw=
=LMJ3
-----END PGP SIGNATURE-----

--9R1rP065BsfpzaNZwDlog0BklX7NyfEXg--
