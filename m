Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B05F459A68B
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 21:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231806AbiHSTfM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 15:35:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231530AbiHSTfL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 15:35:11 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7D7BC2F99
        for <stable@vger.kernel.org>; Fri, 19 Aug 2022 12:35:09 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1oP7lr-0003qd-5V; Fri, 19 Aug 2022 21:35:07 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1oP7lp-000lsq-Ln; Fri, 19 Aug 2022 21:35:05 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1oP7lo-00Cni9-Kn; Fri, 19 Aug 2022 21:35:04 +0200
Date:   Fri, 19 Aug 2022 21:35:01 +0200
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.19 0191/1157] hwmon: (sht15) Fix wrong assumptions in
 device remove callback
Message-ID: <20220819193501.glb43pf64zkl7n3p@pengutronix.de>
References: <20220815180439.416659447@linuxfoundation.org>
 <20220815180447.391756473@linuxfoundation.org>
 <20220815214911.wy7p5sqbog6r6tcg@pengutronix.de>
 <Yvt0Ms9ur2aSj2Zz@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="m7u2qoobcl7vkpee"
Content-Disposition: inline
In-Reply-To: <Yvt0Ms9ur2aSj2Zz@kroah.com>
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


--m7u2qoobcl7vkpee
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Greg,

On Tue, Aug 16, 2022 at 12:40:50PM +0200, Greg Kroah-Hartman wrote:
> On Mon, Aug 15, 2022 at 11:49:11PM +0200, Uwe Kleine-K=F6nig wrote:
> > On Mon, Aug 15, 2022 at 07:52:27PM +0200, Greg Kroah-Hartman wrote:
> > > From: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
> > >=20
> > > [ Upstream commit 7d4edccc9bbfe1dcdff641343f7b0c6763fbe774 ]
> > >=20
> > > Taking a lock at the beginning of .remove() doesn't prevent new reade=
rs.
> > > With the existing approach it can happen, that a read occurs just when
> > > the lock was taken blocking the reader until the lock is released at =
the
> > > end of the remove callback which then accessed *data that is already
> > > freed then.
> > >=20
> > > To actually fix this problem the hwmon core needs some adaption. Until
> > > this is implemented take the optimistic approach of assuming that all
> > > readers are gone after hwmon_device_unregister() and
> > > sysfs_remove_group() as most other drivers do. (And once the core
> > > implements that, taking the lock would deadlock.)
> > >=20
> > > So drop the lock, move the reset to after device unregistration to ke=
ep
> > > the device in a workable state until it's deregistered. Also add a er=
ror
> > > message in case the reset fails and return 0 anyhow. (Returning an er=
ror
> > > code, doesn't stop the platform device unregistration and only results
> > > in a little helpful error message before the devm cleanup handlers are
> > > called.)
> > >=20
> > > Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
> > > Link: https://lore.kernel.org/r/20220725194344.150098-1-u.kleine-koen=
ig@pengutronix.de
> > > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> >=20
> > Does this mean my concerns I expressed in the mail with Message-Id:
> > 20220814155638.idxnihylofsxqlql@pengutronix.de were not taken into
> > consideration?
>=20
> I can't find that message-id on lore.kernel.org, do you have a link?

Oh, I missed your request earlier. No I don't have a link, the mail was
sent to Sasha Levin, Jean Delvare, Guenter Roeck and stable-commits as I
just replied to the "note to let you know that I've just added the patch
titled [...] to the 5.19-stable tree".

I wrote:
> I'd say adding this patch to stable isn't right. The problem existed
> since v3.0 (commit cc15c7ebb424e45ba2c5ceecbe52d025219ee970) and was
> never reported to be hit in practise. And given that the problem doesn't
> go away completely but (AFAICT) just opens the possibility for a hwmon
> core fix, I'd say it's not worth a backport.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--m7u2qoobcl7vkpee
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmL/5eIACgkQwfwUeK3K
7AkGfwf+L+JbxtND792d9fKcXW+J9kb3VlkKrMzaMHmzVTKCHbG3WbO4CV2ZBCTV
sVssp8PP1hpqIjI9/9hYekKhjyROkpJDQM3ADjaIDKvHcwk5ZA4Qrhy9FD/YSAPi
4bXP9ZP/crrSHZwHoyTEdIyh3ys9W/mdGRg9+PuJ3nB6xkNEvF5gVMdB/68wSV6C
z9gP69dfLMG5cFpaKKhSdD/rJaVqw9A+GgKnQnd+yIbAd/AqBb9Mrn2XBTG/97Lk
+KK2stEqVG/sHhvCQsvBwj3XGmElSja+FWcWGnQdXM+57i8IVE4poyTuj2JWAupe
UJcWje/F3xofJJu3InLakL5VZ+nqRA==
=H/ju
-----END PGP SIGNATURE-----

--m7u2qoobcl7vkpee--
