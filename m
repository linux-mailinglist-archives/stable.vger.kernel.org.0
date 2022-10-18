Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85EBD6028B4
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 11:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbiJRJsc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Oct 2022 05:48:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbiJRJsa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Oct 2022 05:48:30 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4ABAB03FE;
        Tue, 18 Oct 2022 02:48:24 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id B05C31C09D9; Tue, 18 Oct 2022 11:48:22 +0200 (CEST)
Date:   Tue, 18 Oct 2022 11:48:21 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        GUO Zihua <guozihua@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        philipp.g.hortmann@gmail.com, dave@stgolabs.net,
        paskripkin@gmail.com, dan.carpenter@oracle.com,
        yogi.kernel@gmail.com, yangyingliang@huawei.com,
        f3sch.git@outlook.com, linux-staging@lists.linux.dev
Subject: Re: [PATCH AUTOSEL 5.10 10/33] staging: rtl8192e: Fix return type
 for implementation of ndo_start_xmit
Message-ID: <20221018094821.GG1264@duo.ucw.cz>
References: <20221013002334.1894749-1-sashal@kernel.org>
 <20221013002334.1894749-10-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="w2JjAQZceEVGylhD"
Content-Disposition: inline
In-Reply-To: <20221013002334.1894749-10-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--w2JjAQZceEVGylhD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit 513d9a61156d79dd0979c4ad400c8587f52cbb9d ]
>=20
> CFI (Control Flow Integrity) is a safety feature allowing the system to
> detect and react should a potential control flow hijacking occurs. In
> particular, the Forward-Edge CFI protects indirect function calls by
> ensuring the prototype of function that is actually called matches the
> definition of the function hook.
>=20
> Since Linux now supports CFI, it will be a good idea to fix mismatched
> return type for implementation of hooks. Otherwise this would get
> cought out by CFI and cause a panic.
>=20
> Use enums from netdev_tx_t as return value instead, then change return
> type to netdev_tx_t. Note that rtllib_xmit_inter() would return 1 only
> on allocation failure and the queue is stopped if that happens, meeting
> the documented requirement if NETDEV_TX_BUSY should be returned by
> ndo_start_xmit.
>=20

> +++ b/drivers/staging/rtl8192e/rtllib_tx.c
> @@ -964,9 +964,9 @@ static int rtllib_xmit_inter(struct sk_buff *skb, str=
uct net_device *dev)
> =20
>  }
> =20
> -int rtllib_xmit(struct sk_buff *skb, struct net_device *dev)
> +netdev_tx_t rtllib_xmit(struct sk_buff *skb, struct net_device *dev)
>  {
>  	memset(skb->cb, 0, sizeof(skb->cb));
> -	return rtllib_xmit_inter(skb, dev);
> +	return rtllib_xmit_inter(skb, dev) ? NETDEV_TX_BUSY : NETDEV_TX_OK;
>  }
>  EXPORT_SYMBOL(rtllib_xmit);

First, rtllib_xmit_inter() should be fixed to return the enum, too.

Second, we really should not take this to stable, as CFI is not
available there. We should drop these patches:

 4.19 14/19] staging: rtl8192u: Fix return type of ieee80211_xmit
 5.10 09/33] staging: rtl8712: Fix return type for implementation of ndo_st=
art_xmit
 5.10 10/33] staging: rtl8192e: Fix return type for implementation of ndo_s=
tart_xmit

Thank you,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--w2JjAQZceEVGylhD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY052ZQAKCRAw5/Bqldv6
8hTcAJ9PBdweJJhOG74AwK6TImK+wL5L+wCgs9x/IBjvRqzunKW9aVpiy21Y8ZE=
=+pT0
-----END PGP SIGNATURE-----

--w2JjAQZceEVGylhD--
