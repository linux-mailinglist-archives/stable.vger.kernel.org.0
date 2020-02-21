Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12F56167527
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:30:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731875AbgBUIX7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:23:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:36220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388572AbgBUIX6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:23:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1826E2467D;
        Fri, 21 Feb 2020 08:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582273437;
        bh=qRbUMUoNDNhRm65zIbW/W+MIQ+kVKOlc6pAN/6NB8T8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=14EL8769x4wvVCTSC45EEZRLG+mSdPlzvxKfD48KaBuUjBXl+z0kXAW8qY9jd+TVs
         RW6gEhstsEC3f1bt7ENKZIVYZrzXs8ccpd9AT9plAMHlnnjkhG9yVPvdRDjt0TAeNh
         9Bksl+WLx/OXu63hfx18UKksffhLYq/QHg5T2X3U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Kees Cook <keescook@chromium.org>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 134/191] arm64: fix alternatives with LLVMs integrated assembler
Date:   Fri, 21 Feb 2020 08:41:47 +0100
Message-Id: <20200221072306.861454640@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072250.732482588@linuxfoundation.org>
References: <20200221072250.732482588@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sami Tolvanen <samitolvanen@google.com>

[ Upstream commit c54f90c2627cc316d365e3073614731e17dbc631 ]

LLVM's integrated assembler fails with the following error when
building KVM:

  <inline asm>:12:6: error: expected absolute expression
   .if kvm_update_va_mask == 0
       ^
  <inline asm>:21:6: error: expected absolute expression
   .if kvm_update_va_mask == 0
       ^
  <inline asm>:24:2: error: unrecognized instruction mnemonic
          NOT_AN_INSTRUCTION
          ^
  LLVM ERROR: Error parsing inline asm

These errors come from ALTERNATIVE_CB and __ALTERNATIVE_CFG,
which test for the existence of the callback parameter in inline
assembly using the following expression:

  " .if " __stringify(cb) " == 0\n"

This works with GNU as, but isn't supported by LLVM. This change
splits __ALTERNATIVE_CFG and ALTINSTR_ENTRY into separate macros
to fix the LLVM build.

Link: https://github.com/ClangBuiltLinux/linux/issues/472
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/alternative.h | 32 ++++++++++++++++++----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/alternative.h b/arch/arm64/include/asm/alternative.h
index 4b650ec1d7dd1..887a8512bf10b 100644
--- a/arch/arm64/include/asm/alternative.h
+++ b/arch/arm64/include/asm/alternative.h
@@ -35,13 +35,16 @@ void apply_alternatives_module(void *start, size_t length);
 static inline void apply_alternatives_module(void *start, size_t length) { }
 #endif
 
-#define ALTINSTR_ENTRY(feature,cb)					      \
+#define ALTINSTR_ENTRY(feature)					              \
 	" .word 661b - .\n"				/* label           */ \
-	" .if " __stringify(cb) " == 0\n"				      \
 	" .word 663f - .\n"				/* new instruction */ \
-	" .else\n"							      \
+	" .hword " __stringify(feature) "\n"		/* feature bit     */ \
+	" .byte 662b-661b\n"				/* source len      */ \
+	" .byte 664f-663f\n"				/* replacement len */
+
+#define ALTINSTR_ENTRY_CB(feature, cb)					      \
+	" .word 661b - .\n"				/* label           */ \
 	" .word " __stringify(cb) "- .\n"		/* callback */	      \
-	" .endif\n"							      \
 	" .hword " __stringify(feature) "\n"		/* feature bit     */ \
 	" .byte 662b-661b\n"				/* source len      */ \
 	" .byte 664f-663f\n"				/* replacement len */
@@ -62,15 +65,14 @@ static inline void apply_alternatives_module(void *start, size_t length) { }
  *
  * Alternatives with callbacks do not generate replacement instructions.
  */
-#define __ALTERNATIVE_CFG(oldinstr, newinstr, feature, cfg_enabled, cb)	\
+#define __ALTERNATIVE_CFG(oldinstr, newinstr, feature, cfg_enabled)	\
 	".if "__stringify(cfg_enabled)" == 1\n"				\
 	"661:\n\t"							\
 	oldinstr "\n"							\
 	"662:\n"							\
 	".pushsection .altinstructions,\"a\"\n"				\
-	ALTINSTR_ENTRY(feature,cb)					\
+	ALTINSTR_ENTRY(feature)						\
 	".popsection\n"							\
-	" .if " __stringify(cb) " == 0\n"				\
 	".pushsection .altinstr_replacement, \"a\"\n"			\
 	"663:\n\t"							\
 	newinstr "\n"							\
@@ -78,17 +80,25 @@ static inline void apply_alternatives_module(void *start, size_t length) { }
 	".popsection\n\t"						\
 	".org	. - (664b-663b) + (662b-661b)\n\t"			\
 	".org	. - (662b-661b) + (664b-663b)\n"			\
-	".else\n\t"							\
+	".endif\n"
+
+#define __ALTERNATIVE_CFG_CB(oldinstr, feature, cfg_enabled, cb)	\
+	".if "__stringify(cfg_enabled)" == 1\n"				\
+	"661:\n\t"							\
+	oldinstr "\n"							\
+	"662:\n"							\
+	".pushsection .altinstructions,\"a\"\n"				\
+	ALTINSTR_ENTRY_CB(feature, cb)					\
+	".popsection\n"							\
 	"663:\n\t"							\
 	"664:\n\t"							\
-	".endif\n"							\
 	".endif\n"
 
 #define _ALTERNATIVE_CFG(oldinstr, newinstr, feature, cfg, ...)	\
-	__ALTERNATIVE_CFG(oldinstr, newinstr, feature, IS_ENABLED(cfg), 0)
+	__ALTERNATIVE_CFG(oldinstr, newinstr, feature, IS_ENABLED(cfg))
 
 #define ALTERNATIVE_CB(oldinstr, cb) \
-	__ALTERNATIVE_CFG(oldinstr, "NOT_AN_INSTRUCTION", ARM64_CB_PATCH, 1, cb)
+	__ALTERNATIVE_CFG_CB(oldinstr, ARM64_CB_PATCH, 1, cb)
 #else
 
 #include <asm/assembler.h>
-- 
2.20.1



