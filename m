Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36CB9600F74
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 14:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230513AbiJQMq5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 08:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230482AbiJQMqn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 08:46:43 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82EE35D0F7;
        Mon, 17 Oct 2022 05:46:35 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id A2D9C1C0016; Mon, 17 Oct 2022 14:46:32 +0200 (CEST)
Date:   Mon, 17 Oct 2022 14:46:32 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        sunghwan jung <onenowy@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net
Subject: Re: [PATCH AUTOSEL 4.9 08/10] Revert "usb: storage: Add quirk for
 Samsung Fit flash"
Message-ID: <20221017124632.GA13227@duo.ucw.cz>
References: <20221013002802.1896096-1-sashal@kernel.org>
 <20221013002802.1896096-8-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="h31gzZEtNLTqOjlF"
Content-Disposition: inline
In-Reply-To: <20221013002802.1896096-8-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: sunghwan jung <onenowy@gmail.com>
>=20
> [ Upstream commit ad5dbfc123e6ffbbde194e2a4603323e09f741ee ]
>=20
> This reverts commit 86d92f5465958752481269348d474414dccb1552,
> which fix the timeout issue for "Samsung Fit Flash".
>=20
> But the commit affects not only "Samsung Fit Flash" but also other usb
> storages that use the same controller and causes severe performance
> regression.
>=20
>  # hdparm -t /dev/sda (without the quirk)
>  Timing buffered disk reads: 622 MB in  3.01 seconds =3D 206.66 MB/sec
>=20
>  # hdparm -t /dev/sda (with the quirk)
>  Timing buffered disk reads: 220 MB in  3.00 seconds =3D  73.32 MB/sec
>=20
> The commit author mentioned that "Issue was reproduced after device has
> bad block", so this quirk should be applied when we have the timeout
> issue with a device that has bad blocks.
>=20
> We revert the commit so that we apply this quirk by adding kernel
> paramters using a bootloader or other ways when we really need it,
> without the performance regression with devices that don't have the
> issue.

Re-introducing timeouts for users in middle of stable series... may
not be nice. Is there better fix in a follow up to this that was not
backported?

I see that buffered reads got faster, but that may not really mean
real performance gains...

Best regards,
								Pavel

>  drivers/usb/storage/unusual_devs.h | 6 ------
>  1 file changed, 6 deletions(-)
>=20
> diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unu=
sual_devs.h
> index 5a6ca1460711..8c51bb66f16f 100644
> --- a/drivers/usb/storage/unusual_devs.h
> +++ b/drivers/usb/storage/unusual_devs.h
> @@ -1294,12 +1294,6 @@ UNUSUAL_DEV( 0x090a, 0x1200, 0x0000, 0x9999,
>  		USB_SC_RBC, USB_PR_BULK, NULL,
>  		0 ),
> =20
> -UNUSUAL_DEV(0x090c, 0x1000, 0x1100, 0x1100,
> -		"Samsung",
> -		"Flash Drive FIT",
> -		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
> -		US_FL_MAX_SECTORS_64),
> -
>  /* aeb */
>  UNUSUAL_DEV( 0x090c, 0x1132, 0x0000, 0xffff,
>  		"Feiya",

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--h31gzZEtNLTqOjlF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY01OqAAKCRAw5/Bqldv6
8pcCAJ0c9IcuHaP/6hN6sPtSamTzyA6odACePR1wC4yMzQfBwOcHkfbEcIlHVfo=
=wr5P
-----END PGP SIGNATURE-----

--h31gzZEtNLTqOjlF--
