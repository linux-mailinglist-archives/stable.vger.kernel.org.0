Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77B7310B53B
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 19:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbfK0SIw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 13:08:52 -0500
Received: from mx2.suse.de ([195.135.220.15]:36238 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726576AbfK0SIv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 13:08:51 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CF48AAC48;
        Wed, 27 Nov 2019 18:08:48 +0000 (UTC)
Subject: Re: [PATCH v2 1/3] drm/mgag200: Extract device type from flags
To:     Emil Velikov <emil.l.velikov@gmail.com>
Cc:     john.p.donnelly@oracle.com, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        ML dri-devel <dri-devel@lists.freedesktop.org>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?Q?Jos=c3=a9_Roberto_de_Souza?= <jose.souza@intel.com>,
        Dave Airlie <airlied@redhat.com>,
        "# 3.13+" <stable@vger.kernel.org>,
        Emil Velikov <emil.velikov@collabora.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Gerd Hoffmann <kraxel@redhat.com>
References: <20191126101529.20356-1-tzimmermann@suse.de>
 <20191126101529.20356-2-tzimmermann@suse.de>
 <CACvgo52_L9RRCh6rKBCqkCuBwmH40NPnGQkCtqpR-T1feKC_5w@mail.gmail.com>
From:   Thomas Zimmermann <tzimmermann@suse.de>
Autocrypt: addr=tzimmermann@suse.de; keydata=
 mQENBFs50uABCADEHPidWt974CaxBVbrIBwqcq/WURinJ3+2WlIrKWspiP83vfZKaXhFYsdg
 XH47fDVbPPj+d6tQrw5lPQCyqjwrCPYnq3WlIBnGPJ4/jreTL6V+qfKRDlGLWFjZcsrPJGE0
 BeB5BbqP5erN1qylK9i3gPoQjXGhpBpQYwRrEyQyjuvk+Ev0K1Jc5tVDeJAuau3TGNgah4Yc
 hdHm3bkPjz9EErV85RwvImQ1dptvx6s7xzwXTgGAsaYZsL8WCwDaTuqFa1d1jjlaxg6+tZsB
 9GluwvIhSezPgnEmimZDkGnZRRSFiGP8yjqTjjWuf0bSj5rUnTGiyLyRZRNGcXmu6hjlABEB
 AAG0J1Rob21hcyBaaW1tZXJtYW5uIDx0emltbWVybWFubkBzdXNlLmRlPokBVAQTAQgAPhYh
 BHIX+6yM6c9jRKFo5WgNwR1TC3ojBQJbOdLgAhsDBQkDwmcABQsJCAcCBhUKCQgLAgQWAgMB
 Ah4BAheAAAoJEGgNwR1TC3ojR80H/jH+vYavwQ+TvO8ksXL9JQWc3IFSiGpuSVXLCdg62AmR
 irxW+qCwNncNQyb9rd30gzdectSkPWL3KSqEResBe24IbA5/jSkPweJasgXtfhuyoeCJ6PXo
 clQQGKIoFIAEv1s8l0ggPZswvCinegl1diyJXUXmdEJRTWYAtxn/atut1o6Giv6D2qmYbXN7
 mneMC5MzlLaJKUtoH7U/IjVw1sx2qtxAZGKVm4RZxPnMCp9E1MAr5t4dP5gJCIiqsdrVqI6i
 KupZstMxstPU//azmz7ZWWxT0JzgJqZSvPYx/SATeexTYBP47YFyri4jnsty2ErS91E6H8os
 Bv6pnSn7eAq5AQ0EWznS4AEIAMYmP4M/V+T5RY5at/g7rUdNsLhWv1APYrh9RQefODYHrNRH
 UE9eosYbT6XMryR9hT8XlGOYRwKWwiQBoWSDiTMo/Xi29jUnn4BXfI2px2DTXwc22LKtLAgT
 RjP+qbU63Y0xnQN29UGDbYgyyK51DW3H0If2a3JNsheAAK+Xc9baj0LGIc8T9uiEWHBnCH+R
 dhgATnWWGKdDegUR5BkDfDg5O/FISymJBHx2Dyoklv5g4BzkgqTqwmaYzsl8UxZKvbaxq0zb
 ehDda8lvhFXodNFMAgTLJlLuDYOGLK2AwbrS3Sp0AEbkpdJBb44qVlGm5bApZouHeJ/+n+7r
 12+lqdsAEQEAAYkBPAQYAQgAJhYhBHIX+6yM6c9jRKFo5WgNwR1TC3ojBQJbOdLgAhsMBQkD
 wmcAAAoJEGgNwR1TC3ojpfcIAInwP5OlcEKokTnHCiDTz4Ony4GnHRP2fXATQZCKxmu4AJY2
 h9ifw9Nf2TjCZ6AMvC3thAN0rFDj55N9l4s1CpaDo4J+0fkrHuyNacnT206CeJV1E7NYntxU
 n+LSiRrOdywn6erjxRi9EYTVLCHcDhBEjKmFZfg4AM4GZMWX1lg0+eHbd5oL1as28WvvI/uI
 aMyV8RbyXot1r/8QLlWldU3NrTF5p7TMU2y3ZH2mf5suSKHAMtbE4jKJ8ZHFOo3GhLgjVrBW
 HE9JXO08xKkgD+w6v83+nomsEuf6C6LYrqY/tsZvyEX6zN8CtirPdPWu/VXNRYAl/lat7lSI
 3H26qrE=
Message-ID: <98068118-8988-e31a-11c3-17a88059fbed@suse.de>
Date:   Wed, 27 Nov 2019 19:08:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <CACvgo52_L9RRCh6rKBCqkCuBwmH40NPnGQkCtqpR-T1feKC_5w@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Jy9XGZCL2t6RjWiBM7l6yflx9sUzs8PsI"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Jy9XGZCL2t6RjWiBM7l6yflx9sUzs8PsI
Content-Type: multipart/mixed; boundary="LtlJLLS30ZVmDIRiCTdDOoNn737q9WzRL";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: Emil Velikov <emil.l.velikov@gmail.com>
Cc: john.p.donnelly@oracle.com, David Airlie <airlied@linux.ie>,
 Daniel Vetter <daniel.vetter@ffwll.ch>,
 ML dri-devel <dri-devel@lists.freedesktop.org>,
 Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
 Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
 =?UTF-8?Q?Jos=c3=a9_Roberto_de_Souza?= <jose.souza@intel.com>,
 Dave Airlie <airlied@redhat.com>, "# 3.13+" <stable@vger.kernel.org>,
 Emil Velikov <emil.velikov@collabora.com>, Sam Ravnborg <sam@ravnborg.org>,
 Gerd Hoffmann <kraxel@redhat.com>
Message-ID: <98068118-8988-e31a-11c3-17a88059fbed@suse.de>
Subject: Re: [PATCH v2 1/3] drm/mgag200: Extract device type from flags
References: <20191126101529.20356-1-tzimmermann@suse.de>
 <20191126101529.20356-2-tzimmermann@suse.de>
 <CACvgo52_L9RRCh6rKBCqkCuBwmH40NPnGQkCtqpR-T1feKC_5w@mail.gmail.com>
In-Reply-To: <CACvgo52_L9RRCh6rKBCqkCuBwmH40NPnGQkCtqpR-T1feKC_5w@mail.gmail.com>

--LtlJLLS30ZVmDIRiCTdDOoNn737q9WzRL
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi Emil

Am 27.11.19 um 17:29 schrieb Emil Velikov:
> Hi Thomas,
>=20
> On Tue, 26 Nov 2019 at 10:15, Thomas Zimmermann <tzimmermann@suse.de> w=
rote:
>>
>> Adds a conversion function that extracts the device type from the
>> PCI id-table flags. Allows for storing additional information in the
>> other flag bits.
>>
>> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
>> Fixes: 81da87f63a1e ("drm: Replace drm_gem_vram_push_to_system() with =
kunmap + unpin")
>=20
> Are you sure the fixes tag is correct? Neither the commit summary nor
> the patch itself seems related to the changes below.

Yes, it's correct. It's part of a patch series [1][2][3] that fixes the b=
ug.

Best regards
Thomas

[1]
https://cgit.freedesktop.org/drm/drm-tip/commit/?id=3D3a8a5aba142a44eaeba=
0cb0ec1b4a8f177b5e59a
[2]
https://cgit.freedesktop.org/drm/drm-tip/commit/?id=3Dd6d437d97d54c85a1a9=
3967b2745e31dff03365a
[3]
https://cgit.freedesktop.org/drm/drm-tip/commit/?id=3D1591fadf857cdbaf2ba=
a55e421af99a61354713c

>=20
> HTH
> Emil
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


--LtlJLLS30ZVmDIRiCTdDOoNn737q9WzRL--

--Jy9XGZCL2t6RjWiBM7l6yflx9sUzs8PsI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEchf7rIzpz2NEoWjlaA3BHVMLeiMFAl3eu6wACgkQaA3BHVML
eiMX4AgAwYxbJSxcPPPQLmJcqufTvGJLKpwqRsj8QsgokxBtmZWMxZHYTFOS0zdN
zVXwS4cw5iPx8Hs7gToCfZvvLUrBdlYCdvG1ojmz29Secg3sNyIa5FGR9ZOII4Zh
KU+bjkU27LRMQZFHOT+lMkUTF4zQPptsQ9GMwAFvRf3s+q0+HA3IrXd/xBe+sm+G
cHKc71IpOeP2GYRRj3C1Cgwu7L9ZdiSpC5M+EcadAZQohUh4V0Iqj3UnG+pDGUw0
iq0OZsWiwusO9H9btut8YE0gxlptj4oW+k//HoOfDeErSf/d8/IdD9AwKj42pUqy
h/NjyZInf1qnNks3q2sph6i4PGNxBg==
=r5l2
-----END PGP SIGNATURE-----

--Jy9XGZCL2t6RjWiBM7l6yflx9sUzs8PsI--
