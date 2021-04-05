Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1D9A354490
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 18:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242023AbhDEQFh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 12:05:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:58102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239356AbhDEQFg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 12:05:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A6B5613E0;
        Mon,  5 Apr 2021 16:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617638730;
        bh=6upIme9NTn4kmRIF1WoJlNw5F51QogKQSHyzMkHD3m4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MvUYBP0Sul+9nUdyZ9U117OKirbuoWnOfVLxUQsgxd1jlyzpIAI7wHG2l+lyOak6J
         dw7POqmJjP3OeKEaAOe5IlQ40rEhIy0R3wz4pzXRJICN+y2euiFXarTg24OTCDSAuN
         Fjp42x8G/iVC/UKVI9qed3NtflxSQhRYfEyTAsZCJqNiNLDDznE+DuavxCyjH7wZGj
         dJ2UzmUcjiJ4Z0k347oVAj7oGHm/8R+POUAN1UZ+9jhBH7FT+JiSqEie9nPDHYDiD9
         Kxrj3nvLuJO1m/WCZceni00a65F+rSWjG4ttKcVv3Jt3YxOgp1Maclrts5oqfsQ+7Z
         BA7JEt6JpiwfQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Suzuki K Poulose <suzuki.poulose@arm.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Subject: [PATCH AUTOSEL 4.14 2/5] KVM: arm64: Disable guest access to trace filter controls
Date:   Mon,  5 Apr 2021 12:05:23 -0400
Message-Id: <20210405160526.269140-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210405160526.269140-1-sashal@kernel.org>
References: <20210405160526.269140-1-sashal@kernel.org>
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
index f88611e241f0..72ed11292df3 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -191,6 +191,7 @@
 #define CPTR_EL2_DEFAULT	0x000033ff
 
 /* Hyp Debug Configuration Register bits */
+#define MDCR_EL2_TTRF		(1 << 19)
 #define MDCR_EL2_TPMS		(1 << 14)
 #define MDCR_EL2_E2PB_MASK	(UL(0x3))
 #define MDCR_EL2_E2PB_SHIFT	(UL(12))
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index dbadfaf850a7..2da4f45ab0bb 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -96,6 +96,7 @@ void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu)
  *  - Debug ROM Address (MDCR_EL2_TDRA)
  *  - OS related registers (MDCR_EL2_TDOSA)
  *  - Statistical profiler (MDCR_EL2_TPMS/MDCR_EL2_E2PB)
+ *  - Self-hosted Trace Filter controls (MDCR_EL2_TTRF)
  *
  * Additionally, KVM only traps guest accesses to the debug registers if
  * the guest is not actively using them (see the KVM_ARM64_DEBUG_DIRTY
@@ -118,6 +119,7 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 	vcpu->arch.mdcr_el2 = __this_cpu_read(mdcr_el2) & MDCR_EL2_HPMN_MASK;
 	vcpu->arch.mdcr_el2 |= (MDCR_EL2_TPM |
 				MDCR_EL2_TPMS |
+				MDCR_EL2_TTRF |
 				MDCR_EL2_TPMCR |
 				MDCR_EL2_TDRA |
 				MDCR_EL2_TDOSA);
-- 
2.30.2

