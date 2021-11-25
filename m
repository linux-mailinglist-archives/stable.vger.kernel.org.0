Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5438645DD40
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 16:22:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356062AbhKYPZ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 10:25:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:54490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355995AbhKYPX3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 10:23:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E29AE610A2;
        Thu, 25 Nov 2021 15:20:16 +0000 (UTC)
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     linux-arm-kernel@lists.infradead.org
Cc:     Chris January <Chris.January@arm.com>, stable@vger.kernel.org,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>
Subject: [PATCH] arm64: KVM: Avoid setting the upper 32 bits of TCR_EL2 and CPTR_EL2 to 1
Date:   Thu, 25 Nov 2021 15:20:14 +0000
Message-Id: <20211125152014.2806582-1-catalin.marinas@arm.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Having a signed (1 << 31) constant for TCR_EL2_RES1 and CPTR_EL2_TCPAC
causes the upper 32-bit to be set to 1 when assigning them to a 64-bit
variable. Bit 32 in TCR_EL2 is no longer RES0 in ARMv8.7: with FEAT_LPA2
it changes the meaning of bits 49:48 and 9:8 in the stage 1 EL2 page
table entries. As a result of the sign-extension, a non-VHE kernel can
no longer boot on a model with ARMv8.7 enabled.

CPTR_EL2 still has the top 32 bits RES0 but we should preempt any future
problems

Make these top bit constants unsigned as per commit df655b75c43f
("arm64: KVM: Avoid setting the upper 32 bits of VTCR_EL2 to 1").

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reported-by: Chris January <Chris.January@arm.com>
Cc: <stable@vger.kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_arm.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index a39fcf318c77..01d47c5886dc 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -91,7 +91,7 @@
 #define HCR_HOST_VHE_FLAGS (HCR_RW | HCR_TGE | HCR_E2H)
 
 /* TCR_EL2 Registers bits */
-#define TCR_EL2_RES1		((1 << 31) | (1 << 23))
+#define TCR_EL2_RES1		((1U << 31) | (1 << 23))
 #define TCR_EL2_TBI		(1 << 20)
 #define TCR_EL2_PS_SHIFT	16
 #define TCR_EL2_PS_MASK		(7 << TCR_EL2_PS_SHIFT)
@@ -276,7 +276,7 @@
 #define CPTR_EL2_TFP_SHIFT 10
 
 /* Hyp Coprocessor Trap Register */
-#define CPTR_EL2_TCPAC	(1 << 31)
+#define CPTR_EL2_TCPAC	(1U << 31)
 #define CPTR_EL2_TAM	(1 << 30)
 #define CPTR_EL2_TTA	(1 << 20)
 #define CPTR_EL2_TFP	(1 << CPTR_EL2_TFP_SHIFT)
