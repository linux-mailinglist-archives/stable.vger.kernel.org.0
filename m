Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 608912A63C7
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 12:59:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729801AbgKDL7X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 06:59:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729700AbgKDL56 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Nov 2020 06:57:58 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AFA8C0613D3;
        Wed,  4 Nov 2020 03:57:57 -0800 (PST)
Date:   Wed, 04 Nov 2020 11:57:54 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1604491075;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1SJ+9JeJWVBHBJ9URQUWbLGmooR2mSzQjp6hmyYspSs=;
        b=ptREcJdcOET7oQFYUQ0boG4+Oxc9tiKL+XX5g+02oIPVMESLLGEW3IzrPGWGpYe3cs3lVX
        spetEi6u92QZmCKDOSAO2ldnV5B+6sQBOdIyc7hY1gwAH8iKUfKUZ/fEJIAt8OZjEZM4T5
        OTRXwSTN5GH+zkynE8yTv5laoY1Y1l439LT6weoEsClks3RY6QFjI1KQoaHopHviT4x+6k
        gdJSHUDmPuRqjnbeQ4ZDS1tSxF2KGkuZBuK5ITc5Ctry70V873qf7UOXA28RBRULDkFLio
        +HsRZju6P9l5Wnwuy0TopuRdCjrUQ4bfuePMGxCJeZxQiNcbIq0KV+OYEZRRcw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1604491075;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1SJ+9JeJWVBHBJ9URQUWbLGmooR2mSzQjp6hmyYspSs=;
        b=YUQzXJUseVkI+4ld0s/YSYvieFhX/xEkjtKbjJCuSjmrYJMB0hF3aDM8oSRS5+g3dnZfZX
        MnxEYrlIVllUHpDw==
From:   "tip-bot2 for Fangrui Song" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/lib: Change .weak to SYM_FUNC_START_WEAK for
 arch/x86/lib/mem*_64.S
Cc:     Sami Tolvanen <samitolvanen@google.com>,
        Fangrui Song <maskray@google.com>,
        Borislav Petkov <bp@suse.de>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        <stable@vger.kernel.org>, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20201103012358.168682-1-maskray@google.com>
References: <20201103012358.168682-1-maskray@google.com>
MIME-Version: 1.0
Message-ID: <160449107432.397.983110962215228376.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     4d6ffa27b8e5116c0abb318790fd01d4e12d75e6
Gitweb:        https://git.kernel.org/tip/4d6ffa27b8e5116c0abb318790fd01d4e12d75e6
Author:        Fangrui Song <maskray@google.com>
AuthorDate:    Mon, 02 Nov 2020 17:23:58 -08:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Wed, 04 Nov 2020 12:30:20 +01:00

x86/lib: Change .weak to SYM_FUNC_START_WEAK for arch/x86/lib/mem*_64.S

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
---
 arch/x86/lib/memcpy_64.S  | 4 +---
 arch/x86/lib/memmove_64.S | 4 +---
 arch/x86/lib/memset_64.S  | 4 +---
 3 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/arch/x86/lib/memcpy_64.S b/arch/x86/lib/memcpy_64.S
index 037faac..1e299ac 100644
--- a/arch/x86/lib/memcpy_64.S
+++ b/arch/x86/lib/memcpy_64.S
@@ -16,8 +16,6 @@
  * to a jmp to memcpy_erms which does the REP; MOVSB mem copy.
  */
 
-.weak memcpy
-
 /*
  * memcpy - Copy a memory block.
  *
@@ -30,7 +28,7 @@
  * rax original destination
  */
 SYM_FUNC_START_ALIAS(__memcpy)
-SYM_FUNC_START_LOCAL(memcpy)
+SYM_FUNC_START_WEAK(memcpy)
 	ALTERNATIVE_2 "jmp memcpy_orig", "", X86_FEATURE_REP_GOOD, \
 		      "jmp memcpy_erms", X86_FEATURE_ERMS
 
diff --git a/arch/x86/lib/memmove_64.S b/arch/x86/lib/memmove_64.S
index 7ff00ea..41902fe 100644
--- a/arch/x86/lib/memmove_64.S
+++ b/arch/x86/lib/memmove_64.S
@@ -24,9 +24,7 @@
  * Output:
  * rax: dest
  */
-.weak memmove
-
-SYM_FUNC_START_ALIAS(memmove)
+SYM_FUNC_START_WEAK(memmove)
 SYM_FUNC_START(__memmove)
 
 	mov %rdi, %rax
diff --git a/arch/x86/lib/memset_64.S b/arch/x86/lib/memset_64.S
index 9ff15ee..0bfd26e 100644
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
@@ -19,7 +17,7 @@
  *
  * rax   original destination
  */
-SYM_FUNC_START_ALIAS(memset)
+SYM_FUNC_START_WEAK(memset)
 SYM_FUNC_START(__memset)
 	/*
 	 * Some CPUs support enhanced REP MOVSB/STOSB feature. It is recommended
