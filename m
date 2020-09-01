Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E51325A0C6
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 23:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbgIAVXB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 17:23:01 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:60240 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728411AbgIAVXB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Sep 2020 17:23:01 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id DA9581C0B9C; Tue,  1 Sep 2020 23:22:58 +0200 (CEST)
Date:   Tue, 1 Sep 2020 23:22:57 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        George Kennedy <george.kennedy@oracle.com>,
        syzbot+38a3699c7eaf165b97a6@syzkaller.appspotmail.com
Subject: Re: [PATCH 4.19 085/125] fbcon: prevent user font height or width
 change from causing potential out-of-bounds access
Message-ID: <20200901212257.GB17861@duo.ucw.cz>
References: <20200901150934.576210879@linuxfoundation.org>
 <20200901150938.740748818@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="neYutvxvOLaeuPCA"
Content-Disposition: inline
In-Reply-To: <20200901150938.740748818@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--neYutvxvOLaeuPCA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2020-09-01 17:10:40, Greg Kroah-Hartman wrote:
> From: George Kennedy <george.kennedy@oracle.com>
>=20
> commit 39b3cffb8cf3111738ea993e2757ab382253d86a upstream.
>=20
> Add a check to fbcon_resize() to ensure that a possible change to user fo=
nt
> height or user font width will not allow a font data out-of-bounds access.
> NOTE: must use original charcount in calculation as font charcount can
> change and cannot be used to determine the font data allocated size.


> +#define PITCH(w) (((w) + 7) >> 3)
> +#define CALC_FONTSZ(h, p, c) ((h) * (p) * (c)) /* size =3D height * pitc=
h * charcount */

Ok, so we validate data from user. Can this overflow? Should it be
inline function for readability?

>  static int fbcon_resize(struct vc_data *vc, unsigned int width,=20
>  			unsigned int height, unsigned int user)
>  {
> @@ -2161,6 +2164,24 @@ static int fbcon_resize(struct vc_data *
>  	struct fb_var_screeninfo var =3D info->var;
>  	int x_diff, y_diff, virt_w, virt_h, virt_fw, virt_fh;
> =20
> +	if (ops->p && ops->p->userfont && FNTSIZE(vc->vc_font.data)) {
> +		int size;
> +		int pitch =3D PITCH(vc->vc_font.width);

Should size be unsigned?

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--neYutvxvOLaeuPCA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX067sQAKCRAw5/Bqldv6
8rpXAJ9uTtvcvDYAN5dPEexRzRORaZsbIwCfcdojqJqhafOpZyAEAQC6CvNxom0=
=Hbwv
-----END PGP SIGNATURE-----

--neYutvxvOLaeuPCA--
