Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5E622E3975
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:25:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388607AbgL1NXy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:23:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:52238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388603AbgL1NXy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:23:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 785C72076D;
        Mon, 28 Dec 2020 13:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161819;
        bh=6tLPHjkb3e2x9jKHF3E0hQL+G1kwjxBd7B2Btae8GNw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1kxBQdGxTvuoPcxVZ1QKngvv81dWka39hCB5ed932D6TnbU3f41fK8k+s0N3eIA14
         cws1iZ4LgZoYkTuOU8Yl3xu7zbv41EN+aufTynjY/3akYGFBMzZoXOd8tFfe1J79P2
         2lK4jPiLLGz2+/ca4nYJnExjeRj/yCTFO4a8Pu28=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>,
        Fangrui Song <maskray@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 4.19 052/346] arm64: Change .weak to SYM_FUNC_START_WEAK_PI for arch/arm64/lib/mem*.S
Date:   Mon, 28 Dec 2020 13:46:11 +0100
Message-Id: <20201228124922.309150956@linuxfoundation.org>
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

commit ec9d78070de986ecf581ea204fd322af4d2477ec upstream.

Commit 39d114ddc682 ("arm64: add KASAN support") added .weak directives to
arch/arm64/lib/mem*.S instead of changing the existing SYM_FUNC_START_PI
macros. This can lead to the assembly snippet `.weak memcpy ... .globl
memcpy` which will produce a STB_WEAK memcpy with GNU as but STB_GLOBAL
memcpy with LLVM's integrated assembler before LLVM 12. LLVM 12 (since
https://reviews.llvm.org/D90108) will error on such an overridden symbol
binding.

Use the appropriate SYM_FUNC_START_WEAK_PI instead.

Fixes: 39d114ddc682 ("arm64: add KASAN support")
Reported-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Fangrui Song <maskray@google.com>
Tested-by: Sami Tolvanen <samitolvanen@google.com>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201029181951.1866093-1-maskray@google.com
Signed-off-by: Will Deacon <will@kernel.org>
[nd: backport to adjust for missing:
  commit 3ac0f4526dfb ("arm64: lib: Use modern annotations for assembly functions")
  commit 35e61c77ef38 ("arm64: asm: Add new-style position independent function annotations")]
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/lib/memcpy.S  |    3 +--
 arch/arm64/lib/memmove.S |    3 +--
 arch/arm64/lib/memset.S  |    3 +--
 3 files changed, 3 insertions(+), 6 deletions(-)

--- a/arch/arm64/lib/memcpy.S
+++ b/arch/arm64/lib/memcpy.S
@@ -68,9 +68,8 @@
 	stp \ptr, \regB, [\regC], \val
 	.endm
 
-	.weak memcpy
 ENTRY(__memcpy)
-ENTRY(memcpy)
+WEAK(memcpy)
 #include "copy_template.S"
 	ret
 ENDPIPROC(memcpy)
--- a/arch/arm64/lib/memmove.S
+++ b/arch/arm64/lib/memmove.S
@@ -57,9 +57,8 @@ C_h	.req	x12
 D_l	.req	x13
 D_h	.req	x14
 
-	.weak memmove
 ENTRY(__memmove)
-ENTRY(memmove)
+WEAK(memmove)
 	cmp	dstin, src
 	b.lo	__memcpy
 	add	tmp1, src, count
--- a/arch/arm64/lib/memset.S
+++ b/arch/arm64/lib/memset.S
@@ -54,9 +54,8 @@ dst		.req	x8
 tmp3w		.req	w9
 tmp3		.req	x9
 
-	.weak memset
 ENTRY(__memset)
-ENTRY(memset)
+WEAK(memset)
 	mov	dst, dstin	/* Preserve return value.  */
 	and	A_lw, val, #255
 	orr	A_lw, A_lw, A_lw, lsl #8


