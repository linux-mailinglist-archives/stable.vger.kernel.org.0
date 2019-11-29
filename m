Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1545310D47D
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 12:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbfK2LAO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Nov 2019 06:00:14 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:39124 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbfK2LAO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Nov 2019 06:00:14 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id D6B2D1C2447; Fri, 29 Nov 2019 12:00:11 +0100 (CET)
Date:   Fri, 29 Nov 2019 12:00:10 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 185/306] net: hns3: bugfix for buffer not free
 problem during resetting
Message-ID: <20191129110010.GA4313@amd>
References: <20191127203114.766709977@linuxfoundation.org>
 <20191127203128.798931840@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="2oS5YaxWCcQjTEyO"
Content-Disposition: inline
In-Reply-To: <20191127203128.798931840@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Huazhong Tan <tanhuazhong@huawei.com>
>=20
> [ Upstream commit 73b907a083b8a8c1c62cb494bc9fbe6ae086c460 ]
>=20
> When hns3_get_ring_config()/hns3_queue_to_ring()/
> hns3_get_vector_ring_chain() failed during resetting, the allocated
> memory has not been freed before these three functions return. So
> this patch adds error handler in these functions to fix it.

Correct me if I'm wrong, but... this introduces use-after-free:

> @@ -2592,6 +2592,16 @@ static int hns3_get_vector_ring_chain(struct hns3_=
enet_tqp_vector *tqp_vector,
>  	}
> =20
>  	return 0;
> +
> +err_free_chain:
> +	cur_chain =3D head->next;
> +	while (cur_chain) {
> +		chain =3D cur_chain->next;
> +		devm_kfree(&pdev->dev, chain);
> +		cur_chain =3D chain;
> +	}

Lets take two iterations:

> +		chain =3D cur_chain->next;
> +		devm_kfree(&pdev->dev, chain);
chain freed here.
> +		cur_chain =3D chain;

> +		chain =3D cur_chain->next;
chain->next accessed here, after free.
> +		devm_kfree(&pdev->dev, chain);
> +		cur_chain =3D chain;

Should it do devm_kfree(&pdev->dev, cur_chain); ?

Best regards,
									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--2oS5YaxWCcQjTEyO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl3g+joACgkQMOfwapXb+vKenQCfTrBeE4pjN7Dk60GFjHV55jJy
UOQAoKwtAbKijIuOZrZqMtJuB7wEO2t/
=lQXL
-----END PGP SIGNATURE-----

--2oS5YaxWCcQjTEyO--
