Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2540374066
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 18:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234650AbhEEQeq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:34:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:53868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234308AbhEEQdP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:33:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF40C613C4;
        Wed,  5 May 2021 16:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232338;
        bh=HIoIwvjaeDzR6jcuBupmH52Whq50YqGDyJRDvBh+h0M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BQiR8F7sb7bo6tfP8+DvhnK5w16CedUIAgicj2wJrNtkvDfyQWOmuzbWgBVUuW3sU
         Ag5a5xrMweFM45uacUlljuvafKfjEcBsXrUJLXygjbbBo6L+SvitEaoGGXZd0jZ+rr
         Gbm7J+hF/ZfORq4NX3KZMWH8asMVaRlF0U0lELKa1pl9+bl84B8zNSLGVAC+HfyiCB
         Iv1uYKdTGzGi/AB6DgYIki/LMS5P+pyxo9WQBDZQs5fAxf8ugXuX+hykM2+xsk28nG
         Wma1YTuMPqpEtwkrl3eI+C+E36z+/nbyKg1PJYoaZOIWrLWAsNc+gdgE2D5tqknwnP
         WCy/vCOcUM3NA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrew Scull <ascull@google.com>, Will Deacon <will@kernel.org>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Subject: [PATCH AUTOSEL 5.12 039/116] KVM: arm64: Use BUG and BUG_ON in nVHE hyp
Date:   Wed,  5 May 2021 12:30:07 -0400
Message-Id: <20210505163125.3460440-39-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163125.3460440-1-sashal@kernel.org>
References: <20210505163125.3460440-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Scull <ascull@google.com>

[ Upstream commit f79e616f27ab6cd74deb0995a8eead3d1c9d65af ]

hyp_panic() reports the address of the panic by using ELR_EL2, but this
isn't a useful address when hyp_panic() is called directly. Replace such
direct calls with BUG() and BUG_ON() which use BRK to trigger an
exception that then goes to hyp_panic() with the correct address. Also
remove the hyp_panic() declaration from the header file to avoid
accidental misuse.

Signed-off-by: Andrew Scull <ascull@google.com>
Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210318143311.839894-5-ascull@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/kvm_hyp.h   | 1 -
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-smp.c  | 6 ++----
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 32ae676236b6..fe5fc814f228 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -100,7 +100,6 @@ u64 __guest_enter(struct kvm_vcpu *vcpu);
 
 bool kvm_host_psci_handler(struct kvm_cpu_context *host_ctxt);
 
-void __noreturn hyp_panic(void);
 #ifdef __KVM_NVHE_HYPERVISOR__
 void __noreturn __hyp_do_panic(struct kvm_cpu_context *host_ctxt, u64 spsr,
 			       u64 elr, u64 par);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 936328207bde..821a69601dd9 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -178,6 +178,6 @@ void handle_trap(struct kvm_cpu_context *host_ctxt)
 		handle_host_smc(host_ctxt);
 		break;
 	default:
-		hyp_panic();
+		BUG();
 	}
 }
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-smp.c b/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
index 879559057dee..9f54833af400 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
@@ -18,8 +18,7 @@ u64 __ro_after_init hyp_cpu_logical_map[NR_CPUS] = { [0 ... NR_CPUS-1] = INVALID
 
 u64 cpu_logical_map(unsigned int cpu)
 {
-	if (cpu >= ARRAY_SIZE(hyp_cpu_logical_map))
-		hyp_panic();
+	BUG_ON(cpu >= ARRAY_SIZE(hyp_cpu_logical_map));
 
 	return hyp_cpu_logical_map[cpu];
 }
@@ -30,8 +29,7 @@ unsigned long __hyp_per_cpu_offset(unsigned int cpu)
 	unsigned long this_cpu_base;
 	unsigned long elf_base;
 
-	if (cpu >= ARRAY_SIZE(kvm_arm_hyp_percpu_base))
-		hyp_panic();
+	BUG_ON(cpu >= ARRAY_SIZE(kvm_arm_hyp_percpu_base));
 
 	cpu_base_array = (unsigned long *)&kvm_arm_hyp_percpu_base;
 	this_cpu_base = kern_hyp_va(cpu_base_array[cpu]);
-- 
2.30.2

