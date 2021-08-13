Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1DC3EB404
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 12:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239176AbhHMK3Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 06:29:24 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:55880 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240125AbhHMK3Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Aug 2021 06:29:16 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id DCBA01C0B76; Fri, 13 Aug 2021 12:28:40 +0200 (CEST)
Date:   Fri, 13 Aug 2021 12:28:40 +0200
From:   Pavel Machek <pavel@denx.de>
To:     stable@vger.kernel.org, yuehaibing@huawei.com
Subject: [PATCH 4.4 4.9 4.14 4.19 5.4 5.10] net: xilinx_emaclite: Do not
 print real IOMEM pointer
Message-ID: <20210813102840.GA31185@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom: YueHaibing <yuehaibing@huawei.com>

Commit d0d62baa7f505bd4c59cd169692ff07ec49dde37 upstream.

Printing kernel pointers is discouraged because they might leak kernel
memory layout.  This fixes smatch warning:

drivers/net/ethernet/xilinx/xilinx_emaclite.c:1191 xemaclite_of_probe() war=
n:
 argument 4 to %08lX specifier is cast from pointer

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>
---
 drivers/net/ethernet/xilinx/xilinx_emaclite.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/et=
hernet/xilinx/xilinx_emaclite.c
index 909a008f9927..26cd42bfef0c 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -1180,9 +1180,8 @@ static int xemaclite_of_probe(struct platform_device =
*ofdev)
 	}
=20
 	dev_info(dev,
-		 "Xilinx EmacLite at 0x%08X mapped to 0x%08X, irq=3D%d\n",
-		 (unsigned int __force)ndev->mem_start,
-		 (unsigned int __force)lp->base_addr, ndev->irq);
+		 "Xilinx EmacLite at 0x%08X mapped to 0x%p, irq=3D%d\n",
+		 (unsigned int __force)ndev->mem_start, lp->base_addr, ndev->irq);
 	return 0;
=20
 error:

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYRZJWAAKCRAw5/Bqldv6
8u1LAJ95gFcKSyMS+k/Tkr8v2q7CQ7mTJQCfRJN/tNWNF8FB9QVNuvZ4lSC4WvY=
=Garl
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
