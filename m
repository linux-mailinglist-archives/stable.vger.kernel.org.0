Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0F4261E25
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732392AbgIHTrf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:47:35 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:46044 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732210AbgIHTr2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Sep 2020 15:47:28 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 194181C0B87; Tue,  8 Sep 2020 21:47:24 +0200 (CEST)
Date:   Tue, 8 Sep 2020 21:47:23 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Marc Smith <msmith626@gmail.com>,
        Edwin Peer <edwin.peer@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 34/88] bnxt_en: fix HWRM error when querying VF
 temperature
Message-ID: <20200908194723.GB6758@duo.ucw.cz>
References: <20200908152221.082184905@linuxfoundation.org>
 <20200908152222.792503974@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="8P1HSweYDcXXzwPJ"
Content-Disposition: inline
In-Reply-To: <20200908152222.792503974@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--8P1HSweYDcXXzwPJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Firmware returns RESOURCE_ACCESS_DENIED for HWRM_TEMP_MONITORY_QUERY for
> VFs. This produces unpleasing error messages in the log when temp1_input
> is queried via the hwmon sysfs interface from a VF.
>=20
> The error is harmless and expected, so silence it and return unknown as
> the value. Since the device temperature is not particularly sensitive
> information, provide flexibility to change this policy in future by
> silencing the error rather than avoiding the HWRM call entirely for VFs.
>=20
> Fixes: cde49a42a9bb ("bnxt_en: Add hwmon sysfs support to read
> temperature")

Is this new interface described somewhere?

> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> @@ -6836,16 +6836,19 @@ static ssize_t bnxt_show_temp(struct device *dev,
=2E..
> -	return sprintf(buf, "%u\n", temp);
> +	if (len)
> +		return len;
> +
> +	return sprintf(buf, "unknown\n");
>  }

We normally just do return -EIO (or other error code) in such cases.

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--8P1HSweYDcXXzwPJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX1ffywAKCRAw5/Bqldv6
8sXIAJ9BSVZ2KXHsgjvUYGiaxLJKhy8r7ACfQV6tWW2ZhZfSs4Nji2Stw5c2MYM=
=fB9W
-----END PGP SIGNATURE-----

--8P1HSweYDcXXzwPJ--
