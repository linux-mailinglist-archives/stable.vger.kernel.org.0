Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF0C162B97C
	for <lists+stable@lfdr.de>; Wed, 16 Nov 2022 11:42:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233587AbiKPKmX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Nov 2022 05:42:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233444AbiKPKlp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Nov 2022 05:41:45 -0500
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9D2E4046F
        for <stable@vger.kernel.org>; Wed, 16 Nov 2022 02:29:59 -0800 (PST)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 497C01C09F6; Wed, 16 Nov 2022 11:29:58 +0100 (CET)
Date:   Wed, 16 Nov 2022 11:29:57 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        Shang XiaoJing <shangxiaojing@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 026/118] nfc: s3fwrn5: Fix potential memory leak in
 s3fwrn5_nci_send()
Message-ID: <Y3S7pQH6mHitxcfy@duo.ucw.cz>
References: <20221108133340.718216105@linuxfoundation.org>
 <20221108133341.795605593@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="QPc+M1xnBIb8zWhZ"
Content-Disposition: inline
In-Reply-To: <20221108133341.795605593@linuxfoundation.org>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--QPc+M1xnBIb8zWhZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Shang XiaoJing <shangxiaojing@huawei.com>
>=20
> [ Upstream commit 3a146b7e3099dc7cf3114f627d9b79291e2d2203 ]
>=20
> s3fwrn5_nci_send() will call s3fwrn5_i2c_write() or s3fwrn82_uart_write(),
> and free the skb if write() failed. However, even if the write() run
> succeeds, the skb will not be freed in write(). As the result, the skb
> will memleak. s3fwrn5_nci_send() should also free the skb when write()
> succeeds.

There are more error returns in that function that do not free
anything. Do they need to be fixed, too?

Same goes for "nfc: nxp-nci: Fix potential memory leak in
nxp_nci_send()".

Best regards,
								Pavel
> +++ b/drivers/nfc/s3fwrn5/core.c
> @@ -97,11 +97,15 @@ static int s3fwrn5_nci_send(struct nci_dev *ndev, str=
uct sk_buff *skb)
>  	}
> =20
>  	ret =3D s3fwrn5_write(info, skb);
> -	if (ret < 0)
> +	if (ret < 0) {
>  		kfree_skb(skb);
> +		mutex_unlock(&info->mutex);
> +		return ret;
> +	}
> =20
> +	consume_skb(skb);
>  	mutex_unlock(&info->mutex);
> -	return ret;
> +	return 0;
>  }
> =20
>  static int s3fwrn5_nci_post_setup(struct nci_dev *ndev)

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--QPc+M1xnBIb8zWhZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY3S7pQAKCRAw5/Bqldv6
8goeAJ44aZI0JntTnEd3VkXi5ZM1g5bn8ACeNcxzFxqqnP1PxZHKCBRI/oFXnD8=
=PYQk
-----END PGP SIGNATURE-----

--QPc+M1xnBIb8zWhZ--
