Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B3483903D9
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 16:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233687AbhEYOZ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 10:25:57 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:47318 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233618AbhEYOZ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 May 2021 10:25:56 -0400
X-Greylist: delayed 1466 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 May 2021 10:25:56 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=dZ7frPW5fj01Ft33s69bx86lJXEsnfOqSYuGUJQ6UHM=; b=SkyNQAttLXLQj2vmb5/XI9WPtH
        2ycyIrOMFgF8Vzr0KbBDGeBcPNCGxcLRnDipBbex822YUu3oGbpVIw/we4tunR89I9R16U94A8J95
        3ukdFbS425h/ebbU1lO2nfO08HpOE1NLbcCT7sKfxvqFQSIaf4FxMAp0g8TSx6zUzn8c=;
Received: from 94.196.90.140.threembb.co.uk ([94.196.90.140] helo=fitzroy.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <broonie@sirena.org.uk>)
        id 1llXb8-005kyR-TT; Tue, 25 May 2021 13:59:55 +0000
Received: by fitzroy.sirena.org.uk (Postfix, from userid 1000)
        id E5863D00386; Tue, 25 May 2021 15:00:28 +0100 (BST)
Date:   Tue, 25 May 2021 15:00:28 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        alsa-devel@alsa-project.org, patches@opensource.cirrus.com
Subject: Re: [PATCH AUTOSEL 5.12 32/63] ASoC: cs43130: handle errors in
 cs43130_probe() properly
Message-ID: <YK0C/HLiQtt/vyqV@sirena.org.uk>
References: <20210524144620.2497249-1-sashal@kernel.org>
 <20210524144620.2497249-32-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="RFaW+4Kl3/3n2UVF"
Content-Disposition: inline
In-Reply-To: <20210524144620.2497249-32-sashal@kernel.org>
X-Cookie: The wages of sin are unreported.
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--RFaW+4Kl3/3n2UVF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 24, 2021 at 10:45:49AM -0400, Sasha Levin wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>=20
> [ Upstream commit 2da441a6491d93eff8ffff523837fd621dc80389 ]
>=20
> cs43130_probe() does not do any valid error checking of things it
> initializes, OR what it does, it does not unwind properly if there are
> errors.

I don't have this commit and can't see any sign of it having been
submitted upstream.  Where is it being backported from?  The last
commit I can see in -next to this driver is
d2912cb15bdda8ba4a5dd73396ad62641af2f520 (treewide: Replace GPLv2
boilerplate/reference with SPDX - rule 500) from 2019.

>=20
> Fix this up by moving the sysfs files to an attribute group so the
> driver core will correctly add/remove them all at once and handle errors
> with them, and correctly check for creating a new workqueue and
> unwinding if that fails.
>=20
> Cc: Mark Brown <broonie@kernel.org>
> Link: https://lore.kernel.org/r/20210503115736.2104747-58-gregkh@linuxfou=
ndation.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  sound/soc/codecs/cs43130.c | 28 ++++++++++++++--------------
>  1 file changed, 14 insertions(+), 14 deletions(-)
>=20
> diff --git a/sound/soc/codecs/cs43130.c b/sound/soc/codecs/cs43130.c
> index c2b6f0ae6d57..80cd3ea0c157 100644
> --- a/sound/soc/codecs/cs43130.c
> +++ b/sound/soc/codecs/cs43130.c
> @@ -1735,6 +1735,14 @@ static DEVICE_ATTR(hpload_dc_r, 0444, cs43130_show=
_dc_r, NULL);
>  static DEVICE_ATTR(hpload_ac_l, 0444, cs43130_show_ac_l, NULL);
>  static DEVICE_ATTR(hpload_ac_r, 0444, cs43130_show_ac_r, NULL);
> =20
> +static struct attribute *hpload_attrs[] =3D {
> +	&dev_attr_hpload_dc_l.attr,
> +	&dev_attr_hpload_dc_r.attr,
> +	&dev_attr_hpload_ac_l.attr,
> +	&dev_attr_hpload_ac_r.attr,
> +};
> +ATTRIBUTE_GROUPS(hpload);
> +
>  static struct reg_sequence hp_en_cal_seq[] =3D {
>  	{CS43130_INT_MASK_4, CS43130_INT_MASK_ALL},
>  	{CS43130_HP_MEAS_LOAD_1, 0},
> @@ -2302,23 +2310,15 @@ static int cs43130_probe(struct snd_soc_component=
 *component)
> =20
>  	cs43130->hpload_done =3D false;
>  	if (cs43130->dc_meas) {
> -		ret =3D device_create_file(component->dev, &dev_attr_hpload_dc_l);
> -		if (ret < 0)
> -			return ret;
> -
> -		ret =3D device_create_file(component->dev, &dev_attr_hpload_dc_r);
> -		if (ret < 0)
> -			return ret;
> -
> -		ret =3D device_create_file(component->dev, &dev_attr_hpload_ac_l);
> -		if (ret < 0)
> -			return ret;
> -
> -		ret =3D device_create_file(component->dev, &dev_attr_hpload_ac_r);
> -		if (ret < 0)
> +		ret =3D sysfs_create_groups(&component->dev->kobj, hpload_groups);
> +		if (ret)
>  			return ret;
> =20
>  		cs43130->wq =3D create_singlethread_workqueue("cs43130_hp");
> +		if (!cs43130->wq) {
> +			sysfs_remove_groups(&component->dev->kobj, hpload_groups);
> +			return -ENOMEM;
> +		}
>  		INIT_WORK(&cs43130->work, cs43130_imp_meas);
>  	}
> =20
> --=20
> 2.30.2
>=20

--RFaW+4Kl3/3n2UVF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmCtAvwACgkQJNaLcl1U
h9CqVwf+JrlXxzH0ZWbyyEBQeBp7aL+qzVYCyuDTbkOPDbUhvhdz22j4/JhgNLy2
7R+fkJZwjDlymrKxLVvCtFNTS3dQvM+v5TpDGqRiprNlEZ87UuzhBK3aSfiEEx/w
qJ2vORFHPwDe8ROlNjU+qsVRMZ/keaBPLNOYDeePqSkLP4CWYaQuW9Ul7IEIX0w1
RW+87PQXjkRa8fh+7dC3nI2PS2QcCHg4czgFCcZbJ7ZGKLXSJycCla11pNRCENiP
OhiyY+oCUZIkNOOVUw2/6zHEdWNmguhq4qrXAXBK47UKiu4pn0kys32jLqagJYf7
FYhTW4u4GO/xqSnOZbMbOtdqubNuMQ==
=v17c
-----END PGP SIGNATURE-----

--RFaW+4Kl3/3n2UVF--
