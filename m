Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9639C322BE6
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 15:07:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbhBWOGv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 09:06:51 -0500
Received: from mx2.suse.de ([195.135.220.15]:41920 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230291AbhBWOGv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Feb 2021 09:06:51 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 296D3AF2C;
        Tue, 23 Feb 2021 14:06:09 +0000 (UTC)
Subject: Re: [PATCH v3] drm: Use USB controller's DMA mask when importing
 dmabufs
To:     Takashi Iwai <tiwai@suse.de>
Cc:     Mathias Nyman <mathias.nyman@linux.intel.com>, airlied@linux.ie,
        gregkh@linuxfoundation.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Oliver Neukum <oneukum@suse.com>,
        Johan Hovold <johan@kernel.org>, hdegoede@redhat.com,
        Christoph Hellwig <hch@lst.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        dri-devel@lists.freedesktop.org, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        sean@poorly.run, christian.koenig@amd.com
References: <20210223105842.27011-1-tzimmermann@suse.de>
 <s5hh7m2vqyd.wl-tiwai@suse.de>
From:   Thomas Zimmermann <tzimmermann@suse.de>
Message-ID: <f4452070-bab1-35ad-69aa-d020a4a3a5b7@suse.de>
Date:   Tue, 23 Feb 2021 15:06:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <s5hh7m2vqyd.wl-tiwai@suse.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="7aYl7icMQv17jkilLUeIhhp6ISik7DLkM"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7aYl7icMQv17jkilLUeIhhp6ISik7DLkM
Content-Type: multipart/mixed; boundary="aBDUZUy3Os2nqn1T3G46zfyCm6RwWSKu5";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>, airlied@linux.ie,
 gregkh@linuxfoundation.org, Sebastian Andrzej Siewior
 <bigeasy@linutronix.de>, Oliver Neukum <oneukum@suse.com>,
 Johan Hovold <johan@kernel.org>, hdegoede@redhat.com,
 Christoph Hellwig <hch@lst.de>, Alan Stern <stern@rowland.harvard.edu>,
 dri-devel@lists.freedesktop.org, stable@vger.kernel.org,
 Thomas Gleixner <tglx@linutronix.de>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>, sean@poorly.run,
 christian.koenig@amd.com
Message-ID: <f4452070-bab1-35ad-69aa-d020a4a3a5b7@suse.de>
Subject: Re: [PATCH v3] drm: Use USB controller's DMA mask when importing
 dmabufs
References: <20210223105842.27011-1-tzimmermann@suse.de>
 <s5hh7m2vqyd.wl-tiwai@suse.de>
In-Reply-To: <s5hh7m2vqyd.wl-tiwai@suse.de>

--aBDUZUy3Os2nqn1T3G46zfyCm6RwWSKu5
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi

Am 23.02.21 um 14:44 schrieb Takashi Iwai:
> On Tue, 23 Feb 2021 11:58:42 +0100,
> Thomas Zimmermann wrote:
>>
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
>=20
> Aside from the discussion whether this "workaround" is needed, the use
> of udev->bus->controller here looks a bit suspicious.  As the old USB
> code (before the commit 6eb0233ec2d0) indicated, it was rather
> usb->bus->sysdev that was used for the DMA mask, and it's also the one
> most of USB core code refers to.  A similar question came up while
> fixing the same kind of bug in the media subsystem, and we concluded
> that bus->sysdev is a better choice.

Good to hear that we're not the only ones affected by this. Wrt the=20
original code, using sysdev makes even more sense.

Best regards
Thomas

>=20
>=20
> Takashi
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


--aBDUZUy3Os2nqn1T3G46zfyCm6RwWSKu5--

--7aYl7icMQv17jkilLUeIhhp6ISik7DLkM
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEExndm/fpuMUdwYFFolh/E3EQov+AFAmA1C88FAwAAAAAACgkQlh/E3EQov+A4
dw/+L9E6MX/XrBQejK7EYIXa9mF5Y/ztlbwg7a7+SRVQ3AJQHDwjp5qCRLoiEynXAj2mnWsm5pxZ
TbumBTzd33HogxAUW04nS1K9bN0uFpxtTe9J76zf/7T/Z0TkL2xSPL4h/C+W4AJNvJfVbCvOVhX7
HkpV1dyafsbv6LGOAQ7D3ryjgmXNrKzd/juoCdesBe0WQ1ZZGb13ZBM7V67Dt72Qr3o9FgkOTlXB
eSspr6YMaT2WUoruhQZE+H7gG3PgU0cKEhPaUvhuPzagppk9VypI5Vp6eqa1W9ln5WTJMxx+GiC7
fIawP4Gg+GeTbIoq6BzohpNCi+Wt7d0fz9k6k6nNKL73fn3PlC3jdkSA28jGjNCeP3RO17SYJAEl
V+/S/SNV8ZZXM6Oo8QAZZCUUwOL/ENrR9iieZuIG46N2MtXTyRB7ntXfrzxLT6H59cs64RiWA+IV
8Nj8JIxqKHZMN0+fI29nNoiLg8xfSO/oN81hHvhNVAspjCb7j5Ab/UuyvM/TW0GJGW7LP6CV0gjW
iJS4y2RyYcF3nR3aFT9ciW5ke52v/YR1gpdzZ7CCQa6d4EDmHMv9UliAOjzJL1bzna4HoT7w0FRW
NUWah5DaNDv1cFy892bK2u1KMeATsyI09yqmMQk86ewxCQbzdQX6xIS6n5W6wgOYbUE8g+aqHyaU
ns4=
=66OK
-----END PGP SIGNATURE-----

--7aYl7icMQv17jkilLUeIhhp6ISik7DLkM--
