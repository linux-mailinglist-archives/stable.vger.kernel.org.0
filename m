Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6798649886F
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 19:35:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244133AbiAXSfd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 13:35:33 -0500
Received: from maynard.decadent.org.uk ([95.217.213.242]:42504 "EHLO
        maynard.decadent.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245079AbiAXSfc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 13:35:32 -0500
Received: from 168.7-181-91.adsl-dyn.isp.belgacom.be ([91.181.7.168] helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1nC4Bd-0007Fg-Va; Mon, 24 Jan 2022 19:35:29 +0100
Received: from ben by deadeye with local (Exim 4.95)
        (envelope-from <ben@decadent.org.uk>)
        id 1nC4Bd-00A1zW-HC;
        Mon, 24 Jan 2022 19:35:29 +0100
Date:   Mon, 24 Jan 2022 19:35:29 +0100
From:   Ben Hutchings <ben@decadent.org.uk>
To:     stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Luo Likang <luolikang@nsfocus.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 4.9] media: firewire: firedtv-avc: fix a buffer overflow in
 avc_ca_pmt()
Message-ID: <Ye7xcRkdnlSW+Oy2@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="gV35ZE8pv1mmxsa0"
Content-Disposition: inline
X-SA-Exim-Connect-IP: 91.181.7.168
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--gV35ZE8pv1mmxsa0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom: Dan Carpenter <dan.carpenter@oracle.com>

commit 35d2969ea3c7d32aee78066b1f3cf61a0d935a4e upstream.

The bounds checking in avc_ca_pmt() is not strict enough.  It should
be checking "read_pos + 4" because it's reading 5 bytes.  If the
"es_info_length" is non-zero then it reads a 6th byte so there needs to
be an additional check for that.

I also added checks for the "write_pos".  I don't think these are
required because "read_pos" and "write_pos" are tied together so
checking one ought to be enough.  But they make the code easier to
understand for me.  The check on write_pos is:

	if (write_pos + 4 >=3D sizeof(c->operand) - 4) {

The first "+ 4" is because we're writing 5 bytes and the last " - 4"
is to leave space for the CRC.

The other problem is that "length" can be invalid.  It comes from
"data_length" in fdtv_ca_pmt().

Cc: stable@vger.kernel.org
Reported-by: Luo Likang <luolikang@nsfocus.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
[bwh: Backported to 4.9: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/firewire/firedtv-avc.c | 14 +++++++++++---
 drivers/media/firewire/firedtv-ci.c  |  2 ++
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/media/firewire/firedtv-avc.c b/drivers/media/firewire/=
firedtv-avc.c
index 280b5ffea592..3a373711f5ad 100644
--- a/drivers/media/firewire/firedtv-avc.c
+++ b/drivers/media/firewire/firedtv-avc.c
@@ -1169,7 +1169,11 @@ int avc_ca_pmt(struct firedtv *fdtv, char *msg, int =
length)
 		read_pos +=3D program_info_length;
 		write_pos +=3D program_info_length;
 	}
-	while (read_pos < length) {
+	while (read_pos + 4 < length) {
+		if (write_pos + 4 >=3D sizeof(c->operand) - 4) {
+			ret =3D -EINVAL;
+			goto out;
+		}
 		c->operand[write_pos++] =3D msg[read_pos++];
 		c->operand[write_pos++] =3D msg[read_pos++];
 		c->operand[write_pos++] =3D msg[read_pos++];
@@ -1181,13 +1185,17 @@ int avc_ca_pmt(struct firedtv *fdtv, char *msg, int=
 length)
 		c->operand[write_pos++] =3D es_info_length >> 8;
 		c->operand[write_pos++] =3D es_info_length & 0xff;
 		if (es_info_length > 0) {
+			if (read_pos >=3D length) {
+				ret =3D -EINVAL;
+				goto out;
+			}
 			pmt_cmd_id =3D msg[read_pos++];
 			if (pmt_cmd_id !=3D 1 && pmt_cmd_id !=3D 4)
 				dev_err(fdtv->device, "invalid pmt_cmd_id %d "
 					"at stream level\n", pmt_cmd_id);
=20
-			if (es_info_length > sizeof(c->operand) - 4 -
-					     write_pos) {
+			if (es_info_length > sizeof(c->operand) - 4 - write_pos ||
+			    es_info_length > length - read_pos) {
 				ret =3D -EINVAL;
 				goto out;
 			}
diff --git a/drivers/media/firewire/firedtv-ci.c b/drivers/media/firewire/f=
iredtv-ci.c
index edbb30fdd9d9..93fb4b7312af 100644
--- a/drivers/media/firewire/firedtv-ci.c
+++ b/drivers/media/firewire/firedtv-ci.c
@@ -138,6 +138,8 @@ static int fdtv_ca_pmt(struct firedtv *fdtv, void *arg)
 	} else {
 		data_length =3D msg->msg[3];
 	}
+	if (data_length > sizeof(msg->msg) - data_pos)
+		return -EINVAL;
=20
 	return avc_ca_pmt(fdtv, &msg->msg[data_pos], data_length);
 }

--gV35ZE8pv1mmxsa0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmHu8XEACgkQ57/I7JWG
EQnkYg//Rwx/9Y9U7ASf/ASiFGMGup4lYhTJVre0XgBbD+SIXKiXEyf4IOBMUPda
+nHA0Uq9RFpfTNf5zD7uMMkoLfdz4fPXcKBB/XyKv7ozc7Xs5fflfTOOSSPtO14Z
6SliMSK4xrsnH2BbXTIHwmDSij438U1zUgQClRfvUqhe/UQCztBKu5nwIJYswA3m
XYfIf3LnSDkcxail4A+sLKl6EdECmHMV2a0UcM57pJfDBRmReVgonFO0CTsSas3k
XQ7FDCuUDu2GN6RJyaWT2Rz/z5MN0WOY5KWSg3tlNSp6YGSTZB1UaV2gKQy9ddb3
F33u3uuAhjQQlm8F4QXasyWQZq6SktNTUnaQ39kwvgnzpfwYociCLK5ldgOaJArR
ivawEFLKZd0CPzKK2U4it3O9grf7TFwskkJrZvkXQ1l20KhgevFBOWRZ3XdpaoT7
/01Cm5TNIwwX4nIj6J/M6Ck66RCPFo1E6oHdcPNztMMRxQL6KOtNVJnJ001tAblZ
SKBdzUXu4c5OyCZD5Lxhaa2wO8Sdmy02m8dSLyF2dc0PXlGj/YxCK3B5lh7znGHN
ZP1ay4jSWX7FNFcP0WbNJifJMD6Rj8DOTW2LnyPt2rtkpNggld/VfSCjW+aCZ0Gf
1FFRXc4Hr779jQXALn9COBa8UWDgabOIDD74vKPfnISQ8SKMbuI=
=v65w
-----END PGP SIGNATURE-----

--gV35ZE8pv1mmxsa0--
