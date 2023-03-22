Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4671E6C5356
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 19:11:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbjCVSLu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 14:11:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjCVSLt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 14:11:49 -0400
Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [95.217.213.242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E550A64A81;
        Wed, 22 Mar 2023 11:11:47 -0700 (PDT)
Received: from [213.219.167.32] (helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1pf2w5-0004fX-QF; Wed, 22 Mar 2023 19:11:45 +0100
Received: from ben by deadeye with local (Exim 4.96)
        (envelope-from <ben@decadent.org.uk>)
        id 1pf2w5-006OWH-12;
        Wed, 22 Mar 2023 19:11:45 +0100
Date:   Wed, 22 Mar 2023 19:11:45 +0100
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     linux-kbuild@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] modpost: Fix processing of CRCs on 32-bit build machines
Message-ID: <ZBtE4XlqCXjFELHR@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="+8Al0RIa47xRJ8Lx"
Content-Disposition: inline
X-SA-Exim-Connect-IP: 213.219.167.32
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--+8Al0RIa47xRJ8Lx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

modpost now reads CRCs from .*.cmd files, parsing them using strtol().
This is inconsistent with its parsing of Module.symvers and with their
definition as *unsigned* 32-bit values.

strtol() clamps values to [LONG_MIN, LONG_MAX], and when building on a
32-bit system this changes all CRCs >=3D 0x80000000 to be 0x7fffffff.

Change extract_crcs_for_object() to use strtoul() instead.

Cc: stable@vger.kernel.org
Fixes: f292d875d0dc ("modpost: extract symbol versions from *.cmd files")
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 scripts/mod/modpost.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index efff8078e395..9466b6a2abae 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1733,7 +1733,7 @@ static void extract_crcs_for_object(const char *objec=
t, struct module *mod)
 		if (!isdigit(*p))
 			continue;	/* skip this line */
=20
-		crc =3D strtol(p, &p, 0);
+		crc =3D strtoul(p, &p, 0);
 		if (*p !=3D '\n')
 			continue;	/* skip this line */
=20

--+8Al0RIa47xRJ8Lx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmQbRNwACgkQ57/I7JWG
EQksyRAAj5xtJaqdL5zvcu65njrnJ1asDS3QKkvteeavErdiLljDEt88WPIUeEe0
jKMj9TfUjZtuKMvIHSB7jO6egDkPEHR+bmI/Z5aC+yUmfB6GVvfq44PnG2ydGZ0n
CPJn6LZtceD+ypnT1TNv9MuGHSopa9HOQdWNA8OaiGkfYJTRIxk1RADwVb4d9ezF
1pl0jEk4/twEGjYlE4bvKnNdpcXDEnOr4XEAIxIp6tQfE0U13baDb7uegsIcIYuf
oucu7t86GehJmR995xX0Cmpu3Fo2CWh1beCLrHsM5IlGVtzqSDXtRpKzIiIJ3JzN
FVYvCPJSfEUyAmiacSNoDHRViVxFGa2B+gCdttdAa4kSxfL+ewoQZPmQmlr4mVFO
Gd0Xzd4Kt2834HF+jKYes0rnPBreCYElr0vHabQZtyOKKgWApXIOydk+y0yC3M/C
E/b71r4+kbun611HkmeCpPtF0qhmBHGjn685E7DAmT1K4vLVoP6GghqLU1BtB/QI
XrhlSPx1ZG438HdvfLK6ApwsOKvUsFYZA5CtdDEwZE/MMyH8QD6FAxBPVR2J04S9
XB4Ju24qXIFtrgMPtBlXyhUCwTXt9tbIeQ3/h8L8pQIfT+LlLuCYdm/JQIpZoZ9w
RWZ3FlWW8wtEp2Rd/fwwuqM+NBxTU4OARKIFwu34gtBsCFVNU+A=
=94ea
-----END PGP SIGNATURE-----

--+8Al0RIa47xRJ8Lx--
