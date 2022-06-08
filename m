Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC588543E40
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 23:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233140AbiFHVIg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 17:08:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234646AbiFHVIf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 17:08:35 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E09D022736E;
        Wed,  8 Jun 2022 14:08:33 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 802711C0BB5; Wed,  8 Jun 2022 23:08:30 +0200 (CEST)
Date:   Wed, 8 Jun 2022 23:08:30 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Zheng Bin <zhengbin13@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        w.d.hubbs@gmail.com, chris@the-brannons.com, kirk@reisers.ca,
        samuel.thibault@ens-lyon.org, trix@redhat.com,
        salah.triki@gmail.com, speakup@linux-speakup.org
Subject: Re: [PATCH AUTOSEL 5.10 21/38] accessiblity: speakup: Add missing
 misc_deregister in softsynth_probe
Message-ID: <20220608210830.GA1306@duo.ucw.cz>
References: <20220607175835.480735-1-sashal@kernel.org>
 <20220607175835.480735-21-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="liOOAslEiF7prFVr"
Content-Disposition: inline
In-Reply-To: <20220607175835.480735-21-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Zheng Bin <zhengbin13@huawei.com>
>=20
> [ Upstream commit 106101303eda8f93c65158e5d72b2cc6088ed034 ]
>=20
> softsynth_probe misses a call misc_deregister() in an error path, this
> patch fixes that.

This seems incorrect. Registration failed, we can't really deregister.

I checked random other caller of misc_register(), and it does not seem
this API is unusual.

Best regards,
								Pavel

> +++ b/drivers/accessibility/speakup/speakup_soft.c
> @@ -390,6 +390,7 @@ static int softsynth_probe(struct spk_synth *synth)
>  	synthu_device.name =3D "softsynthu";
>  	synthu_device.fops =3D &softsynthu_fops;
>  	if (misc_register(&synthu_device)) {
> +		misc_deregister(&synth_device);
>  		pr_warn("Couldn't initialize miscdevice /dev/softsynthu.\n");
>  		return -ENODEV;
>  	}


--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--liOOAslEiF7prFVr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYqEPzgAKCRAw5/Bqldv6
8iKSAKCAku6qb+5NjpqdOMca0bsNKBgj/gCfYTbZIhGE/FQarjaj1ZwM7wkIZik=
=fD/V
-----END PGP SIGNATURE-----

--liOOAslEiF7prFVr--
