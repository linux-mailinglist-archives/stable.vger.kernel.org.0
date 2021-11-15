Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3029D450D13
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:46:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237510AbhKORtV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:49:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:57924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238669AbhKORrF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:47:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B04986331C;
        Mon, 15 Nov 2021 17:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997376;
        bh=amcfJlGK8EQzzLl/9k8w85fKP6X61/j4euPeLkcMqEE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x9Q29WE2qdo7aWN7ULE0vesmikUTMaa2QOJ31n+IjJcSePe2W70k8UZQdYwFSgNuU
         Ti6x0BXJ6+nQBg2/VgNBu3J46/VakdRArbPuVHdO2HpktZEtFZryZOTltW/FffzrSC
         1ql7e2TMDUrW5Nzyh18VIhJqOGV52zghhrSAdPQo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 5.10 126/575] KVM: arm64: Extract ESR_ELx.EC only
Date:   Mon, 15 Nov 2021 17:57:31 +0100
Message-Id: <20211115165348.069549994@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

commit 8bb084119f1acc2ec55ea085a97231e3ddb30782 upstream.

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
Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20211103110545.4613-1-mark.rutland@arm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/esr.h   |    1 +
 arch/arm64/kvm/hyp/hyp-entry.S |    2 +-
 arch/arm64/kvm/hyp/nvhe/host.S |    2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -68,6 +68,7 @@
 #define ESR_ELx_EC_MAX		(0x3F)
 
 #define ESR_ELx_EC_SHIFT	(26)
+#define ESR_ELx_EC_WIDTH	(6)
 #define ESR_ELx_EC_MASK		(UL(0x3F) << ESR_ELx_EC_SHIFT)
 #define ESR_ELx_EC(esr)		(((esr) & ESR_ELx_EC_MASK) >> ESR_ELx_EC_SHIFT)
 
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -43,7 +43,7 @@
 el1_sync:				// Guest trapped into EL2
 
 	mrs	x0, esr_el2
-	lsr	x0, x0, #ESR_ELx_EC_SHIFT
+	ubfx	x0, x0, #ESR_ELx_EC_SHIFT, #ESR_ELx_EC_WIDTH
 	cmp	x0, #ESR_ELx_EC_HVC64
 	ccmp	x0, #ESR_ELx_EC_HVC32, #4, ne
 	b.ne	el1_trap
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -97,7 +97,7 @@ SYM_FUNC_END(__hyp_do_panic)
 .L__vect_start\@:
 	stp	x0, x1, [sp, #-16]!
 	mrs	x0, esr_el2
-	lsr	x0, x0, #ESR_ELx_EC_SHIFT
+	ubfx	x0, x0, #ESR_ELx_EC_SHIFT, #ESR_ELx_EC_WIDTH
 	cmp	x0, #ESR_ELx_EC_HVC64
 	ldp	x0, x1, [sp], #16
 	b.ne	__host_exit


