Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 695A034BEF4
	for <lists+stable@lfdr.de>; Sun, 28 Mar 2021 22:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbhC1UnN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Mar 2021 16:43:13 -0400
Received: from maynard.decadent.org.uk ([95.217.213.242]:37180 "EHLO
        maynard.decadent.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231258AbhC1Umx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Mar 2021 16:42:53 -0400
Received: from [2a02:1811:d34:3700:3b8d:b310:d327:e418] (helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1lQcFI-0001yE-Jy; Sun, 28 Mar 2021 22:42:52 +0200
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1lQcFH-003Gi1-P8; Sun, 28 Mar 2021 22:42:51 +0200
Date:   Sun, 28 Mar 2021 22:42:51 +0200
From:   Ben Hutchings <ben@decadent.org.uk>
To:     stable@vger.kernel.org
Cc:     Lee Jones <lee.jones@linaro.org>,
        "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 10/13] arm64: futex: Bound number of LDXR/STXR loops in
 FUTEX_WAKE_OP
Message-ID: <YGDqS7bKz9n1Jto3@decadent.org.uk>
References: <YGDp1qJOCUJmE1Ty@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ONy0Y04YDnEihpm3"
Content-Disposition: inline
In-Reply-To: <YGDp1qJOCUJmE1Ty@decadent.org.uk>
X-SA-Exim-Connect-IP: 2a02:1811:d34:3700:3b8d:b310:d327:e418
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ONy0Y04YDnEihpm3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom: Will Deacon <will.deacon@arm.com>

commit 03110a5cb2161690ae5ac04994d47ed0cd6cef75 upstream.

Our futex implementation makes use of LDXR/STXR loops to perform atomic
updates to user memory from atomic context. This can lead to latency
problems if we end up spinning around the LL/SC sequence at the expense
of doing something useful.

Rework our futex atomic operations so that we return -EAGAIN if we fail
to update the futex word after 128 attempts. The core futex code will
reschedule if necessary and we'll try again later.

Fixes: 6170a97460db ("arm64: Atomic operations")
Signed-off-by: Will Deacon <will.deacon@arm.com>
[bwh: Backported to 4.9: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm64/include/asm/futex.h | 59 +++++++++++++++++++++-------------
 1 file changed, 37 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/include/asm/futex.h b/arch/arm64/include/asm/futex.h
index 86a43450f014..bdf5ec2b8356 100644
--- a/arch/arm64/include/asm/futex.h
+++ b/arch/arm64/include/asm/futex.h
@@ -26,7 +26,12 @@
 #include <asm/errno.h>
 #include <asm/sysreg.h>
=20
+#define FUTEX_MAX_LOOPS	128 /* What's the largest number you can think of?=
 */
+
 #define __futex_atomic_op(insn, ret, oldval, uaddr, tmp, oparg)		\
+do {									\
+	unsigned int loops =3D FUTEX_MAX_LOOPS;				\
+									\
 	asm volatile(							\
 	ALTERNATIVE("nop", SET_PSTATE_PAN(0), ARM64_HAS_PAN,		\
 		    CONFIG_ARM64_PAN)					\
@@ -34,21 +39,26 @@
 "1:	ldxr	%w1, %2\n"						\
 	insn "\n"							\
 "2:	stlxr	%w0, %w3, %2\n"						\
-"	cbnz	%w0, 1b\n"						\
-"	dmb	ish\n"							\
+"	cbz	%w0, 3f\n"						\
+"	sub	%w4, %w4, %w0\n"					\
+"	cbnz	%w4, 1b\n"						\
+"	mov	%w0, %w7\n"						\
 "3:\n"									\
+"	dmb	ish\n"							\
 "	.pushsection .fixup,\"ax\"\n"					\
 "	.align	2\n"							\
-"4:	mov	%w0, %w5\n"						\
+"4:	mov	%w0, %w6\n"						\
 "	b	3b\n"							\
 "	.popsection\n"							\
 	_ASM_EXTABLE(1b, 4b)						\
 	_ASM_EXTABLE(2b, 4b)						\
 	ALTERNATIVE("nop", SET_PSTATE_PAN(1), ARM64_HAS_PAN,		\
 		    CONFIG_ARM64_PAN)					\
-	: "=3D&r" (ret), "=3D&r" (oldval), "+Q" (*uaddr), "=3D&r" (tmp)	\
-	: "r" (oparg), "Ir" (-EFAULT)					\
-	: "memory")
+	: "=3D&r" (ret), "=3D&r" (oldval), "+Q" (*uaddr), "=3D&r" (tmp),	\
+	  "+r" (loops)							\
+	: "r" (oparg), "Ir" (-EFAULT), "Ir" (-EAGAIN)			\
+	: "memory");							\
+} while (0)
=20
 static inline int
 arch_futex_atomic_op_inuser(int op, int oparg, int *oval, u32 __user *uadd=
r)
@@ -59,23 +69,23 @@ arch_futex_atomic_op_inuser(int op, int oparg, int *ova=
l, u32 __user *uaddr)
=20
 	switch (op) {
 	case FUTEX_OP_SET:
-		__futex_atomic_op("mov	%w3, %w4",
+		__futex_atomic_op("mov	%w3, %w5",
 				  ret, oldval, uaddr, tmp, oparg);
 		break;
 	case FUTEX_OP_ADD:
-		__futex_atomic_op("add	%w3, %w1, %w4",
+		__futex_atomic_op("add	%w3, %w1, %w5",
 				  ret, oldval, uaddr, tmp, oparg);
 		break;
 	case FUTEX_OP_OR:
-		__futex_atomic_op("orr	%w3, %w1, %w4",
+		__futex_atomic_op("orr	%w3, %w1, %w5",
 				  ret, oldval, uaddr, tmp, oparg);
 		break;
 	case FUTEX_OP_ANDN:
-		__futex_atomic_op("and	%w3, %w1, %w4",
+		__futex_atomic_op("and	%w3, %w1, %w5",
 				  ret, oldval, uaddr, tmp, ~oparg);
 		break;
 	case FUTEX_OP_XOR:
-		__futex_atomic_op("eor	%w3, %w1, %w4",
+		__futex_atomic_op("eor	%w3, %w1, %w5",
 				  ret, oldval, uaddr, tmp, oparg);
 		break;
 	default:
@@ -95,6 +105,7 @@ futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *_ua=
ddr,
 			      u32 oldval, u32 newval)
 {
 	int ret =3D 0;
+	unsigned int loops =3D FUTEX_MAX_LOOPS;
 	u32 val, tmp;
 	u32 __user *uaddr;
=20
@@ -106,21 +117,25 @@ futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *=
_uaddr,
 ALTERNATIVE("nop", SET_PSTATE_PAN(0), ARM64_HAS_PAN, CONFIG_ARM64_PAN)
 "	prfm	pstl1strm, %2\n"
 "1:	ldxr	%w1, %2\n"
-"	sub	%w3, %w1, %w4\n"
-"	cbnz	%w3, 3f\n"
-"2:	stlxr	%w3, %w5, %2\n"
-"	cbnz	%w3, 1b\n"
-"	dmb	ish\n"
+"	sub	%w3, %w1, %w5\n"
+"	cbnz	%w3, 4f\n"
+"2:	stlxr	%w3, %w6, %2\n"
+"	cbz	%w3, 3f\n"
+"	sub	%w4, %w4, %w3\n"
+"	cbnz	%w4, 1b\n"
+"	mov	%w0, %w8\n"
 "3:\n"
+"	dmb	ish\n"
+"4:\n"
 "	.pushsection .fixup,\"ax\"\n"
-"4:	mov	%w0, %w6\n"
-"	b	3b\n"
+"5:	mov	%w0, %w7\n"
+"	b	4b\n"
 "	.popsection\n"
-	_ASM_EXTABLE(1b, 4b)
-	_ASM_EXTABLE(2b, 4b)
+	_ASM_EXTABLE(1b, 5b)
+	_ASM_EXTABLE(2b, 5b)
 ALTERNATIVE("nop", SET_PSTATE_PAN(1), ARM64_HAS_PAN, CONFIG_ARM64_PAN)
-	: "+r" (ret), "=3D&r" (val), "+Q" (*uaddr), "=3D&r" (tmp)
-	: "r" (oldval), "r" (newval), "Ir" (-EFAULT)
+	: "+r" (ret), "=3D&r" (val), "+Q" (*uaddr), "=3D&r" (tmp), "+r" (loops)
+	: "r" (oldval), "r" (newval), "Ir" (-EFAULT), "Ir" (-EAGAIN)
 	: "memory");
=20
 	*uval =3D val;


--ONy0Y04YDnEihpm3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmBg6ksACgkQ57/I7JWG
EQmjqhAA1KV7z6zBNysdVCLTpFFDsRuAZ9wKJ21iUzYfo3gFd0LCXZ7TY119+FCj
SLlms++lzAPZ61dhEGqORADIR3haldocfeWuDzk8uxCu+kFJ3X0PUNJed/MW1Lq7
pnd5JQyw+ihu2lGKOt+Pijwz21oTFjJhHobqGGY5MelC4CWFY1PpIBWUrX9Ysr8f
QW31XEE9kOZkeahwuPhH2dsQJM6HRej/p6fvNZbnIW81Qt4FtA5eO9SNUlFfJ7xs
kMlab3nyqnvupl2h7DIHiTdM1UhkI8stLxG2YhWO3qW5ykFWxdbYyNuDBIvkVstj
CofeJQ7uwvL8aUhJ1Sq/3rtnpcJio8tNIHm0A1yukuI2bzyY7qQR0cAl0HjaAop9
6BSKyjG2esXk09s0NUEbc9oIyUYVYwPWzGiijDd+mKEwhCbdvkjfzwXg2I7VKcEQ
iW2cVMhJERj+L3RUr0k/WWu7dcStei8jf/XEZLaPRkKq1GZzIhsxc2fEyUDCUdJ0
iI+4ftMtvvNQqFMykjkz2rrvNEU+GrhbkfnfHWWGfOFO0RFjoNX5YJ/Xjd3uznRS
WpgvzzcYyxLCulGsjzpa+RAn5GovbxXY5nOaoiSCabJwTiyd77DPykcN5aSC5rRm
KXyW/S/LOKLVOkcTg7OgcgJFkwoIL3bsahIDw8vmrjiCp5QdiMk=
=ytk4
-----END PGP SIGNATURE-----

--ONy0Y04YDnEihpm3--
