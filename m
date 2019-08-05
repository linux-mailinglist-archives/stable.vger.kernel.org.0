Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0914281F5D
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 16:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727349AbfHEOpK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 10:45:10 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57911 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728665AbfHEOpK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 10:45:10 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id 0B52780261; Mon,  5 Aug 2019 16:44:54 +0200 (CEST)
Date:   Mon, 5 Aug 2019 16:45:06 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 03/74] ARM: dts: rockchip: Make
 rk3288-veyron-mickeys emmc work again
Message-ID: <20190805144506.GB24265@amd>
References: <20190805124935.819068648@linuxfoundation.org>
 <20190805124936.105953796@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="kXdP64Ggrk/fb43R"
Content-Disposition: inline
In-Reply-To: <20190805124936.105953796@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--kXdP64Ggrk/fb43R
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon 2019-08-05 15:02:16, Greg Kroah-Hartman wrote:
> [ Upstream commit 99fa066710f75f18f4d9a5bc5f6a711968a581d5 ]
>=20
> When I try to boot rk3288-veyron-mickey I totally fail to make the
> eMMC work.  Specifically my logs (on Chrome OS 4.19):
>=20
>   mmc_host mmc1: card is non-removable.
>   mmc_host mmc1: Bus speed (slot 0) =3D 400000Hz (slot req 400000Hz, actu=
al 400000HZ div =3D 0)
>   mmc_host mmc1: Bus speed (slot 0) =3D 50000000Hz (slot req 52000000Hz, =
actual 50000000HZ div =3D 0)
>   mmc1: switch to bus width 8 failed
>   mmc1: switch to bus width 4 failed
>   mmc1: new high speed MMC card at address 0001
>   mmcblk1: mmc1:0001 HAG2e 14.7 GiB
>   mmcblk1boot0: mmc1:0001 HAG2e partition 1 4.00 MiB
>   mmcblk1boot1: mmc1:0001 HAG2e partition 2 4.00 MiB
>   mmcblk1rpmb: mmc1:0001 HAG2e partition 3 4.00 MiB, chardev (243:0)
>   mmc_host mmc1: Bus speed (slot 0) =3D 400000Hz (slot req 400000Hz, actu=
al 400000HZ div =3D 0)
>   mmc_host mmc1: Bus speed (slot 0) =3D 50000000Hz (slot req 52000000Hz, =
actual 50000000HZ div =3D 0)
>   mmc1: switch to bus width 8 failed
>   mmc1: switch to bus width 4 failed
>   mmc1: tried to HW reset card, got error -110
>   mmcblk1: error -110 requesting status
>   mmcblk1: recovery failed!
>   print_req_error: I/O error, dev mmcblk1, sector 0
>   ...
>=20
> When I remove the '/delete-property/mmc-hs200-1_8v' then everything is
> hunky dory.
>=20
> That line comes from the original submission of the mickey dts
> upstream, so presumably at the time the HS200 was failing and just
> enumerating things as a high speed device was fine.  ...or maybe it's
> just that some mickey devices work when enumerating at "high speed",
> just not mine?
>=20
> In any case, hs200 seems good now.  Let's turn it on.

Ok, so this was tested in v4.19; good. But AFAICT it is queued to
4.14, too... which may not be good idea unless it was tested there...?

Plus.. if this fixes stuff, that there are other configurations in the
dts that do not work. Should they be disabled or something?

									Pavel

> diff --git a/arch/arm/boot/dts/rk3288-veyron-mickey.dts b/arch/arm/boot/d=
ts/rk3288-veyron-mickey.dts
> index 1e0158acf895d..a593d0a998fc8 100644
> --- a/arch/arm/boot/dts/rk3288-veyron-mickey.dts
> +++ b/arch/arm/boot/dts/rk3288-veyron-mickey.dts
> @@ -124,10 +124,6 @@
>  	};
>  };
> =20
> -&emmc {
> -	/delete-property/mmc-hs200-1_8v;
> -};
> -
>  &i2c2 {
>  	status =3D "disabled";
>  };

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--kXdP64Ggrk/fb43R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl1IQPIACgkQMOfwapXb+vLxPQCfXakSV8rpEuhNxG7gnvWjaqft
kn8AoLz0I9V3Op8m+AzrbQWfudVACu65
=n59k
-----END PGP SIGNATURE-----

--kXdP64Ggrk/fb43R--
