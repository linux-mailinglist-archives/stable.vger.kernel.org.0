Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAA64241F56
	for <lists+stable@lfdr.de>; Tue, 11 Aug 2020 19:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729206AbgHKRg6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Aug 2020 13:36:58 -0400
Received: from mail-qv1-f66.google.com ([209.85.219.66]:34621 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729046AbgHKRg6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Aug 2020 13:36:58 -0400
Received: by mail-qv1-f66.google.com with SMTP id t6so6366609qvw.1;
        Tue, 11 Aug 2020 10:36:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2HnMUolNEq5cXPKXr7ZP+lVltLaJ656X7idvYxtYJ7A=;
        b=Pl5B0myGCA0wsbETlDHMgxKZY1rdOqLnNI6Z+rZ6JwYT+IzTA5EUbTDw7nRIPE6Idd
         6g+HSRPpqkp9xP36/s9m6IIGbLAA4tugxfXe1k+OFXGok5kKrDe4ub7n9uOEX8u6aYel
         Hwu87YfpzMWJ85KAFhJF+vhixmNdf2+W2LtSqHXI3jZVyVBnk7HN+PbjqTc9mR19ACMt
         FxUYD/n9ExGJfrSh3/WFxEzXDungU3Nt//mBmHiJZpgbcNIjV1CMZzeyTLKqpEynm9l5
         sILdED892AK+DvMz3RQgiWU6mkYrjXv7mbw6Wmt3RyNU02Z7I3BpM3BD31b9/2lqGqzA
         +F5A==
X-Gm-Message-State: AOAM5338qWjUIMIPw9EdbqKcjWNrFv4LaRgjVi++bxEknsX9XwdE/EGq
        EKXOjjNyxmab9ri3YfYtVKI=
X-Google-Smtp-Source: ABdhPJwhGbiF/GVbqEyHJWJ4sQPbBhzYCPykjHnulAAj6EUyOwQ1D7fpG8kqEetz98Mxmg5RR6edzQ==
X-Received: by 2002:ad4:450e:: with SMTP id k14mr2315086qvu.211.1597167416620;
        Tue, 11 Aug 2020 10:36:56 -0700 (PDT)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id q68sm17305993qke.123.2020.08.11.10.36.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2020 10:36:56 -0700 (PDT)
From:   Arvind Sankar <nivedita@alum.mit.edu>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Fangrui Song <maskray@google.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        e5ten.arch@gmail.com,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Subject: [PATCH] x86/boot/compressed: Disable relocation relaxation for non-pie link
Date:   Tue, 11 Aug 2020 13:36:55 -0400
Message-Id: <20200811173655.1162093-1-nivedita@alum.mit.edu>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <CAKwvOd=ypa8xE-kaDa7XtzPsBH8=Xu_pZj2rnWaeawNs=3dDkw@mail.gmail.com>
References: <CAKwvOd=ypa8xE-kaDa7XtzPsBH8=Xu_pZj2rnWaeawNs=3dDkw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
- gcc happens to only generate GOTPCREL relocations on mov instructions.
- clang does generate GOTPCREL relocations on non-mov instructions, but
  when building the compressed kernel, it uses its integrated assembler
  (due to the redefinition of KBUILD_CFLAGS dropping -no-integrated-as),
  which has so far defaulted to not generating the GOTPCRELX
  relocations.

Nick Desaulniers reports [1,2]:
  A recent change [3] to a default value of configuration variable
  (ENABLE_X86_RELAX_RELOCATIONS OFF -> ON) in LLVM now causes Clang's
  integrated assembler to emit R_X86_64_GOTPCRELX/R_X86_64_REX_GOTPCRELX
  relocations. LLD will relax instructions with these relocations based
  on whether the image is being linked as position independent or not.
  When not, then LLD will relax these instructions to use absolute
  addressing mode (R_RELAX_GOT_PC_NOPIC). This causes kernels built with
  Clang and linked with LLD to fail to boot.

Patch series [4] is a solution to allow the compressed kernel to be
linked with -pie unconditionally, but even if merged is unlikely to be
backported. As a simple solution that can be applied to stable as well,
prevent the assembler from generating the relaxed relocation types using
the -mrelax-relocations=no option.

[0] https://gitlab.com/x86-psABIs/x86-64-ABI/-/blob/master/x86-64-ABI/linker-optimization.tex#L65
[1] https://lore.kernel.org/lkml/20200807194100.3570838-1-ndesaulniers@google.com/
[2] https://github.com/ClangBuiltLinux/linux/issues/1121
[3] https://reviews.llvm.org/rGc41a18cf61790fc898dcda1055c3efbf442c14c0
[4] https://lore.kernel.org/lkml/20200731202738.2577854-1-nivedita@alum.mit.edu/

Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
Reported-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
Cc: stable@vger.kernel.org # 4.19.x
---
 arch/x86/boot/compressed/Makefile | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 3962f592633d..c5449bea58ec 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -62,6 +62,12 @@ KBUILD_LDFLAGS += $(shell $(LD) --help 2>&1 | grep -q "\-z noreloc-overflow" \
 endif
 LDFLAGS_vmlinux := -T
 
+# Disable relocation relaxation if not linking as PIE
+ifeq ($(filter -pie,$(KBUILD_LDFLAGS)),)
+KBUILD_CFLAGS += $(call as-option, -Wa$(comma)-mrelax-relocations=no)
+KBUILD_AFLAGS += $(call as-option, -Wa$(comma)-mrelax-relocations=no)
+endif
+
 hostprogs	:= mkpiggy
 HOST_EXTRACFLAGS += -I$(srctree)/tools/include
 
-- 
2.26.2

