Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1C52E3932
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:22:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733163AbgL1NUW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:20:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:48934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733160AbgL1NUW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:20:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E218F207CF;
        Mon, 28 Dec 2020 13:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161581;
        bh=Ihcc4nN+OkEsPNSB38BRCmUphGdB0TEpOMi6Bhbp9OI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NIKgxpu8TEoxm5Cf2QWS46GBOgZTxBF1bbQtJ08r0B7+EyUqFdjxHOIblTM5002XA
         TE7JFvmOEfmZOfCpct/ImyV5Gj2G1LQ9Radlo6Be6fGGBK5tw5mGl6ECw50ehVPdDZ
         AS37EUBrbfUSbZ4EO5+fxeJI+ujp5W6iKggRV03w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>,
        Fangrui Song <maskray@google.com>,
        Borislav Petkov <bp@suse.de>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH 4.19 002/346] x86/lib: Change .weak to SYM_FUNC_START_WEAK for arch/x86/lib/mem*_64.S
Date:   Mon, 28 Dec 2020 13:45:21 +0100
Message-Id: <20201228124919.871342748@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fangrui Song <maskray@google.com>

commit 4d6ffa27b8e5116c0abb318790fd01d4e12d75e6 upstream.

Commit

  393f203f5fd5 ("x86_64: kasan: add interceptors for memset/memmove/memcpy functions")

added .weak directives to arch/x86/lib/mem*_64.S instead of changing the
existing ENTRY macros to WEAK. This can lead to the assembly snippet

  .weak memcpy
  ...
  .globl memcpy

which will produce a STB_WEAK memcpy with GNU as but STB_GLOBAL memcpy
with LLVM's integrated assembler before LLVM 12. LLVM 12 (since
https://reviews.llvm.org/D90108) will error on such an overridden symbol
binding.

Commit

  ef1e03152cb0 ("x86/asm: Make some functions local")

changed ENTRY in arch/x86/lib/memcpy_64.S to SYM_FUNC_START_LOCAL, which
was ineffective due to the preceding .weak directive.

Use the appropriate SYM_FUNC_START_WEAK instead.

Fixes: 393f203f5fd5 ("x86_64: kasan: add interceptors for memset/memmove/memcpy functions")
Fixes: ef1e03152cb0 ("x86/asm: Make some functions local")
Reported-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Fangrui Song <maskray@google.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Nathan Chancellor <natechancellor@gmail.com>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20201103012358.168682-1-maskray@google.com
[nd: backport due to missing
  commit e9b9d020c487 ("x86/asm: Annotate aliases")
  commit ffedeeb780dc ("linkage: Introduce new macros for assembler symbols")]
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/lib/memcpy_64.S  |    6 +++---
 arch/x86/lib/memmove_64.S |    4 ++--
 arch/x86/lib/memset_64.S  |    6 +++---
 3 files changed, 8 insertions(+), 8 deletions(-)

--- a/arch/x86/lib/memcpy_64.S
+++ b/arch/x86/lib/memcpy_64.S
@@ -14,8 +14,6 @@
  * to a jmp to memcpy_erms which does the REP; MOVSB mem copy.
  */
 
-.weak memcpy
-
 /*
  * memcpy - Copy a memory block.
  *
@@ -28,7 +26,9 @@
  * rax original destination
  */
 ENTRY(__memcpy)
-ENTRY(memcpy)
+.weak memcpy
+.p2align 4, 0x90
+memcpy:
 	ALTERNATIVE_2 "jmp memcpy_orig", "", X86_FEATURE_REP_GOOD, \
 		      "jmp memcpy_erms", X86_FEATURE_ERMS
 
--- a/arch/x86/lib/memmove_64.S
+++ b/arch/x86/lib/memmove_64.S
@@ -25,8 +25,8 @@
  * rax: dest
  */
 .weak memmove
-
-ENTRY(memmove)
+.p2align 4, 0x90
+memmove:
 ENTRY(__memmove)
 
 	/* Handle more 32 bytes in loop */
--- a/arch/x86/lib/memset_64.S
+++ b/arch/x86/lib/memset_64.S
@@ -6,8 +6,6 @@
 #include <asm/alternative-asm.h>
 #include <asm/export.h>
 
-.weak memset
-
 /*
  * ISO C memset - set a memory block to a byte value. This function uses fast
  * string to get better performance than the original function. The code is
@@ -19,7 +17,9 @@
  *
  * rax   original destination
  */
-ENTRY(memset)
+.weak memset
+.p2align 4, 0x90
+memset:
 ENTRY(__memset)
 	/*
 	 * Some CPUs support enhanced REP MOVSB/STOSB feature. It is recommended


