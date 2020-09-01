Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B376259E4B
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 20:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgIASnD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 14:43:03 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:45336 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbgIASnC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Sep 2020 14:43:02 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 21B441C0B9B; Tue,  1 Sep 2020 20:43:00 +0200 (CEST)
Date:   Tue, 1 Sep 2020 20:42:58 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Evgeny Novikov <novikov@ispras.ru>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 047/125] media: davinci: vpif_capture: fix potential
 double free
Message-ID: <20200901183912.GA5295@duo.ucw.cz>
References: <20200901150934.576210879@linuxfoundation.org>
 <20200901150936.857115610@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="bCsyhTFzCvuiizWE"
Content-Disposition: inline
In-Reply-To: <20200901150936.857115610@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--bCsyhTFzCvuiizWE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit 602649eadaa0c977e362e641f51ec306bc1d365d ]
>=20
> In case of errors vpif_probe_complete() releases memory for vpif_obj.sd
> and unregisters the V4L2 device. But then this is done again by
> vpif_probe() itself. The patch removes the cleaning from
> vpif_probe_complete().

> Signed-off-by: Evgeny Novikov <novikov@ispras.ru>
> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/media/platform/davinci/vpif_capture.c | 2 --
>  1 file changed, 2 deletions(-)
>=20
> diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/medi=
a/platform/davinci/vpif_capture.c
> index a96f53ce80886..cf1d11e6dd8c4 100644
> --- a/drivers/media/platform/davinci/vpif_capture.c
> +++ b/drivers/media/platform/davinci/vpif_capture.c
> @@ -1489,8 +1489,6 @@ probe_out:
>  		/* Unregister video device */
>  		video_unregister_device(&ch->video_dev);
>  	}
> -	kfree(vpif_obj.sd);
> -	v4l2_device_unregister(&vpif_obj.v4l2_dev);
> =20
>  	return err;
>  }

This one is wrong. Unlike mainline, 4.19 does check return value of
vpif_probe_complete(), and thus it will lead to memory leak in 4.19.

Furthermore, I believe mainline still has a problems after this
patch. There is sync and async path where vpif_probe_complete(), and
while this fixes the sync path in mainline, I believe it will cause
memory leak on the async path.

Best regards,
									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--bCsyhTFzCvuiizWE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX06WMgAKCRAw5/Bqldv6
8oVYAJ0bhGBctKpJkKysPtiS8fIF7oACrwCgp0ZfdNdUxd0xmdcm83RhLUXGHk4=
=Cn3J
-----END PGP SIGNATURE-----

--bCsyhTFzCvuiizWE--
