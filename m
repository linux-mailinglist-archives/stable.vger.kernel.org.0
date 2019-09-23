Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77B1CBB1AC
	for <lists+stable@lfdr.de>; Mon, 23 Sep 2019 11:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405889AbfIWJuq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Sep 2019 05:50:46 -0400
Received: from mx1.emlix.com ([188.40.240.192]:41248 "EHLO mx1.emlix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405498AbfIWJuq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Sep 2019 05:50:46 -0400
X-Greylist: delayed 597 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Sep 2019 05:50:44 EDT
Received: from mailer.emlix.com (unknown [81.20.119.6])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.emlix.com (Postfix) with ESMTPS id E42475FA99
        for <stable@vger.kernel.org>; Mon, 23 Sep 2019 11:40:45 +0200 (CEST)
From:   Rolf Eike Beer <eb@emlix.com>
To:     stable@vger.kernel.org
Subject: [4.14] please include 056d28d135bca0b1d0908990338e00e9dadaf057
Date:   Mon, 23 Sep 2019 11:40:41 +0200
Message-ID: <7888549.SPjspKb6cB@devpool35>
Organization: emlix GmbH
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2493806.oVEsFefb8Z"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--nextPart2493806.oVEsFefb8Z
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"

Hi all,

please include 056d28d135bca0b1d0908990338e00e9dadaf057, I can't build with=
out=20
it. It is in several other stable kernels (e.g. 4.19). It fails applying in=
=20
tools/objtool/Makefile, but the fixup is rather trivial.

=46or reference, this is the patch as I manually apply it currently:

=46rom 7d25e19601df63ece47da732c96d656ec3850a52 Mon Sep 17 00:00:00 2001
=46rom: Rolf Eike Beer <eb@emlix.com>
Date: Tue, 26 Mar 2019 12:48:39 -0500
Subject: [PATCH] objtool: Query pkg-config for libelf location

If it is not in the default location, compilation fails at several points.

Signed-off-by: Rolf Eike Beer <eb@emlix.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/91a25e992566a7968fedc89ec80e7f4c83ad0548.15=
53622500.git.jpoimboe@redhat.com

(cherry picked from commit 056d28d135bca0b1d0908990338e00e9dadaf057)
=2D--
 Makefile               | 4 +++-
 tools/objtool/Makefile | 7 +++++--
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index ad923d5eae1e..e5deecb976fd 100644
=2D-- a/Makefile
+++ b/Makefile
@@ -949,9 +949,11 @@ mod_sign_cmd =3D true
 endif
 export mod_sign_cmd
=20
+HOST_LIBELF_LIBS =3D $(shell pkg-config libelf --libs 2>/dev/null || echo =
=2Dlelf)
+
 ifdef CONFIG_STACK_VALIDATION
   has_libelf :=3D $(call try-run,\
=2D		echo "int main() {}" | $(HOSTCC) -xc -o /dev/null -lelf -,1,0)
+		echo "int main() {}" | $(HOSTCC) -xc -o /dev/null $(HOST_LIBELF_LIBS) -,=
1,0)
   ifeq ($(has_libelf),1)
     objtool_target :=3D tools/objtool FORCE
   else
diff --git a/tools/objtool/Makefile b/tools/objtool/Makefile
index 884d4f1ed0c1..85d3d041e083 100644
=2D-- a/tools/objtool/Makefile
+++ b/tools/objtool/Makefile
@@ -26,14 +26,17 @@ LIBSUBCMD		=3D $(LIBSUBCMD_OUTPUT)libsubcmd.a
 OBJTOOL    :=3D $(OUTPUT)objtool
 OBJTOOL_IN :=3D $(OBJTOOL)-in.o
=20
+LIBELF_FLAGS :=3D $(shell pkg-config libelf --cflags 2>/dev/null)
+LIBELF_LIBS  :=3D $(shell pkg-config libelf --libs 2>/dev/null || echo -le=
lf)
+
 all: $(OBJTOOL)
=20
 INCLUDES :=3D -I$(srctree)/tools/include \
 	    -I$(srctree)/tools/arch/$(HOSTARCH)/include/uapi \
 	    -I$(srctree)/tools/objtool/arch/$(ARCH)/include
 WARNINGS :=3D $(EXTRA_WARNINGS) -Wno-switch-default -Wno-switch-enum -Wno-=
packed
=2DCFLAGS   +=3D -Wall -Werror $(WARNINGS) -fomit-frame-pointer -O2 -g $(IN=
CLUDES)
=2DLDFLAGS  +=3D -lelf $(LIBSUBCMD)
+CFLAGS   +=3D -Wall -Werror $(WARNINGS) -fomit-frame-pointer -O2 -g $(INCL=
UDES) $(LIBELF_FLAGS)
+LDFLAGS  +=3D $(LIBELF_LIBS) $(LIBSUBCMD)
=20
 # Allow old libelf to be used:
 elfshdr :=3D $(shell echo '$(pound)include <libelf.h>' | $(CC) $(CFLAGS) -=
x c -E - | grep elf_getshdr)
=2D-=20
2.23.0

Greetings,

Eike
=2D-=20
Rolf Eike Beer, emlix GmbH, http://www.emlix.com
=46on +49 551 30664-0, Fax +49 551 30664-11
Gothaer Platz 3, 37083 G=C3=B6ttingen, Germany
Sitz der Gesellschaft: G=C3=B6ttingen, Amtsgericht G=C3=B6ttingen HR B 3160
Gesch=C3=A4ftsf=C3=BChrung: Heike Jordan, Dr. Uwe Kracke =E2=80=93 Ust-IdNr=
=2E: DE 205 198 055

emlix - smart embedded open source
--nextPart2493806.oVEsFefb8Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iLMEAAEIAB0WIQQ/Uctzh31xzAxFCLur5FH7Xu2t/AUCXYiTGQAKCRCr5FH7Xu2t
/JsIBACaN7JU1OZ6h8Aegbts6B4pDXQwrnBma1684+yi3f4NPyXx9gzj0SJzlv0a
u3zv+K5XXGsYGhNBulyb36/agPY/C5owLx1VqjPJVQ8Z79AmmcOGr2Bc80zVlrOT
x/sb/6Zx3lJ0q1+jKnoVNFr0JrVuPtubEwHAh57CT72FdjAeQA==
=m3M+
-----END PGP SIGNATURE-----

--nextPart2493806.oVEsFefb8Z--



