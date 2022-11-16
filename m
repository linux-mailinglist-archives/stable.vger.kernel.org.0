Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7F7962B9A4
	for <lists+stable@lfdr.de>; Wed, 16 Nov 2022 11:44:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238650AbiKPKoc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Nov 2022 05:44:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233871AbiKPKoP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Nov 2022 05:44:15 -0500
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA854F28
        for <stable@vger.kernel.org>; Wed, 16 Nov 2022 02:32:12 -0800 (PST)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 7C2C51C09F6; Wed, 16 Nov 2022 11:32:11 +0100 (CET)
Date:   Wed, 16 Nov 2022 11:32:11 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        Shang XiaoJing <shangxiaojing@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 027/118] nfc: nfcmrvl: Fix potential memory leak in
 nfcmrvl_i2c_nci_send()
Message-ID: <Y3S8K6Bzs62UkKXg@duo.ucw.cz>
References: <20221108133340.718216105@linuxfoundation.org>
 <20221108133341.836879145@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="sit6fkatb6c/qX78"
Content-Disposition: inline
In-Reply-To: <20221108133341.836879145@linuxfoundation.org>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--sit6fkatb6c/qX78
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Shang XiaoJing <shangxiaojing@huawei.com>
>=20
> [ Upstream commit 93d904a734a74c54d945a9884b4962977f1176cd ]
>=20
> nfcmrvl_i2c_nci_send() will be called by nfcmrvl_nci_send(), and skb
> should be freed in nfcmrvl_i2c_nci_send(). However, nfcmrvl_nci_send()
> will only free skb when i2c_master_send() return >=3D0, which means skb
> will memleak when i2c_master_send() failed. Free skb no matter whether
> i2c_master_send() succeeds.

We still need to free the skb in the other error exits, right?

Best regards,
								Pavel
							=09
> +++ b/drivers/nfc/nfcmrvl/i2c.c
> @@ -151,10 +151,15 @@ static int nfcmrvl_i2c_nci_send(struct nfcmrvl_priv=
ate *priv,
>  			ret =3D -EREMOTEIO;
>  		} else
>  			ret =3D 0;
> +	}
> +
> +	if (ret) {
>  		kfree_skb(skb);
> +		return ret;
>  	}
> =20
> -	return ret;
> +	consume_skb(skb);
> +	return 0;
>  }
> =20
>  static void nfcmrvl_i2c_nci_update_config(struct nfcmrvl_private *priv,

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--sit6fkatb6c/qX78
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY3S8KwAKCRAw5/Bqldv6
8jhNAKCi4n/aOKGXNaFChdfN32UQh2z7BwCgks+eFlsEN3b6yyumgpecGPkw8So=
=Xt4m
-----END PGP SIGNATURE-----

--sit6fkatb6c/qX78--
