Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC8A315EFEE
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388711AbgBNRvc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:51:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:43208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388252AbgBNP6v (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:58:51 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F29D22467B;
        Fri, 14 Feb 2020 15:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695930;
        bh=avJYHk9+rm68xYfto9kc+SfaVmoDR3ZjTQltM8N55/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LRI21qPxO1fcE/v6AtEcoIEPST1FjSUmxEU5SlUrgjNtAH5gjDhA+y5b+6vlIJ8Fd
         BPeu6Bx0lAFxeLamohIxO5RUwqyIwZGL0booS+gcIXwj4eLIbBUW3nZSqpUmvPQa09
         V1q495HPugRvBt+LqoRkVY33lhF62mofRfjpKXYw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.5 466/542] ARM: 8941/1: decompressor: enable CP15 barrier instructions in v7 cache setup code
Date:   Fri, 14 Feb 2020 10:47:38 -0500
Message-Id: <20200214154854.6746-466-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

[ Upstream commit 8239fc7755fd3d410920006615abd0c7d653560f ]

Commit e17b1af96b2afc38e684aa2f1033387e2ed10029

  "ARM: 8857/1: efi: enable CP15 DMB instructions before cleaning the cache"

added some explicit handling of the CP15BEN bit in the SCTLR system
register, to ensure that CP15 barrier instructions are enabled, even
if we enter the decompressor via the EFI stub.

However, as it turns out, there are other ways in which we may end up
using CP15 barrier instructions without them being enabled. I.e., when
the decompressor startup code skips the cache_on() initially, we end
up calling cache_clean_flush() with the caches and MMU off, in which
case the CP15BEN bit in SCTLR may not be programmed either. And in
fact, cache_on() itself issues CP15 barrier instructions before actually
enabling them by programming the new SCTLR value (and issuing an ISB)

Since these routines are shared between v7 CPUs and older ones that
implement the CPUID extension as well, using the ordinary v7 barrier
instructions in this code is not possible, and so we should enable the
CP15 ones explicitly before issuing them. Note that a v7 ISB is still
required between programming the SCTLR register and using the CP15 barrier
instructions, and we should take care to branch over it if the CP15BEN
bit is already set, given that in that case, the CPU may not support it.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/compressed/head.S | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
index ead21e5f2b803..469a2b3b60c09 100644
--- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -140,6 +140,17 @@
 #endif
 		.endm
 
+		.macro	enable_cp15_barriers, reg
+		mrc	p15, 0, \reg, c1, c0, 0	@ read SCTLR
+		tst	\reg, #(1 << 5)		@ CP15BEN bit set?
+		bne	.L_\@
+		orr	\reg, \reg, #(1 << 5)	@ CP15 barrier instructions
+		mcr	p15, 0, \reg, c1, c0, 0	@ write SCTLR
+ ARM(		.inst   0xf57ff06f		@ v7+ isb	)
+ THUMB(		isb						)
+.L_\@:
+		.endm
+
 		.section ".start", "ax"
 /*
  * sort out different calling conventions
@@ -820,6 +831,7 @@ __armv4_mmu_cache_on:
 		mov	pc, r12
 
 __armv7_mmu_cache_on:
+		enable_cp15_barriers	r11
 		mov	r12, lr
 #ifdef CONFIG_MMU
 		mrc	p15, 0, r11, c0, c1, 4	@ read ID_MMFR0
@@ -1209,6 +1221,7 @@ __armv6_mmu_cache_flush:
 		mov	pc, lr
 
 __armv7_mmu_cache_flush:
+		enable_cp15_barriers	r10
 		tst	r4, #1
 		bne	iflush
 		mrc	p15, 0, r10, c0, c1, 5	@ read ID_MMFR1
-- 
2.20.1

