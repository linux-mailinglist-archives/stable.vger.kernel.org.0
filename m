Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D23EE5991C4
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 02:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233314AbiHSAdS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Aug 2022 20:33:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbiHSAdR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Aug 2022 20:33:17 -0400
Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [95.217.213.242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 984A1FD00;
        Thu, 18 Aug 2022 17:33:15 -0700 (PDT)
Received: from 213.219.160.184.adsl.dyn.edpnet.net ([213.219.160.184] helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1oOpwj-0000wB-3a; Fri, 19 Aug 2022 02:33:09 +0200
Received: from ben by deadeye with local (Exim 4.96)
        (envelope-from <ben@decadent.org.uk>)
        id 1oOpwi-000a0S-0N;
        Fri, 19 Aug 2022 02:33:08 +0200
Date:   Fri, 19 Aug 2022 02:33:08 +0200
From:   Ben Hutchings <ben@decadent.org.uk>
To:     x86@kernel.org
Cc:     linux-kernel@vger.kernel.org, 1017425@bugs.debian.org,
        =?iso-8859-1?Q?Martin-=C9ric?= Racine <martin-eric.racine@iki.fi>,
        stable@vger.kernel.org, regressions@lists.linux.dev,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Subject: [PATCH] x86/speculation: Avoid LFENCE in FILL_RETURN_BUFFER on CPUs
 that lack it
Message-ID: <Yv7aRJ/SvVhSdnSB@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="eT0M3T1LYdQ/WIvW"
Content-Disposition: inline
X-SA-Exim-Connect-IP: 213.219.160.184
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--eT0M3T1LYdQ/WIvW
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom: Ben Hutchings <benh@debian.org>

The mitigation for PBRSB includes adding LFENCE instructions to the
RSB filling sequence.  However, RSB filling is done on some older CPUs
that don't support the LFENCE instruction.

Define and use a BARRIER_NOSPEC macro which makes the LFENCE
conditional on X86_FEATURE_LFENCE_RDTSC, like the barrier_nospec()
macro defined for C code in <asm/barrier.h>.

Reported-by: Martin-=C9ric Racine <martin-eric.racine@iki.fi>
References: https://bugs.debian.org/1017425
Cc: stable@vger.kernel.org
Cc: regressions@lists.linux.dev
Cc: Daniel Sneddon <daniel.sneddon@linux.intel.com>
Cc: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Fixes: 2b1299322016 ("x86/speculation: Add RSB VM Exit protections")
Fixes: ba6e31af2be9 ("x86/speculation: Add LFENCE to RSB fill sequence")
Signed-off-by: Ben Hutchings <benh@debian.org>
---
Re-sending this with properly matched From address and server.
Apologies if you got 2 copies.

Ben.

 arch/x86/include/asm/nospec-branch.h | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/no=
spec-branch.h
index e64fd20778b6..b1029fd88474 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -34,6 +34,11 @@
=20
 #define RSB_CLEAR_LOOPS		32	/* To forcibly overwrite all entries */
=20
+#ifdef __ASSEMBLY__
+
+/* Prevent speculative execution past this barrier. */
+#define BARRIER_NOSPEC ALTERNATIVE "", "lfence", X86_FEATURE_LFENCE_RDTSC
+
 /*
  * Google experimented with loop-unrolling and this turned out to be
  * the optimal version - two calls, each with their own speculation
@@ -62,9 +67,7 @@
 	dec	reg;				\
 	jnz	771b;				\
 	/* barrier for jnz misprediction */	\
-	lfence;
-
-#ifdef __ASSEMBLY__
+	BARRIER_NOSPEC;
=20
 /*
  * This should be used immediately before an indirect jump/call. It tells
@@ -138,7 +141,7 @@
 	int3
 .Lunbalanced_ret_guard_\@:
 	add $(BITS_PER_LONG/8), %_ASM_SP
-	lfence
+	BARRIER_NOSPEC
 .endm
=20
  /*

--eT0M3T1LYdQ/WIvW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmL+2j0ACgkQ57/I7JWG
EQlPgA/+JoIOscO32lmTqexszlIn0F8EUMhfZfCh6h3mSgt0w8B1r4oBmEZTs9x5
HOHjeG0ZtdQvTKm10bCn2eCQq9xhH35m/OSNoysS64lFsQLyKmvXoV2U36nvxSnu
S7Dd0pt1Mgxs6o7+l/Gxhd1Jva6JagwjZjcOe3cPmcMtgbBZfPsmAofkSbq/89u4
iBeUm7YE5i7zRB5DZWHbMs+GIEGdyRplu1u7pYxRSg9XQg/zSdNdS02c5v8/PLx2
NgTGVR+t858WG791oTNXqkV1SG1s3LNuimJej155QCxyMNrJgAqre713cv9x5uEA
tU/VRZdPoYkee/L6d31p77C9+BV1PD2wy1pUFVBEvXV7cbDXvpXNjb5ZRAHPSBIa
1LBP1jrvCfeq7r4qQPIjIU5T8mU6ClJKkHLnf0ZjFwDvyNOEHy9dlH5ShjYy/oFX
Wedrbb7Y/sk39fxF5km0ns8gL/s689HbT1quEbqE2NhjfurOlSTuejwE4kZv8+O9
OTvzIPOoM0rjNZOWKn89zLwSygZxJeEczWiA6dml6vuqdU9p0TAI5b7DCvbcr71J
KziLwMJAGHIik+FYKS34tKsQaHTUIIbgNV3H1GLZnQrcYH0zfSDvO0q+X8bVcSWB
5k23Kkd4wwcu/WEVBSAIkiMoHmQrxUauVOcIDBXOoi0je9B67kQ=
=/q8V
-----END PGP SIGNATURE-----

--eT0M3T1LYdQ/WIvW--
