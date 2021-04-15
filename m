Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85673360DBE
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 17:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233781AbhDOPFk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 11:05:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:47228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234175AbhDOPC0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 11:02:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D65406141D;
        Thu, 15 Apr 2021 14:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498670;
        bh=3g36g50sGrlLKwYeeXFoH665hG2tCB9SHANgl+u75Aw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pyzx5FUlIjjmyi6CpA4F2exTN+iz9ucozKh2bft5WOHkLDCQWZbje6mGxgA8Xev4y
         A35iJ6QDiLdbkR1kP7tPPB9LRvm0RTWPHQGsSt76WSt5b6NHkQUIRF9dJ2EAtyeT/6
         52j0p1rCCz87elHKEb0aHQHawdKEzJ/ne+vlgaV0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 04/25] KVM: arm64: Disable guest access to trace filter controls
Date:   Thu, 15 Apr 2021 16:47:58 +0200
Message-Id: <20210415144413.305721939@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144413.165663182@linuxfoundation.org>
References: <20210415144413.165663182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

[ Upstream commit a354a64d91eec3e0f8ef0eed575b480fd75b999c ]

Disable guest access to the Trace Filter control registers.
We do not advertise the Trace filter feature to the guest
(ID_AA64DFR0_EL1: TRACE_FILT is cleared) already, but the guest
can still access the TRFCR_EL1 unless we trap it.

This will also make sure that the guest cannot fiddle with
the filtering controls set by a nvhe host.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210323120647.454211-3-suzuki.poulose@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/kvm_arm.h | 1 +
 arch/arm64/kvm/debug.c           | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 64ce29378467..395cb22d9f7d 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -277,6 +277,7 @@
 #define CPTR_EL2_DEFAULT	CPTR_EL2_RES1
 
 /* Hyp Debug Configuration Register bits */
+#define MDCR_EL2_TTRF		(1 << 19)
 #define MDCR_EL2_TPMS		(1 << 14)
 #define MDCR_EL2_E2PB_MASK	(UL(0x3))
 #define MDCR_EL2_E2PB_SHIFT	(UL(12))
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index 7a7e425616b5..dbc890511631 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -89,6 +89,7 @@ void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu)
  *  - Debug ROM Address (MDCR_EL2_TDRA)
  *  - OS related registers (MDCR_EL2_TDOSA)
  *  - Statistical profiler (MDCR_EL2_TPMS/MDCR_EL2_E2PB)
+ *  - Self-hosted Trace Filter controls (MDCR_EL2_TTRF)
  *
  * Additionally, KVM only traps guest accesses to the debug registers if
  * the guest is not actively using them (see the KVM_ARM64_DEBUG_DIRTY
@@ -112,6 +113,7 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 	vcpu->arch.mdcr_el2 = __this_cpu_read(mdcr_el2) & MDCR_EL2_HPMN_MASK;
 	vcpu->arch.mdcr_el2 |= (MDCR_EL2_TPM |
 				MDCR_EL2_TPMS |
+				MDCR_EL2_TTRF |
 				MDCR_EL2_TPMCR |
 				MDCR_EL2_TDRA |
 				MDCR_EL2_TDOSA);
-- 
2.30.2



