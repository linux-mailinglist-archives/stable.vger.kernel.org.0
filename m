Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 994056437C0
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 23:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233037AbiLEWKr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 17:10:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233265AbiLEWKo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 17:10:44 -0500
Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [95.217.213.242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DEC21A38D
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 14:10:44 -0800 (PST)
Received: from 213.219.160.184.adsl.dyn.edpnet.net ([213.219.160.184] helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1p2Jfd-0006gw-LR; Mon, 05 Dec 2022 23:10:41 +0100
Received: from ben by deadeye with local (Exim 4.96)
        (envelope-from <ben@decadent.org.uk>)
        id 1p2Jfd-000jTA-09;
        Mon, 05 Dec 2022 23:10:41 +0100
Date:   Mon, 5 Dec 2022 23:10:41 +0100
From:   Ben Hutchings <ben@decadent.org.uk>
To:     stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Suleiman Souhlal <suleiman@google.com>
Subject: [PATCH 4.14 2/2] Revert "x86/speculation: Change FILL_RETURN_BUFFER
 to work with objtool"
Message-ID: <Y45sYZzXW9/fKPbz@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="pcQ3lfnBKmIllsrY"
Content-Disposition: inline
In-Reply-To: <Y45sM5Dg6Y6YQIBZ@decadent.org.uk>
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


--pcQ3lfnBKmIllsrY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

This reverts commit c95afe5bcad40e1f0292bfc0a625c4aa080cc971, which
was commit 089dd8e53126ebaf506e2dc0bf89d652c36bfc12 upstream.

The necessary changes to objtool have not been backported to 4.14.
Backporting this commit alone only added build warnings.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/include/asm/nospec-branch.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/no=
spec-branch.h
index d5d4927e7683..0cd3b0c74d05 100644
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

--pcQ3lfnBKmIllsrY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmOObGAACgkQ57/I7JWG
EQk9Yw//a98hWDZ6MGtPwq/PUl9OyyrMaWowZdyIOTtQz0wpAX7cuIvZushjbvb1
TK4ftm2IhuYDYxkCcAzTtjOxkIicVWJnbr1x9daKBlF+2wB0k9XE1LBieGrsrMYf
6YanIqthAkFIckhYMVi+P3Pa3/8IgQ7YDaM6s7zf0cVpkL2KIQABkB6uSOM03C9N
ONvFZQEN3n7jDNu4VUHOL3Q4eFH+2k+0C6BVs3h469fTwEeMJj9ThGXIAOwy7Gjx
wOY+66zYIuJrxd3VATFbfwB+A4iOEAGwxgJJ6XTa7SYt7GDak0zmjBOlo0ml9cPM
o7l9EvJEjD5IoNWhMWjsoPWVtIbgBYmNpOmm4sMfG05bC+u+DeB9Ax8RSxc/Olpu
2pwic9CumGhoNsXpteFVML3O237Py/+4hEXNMut2uErRyjD5+omMjqay+74JbfvP
O2aAoooNJnI7slsnlHX2SGGElOQEkCq689B5CASnTf4bfpMVTYRfiptJAYsYcKYQ
Nmc/Cyi/JNrEQsnGQFm31ubbOgAqKcOGoOHB46jqsCfpIPsPOb9vogOouP4p6Gnb
LHouC6+ecOXQWyQaJ0InvwWHgom2ejAgKDUs77ZDq0AiLpNSpiKns0tReMxUWsPb
2VFGfegYJW/g+PdUMvXUJpIhw5p8BSuBj9JOgEgAs7Mi94guX0g=
=X1Pg
-----END PGP SIGNATURE-----

--pcQ3lfnBKmIllsrY--
