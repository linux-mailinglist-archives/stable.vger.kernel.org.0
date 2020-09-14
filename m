Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47BFD2692D7
	for <lists+stable@lfdr.de>; Mon, 14 Sep 2020 19:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726349AbgINRRK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Sep 2020 13:17:10 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:34874 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726050AbgINRQp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Sep 2020 13:16:45 -0400
Date:   Mon, 14 Sep 2020 17:16:27 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1600103788;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hKJzvN3Uf4aP8GgYNeDCYfuKOeuXhv5z36Q85ovx5No=;
        b=UoRphFcNXi0ifDS+QAaPqLa2McRsJDl3PaE5j53RuxH0mkU5UTpYMboL91103/yBQHXyI8
        lQzc/TNITQc8MFwGDoqAZqsyxeMijLT77J0m0q7b7ruiL1OBbZDdpZo41JFNIZiFi109dw
        9UFlA6pgyC7E8+kxZgpC9xkqzQRuk28T9+3mniV185i1sXT33su2StVgrlEytibJkL+mx8
        MrWmlQzbicczRWPF/hoNrmdT+CrX8wiqb5TYyKcx2H8YCZdpg35EAqxmeS9B56DxXlHVES
        TmV1kfGN2QPtbIBumNK3mqag6iLQDUlYBPbZkYJ8gikPlJbEw2qKq8gVFIBPZQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1600103788;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hKJzvN3Uf4aP8GgYNeDCYfuKOeuXhv5z36Q85ovx5No=;
        b=4zIOFmguJw1gEy//WPx2xtIczzDCoT7ymR+KfhaZRw32ECJqrnA9V5y+w+b2gBIM3vVnT9
        N4vihCt0PSHMLwDw==
From:   "tip-bot2 for Arvind Sankar" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/boot/compressed: Disable relocation relaxation
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Ingo Molnar <mingo@kernel.org>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>, stable@vger.kernel.org,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20200812004308.1448603-1-nivedita@alum.mit.edu>
References: <20200812004308.1448603-1-nivedita@alum.mit.edu>
MIME-Version: 1.0
Message-ID: <160010378780.15536.10220665698122173682.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     09e43968db40c33a73e9ddbfd937f46d5c334924
Gitweb:        https://git.kernel.org/tip/09e43968db40c33a73e9ddbfd937f46d5c334924
Author:        Arvind Sankar <nivedita@alum.mit.edu>
AuthorDate:    Tue, 11 Aug 2020 20:43:08 -04:00
Committer:     Ingo Molnar <mingo@kernel.org>
CommitterDate: Mon, 14 Sep 2020 11:14:45 +02:00

x86/boot/compressed: Disable relocation relaxation

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
---
 arch/x86/boot/compressed/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 3962f59..ff7894f 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -43,6 +43,8 @@ KBUILD_CFLAGS += -Wno-pointer-sign
 KBUILD_CFLAGS += $(call cc-option,-fmacro-prefix-map=$(srctree)/=)
 KBUILD_CFLAGS += -fno-asynchronous-unwind-tables
 KBUILD_CFLAGS += -D__DISABLE_EXPORTS
+# Disable relocation relaxation in case the link is not PIE.
+KBUILD_CFLAGS += $(call as-option,-Wa$(comma)-mrelax-relocations=no)
 
 KBUILD_AFLAGS  := $(KBUILD_CFLAGS) -D__ASSEMBLY__
 GCOV_PROFILE := n
