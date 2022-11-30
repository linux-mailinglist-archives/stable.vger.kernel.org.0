Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B84F563E5B8
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 00:47:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbiK3Xr1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 18:47:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbiK3Xr0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 18:47:26 -0500
X-Greylist: delayed 163 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 30 Nov 2022 15:47:25 PST
Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [95.217.213.242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC7D058BCE
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 15:47:24 -0800 (PST)
Received: from 213.219.160.184.adsl.dyn.edpnet.net ([213.219.160.184] helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1p0WnT-0002EM-1p; Thu, 01 Dec 2022 00:47:23 +0100
Received: from ben by deadeye with local (Exim 4.96)
        (envelope-from <ben@decadent.org.uk>)
        id 1p0WnS-000A4s-1N;
        Thu, 01 Dec 2022 00:47:22 +0100
Date:   Thu, 1 Dec 2022 00:47:22 +0100
From:   Ben Hutchings <ben@decadent.org.uk>
To:     stable@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: [PATCH 4.14] efi: random: Properly limit the size of the random seed
Message-ID: <Y4frikbdKtF5V1WU@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="BGukgjG1AEe0yX1O"
Content-Disposition: inline
X-SA-Exim-Connect-IP: 213.219.160.184
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--BGukgjG1AEe0yX1O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Commit be36f9e7517e ("efi: READ_ONCE rng seed size before munmap")
added a READ_ONCE() and also changed the call to
add_bootloader_randomness() to use the local size variable.  Neither
of these changes was actually needed and this was not backported to
the 4.14 stable branch.

Commit 161a438d730d ("efi: random: reduce seed size to 32 bytes")
reverted the addition of READ_ONCE() and added a limit to the value of
size.  This depends on the earlier commit, because size can now differ
=66rom seed->size, but it was wrongly backported to the 4.14 stable
branch by itself.

Apply the missing change to the add_bootloader_randomness() parameter
(except that here we are still using add_device_randomness()).

Fixes: 700485f70e50 ("efi: random: reduce seed size to 32 bytes")
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/firmware/efi/efi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index ed981f5e29ae..cc64869d8420 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -541,7 +541,7 @@ int __init efi_config_parse_tables(void *config_tables,=
 int count, int sz,
 			seed =3D early_memremap(efi.rng_seed,
 					      sizeof(*seed) + size);
 			if (seed !=3D NULL) {
-				add_device_randomness(seed->bits, seed->size);
+				add_device_randomness(seed->bits, size);
 				early_memunmap(seed, sizeof(*seed) + size);
 				pr_notice("seeding entropy pool\n");
 			} else {

--BGukgjG1AEe0yX1O
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmOH64oACgkQ57/I7JWG
EQn4JQ/+IyKKxFWsyBQb5pfxrOnaq1c04qAohi3O3/+vLJV5kzPjillq6rSXjASa
qbXa8pYe6ASTyyLWZbUY27yJUK9y7o5wxQ3SHV6/p3gL9VcyEzYQyZJYWY7cb/bP
99Z1Ci6AORcvSSMPMvAxgsVW6qmwakayDI/cD8MoQ7IV6XSUr515iiGrPdLq1obs
ig4fgKGw/vKJ1gACa3rBAfhh9ppXlqvV4o4eN2nuoutvJjwA7oq/IXOIhguKBnux
woXzqQ35cCjnAP4UxVYPOq/nBZIoguops32vMhLfUfwXAItYBlyyQV4LEhS8mFKB
R6tt/hXrMFKi0yLu7SBKmNaNy7+USLS4Nz3+qOSarrrx8DKXfnK32BiSUgQy5vQ9
AhOK8KGPSIgU7OUkmnHtb+UTwkCxXfFTDeizp4ANNtp/aKok1K+xodeHar2/s6Ug
IwOafa7s6F121+FNRfzYQvM2wIDawjHzdlo4BYJwl7WwLnkov9WgMRGs32DB+ATZ
stzimexVt/E3MK/3eGWVuhDIyUjt0P+cBCISgJWQpSWOgWl3w7nTT+OGLvGcy9z9
1AcWJGK9zLGcmf48/Hfm4kQKwUubb0AHlZ9BmmZkzCViFxv7avUvR7r/MqotEJQr
P+weAVEOTUwa6y1YfcGZB4nVt935NiNCSiIZF8yH9M4apAxrxGQ=
=ECBi
-----END PGP SIGNATURE-----

--BGukgjG1AEe0yX1O--
