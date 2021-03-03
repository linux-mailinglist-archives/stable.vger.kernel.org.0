Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94F0332BC58
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 22:53:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447273AbhCCNsg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 08:48:36 -0500
Received: from mx2.suse.de ([195.135.220.15]:40774 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1380254AbhCCN33 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Mar 2021 08:29:29 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 819CEADFB;
        Wed,  3 Mar 2021 13:27:34 +0000 (UTC)
Subject: Re: [PATCH v7] drm: Use USB controller's DMA mask when importing
 dmabufs
To:     =?UTF-8?Q?Noralf_Tr=c3=b8nnes?= <noralf@tronnes.org>,
        daniel@ffwll.ch, airlied@linux.ie,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        sumit.semwal@linaro.org, christian.koenig@amd.com,
        gregkh@linuxfoundation.org, hdegoede@redhat.com, sean@poorly.run,
        stern@rowland.harvard.edu, dan.carpenter@oracle.com
Cc:     dri-devel@lists.freedesktop.org, Pavel Machek <pavel@ucw.cz>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org
References: <20210303084512.25635-1-tzimmermann@suse.de>
 <f1271ed4-1bb1-0fe6-a5b1-db9dbae575fe@tronnes.org>
From:   Thomas Zimmermann <tzimmermann@suse.de>
Message-ID: <6689d8d4-2686-e16e-339a-6d95f6e98dab@suse.de>
Date:   Wed, 3 Mar 2021 14:27:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <f1271ed4-1bb1-0fe6-a5b1-db9dbae575fe@tronnes.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="tPhfvKexJnvRiAH5JX8sqPwoimgjFXJNI"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tPhfvKexJnvRiAH5JX8sqPwoimgjFXJNI
Content-Type: multipart/mixed; boundary="Lm8xDg2QwoR53diXg0OuBWd8AcHTPCTwp";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: =?UTF-8?Q?Noralf_Tr=c3=b8nnes?= <noralf@tronnes.org>, daniel@ffwll.ch,
 airlied@linux.ie, maarten.lankhorst@linux.intel.com, mripard@kernel.org,
 sumit.semwal@linaro.org, christian.koenig@amd.com,
 gregkh@linuxfoundation.org, hdegoede@redhat.com, sean@poorly.run,
 stern@rowland.harvard.edu, dan.carpenter@oracle.com
Cc: dri-devel@lists.freedesktop.org, Pavel Machek <pavel@ucw.cz>,
 Daniel Vetter <daniel.vetter@ffwll.ch>, Christoph Hellwig <hch@lst.de>,
 stable@vger.kernel.org
Message-ID: <6689d8d4-2686-e16e-339a-6d95f6e98dab@suse.de>
Subject: Re: [PATCH v7] drm: Use USB controller's DMA mask when importing
 dmabufs
References: <20210303084512.25635-1-tzimmermann@suse.de>
 <f1271ed4-1bb1-0fe6-a5b1-db9dbae575fe@tronnes.org>
In-Reply-To: <f1271ed4-1bb1-0fe6-a5b1-db9dbae575fe@tronnes.org>

--Lm8xDg2QwoR53diXg0OuBWd8AcHTPCTwp
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi,

thanks for reviewing. This will be fixed in the next iteration.

Best regards
Thomas

Am 03.03.21 um 11:58 schrieb Noralf Tr=C3=B8nnes:
>=20
>=20
> Den 03.03.2021 09.45, skrev Thomas Zimmermann:
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
>=20
> This doesn't seem to be the case anymore.
>=20
>> Tested by joining/mirroring displays of udl and radeon un der Gnome/X1=
1.
>=20
> s/un der/under/
>=20
>>
>> v7:
>> 	* fix use-before-init bug in gm12u320 (Dan)
>> v6:
>> 	* implement workaround in DRM drivers and hold reference to
>> 	  DMA device while USB device is in use
>> 	* remove dev_is_usb() (Greg)
>> 	* collapse USB helper into usb_intf_get_dma_device() (Alan)
>> 	* integrate Daniel's TODO statement (Daniel)
>> 	* fix typos (Greg)
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
>> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Acked-by: Christian K=C3=B6nig <christian.koenig@amd.com>
>> Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
>> Cc: Christoph Hellwig <hch@lst.de>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: <stable@vger.kernel.org> # v5.10+
>> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
>> ---
>>   Documentation/gpu/todo.rst      | 21 +++++++++++++++++++++
>>   drivers/gpu/drm/tiny/gm12u320.c | 28 ++++++++++++++++++++++++++--
>>   drivers/gpu/drm/udl/udl_drv.c   | 17 +++++++++++++++++
>>   drivers/gpu/drm/udl/udl_drv.h   |  1 +
>>   drivers/gpu/drm/udl/udl_main.c  |  9 +++++++++
>>   drivers/usb/core/usb.c          | 32 +++++++++++++++++++++++++++++++=
+
>>   include/linux/usb.h             |  2 ++
>>   7 files changed, 108 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/tiny/gm12u320.c b/drivers/gpu/drm/tiny/gm=
12u320.c
>> index 0b4f4f2af1ef..4fe372f43cf5 100644
>> --- a/drivers/gpu/drm/tiny/gm12u320.c
>> +++ b/drivers/gpu/drm/tiny/gm12u320.c
>=20
> [...]
>=20
>> @@ -638,12 +656,15 @@ static int gm12u320_usb_probe(struct usb_interfa=
ce *interface,
>>   				      struct gm12u320_device, dev);
>>   	if (IS_ERR(gm12u320))
>>   		return PTR_ERR(gm12u320);
>> +	dev =3D &gm12u320->dev;
>> +
>> +	gm12u320->dmadev =3D usb_intf_get_dma_device(to_usb_interface(dev->d=
ev));
>> +	if (!gm12u320->dmadev)
>> +		drm_warn(dev, "buffer sharing not supported"); /* not an error */
>>  =20
>=20
> When implementing this in my own driver I discovered that this device
> ref will leak if probing fails after this.
>=20
> I've done it like this:
>=20
> 	gdrm->dmadev =3D usb_intf_get_dma_device(intf);
> 	if (!gdrm->dmadev)
> 		dev_warn(dev, "buffer sharing not supported");
>=20
> 	ret =3D drm_dev_register(drm, 0);
> 	if (ret) {
> 		put_device(gdrm->dmadev);
> 		return ret;
> 	}
>=20
> An even better solution would be to have a devm_ version of the functio=
n.
>=20
> Noralf.
>=20
>>   	INIT_DELAYED_WORK(&gm12u320->fb_update.work, gm12u320_fb_update_wor=
k);
>>   	mutex_init(&gm12u320->fb_update.lock);
>>  =20
>> -	dev =3D &gm12u320->dev;
>> -
>>   	ret =3D drmm_mode_config_init(dev);
>>   	if (ret)
>>   		return ret;

--=20
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Maxfeldstr. 5, 90409 N=C3=BCrnberg, Germany
(HRB 36809, AG N=C3=BCrnberg)
Gesch=C3=A4ftsf=C3=BChrer: Felix Imend=C3=B6rffer


--Lm8xDg2QwoR53diXg0OuBWd8AcHTPCTwp--

--tPhfvKexJnvRiAH5JX8sqPwoimgjFXJNI
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEExndm/fpuMUdwYFFolh/E3EQov+AFAmA/jsQFAwAAAAAACgkQlh/E3EQov+D3
6g//ScWxI4jFAVOLrAfbD69U7bqfp5ypQKG3g4OUwWA7lBUvDlonQyZBbiyUHvBr9BcNFETlhZe+
8LWEZv1vySBAaZz8yWNkbon+HfJAWREkgGAzWbMVhpbJ/n5cNiVtW6Z1V9ARE515tiTyDXC/T8w0
Z2NvT/TqUpmFa4bwiRGPGlOZDMcj9uSjkBDsOidCJ7zptOKtNbfPaJVarf/n5ZqzQUZuvlUjcYCW
Ww8IiToiAYG8C56q0/274Yu1X0VG39teeYmLss5XEaKBCt1Lfb/UM5eRLQX/BCs4ct39/nQdU75x
xA6SmwKRr7MwE5HJHL9md8QzbqAaI5Khdl/6sHREQFNQzyQbRCgj4lsCo9/K6EGa1OjBJotYoQLp
UE4IwlHfFEkujJA0O3gbePO/dyEJruCvD3m65rtuhBzc5vaA6aL/gQ8mIeWxphGFEcyMawPnnrQE
/KV3MeXc3bkayxYMPKLXBwvGyYS+3mI6KcBIohlyrr2Rbvjo9sfHOzyfyWv5LTtn9Zp7HKimPr8O
rm2vLnhoueyhLzICW5RBja5mBd4ciMEL44jFcBR6txYFOkE/OC9HWPmZIdB4F84mV/PrMcdtcxbC
2581vK8OYlUApem7PL9t08gZdjQYy+iqjMLznWva/OKWEM4T1ffrfqv35Y6u3Tw65iN5ZSTv3DdB
6sk=
=VqT9
-----END PGP SIGNATURE-----

--tPhfvKexJnvRiAH5JX8sqPwoimgjFXJNI--
