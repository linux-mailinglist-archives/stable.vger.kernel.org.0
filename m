Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C66BE6944
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:35:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729395AbfJ0VIr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:08:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:55076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729391AbfJ0VIq (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:08:46 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B39252064A;
        Sun, 27 Oct 2019 21:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210525;
        bh=L6AtQUXHVMZgVJXZeNDPYuPpnqtOyjV6wz29rG6+lDU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N0A3QkJ+jhk1zIn5fKljbDyfL/bgDkyHGgrtoolo+TLrMlrcxA7dFXd5kF+yRaowb
         UqGCuA+9iYYfDv2/tcz0z+7odb+pkgcnZJsFcQQbH1fAd/I+XwXg35mPTMVMofjIYs
         e9FjwGwYQRbPnE/nEZSTXA5g6GkNNz/n5bH3yfcc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dave Martin <dave.martin@arm.com>,
        James Morse <james.morse@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 4.14 043/119] arm64: move SCTLR_EL{1,2} assertions to <asm/sysreg.h>
Date:   Sun, 27 Oct 2019 22:00:20 +0100
Message-Id: <20191027203316.888729272@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203259.948006506@linuxfoundation.org>
References: <20191027203259.948006506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit 1c312e84c2d71da4101754fa6118f703f7473e01 ]

Currently we assert that the SCTLR_EL{1,2}_{SET,CLEAR} bits are
self-consistent with an assertion in config_sctlr_el1(). This is a bit
unusual, since config_sctlr_el1() doesn't make use of these definitions,
and is far away from the definitions themselves.

We can use the CPP #error directive to have equivalent assertions in
<asm/sysreg.h>, next to the definitions of the set/clear bits, which is
a bit clearer and simpler.

At the same time, lets fill in the upper 32 bits for both registers in
their respective RES0 definitions. This could be a little nicer with
GENMASK_ULL(63, 32), but this currently lives in <linux/bitops.h>, which
cannot safely be included from assembly, as <asm/sysreg.h> can.

Note the when the preprocessor evaluates an expression for an #if
directive, all signed or unsigned values are treated as intmax_t or
uintmax_t respectively. To avoid ambiguity, we define explicitly define
the mask of all 64 bits.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Martin <dave.martin@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/sysreg.h |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -315,7 +315,8 @@
 #define SCTLR_EL2_RES0	((1 << 6)  | (1 << 7)  | (1 << 8)  | (1 << 9)  | \
 			 (1 << 10) | (1 << 13) | (1 << 14) | (1 << 15) | \
 			 (1 << 17) | (1 << 20) | (1 << 21) | (1 << 24) | \
-			 (1 << 26) | (1 << 27) | (1 << 30) | (1 << 31))
+			 (1 << 26) | (1 << 27) | (1 << 30) | (1 << 31) | \
+			 (0xffffffffUL << 32))
 
 #ifdef CONFIG_CPU_BIG_ENDIAN
 #define ENDIAN_SET_EL2		SCTLR_ELx_EE
@@ -331,9 +332,9 @@
 			 SCTLR_ELx_SA     | SCTLR_ELx_I    | SCTLR_ELx_WXN | \
 			 ENDIAN_CLEAR_EL2 | SCTLR_EL2_RES0)
 
-/* Check all the bits are accounted for */
-#define SCTLR_EL2_BUILD_BUG_ON_MISSING_BITS	BUILD_BUG_ON((SCTLR_EL2_SET ^ SCTLR_EL2_CLEAR) != ~0)
-
+#if (SCTLR_EL2_SET ^ SCTLR_EL2_CLEAR) != 0xffffffffffffffff
+#error "Inconsistent SCTLR_EL2 set/clear bits"
+#endif
 
 /* SCTLR_EL1 specific flags. */
 #define SCTLR_EL1_UCI		(1 << 26)
@@ -352,7 +353,8 @@
 #define SCTLR_EL1_RES1	((1 << 11) | (1 << 20) | (1 << 22) | (1 << 28) | \
 			 (1 << 29))
 #define SCTLR_EL1_RES0  ((1 << 6)  | (1 << 10) | (1 << 13) | (1 << 17) | \
-			 (1 << 21) | (1 << 27) | (1 << 30) | (1 << 31))
+			 (1 << 21) | (1 << 27) | (1 << 30) | (1 << 31) | \
+			 (0xffffffffUL << 32))
 
 #ifdef CONFIG_CPU_BIG_ENDIAN
 #define ENDIAN_SET_EL1		(SCTLR_EL1_E0E | SCTLR_ELx_EE)
@@ -371,8 +373,9 @@
 			 SCTLR_EL1_UMA | SCTLR_ELx_WXN     | ENDIAN_CLEAR_EL1 |\
 			 SCTLR_EL1_RES0)
 
-/* Check all the bits are accounted for */
-#define SCTLR_EL1_BUILD_BUG_ON_MISSING_BITS	BUILD_BUG_ON((SCTLR_EL1_SET ^ SCTLR_EL1_CLEAR) != ~0)
+#if (SCTLR_EL1_SET ^ SCTLR_EL1_CLEAR) != 0xffffffffffffffff
+#error "Inconsistent SCTLR_EL1 set/clear bits"
+#endif
 
 /* id_aa64isar0 */
 #define ID_AA64ISAR0_TS_SHIFT		52
@@ -585,9 +588,6 @@ static inline void config_sctlr_el1(u32
 {
 	u32 val;
 
-	SCTLR_EL2_BUILD_BUG_ON_MISSING_BITS;
-	SCTLR_EL1_BUILD_BUG_ON_MISSING_BITS;
-
 	val = read_sysreg(sctlr_el1);
 	val &= ~clear;
 	val |= set;


