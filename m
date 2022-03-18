Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 003BF4DE06C
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 18:52:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239894AbiCRRvY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 13:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239862AbiCRRvK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 13:51:10 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7E78717B0D0;
        Fri, 18 Mar 2022 10:49:51 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 472AF1576;
        Fri, 18 Mar 2022 10:49:51 -0700 (PDT)
Received: from eglon.cambridge.arm.com (eglon.cambridge.arm.com [10.1.196.218])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9B8083F7B4;
        Fri, 18 Mar 2022 10:49:50 -0700 (PDT)
From:   James Morse <james.morse@arm.com>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, james.morse@arm.com,
        catalin.marinas@arm.com
Subject: [stable:PATCH v4.19.235 20/22] KVM: arm64: Allow SMCCC_ARCH_WORKAROUND_3 to be discovered and migrated
Date:   Fri, 18 Mar 2022 17:48:40 +0000
Message-Id: <20220318174842.2321061-21-james.morse@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220318174842.2321061-1-james.morse@arm.com>
References: <20220318174842.2321061-1-james.morse@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit a5905d6af492ee6a4a2205f0d550b3f931b03d03 upstream.

KVM allows the guest to discover whether the ARCH_WORKAROUND SMCCC are
implemented, and to preserve that state during migration through its
firmware register interface.

Add the necessary boiler plate for SMCCC_ARCH_WORKAROUND_3.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
[ kvm code moved to virt/kvm/arm, removed fw regs ABI. Added 32bit stub ]
Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm/include/asm/kvm_host.h   |  7 +++++++
 arch/arm64/include/asm/kvm_host.h |  5 +++++
 virt/kvm/arm/psci.c               | 12 ++++++++++++
 3 files changed, 24 insertions(+)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index ae073fceb3f0..db20534912cd 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -26,6 +26,7 @@
 #include <asm/kvm_asm.h>
 #include <asm/kvm_mmio.h>
 #include <asm/fpstate.h>
+#include <asm/spectre.h>
 #include <kvm/arm_arch_timer.h>
 
 #define __KVM_HAVE_ARCH_INTC_INITIALIZED
@@ -367,4 +368,10 @@ void kvm_arch_free_vm(struct kvm *kvm);
 
 #define kvm_arm_vcpu_loaded(vcpu)	(false)
 
+static inline int kvm_arm_get_spectre_bhb_state(void)
+{
+	/* 32bit guests don't need firmware for this */
+	return SPECTRE_VULNERABLE; /* aka SMCCC_RET_NOT_SUPPORTED */
+}
+
 #endif /* __ARM_KVM_HOST_H__ */
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 07472c138ced..7e1b19ea07ea 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -542,4 +542,9 @@ void kvm_arch_free_vm(struct kvm *kvm);
 
 #define kvm_arm_vcpu_loaded(vcpu)	((vcpu)->arch.sysregs_loaded_on_cpu)
 
+static inline enum mitigation_state kvm_arm_get_spectre_bhb_state(void)
+{
+	return arm64_get_spectre_bhb_state();
+}
+
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/virt/kvm/arm/psci.c b/virt/kvm/arm/psci.c
index 34d08ee63747..a161951e55a5 100644
--- a/virt/kvm/arm/psci.c
+++ b/virt/kvm/arm/psci.c
@@ -429,6 +429,18 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 				break;
 			}
 			break;
+		case ARM_SMCCC_ARCH_WORKAROUND_3:
+			switch (kvm_arm_get_spectre_bhb_state()) {
+			case SPECTRE_VULNERABLE:
+				break;
+			case SPECTRE_MITIGATED:
+				val = SMCCC_RET_SUCCESS;
+				break;
+			case SPECTRE_UNAFFECTED:
+				val = SMCCC_ARCH_WORKAROUND_RET_UNAFFECTED;
+				break;
+			}
+			break;
 		}
 		break;
 	default:
-- 
2.30.2

