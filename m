Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9EF2644372
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 13:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233811AbiLFMvu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 07:51:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230327AbiLFMvt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 07:51:49 -0500
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7FB410B7A
        for <stable@vger.kernel.org>; Tue,  6 Dec 2022 04:51:47 -0800 (PST)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 2050F1C09DB; Tue,  6 Dec 2022 13:51:43 +0100 (CET)
Date:   Tue, 6 Dec 2022 13:51:42 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        Duoming Zhou <duoming@zju.edu.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.9 38/62] qlcnic: fix sleep-in-atomic-context bugs
 caused by msleep
Message-ID: <Y4863iukOiRJx3K+@duo.ucw.cz>
References: <20221205190758.073114639@linuxfoundation.org>
 <20221205190759.531467030@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="oPIx4hLnTvh7JOJc"
Content-Disposition: inline
In-Reply-To: <20221205190759.531467030@linuxfoundation.org>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--oPIx4hLnTvh7JOJc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Duoming Zhou <duoming@zju.edu.cn>

>    (atomic context)
> dev_watchdog
>   qlcnic_tx_timeout
>     qlcnic_83xx_idc_request_reset
>       qlcnic_83xx_lock_driver
>         qlcnic_83xx_recover_driver_lock
>           msleep
>=20
> Fix by changing msleep() to mdelay(), the mdelay() is
> busy-waiting and the bugs could be mitigated.

The mdelay is for 200 msec:

qlcnic_83xx_hw.h:#define QLC_83XX_DRV_LOCK_RECOVERY_DELAY 200

This may be an improvement, but spinning for 200 msec in atomic
context is not okay, I'm afraid.

Best regards,
                                                        Pavel


--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--oPIx4hLnTvh7JOJc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY4863gAKCRAw5/Bqldv6
8pWaAJ4kRsHgwrGfjfCTmRaZ/zTKcmLpSgCdFiY8qfYUQjjVz/LYVwwsq0Yzr2A=
=tBwU
-----END PGP SIGNATURE-----

--oPIx4hLnTvh7JOJc--
