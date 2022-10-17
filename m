Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 278026015C7
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 19:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbiJQRwd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 13:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbiJQRwc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 13:52:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3662DF53
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 10:52:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79C4AB81620
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 17:52:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D60D0C433C1;
        Mon, 17 Oct 2022 17:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666029149;
        bh=S88/rQpRD5ijrffLRAlbuudyaI7Mm2rzjtnu226UW7Q=;
        h=Date:From:To:Cc:Subject:From;
        b=m5WqHKailhz+8wGIhAth9uYoHMheOrW3Wq9BK66YYNzL4s83AZAl420rIKAuOieWs
         uZ2yafeFIhj/SmoE89K6/rbrxVgHP+aRd+KbaAVMw6Bxzaf5zB4nIPsYqRSXLUfqvB
         5p40DTASXxWEv87KNHbnwyRK9J9DKzUDzxEgCQwnfbL6KHfYYmUDI8D5ZCEPGCKVzg
         CT83lLYJNgxNxK3OEgR8cQYsw9gdJ9tTzWg1MNcA4e4WUZJItu1Iol424ggpRKqZfd
         wsad4Q4+nW++qkFu64BWNBvEHgdSB8+6wLS4NUnTorCrkpWGyKcQR92B4LDSrIysA5
         rGFVNEwdXXaMA==
Date:   Mon, 17 Oct 2022 10:52:27 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, llvm@lists.linux.dev,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: Apply 0a6de78cff60 to 5.15+
Message-ID: <Y02WW7iIeWPFTV8L@dev-arch.thelio-3990X>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="lRArZorZLPlzaoQg"
Content-Disposition: inline
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--lRArZorZLPlzaoQg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg and Sasha,

Please consider applying the following commits to 5.19 and 6.0:

4f001a21080f ("Kconfig.debug: simplify the dependency of DEBUG_INFO_DWARF4/5")
bb1435f3f575 ("Kconfig.debug: add toolchain checks for DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT")
0a6de78cff60 ("lib/Kconfig.debug: Add check for non-constant .{s,u}leb128 support to DWARF5")

The main change is the final one but the second patch is a prerequisite
and a useful fix in its own right. The first change allows the second to
apply cleanly and it is a good clean up as well.

I have verified that they apply cleanly to those trees with 'patch -p1'.
Attached is a manual backport for 5.15; the changes should not be
necessary for older trees, as they do not have support for DWARF 5.

If there are any problems or questions, please let me know.

Cheers,
Nathan

--lRArZorZLPlzaoQg
Content-Type: application/mbox
Content-Disposition: attachment; filename="0a6de78cff60-5.15.mbox"
Content-Transfer-Encoding: quoted-printable

