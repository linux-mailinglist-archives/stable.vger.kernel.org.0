Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3914C4BFCD2
	for <lists+stable@lfdr.de>; Tue, 22 Feb 2022 16:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233573AbiBVPgT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 10:36:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233567AbiBVPgA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 10:36:00 -0500
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89962163D6B;
        Tue, 22 Feb 2022 07:35:31 -0800 (PST)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id E4ACF1C0B85; Tue, 22 Feb 2022 16:35:29 +0100 (CET)
Date:   Tue, 22 Feb 2022 16:35:28 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 4.19 29/58] bonding: fix data-races around
 agg_select_timer
Message-ID: <20220222153528.GA27262@amd>
References: <20220221084911.895146879@linuxfoundation.org>
 <20220221084912.825972694@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline
In-Reply-To: <20220221084912.825972694@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> syzbot reported that two threads might write over agg_select_timer
> at the same time. Make agg_select_timer atomic to fix the races.

Ok, but:

> --- a/drivers/net/bonding/bond_3ad.c
> +++ b/drivers/net/bonding/bond_3ad.c
> @@ -249,7 +249,7 @@ static inline int __check_agg_selection_
>  	if (bond =3D=3D NULL)
>  		return 0;
> =20
> -	return BOND_AD_INFO(bond).agg_select_timer ? 1 : 0;
> +	return atomic_read(&BOND_AD_INFO(bond).agg_select_timer) ? 1 : 0;
>  }

This could probably use !!.

> +static bool bond_agg_timer_advance(struct bonding *bond)
> +{
> +	int val, nval;
> +
> +	while (1) {
> +		val =3D atomic_read(&BOND_AD_INFO(bond).agg_select_timer);
> +		if (!val)
> +			return false;
> +		nval =3D val - 1;
> +		if (atomic_cmpxchg(&BOND_AD_INFO(bond).agg_select_timer,
> +				   val, nval) =3D=3D val)
> +			break;
> +	}
> +	return nval =3D=3D 0;
> +}

This should really be atomic_dec_if_positive, no?

Best regards,
								Pavel
--=20
http://www.livejournal.com/~pavelmachek

--7AUc2qLy4jB3hD7Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmIVAsAACgkQMOfwapXb+vKzngCeN5rpyiYQZre0h6CzYRc/yKs/
yFEAoK1I2ow3kXEy7OJt828WM82tSDEb
=aXx+
-----END PGP SIGNATURE-----

--7AUc2qLy4jB3hD7Z--
