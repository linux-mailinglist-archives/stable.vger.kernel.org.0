Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE409227F2D
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 13:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726611AbgGULns (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 07:43:48 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:52838 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726266AbgGULnr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jul 2020 07:43:47 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 449911C0BE5; Tue, 21 Jul 2020 13:43:45 +0200 (CEST)
Date:   Tue, 21 Jul 2020 13:43:44 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Finley Xiao <finley.xiao@rock-chips.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH 4.19 123/133] thermal/drivers/cpufreq_cooling: Fix wrong
 frequency converted from power
Message-ID: <20200721114344.GC17778@duo.ucw.cz>
References: <20200720152803.732195882@linuxfoundation.org>
 <20200720152809.664822211@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="E13BgyNx05feLLmH"
Content-Disposition: inline
In-Reply-To: <20200720152809.664822211@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--E13BgyNx05feLLmH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon 2020-07-20 17:37:50, Greg Kroah-Hartman wrote:
> From: Finley Xiao <finley.xiao@rock-chips.com>
>=20
> commit 371a3bc79c11b707d7a1b7a2c938dc3cc042fffb upstream.
>=20
> The function cpu_power_to_freq is used to find a frequency and set the
> cooling device to consume at most the power to be converted. For example,
> if the power to be converted is 80mW, and the em table is as follow.
> struct em_cap_state table[] =3D {
> 	/* KHz     mW */
> 	{ 1008000, 36, 0 },
> 	{ 1200000, 49, 0 },
> 	{ 1296000, 59, 0 },
> 	{ 1416000, 72, 0 },
> 	{ 1512000, 86, 0 },
> };
> The target frequency should be 1416000KHz, not 1512000KHz.
>=20
> Fixes: 349d39dc5739 ("thermal: cpu_cooling: merge frequency and power tab=
les")

Wow, this is completely different from the upstream patch. There the
loops goes down, not up. The code does not match the changelog here.

> --- a/drivers/thermal/cpu_cooling.c
> +++ b/drivers/thermal/cpu_cooling.c
> @@ -278,11 +278,11 @@ static u32 cpu_power_to_freq(struct cpuf
>  	int i;
>  	struct freq_table *freq_table =3D cpufreq_cdev->freq_table;
> =20
> -	for (i =3D 1; i <=3D cpufreq_cdev->max_level; i++)
> -		if (power > freq_table[i].power)
> +	for (i =3D 0; i < cpufreq_cdev->max_level; i++)
> +		if (power >=3D freq_table[i].power)
>  			break;
> =20
> -	return freq_table[i - 1].frequency;
> +	return freq_table[i].frequency;
>  }


Something is very wrong here, if table is sorted like described in the
changelog, it will always break at i=3D=3D0 or i=3D=3D1... not working at a=
ll
in the old or the new version.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--E13BgyNx05feLLmH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXxbU8AAKCRAw5/Bqldv6
8vk4AJ9HCaDhsrK1riRQn2673sq+lLwEmgCdHWpcAQ+z1QB2Ypzh5Vji4BTCMsY=
=8j55
-----END PGP SIGNATURE-----

--E13BgyNx05feLLmH--
