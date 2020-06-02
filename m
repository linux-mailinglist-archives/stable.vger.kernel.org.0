Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB8E1EC172
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 19:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbgFBRz2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jun 2020 13:55:28 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55158 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726019AbgFBRz2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jun 2020 13:55:28 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jgB8H-0003ic-Uk; Tue, 02 Jun 2020 18:55:26 +0100
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1jgB8H-000E3N-Hx; Tue, 02 Jun 2020 18:55:25 +0100
Date:   Tue, 2 Jun 2020 18:55:25 +0100
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     yangerkun <yangerkun@huawei.com>, stable@vger.kernel.org
Subject: [PATCH 4.4,4.9 2/2] slip: not call free_netdev before rtnl_unlock in
 slip_open
Message-ID: <20200602175525.GB53769@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="dTy3Mrz/UPE2dbVg"
Content-Disposition: inline
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--dTy3Mrz/UPE2dbVg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom: yangerkun <yangerkun@huawei.com>

commit f596c87005f7b1baeb7d62d9a9e25d68c3dfae10 upstream.

As the description before netdev_run_todo, we cannot call free_netdev
before rtnl_unlock, fix it by reorder the code.

Signed-off-by: yangerkun <yangerkun@huawei.com>
Reviewed-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Backported to <4.11: free_netdev() is called through sl_free_netdev()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/slip/slip.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/slip/slip.c b/drivers/net/slip/slip.c
index cc841126147e..f870396e05e1 100644
--- a/drivers/net/slip/slip.c
+++ b/drivers/net/slip/slip.c
@@ -867,7 +867,10 @@ static int slip_open(struct tty_struct *tty)
 	sl->tty =3D NULL;
 	tty->disc_data =3D NULL;
 	clear_bit(SLF_INUSE, &sl->flags);
+	/* do not call free_netdev before rtnl_unlock */
+	rtnl_unlock();
 	sl_free_netdev(sl->dev);
+	return err;
=20
 err_exit:
 	rtnl_unlock();

--dTy3Mrz/UPE2dbVg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl7Wko0ACgkQ57/I7JWG
EQl0zg//cc4iOCC9F8BPa/8LiMtfYAD/lConV5YWl6doEXG5AsQB5rI2Jbsbejc+
UzybWWdhj6Cb42EkZneXE/oma1gkhlZP4ZchJ9KhU/NoGJ4C3FZ1jLLEjIQGh8OG
6Bt8CMNlhBE9vo1/dcky4r4tAiOUyGcEGt1T0NUDOxkuYUN6tZyGznaoHqCa9Aad
ayMvOjUaNOOt6iKZOK/4LczU101WE+axVH4iLu7Vpf3MqDOVsNoVnDf+6NDkZbee
aZ4WXqew/TRvHTikrj697QM90EQPNO54aPmAnbKT8+Pzdy4yIyiKnlAmFYnXjMue
88CTFf4DG5d00nX8U4rdPqyQPot+EyOFWHOTY2g4/ocDMOCSX5e46TsRt4rrjxbm
yHwzn8PQ9OV2PU9PC1LLDLDXA6zy0j0N9+yQ+GhVrPhJ9Z9462LB3e0DXL2oAZcq
DPp7WXtzdMkVVN7Mefc6OqljOhtNzv/0utbbSA6KlEmRgaU1tUJGenWf30sRm1tX
T89zf77EcyhVv6yMcA8nhiDTQ71/84mURXyU3GtqPHpu72A0f2ezUuePboXAZIjB
yM3bwO5fPgzQEoVsPySFJOGihyZpTt2QXtaZmjV+EUEqo/mg+Iv6QFjMpTL0esR5
9vLyHAHoal0ydMWPmdPy2l/Td9jSKB0Xv2mlpCU8jTC6dkM8Gug=
=QGr7
-----END PGP SIGNATURE-----

--dTy3Mrz/UPE2dbVg--
