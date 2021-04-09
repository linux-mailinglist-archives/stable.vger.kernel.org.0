Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A93B2359C2C
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 12:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233797AbhDIKed (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 06:34:33 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:41042 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233505AbhDIKeM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Apr 2021 06:34:12 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 306A41C0B78; Fri,  9 Apr 2021 12:33:56 +0200 (CEST)
Date:   Fri, 9 Apr 2021 12:33:55 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Pavel Andrianov <andrianov@ispras.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 06/41] net: pxa168_eth: Fix a potential data race in
 pxa168_eth_remove
Message-ID: <20210409103355.GA10988@amd>
References: <20210409095304.818847860@linuxfoundation.org>
 <20210409095305.022244081@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ZGiS0Q5IWpPtfppv"
Content-Disposition: inline
In-Reply-To: <20210409095305.022244081@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit 0571a753cb07982cc82f4a5115e0b321da89e1f3 ]
>=20
> pxa168_eth_remove() firstly calls unregister_netdev(),
> then cancels a timeout work. unregister_netdev() shuts down a device
> interface and removes it from the kernel tables. If the timeout occurs
> in parallel, the timeout work (pxa168_eth_tx_timeout_task) performs stop
> and open of the device. It may lead to an inconsistent state and memory
> leaks.

AFAICT the timeout work does a lot of processing, including
pxa168_eth_open(), pxa168_init_phy() and phy_connect_direct(). We
probably don't want that to run with clock being disabled and DMA
being unmapped.

We certainly don't want phy_disconnect() being undone by
phy_connect_direct() running in the workqueue.

IOW this patch is not enough to fix the bugs, and at least fix below
is needed to get something reasonable.

Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
								Pavel

> +++ b/drivers/net/ethernet/marvell/pxa168_eth.c
> @@ -1544,8 +1544,8 @@ static int pxa168_eth_remove(struct platform_device=
 *pdev)
>  	clk_disable_unprepare(pep->clk);
>  	mdiobus_unregister(pep->smi_bus);
>  	mdiobus_free(pep->smi_bus);
> -	unregister_netdev(dev);
>  	cancel_work_sync(&pep->tx_timeout_task);
> +	unregister_netdev(dev);
>  	free_netdev(dev);
>  	return 0;
>  }

diff --git a/drivers/net/ethernet/marvell/pxa168_eth.c b/drivers/net/ethern=
et/marvell/pxa168_eth.c
index d1e4d42e497d..432be22a51be 100644
--- a/drivers/net/ethernet/marvell/pxa168_eth.c
+++ b/drivers/net/ethernet/marvell/pxa168_eth.c
@@ -1532,7 +1532,8 @@ static int pxa168_eth_remove(struct platform_device *=
pdev)
 {
 	struct net_device *dev =3D platform_get_drvdata(pdev);
 	struct pxa168_eth_private *pep =3D netdev_priv(dev);
-
+=09
+	cancel_work_sync(&pep->tx_timeout_task);
 	if (pep->htpr) {
 		dma_free_coherent(pep->dev->dev.parent, HASH_ADDR_TABLE_SIZE,
 				  pep->htpr, pep->htpr_dma);
@@ -1545,7 +1546,6 @@ static int pxa168_eth_remove(struct platform_device *=
pdev)
 	mdiobus_unregister(pep->smi_bus);
 	mdiobus_free(pep->smi_bus);
 	unregister_netdev(dev);
-	cancel_work_sync(&pep->tx_timeout_task);
 	free_netdev(dev);
 	return 0;
 }

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--ZGiS0Q5IWpPtfppv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmBwLZMACgkQMOfwapXb+vKHeACcDyESzRhB6oVMJt2LOPVZC3oH
FZkAoK/uKgltga666cAWkBuOBlLkeNuf
=62ZG
-----END PGP SIGNATURE-----

--ZGiS0Q5IWpPtfppv--
