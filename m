Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F53E4F68DC
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 20:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240338AbiDFSKB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 14:10:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240114AbiDFSIz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 14:08:55 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CFC3C1A8446;
        Wed,  6 Apr 2022 09:46:38 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B0AAE12FC;
        Wed,  6 Apr 2022 09:46:38 -0700 (PDT)
Received: from eglon.cambridge.arm.com (eglon.cambridge.arm.com [10.1.196.218])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0F5B03F73B;
        Wed,  6 Apr 2022 09:46:37 -0700 (PDT)
From:   James Morse <james.morse@arm.com>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [stable:PATCH v4.9.309 41/43] KVM: arm64: Allow SMCCC_ARCH_WORKAROUND_3 to be discovered and migrated
Date:   Wed,  6 Apr 2022 17:45:44 +0100
Message-Id: <20220406164546.1888528-41-james.morse@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220406164546.1888528-1-james.morse@arm.com>
References: <0220406164217.1888053-1-james.morse@arm.com>
 <20220406164546.1888528-1-james.morse@arm.com>
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
[ kvm code moved to arch/arm/kvm, removed fw regs ABI. Added 32bit stub ]
Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm/include/asm/kvm_host.h   | 5 +++++
 arch/arm/kvm/psci.c               | 4 ++++
 arch/arm64/include/asm/kvm_host.h | 4 ++++
 3 files changed, 13 insertions(+)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 2fda7e905754..82c71a147f21 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -349,4 +349,9 @@ static inline int kvm_arm_have_ssbd(void)
 	return KVM_SSBD_UNKNOWN;
 }
 
+static inline bool kvm_arm_spectre_bhb_mitigated(void)
+{
+	/* 32bit guests don't need firmware for this */
+	return false;
+}
 #endif /* __ARM_KVM_HOST_H__ */
diff --git a/arch/arm/kvm/psci.c b/arch/arm/kvm/psci.c
index 83365bec04b6..a262c175456d 100644
--- a/arch/arm/kvm/psci.c
+++ b/arch/arm/kvm/psci.c
@@ -431,6 +431,10 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 				break;
 			}
 			break;
+		case ARM_SMCCC_ARCH_WORKAROUND_3:
+			if (kvm_arm_spectre_bhb_mitigated())
+				val = SMCCC_RET_SUCCESS;
+			break;
 		}
 		break;
 	default:
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index a152a7bbc85a..a75f02e5f0fd 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -452,4 +452,8 @@ static inline int kvm_arm_have_ssbd(void)
 	}
 }
 
+static inline bool kvm_arm_spectre_bhb_mitigated(void)
+{
+	return arm64_get_spectre_bhb_state() == SPECTRE_MITIGATED;
+}
 #endif /* __ARM64_KVM_HOST_H__ */
-- 
2.30.2

