Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79E3D5FE222
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 20:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231849AbiJMSyb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 14:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232560AbiJMSyE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 14:54:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EEDA13F61
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 11:52:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 893A7B81CF4
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 18:51:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4CAFC433C1;
        Thu, 13 Oct 2022 18:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665687084;
        bh=5HywPeYwa41cwYRHD8Oba7oBrO5GJZh5hIEzFuU9u/Q=;
        h=Date:From:To:Cc:Subject:From;
        b=ZdDUGqxJ27W9V+I8uN4+nzi3oMPkLopTZlb43hAcwKN2sjN/TnjY3jadv6pVMBjkc
         8ys+VaK+xV090dP64z7fHVzqeHjMjVI61DOrC0OdVbWtzFQLF7kV1UjpQ7TpXm0qx8
         UGsfRKNugPo964WHO4pBCcPA9TsPq406Iz9TJ+tPrww/lWVwPr25Axv62q1FFfLonT
         Avuj4YefwLwsiR2aq/4rgOrWzzm/AESOTx2I4535J7MrBnlXbkUlhkD7t5ZX0Ap3KJ
         O36d+nWX+UW7Cn7HoMFfNFn49je0TTZBQ0HdW3PS3VIq0ZtFEGoBHq5sFnyEm+A5mI
         028N4pq/SXy2A==
Date:   Thu, 13 Oct 2022 11:51:22 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, llvm@lists.linux.dev,
        Kees Cook <keescook@chromium.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: Backport of 607e57c6c62c009 for 5.10 and 5.15
Message-ID: <Y0heKubSc1P6rbNB@dev-arch.thelio-3990X>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="4tqRJsZmhHPics/4"
Content-Disposition: inline
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--4tqRJsZmhHPics/4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg and Sasha,

