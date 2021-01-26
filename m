Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF3A8304C21
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 23:28:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727389AbhAZWBH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 17:01:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:43272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728656AbhAZU62 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Jan 2021 15:58:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95774221EF;
        Tue, 26 Jan 2021 20:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611694666;
        bh=LT/2xDC/IcAQS0U6Ow4SjbSH5RpwS5qjp6X7NPWRP0o=;
        h=Date:From:To:Cc:Subject:From;
        b=H6ev4GpEYbdm4jMyIxIswaKjbrcmZJ+nrYgeB5WlCRDu783QA2/ucWtJfMDjglzWw
         myXKLWWU/8MYhUMupjSPq7W2IP7jDNdiEk0IpL84zV9CCZXhIZRtXK/DFoKNmgu6TK
         Ls1iExpgTsrYTUYsCu0g4aXsj5Wa6MQlxDaqSZ0lM8pGlnK8Ver3H0QznnAhIPb974
         OZzeXnt3F7gpu+J1NCZmRCfRkoZJ/HwueF8jIaWapb88+7nUmFwrnMDSWS1GbCnq6T
         7GNDHDWUfPuf4pR1vOnRsb1TnI/utsqbdaNGVl0J+pbOLUO39uOVl1ISMc5krmluzo
         y3Ny0G5ngYBcg==
Date:   Tue, 26 Jan 2021 13:57:43 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>,
        clang-built-linux@googlegroups.com
Subject: Backport of 09e43968db40 to 4.14, 4.9, and 4.4
Message-ID: <20210126205743.GA2093914@ubuntu-m3-large-x86>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="LZvS9be/3tNcYl/X"
Content-Disposition: inline
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg and Sasha,

