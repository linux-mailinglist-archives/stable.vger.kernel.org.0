Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED5A74F5445
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 06:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1441855AbiDFEqs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 00:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385501AbiDEVto (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 17:49:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A2D5186C5
        for <stable@vger.kernel.org>; Tue,  5 Apr 2022 13:58:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C3F9960AB4
        for <stable@vger.kernel.org>; Tue,  5 Apr 2022 20:58:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D02D2C385A0;
        Tue,  5 Apr 2022 20:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649192308;
        bh=eru2Fy69RsSDkjv/6kZY48cRU1bMEv/tRs0hL3gMK/M=;
        h=Date:From:To:Cc:Subject:From;
        b=lpC9c26crkilPCr92M+qECX2Kbis0f2TAy1vcntV7gH/jrMjFUUVJSqdMkp8VkIMQ
         Rg4bNvuu46FjjzbTLPoRoFLXYd/5dLaW1E2yR2EM5tvuW2gpVdHUOH6jc9VN+u1nIE
         8Z5DdFvoMQ3ccYggbOODIi2xg2x7XJTXLedciao9TWV+o+++qyWb2buueTlnCIQfmh
         Tkz+6WHKmjNm5dBADTwIC9PJY61A575F5kXt7Kx3kWKFa/qtU2Jf8RrB5/OZtR/Smm
         hFTUHoJA4pgOVS8DnEs6WuGSbhvWMY14wyh8pTeWMB0/Lfymbi/u7wsUrJXQMWGtcZ
         SNiewluAx71Qw==
Date:   Tue, 5 Apr 2022 13:58:26 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, llvm@lists.linux.dev,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: Backport of 4013e26670c5 and 60210a3d86dc for 4.9 to 5.10
Message-ID: <Ykytcg+xI/MRSLue@dev-arch.thelio-3990X>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="dl877+ljsnFOzQiu"
Content-Disposition: inline
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--dl877+ljsnFOzQiu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg and Sasha,

Please find attached backports for commits 4013e26670c5 ("arm64: module:
remove (NOLOAD) from linker script") and 60210a3d86dc ("riscv module:
remove (NOLOAD)") to 4.9 through 5.10, where applicable. They resolve a
spew of warnings when linking modules with ld.lld. 4013e26670c5 is
currently queued from 5.15 to 5.17 and 60210a3d86dc is queued for 5.10
through 5.17, as that is where they applied cleanly.

Cheers,
Nathan

--dl877+ljsnFOzQiu
Content-Type: application/mbox
Content-Disposition: attachment; filename="4.9.mbox"
Content-Transfer-Encoding: quoted-printable

=46rom 7e3e029e004b656c99ef9a703c9da40c01258ea7 Mon Sep 17 00:00:00 2001=0A=
=46rom: Fangrui Song <maskray@google.com>=0ADate: Fri, 18 Feb 2022 00:12:09=
 -0800=0ASubject: [PATCH 4.9] arm64: module: remove (NOLOAD) from linker sc=
ript=0A=0Acommit 4013e26670c590944abdab56c4fa797527b74325 upstream.=0A=0AOn=
 ELF, (NOLOAD) sets the section type to SHT_NOBITS[1]. It is conceptually=
=0Ainappropriate for .plt and .text.* sections which are always=0ASHT_PROGB=
ITS.=0A=0AIn GNU ld, if PLT entries are needed, .plt will be SHT_PROGBITS a=
nyway=0Aand (NOLOAD) will be essentially ignored. In ld.lld, since=0Ahttps:=
//reviews.llvm.org/D118840 ("[ELF] Support (TYPE=3D<value>) to=0Acustomize =
the output section type"), ld.lld will report a `section type=0Amismatch` e=
rror. Just remove (NOLOAD) to fix the error.=0A=0A[1] https://lld.llvm.org/=
ELF/linker_script.html As of today, "The=0Asection should be marked as not =
loadable" on=0Ahttps://sourceware.org/binutils/docs/ld/Output-Section-Type.=
html is=0Aoutdated for ELF.=0A=0ATested-by: Nathan Chancellor <nathan@kerne=
l.org>=0AReported-by: Nathan Chancellor <nathan@kernel.org>=0ASigned-off-by=
: Fangrui Song <maskray@google.com>=0AAcked-by: Ard Biesheuvel <ardb@kernel=
=2Eorg>=0ALink: https://lore.kernel.org/r/20220218081209.354383-1-maskray@g=
oogle.com=0ASigned-off-by: Will Deacon <will@kernel.org>=0A[nathan: Fix con=
flicts due to lack of 596b0474d3d9, be0f272bfc83, and 24af6c4e4e0f]=0ASigne=
d-off-by: Nathan Chancellor <nathan@kernel.org>=0A---=0A arch/arm64/kernel/=
module.lds | 2 +-=0A 1 file changed, 1 insertion(+), 1 deletion(-)=0A=0Adif=
f --git a/arch/arm64/kernel/module.lds b/arch/arm64/kernel/module.lds=0Aind=
ex 8949f6c6f729..05881e2b414c 100644=0A--- a/arch/arm64/kernel/module.lds=
=0A+++ b/arch/arm64/kernel/module.lds=0A@@ -1,3 +1,3 @@=0A SECTIONS {=0A-	.=
plt (NOLOAD) : { BYTE(0) }=0A+	.plt : { BYTE(0) }=0A }=0A=0Abase-commit: ae=
62da6ae3f6d9c7ea62960573f8a48df434e7a4=0A-- =0A2.35.1=0A=0A
--dl877+ljsnFOzQiu
Content-Type: application/mbox
Content-Disposition: attachment; filename="4.14.mbox"
Content-Transfer-Encoding: quoted-printable

=46rom d1ba6cd4afa9b9dd4295ad0f5833ecebab8e93f5 Mon Sep 17 00:00:00 2001=0A=
=46rom: Fangrui Song <maskray@google.com>=0ADate: Fri, 18 Feb 2022 00:12:09=
 -0800=0ASubject: [PATCH 4.14] arm64: module: remove (NOLOAD) from linker s=
cript=0A=0Acommit 4013e26670c590944abdab56c4fa797527b74325 upstream.=0A=0AO=
n ELF, (NOLOAD) sets the section type to SHT_NOBITS[1]. It is conceptually=
=0Ainappropriate for .plt and .text.* sections which are always=0ASHT_PROGB=
ITS.=0A=0AIn GNU ld, if PLT entries are needed, .plt will be SHT_PROGBITS a=
nyway=0Aand (NOLOAD) will be essentially ignored. In ld.lld, since=0Ahttps:=
//reviews.llvm.org/D118840 ("[ELF] Support (TYPE=3D<value>) to=0Acustomize =
the output section type"), ld.lld will report a `section type=0Amismatch` e=
rror. Just remove (NOLOAD) to fix the error.=0A=0A[1] https://lld.llvm.org/=
ELF/linker_script.html As of today, "The=0Asection should be marked as not =
loadable" on=0Ahttps://sourceware.org/binutils/docs/ld/Output-Section-Type.=
html is=0Aoutdated for ELF.=0A=0ATested-by: Nathan Chancellor <nathan@kerne=
l.org>=0AReported-by: Nathan Chancellor <nathan@kernel.org>=0ASigned-off-by=
: Fangrui Song <maskray@google.com>=0AAcked-by: Ard Biesheuvel <ardb@kernel=
=2Eorg>=0ALink: https://lore.kernel.org/r/20220218081209.354383-1-maskray@g=
oogle.com=0ASigned-off-by: Will Deacon <will@kernel.org>=0A[nathan: Fix con=
flicts due to lack of 596b0474d3d9]=0ASigned-off-by: Nathan Chancellor <nat=
han@kernel.org>=0A---=0A arch/arm64/kernel/module.lds | 6 +++---=0A 1 file =
changed, 3 insertions(+), 3 deletions(-)=0A=0Adiff --git a/arch/arm64/kerne=
l/module.lds b/arch/arm64/kernel/module.lds=0Aindex 09a0eef71d12..9371abe2f=
4c2 100644=0A--- a/arch/arm64/kernel/module.lds=0A+++ b/arch/arm64/kernel/m=
odule.lds=0A@@ -1,5 +1,5 @@=0A SECTIONS {=0A-	.plt 0 (NOLOAD) : { BYTE(0) }=
=0A-	.init.plt 0 (NOLOAD) : { BYTE(0) }=0A-	.text.ftrace_trampoline 0 (NOLO=
AD) : { BYTE(0) }=0A+	.plt 0 : { BYTE(0) }=0A+	.init.plt 0 : { BYTE(0) }=0A=
+	.text.ftrace_trampoline 0 : { BYTE(0) }=0A }=0A=0Abase-commit: 74766a9736=
37a02c32c04c1c6496e114e4855239=0A-- =0A2.35.1=0A=0A
--dl877+ljsnFOzQiu
Content-Type: application/mbox
Content-Disposition: attachment; filename="4.19.mbox"
Content-Transfer-Encoding: quoted-printable

=46rom 8f7d798d2e47e4844dacd66558aee52a598d67ad Mon Sep 17 00:00:00 2001=0A=
=46rom: Fangrui Song <maskray@google.com>=0ADate: Fri, 18 Feb 2022 00:12:09=
 -0800=0ASubject: [PATCH 4.19] arm64: module: remove (NOLOAD) from linker s=
cript=0A=0Acommit 4013e26670c590944abdab56c4fa797527b74325 upstream.=0A=0AO=
n ELF, (NOLOAD) sets the section type to SHT_NOBITS[1]. It is conceptually=
=0Ainappropriate for .plt and .text.* sections which are always=0ASHT_PROGB=
ITS.=0A=0AIn GNU ld, if PLT entries are needed, .plt will be SHT_PROGBITS a=
nyway=0Aand (NOLOAD) will be essentially ignored. In ld.lld, since=0Ahttps:=
//reviews.llvm.org/D118840 ("[ELF] Support (TYPE=3D<value>) to=0Acustomize =
the output section type"), ld.lld will report a `section type=0Amismatch` e=
rror. Just remove (NOLOAD) to fix the error.=0A=0A[1] https://lld.llvm.org/=
ELF/linker_script.html As of today, "The=0Asection should be marked as not =
loadable" on=0Ahttps://sourceware.org/binutils/docs/ld/Output-Section-Type.=
html is=0Aoutdated for ELF.=0A=0ATested-by: Nathan Chancellor <nathan@kerne=
l.org>=0AReported-by: Nathan Chancellor <nathan@kernel.org>=0ASigned-off-by=
: Fangrui Song <maskray@google.com>=0AAcked-by: Ard Biesheuvel <ardb@kernel=
=2Eorg>=0ALink: https://lore.kernel.org/r/20220218081209.354383-1-maskray@g=
oogle.com=0ASigned-off-by: Will Deacon <will@kernel.org>=0A[nathan: Fix con=
flicts due to lack of 596b0474d3d9]=0ASigned-off-by: Nathan Chancellor <nat=
han@kernel.org>=0A---=0A arch/arm64/kernel/module.lds | 6 +++---=0A 1 file =
changed, 3 insertions(+), 3 deletions(-)=0A=0Adiff --git a/arch/arm64/kerne=
l/module.lds b/arch/arm64/kernel/module.lds=0Aindex 09a0eef71d12..9371abe2f=
4c2 100644=0A--- a/arch/arm64/kernel/module.lds=0A+++ b/arch/arm64/kernel/m=
odule.lds=0A@@ -1,5 +1,5 @@=0A SECTIONS {=0A-	.plt 0 (NOLOAD) : { BYTE(0) }=
=0A-	.init.plt 0 (NOLOAD) : { BYTE(0) }=0A-	.text.ftrace_trampoline 0 (NOLO=
AD) : { BYTE(0) }=0A+	.plt 0 : { BYTE(0) }=0A+	.init.plt 0 : { BYTE(0) }=0A=
+	.text.ftrace_trampoline 0 : { BYTE(0) }=0A }=0A=0Abase-commit: a6e4a1818e=
fa77621b27b5055cea85873b5e1f83=0A-- =0A2.35.1=0A=0A
--dl877+ljsnFOzQiu
Content-Type: application/mbox
Content-Disposition: attachment; filename="5.4.mbox"
Content-Transfer-Encoding: quoted-printable

=46rom ad1018755e5368bdfb9de2ab87d03002a1344ddf Mon Sep 17 00:00:00 2001=0A=
=46rom: Fangrui Song <maskray@google.com>=0ADate: Fri, 18 Feb 2022 00:12:09=
 -0800=0ASubject: [PATCH 5.4 1/2] arm64: module: remove (NOLOAD) from linke=
r script=0A=0Acommit 4013e26670c590944abdab56c4fa797527b74325 upstream.=0A=
=0AOn ELF, (NOLOAD) sets the section type to SHT_NOBITS[1]. It is conceptua=
lly=0Ainappropriate for .plt and .text.* sections which are always=0ASHT_PR=
OGBITS.=0A=0AIn GNU ld, if PLT entries are needed, .plt will be SHT_PROGBIT=
S anyway=0Aand (NOLOAD) will be essentially ignored. In ld.lld, since=0Ahtt=
ps://reviews.llvm.org/D118840 ("[ELF] Support (TYPE=3D<value>) to=0Acustomi=
ze the output section type"), ld.lld will report a `section type=0Amismatch=
` error. Just remove (NOLOAD) to fix the error.=0A=0A[1] https://lld.llvm.o=
rg/ELF/linker_script.html As of today, "The=0Asection should be marked as n=
ot loadable" on=0Ahttps://sourceware.org/binutils/docs/ld/Output-Section-Ty=
pe.html is=0Aoutdated for ELF.=0A=0ATested-by: Nathan Chancellor <nathan@ke=
rnel.org>=0AReported-by: Nathan Chancellor <nathan@kernel.org>=0ASigned-off=
-by: Fangrui Song <maskray@google.com>=0AAcked-by: Ard Biesheuvel <ardb@ker=
nel.org>=0ALink: https://lore.kernel.org/r/20220218081209.354383-1-maskray@=
google.com=0ASigned-off-by: Will Deacon <will@kernel.org>=0A[nathan: Fix co=
nflicts due to lack of 596b0474d3d9]=0ASigned-off-by: Nathan Chancellor <na=
than@kernel.org>=0A---=0A arch/arm64/kernel/module.lds | 6 +++---=0A 1 file=
 changed, 3 insertions(+), 3 deletions(-)=0A=0Adiff --git a/arch/arm64/kern=
el/module.lds b/arch/arm64/kernel/module.lds=0Aindex 09a0eef71d12..9371abe2=
f4c2 100644=0A--- a/arch/arm64/kernel/module.lds=0A+++ b/arch/arm64/kernel/=
module.lds=0A@@ -1,5 +1,5 @@=0A SECTIONS {=0A-	.plt 0 (NOLOAD) : { BYTE(0) =
}=0A-	.init.plt 0 (NOLOAD) : { BYTE(0) }=0A-	.text.ftrace_trampoline 0 (NOL=
OAD) : { BYTE(0) }=0A+	.plt 0 : { BYTE(0) }=0A+	.init.plt 0 : { BYTE(0) }=
=0A+	.text.ftrace_trampoline 0 : { BYTE(0) }=0A }=0A=0Abase-commit: 2845ff3=
fd34499603249676495c524a35e795b45=0A-- =0A2.35.1=0A=0A=0AFrom caa6283ed5612=
154de7ab79195d095ea13e57f3e Mon Sep 17 00:00:00 2001=0AFrom: Fangrui Song <=
maskray@google.com>=0ADate: Mon, 21 Mar 2022 18:26:17 -0700=0ASubject: [PAT=
CH 5.4 2/2] riscv module: remove (NOLOAD)=0A=0Acommit 60210a3d86dc57ce4a76a=
366e7841dda746a33f7 upstream.=0A=0AOn ELF, (NOLOAD) sets the section type t=
o SHT_NOBITS[1]. It is conceptually=0Ainappropriate for .plt, .got, and .go=
t.plt sections which are always=0ASHT_PROGBITS.=0A=0AIn GNU ld, if PLT entr=
ies are needed, .plt will be SHT_PROGBITS anyway=0Aand (NOLOAD) will be ess=
entially ignored. In ld.lld, since=0Ahttps://reviews.llvm.org/D118840 ("[EL=
F] Support (TYPE=3D<value>) to=0Acustomize the output section type"), ld.ll=
d will report a `section type=0Amismatch` error (later changed to a warning=
). Just remove (NOLOAD) to=0Afix the warning.=0A=0A[1] https://lld.llvm.org=
/ELF/linker_script.html As of today, "The=0Asection should be marked as not=
 loadable" on=0Ahttps://sourceware.org/binutils/docs/ld/Output-Section-Type=
=2Ehtml is=0Aoutdated for ELF.=0A=0ALink: https://github.com/ClangBuiltLinu=
x/linux/issues/1597=0AFixes: ab1ef68e5401 ("RISC-V: Add sections of PLT and=
 GOT for kernel module")=0AReported-by: Nathan Chancellor <nathan@kernel.or=
g>=0ASigned-off-by: Fangrui Song <maskray@google.com>=0ASigned-off-by: Palm=
er Dabbelt <palmer@rivosinc.com>=0A[nathan: Fix conflicts due to lack of 59=
6b0474d3d9]=0ASigned-off-by: Nathan Chancellor <nathan@kernel.org>=0A---=0A=
 arch/riscv/kernel/module.lds | 6 +++---=0A 1 file changed, 3 insertions(+)=
, 3 deletions(-)=0A=0Adiff --git a/arch/riscv/kernel/module.lds b/arch/risc=
v/kernel/module.lds=0Aindex 295ecfb341a2..18ec719899e2 100644=0A--- a/arch/=
riscv/kernel/module.lds=0A+++ b/arch/riscv/kernel/module.lds=0A@@ -2,7 +2,7=
 @@=0A /* Copyright (C) 2017 Andes Technology Corporation */=0A =0A SECTION=
S {=0A-	.plt (NOLOAD) : { BYTE(0) }=0A-	.got (NOLOAD) : { BYTE(0) }=0A-	.go=
t.plt (NOLOAD) : { BYTE(0) }=0A+	.plt : { BYTE(0) }=0A+	.got : { BYTE(0) }=
=0A+	.got.plt : { BYTE(0) }=0A }=0A-- =0A2.35.1=0A=0A
--dl877+ljsnFOzQiu
Content-Type: application/mbox
Content-Disposition: attachment; filename="5.10.mbox"
Content-Transfer-Encoding: quoted-printable

=46rom 56314ce04d4fff8623f583c6c241b357a87b2997 Mon Sep 17 00:00:00 2001=0A=
=46rom: Fangrui Song <maskray@google.com>=0ADate: Fri, 18 Feb 2022 00:12:09=
 -0800=0ASubject: [PATCH 5.10] arm64: module: remove (NOLOAD) from linker s=
cript=0A=0Acommit 4013e26670c590944abdab56c4fa797527b74325 upstream.=0A=0AO=
n ELF, (NOLOAD) sets the section type to SHT_NOBITS[1]. It is conceptually=
=0Ainappropriate for .plt and .text.* sections which are always=0ASHT_PROGB=
ITS.=0A=0AIn GNU ld, if PLT entries are needed, .plt will be SHT_PROGBITS a=
nyway=0Aand (NOLOAD) will be essentially ignored. In ld.lld, since=0Ahttps:=
//reviews.llvm.org/D118840 ("[ELF] Support (TYPE=3D<value>) to=0Acustomize =
the output section type"), ld.lld will report a `section type=0Amismatch` e=
rror. Just remove (NOLOAD) to fix the error.=0A=0A[1] https://lld.llvm.org/=
ELF/linker_script.html As of today, "The=0Asection should be marked as not =
loadable" on=0Ahttps://sourceware.org/binutils/docs/ld/Output-Section-Type.=
html is=0Aoutdated for ELF.=0A=0ATested-by: Nathan Chancellor <nathan@kerne=
l.org>=0AReported-by: Nathan Chancellor <nathan@kernel.org>=0ASigned-off-by=
: Fangrui Song <maskray@google.com>=0AAcked-by: Ard Biesheuvel <ardb@kernel=
=2Eorg>=0ALink: https://lore.kernel.org/r/20220218081209.354383-1-maskray@g=
oogle.com=0ASigned-off-by: Will Deacon <will@kernel.org>=0A[nathan: Fix con=
flicts due to lack of 1cbdf60bd1b7]=0ASigned-off-by: Nathan Chancellor <nat=
han@kernel.org>=0A---=0A arch/arm64/include/asm/module.lds.h | 6 +++---=0A =
1 file changed, 3 insertions(+), 3 deletions(-)=0A=0Adiff --git a/arch/arm6=
4/include/asm/module.lds.h b/arch/arm64/include/asm/module.lds.h=0Aindex 81=
0045628c66..0522337d600a 100644=0A--- a/arch/arm64/include/asm/module.lds.h=
=0A+++ b/arch/arm64/include/asm/module.lds.h=0A@@ -1,7 +1,7 @@=0A #ifdef CO=
NFIG_ARM64_MODULE_PLTS=0A SECTIONS {=0A-	.plt 0 (NOLOAD) : { BYTE(0) }=0A-	=
=2Einit.plt 0 (NOLOAD) : { BYTE(0) }=0A-	.text.ftrace_trampoline 0 (NOLOAD)=
 : { BYTE(0) }=0A+	.plt 0 : { BYTE(0) }=0A+	.init.plt 0 : { BYTE(0) }=0A+	.=
text.ftrace_trampoline 0 : { BYTE(0) }=0A }=0A #endif=0A=0Abase-commit: d9c=
5818a0bc09e4cc9fe663edb69e4d6cdae4f70=0A-- =0A2.35.1=0A=0A
--dl877+ljsnFOzQiu--
