Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D81BB388040
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 21:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238448AbhERTCz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 15:02:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:49546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238394AbhERTCy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 May 2021 15:02:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2366A610E9;
        Tue, 18 May 2021 19:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621364496;
        bh=N0OYIBjgObbNxtkzADopyy7cdON09mSWl+anyWhDbPY=;
        h=From:To:Cc:Subject:Date:From;
        b=gAFZkQUMSOAp5Jd8+egXCbE2xH9HSMjlQjU4nYmhViIMjmP0GMe9puxRUWa7Id5mV
         3moE5aBfcMOSIXcEtGhsN33EqnWqtR2PEAZR+DamRe+YeYEvPUxcENh0q8suB9quBG
         OtLwRbKe+Sf61sz1oXjMfdypCgo2SWvOc4GxUPaYLNzp/uGal7uq2Zy95SgpahR6NZ
         e4L2q3tWdJbDyIUQVS8LOcMyqyHff9sIMTCdI2kstKfLn1KigvWxNB8gAtwKssiBNI
         7df59rgE1xBR7jywcHEeoI+uB1L+jrccfmIRVyZpmv8/xh3W4OzLn/ypgrdMThMcEJ
         RDUCMjezTv0iA==
From:   Nathan Chancellor <nathan@kernel.org>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Kees Cook <keescook@chromium.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Nathan Chancellor <nathan@kernel.org>, stable@vger.kernel.org,
        Anthony Ruhier <aruhier@mailbox.org>
Subject: [PATCH] x86: Fix location of '-plugin-opt=' flags
Date:   Tue, 18 May 2021 12:01:06 -0700
Message-Id: <20210518190106.60935-1-nathan@kernel.org>
X-Mailer: git-send-email 2.32.0.rc0
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit b33fff07e3e3 ("x86, build: allow LTO to be selected") added a
couple of '-plugin-opt=' flags to KBUILD_LDFLAGS because the code model
and stack alignment are not stored in LLVM bitcode. However, these flags
were added to KBUILD_LDFLAGS prior to the emulation flag assignment,
which uses ':=', so they were overwritten and never added to $(LD)
invocations. The absence of these flags caused misalignment issues in
the AMDGPU driver when compiling with CONFIG_LTO_CLANG, resulting in
general protection faults.

Shuffle the assignment below the initial one so that the flags are
properly passed along and all of the linker flags stay together.

At the same time, avoid any future issues with clobbering flags by
changing the emulation flag assignment to '+=' since KBUILD_LDFLAGS is
already defined with ':=' in the main Makefile before being exported for
modification here as a result of commit ce99d0bf312d ("kbuild: clear
LDFLAGS in the top Makefile").

Cc: stable@vger.kernel.org
Fixes: b33fff07e3e3 ("x86, build: allow LTO to be selected")
Link: https://github.com/ClangBuiltLinux/linux/issues/1374
Reported-by: Anthony Ruhier <aruhier@mailbox.org>
Tested-by: Anthony Ruhier <aruhier@mailbox.org>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/x86/Makefile | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index c77c5d8a7b3e..307529417021 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -178,11 +178,6 @@ ifeq ($(ACCUMULATE_OUTGOING_ARGS), 1)
 	KBUILD_CFLAGS += $(call cc-option,-maccumulate-outgoing-args,)
 endif
 
-ifdef CONFIG_LTO_CLANG
-KBUILD_LDFLAGS	+= -plugin-opt=-code-model=kernel \
-		   -plugin-opt=-stack-alignment=$(if $(CONFIG_X86_32),4,8)
-endif
-
 # Workaround for a gcc prelease that unfortunately was shipped in a suse release
 KBUILD_CFLAGS += -Wno-sign-compare
 #
@@ -202,7 +197,12 @@ ifdef CONFIG_RETPOLINE
   endif
 endif
 
-KBUILD_LDFLAGS := -m elf_$(UTS_MACHINE)
+KBUILD_LDFLAGS += -m elf_$(UTS_MACHINE)
+
+ifdef CONFIG_LTO_CLANG
+KBUILD_LDFLAGS	+= -plugin-opt=-code-model=kernel \
+		   -plugin-opt=-stack-alignment=$(if $(CONFIG_X86_32),4,8)
+endif
 
 ifdef CONFIG_X86_NEED_RELOCS
 LDFLAGS_vmlinux := --emit-relocs --discard-none

base-commit: d07f6ca923ea0927a1024dfccafc5b53b61cfecc
-- 
2.32.0.rc0

