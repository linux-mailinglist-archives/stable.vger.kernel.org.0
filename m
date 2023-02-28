Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3210C6A61BA
	for <lists+stable@lfdr.de>; Tue, 28 Feb 2023 22:48:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbjB1Vs0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Feb 2023 16:48:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbjB1VsZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Feb 2023 16:48:25 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76E9F6EB7
        for <stable@vger.kernel.org>; Tue, 28 Feb 2023 13:48:24 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1pX7pc-00077U-EI; Tue, 28 Feb 2023 22:48:20 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pX7pb-000xOT-Lm; Tue, 28 Feb 2023 22:48:19 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pX7pb-0017Pe-0W; Tue, 28 Feb 2023 22:48:19 +0100
Date:   Tue, 28 Feb 2023 22:48:18 +0100
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Munehisa Kamata <kamatam@amazon.com>
Cc:     linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, thierry.reding@gmail.com,
        kernel@pengutronix.de, tobetter@gmail.com
Subject: Re: [PATCH] pwm: Zero-initialize the pwm_state passed to driver's
 .get_state()
Message-ID: <20230228214818.zkzmr6zuqica4bqa@pengutronix.de>
References: <20230228101558.b4dosk54jojfqkgi@pengutronix.de>
 <20230228194327.1237008-1-kamatam@amazon.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="hg5k6tzebwpumy4g"
Content-Disposition: inline
In-Reply-To: <20230228194327.1237008-1-kamatam@amazon.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--hg5k6tzebwpumy4g
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Tue, Feb 28, 2023 at 11:43:27AM -0800, Munehisa Kamata wrote:
> On Tue, 2023-02-28 10:15:58 +0000, Uwe Kleine-K=F6nig wrote:
> >
> > This is just to ensure that .usage_power is properly initialized and
> > doesn't contain random stack data. The other members of struct pwm_state
> > should get a value assigned in a successful call to .get_state(). So in
> > the absence of bugs in driver implementations, this is only a safe-guard
> > and no fix.
> >=20
> > Reported-by: Munehisa Kamata <kamatam@amazon.com>
> > Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
> > ---
> >  drivers/pwm/core.c | 9 ++++++++-
> >  1 file changed, 8 insertions(+), 1 deletion(-)
> >=20
> > Hello,
> >=20
> > On Sat, Feb 25, 2023 at 05:37:21PM -0800, Munehisa Kamata wrote:
> > > Zero-initialize the on-stack structure to avoid unexpected behaviors.=
 Some
> > > drivers may not set or initialize all the values in pwm_state through=
 their
> > > .get_state() callback and therefore some random values may remain the=
re and
> > > be set into pwm->state eventually.
> > >=20
> > > This actually caused regression on ODROID-N2+ as reported in [1]; ker=
nel
> > > fails to boot due to random panic or hang-up.
> > >=20
> > > [1] https://forum.odroid.com/viewtopic.php?f=3D177&t=3D46360
> > >=20
> > > Fixes: c73a3107624d ("pwm: Handle .get_state() failures")
> > > Cc: stable@vger.kernel.org # 6.2
> > > Signed-off-by: Munehisa Kamata <kamatam@amazon.com>
> >=20
> > My patch is essentially the same as Munehisa's, just written a bit
> > differently (to maybe make it easier for the compiler to optimize it?)
> > and with an explaining comment. The actual motivation is different so
> > the commit log is considerably different, too.
> >=20
> > I was unsure how to honor Munehisa's effort, I went with a
> > "Reported-by". Please tell me if you want this to be different.
>=20
> I'm okay with that, thank you.
>=20
> Perhaps, you should also add Cc tag for the stable tree? I did that in my
> patch and we're actually CCing to the stable list, but I'm not sure if it
> can pick up your patch without the tag. This should be fixed in linux-6.2=
=2Ey.

IMHO the problem you reported should be fixed by adapting .get_state()
in the meson driver.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--hg5k6tzebwpumy4g
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmP+dp8ACgkQwfwUeK3K
7AnU1wgAgYNenYgLsirU4NIF1nBZmL5XLN8gNVv5TaFLAAyu4sV8UJFWxlcZQky1
8rJUldOcKf5pfugeAjjNFxQB8SShUL+9ONaCmD5/NVBSiOEYRfIMX0qvMn+g27tf
VjIuFwEWC8Tg1Klm9lqsb4HEUjSvGWHVhERNXtWHYkp35NK+sb3UKsaoESgtcbte
ztuANJleB8BaA09D3VhdSQA1fNAUb8AJSQXQO2xAq5VJTwlit49UMYT//sEWp7wC
b6bONYAjYeHBlEL0yiithuG8SkCBUxOptevCYIooXWrs+6/4c9J265/M+yBRNWfM
tmvzpjR0jfWiBN55/apmMTIurPRglw==
=ZPv5
-----END PGP SIGNATURE-----

--hg5k6tzebwpumy4g--