Please find attached backports for commit 607e57c6c62c ("hardening:
Remove Clang's enable flag for -ftrivial-auto-var-init=zero") along with
prerequisite changes for 5.10 and 5.15. This change is necessary to keep
CONFIG_INIT_STACK_ALL_ZERO working with clang-16. This change is already
queued up for 5.19 and newer and it is not relevant for 5.4 and older
(at least upstream, I'll be doing backports for older Android branches
shortly). If there are any questions or problems, please let me know!

Cheers,
Nathan

--4tqRJsZmhHPics/4
Content-Type: application/mbox
Content-Disposition: attachment; filename="607e57c6c62c009-5.10.mbox"
Content-Transfer-Encoding: quoted-printable

=46rom 5bd1793c7e64446980ade23f3cf1cd4a5788a5da Mon Sep 17 00:00:00 2001=0A=
=46rom: Kees Cook <keescook@chromium.org>=0ADate: Tue, 20 Jul 2021 14:54:17=
 -0700=0ASubject: [PATCH 5.10 1/3] hardening: Clarify Kconfig text for auto=
-var-init=0A=0Acommit dcb7c0b9461c2a30f6616262736daac6f01ecb09 upstream.=0A=
=0AClarify the details around the automatic variable initialization modes=
=0Aavailable. Specifically this details the values used for pattern init=0A=
and expands on the rationale for zero init safety. Additionally makes=0Azer=
o init the default when available.=0A=0ACc: glider@google.com=0ACc: Nathan =
Chancellor <nathan@kernel.org>=0ACc: Nick Desaulniers <ndesaulniers@google.=
com>=0ACc: linux-security-module@vger.kernel.org=0ACc: clang-built-linux@go=
oglegroups.com=0ASigned-off-by: Kees Cook <keescook@chromium.org>=0AAcked-b=
y: Gustavo A. R. Silva <gustavoars@kernel.org>=0ASigned-off-by: Nathan Chan=
cellor <nathan@kernel.org>=0A---=0A security/Kconfig.hardening | 52 +++++++=
++++++++++++++++---------------=0A 1 file changed, 32 insertions(+), 20 del=
etions(-)=0A=0Adiff --git a/security/Kconfig.hardening b/security/Kconfig.h=
ardening=0Aindex 269967c4fc1b..45c688488172 100644=0A--- a/security/Kconfig=
=2Ehardening=0A+++ b/security/Kconfig.hardening=0A@@ -29,6 +29,7 @@ choice=
=0A 	prompt "Initialize kernel stack variables at function entry"=0A 	defau=
lt GCC_PLUGIN_STRUCTLEAK_BYREF_ALL if COMPILE_TEST && GCC_PLUGINS=0A 	defau=
lt INIT_STACK_ALL_PATTERN if COMPILE_TEST && CC_HAS_AUTO_VAR_INIT_PATTERN=
=0A+	default INIT_STACK_ALL_ZERO if CC_HAS_AUTO_VAR_INIT_PATTERN=0A 	defaul=
t INIT_STACK_NONE=0A 	help=0A 	  This option enables initialization of stac=
k variables at=0A@@ -39,11 +40,11 @@ choice=0A 	  syscalls.=0A =0A 	  This =
chooses the level of coverage over classes of potentially=0A-	  uninitializ=
ed variables. The selected class will be=0A+	  uninitialized variables. The=
 selected class of variable will be=0A 	  initialized before use in a funct=
ion.=0A =0A 	config INIT_STACK_NONE=0A-		bool "no automatic initialization =
(weakest)"=0A+		bool "no automatic stack variable initialization (weakest)"=
=0A 		help=0A 		  Disable automatic stack variable initialization.=0A 		  T=
his leaves the kernel vulnerable to the standard=0A@@ -80,7 +81,7 @@ choice=
=0A 		  and is disallowed.=0A =0A 	config GCC_PLUGIN_STRUCTLEAK_BYREF_ALL=
=0A-		bool "zero-init anything passed by reference (very strong)"=0A+		bool=
 "zero-init everything passed by reference (very strong)"=0A 		depends on G=
CC_PLUGINS=0A 		depends on !(KASAN && KASAN_STACK=3D1)=0A 		select GCC_PLUG=
IN_STRUCTLEAK=0A@@ -91,33 +92,44 @@ choice=0A 		  of uninitialized stack va=
riable exploits and information=0A 		  exposures.=0A =0A+		  As a side-effe=
ct, this keeps a lot of variables on the=0A+		  stack that can otherwise be=
 optimized out, so combining=0A+		  this with CONFIG_KASAN_STACK can lead t=
o a stack overflow=0A+		  and is disallowed.=0A+=0A 	config INIT_STACK_ALL_=
PATTERN=0A-		bool "0xAA-init everything on the stack (strongest)"=0A+		bool=
 "pattern-init everything (strongest)"=0A 		depends on CC_HAS_AUTO_VAR_INIT=
_PATTERN=0A 		help=0A-		  Initializes everything on the stack with a 0xAA=
=0A-		  pattern. This is intended to eliminate all classes=0A-		  of uninit=
ialized stack variable exploits and information=0A-		  exposures, even vari=
ables that were warned to have been=0A-		  left uninitialized.=0A+		  Initi=
alizes everything on the stack (including padding)=0A+		  with a specific d=
ebug value. This is intended to eliminate=0A+		  all classes of uninitializ=
ed stack variable exploits and=0A+		  information exposures, even variables=
 that were warned about=0A+		  having been left uninitialized.=0A =0A 		  P=
attern initialization is known to provoke many existing bugs=0A 		  related=
 to uninitialized locals, e.g. pointers receive=0A-		  non-NULL values, buf=
fer sizes and indices are very big.=0A+		  non-NULL values, buffer sizes an=
d indices are very big. The=0A+		  pattern is situation-specific; Clang on =
64-bit uses 0xAA=0A+		  repeating for all types and padding except float an=
d double=0A+		  which use 0xFF repeating (-NaN). Clang on 32-bit uses 0xFF=
=0A+		  repeating for all types and padding.=0A =0A 	config INIT_STACK_ALL_=
ZERO=0A-		bool "zero-init everything on the stack (strongest and safest)"=
=0A+		bool "zero-init everything (strongest and safest)"=0A 		depends on CC=
_HAS_AUTO_VAR_INIT_ZERO=0A 		help=0A-		  Initializes everything on the stac=
k with a zero=0A-		  value. This is intended to eliminate all classes=0A-		=
  of uninitialized stack variable exploits and information=0A-		  exposures=
, even variables that were warned to have been=0A-		  left uninitialized.=
=0A-=0A-		  Zero initialization provides safe defaults for strings,=0A-		  =
pointers, indices and sizes, and is therefore=0A-		  more suitable as a sec=
urity mitigation measure.=0A+		  Initializes everything on the stack (inclu=
ding padding)=0A+		  with a zero value. This is intended to eliminate all=
=0A+		  classes of uninitialized stack variable exploits and=0A+		  informa=
tion exposures, even variables that were warned=0A+		  about having been le=
ft uninitialized.=0A+=0A+		  Zero initialization provides safe defaults for=
 strings=0A+		  (immediately NUL-terminated), pointers (NULL), indices=0A+	=
	  (index 0), and sizes (0 length), so it is therefore more=0A+		  suitable=
 as a production security mitigation than pattern=0A+		  initialization.=0A=
 =0A endchoice=0A =0A-- =0A2.37.3=0A=0A=0AFrom b5b0ed7f316c469247f369b0ee03=
d31ee03c6ea6 Mon Sep 17 00:00:00 2001=0AFrom: Kees Cook <keescook@chromium.=
org>=0ADate: Tue, 14 Sep 2021 12:49:03 -0700=0ASubject: [PATCH 5.10 2/3] ha=
rdening: Avoid harmless Clang option under=0A CONFIG_INIT_STACK_ALL_ZERO=0A=
=0Acommit f02003c860d921171be4a27e2893766eb3bc6871 upstream.=0A=0ACurrently=
 under Clang, CC_HAS_AUTO_VAR_INIT_ZERO requires an extra=0A-enable flag co=
mpared to CC_HAS_AUTO_VAR_INIT_PATTERN. GCC 12[1] will=0Anot, and will happ=
ily ignore the Clang-specific flag. However, its=0Apresence on the command-=
line is both cumbersome and confusing. Due to=0AGCC's tolerant behavior, th=
ough, we can continue to use a single Kconfig=0Acc-option test for the feat=
ure on both compilers, but then drop the=0AClang-specific option in the Mak=
efile.=0A=0AIn other words, this patch does not change anything other than =
making the=0Acompiler command line shorter once GCC supports -ftrivial-auto=
-var-init=3Dzero.=0A=0A[1] https://gcc.gnu.org/git/?p=3Dgcc.git;a=3Dcommitd=
iff;h=3Da25e0b5e6ac8a77a71c229e0a7b744603365b0e9=0A=0ACc: Greg Kroah-Hartma=
n <gregkh@linuxfoundation.org>=0ACc: Masahiro Yamada <masahiroy@kernel.org>=
=0ACc: llvm@lists.linux.dev=0AFixes: dcb7c0b9461c ("hardening: Clarify Kcon=
fig text for auto-var-init")=0ASuggested-by: Will Deacon <will@kernel.org>=
=0ALink: https://lore.kernel.org/lkml/20210914102837.6172-1-will@kernel.org=
/=0AReviewed-by: Nick Desaulniers <ndesaulniers@google.com>=0AReviewed-by: =
Nathan Chancellor <nathan@kernel.org>=0AAcked-by: Will Deacon <will@kernel.=
org>=0ASigned-off-by: Kees Cook <keescook@chromium.org>=0ASigned-off-by: Na=
than Chancellor <nathan@kernel.org>=0A---=0A Makefile                   | 6=
 +++---=0A security/Kconfig.hardening | 5 ++++-=0A 2 files changed, 7 inser=
tions(+), 4 deletions(-)=0A=0Adiff --git a/Makefile b/Makefile=0Aindex 2411=
0f834775..1a3cc9d4c5fe 100644=0A--- a/Makefile=0A+++ b/Makefile=0A@@ -816,1=
2 +816,12 @@ endif=0A =0A # Initialize all stack variables with a zero valu=
e.=0A ifdef CONFIG_INIT_STACK_ALL_ZERO=0A-# Future support for zero initial=
ization is still being debated, see=0A-# https://bugs.llvm.org/show_bug.cgi=
?id=3D45497. These flags are subject to being=0A-# renamed or dropped.=0A K=
BUILD_CFLAGS	+=3D -ftrivial-auto-var-init=3Dzero=0A+ifdef CONFIG_CC_IS_CLAN=
G=0A+# https://bugs.llvm.org/show_bug.cgi?id=3D45497=0A KBUILD_CFLAGS	+=3D =
-enable-trivial-auto-var-init-zero-knowing-it-will-be-removed-from-clang=0A=
 endif=0A+endif=0A =0A DEBUG_CFLAGS	:=3D=0A =0Adiff --git a/security/Kconfi=
g.hardening b/security/Kconfig.hardening=0Aindex 45c688488172..81368ce57d67=
 100644=0A--- a/security/Kconfig.hardening=0A+++ b/security/Kconfig.hardeni=
ng=0A@@ -23,13 +23,16 @@ config CC_HAS_AUTO_VAR_INIT_PATTERN=0A 	def_bool $=
(cc-option,-ftrivial-auto-var-init=3Dpattern)=0A =0A config CC_HAS_AUTO_VAR=
_INIT_ZERO=0A+	# GCC ignores the -enable flag, so we can test for the featu=
re with=0A+	# a single invocation using the flag, but drop it as appropriat=
e in=0A+	# the Makefile, depending on the presence of Clang.=0A 	def_bool $=
(cc-option,-ftrivial-auto-var-init=3Dzero -enable-trivial-auto-var-init-zer=
o-knowing-it-will-be-removed-from-clang)=0A =0A choice=0A 	prompt "Initiali=
ze kernel stack variables at function entry"=0A 	default GCC_PLUGIN_STRUCTL=
EAK_BYREF_ALL if COMPILE_TEST && GCC_PLUGINS=0A 	default INIT_STACK_ALL_PAT=
TERN if COMPILE_TEST && CC_HAS_AUTO_VAR_INIT_PATTERN=0A-	default INIT_STACK=
_ALL_ZERO if CC_HAS_AUTO_VAR_INIT_PATTERN=0A+	default INIT_STACK_ALL_ZERO i=
f CC_HAS_AUTO_VAR_INIT_ZERO=0A 	default INIT_STACK_NONE=0A 	help=0A 	  This=
 option enables initialization of stack variables at=0A-- =0A2.37.3=0A=0A=
=0AFrom 0891e1a67b30641bbb51ae1ea8dd4a1d25865ac3 Mon Sep 17 00:00:00 2001=
=0AFrom: Kees Cook <keescook@chromium.org>=0ADate: Thu, 29 Sep 2022 22:57:4=
3 -0700=0ASubject: [PATCH 5.10 3/3] hardening: Remove Clang's enable flag f=
or=0A -ftrivial-auto-var-init=3Dzero=0A=0Acommit 607e57c6c62c00965ae276902c=
166834ce73014a upstream.=0A=0ANow that Clang's -enable-trivial-auto-var-ini=
t-zero-knowing-it-will-be-removed-from-clang=0Aoption is no longer required=
, remove it from the command line. Clang 16=0Aand later will warn when it i=
s used, which will cause Kconfig to think=0Ait can't use -ftrivial-auto-var=
-init=3Dzero at all. Check for whether it=0Ais required and only use it whe=
n so.=0A=0ACc: Nathan Chancellor <nathan@kernel.org>=0ACc: Masahiro Yamada =
<masahiroy@kernel.org>=0ACc: Nick Desaulniers <ndesaulniers@google.com>=0AC=
c: linux-kbuild@vger.kernel.org=0ACc: llvm@lists.linux.dev=0ACc: stable@vge=
r.kernel.org=0AFixes: f02003c860d9 ("hardening: Avoid harmless Clang option=
 under CONFIG_INIT_STACK_ALL_ZERO")=0ASigned-off-by: Kees Cook <keescook@ch=
romium.org>=0ASigned-off-by: Nathan Chancellor <nathan@kernel.org>=0A---=0A=
 Makefile                   |  4 ++--=0A security/Kconfig.hardening | 14 ++=
++++++++----=0A 2 files changed, 12 insertions(+), 6 deletions(-)=0A=0Adiff=
 --git a/Makefile b/Makefile=0Aindex 1a3cc9d4c5fe..a26360d4f574 100644=0A--=
- a/Makefile=0A+++ b/Makefile=0A@@ -817,8 +817,8 @@ endif=0A # Initialize a=
ll stack variables with a zero value.=0A ifdef CONFIG_INIT_STACK_ALL_ZERO=
=0A KBUILD_CFLAGS	+=3D -ftrivial-auto-var-init=3Dzero=0A-ifdef CONFIG_CC_IS=
_CLANG=0A-# https://bugs.llvm.org/show_bug.cgi?id=3D45497=0A+ifdef CONFIG_C=
C_HAS_AUTO_VAR_INIT_ZERO_ENABLER=0A+# https://github.com/llvm/llvm-project/=
issues/44842=0A KBUILD_CFLAGS	+=3D -enable-trivial-auto-var-init-zero-knowi=
ng-it-will-be-removed-from-clang=0A endif=0A endif=0Adiff --git a/security/=
Kconfig.hardening b/security/Kconfig.hardening=0Aindex 81368ce57d67..b54eb7=
177a31 100644=0A--- a/security/Kconfig.hardening=0A+++ b/security/Kconfig.h=
ardening=0A@@ -22,11 +22,17 @@ menu "Memory initialization"=0A config CC_HA=
S_AUTO_VAR_INIT_PATTERN=0A 	def_bool $(cc-option,-ftrivial-auto-var-init=3D=
pattern)=0A =0A-config CC_HAS_AUTO_VAR_INIT_ZERO=0A-	# GCC ignores the -ena=
ble flag, so we can test for the feature with=0A-	# a single invocation usi=
ng the flag, but drop it as appropriate in=0A-	# the Makefile, depending on=
 the presence of Clang.=0A+config CC_HAS_AUTO_VAR_INIT_ZERO_BARE=0A+	def_bo=
ol $(cc-option,-ftrivial-auto-var-init=3Dzero)=0A+=0A+config CC_HAS_AUTO_VA=
R_INIT_ZERO_ENABLER=0A+	# Clang 16 and later warn about using the -enable f=
lag, but it=0A+	# is required before then.=0A 	def_bool $(cc-option,-ftrivi=
al-auto-var-init=3Dzero -enable-trivial-auto-var-init-zero-knowing-it-will-=
be-removed-from-clang)=0A+	depends on !CC_HAS_AUTO_VAR_INIT_ZERO_BARE=0A+=
=0A+config CC_HAS_AUTO_VAR_INIT_ZERO=0A+	def_bool CC_HAS_AUTO_VAR_INIT_ZERO=
_BARE || CC_HAS_AUTO_VAR_INIT_ZERO_ENABLER=0A =0A choice=0A 	prompt "Initia=
lize kernel stack variables at function entry"=0A-- =0A2.37.3=0A=0A
--4tqRJsZmhHPics/4
Content-Type: application/mbox
Content-Disposition: attachment; filename="607e57c6c62c009-5.15.mbox"
Content-Transfer-Encoding: quoted-printable

=46rom 0acd91ece434afda491573b03ed6f6274ccf6e47 Mon Sep 17 00:00:00 2001=0A=
=46rom: Kees Cook <keescook@chromium.org>=0ADate: Tue, 14 Sep 2021 12:49:03=
 -0700=0ASubject: [PATCH 5.15 1/2] hardening: Avoid harmless Clang option u=
nder=0A CONFIG_INIT_STACK_ALL_ZERO=0A=0Acommit f02003c860d921171be4a27e2893=
766eb3bc6871 upstream.=0A=0ACurrently under Clang, CC_HAS_AUTO_VAR_INIT_ZER=
O requires an extra=0A-enable flag compared to CC_HAS_AUTO_VAR_INIT_PATTERN=
=2E GCC 12[1] will=0Anot, and will happily ignore the Clang-specific flag. =
However, its=0Apresence on the command-line is both cumbersome and confusin=
g. Due to=0AGCC's tolerant behavior, though, we can continue to use a singl=
e Kconfig=0Acc-option test for the feature on both compilers, but then drop=
 the=0AClang-specific option in the Makefile.=0A=0AIn other words, this pat=
ch does not change anything other than making the=0Acompiler command line s=
horter once GCC supports -ftrivial-auto-var-init=3Dzero.=0A=0A[1] https://g=
cc.gnu.org/git/?p=3Dgcc.git;a=3Dcommitdiff;h=3Da25e0b5e6ac8a77a71c229e0a7b7=
44603365b0e9=0A=0ACc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>=0ACc:=
 Masahiro Yamada <masahiroy@kernel.org>=0ACc: llvm@lists.linux.dev=0AFixes:=
 dcb7c0b9461c ("hardening: Clarify Kconfig text for auto-var-init")=0ASugge=
sted-by: Will Deacon <will@kernel.org>=0ALink: https://lore.kernel.org/lkml=
/20210914102837.6172-1-will@kernel.org/=0AReviewed-by: Nick Desaulniers <nd=
esaulniers@google.com>=0AReviewed-by: Nathan Chancellor <nathan@kernel.org>=
=0AAcked-by: Will Deacon <will@kernel.org>=0ASigned-off-by: Kees Cook <kees=
cook@chromium.org>=0ASigned-off-by: Nathan Chancellor <nathan@kernel.org>=
=0A---=0A Makefile                   | 6 +++---=0A security/Kconfig.hardeni=
ng | 5 ++++-=0A 2 files changed, 7 insertions(+), 4 deletions(-)=0A=0Adiff =
--git a/Makefile b/Makefile=0Aindex fc47032dabb8..0a4d703b7c9c 100644=0A---=
 a/Makefile=0A+++ b/Makefile=0A@@ -844,12 +844,12 @@ endif=0A =0A # Initial=
ize all stack variables with a zero value.=0A ifdef CONFIG_INIT_STACK_ALL_Z=
ERO=0A-# Future support for zero initialization is still being debated, see=
=0A-# https://bugs.llvm.org/show_bug.cgi?id=3D45497. These flags are subjec=
t to being=0A-# renamed or dropped.=0A KBUILD_CFLAGS	+=3D -ftrivial-auto-va=
r-init=3Dzero=0A+ifdef CONFIG_CC_IS_CLANG=0A+# https://bugs.llvm.org/show_b=
ug.cgi?id=3D45497=0A KBUILD_CFLAGS	+=3D -enable-trivial-auto-var-init-zero-=
knowing-it-will-be-removed-from-clang=0A endif=0A+endif=0A =0A # While VLAs=
 have been removed, GCC produces unreachable stack probes=0A # for the rand=
omize_kstack_offset feature. Disable it for all compilers.=0Adiff --git a/s=
ecurity/Kconfig.hardening b/security/Kconfig.hardening=0Aindex 90cbaff86e13=
=2E.ded17b8abce2 100644=0A--- a/security/Kconfig.hardening=0A+++ b/security=
/Kconfig.hardening=0A@@ -23,13 +23,16 @@ config CC_HAS_AUTO_VAR_INIT_PATTER=
N=0A 	def_bool $(cc-option,-ftrivial-auto-var-init=3Dpattern)=0A =0A config=
 CC_HAS_AUTO_VAR_INIT_ZERO=0A+	# GCC ignores the -enable flag, so we can te=
st for the feature with=0A+	# a single invocation using the flag, but drop =
it as appropriate in=0A+	# the Makefile, depending on the presence of Clang=
=2E=0A 	def_bool $(cc-option,-ftrivial-auto-var-init=3Dzero -enable-trivial=
-auto-var-init-zero-knowing-it-will-be-removed-from-clang)=0A =0A choice=0A=
 	prompt "Initialize kernel stack variables at function entry"=0A 	default =
GCC_PLUGIN_STRUCTLEAK_BYREF_ALL if COMPILE_TEST && GCC_PLUGINS=0A 	default =
INIT_STACK_ALL_PATTERN if COMPILE_TEST && CC_HAS_AUTO_VAR_INIT_PATTERN=0A-	=
default INIT_STACK_ALL_ZERO if CC_HAS_AUTO_VAR_INIT_PATTERN=0A+	default INI=
T_STACK_ALL_ZERO if CC_HAS_AUTO_VAR_INIT_ZERO=0A 	default INIT_STACK_NONE=
=0A 	help=0A 	  This option enables initialization of stack variables at=0A=
-- =0A2.37.3=0A=0A=0AFrom 0f252057bf00f6819ea2d7beae88289fd224fec5 Mon Sep =
17 00:00:00 2001=0AFrom: Kees Cook <keescook@chromium.org>=0ADate: Thu, 29 =
Sep 2022 22:57:43 -0700=0ASubject: [PATCH 5.15 2/2] hardening: Remove Clang=
's enable flag for=0A -ftrivial-auto-var-init=3Dzero=0A=0Acommit 607e57c6c6=
2c00965ae276902c166834ce73014a upstream.=0A=0ANow that Clang's -enable-triv=
ial-auto-var-init-zero-knowing-it-will-be-removed-from-clang=0Aoption is no=
 longer required, remove it from the command line. Clang 16=0Aand later wil=
l warn when it is used, which will cause Kconfig to think=0Ait can't use -f=
trivial-auto-var-init=3Dzero at all. Check for whether it=0Ais required and=
 only use it when so.=0A=0ACc: Nathan Chancellor <nathan@kernel.org>=0ACc: =
Masahiro Yamada <masahiroy@kernel.org>=0ACc: Nick Desaulniers <ndesaulniers=
@google.com>=0ACc: linux-kbuild@vger.kernel.org=0ACc: llvm@lists.linux.dev=
=0ACc: stable@vger.kernel.org=0AFixes: f02003c860d9 ("hardening: Avoid harm=
less Clang option under CONFIG_INIT_STACK_ALL_ZERO")=0ASigned-off-by: Kees =
Cook <keescook@chromium.org>=0ASigned-off-by: Nathan Chancellor <nathan@ker=
nel.org>=0A---=0A Makefile                   |  4 ++--=0A security/Kconfig.=
hardening | 14 ++++++++++----=0A 2 files changed, 12 insertions(+), 6 delet=
ions(-)=0A=0Adiff --git a/Makefile b/Makefile=0Aindex 0a4d703b7c9c..d6e2965=
11015 100644=0A--- a/Makefile=0A+++ b/Makefile=0A@@ -845,8 +845,8 @@ endif=
=0A # Initialize all stack variables with a zero value.=0A ifdef CONFIG_INI=
T_STACK_ALL_ZERO=0A KBUILD_CFLAGS	+=3D -ftrivial-auto-var-init=3Dzero=0A-if=
def CONFIG_CC_IS_CLANG=0A-# https://bugs.llvm.org/show_bug.cgi?id=3D45497=
=0A+ifdef CONFIG_CC_HAS_AUTO_VAR_INIT_ZERO_ENABLER=0A+# https://github.com/=
llvm/llvm-project/issues/44842=0A KBUILD_CFLAGS	+=3D -enable-trivial-auto-v=
ar-init-zero-knowing-it-will-be-removed-from-clang=0A endif=0A endif=0Adiff=
 --git a/security/Kconfig.hardening b/security/Kconfig.hardening=0Aindex de=
d17b8abce2..942ed8de36d3 100644=0A--- a/security/Kconfig.hardening=0A+++ b/=
security/Kconfig.hardening=0A@@ -22,11 +22,17 @@ menu "Memory initializatio=
n"=0A config CC_HAS_AUTO_VAR_INIT_PATTERN=0A 	def_bool $(cc-option,-ftrivia=
l-auto-var-init=3Dpattern)=0A =0A-config CC_HAS_AUTO_VAR_INIT_ZERO=0A-	# GC=
C ignores the -enable flag, so we can test for the feature with=0A-	# a sin=
gle invocation using the flag, but drop it as appropriate in=0A-	# the Make=
file, depending on the presence of Clang.=0A+config CC_HAS_AUTO_VAR_INIT_ZE=
RO_BARE=0A+	def_bool $(cc-option,-ftrivial-auto-var-init=3Dzero)=0A+=0A+con=
fig CC_HAS_AUTO_VAR_INIT_ZERO_ENABLER=0A+	# Clang 16 and later warn about u=
sing the -enable flag, but it=0A+	# is required before then.=0A 	def_bool $=
(cc-option,-ftrivial-auto-var-init=3Dzero -enable-trivial-auto-var-init-zer=
o-knowing-it-will-be-removed-from-clang)=0A+	depends on !CC_HAS_AUTO_VAR_IN=
IT_ZERO_BARE=0A+=0A+config CC_HAS_AUTO_VAR_INIT_ZERO=0A+	def_bool CC_HAS_AU=
TO_VAR_INIT_ZERO_BARE || CC_HAS_AUTO_VAR_INIT_ZERO_ENABLER=0A =0A choice=0A=
 	prompt "Initialize kernel stack variables at function entry"=0A-- =0A2.37=
=2E3=0A=0A
--4tqRJsZmhHPics/4--
