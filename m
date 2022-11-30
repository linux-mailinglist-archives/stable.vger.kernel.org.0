Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 742ED63E5DB
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 00:55:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbiK3XzY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 18:55:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbiK3XzW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 18:55:22 -0500
Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [95.217.213.242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93D4127B3C
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 15:55:21 -0800 (PST)
Received: from 213.219.160.184.adsl.dyn.edpnet.net ([213.219.160.184] helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1p0Wko-0002E0-VY; Thu, 01 Dec 2022 00:44:38 +0100
Received: from ben by deadeye with local (Exim 4.96)
        (envelope-from <ben@decadent.org.uk>)
        id 1p0Wko-0009yJ-18;
        Thu, 01 Dec 2022 00:44:38 +0100
Date:   Thu, 1 Dec 2022 00:44:38 +0100
From:   Ben Hutchings <ben@decadent.org.uk>
To:     stable@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: [PATCH 4.19] efi: random: Properly limit the size of the random seed
Message-ID: <Y4fq5mGUbcKV8VwM@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="dv+fgnZNBLRrap/c"
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


--dv+fgnZNBLRrap/c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Commit be36f9e7517e ("efi: READ_ONCE rng seed size before munmap")
added a READ_ONCE() and also changed the call to
add_bootloader_randomness() to use the local size variable.  Neither
of these changes was actually needed and this was not backported to
the 4.19 stable branch.

Commit 161a438d730d ("efi: random: reduce seed size to 32 bytes")
reverted the addition of READ_ONCE() and added a limit to the value of
size.  This depends on the earlier commit, because size can now differ
=66rom seed->size, but it was wrongly backported to the 4.19 stable
branch by itself.

Apply the missing change to the add_bootloader_randomness() parameter
(except that here we are still using add_device_randomness()).

Fixes: 0513592520ae ("efi: random: reduce seed size to 32 bytes")
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/firmware/efi/efi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index f0ef2643b70e..2bbc2289fe09 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -566,7 +566,7 @@ int __init efi_config_parse_tables(void *config_tables,=
 int count, int sz,
 					      sizeof(*seed) + size);
 			if (seed !=3D NULL) {
 				pr_notice("seeding entropy pool\n");
-				add_device_randomness(seed->bits, seed->size);
+				add_device_randomness(seed->bits, size);
 				early_memunmap(seed, sizeof(*seed) + size);
 			} else {
 				pr_err("Could not map UEFI random seed!\n");

--dv+fgnZNBLRrap/c
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmOH6uIACgkQ57/I7JWG
EQnr1hAAy+8bivgmsQ8f23fOhcOAJZBGsf6YEeyqnccMqc5a/HikuTk/mRECv5F7
KlEOwDSHntn9SvAcPHzocOH9S/vJRzS8rTQ5ugeIz36J7qxQ5MhkUUVXlJgKYVUS
kfbbfPXyS7gGU0gK1DAFk3T0idsme61reWEJX1kokVMCanOpzHBxHgMczqYgY59K
q+T4JkDY+22QNhrdbBGZFplZkEZI7nfVWiH4HCd9NfU3NZIt+gOjtL1h9O5OGpGY
TYK+Yn6F/UoXTHCrPCLO0bJlyL+kn65fEvSGCxAcCSTwLxPUy5PNA1RjqBy2COco
WxT7wRBpvGDGVY07gFW16qnTjmG+f5zZWBvRAczj6z6zOgvesHexmeM5Xq+Unl8T
AqymAI0s9KFVgCWMhxpF/+5+QYsMITz4N63OMJ5B4A8ZD6AQiJlsVjr7pPKUR17b
yKI+aVie7jF0lBQNfMVJOVVySbszcrTyk2A/7NbK7odqxQtifZYem9DJh1FAPHEr
jr2J0/Y6hX5dLtfd7N3zYI39NjtdB9LYBMkAc2wUuO/wTeK+bCiZJgZM9K4NniSg
5xvbPEP/V4iHSM4AQ8SuXHZdSVc5M3S0LQT5aTj9rS56QdnbudeLrexujAqwgwOw
eyQDG6rCqyaMvjKaf2Ch5ymCrQ1Xk0GoWrkQ0paPqFEv3eWpSas=
=PUX8
-----END PGP SIGNATURE-----

--dv+fgnZNBLRrap/c--
