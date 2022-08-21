Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB7959B2AF
	for <lists+stable@lfdr.de>; Sun, 21 Aug 2022 10:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbiHUIGG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Aug 2022 04:06:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbiHUIGF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Aug 2022 04:06:05 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0674F1A3AC
        for <stable@vger.kernel.org>; Sun, 21 Aug 2022 01:06:04 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1oPfy4-0001Wi-SF; Sun, 21 Aug 2022 10:06:00 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1oPfy3-001422-D0; Sun, 21 Aug 2022 10:05:59 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1oPfy2-00D71c-Fg; Sun, 21 Aug 2022 10:05:58 +0200
Date:   Sun, 21 Aug 2022 10:05:55 +0200
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.19 0191/1157] hwmon: (sht15) Fix wrong assumptions in
 device remove callback
Message-ID: <20220821080555.rft6xztc2rfn7bny@pengutronix.de>
References: <20220815180439.416659447@linuxfoundation.org>
 <20220815180447.391756473@linuxfoundation.org>
 <20220815214911.wy7p5sqbog6r6tcg@pengutronix.de>
 <Yvt0Ms9ur2aSj2Zz@kroah.com>
 <20220819193501.glb43pf64zkl7n3p@pengutronix.de>
 <YwEkkn1xmGM5kHel@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ngxpe4bl247yovnx"
Content-Disposition: inline
In-Reply-To: <YwEkkn1xmGM5kHel@kroah.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ngxpe4bl247yovnx
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 20, 2022 at 08:14:42PM +0200, Greg Kroah-Hartman wrote:
> On Fri, Aug 19, 2022 at 09:35:01PM +0200, Uwe Kleine-K=F6nig wrote:
> > Hello Greg,
> >=20
> > On Tue, Aug 16, 2022 at 12:40:50PM +0200, Greg Kroah-Hartman wrote:
> > > On Mon, Aug 15, 2022 at 11:49:11PM +0200, Uwe Kleine-K=F6nig wrote:
> > > > On Mon, Aug 15, 2022 at 07:52:27PM +0200, Greg Kroah-Hartman wrote:
> > > > > From: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
> > > > >=20
> > > > > [ Upstream commit 7d4edccc9bbfe1dcdff641343f7b0c6763fbe774 ]
> > > > >=20
> > > > > Taking a lock at the beginning of .remove() doesn't prevent new r=
eaders.
> > > > > With the existing approach it can happen, that a read occurs just=
 when
> > > > > the lock was taken blocking the reader until the lock is released=
 at the
> > > > > end of the remove callback which then accessed *data that is alre=
ady
> > > > > freed then.
> > > > >=20
> > > > > To actually fix this problem the hwmon core needs some adaption. =
Until
> > > > > this is implemented take the optimistic approach of assuming that=
 all
> > > > > readers are gone after hwmon_device_unregister() and
> > > > > sysfs_remove_group() as most other drivers do. (And once the core
> > > > > implements that, taking the lock would deadlock.)
> > > > >=20
> > > > > So drop the lock, move the reset to after device unregistration t=
o keep
> > > > > the device in a workable state until it's deregistered. Also add =
a error
> > > > > message in case the reset fails and return 0 anyhow. (Returning a=
n error
> > > > > code, doesn't stop the platform device unregistration and only re=
sults
> > > > > in a little helpful error message before the devm cleanup handler=
s are
> > > > > called.)
> > > > >=20
> > > > > Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
> > > > > Link: https://lore.kernel.org/r/20220725194344.150098-1-u.kleine-=
koenig@pengutronix.de
> > > > > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > > > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > >=20
> > > > Does this mean my concerns I expressed in the mail with Message-Id:
> > > > 20220814155638.idxnihylofsxqlql@pengutronix.de were not taken into
> > > > consideration?
> > >=20
> > > I can't find that message-id on lore.kernel.org, do you have a link?
> >=20
> > Oh, I missed your request earlier. No I don't have a link, the mail was
> > sent to Sasha Levin, Jean Delvare, Guenter Roeck and stable-commits as I
> > just replied to the "note to let you know that I've just added the patch
> > titled [...] to the 5.19-stable tree".
>=20
> Ok, I've dropped it now from all pending queues (5.10 and older), I can
> also revert it from the newer ones if you want me to.

Actually I don't care much. It touches a path that is not usually hit,
because platform devices are not removed very often. So I expect even if
the problem with this driver is a different one now, we won't get any
regressions here.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--ngxpe4bl247yovnx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmMB52AACgkQwfwUeK3K
7AlYkAgAl3b1m0Z9dGXgA8Ow+PZpHzugctVa8JxnIglfdzeET6EKwJfIjmfoxxuW
fOzmqpTygtOblKU96bo1iRgx5/PWlg0ozLzK6K7a5Ac1HDGMt1P98bDAHLCgdpxJ
PfsuKRFdFYkRQ/HgUnUiPNbwfvhrSBaZ5nJYU2LMG4aWamz8VTQN/pictzNTl442
vYNXdYslqTpNKE8nEN+5NbeGUY5A4SZV/Ka3YqMcrx3JBdKsEEfhhcm3zjdpRnUy
dXEs6NvlXzOt5FBnmFeZh0RhTFWv/wCrRzmhtRBLya58cTvPB3tHYuOaxBLc2BDT
dzkH8Lp5pI4x+yzSXxNLXq/QWvP8pQ==
=fBdH
-----END PGP SIGNATURE-----

--ngxpe4bl247yovnx--
