Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA59732E808
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:25:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbhCEMYm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:24:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:58764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230143AbhCEMYN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:24:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE7F565035;
        Fri,  5 Mar 2021 12:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947053;
        bh=H80drgz2QjWFLzCaXPaW80pTjIGTtPm5BOLLnJQx5gs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FOuNDYeN8bAtTaGTwqMs5NLWSA/GkP24LQJsUJmiv9QviLPapgpTnEyqwS3NssQe2
         lgOeqCzJp07nEiIt6/Ay0R7UgGp9q4cRxuS/X24ni0035W9KACrNbIf1K8QO3TEf+w
         F2d5Ku8TvKmhUG7mnQgYCgcWHWADV2duSEVADnZA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Fangrui Song <maskray@google.com>,
        Borislav Petkov <bp@suse.de>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH 5.11 003/104] x86/build: Treat R_386_PLT32 relocation as R_386_PC32
Date:   Fri,  5 Mar 2021 13:20:08 +0100
Message-Id: <20210305120903.344620109@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.166929741@linuxfoundation.org>
References: <20210305120903.166929741@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fangrui Song <maskray@google.com>

commit bb73d07148c405c293e576b40af37737faf23a6a upstream.

This is similar to commit

  b21ebf2fb4cd ("x86: Treat R_X86_64_PLT32 as R_X86_64_PC32")

but for i386. As far as the kernel is concerned, R_386_PLT32 can be
treated the same as R_386_PC32.

R_386_PLT32/R_X86_64_PLT32 are PC-relative relocation types which
can only be used by branches. If the referenced symbol is defined
externally, a PLT will be used.

R_386_PC32/R_X86_64_PC32 are PC-relative relocation types which can be
used by address taking operations and branches. If the referenced symbol
is defined externally, a copy relocation/canonical PLT entry will be
created in the executable.

On x86-64, there is no PIC vs non-PIC PLT distinction and an
R_X86_64_PLT32 relocation is produced for both `call/jmp foo` and
`call/jmp foo@PLT` with newer (2018) GNU as/LLVM integrated assembler.
This avoids canonical PLT entries (st_shndx=0, st_value!=0).

On i386, there are 2 types of PLTs, PIC and non-PIC. Currently,
the GCC/GNU as convention is to use R_386_PC32 for non-PIC PLT and
R_386_PLT32 for PIC PLT. Copy relocations/canonical PLT entries
are possible ABI issues but GCC/GNU as will likely keep the status
quo because (1) the ABI is legacy (2) the change will drop a GNU
ld diagnostic for non-default visibility ifunc in shared objects.

clang-12 -fno-pic (since [1]) can emit R_386_PLT32 for compiler
generated function declarations, because preventing canonical PLT
entries is weighed over the rare ifunc diagnostic.

Further info for the more interested:

  https://github.com/ClangBuiltLinux/linux/issues/1210
  https://sourceware.org/bugzilla/show_bug.cgi?id=27169
  https://github.com/llvm/llvm-project/commit/a084c0388e2a59b9556f2de0083333232da3f1d6 [1]

 [ bp: Massage commit message. ]

Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Fangrui Song <maskray@google.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Nathan Chancellor <natechancellor@gmail.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Link: https://lkml.kernel.org/r/20210127205600.1227437-1-maskray@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/module.c |    1 +
 arch/x86/tools/relocs.c  |   12 ++++++++----
 2 files changed, 9 insertions(+), 4 deletions(-)

--- a/arch/x86/kernel/module.c
+++ b/arch/x86/kernel/module.c
@@ -114,6 +114,7 @@ int apply_relocate(Elf32_Shdr *sechdrs,
 			*location += sym->st_value;
 			break;
 		case R_386_PC32:
+		case R_386_PLT32:
 			/* Add the value, subtract its position */
 			*location += sym->st_value - (uint32_t)location;
 			break;
--- a/arch/x86/tools/relocs.c
+++ b/arch/x86/tools/relocs.c
@@ -867,9 +867,11 @@ static int do_reloc32(struct section *se
 	case R_386_PC32:
 	case R_386_PC16:
 	case R_386_PC8:
+	case R_386_PLT32:
 		/*
-		 * NONE can be ignored and PC relative relocations don't
-		 * need to be adjusted.
+		 * NONE can be ignored and PC relative relocations don't need
+		 * to be adjusted. Because sym must be defined, R_386_PLT32 can
+		 * be treated the same way as R_386_PC32.
 		 */
 		break;
 
@@ -910,9 +912,11 @@ static int do_reloc_real(struct section
 	case R_386_PC32:
 	case R_386_PC16:
 	case R_386_PC8:
+	case R_386_PLT32:
 		/*
-		 * NONE can be ignored and PC relative relocations don't
-		 * need to be adjusted.
+		 * NONE can be ignored and PC relative relocations don't need
+		 * to be adjusted. Because sym must be defined, R_386_PLT32 can
+		 * be treated the same way as R_386_PC32.
 		 */
 		break;
 


