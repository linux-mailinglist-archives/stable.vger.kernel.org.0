Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F15FF256761
	for <lists+stable@lfdr.de>; Sat, 29 Aug 2020 14:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbgH2MKY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Aug 2020 08:10:24 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:55288 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726876AbgH2MKX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Aug 2020 08:10:23 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id ABEEE1C0B82; Sat, 29 Aug 2020 14:10:20 +0200 (CEST)
Date:   Sat, 29 Aug 2020 14:10:20 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jia-Ju Bai <baijiaju@tsinghua.edu.cn>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.19 08/38] media: pci: ttpci: av7110: fix
 possible buffer overflow caused by bad DMA value in debiirq()
Message-ID: <20200829121020.GA20944@duo.ucw.cz>
References: <20200821161807.348600-1-sashal@kernel.org>
 <20200821161807.348600-8-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Content-Disposition: inline
In-Reply-To: <20200821161807.348600-8-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> The value av7110->debi_virt is stored in DMA memory, and it is assigned
> to data, and thus data[0] can be modified at any time by malicious
> hardware. In this case, "if (data[0] < 2)" can be passed, but then
> data[0] can be changed into a large number, which may cause buffer
> overflow when the code "av7110->ci_slot[data[0]]" is used.
>=20
> To fix this possible bug, data[0] is assigned to a local variable, which
> replaces the use of data[0].

I'm pretty sure hardware capable of manipulating memory can work
around any such checks, but...

> +++ b/drivers/media/pci/ttpci/av7110.c
> @@ -424,14 +424,15 @@ static void debiirq(unsigned long cookie)
>  	case DATA_CI_GET:
>  	{
>  		u8 *data =3D av7110->debi_virt;
> +		u8 data_0 =3D data[0];
> =20
> -		if ((data[0] < 2) && data[2] =3D=3D 0xff) {
> +		if (data_0 < 2 && data[2] =3D=3D 0xff) {
>  			int flags =3D 0;
>  			if (data[5] > 0)
>  				flags |=3D CA_CI_MODULE_PRESENT;
>  			if (data[5] > 5)
>  				flags |=3D CA_CI_MODULE_READY;
> -			av7110->ci_slot[data[0]].flags =3D flags;
> +			av7110->ci_slot[data_0].flags =3D flags;

This does not even do what it says. Compiler is still free to access
data[0] multiple times. It needs READ_ONCE() to be effective.

Best regards,
								Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX0pFrAAKCRAw5/Bqldv6
8voQAJ9ExNyygKhg/hCWcFdC6iANTre5iQCdFZfPDfYl6rhOxjgz439HbYmQxIc=
=J6Tm
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
