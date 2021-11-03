Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F577444058
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 12:05:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbhKCLI1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 07:08:27 -0400
Received: from foss.arm.com ([217.140.110.172]:56562 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229506AbhKCLI1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Nov 2021 07:08:27 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E56B5D6E;
        Wed,  3 Nov 2021 04:05:50 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id AE9FA3F7B4;
        Wed,  3 Nov 2021 04:05:49 -0700 (PDT)
From:   Mark Rutland <mark.rutland@arm.com>
To:     linux-arm-kernel@lists.infradead.org
Cc:     alexandru.elisei@arm.com, catalin.marinas@arm.com,
        james.morse@arm.com, mark.rutland@arm.com, maz@kernel.org,
        stable@vger.kernel.org, suzuki.poulose@arm.com, will@kernel.org
Subject: [PATCH] arm64/kvm: extract ESR_ELx.EC only
Date:   Wed,  3 Nov 2021 11:05:45 +0000
Message-Id: <20211103110545.4613-1-mark.rutland@arm.com>
X-Mailer: git-send-email 2.11.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since ARMv8.0 the upper 32 bits of ESR_ELx have been RES0, and recently
some of the upper bits gained a meaning and can be non-zero. For
example, when FEAT_LS64 is implemented, ESR_ELx[36:32] contain ISS2,
which for an ST64BV or ST64BV0 can be non-zero. This can be seen in ARM
DDI 0487G.b, page D13-3145, section D13.2.37.

Generally, we must not rely on RES0 bit remaining zero in future, and
when extracting ESR_ELx.EC we must mask out all other bits.

All C code uses the ESR_ELx_EC() macro, which masks out the irrelevant
bits, and therefore no alterations are required to C code to avoid
consuming irrelevant bits.

In a couple of places the KVM assembly extracts ESR_ELx.EC using LSR on
an X register, and so could in theory consume previously RES0 bits. In
both cases this is for comparison with EC values ESR_ELx_EC_HVC32 and
ESR_ELx_EC_HVC64, for which the upper bits of ESR_ELx must currently be
zero, but this could change in future.

This patch adjusts the KVM vectors to use UBFX rather than LSR to
extract ESR_ELx.EC, ensuring these are robust to future additions to
ESR_ELx.

Cc: stable@vger.kernel.org
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/esr.h   | 1 +
 arch/arm64/kvm/hyp/hyp-entry.S | 2 +-
 arch/arm64/kvm/hyp/nvhe/host.S | 2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index a305ce256090..d52a0b269ee8 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -68,6 +68,7 @@
 #define ESR_ELx_EC_MAX		(0x3F)
 
 #define ESR_ELx_EC_SHIFT	(26)
+#define ESR_ELx_EC_WIDTH	(6)
 #define ESR_ELx_EC_MASK		(UL(0x3F) << ESR_ELx_EC_SHIFT)
 #define ESR_ELx_EC(esr)		(((esr) & ESR_ELx_EC_MASK) >> ESR_ELx_EC_SHIFT)
 
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index 9aa9b73475c9..b6b6801d96d5 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -44,7 +44,7 @@
 el1_sync:				// Guest trapped into EL2
 
 	mrs	x0, esr_el2
-	lsr	x0, x0, #ESR_ELx_EC_SHIFT
+	ubfx	x0, x0, #ESR_ELx_EC_SHIFT, #ESR_ELx_EC_WIDTH
 	cmp	x0, #ESR_ELx_EC_HVC64
 	ccmp	x0, #ESR_ELx_EC_HVC32, #4, ne
 	b.ne	el1_trap
diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
index 4b652ffb591d..d310d2b2c8b4 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -115,7 +115,7 @@ SYM_FUNC_END(__hyp_do_panic)
 .L__vect_start\@:
 	stp	x0, x1, [sp, #-16]!
 	mrs	x0, esr_el2
-	lsr	x0, x0, #ESR_ELx_EC_SHIFT
+	ubfx	x0, x0, #ESR_ELx_EC_SHIFT, #ESR_ELx_EC_WIDTH
 	cmp	x0, #ESR_ELx_EC_HVC64
 	b.ne	__host_exit
 
-- 
2.11.0

