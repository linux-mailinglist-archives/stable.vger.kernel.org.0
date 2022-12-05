Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA536436E2
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 22:31:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbiLEVba (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 16:31:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbiLEVb3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 16:31:29 -0500
Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [95.217.213.242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF9712496B
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 13:31:27 -0800 (PST)
Received: from 213.219.160.184.adsl.dyn.edpnet.net ([213.219.160.184] helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1p2J3d-0006aq-9P; Mon, 05 Dec 2022 22:31:25 +0100
Received: from ben by deadeye with local (Exim 4.96)
        (envelope-from <ben@decadent.org.uk>)
        id 1p2J3c-000iZB-25;
        Mon, 05 Dec 2022 22:31:24 +0100
Date:   Mon, 5 Dec 2022 22:31:24 +0100
From:   Ben Hutchings <ben@decadent.org.uk>
To:     stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Suleiman Souhlal <suleiman@google.com>
Subject: [PATCH 4.19] Revert "x86/speculation: Change FILL_RETURN_BUFFER to
 work with objtool"
Message-ID: <Y45jLPqv/0fJ+rmk@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="g21yOQZJJDOCAgxS"
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


--g21yOQZJJDOCAgxS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

This reverts commit 9f3330d4930e034d84ee6561fbfb098433ff0ab9, which
was commit 089dd8e53126ebaf506e2dc0bf89d652c36bfc12 upstream.

The necessary changes to objtool have not been backported to 4.19.
Backporting this commit alone only added build warnings.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/include/asm/nospec-branch.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/no=
spec-branch.h
index 64b086c47b4a..0f99dda233a5 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -4,13 +4,11 @@
 #define _ASM_X86_NOSPEC_BRANCH_H_
=20
 #include <linux/static_key.h>
-#include <linux/frame.h>
=20
 #include <asm/alternative.h>
 #include <asm/alternative-asm.h>
 #include <asm/cpufeatures.h>
 #include <asm/msr-index.h>
-#include <asm/unwind_hints.h>
 #include <asm/percpu.h>
=20
 /*
@@ -54,9 +52,9 @@
 	lfence;					\
 	jmp	775b;				\
 774:						\
-	add	$(BITS_PER_LONG/8) * 2, sp;	\
 	dec	reg;				\
 	jnz	771b;				\
+	add	$(BITS_PER_LONG/8) * nr, sp;	\
 	/* barrier for jnz misprediction */	\
 	lfence;
 #else
@@ -167,8 +165,10 @@
   * monstrosity above, manually.
   */
 .macro FILL_RETURN_BUFFER reg:req nr:req ftr:req
-	ALTERNATIVE "jmp .Lskip_rsb_\@", "", \ftr
-	__FILL_RETURN_BUFFER(\reg,\nr,%_ASM_SP)
+	ANNOTATE_NOSPEC_ALTERNATIVE
+	ALTERNATIVE "jmp .Lskip_rsb_\@",				\
+		__stringify(__FILL_RETURN_BUFFER(\reg,\nr,%_ASM_SP))	\
+		\ftr
 .Lskip_rsb_\@:
 .endm
=20

--g21yOQZJJDOCAgxS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmOOYygACgkQ57/I7JWG
EQl/SxAAolpD1BA1igQJ+ujE/aIJquvnQdFKo2bTmyX1tmXz6M54IOEGcw9AwSLR
Xy8AJkGC4kWi1dxt/e3EqRVWzf67D0T2PoaiJ64mZlSv5zHjRsvYTKGCkUpE8WjF
YVT6mkEzMlNSYAHnf3EoHX8j5MVIDnc+Dl+Lm1RWJndJczKuWbcw6HoCy4wh3+3p
8Pq/lNqxw+gA1HCHSEYsyp+GXFOfglPVf6NtKubWRwL9ffj2f2V2vuSJPG4D9p1z
qRrLLZ3UxXNpm0rid26evTyzS4ZoFKkXYyNvsRA07oQFUrdca9r/ijiqf5zfgzPz
Bxei0gbdUERJhWXZfwpRQBQLqmA7tyGWDOe2uwmkY3N++FpFAbhT7koR8MlN7cbJ
fTEJ/Iqyr2SDViAL7vgfHCn7Yvvxa44MeaLo0oyY6tJ+9CRUwHaPAbFBU24KbhG6
M4Mhtz9Hh3SO35h4BMwlmfp0oGttP7yVYuE8x5uTF6cOdnzMl/6b6xRvav8t7Msg
sKSXddvrSrZUQ7gRQcRA75lMCo/IxcOw5Nb2KqRzKPCM8bG1V+6VpZLrHggZ0i6S
3Xo/MGptLjKygTgGGDkg+4pxEwYPJIQrr+EsXqqT64SDxPiw/rwY55D4MUD9HBXc
DZbixA+dFRGVdFrG67CXjQy3x6ExJrUj8v1oe7bCbcctvJ/uaRU=
=NZdN
-----END PGP SIGNATURE-----

--g21yOQZJJDOCAgxS--
