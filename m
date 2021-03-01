Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFF3B3278F8
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 09:14:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232820AbhCAINC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 03:13:02 -0500
Received: from mx2.suse.de ([195.135.220.15]:50010 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232791AbhCAIMu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 03:12:50 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C6EBEAAC5;
        Mon,  1 Mar 2021 08:12:07 +0000 (UTC)
Subject: Re: [PATCH v5] drm: Use USB controller's DMA mask when importing
 dmabufs
To:     Pavel Machek <pavel@ucw.cz>, Daniel Vetter <daniel@ffwll.ch>
Cc:     airlied@linux.ie, gregkh@linuxfoundation.org,
        Christoph Hellwig <hch@lst.de>, hdegoede@redhat.com,
        stern@rowland.harvard.edu, dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>, stable@vger.kernel.org,
        sean@poorly.run, christian.koenig@amd.com
References: <20210226092648.4584-1-tzimmermann@suse.de>
 <YDkBuu0AhZy+C/Y/@phenom.ffwll.local> <20210226203312.GA3379@duo.ucw.cz>
From:   Thomas Zimmermann <tzimmermann@suse.de>
Message-ID: <1adb54b8-95dc-0abb-487d-4df8631f9620@suse.de>
Date:   Mon, 1 Mar 2021 09:12:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210226203312.GA3379@duo.ucw.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Cemqj0UT4Kw6RI6RCIC7JY3mfwGp3XkzT"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Cemqj0UT4Kw6RI6RCIC7JY3mfwGp3XkzT
Content-Type: multipart/mixed; boundary="IOGrfYGWofvwdV9AO5CURMPRmJs0eEhq6";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: Pavel Machek <pavel@ucw.cz>, Daniel Vetter <daniel@ffwll.ch>
Cc: airlied@linux.ie, gregkh@linuxfoundation.org,
 Christoph Hellwig <hch@lst.de>, hdegoede@redhat.com,
 stern@rowland.harvard.edu, dri-devel@lists.freedesktop.org,
 Daniel Vetter <daniel.vetter@ffwll.ch>, stable@vger.kernel.org,
 sean@poorly.run, christian.koenig@amd.com
Message-ID: <1adb54b8-95dc-0abb-487d-4df8631f9620@suse.de>
Subject: Re: [PATCH v5] drm: Use USB controller's DMA mask when importing
 dmabufs
References: <20210226092648.4584-1-tzimmermann@suse.de>
 <YDkBuu0AhZy+C/Y/@phenom.ffwll.local> <20210226203312.GA3379@duo.ucw.cz>
In-Reply-To: <20210226203312.GA3379@duo.ucw.cz>

--IOGrfYGWofvwdV9AO5CURMPRmJs0eEhq6
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi

Am 26.02.21 um 21:33 schrieb Pavel Machek:
> Hi!
>=20
>=20
>>> +	struct device *dmadev;
>>> +	struct drm_gem_object *obj;
>>> +
>>> +	if (!dev_is_usb(dev->dev))
>>> +		return ERR_PTR(-ENODEV);
>>> +
>>> +	dmadev =3D usb_intf_get_dma_device(to_usb_interface(dev->dev));
>>> +	if (drm_WARN_ONCE(dev, !dmadev, "buffer sharing not supported"))
>>> +		return ERR_PTR(-ENODEV);
>>> +
>>> +	obj =3D drm_gem_prime_import_dev(dev, dma_buf, dmadev);
>>> +
>>> +	put_device(dmadev);
>>
>> Just realized there's another can of worms here because dma_buf_attach=

>> does not refcount the struct device. But the dma_buf can easily outliv=
e
>> the underlying device, at least right now.
>>
>> We should probably require that devices get rid of all their mappings =
in
>> their hotunplug code.
>>
>> Ofc now that we pick some random other device struct this gets kinda
>> worse.
>>
>> Anyway, also just another pre-existing condition that we should worry
>> about here. It's all still a very bad hack.
>=20
> This is actually regression fix if I understand this correctly. Bug
> means udl is unusable, so that's kind of bad.
>=20
> Should we revert the original commit causing this while this get
> sorted out?

Better not. It's not easily revert-able, so other code might break in=20
the process.

I'd rather wait a bit for this to get ready, or meanwhile cherry-pick=20
the current patch.

Best regards
Thomas

>=20
> Best regards,
> 								Pavel
>=20
>=20
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel
>=20

--=20
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Maxfeldstr. 5, 90409 N=FCrnberg, Germany
(HRB 36809, AG N=FCrnberg)
Gesch=E4ftsf=FChrer: Felix Imend=F6rffer


--IOGrfYGWofvwdV9AO5CURMPRmJs0eEhq6--

--Cemqj0UT4Kw6RI6RCIC7JY3mfwGp3XkzT
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEExndm/fpuMUdwYFFolh/E3EQov+AFAmA8odYFAwAAAAAACgkQlh/E3EQov+D6
ERAAqhCtxyYv+hyefJI1xOml96qzh2ZcxiTVj/4J7CipQx76IxlnZY7vwRfI8iQcHy3dkRbWmyN0
3sXM80YWgQtW/9116mKgOGGVBqOseXmpsZSZcTrYRdZSxBLR1iJSMkOFxC2JwW3oUe1ilQ/Sh65t
qWNx3O33sLk8NPFKAOpzT2mPjplfBhs8hCt/VnfONaZdYecvKzeIZnUV8ah0AoiXLRI4qsU9m+ka
AdLhmFF1zD9Revy1IeH5N9S9TKp5vvaTbnVcNuhG9ahk4uapy12xEbalQwPz9zHqyNNcWmRuO6mK
6BnY2vUazEqVjM3/18RUNv3lAr1YuvSPfWj2SwPbY/YphwoEJao8WtaKsTObrkyRabSL+xntog1U
C0oj7FT2n0BDLt/uLiru147dtzS64hXneUaM8/BoF/HW9AqhjuMGlM8AnECjGCPiLlNKQnqhadas
F2Yqpbmvl5UTRiRi7eHwBzGTNArDrAmovQ34brJUNZ0tvLfdaNQ442dFxa6HH5lvNrTSPODm/JZo
L6F5nAIZnpFx6/S3ypYkOrcOB31xuE8SZ1ZhjHU2oGI9HYuVRPQWpWwIwth0pLvXjHLhlKMHZXWs
rg2OovBZohqpb0TtPWBXhXLdC0Dwy5qG6LKobTzkmFpuFS1zvtLCH9po0dP1ljZ5TdLf6IVuS85i
TpI=
=9WDm
-----END PGP SIGNATURE-----

--Cemqj0UT4Kw6RI6RCIC7JY3mfwGp3XkzT--
