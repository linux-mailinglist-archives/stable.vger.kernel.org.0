Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2422D35E9E1
	for <lists+stable@lfdr.de>; Wed, 14 Apr 2021 02:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbhDNAJc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Apr 2021 20:09:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:54328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230070AbhDNAJc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Apr 2021 20:09:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBEFD61246;
        Wed, 14 Apr 2021 00:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618358951;
        bh=SGCsWnJBFU+PxLaU3qadL12J+jaWNLTDyWNJnKddMuc=;
        h=From:To:Cc:Subject:Date:From;
        b=JQWxh+Jv8A+tHVoORVEKiKYEGfSjDj7APbD58NkbftuWe1MQqhlRmP/IbE0iccbQ1
         lYUy7OS684VJX6qxq1LqiFiveFCZThNcNa88D/CcNphXPlAX3LovLn0xpQDDJp8V1c
         7YQDeS50IkM3fxJfZ5vF8fJvu7fs86rL9A4rantLO4FLc/E83n4zD1feiKvxO5ozFv
         6t2LIr8pPTOpefrbj/9aGIbOmbHt1SbIHgMJamS0/iPX4bfBfarrx5aZKoljGjPMQl
         +qTsO7LCvMqynuO+a3pRpMJzBtxLwsAlGvPJfzrAALPyHwad+xdct3aQtiR7Bsmyen
         IKI14eVl/DqSw==
From:   Nathan Chancellor <nathan@kernel.org>
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Jian Cai <jiancai@google.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Nathan Chancellor <nathan@kernel.org>, stable@vger.kernel.org
Subject: [PATCH] arm64: alternatives: Move length validation in alternative_{insn,endif}
Date:   Tue, 13 Apr 2021 17:08:04 -0700
Message-Id: <20210414000803.662534-1-nathan@kernel.org>
X-Mailer: git-send-email 2.31.1.272.g89b43f80a5
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Cc: stable@vger.kernel.org
Fixes: f7b93d42945c ("arm64/alternatives: use subsections for replacement sequences")
Link: https://github.com/ClangBuiltLinux/linux/issues/1347
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---

Apologies if my explanation or terminology is off, I am only now getting
more familiar with assembly.

 arch/arm64/include/asm/alternative-macros.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/alternative-macros.h b/arch/arm64/include/asm/alternative-macros.h
index 5df500dcc627..8a078fc662ac 100644
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

base-commit: 738fa58ee1328481d1d7889e7c430b3401c571b9
-- 
2.31.1.272.g89b43f80a5

