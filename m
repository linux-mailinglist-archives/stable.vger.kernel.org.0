Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2576499ABD
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:57:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359741AbiAXVqI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:46:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1456532AbiAXVjb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:39:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B0F8C061341;
        Mon, 24 Jan 2022 12:24:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 39E786090A;
        Mon, 24 Jan 2022 20:24:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18C96C340E5;
        Mon, 24 Jan 2022 20:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055874;
        bh=l3akZgYVfwMEfwcCOQk0BID8yWFagZs9UcWLxnR9ZfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WF4taM1pWA/dvUaOBojgGibAYV/0cUf0QITTIoOXD710kR+7E7GvPuxGzk+9Xw+zo
         nvHkL/6HFSm05b4dpC4SbhguwSPHjzvxkQA891cbbUoyvdNhv/IRZwrCLEh+Q7VVP1
         DWg4tgKFmdskuQR/aeN04MnwDdxQP1n6x0FIS5f4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Adam Lackorzynski <adam@l4re.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 261/846] ARM: 9159/1: decompressor: Avoid UNPREDICTABLE NOP encoding
Date:   Mon, 24 Jan 2022 19:36:18 +0100
Message-Id: <20220124184109.923209775@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit a92882a4d270fbcc021ee6848de5e48b7f0d27f3 ]

In the decompressor's head.S we need to start with an instruction that
is some kind of NOP, but also mimics as the PE/COFF header, when the
kernel is linked as an UEFI application. The clever solution here is
"tstne r0, #0x4d000", which in the worst case just clobbers the
condition flags, and bears the magic "MZ" signature in the lowest 16 bits.

However the encoding used (0x13105a4d) is actually not valid, since bits
[15:12] are supposed to be 0 (written as "(0)" in the ARM ARM).
Violating this is UNPREDICTABLE, and *can* trigger an UNDEFINED
exception. Common Cortex cores seem to ignore those bits, but QEMU
chooses to trap, so the code goes fishing because of a missing exception
handler at this point. We are just saved by the fact that commonly (with
-kernel or when running from U-Boot) the "Z" bit is set, so the
instruction is never executed. See [0] for more details.

To make things more robust and avoid UNPREDICTABLE behaviour in the
kernel code, lets replace this with a "two-instruction NOP":
The first instruction is an exclusive OR, the effect of which the second
instruction reverts. This does not leave any trace, neither in a
register nor in the condition flags. Also it's a perfectly valid
encoding. Kudos to Peter Maydell for coming up with this gem.

[0] https://lore.kernel.org/qemu-devel/YTPIdbUCmwagL5%2FD@os.inf.tu-dresden.de/T/

Link: https://lore.kernel.org/linux-arm-kernel/20210908162617.104962-1-andre.przywara@arm.com/T/

Fixes: 81a0bc39ea19 ("ARM: add UEFI stub support")
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reported-by: Adam Lackorzynski <adam@l4re.org>
Suggested-by: Peter Maydell <peter.maydell@linaro.org>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/compressed/efi-header.S | 22 ++++++++++++++--------
 arch/arm/boot/compressed/head.S       |  3 ++-
 2 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/arch/arm/boot/compressed/efi-header.S b/arch/arm/boot/compressed/efi-header.S
index c0e7a745103e2..230030c130853 100644
--- a/arch/arm/boot/compressed/efi-header.S
+++ b/arch/arm/boot/compressed/efi-header.S
@@ -9,16 +9,22 @@
 #include <linux/sizes.h>
 
 		.macro	__nop
-#ifdef CONFIG_EFI_STUB
-		@ This is almost but not quite a NOP, since it does clobber the
-		@ condition flags. But it is the best we can do for EFI, since
-		@ PE/COFF expects the magic string "MZ" at offset 0, while the
-		@ ARM/Linux boot protocol expects an executable instruction
-		@ there.
-		.inst	MZ_MAGIC | (0x1310 << 16)	@ tstne r0, #0x4d000
-#else
  AR_CLASS(	mov	r0, r0		)
   M_CLASS(	nop.w			)
+		.endm
+
+		.macro __initial_nops
+#ifdef CONFIG_EFI_STUB
+		@ This is a two-instruction NOP, which happens to bear the
+		@ PE/COFF signature "MZ" in the first two bytes, so the kernel
+		@ is accepted as an EFI binary. Booting via the UEFI stub
+		@ will not execute those instructions, but the ARM/Linux
+		@ boot protocol does, so we need some NOPs here.
+		.inst	MZ_MAGIC | (0xe225 << 16)	@ eor r5, r5, 0x4d000
+		eor	r5, r5, 0x4d000			@ undo previous insn
+#else
+		__nop
+		__nop
 #endif
 		.endm
 
diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
index b1cb1972361b8..bf79f2f78d232 100644
--- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -203,7 +203,8 @@ start:
 		 * were patching the initial instructions of the kernel, i.e
 		 * had started to exploit this "patch area".
 		 */
-		.rept	7
+		__initial_nops
+		.rept	5
 		__nop
 		.endr
 #ifndef CONFIG_THUMB2_KERNEL
-- 
2.34.1



