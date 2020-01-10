Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA0C1136B98
	for <lists+stable@lfdr.de>; Fri, 10 Jan 2020 12:00:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727455AbgAJLAg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jan 2020 06:00:36 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:48576 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727537AbgAJLAf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jan 2020 06:00:35 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id EF8B91C25B1; Fri, 10 Jan 2020 12:00:33 +0100 (CET)
Date:   Fri, 10 Jan 2020 12:00:33 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 118/219] rfkill: allocate static minor
Message-ID: <20200110110033.GA11563@amd>
References: <20191229162508.458551679@linuxfoundation.org>
 <20191229162526.353368525@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="tThc/1wpZn/ma/RB"
Content-Disposition: inline
In-Reply-To: <20191229162526.353368525@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun 2019-12-29 18:18:40, Greg Kroah-Hartman wrote:
> From: Marcel Holtmann <marcel@holtmann.org>
>=20
> [ Upstream commit 8670b2b8b029a6650d133486be9d2ace146fd29a ]
>=20
> udev has a feature of creating /dev/<node> device-nodes if it finds
> a devnode:<node> modalias. This allows for auto-loading of modules that
> provide the node. This requires to use a statically allocated minor
> number for misc character devices.
>=20
> However, rfkill uses dynamic minor numbers and prevents auto-loading
> of the module. So allocate the next static misc minor number and use
> it for rfkill.

Is this good idea for stable?

I don't see this major/minor allocated in devices.txt in
mainline. Should something like this be added?

Signed-off-by: Pavel Machek <pavel@denx.de>

diff --git a/Documentation/admin-guide/devices.txt b/Documentation/admin-gu=
ide/devices.txt
index 1c5d2281efc9..aa888a350df8 100644
--- a/Documentation/admin-guide/devices.txt
+++ b/Documentation/admin-guide/devices.txt
@@ -375,8 +375,9 @@
 		239 =3D /dev/uhid		User-space I/O driver support for HID subsystem
 		240 =3D /dev/userio	Serio driver testing device
 		241 =3D /dev/vhost-vsock	Host kernel driver for virtio vsock
+		242 =3D /dev/rfkill	Turning off radio transmissions (rfkill)
=20
-		242-254			Reserved for local use
+		243-254			Reserved for local use
 		255			Reserved for MISC_DYNAMIC_MINOR
=20
   11 char	Raw keyboard device	(Linux/SPARC only)


--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--tThc/1wpZn/ma/RB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl4YWVEACgkQMOfwapXb+vKgbwCfaxl2Th8eHRr/0sPSWcX1vNAW
BisAnRRhvoGsuElHI0g8boMeSvbzTo7F
=66Dr
-----END PGP SIGNATURE-----

--tThc/1wpZn/ma/RB--
