Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C77D364437
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240642AbhDSNZw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:25:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:34744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242000AbhDSNZJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:25:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4D1161370;
        Mon, 19 Apr 2021 13:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838400;
        bh=tGk4CSXuQa2/ZRK8TSBTf+Hnqgwk9HV17o8vQ4NhOh8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mRIXlKUoglkv7RKwBZ1IDWkbhbuz/ZYDRICnfav1P3E5KDJw7oqpXFvl7HOBMbyQI
         9YTIRQnR7V54AXtG//KZDynETRGLpsN/jRWx8daBCZ0rCaM6FgW+o6XTQZmksLLUjR
         EsQV1yTx1EYOr3jm6gKRaemWlI6FSQucL4I2Ew9A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 5.4 46/73] arm64: alternatives: Move length validation in alternative_{insn, endif}
Date:   Mon, 19 Apr 2021 15:06:37 +0200
Message-Id: <20210419130525.320683439@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130523.802169214@linuxfoundation.org>
References: <20210419130523.802169214@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

commit 22315a2296f4c251fa92aec45fbbae37e9301b6c upstream.

After commit 2decad92f473 ("arm64: mte: Ensure TIF_MTE_ASYNC_FAULT is
set atomically"), LLVM's integrated assembler fails to build entry.S:

<instantiation>:5:7: error: expected assembly-time absolute expression
 .org . - (664b-663b) + (662b-661b)
      ^
<instantiation>:6:7: error: expected assembly-time absolute expression
 .org . - (662b-661b) + (664b-663b)
      ^

The root cause is LLVM's assembler has a one-pass design, meaning it
cannot figure out these instruction lengths when the .org directive is
outside of the subsection that they are in, which was changed by the
.arch_extension directive added in the above commit.

Apply the same fix from commit 966a0acce2fc ("arm64/alternatives: move
length validation inside the subsection") to the alternative_endif
macro, shuffling the .org directives so that the length validation
happen will always happen in the same subsections. alternative_insn has
not shown any issue yet but it appears that it could have the same issue
in the future so just preemptively change it.

Fixes: f7b93d42945c ("arm64/alternatives: use subsections for replacement sequences")
Cc: <stable@vger.kernel.org> # 5.8.x
Link: https://github.com/ClangBuiltLinux/linux/issues/1347
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Tested-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
Link: https://lore.kernel.org/r/20210414000803.662534-1-nathan@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/alternative.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/arm64/include/asm/alternative.h
+++ b/arch/arm64/include/asm/alternative.h
@@ -119,9 +119,9 @@ static inline void apply_alternatives_mo
 	.popsection
 	.subsection 1
 663:	\insn2
-664:	.previous
-	.org	. - (664b-663b) + (662b-661b)
+664:	.org	. - (664b-663b) + (662b-661b)
 	.org	. - (662b-661b) + (664b-663b)
+	.previous
 	.endif
 .endm
 
@@ -191,11 +191,11 @@ static inline void apply_alternatives_mo
  */
 .macro alternative_endif
 664:
+	.org	. - (664b-663b) + (662b-661b)
+	.org	. - (662b-661b) + (664b-663b)
 	.if .Lasm_alt_mode==0
 	.previous
 	.endif
-	.org	. - (664b-663b) + (662b-661b)
-	.org	. - (662b-661b) + (664b-663b)
 .endm
 
 /*


