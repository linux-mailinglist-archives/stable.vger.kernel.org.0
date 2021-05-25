Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0BEC390AA4
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 22:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232425AbhEYUsf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 16:48:35 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:44036 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbhEYUsf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 May 2021 16:48:35 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 6F3AA1C0B79; Tue, 25 May 2021 22:47:04 +0200 (CEST)
Date:   Tue, 25 May 2021 22:47:04 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ferenc Bakonyi <fero@drama.obuda.kando.hu>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Igor Matheus Andrade Torrente <igormtorrente@gmail.com>
Subject: Re: [PATCH 4.4 28/31] video: hgafb: fix potential NULL pointer
 dereference
Message-ID: <20210525204704.GA12631@duo.ucw.cz>
References: <20210524152322.919918360@linuxfoundation.org>
 <20210524152323.833888129@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
In-Reply-To: <20210524152323.833888129@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Igor Matheus Andrade Torrente <igormtorrente@gmail.com>
>=20
> commit dc13cac4862cc68ec74348a80b6942532b7735fa upstream.
>=20
> The return of ioremap if not checked, and can lead to a NULL to be
> assigned to hga_vram. Potentially leading to a NULL pointer
> dereference.
>=20
> The fix adds code to deal with this case in the error label and
> changes how the hgafb_probe handles the return of hga_card_detect.

This will break hgafb completely, right? And crash system without hga
card as a bonus.

> +++ b/drivers/video/fbdev/hgafb.c
> @@ -285,6 +285,8 @@ static int hga_card_detect(void)
>  	hga_vram_len  =3D 0x08000;
> =20
>  	hga_vram =3D ioremap(0xb0000, hga_vram_len);
> +	if (!hga_vram)
> +		return -ENOMEM;
> =20
>  	if (request_region(0x3b0, 12, "hgafb"))
>  		release_io_ports =3D 1;
> @@ -344,13 +346,18 @@ static int hga_card_detect(void)
>  			hga_type_name =3D "Hercules";
>  			break;
>  	}
> -	return 1;
> +	return 0;

Ok, so calling convention is now "0 means detected".


> @@ -548,13 +555,11 @@ static struct fb_ops hgafb_ops =3D {
>  static int hgafb_probe(struct platform_device *pdev)
>  {
>  	struct fb_info *info;
> +	int ret;
=2E..
> +	ret =3D hga_card_detect();
> +	if (!ret)
> +		return ret;
> =20
>  	printk(KERN_INFO "hgafb: %s with %ldK of memory detected.\n",
>  		hga_type_name, hga_vram_len/1024);
>=20

If the card is detected, 0 is returned, !0 is true, and we abort
detection....

								Pavel
							=09
Signed-off-by: Pavel Machek <pavel@denx.de>

diff --git a/drivers/video/fbdev/hgafb.c b/drivers/video/fbdev/hgafb.c
index c35f217db53f..d6a95ea49c64 100644
--- a/drivers/video/fbdev/hgafb.c
+++ b/drivers/video/fbdev/hgafb.c
@@ -282,7 +282,7 @@ static int hga_card_detect(void)
 	void __iomem *p, *q;
 	unsigned short p_save, q_save;
=20
-	hga_vram_len  =3D 0x08000;
+	hga_vram_len =3D 0x08000;
=20
 	hga_vram =3D ioremap(0xb0000, hga_vram_len);
 	if (!hga_vram)
@@ -558,7 +558,7 @@ static int hgafb_probe(struct platform_device *pdev)
 	int ret;
=20
 	ret =3D hga_card_detect();
-	if (!ret)
+	if (ret)
 		return ret;
=20
 	printk(KERN_INFO "hgafb: %s with %ldK of memory detected.\n",


--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYK1iSAAKCRAw5/Bqldv6
8nLrAJ4wD/bAdGIucmpOt+V2+FL+SG/U9wCgsLb9HTpU2gUIz00oalDNs2LGGvc=
=YHM2
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
