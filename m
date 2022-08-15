Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26D955951E7
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 07:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232493AbiHPFVM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 01:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232799AbiHPFUz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 01:20:55 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 989D5213EBE
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 14:49:24 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1oNhxV-0000K4-V5; Mon, 15 Aug 2022 23:49:18 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1oNhxR-0041OZ-0H; Mon, 15 Aug 2022 23:49:15 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1oNhxS-00Bxxd-FW; Mon, 15 Aug 2022 23:49:14 +0200
Date:   Mon, 15 Aug 2022 23:49:11 +0200
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.19 0191/1157] hwmon: (sht15) Fix wrong assumptions in
 device remove callback
Message-ID: <20220815214911.wy7p5sqbog6r6tcg@pengutronix.de>
References: <20220815180439.416659447@linuxfoundation.org>
 <20220815180447.391756473@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="cdn6od7prkvb2rrh"
Content-Disposition: inline
In-Reply-To: <20220815180447.391756473@linuxfoundation.org>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--cdn6od7prkvb2rrh
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Mon, Aug 15, 2022 at 07:52:27PM +0200, Greg Kroah-Hartman wrote:
> From: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
>=20
> [ Upstream commit 7d4edccc9bbfe1dcdff641343f7b0c6763fbe774 ]
>=20
> Taking a lock at the beginning of .remove() doesn't prevent new readers.
> With the existing approach it can happen, that a read occurs just when
> the lock was taken blocking the reader until the lock is released at the
> end of the remove callback which then accessed *data that is already
> freed then.
>=20
> To actually fix this problem the hwmon core needs some adaption. Until
> this is implemented take the optimistic approach of assuming that all
> readers are gone after hwmon_device_unregister() and
> sysfs_remove_group() as most other drivers do. (And once the core
> implements that, taking the lock would deadlock.)
>=20
> So drop the lock, move the reset to after device unregistration to keep
> the device in a workable state until it's deregistered. Also add a error
> message in case the reset fails and return 0 anyhow. (Returning an error
> code, doesn't stop the platform device unregistration and only results
> in a little helpful error message before the devm cleanup handlers are
> called.)
>=20
> Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
> Link: https://lore.kernel.org/r/20220725194344.150098-1-u.kleine-koenig@p=
engutronix.de
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Does this mean my concerns I expressed in the mail with Message-Id:
20220814155638.idxnihylofsxqlql@pengutronix.de were not taken into
consideration?

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--cdn6od7prkvb2rrh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmL6v1QACgkQwfwUeK3K
7AmfzAf+PY9qvY1QH95cKvjzGKeBnvO9pcR0rqSv6yaH7kor+QMK87IuuCaH2nX2
CoHXySBd5cSxpghL8kOEJCWATFnE0vAzKgAnJL38Ft5B8ebVR14LJzUszqqX2YDO
sEOcP9FjogRxf27mgb8Co8WeaMuqSNcEwpQnvfDkWqD+89xfH2eOUOngVqPDHxNB
4+cjI5JIGeaaTwqprJGKXLUzjopDVk0kRy1QRAHwwBFV2BYFLZXpN8ZTcqTIpr+e
PROJgfCccJVFajXdnX4BjbV9ZCyOI6MLhldOtujgUa06uIwfhpnlGm9TiZYMLE26
EZ78otywV/+ESXT/sr4rFXZFLp/r0Q==
=YBYr
-----END PGP SIGNATURE-----

--cdn6od7prkvb2rrh--
