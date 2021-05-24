Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C68B38F01C
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235273AbhEXQBK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 12:01:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:46884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235263AbhEXQAQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 12:00:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8953A61985;
        Mon, 24 May 2021 15:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621871164;
        bh=aQU06NP4TbAS94hxCLLE0B5GUPZTGRoMn+HDYln3HX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PLpGbIFyrq4dVLbBPN57qL2vnTTPWCl4BnxiXAhLaQ7cnlUkKPfNDTEsYmqkpGu08
         zzRHKwy+09po29kqBpJhnoq17AsUVBA6B1tXunIgIKIhbQvwQF2PRCNUdwIsGJrwx/
         KcyKDz6OA1QZtchzP9LY7rAMbGTY4m+G3e25u+ZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anthony Ruhier <aruhier@mailbox.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 5.12 068/127] x86/build: Fix location of -plugin-opt= flags
Date:   Mon, 24 May 2021 17:26:25 +0200
Message-Id: <20210524152337.153392028@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152334.857620285@linuxfoundation.org>
References: <20210524152334.857620285@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

commit 0024430e920f2900654ad83cd081cf52e02a3ef5 upstream.

Commit b33fff07e3e3 ("x86, build: allow LTO to be selected") added a
couple of '-plugin-opt=' flags to KBUILD_LDFLAGS because the code model
and stack alignment are not stored in LLVM bitcode.

However, these flags were added to KBUILD_LDFLAGS prior to the
emulation flag assignment, which uses ':=', so they were overwritten
and never added to $(LD) invocations.

The absence of these flags caused misalignment issues in the
AMDGPU driver when compiling with CONFIG_LTO_CLANG, resulting in
general protection faults.

Shuffle the assignment below the initial one so that the flags are
properly passed along and all of the linker flags stay together.

At the same time, avoid any future issues with clobbering flags by
changing the emulation flag assignment to '+=' since KBUILD_LDFLAGS is
already defined with ':=' in the main Makefile before being exported for
modification here as a result of commit:

  ce99d0bf312d ("kbuild: clear LDFLAGS in the top Makefile")

Fixes: b33fff07e3e3 ("x86, build: allow LTO to be selected")
Reported-by: Anthony Ruhier <aruhier@mailbox.org>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Anthony Ruhier <aruhier@mailbox.org>
Cc: stable@vger.kernel.org
Link: https://github.com/ClangBuiltLinux/linux/issues/1374
Link: https://lore.kernel.org/r/20210518190106.60935-1-nathan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/Makefile |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -170,11 +170,6 @@ ifeq ($(ACCUMULATE_OUTGOING_ARGS), 1)
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
@@ -194,7 +189,12 @@ ifdef CONFIG_RETPOLINE
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