Please find attached backports of 09e43968db40 ("x86/boot/compressed:
Disable relocation relaxation"), targeting 4.14, 4.9, and 4.4. This
fixes an observed boot failure in our CI:

https://github.com/ClangBuiltLinux/continuous-integration2/runs/1766193534

Cheers,
Nathan

--LZvS9be/3tNcYl/X
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="4.14-09e43968db40.patch"

From f123004e00dcb4083a6faf062cdcfa94673cb65a Mon Sep 17 00:00:00 2001
From: Arvind Sankar <nivedita@alum.mit.edu>
Date: Tue, 11 Aug 2020 20:43:08 -0400
Subject: [PATCH 4.14] x86/boot/compressed: Disable relocation relaxation

commit 09e43968db40c33a73e9ddbfd937f46d5c334924 upstream.

The x86-64 psABI [0] specifies special relocation types
(R_X86_64_[REX_]GOTPCRELX) for indirection through the Global Offset
Table, semantically equivalent to R_X86_64_GOTPCREL, which the linker
can take advantage of for optimization (relaxation) at link time. This
is supported by LLD and binutils versions 2.26 onwards.

The compressed kernel is position-independent code, however, when using
LLD or binutils versions before 2.27, it must be linked without the -pie
option. In this case, the linker may optimize certain instructions into
a non-position-independent form, by converting foo@GOTPCREL(%rip) to $foo.

This potential issue has been present with LLD and binutils-2.26 for a
long time, but it has never manifested itself before now:

- LLD and binutils-2.26 only relax
	movq	foo@GOTPCREL(%rip), %reg
  to
	leaq	foo(%rip), %reg
  which is still position-independent, rather than
	mov	$foo, %reg
  which is permitted by the psABI when -pie is not enabled.

- GCC happens to only generate GOTPCREL relocations on mov instructions.

- CLang does generate GOTPCREL relocations on non-mov instructions, but
  when building the compressed kernel, it uses its integrated assembler
  (due to the redefinition of KBUILD_CFLAGS dropping -no-integrated-as),
  which has so far defaulted to not generating the GOTPCRELX
  relocations.

Nick Desaulniers reports [1,2]:

  "A recent change [3] to a default value of configuration variable
   (ENABLE_X86_RELAX_RELOCATIONS OFF -> ON) in LLVM now causes Clang's
   integrated assembler to emit R_X86_64_GOTPCRELX/R_X86_64_REX_GOTPCRELX
   relocations. LLD will relax instructions with these relocations based
   on whether the image is being linked as position independent or not.
   When not, then LLD will relax these instructions to use absolute
   addressing mode (R_RELAX_GOT_PC_NOPIC). This causes kernels built with
   Clang and linked with LLD to fail to boot."

Patch series [4] is a solution to allow the compressed kernel to be
linked with -pie unconditionally, but even if merged is unlikely to be
backported. As a simple solution that can be applied to stable as well,
prevent the assembler from generating the relaxed relocation types using
the -mrelax-relocations=no option. For ease of backporting, do this
unconditionally.

[0] https://gitlab.com/x86-psABIs/x86-64-ABI/-/blob/master/x86-64-ABI/linker-optimization.tex#L65
[1] https://lore.kernel.org/lkml/20200807194100.3570838-1-ndesaulniers@google.com/
[2] https://github.com/ClangBuiltLinux/linux/issues/1121
[3] https://reviews.llvm.org/rGc41a18cf61790fc898dcda1055c3efbf442c14c0
[4] https://lore.kernel.org/lkml/20200731202738.2577854-1-nivedita@alum.mit.edu/

Reported-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200812004308.1448603-1-nivedita@alum.mit.edu
[nc: Backport to 4.14]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/x86/boot/compressed/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 3a250ca2406c..644f9e14cb09 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -36,6 +36,8 @@ KBUILD_CFLAGS += -mno-mmx -mno-sse
 KBUILD_CFLAGS += $(call cc-option,-ffreestanding)
 KBUILD_CFLAGS += $(call cc-option,-fno-stack-protector)
 KBUILD_CFLAGS += $(call cc-disable-warning, address-of-packed-member)
+# Disable relocation relaxation in case the link is not PIE.
+KBUILD_CFLAGS += $(call as-option,-Wa$(comma)-mrelax-relocations=no)
 
 KBUILD_AFLAGS  := $(KBUILD_CFLAGS) -D__ASSEMBLY__
 GCOV_PROFILE := n

base-commit: 2d2791fce891fc20709232d49a6bae075b9a77f8
-- 
2.30.0


--LZvS9be/3tNcYl/X
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="4.9-09e43968db40.patch"

From b5488c5acc9ad2123117fdb5fbcaaa4a9bcb84e3 Mon Sep 17 00:00:00 2001
From: Arvind Sankar <nivedita@alum.mit.edu>
Date: Tue, 11 Aug 2020 20:43:08 -0400
Subject: [PATCH 4.9] x86/boot/compressed: Disable relocation relaxation

commit 09e43968db40c33a73e9ddbfd937f46d5c334924 upstream.

The x86-64 psABI [0] specifies special relocation types
(R_X86_64_[REX_]GOTPCRELX) for indirection through the Global Offset
Table, semantically equivalent to R_X86_64_GOTPCREL, which the linker
can take advantage of for optimization (relaxation) at link time. This
is supported by LLD and binutils versions 2.26 onwards.

The compressed kernel is position-independent code, however, when using
LLD or binutils versions before 2.27, it must be linked without the -pie
option. In this case, the linker may optimize certain instructions into
a non-position-independent form, by converting foo@GOTPCREL(%rip) to $foo.

This potential issue has been present with LLD and binutils-2.26 for a
long time, but it has never manifested itself before now:

- LLD and binutils-2.26 only relax
	movq	foo@GOTPCREL(%rip), %reg
  to
	leaq	foo(%rip), %reg
  which is still position-independent, rather than
	mov	$foo, %reg
  which is permitted by the psABI when -pie is not enabled.

- GCC happens to only generate GOTPCREL relocations on mov instructions.

- CLang does generate GOTPCREL relocations on non-mov instructions, but
  when building the compressed kernel, it uses its integrated assembler
  (due to the redefinition of KBUILD_CFLAGS dropping -no-integrated-as),
  which has so far defaulted to not generating the GOTPCRELX
  relocations.

Nick Desaulniers reports [1,2]:

  "A recent change [3] to a default value of configuration variable
   (ENABLE_X86_RELAX_RELOCATIONS OFF -> ON) in LLVM now causes Clang's
   integrated assembler to emit R_X86_64_GOTPCRELX/R_X86_64_REX_GOTPCRELX
   relocations. LLD will relax instructions with these relocations based
   on whether the image is being linked as position independent or not.
   When not, then LLD will relax these instructions to use absolute
   addressing mode (R_RELAX_GOT_PC_NOPIC). This causes kernels built with
   Clang and linked with LLD to fail to boot."

Patch series [4] is a solution to allow the compressed kernel to be
linked with -pie unconditionally, but even if merged is unlikely to be
backported. As a simple solution that can be applied to stable as well,
prevent the assembler from generating the relaxed relocation types using
the -mrelax-relocations=no option. For ease of backporting, do this
unconditionally.

[0] https://gitlab.com/x86-psABIs/x86-64-ABI/-/blob/master/x86-64-ABI/linker-optimization.tex#L65
[1] https://lore.kernel.org/lkml/20200807194100.3570838-1-ndesaulniers@google.com/
[2] https://github.com/ClangBuiltLinux/linux/issues/1121
[3] https://reviews.llvm.org/rGc41a18cf61790fc898dcda1055c3efbf442c14c0
[4] https://lore.kernel.org/lkml/20200731202738.2577854-1-nivedita@alum.mit.edu/

Reported-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200812004308.1448603-1-nivedita@alum.mit.edu
[nc: Backport to 4.9]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/x86/boot/compressed/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 89b163351e64..7be7acd6a540 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -35,6 +35,8 @@ KBUILD_CFLAGS += -mno-mmx -mno-sse
 KBUILD_CFLAGS += $(call cc-option,-ffreestanding)
 KBUILD_CFLAGS += $(call cc-option,-fno-stack-protector)
 KBUILD_CFLAGS += $(call cc-disable-warning, address-of-packed-member)
+# Disable relocation relaxation in case the link is not PIE.
+KBUILD_CFLAGS += $(call as-option,-Wa$(comma)-mrelax-relocations=no)
 
 KBUILD_AFLAGS  := $(KBUILD_CFLAGS) -D__ASSEMBLY__
 GCOV_PROFILE := n

base-commit: 8db42574fc93d05e7f1f5fbd88af55f4f69ff586
-- 
2.30.0


--LZvS9be/3tNcYl/X
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="4.4-09e43968db40.patch"

From 68e7a6bb917358c767187d34cc8f8184e64e0ade Mon Sep 17 00:00:00 2001
From: Arvind Sankar <nivedita@alum.mit.edu>
Date: Tue, 11 Aug 2020 20:43:08 -0400
Subject: [PATCH 4.4] x86/boot/compressed: Disable relocation relaxation

commit 09e43968db40c33a73e9ddbfd937f46d5c334924 upstream.

The x86-64 psABI [0] specifies special relocation types
(R_X86_64_[REX_]GOTPCRELX) for indirection through the Global Offset
Table, semantically equivalent to R_X86_64_GOTPCREL, which the linker
can take advantage of for optimization (relaxation) at link time. This
is supported by LLD and binutils versions 2.26 onwards.

The compressed kernel is position-independent code, however, when using
LLD or binutils versions before 2.27, it must be linked without the -pie
option. In this case, the linker may optimize certain instructions into
a non-position-independent form, by converting foo@GOTPCREL(%rip) to $foo.

This potential issue has been present with LLD and binutils-2.26 for a
long time, but it has never manifested itself before now:

- LLD and binutils-2.26 only relax
	movq	foo@GOTPCREL(%rip), %reg
  to
	leaq	foo(%rip), %reg
  which is still position-independent, rather than
	mov	$foo, %reg
  which is permitted by the psABI when -pie is not enabled.

- GCC happens to only generate GOTPCREL relocations on mov instructions.

- CLang does generate GOTPCREL relocations on non-mov instructions, but
  when building the compressed kernel, it uses its integrated assembler
  (due to the redefinition of KBUILD_CFLAGS dropping -no-integrated-as),
  which has so far defaulted to not generating the GOTPCRELX
  relocations.

Nick Desaulniers reports [1,2]:

  "A recent change [3] to a default value of configuration variable
   (ENABLE_X86_RELAX_RELOCATIONS OFF -> ON) in LLVM now causes Clang's
   integrated assembler to emit R_X86_64_GOTPCRELX/R_X86_64_REX_GOTPCRELX
   relocations. LLD will relax instructions with these relocations based
   on whether the image is being linked as position independent or not.
   When not, then LLD will relax these instructions to use absolute
   addressing mode (R_RELAX_GOT_PC_NOPIC). This causes kernels built with
   Clang and linked with LLD to fail to boot."

Patch series [4] is a solution to allow the compressed kernel to be
linked with -pie unconditionally, but even if merged is unlikely to be
backported. As a simple solution that can be applied to stable as well,
prevent the assembler from generating the relaxed relocation types using
the -mrelax-relocations=no option. For ease of backporting, do this
unconditionally.

[0] https://gitlab.com/x86-psABIs/x86-64-ABI/-/blob/master/x86-64-ABI/linker-optimization.tex#L65
[1] https://lore.kernel.org/lkml/20200807194100.3570838-1-ndesaulniers@google.com/
[2] https://github.com/ClangBuiltLinux/linux/issues/1121
[3] https://reviews.llvm.org/rGc41a18cf61790fc898dcda1055c3efbf442c14c0
[4] https://lore.kernel.org/lkml/20200731202738.2577854-1-nivedita@alum.mit.edu/

Reported-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200812004308.1448603-1-nivedita@alum.mit.edu
[nc: Backport to 4.4]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/x86/boot/compressed/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index bf0c7b6b00c3..01eafd8aeec6 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -31,6 +31,8 @@ KBUILD_CFLAGS += -mno-mmx -mno-sse
 KBUILD_CFLAGS += $(call cc-option,-ffreestanding)
 KBUILD_CFLAGS += $(call cc-option,-fno-stack-protector)
 KBUILD_CFLAGS += $(call cc-disable-warning, address-of-packed-member)
+# Disable relocation relaxation in case the link is not PIE.
+KBUILD_CFLAGS += $(call as-option,-Wa$(comma)-mrelax-relocations=no)
 
 KBUILD_AFLAGS  := $(KBUILD_CFLAGS) -D__ASSEMBLY__
 GCOV_PROFILE := n

base-commit: 4f907dff9d3629fc87f9608770168b68958a9f46
-- 
2.30.0


--LZvS9be/3tNcYl/X--
