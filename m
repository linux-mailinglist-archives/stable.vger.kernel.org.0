Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43AB93FE38B
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 22:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231373AbhIAUKy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 16:10:54 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:46014 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242567AbhIAUKx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Sep 2021 16:10:53 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 2B52D1C0BA1; Wed,  1 Sep 2021 22:09:54 +0200 (CEST)
Date:   Wed, 1 Sep 2021 22:09:53 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 047/103] net: stmmac: add mutex lock to protect est
 parameters
Message-ID: <20210901200953.GB8962@duo.ucw.cz>
References: <20210901122300.503008474@linuxfoundation.org>
 <20210901122302.156121465@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="NDin8bjvE/0mNLFQ"
Content-Disposition: inline
In-Reply-To: <20210901122302.156121465@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--NDin8bjvE/0mNLFQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit b2aae654a4794ef898ad33a179f341eb610f6b85 ]
>=20
> Add a mutex lock to protect est structure parameters so that the
> EST parameters can be updated by other threads.

Mainline version of the patch is okay, but I believe we need one more
mutex_unlock in 5.10.

Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/=
ethernet/stmicro/stmmac/stmmac_tc.c
index 22c34474e617..639980306115 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -765,6 +765,7 @@ static int tc_setup_taprio(struct stmmac_priv *priv,
 				   priv->plat->tx_queues_to_use,
 				   priv->plat->rx_queues_to_use, fpe);
 	if (ret && fpe) {
+		mutex_unlock(&priv->plat->est->lock);
 		netdev_err(priv->dev, "failed to enable Frame Preemption\n");
 		return ret;
 	}

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--NDin8bjvE/0mNLFQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYS/eEQAKCRAw5/Bqldv6
8iXtAKCmVub25dmgVRjdPVCSSwcoYfHMXwCglP2YuNR7kwoLoT4ksL7PVsmuQd4=
=kCOO
-----END PGP SIGNATURE-----

--NDin8bjvE/0mNLFQ--
