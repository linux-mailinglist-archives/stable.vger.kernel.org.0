Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 116CE55044C
	for <lists+stable@lfdr.de>; Sat, 18 Jun 2022 13:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232506AbiFRLhK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Jun 2022 07:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbiFRLhI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Jun 2022 07:37:08 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4D721A041;
        Sat, 18 Jun 2022 04:37:05 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 4F29F1C0B8F; Sat, 18 Jun 2022 13:37:04 +0200 (CEST)
Date:   Sat, 18 Jun 2022 13:37:03 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Coly Li <colyli@suse.de>
Cc:     Pavel Machek <pavel@denx.de>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        baijiaju1990@gmail.com, oslab@tsinghua.edu.cn,
        Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, Daniel Latypov <dlatypov@google.com>,
        Brendan Higgins <brendanhiggins@google.com>,
        kunit-dev@googlegroups.com,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH 5.17 000/772] 5.17.14-rc1 review
Message-ID: <20220618113703.GA10888@duo.ucw.cz>
References: <20220607164948.980838585@linuxfoundation.org>
 <CA+G9fYui20CoDeqa6OrCYB+CGpgoFkhXtkdMDFJd1H55efCm6Q@mail.gmail.com>
 <CA+G9fYt47PBfbOK77eiH3qP2QH0iWQ=p12NELpL+R_k7O678=g@mail.gmail.com>
 <20220618104925.GA3644@duo.ucw.cz>
 <6497730E-D4D2-4FB3-B95B-E1DAB2C2B287@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="pWyiEgJYm5f9v55/"
Content-Disposition: inline
In-Reply-To: <6497730E-D4D2-4FB3-B95B-E1DAB2C2B287@suse.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> >>    Fixes: bc082a55d25c ("bcache: fix inaccurate io state for detached
> > ...
> >=20
> >> +++ b/drivers/md/bcache/request.c
> >> @@ -1107,6 +1107,12 @@ static void detached_dev_do_request(struct
> >> bcache_device *d, struct bio *bio,
> >>         * which would call closure_get(&dc->disk.cl)
> >>         */
> >>        ddip =3D kzalloc(sizeof(struct detached_dev_io_private), GFP_NO=
IO);
> >> +       if (!ddip) {
> >> +               bio->bi_status =3D BLK_STS_RESOURCE;
> >> +               bio->bi_end_io(bio);
> >> +               return;
> >> +       }
> >> +
> >>        ddip->d =3D d;
> >>        /* Count on the bcache device */
> >>        ddip->orig_bdev =3D orig_bdev;
> >>=20
> >=20
> > So... for patch to make any difference, memory allocation has to fail
> > and ddip has to be NULL.
> >=20
> > Before the patch, it would oops in "ddip->d =3D d;". With the patch, you
> > do some kind of error handling. Even if it is buggy, it should not do
> > more harm than immediate oops.
>=20
> I just receive this single email and don=E2=80=99t have any idea for the =
context and what the problem is. Where can I see the whole conversation?
>=20

Discussion happened on stable@vger.kernel.org mailing lists, archives
should be easily available. Copy went to lkml, too.

Best regards,
								Pavel
--=20
People of Russia, stop Putin before his war on Ukraine escalates.

--pWyiEgJYm5f9v55/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iFwEABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYq243wAKCRAw5/Bqldv6
8i+2AJdGM7sgIlX9Cpj2tjxtHjOUGbD0AKC/EHB1Dm/JmiCnatyPGyqNLzQmGQ==
=p/eF
-----END PGP SIGNATURE-----

--pWyiEgJYm5f9v55/--
