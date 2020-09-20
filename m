Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 402DB2712ED
	for <lists+stable@lfdr.de>; Sun, 20 Sep 2020 10:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbgITIi0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Sep 2020 04:38:26 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:59824 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbgITIi0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Sep 2020 04:38:26 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id BE7501C0B94; Sun, 20 Sep 2020 10:28:39 +0200 (CEST)
Date:   Sun, 20 Sep 2020 10:28:38 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, dan.j.williams@intel.com,
        vkoul@kernel.org, ludovic.desroches@microchip.com,
        stable@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: [PATCH 4.19] dmaengine: at_hdmac: Fix memory leak
Message-ID: <20200920082838.GA813@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="XsQoSWH+UP9D9v3l"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


This fixes memory leak in at_hdmac. Mainline does not have the same
problem.

Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index 86427f6ba78c..0847b2055857 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -1714,8 +1714,10 @@ static struct dma_chan *at_dma_xlate(struct of_phand=
le_args *dma_spec,
 	atslave->dma_dev =3D &dmac_pdev->dev;
=20
 	chan =3D dma_request_channel(mask, at_dma_filter, atslave);
-	if (!chan)
+	if (!chan) {
+		kfree(atslave);
 		return NULL;
+	}
=20
 	atchan =3D to_at_dma_chan(chan);
 	atchan->per_if =3D dma_spec->args[0] & 0xff;

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--XsQoSWH+UP9D9v3l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl9nErYACgkQMOfwapXb+vI9BACgw3g6qlJ65PvDed0Jfrfa0voB
nFMAoIHRW+dHA2qeUSnIg4WPsR58F/K2
=U2YD
-----END PGP SIGNATURE-----

--XsQoSWH+UP9D9v3l--
