Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFEA5324B9D
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 09:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233603AbhBYH6B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 02:58:01 -0500
Received: from mx2.suse.de ([195.135.220.15]:38030 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233018AbhBYH6A (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Feb 2021 02:58:00 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 23591B08C;
        Thu, 25 Feb 2021 07:57:18 +0000 (UTC)
Subject: Re: [PATCH v4] drm: Use USB controller's DMA mask when importing
 dmabufs
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     airlied@linux.ie, gregkh@linuxfoundation.org,
        Christoph Hellwig <hch@lst.de>, hdegoede@redhat.com,
        dri-devel@lists.freedesktop.org, stable@vger.kernel.org,
        sean@poorly.run, christian.koenig@amd.com
References: <20210224092304.29932-1-tzimmermann@suse.de>
 <20210224152153.GA1307460@rowland.harvard.edu>
From:   Thomas Zimmermann <tzimmermann@suse.de>
Message-ID: <b44307cf-25f9-acd0-eb35-92e8716205de@suse.de>
Date:   Thu, 25 Feb 2021 08:57:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210224152153.GA1307460@rowland.harvard.edu>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="vjnhpo50sTL5wnAPxWRkNpywRp0PNO5oy"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vjnhpo50sTL5wnAPxWRkNpywRp0PNO5oy
Content-Type: multipart/mixed; boundary="wxHLQCOJvWeAOKLrtkkef0y1hUwdZR2oz";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: airlied@linux.ie, gregkh@linuxfoundation.org,
 Christoph Hellwig <hch@lst.de>, hdegoede@redhat.com,
 dri-devel@lists.freedesktop.org, stable@vger.kernel.org, sean@poorly.run,
 christian.koenig@amd.com
Message-ID: <b44307cf-25f9-acd0-eb35-92e8716205de@suse.de>
Subject: Re: [PATCH v4] drm: Use USB controller's DMA mask when importing
 dmabufs
References: <20210224092304.29932-1-tzimmermann@suse.de>
 <20210224152153.GA1307460@rowland.harvard.edu>
In-Reply-To: <20210224152153.GA1307460@rowland.harvard.edu>

--wxHLQCOJvWeAOKLrtkkef0y1hUwdZR2oz
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi

Am 24.02.21 um 16:21 schrieb Alan Stern:
> On Wed, Feb 24, 2021 at 10:23:04AM +0100, Thomas Zimmermann wrote:
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
>> Cc: Christoph Hellwig <hch@lst.de>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: <stable@vger.kernel.org> # v5.10+
>> ---
>=20
>> +struct drm_gem_object *drm_gem_prime_import_usb(struct drm_device *de=
v,
>> +						struct dma_buf *dma_buf)
>> +{
>> +	struct usb_device *udev;
>> +	struct device *dmadev;
>> +	struct drm_gem_object *obj;
>> +
>> +	if (!dev_is_usb(dev->dev))
>> +		return ERR_PTR(-ENODEV);
>> +	udev =3D interface_to_usbdev(to_usb_interface(dev->dev));
>> +
>> +	dmadev =3D usb_get_dma_device(udev);
>=20
> You can do it this way if you want, but I think usb_get_dma_device woul=
d
> be easier to use if its argument was a pointer to struct usb_interface
> or (even better) a pointer to a usb_interface's embedded struct device.=

> Then you wouldn't need to compute udev, and the same would be true for
> other callers.

It seemed natural to me to use usb_device, because it contains the bus=20
pointer. But maybe a little wrapper for usb_interface in the header file =

makes things easier to read. I'll wait a bit for other reviews to come in=
=2E

Best regards
Thomas

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


--wxHLQCOJvWeAOKLrtkkef0y1hUwdZR2oz--

--vjnhpo50sTL5wnAPxWRkNpywRp0PNO5oy
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEExndm/fpuMUdwYFFolh/E3EQov+AFAmA3WFoFAwAAAAAACgkQlh/E3EQov+AW
rA//d9s3mcmUe+mJ1042oCb91xDD87WYaCvBv12WReWd6ewdidi+SQJtOI+MqIiv41aediIW8vVo
VG0hEi8Et0jsQ8nFdgNX1JWBYd/j9thlNznfzozbGI+GOyk+Ub32OU5wzDRZahJx6FVcSOEGLx7f
Jula2SoIlnwjJ1k/uGAuo227Z5nkB7bPCIARolj/ZFlVjGTCYKcSPW4y8a8cyrI3Nu9ApnZgtr90
6tLT7Wm+Pfe7QPq6NRk7EIz0msofRFNQUlcAxUfNqHn6JVBFaInl+DQ7PXd+nddvK4Prp4TaxlaU
sYliW525X87Da8qzSn8cVkDC05EophjOiU1LtP9royIBeLvLMGhuCRRl49WMp6W3RWMCKjvQ3w2M
idbU4h9FmoCvJqE0SJykZ4KazfneifBPxO/4DvcbWuQz2B/oFSKgGb8kbn+YXsV2UCPfBJ0kHsC/
wHD+LKMNrUlvY4D/vhw5VjHNnsjc1LUCg+fLiJeozLOFKZgwSWEcJv4EsqtUTMZioL2cQU5s358b
i12c4SzsjOj+o61WOH3+isUZ0sRKQun9d4vIsc1+PlE/2A3ZG8i4cpptD+6KVvxkCQa6dKX6V6Th
gUS0FCoWKLrEHJPFc9qc5hoP2DkN0VMWezrhB77LQ8dMsL+Bq1RMavBHitTH8/xMgU4j8x1m4Bxg
aVY=
=wmHp
-----END PGP SIGNATURE-----

--vjnhpo50sTL5wnAPxWRkNpywRp0PNO5oy--
