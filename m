Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7638249032
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 23:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgHRVfA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 17:35:00 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:44812 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726372AbgHRVe4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Aug 2020 17:34:56 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 748AC1C0BB8; Tue, 18 Aug 2020 23:34:54 +0200 (CEST)
Date:   Tue, 18 Aug 2020 23:34:53 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 073/168] media: firewire: Using uninitialized values
 in node_probe()
Message-ID: <20200818213453.GB25182@amd>
References: <20200817143733.692105228@linuxfoundation.org>
 <20200817143737.355562192@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="pvezYHf7grwyp3Bc"
Content-Disposition: inline
In-Reply-To: <20200817143737.355562192@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--pvezYHf7grwyp3Bc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Dan Carpenter <dan.carpenter@oracle.com>
>=20
> [ Upstream commit 2505a210fc126599013aec2be741df20aaacc490 ]
>=20
> If fw_csr_string() returns -ENOENT, then "name" is uninitialized.  So
> then the "strlen(model_names[i]) <=3D name_len" is true because strlen()
> is unsigned and -ENOENT is type promoted to a very high positive value.
> Then the "strncmp(name, model_names[i], name_len)" uses uninitialized
> data because "name" is uninitialized.

This causes memory leak, AFAICT.

Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
								Pavel

diff --git a/drivers/media/firewire/firedtv-fw.c b/drivers/media/firewire/f=
iredtv-fw.c
index eaf94b817dbc..2ac9d24d3f0c 100644
--- a/drivers/media/firewire/firedtv-fw.c
+++ b/drivers/media/firewire/firedtv-fw.c
@@ -271,8 +271,10 @@ static int node_probe(struct fw_unit *unit, const stru=
ct ieee1394_device_id *id)
=20
 	name_len =3D fw_csr_string(unit->directory, CSR_MODEL,
 				 name, sizeof(name));
-	if (name_len < 0)
-		return name_len;
+	if (name_len < 0) {
+		err =3D name_len;
+		goto fail_free;
+	}
 	for (i =3D ARRAY_SIZE(model_names); --i; )
 		if (strlen(model_names[i]) <=3D name_len &&
 		    strncmp(name, model_names[i], name_len) =3D=3D 0)



--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--pvezYHf7grwyp3Bc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl88SX0ACgkQMOfwapXb+vI6YQCglanJAWy5M2+yqIDcVnaJjLnA
cCcAnR5rfyY8Pk/j/uo1uVKXyK0zUtkw
=XDJf
-----END PGP SIGNATURE-----

--pvezYHf7grwyp3Bc--
