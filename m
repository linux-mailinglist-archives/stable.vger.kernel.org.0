Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB7A8550412
	for <lists+stable@lfdr.de>; Sat, 18 Jun 2022 12:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232489AbiFRKtb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Jun 2022 06:49:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbiFRKtb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Jun 2022 06:49:31 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2595617585;
        Sat, 18 Jun 2022 03:49:29 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 2526A1C0B8F; Sat, 18 Jun 2022 12:49:26 +0200 (CEST)
Date:   Sat, 18 Jun 2022 12:49:25 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>, baijiaju1990@gmail.com,
        oslab@tsinghua.edu.cn, colyli@suse.de, axboe@kernel.dk
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, Daniel Latypov <dlatypov@google.com>,
        Brendan Higgins <brendanhiggins@google.com>,
        kunit-dev@googlegroups.com,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH 5.17 000/772] 5.17.14-rc1 review
Message-ID: <20220618104925.GA3644@duo.ucw.cz>
References: <20220607164948.980838585@linuxfoundation.org>
 <CA+G9fYui20CoDeqa6OrCYB+CGpgoFkhXtkdMDFJd1H55efCm6Q@mail.gmail.com>
 <CA+G9fYt47PBfbOK77eiH3qP2QH0iWQ=p12NELpL+R_k7O678=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="fdj2RfSjLxBAspz7"
Content-Disposition: inline
In-Reply-To: <CA+G9fYt47PBfbOK77eiH3qP2QH0iWQ=p12NELpL+R_k7O678=g@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!
> > >
> > > This is the start of the stable review cycle for the 5.17.14 release.
> > > There are 772 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
> > >
> > > Responses should be made by Thu, 09 Jun 2022 16:48:02 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/pa=
tch-5.17.14-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git linux-5.17.y
> > > and the diffstat can be found below.
> > >
=2E..
> > We will bisect and let you know more details about this reported proble=
m.
>=20
> The bisect script pointed me to this commit and  reverted and tested and
> confirmed.

Can you add some printks into that? Because I'm pretty sure this patch
does not break anything. (It should not fix much, either.)

> commit 1883088ed4a0d5cc9cea500ca4e89a354ab32c11
> Author: Jia-Ju Bai <baijiaju1990@gmail.com>

>     md: bcache: check the return value of kzalloc() in detached_dev_do_re=
quest()
>=20
>     commit 40f567bbb3b0639d2ec7d1c6ad4b1b018f80cf19 upstream.
>=20
>     The function kzalloc() in detached_dev_do_request() can fail, so its
>     return value should be checked.
>=20
>     Fixes: bc082a55d25c ("bcache: fix inaccurate io state for detached
=2E..

> +++ b/drivers/md/bcache/request.c
> @@ -1107,6 +1107,12 @@ static void detached_dev_do_request(struct
> bcache_device *d, struct bio *bio,
>          * which would call closure_get(&dc->disk.cl)
>          */
>         ddip =3D kzalloc(sizeof(struct detached_dev_io_private), GFP_NOIO=
);
> +       if (!ddip) {
> +               bio->bi_status =3D BLK_STS_RESOURCE;
> +               bio->bi_end_io(bio);
> +               return;
> +       }
> +
>         ddip->d =3D d;
>         /* Count on the bcache device */
>         ddip->orig_bdev =3D orig_bdev;
>=20

So... for patch to make any difference, memory allocation has to fail
and ddip has to be NULL.

Before the patch, it would oops in "ddip->d =3D d;". With the patch, you
do some kind of error handling. Even if it is buggy, it should not do
more harm than immediate oops.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--fdj2RfSjLxBAspz7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYq2ttQAKCRAw5/Bqldv6
8oHGAJ9pEIvr/YXimrgyUF20plQSfIVzMwCZAVwuSN3MVMeBOt0SNNBc4rygDCc=
=l+d7
-----END PGP SIGNATURE-----

--fdj2RfSjLxBAspz7--
