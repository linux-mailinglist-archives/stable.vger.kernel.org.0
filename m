Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D370A1EC171
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 19:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726037AbgFBRyX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jun 2020 13:54:23 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55138 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726019AbgFBRyX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jun 2020 13:54:23 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jgB7C-0003Wg-HH; Tue, 02 Jun 2020 18:54:18 +0100
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1jgB7C-000E2T-3A; Tue, 02 Jun 2020 18:54:18 +0100
Date:   Tue, 2 Jun 2020 18:54:18 +0100
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     yangerkun <yangerkun@huawei.com>, stable@vger.kernel.org
Subject: [PATCH 4.4,4.9 1/2] slcan: Fix double-free on slcan_open() error path
Message-ID: <20200602175418.GA53769@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="IS0zKkzwUGydFO0o"
Content-Disposition: inline
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Commit 9ebd796e2400 ("can: slcan: Fix use-after-free Read in
slcan_open") was incorrectly backported to 4.4 and 4.9 stable
branches.

Since they do not have commit cf124db566e6 ("net: Fix inconsistent
teardown and release of private netdev state."), the destructor
function slc_free_netdev() is already responsible for calling
free_netdev() and slcan_open() must not call both of them.

yangerkun previously fixed the same bug in slip.

Fixes: ce624b2089ea ("can: slcan: Fix use-after-free Read in slcan_open") #=
 4.4
Fixes: f59604a80fa4 ("slcan: not call free_netdev before rtnl_unlock ...") =
# 4.4
Fixes: 56635a1e6ffb ("can: slcan: Fix use-after-free Read in slcan_open") #=
 4.9
Fixes: a1c9b23142ac ("slcan: not call free_netdev before rtnl_unlock ...") =
# 4.9
Cc: yangerkun <yangerkun@huawei.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/can/slcan.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
index d0435c7631ff..9c938f9892b2 100644
--- a/drivers/net/can/slcan.c
+++ b/drivers/net/can/slcan.c
@@ -618,10 +618,9 @@ static int slcan_open(struct tty_struct *tty)
 	sl->tty =3D NULL;
 	tty->disc_data =3D NULL;
 	clear_bit(SLF_INUSE, &sl->flags);
-	slc_free_netdev(sl->dev);
 	/* do not call free_netdev before rtnl_unlock */
 	rtnl_unlock();
-	free_netdev(sl->dev);
+	slc_free_netdev(sl->dev);
 	return err;
=20
 err_exit:


--IS0zKkzwUGydFO0o
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl7WkkMACgkQ57/I7JWG
EQmGqQ//RY8dBWfn4RY+DrJuyu5tj+xmc92/y8sFtbNO4PtgBD89cgA9ssDsdtJp
uaRmQyTMIl4yMNnIOJdHIIboRhWx++L5uTDhMIv691GRf4Lx+gyeRzWWNb/6pa7s
QG2gZRX73EjVkS5lLUT++Xzu2G6Xga0bz93Dep0IwMurX7yMPJyGTLe/i40F2NON
8Mt+x792vm3e1lFBVkKZ+zzx42iQ2rCcJoa3gvXiCgu0uDSeOUZA7nQcDfUwaOAG
EfYo8p0NNCnyYjrn4QDXk2b3ZWogBgE8BES6aOV8H1jqBcOk6p2ni+IAwBLALSB9
YIUxQJk+mqNfF7zT2nPqHUE0H93X+50kZLAUPuk9K0KihbEfgFtAuiqs8ericwfb
836xeC4yJkPrCN79hGJUYkWuWGTTmdPMwppU1HVvGG+TofZgFrYVDuJs/JcHrurt
Ui6LNB25Qis/16tOjpHVE2DowMgoU1nGVzH+0dcIxlvXk6h4PalOhLkA8E5eDear
2R5msl4TK0B6aE86B1slhce4NzSgNS7BZASA+befNE/Lby/LgCxcdjuOD+m1QJ44
WCw0pgsEIsqABvPMJ08lv2BwPpo8xwsLMAuhfOZvpIMDT/S+7UPeXtoy/2dlqVdL
yqeGs41t1MUPKi+ISWGahynlP89OyUarQsdvKJl1oCW/lu+UjSw=
=S5WA
-----END PGP SIGNATURE-----

--IS0zKkzwUGydFO0o--
