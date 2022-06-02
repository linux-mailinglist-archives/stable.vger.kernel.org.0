Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25C7953BC35
	for <lists+stable@lfdr.de>; Thu,  2 Jun 2022 18:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236861AbiFBQMe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jun 2022 12:12:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233080AbiFBQMe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jun 2022 12:12:34 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4D90AE4C;
        Thu,  2 Jun 2022 09:12:32 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id D28741C0B9B; Thu,  2 Jun 2022 18:12:30 +0200 (CEST)
Date:   Thu, 2 Jun 2022 18:12:30 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        theflamefire89@gmail.com
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jordy Zomer <jordy@pwning.systems>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Denis Efremov <denis.e.efremov@oracle.com>
Subject: Re: [PATCH 4.19 01/20] nfc: st21nfca: Fix potential buffer overflows
 in EVT_TRANSACTION
Message-ID: <20220602161229.GA32444@duo.ucw.cz>
References: <20220325150417.010265747@linuxfoundation.org>
 <20220325150417.055045556@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="pf9I7BMVVzbSWLtt"
Content-Disposition: inline
In-Reply-To: <20220325150417.055045556@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> commit 4fbcc1a4cb20fe26ad0225679c536c80f1648221 upstream.
>=20
> It appears that there are some buffer overflows in EVT_TRANSACTION.
> This happens because the length parameters that are passed to memcpy
> come directly from skb->data and are not guarded in any way.
>=20
> Signed-off-by: Jordy Zomer <jordy@pwning.systems>
> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Denis Efremov <denis.e.efremov@oracle.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

It seems that this patch causes an memory leak, transaction does not
seem to be freed in the error paths.

(I also wonder if the skb should be freed in the error paths...?)

Reported-by: <theflamefire89@gmail.com>

>  drivers/nfc/st21nfca/se.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
>=20
> --- a/drivers/nfc/st21nfca/se.c
> +++ b/drivers/nfc/st21nfca/se.c
> @@ -332,6 +332,11 @@ int st21nfca_connectivity_event_received
>  			return -ENOMEM;
> =20
>  		transaction->aid_len =3D skb->data[1];
> +
> +		/* Checking if the length of the AID is valid */
> +		if (transaction->aid_len > sizeof(transaction->aid))
> +			return -EINVAL;
> +
>  		memcpy(transaction->aid, &skb->data[2],
>  		       transaction->aid_len);
> =20
> @@ -341,6 +346,11 @@ int st21nfca_connectivity_event_received
>  			return -EPROTO;
> =20
>  		transaction->params_len =3D skb->data[transaction->aid_len + 3];
> +
> +		/* Total size is allocated (skb->len - 2) minus fixed array members */
> +		if (transaction->params_len > ((skb->len - 2) - sizeof(struct nfc_evt_=
transaction)))
> +			return -EINVAL;
> +
>  		memcpy(transaction->params, skb->data +
>  		       transaction->aid_len + 4, transaction->params_len);
> =20
>=20

--=20
People of Russia, stop Putin before his war on Ukraine escalates.

--pf9I7BMVVzbSWLtt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYpjhbQAKCRAw5/Bqldv6
8vE3AJ4xMLZdnYOYM/Z9InnPmofTV8YfcQCgvc6Q9aeOoqwrTaWNmT+FxpniGnk=
=Rx9k
-----END PGP SIGNATURE-----

--pf9I7BMVVzbSWLtt--