=46rom 3f3da9579a6e81b5c09fc8d876227065194943ac Mon Sep 17 00:00:00 2001=0A=
=46rom: Masahiro Yamada <masahiroy@kernel.org>=0ADate: Wed, 5 Oct 2022 01:2=
9:03 +0900=0ASubject: [PATCH 5.15 1/3] Kconfig.debug: simplify the dependen=
cy of=0A DEBUG_INFO_DWARF4/5=0A=0Acommit 4f001a21080ff2e2f0e1c3692f5e119aed=
bb3bc1 upstream.=0A=0ACommit c0a5c81ca9be ("Kconfig.debug: drop GCC 5+ vers=
ion check for=0ADWARF5") could have cleaned up the code a bit more.=0A=0A"C=
C_IS_CLANG &&" is unneeded. No functional change is intended.=0A=0ASigned-o=
ff-by: Masahiro Yamada <masahiroy@kernel.org>=0AReviewed-by: Nathan Chancel=
lor <nathan@kernel.org>=0A[nathan: Only apply to DWARF5, as 5.15 does not h=
ave 32ef9e5054ec032]=0ASigned-off-by: Nathan Chancellor <nathan@kernel.org>=
=0A---=0A lib/Kconfig.debug | 2 +-=0A 1 file changed, 1 insertion(+), 1 del=
etion(-)=0A=0Adiff --git a/lib/Kconfig.debug b/lib/Kconfig.debug=0Aindex 7f=
d3fa05379e..095156b70cbe 100644=0A--- a/lib/Kconfig.debug=0A+++ b/lib/Kconf=
ig.debug=0A@@ -295,7 +295,7 @@ config DEBUG_INFO_DWARF4=0A =0A config DEBUG=
_INFO_DWARF5=0A 	bool "Generate DWARF Version 5 debuginfo"=0A-	depends on !=
CC_IS_CLANG || (CC_IS_CLANG && (AS_IS_LLVM || (AS_IS_GNU && AS_VERSION >=3D=
 23502)))=0A+	depends on !CC_IS_CLANG || AS_IS_LLVM || (AS_IS_GNU && AS_VER=
SION >=3D 23502)=0A 	depends on !DEBUG_INFO_BTF=0A 	help=0A 	  Generate DWA=
RF v5 debug info. Requires binutils 2.35.2, gcc 5.0+ (gcc=0A=0Abase-commit:=
 a3f2f5ac9d61e973e383f17a95cf2aa384e2d0c4=0A-- =0A2.38.0=0A=0A=0AFrom 6e330=
77ffa24e3839efbbe4e4dd357e262668869 Mon Sep 17 00:00:00 2001=0AFrom: Masahi=
ro Yamada <masahiroy@kernel.org>=0ADate: Wed, 5 Oct 2022 01:29:04 +0900=0AS=
ubject: [PATCH 5.15 2/3] Kconfig.debug: add toolchain checks for=0A DEBUG_I=
NFO_DWARF_TOOLCHAIN_DEFAULT=0A=0Acommit bb1435f3f575b5213eaf27434efa3971f51=
c01de upstream.=0A=0ACONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT does not giv=
e explicit=0A-gdwarf-* flag. The actual DWARF version is up to the toolchai=
n.=0A=0AThe combination of GCC and GAS works fine, and Clang with the integ=
rated=0Aassembler is good too.=0A=0AThe combination of Clang and GAS is tri=
cky, but at least, the -g flag=0Aworks for Clang <=3D13, which defaults to =
DWARF v4.=0A=0AClang 14 switched its default to DWARF v5.=0A=0ANow, CONFIG_=
DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT has the same issue as=0Aaddressed by com=
mit 98cd6f521f10 ("Kconfig: allow explicit opt in to=0ADWARF v5").=0A=0ACON=
FIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=3Dy for Clang >=3D 14 and=0AGAS < 2.=
35 produces a ton of errors like follows:=0A=0A  /tmp/main-c2741c.s: Assemb=
ler messages:=0A  /tmp/main-c2741c.s:109: Error: junk at end of line, first=
 unrecognized character is `"'=0A  /tmp/main-c2741c.s:109: Error: file numb=
er less than one=0A=0AAdd 'depends on' to check toolchains.=0A=0ASigned-off=
-by: Masahiro Yamada <masahiroy@kernel.org>=0AReviewed-by: Nathan Chancello=
r <nathan@kernel.org>=0A[nathan: Fix conflict due to lack of f9b3cd24578401=
e]=0ASigned-off-by: Nathan Chancellor <nathan@kernel.org>=0A---=0A lib/Kcon=
fig.debug | 1 +=0A 1 file changed, 1 insertion(+)=0A=0Adiff --git a/lib/Kco=
nfig.debug b/lib/Kconfig.debug=0Aindex 095156b70cbe..646778e68f00 100644=0A=
--- a/lib/Kconfig.debug=0A+++ b/lib/Kconfig.debug=0A@@ -274,6 +274,7 @@ cho=
ice=0A =0A config DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=0A 	bool "Rely on the =
toolchain's implicit default DWARF version"=0A+	depends on !CC_IS_CLANG || =
AS_IS_LLVM || CLANG_VERSION < 140000 || (AS_IS_GNU && AS_VERSION >=3D 23502=
)=0A 	help=0A 	  The implicit default version of DWARF debug info produced =
by a=0A 	  toolchain changes over time.=0A-- =0A2.38.0=0A=0A=0AFrom 5b99cc8=
4231bc3887a7c24633f8d2c3fd6f97a58 Mon Sep 17 00:00:00 2001=0AFrom: Nathan C=
hancellor <nathan@kernel.org>=0ADate: Fri, 14 Oct 2022 13:42:11 -0700=0ASub=
ject: [PATCH 5.15 3/3] lib/Kconfig.debug: Add check for non-constant=0A .{s=
,u}leb128 support to DWARF5=0A=0Acommit 0a6de78cff600cb991f2a1b7ed376935871=
796a0 upstream.=0A=0AWhen building with a RISC-V kernel with DWARF5 debug i=
nfo using clang=0Aand the GNU assembler, several instances of the following=
 error appear:=0A=0A  /tmp/vgettimeofday-48aa35.s:2963: Error: non-constant=
 .uleb128 is not supported=0A=0ADumping the .s file reveals these .uleb128 =
directives come from=0A.debug_loc and .debug_ranges:=0A=0A  .Ldebug_loc0:=
=0A          .byte   4                               # DW_LLE_offset_pair=
=0A          .uleb128 .Lfunc_begin0-.Lfunc_begin0    #   starting offset=0A=
          .uleb128 .Ltmp1-.Lfunc_begin0           #   ending offset=0A     =
     .byte   1                               # Loc expr size=0A          .b=
yte   90                              # DW_OP_reg10=0A          .byte   0  =
                             # DW_LLE_end_of_list=0A=0A  .Ldebug_ranges0:=
=0A          .byte   4                               # DW_RLE_offset_pair=
=0A          .uleb128 .Ltmp6-.Lfunc_begin0           #   starting offset=0A=
          .uleb128 .Ltmp27-.Lfunc_begin0          #   ending offset=0A     =
     .byte   4                               # DW_RLE_offset_pair=0A       =
   .uleb128 .Ltmp28-.Lfunc_begin0          #   starting offset=0A          =
=2Euleb128 .Ltmp30-.Lfunc_begin0          #   ending offset=0A          .by=
te   0                               # DW_RLE_end_of_list=0A=0AThere is an =
outstanding binutils issue to support a non-constant operand=0Ato .sleb128 =
and .uleb128 in GAS for RISC-V but there does not appear to=0Abe any moveme=
nt on it, due to concerns over how it would work with=0Alinker relaxation.=
=0A=0ATo avoid these build errors, prevent DWARF5 from being selected when=
=0Ausing clang and an assembler that does not have support for these symbol=
=0Adeltas, which can be easily checked in Kconfig with as-instr plus the=0A=
small test program from the dwz test suite from the binutils issue.=0A=0ALi=
nk: https://sourceware.org/bugzilla/show_bug.cgi?id=3D27215=0ALink: https:/=
/github.com/ClangBuiltLinux/linux/issues/1719=0ASigned-off-by: Nathan Chanc=
ellor <nathan@kernel.org>=0AReviewed-by: Nick Desaulniers <ndesaulniers@goo=
gle.com>=0ASigned-off-by: Masahiro Yamada <masahiroy@kernel.org>=0A[nathan:=
 Fix conflicts due to lack of f9b3cd24578401e]=0ASigned-off-by: Nathan Chan=
cellor <nathan@kernel.org>=0A---=0A lib/Kconfig.debug | 9 +++++++--=0A 1 fi=
le changed, 7 insertions(+), 2 deletions(-)=0A=0Adiff --git a/lib/Kconfig.d=
ebug b/lib/Kconfig.debug=0Aindex 646778e68f00..1699b2124558 100644=0A--- a/=
lib/Kconfig.debug=0A+++ b/lib/Kconfig.debug=0A@@ -208,6 +208,11 @@ config D=
EBUG_BUGVERBOSE=0A =0A endmenu # "printk and dmesg options"=0A =0A+# Clang =
is known to generate .{s,u}leb128 with symbol deltas with DWARF5, which=0A+=
# some targets may not support: https://sourceware.org/bugzilla/show_bug.cg=
i?id=3D27215=0A+config AS_HAS_NON_CONST_LEB128=0A+	def_bool $(as-instr,.ule=
b128 .Lexpr_end4 - .Lexpr_start3\n.Lexpr_start3:\n.Lexpr_end4:)=0A+=0A menu=
 "Compile-time checks and compiler options"=0A =0A config DEBUG_INFO=0A@@ -=
274,7 +279,7 @@ choice=0A =0A config DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=0A =
	bool "Rely on the toolchain's implicit default DWARF version"=0A-	depends =
on !CC_IS_CLANG || AS_IS_LLVM || CLANG_VERSION < 140000 || (AS_IS_GNU && AS=
_VERSION >=3D 23502)=0A+	depends on !CC_IS_CLANG || AS_IS_LLVM || CLANG_VER=
SION < 140000 || (AS_IS_GNU && AS_VERSION >=3D 23502 && AS_HAS_NON_CONST_LE=
B128)=0A 	help=0A 	  The implicit default version of DWARF debug info produ=
ced by a=0A 	  toolchain changes over time.=0A@@ -296,7 +301,7 @@ config DE=
BUG_INFO_DWARF4=0A =0A config DEBUG_INFO_DWARF5=0A 	bool "Generate DWARF Ve=
rsion 5 debuginfo"=0A-	depends on !CC_IS_CLANG || AS_IS_LLVM || (AS_IS_GNU =
&& AS_VERSION >=3D 23502)=0A+	depends on !CC_IS_CLANG || AS_IS_LLVM || (AS_=
IS_GNU && AS_VERSION >=3D 23502 && AS_HAS_NON_CONST_LEB128)=0A 	depends on =
!DEBUG_INFO_BTF=0A 	help=0A 	  Generate DWARF v5 debug info. Requires binut=
ils 2.35.2, gcc 5.0+ (gcc=0A-- =0A2.38.0=0A=0A
--lRArZorZLPlzaoQg--
