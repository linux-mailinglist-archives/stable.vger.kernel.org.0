Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88A573642F4
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238807AbhDSNMt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:12:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:47510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239740AbhDSNLe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:11:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBA53613AE;
        Mon, 19 Apr 2021 13:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618837863;
        bh=e/YWmjbMjgAaQhEyfU+nUYH5L4j/9kJBl0oTCgCdDr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2P/23kS9JZDhEX8nTnQgX32ASzK+JDV13Y7ePxd6ko2DukXgkXvYm4y/3/yP5c4Sl
         u2xKsaZjqM7Z6NJr+8agsgll/UlY5NMcTbVjZW36JRNl3xg3H7oHLVgxxRvx3/hu++
         S/H48xiW+r3yRPwPT3f8nc9J9NyW31SdNmdxoZJA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 5.11 064/122] arm64: alternatives: Move length validation in alternative_{insn, endif}
Date:   Mon, 19 Apr 2021 15:05:44 +0200
Message-Id: <20210419130532.356543037@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130530.166331793@linuxfoundation.org>
References: <20210419130530.166331793@linuxfoundation.org>
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
 arch/arm64/include/asm/alternative-macros.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/arm64/include/asm/alternative-macros.h
+++ b/arch/arm64/include/asm/alternative-macros.h
@@ -97,9 +97,9 @@
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
 
@@ -169,11 +169,11 @@
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


