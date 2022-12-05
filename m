Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 310486437BD
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 23:10:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233311AbiLEWKi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 17:10:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232842AbiLEWKb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 17:10:31 -0500
Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [95.217.213.242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4146418E34
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 14:10:29 -0800 (PST)
Received: from 213.219.160.184.adsl.dyn.edpnet.net ([213.219.160.184] helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1p2JfP-0006gn-Ij; Mon, 05 Dec 2022 23:10:27 +0100
Received: from ben by deadeye with local (Exim 4.96)
        (envelope-from <ben@decadent.org.uk>)
        id 1p2JfO-000jSr-2q;
        Mon, 05 Dec 2022 23:10:26 +0100
Date:   Mon, 5 Dec 2022 23:10:26 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 4.14 1/2] x86/nospec: Fix i386 RSB stuffing
Message-ID: <Y45sUiyu2/cjze66@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="m5rtUgRjKYzQpGht"
Content-Disposition: inline
In-Reply-To: <Y45sM5Dg6Y6YQIBZ@decadent.org.uk>
X-SA-Exim-Connect-IP: 213.219.160.184
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--m5rtUgRjKYzQpGht
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

commit 332924973725e8cdcc783c175f68cf7e162cb9e5 upstream.

Turns out that i386 doesn't unconditionally have LFENCE, as such the
loop in __FILL_RETURN_BUFFER isn't actually speculation safe on such
chips.

Fixes: ba6e31af2be9 ("x86/speculation: Add LFENCE to RSB fill sequence")
Reported-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/Yv9tj9vbQ9nNlXoY@worktop.programming.kicks-=
ass.net
[bwh: Backported to 4.14:
 - __FILL_RETURN_BUFFER takes an sp parameter
 - Open-code __FILL_RETURN_SLOT]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/include/asm/nospec-branch.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/no=
spec-branch.h
index 118441f53399..d5d4927e7683 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -38,6 +38,7 @@
  * the optimal version =E2=80=94 two calls, each with their own speculation
  * trap should their return address end up getting used, in a loop.
  */
+#ifdef CONFIG_X86_64
 #define __FILL_RETURN_BUFFER(reg, nr, sp)	\
 	mov	$(nr/2), reg;			\
 771:						\
@@ -58,6 +59,19 @@
 	jnz	771b;				\
 	/* barrier for jnz misprediction */	\
 	lfence;
+#else
+/*
+ * i386 doesn't unconditionally have LFENCE, as such it can't
+ * do a loop.
+ */
+#define __FILL_RETURN_BUFFER(reg, nr, sp)	\
+	.rept nr;				\
+	call	772f;				\
+	int3;					\
+772:;						\
+	.endr;					\
+	add	$(BITS_PER_LONG/8) * nr, sp;
+#endif
=20
 #define ISSUE_UNBALANCED_RET_GUARD(sp)		\
 	call 992f;				\


--m5rtUgRjKYzQpGht
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmOObFIACgkQ57/I7JWG
EQmCWw/+Ijx9Ywb68kPKqwR+Dt37t/d7xLW6+T05dmQ/SWLZr5YrTBMlcICNv2U2
O4wzhqQ6oHb3aRSQdA7Qg9/2Ezag3YudaU3njT0yXLS+2jNrT8WxxL5tA56bxrXR
a1ZqPA1akxT2wfg/etpq6xNt8HgmpVoqts9h6gtng4mTIHNGgPH7oeYw+tYIM+Va
tOzKO7q06F1BqC5kKhYOoXCEZ759hJxp6NdrkuT1D6O9borNJNaELLIGG/7bM7Ro
x4Zc6vCuRPyVBq/C9Tk5KI+shuC22jwZrWr3Qn3YRGOANxSFp+cz6098INOguna+
CSlrzGmjLm+1gnpYxO5hhOD2FNrNFIBt+S8YUCy69Flak3B4JUV/ezrqjC30fDib
x+ROYdRRiLOcKkPp2SSWtred0AuqqQLSRB4bXTVzsSwGtHekLzPonIXtI8u/5Cqk
69/+SZi3hbxAtNatdeOYvrPKk32sm2xn4Ca6r8Bgnr6wqCHf1QiO3ZaSrlIfrnT2
j4EzLojy9BULbE4EFJcfyCqs1kp5ZQL9zzq0HUJA+1OBXnos54RBtHo+kQ2+uMCw
0lGb/LuwCsS7ssKvgqzmg01YhGcmCMfAZiXWAWuQv6xx9na2Mx5lqVV/7HfYrkY1
PR4M7n8C77CDQMied1tM+7GpmnzupmE4cWRXjR85eneg2uEIUO0=
=JUIu
-----END PGP SIGNATURE-----

--m5rtUgRjKYzQpGht--
