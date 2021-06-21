Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 296ED3AE898
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 14:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbhFUMDa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 08:03:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbhFUMDa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Jun 2021 08:03:30 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30BFFC061574
        for <stable@vger.kernel.org>; Mon, 21 Jun 2021 05:01:16 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lvIc3-0003EE-8V; Mon, 21 Jun 2021 14:01:11 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:3569:1fb5:40be:61fc])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id CE8A1640588;
        Mon, 21 Jun 2021 12:01:09 +0000 (UTC)
Date:   Mon, 21 Jun 2021 14:01:09 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     linux-can@vger.kernel.org
Cc:     kernel@pengutronix.de,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        linux-stable <stable@vger.kernel.org>,
        syzbot <syzbot+355f8edb2ff45d5f95fa@syzkaller.appspotmail.com>,
        syzbot <syzbot+0f1827363a305f74996f@syzkaller.appspotmail.com>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>
Subject: Re: [PATCH] can: bcm/raw/isotp: use per module netdevice notifier
Message-ID: <20210621120109.2dxdjkkkf2s4m5u7@pengutronix.de>
References: <1624271915233178@kroah.com>
 <20210621115820.2894966-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="p5kw7nhn6cibdh6o"
Content-Disposition: inline
In-Reply-To: <20210621115820.2894966-1-mkl@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--p5kw7nhn6cibdh6o
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 21.06.2021 13:58:20, Marc Kleine-Budde wrote:
> From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
>=20
> commit 8d0caedb759683041d9db82069937525999ada53 upstream
>=20
> syzbot is reporting hung task at register_netdevice_notifier() [1] and
> unregister_netdevice_notifier() [2], for cleanup_net() might perform
> time consuming operations while CAN driver's raw/bcm/isotp modules are
> calling {register,unregister}_netdevice_notifier() on each socket.
>=20
> Change raw/bcm/isotp modules to call register_netdevice_notifier() from
> module's __init function and call unregister_netdevice_notifier() from
> module's __exit function, as with gw/j1939 modules are doing.
>=20
> Link: https://syzkaller.appspot.com/bug?id=3D391b9498827788b3cc6830226d4f=
f5be87107c30 [1]
> Link: https://syzkaller.appspot.com/bug?id=3D1724d278c83ca6e6df100a2e320c=
10d991cf2bce [2]
> Link: https://lore.kernel.org/r/54a5f451-05ed-f977-8534-79e7aa2bcc8f@i-lo=
ve.sakura.ne.jp
> Cc: linux-stable <stable@vger.kernel.org>
> Reported-by: syzbot <syzbot+355f8edb2ff45d5f95fa@syzkaller.appspotmail.co=
m>
> Reported-by: syzbot <syzbot+0f1827363a305f74996f@syzkaller.appspotmail.co=
m>
> Reviewed-by: Kirill Tkhai <ktkhai@virtuozzo.com>
> Tested-by: syzbot <syzbot+355f8edb2ff45d5f95fa@syzkaller.appspotmail.com>
> Tested-by: Oliver Hartkopp <socketcan@hartkopp.net>
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> [mkl: ported to v4.9.273]
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> ---
> Hello Greg,
>=20
> this is a backport of
>=20
> | 8d0caedb7596 can: bcm/raw/isotp: use per module netdevice notifier
>=20
> to v4.9.273. Please apply.

This also applies to v4.4.273.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--p5kw7nhn6cibdh6o
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmDQf4IACgkQqclaivrt
76mrBwgAtLzzmKsGnSFnhyKU72QHQhIdDfuTwIHltLkJUyTJEZlV2SUl9NBZMNC7
A/S6yZu3Tv8EH7y6TOqNOyV1AlL9Fynsx0sneEoy7VoOGXPAmcJqBRzjZdDBr+Y4
mdWheX4kt/DzSBr877qUDEwiyaEyVEbBB4mJJPFEIv0EICj09/lFrNcPWwg6e/hW
ttVQ4gIdaOsDIxW2IP2Ctcq6LUf0cliRHhInFHwUJ4PSPodI1uoi2FLkPpSulFqY
MIQrVUwcARHSYrBMCZYWqC9sR7ifOdDXgdELeNATbbp1SlY7WgFKfFssKlTn4T/F
WAefeJJmCXIdI1JDCpuamd2AAZja0w==
=zw/O
-----END PGP SIGNATURE-----

--p5kw7nhn6cibdh6o--
