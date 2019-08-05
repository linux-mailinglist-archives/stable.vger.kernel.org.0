Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E523281F68
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 16:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728826AbfHEOr1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 10:47:27 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57979 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726508AbfHEOr0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 10:47:26 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id 3C5AE80311; Mon,  5 Aug 2019 16:47:12 +0200 (CEST)
Date:   Mon, 5 Aug 2019 16:47:24 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 04/74] ARM: dts: rockchip: Mark that the rk3288
 timer might stop in suspend
Message-ID: <20190805144723.GC24265@amd>
References: <20190805124935.819068648@linuxfoundation.org>
 <20190805124936.173376284@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="8X7/QrJGcKSMr1RN"
Content-Disposition: inline
In-Reply-To: <20190805124936.173376284@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--8X7/QrJGcKSMr1RN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon 2019-08-05 15:02:17, Greg Kroah-Hartman wrote:
> [ Upstream commit 8ef1ba39a9fa53d2205e633bc9b21840a275908e ]
>=20
> This is similar to commit e6186820a745 ("arm64: dts: rockchip: Arch
> counter doesn't tick in system suspend").  Specifically on the rk3288
> it can be seen that the timer stops ticking in suspend if we end up
> running through the "osc_disable" path in rk3288_slp_mode_set().  In
> that path the 24 MHz clock will turn off and the timer stops.
>=20
> To test this, I ran this on a Chrome OS filesystem:
>   before=3D$(date); \
>   suspend_stress_test -c1 --suspend_min=3D30 --suspend_max=3D31; \
>   echo ${before}; date
>=20
> ...and I found that unless I plug in a device that requests USB wakeup
> to be active that the two calls to "date" would show that fewer than
> 30 seconds passed.
>=20
> NOTE: deep suspend (where the 24 MHz clock gets disabled) isn't
> supported yet on upstream Linux so this was tested on a downstream
> kernel.

I guess this does no harm, but deep sleep is unlikely to be suppored
in the stable kernels, so ... is it good idea there?

Thanks,
								Pavel

> --- a/arch/arm/boot/dts/rk3288.dtsi
> +++ b/arch/arm/boot/dts/rk3288.dtsi
> @@ -227,6 +227,7 @@
>  			     <GIC_PPI 11 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_HIGH)>,
>  			     <GIC_PPI 10 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_HIGH)>;
>  		clock-frequency =3D <24000000>;
> +		arm,no-tick-in-suspend;
>  	};
> =20
>  	timer: timer@ff810000 {

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--8X7/QrJGcKSMr1RN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl1IQXsACgkQMOfwapXb+vIQFQCcDqoHomorKYueQyyNsOqXSktm
Q+QAn3UWCuZSg3hdCm/euN1HlYfzBlKT
=AyXM
-----END PGP SIGNATURE-----

--8X7/QrJGcKSMr1RN--
