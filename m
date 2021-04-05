Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D675354499
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 18:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238888AbhDEQFo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 12:05:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:58234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237878AbhDEQFZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 12:05:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 240E6613EE;
        Mon,  5 Apr 2021 16:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617638719;
        bh=U0NkCqrtt2/5zmQhJfG2/sgeLgus2MBC9ny/6oHh/0c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cO8TdGzRw58OdpcUPQvXwhToA7XW285ZAJGZGiqKeDSiRyoDuEt19bN0msKoOA/RV
         ISDVWy/D6FY7ZfQIptNanWY7SYLgbcZl0GdvflJpkM0gkhfzVF4qq3QAKxDscWqWiL
         TfTY381yvmaBxFSPE8j0MN8VaSJK9d3h6UXxZylaP5fvOy4PU19MefTGZ3r8Gkx8TF
         2xvqKjl3Hk0evZt4A1KvtkmJW5lX6S5uk6bAAnKYlpz9m3gRQcvZpEryw6ZA/YFNZH
         D3F4IWJvjgQNe3y0Wj1+Dg306iz80yyA/JIYsSpXfCFsuNT4dmkUnVnpqD1QtCQQ7X
         GqD4oFv3tTPDg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Suzuki K Poulose <suzuki.poulose@arm.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Subject: [PATCH AUTOSEL 4.19 2/8] KVM: arm64: Disable guest access to trace filter controls
Date:   Mon,  5 Apr 2021 12:05:09 -0400
Message-Id: <20210405160515.269020-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210405160515.269020-1-sashal@kernel.org>
References: <20210405160515.269020-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index a3b6f58d188c..6d43f7901da2 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -198,6 +198,7 @@
 #define CPTR_EL2_DEFAULT	CPTR_EL2_RES1
 
 /* Hyp Debug Configuration Register bits */
+#define MDCR_EL2_TTRF		(1 << 19)
 #define MDCR_EL2_TPMS		(1 << 14)
 #define MDCR_EL2_E2PB_MASK	(UL(0x3))
 #define MDCR_EL2_E2PB_SHIFT	(UL(12))
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index 4e722d73a3c3..3606f6b89094 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -100,6 +100,7 @@ void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu)
  *  - Debug ROM Address (MDCR_EL2_TDRA)
  *  - OS related registers (MDCR_EL2_TDOSA)
  *  - Statistical profiler (MDCR_EL2_TPMS/MDCR_EL2_E2PB)
+ *  - Self-hosted Trace Filter controls (MDCR_EL2_TTRF)
  *
  * Additionally, KVM only traps guest accesses to the debug registers if
  * the guest is not actively using them (see the KVM_ARM64_DEBUG_DIRTY
@@ -123,6 +124,7 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 	vcpu->arch.mdcr_el2 = __this_cpu_read(mdcr_el2) & MDCR_EL2_HPMN_MASK;
 	vcpu->arch.mdcr_el2 |= (MDCR_EL2_TPM |
 				MDCR_EL2_TPMS |
+				MDCR_EL2_TTRF |
 				MDCR_EL2_TPMCR |
 				MDCR_EL2_TDRA |
 				MDCR_EL2_TDOSA);
-- 
2.30.2

