Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA1314CE7C
	for <lists+stable@lfdr.de>; Wed, 29 Jan 2020 17:37:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbgA2Qha (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jan 2020 11:37:30 -0500
Received: from sender4-of-o53.zoho.com ([136.143.188.53]:21321 "EHLO
        sender4-of-o53.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726906AbgA2Qha (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jan 2020 11:37:30 -0500
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Jan 2020 11:37:29 EST
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1580314941;
        s=s; d=qubes-os.org; i=frederic.pierret@qubes-os.org;
        h=To:Cc:From:Subject:Message-ID:Date:MIME-Version:Content-Type;
        bh=K19QkB0oonfEXCaZIfhluO472UZCylwbShW7JECNrz4=;
        b=dhkjDT28WTgsQiHTSAFxGKgecfVFDRMtcygbHG5VvS2NRrseHlU4SAjdx441wML9
        lRQJMTHBCNZY9NkzRq85nR6O30PkD9ftQXt58Sym5Qn9ii+Zmp8tPKkbXtPWhGMXHfQ
        J96j7NstVXnSFIORDMFKE5UoXKvuMVvT0oPUaTz4=
Received: from [10.137.0.19] (185.246.211.176 [185.246.211.176]) by mx.zohomail.com
        with SMTPS id 1580314936696574.2486897165325; Wed, 29 Jan 2020 08:22:16 -0800 (PST)
To:     Ben Skeggs <bskeggs@redhat.com>
Cc:     nouveau@lists.freedesktop.org, stable@vger.kernel.org
From:   =?UTF-8?B?RnLDqWTDqXJpYyBQaWVycmV0?= 
        <frederic.pierret@qubes-os.org>
Subject: nv50_disp_chan_mthd: ensure mthd is not NULL
Message-ID: <8a82672e-1a8d-b08e-b387-11ffecd5ba07@qubes-os.org>
Date:   Wed, 29 Jan 2020 17:22:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="WtQVe9uAsSNEoXDlyAZi0KODmrWFpX0CC"
X-Zoho-Virus-Status: 1
X-ZohoMailClient: External
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--WtQVe9uAsSNEoXDlyAZi0KODmrWFpX0CC
Content-Type: multipart/mixed; boundary="7myXQXT16OI7eX115fyWfxDrwq34iJ4jY"

--7myXQXT16OI7eX115fyWfxDrwq34iJ4jY
Content-Type: multipart/mixed;
 boundary="------------96B7C175C78789148090E248"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------96B7C175C78789148090E248
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Dear Ben Skeggs,

Please find attached a patch solving a blocking issue I encountered:
https://bugzilla.kernel.org/show_bug.cgi?id=3D206299

Basically, running at least a RTX2080TI on Xen makes a bad mmio error
which causes having 'mthd' pointer to be NULL in 'channv50.c'. From the
code, it's assumed to be not NULL by accessing directly 'mthd->data[0]'
which is the reason of the kernel panic. I simply check if the pointer
is not NULL before continuing.

Best regards,

Fr=C3=A9d=C3=A9ric Pierret


--------------96B7C175C78789148090E248
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-nv50_disp_chan_mthd-ensure-mthd-is-not-NULL.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="0001-nv50_disp_chan_mthd-ensure-mthd-is-not-NULL.patch"

From: =3D?UTF-8?q?Fr=3DC3=3DA9d=3DC3=3DA9ric=3D20Pierret=3D20=3D28fepitre=
=3D29?=3D
 <frederic.pierret@qubes-os.org>
Date: Sun, 26 Jan 2020 23:24:33 +0100
Subject: [PATCH] nv50_disp_chan_mthd: ensure mthd is not NULL
MIME-Version: 1.0
Content-Type: text/plain; charset=3DUTF-8
Content-Transfer-Encoding: 8bit

Pointer to structure array is assumed not NULL by default. It has
the consequence to raise a kernel panic when it's not the case.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=3D206299
Signed-off-by: Fr=C3=A9d=C3=A9ric Pierret (fepitre) <frederic.pierret@qub=
es-os.org>
---
 drivers/gpu/drm/nouveau/nvkm/engine/disp/channv50.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/disp/channv50.c b/driver=
s/gpu/drm/nouveau/nvkm/engine/disp/channv50.c
index bcf32d92ee5a..50e3539f33d2 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/disp/channv50.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/disp/channv50.c
@@ -74,6 +74,8 @@ nv50_disp_chan_mthd(struct nv50_disp_chan *chan, int de=
bug)
=20
 	if (debug > subdev->debug)
 		return;
+	if (!mthd)
+		return;
=20
 	for (i =3D 0; (list =3D mthd->data[i].mthd) !=3D NULL; i++) {
 		u32 base =3D chan->head * mthd->addr;
--=20
2.21.0


--------------96B7C175C78789148090E248--

--7myXQXT16OI7eX115fyWfxDrwq34iJ4jY--

--WtQVe9uAsSNEoXDlyAZi0KODmrWFpX0CC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEn6ZLkvlecGvyjiymSEAQtc3FduIFAl4xsTMACgkQSEAQtc3F
duLH1g//YG5jYl0TjeQVx9BMrx5bLgOo/XTiajguTQwUBSHoJ/Q36zzKZr9D+VUx
+ihJ48G2koPaUTZWxWrARB7mCXU/LFPOzQ7LvokA8ZQ2MtVOjyGKJfxHBhQaBmZq
+R0RTS0rDi74NyVuCzkXEhgYm/uPoQsaVhy5fdbNF+GHrFODuAIsdBYeVfOalsSH
UtoNyYOA/ccfGfZJHT7XRZNOP3x1UfsfMinInbVrWCEmmQ+g1+pfN837cKf/fILb
5vPoVn7Lx0hZ7vdPduLMSTvdboddj7AhLREGkpS+szPj1HlNM4t/WVgKBR0YZrUf
k26xUVNtXNfK14hg3eb43E/63kBWJak+dVy01xhjsn/gCHBzUX4L/8MWoeRtA5zx
9g4r2BvEKwGiKyvoVtdRec0Mzu0Vf3LzFPo6/V1Pqceelhqh+nS6fWIoCuTEeFeL
NBGcIPyycIMpYhEHmQoGuJCou1T+RwtDFPGHOvjdiKNvbkt1QbpBlhrQ6uRVyG4I
tXG2sHJWsLCSboIUPf1pefxT+11LlYp9uU21Zy/vWQT6NsRXHwqTTv8zkrl6pOBd
j7hBKUCtW2q3UuShmXg85h9UDAJd8j45xwdv+CzlmVaENdhfFdWX3adepE3Sv09q
CsNDlnOtSa+UKdyP8UWoR8k0LKelQCT5X0HtRGVCxf4hccUR0Ro=
=X6Bt
-----END PGP SIGNATURE-----

--WtQVe9uAsSNEoXDlyAZi0KODmrWFpX0CC--
