Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D69633B9B0
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:08:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234945AbhCOOGb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:06:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:37632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233443AbhCOOBl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:01:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6668B64EF8;
        Mon, 15 Mar 2021 14:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816887;
        bh=+V2buA3fXOgeRsujsVxANguWYfDMeZDcLQpatHGt2DU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2QJhuH3RbgPjV7lgbU7COa0Gk3/qoa/GuT4KuNHKBM5XoBsT7Pf0F8yQ5QUra9TiS
         ua23QJ9d/CIv+UKjXez4muIxn+54LWIC8rpLLdHBaSu8a5+K1EgzPZjtjSVz4efTMI
         BgEQQ1RwGd1HBMVeDnfyHCKqOBDIUGfrJskIeI2Q=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolas Pitre <nico@fluxnic.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 169/290] ARM: assembler: introduce adr_l, ldr_l and str_l macros
Date:   Mon, 15 Mar 2021 14:54:22 +0100
Message-Id: <20210315135547.606646930@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Ard Biesheuvel <ardb@kernel.org>

commit 0b1674638a5c69cbace63278625c199100955490 upstream.

Like arm64, ARM supports position independent code sequences that
produce symbol references with a greater reach than the ordinary
adr/ldr instructions. Since on ARM, the adrl pseudo-instruction is
only supported in ARM mode (and not at all when using Clang), having
a adr_l macro like we do on arm64 is useful, and increases symmetry
as well.

Currently, we use open coded instruction sequences involving literals
and arithmetic operations. Instead, we can use movw/movt pairs on v7
CPUs, circumventing the D-cache entirely.

E.g., on v7+ CPUs, we can emit a PC-relative reference as follows:

       movw         <reg>, #:lower16:<sym> - (1f + 8)
       movt         <reg>, #:upper16:<sym> - (1f + 8)
  1:   add          <reg>, <reg>, pc

For older CPUs, we can emit the literal into a subsection, allowing it
to be emitted out of line while retaining the ability to perform
arithmetic on label offsets.

E.g., on pre-v7 CPUs, we can emit a PC-relative reference as follows:

       ldr          <reg>, 2f
  1:   add          <reg>, <reg>, pc
       .subsection  1
  2:   .long        <sym> - (1b + 8)
       .previous

This is allowed by the assembler because, unlike ordinary sections,
subsections are combined into a single section in the object file, and
so the label references are not true cross-section references that are
visible as relocations. (Subsections have been available in binutils
since 2004 at least, so they should not cause any issues with older
toolchains.)

So use the above to implement the macros mov_l, adr_l, ldr_l and str_l,
all of which will use movw/movt pairs on v7 and later CPUs, and use
PC-relative literals otherwise.

Reviewed-by: Nicolas Pitre <nico@fluxnic.net>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/include/asm/assembler.h | 84 ++++++++++++++++++++++++++++++++
 1 file changed, 84 insertions(+)

diff --git a/arch/arm/include/asm/assembler.h b/arch/arm/include/asm/assembler.h
index feac2c8b86f2..72627c5fb3b2 100644
--- a/arch/arm/include/asm/assembler.h
+++ b/arch/arm/include/asm/assembler.h
@@ -494,4 +494,88 @@ THUMB(	orr	\reg , \reg , #PSR_T_BIT	)
 #define _ASM_NOKPROBE(entry)
 #endif
 
+	.macro		__adldst_l, op, reg, sym, tmp, c
+	.if		__LINUX_ARM_ARCH__ < 7
+	ldr\c		\tmp, .La\@
+	.subsection	1
+	.align		2
+.La\@:	.long		\sym - .Lpc\@
+	.previous
+	.else
+	.ifnb		\c
+ THUMB(	ittt		\c			)
+	.endif
+	movw\c		\tmp, #:lower16:\sym - .Lpc\@
+	movt\c		\tmp, #:upper16:\sym - .Lpc\@
+	.endif
+
+#ifndef CONFIG_THUMB2_KERNEL
+	.set		.Lpc\@, . + 8			// PC bias
+	.ifc		\op, add
+	add\c		\reg, \tmp, pc
+	.else
+	\op\c		\reg, [pc, \tmp]
+	.endif
+#else
+.Lb\@:	add\c		\tmp, \tmp, pc
+	/*
+	 * In Thumb-2 builds, the PC bias depends on whether we are currently
+	 * emitting into a .arm or a .thumb section. The size of the add opcode
+	 * above will be 2 bytes when emitting in Thumb mode and 4 bytes when
+	 * emitting in ARM mode, so let's use this to account for the bias.
+	 */
+	.set		.Lpc\@, . + (. - .Lb\@)
+
+	.ifnc		\op, add
+	\op\c		\reg, [\tmp]
+	.endif
+#endif
+	.endm
+
+	/*
+	 * mov_l - move a constant value or [relocated] address into a register
+	 */
+	.macro		mov_l, dst:req, imm:req
+	.if		__LINUX_ARM_ARCH__ < 7
+	ldr		\dst, =\imm
+	.else
+	movw		\dst, #:lower16:\imm
+	movt		\dst, #:upper16:\imm
+	.endif
+	.endm
+
+	/*
+	 * adr_l - adr pseudo-op with unlimited range
+	 *
+	 * @dst: destination register
+	 * @sym: name of the symbol
+	 * @cond: conditional opcode suffix
+	 */
+	.macro		adr_l, dst:req, sym:req, cond
+	__adldst_l	add, \dst, \sym, \dst, \cond
+	.endm
+
+	/*
+	 * ldr_l - ldr <literal> pseudo-op with unlimited range
+	 *
+	 * @dst: destination register
+	 * @sym: name of the symbol
+	 * @cond: conditional opcode suffix
+	 */
+	.macro		ldr_l, dst:req, sym:req, cond
+	__adldst_l	ldr, \dst, \sym, \dst, \cond
+	.endm
+
+	/*
+	 * str_l - str <literal> pseudo-op with unlimited range
+	 *
+	 * @src: source register
+	 * @sym: name of the symbol
+	 * @tmp: mandatory scratch register
+	 * @cond: conditional opcode suffix
+	 */
+	.macro		str_l, src:req, sym:req, tmp:req, cond
+	__adldst_l	str, \src, \sym, \tmp, \cond
+	.endm
+
 #endif /* __ASM_ASSEMBLER_H__ */
-- 
2.30.1



