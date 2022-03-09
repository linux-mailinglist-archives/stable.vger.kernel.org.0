Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB0E4D331D
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 17:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234515AbiCIQNx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 11:13:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235123AbiCIQNC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:13:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C21EA154709;
        Wed,  9 Mar 2022 08:10:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40087B82191;
        Wed,  9 Mar 2022 16:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8919DC340EC;
        Wed,  9 Mar 2022 16:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646842212;
        bh=aznECDtrCLjMhduI5pusl4speT9yyZT4RO1s2dy+4IM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mgNDmsv5GDyEHTGOo4XE7WsGEkZ4lCOru6BT6FNwje2jG1pWcCvOLRI9QmyOwbf8s
         Xpy0F9TWCfx6sMSjN2qu0qf9WxkYWwLQp7VqwDTqGJlW0k3xrYJaKOHWexkxScjL+1
         qj47+jx/b0RQvNgOIjzVcpmutjq4m6k2T16UOYUg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 5.16 34/37] KVM: arm64: Allow SMCCC_ARCH_WORKAROUND_3 to be discovered and migrated
Date:   Wed,  9 Mar 2022 17:00:35 +0100
Message-Id: <20220309155900.075514145@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220309155859.086952723@linuxfoundation.org>
References: <20220309155859.086952723@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Morse <james.morse@arm.com>

commit a5905d6af492ee6a4a2205f0d550b3f931b03d03 upstream.

KVM allows the guest to discover whether the ARCH_WORKAROUND SMCCC are
implemented, and to preserve that state during migration through its
firmware register interface.

Add the necessary boiler plate for SMCCC_ARCH_WORKAROUND_3.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/uapi/asm/kvm.h |    5 +++++
 arch/arm64/kvm/hypercalls.c       |   12 ++++++++++++
 arch/arm64/kvm/psci.c             |   18 +++++++++++++++++-
 3 files changed, 34 insertions(+), 1 deletion(-)

--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -281,6 +281,11 @@ struct kvm_arm_copy_mte_tags {
 #define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_REQUIRED	3
 #define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED     	(1U << 4)
 
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3	KVM_REG_ARM_FW_REG(3)
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3_NOT_AVAIL		0
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3_AVAIL		1
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3_NOT_REQUIRED	2
+
 /* SVE registers */
 #define KVM_REG_ARM64_SVE		(0x15 << KVM_REG_ARM_COPROC_SHIFT)
 
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -107,6 +107,18 @@ int kvm_hvc_call_handler(struct kvm_vcpu
 				break;
 			}
 			break;
+		case ARM_SMCCC_ARCH_WORKAROUND_3:
+			switch (arm64_get_spectre_bhb_state()) {
+			case SPECTRE_VULNERABLE:
+				break;
+			case SPECTRE_MITIGATED:
+				val[0] = SMCCC_RET_SUCCESS;
+				break;
+			case SPECTRE_UNAFFECTED:
+				val[0] = SMCCC_ARCH_WORKAROUND_RET_UNAFFECTED;
+				break;
+			}
+			break;
 		case ARM_SMCCC_HV_PV_TIME_FEATURES:
 			val[0] = SMCCC_RET_SUCCESS;
 			break;
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -406,7 +406,7 @@ int kvm_psci_call(struct kvm_vcpu *vcpu)
 
 int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
 {
-	return 3;		/* PSCI version and two workaround registers */
+	return 4;		/* PSCI version and three workaround registers */
 }
 
 int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
@@ -420,6 +420,9 @@ int kvm_arm_copy_fw_reg_indices(struct k
 	if (put_user(KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2, uindices++))
 		return -EFAULT;
 
+	if (put_user(KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3, uindices++))
+		return -EFAULT;
+
 	return 0;
 }
 
@@ -459,6 +462,17 @@ static int get_kernel_wa_level(u64 regid
 		case SPECTRE_VULNERABLE:
 			return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL;
 		}
+		break;
+	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3:
+		switch (arm64_get_spectre_bhb_state()) {
+		case SPECTRE_VULNERABLE:
+			return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3_NOT_AVAIL;
+		case SPECTRE_MITIGATED:
+			return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3_AVAIL;
+		case SPECTRE_UNAFFECTED:
+			return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3_NOT_REQUIRED;
+		}
+		return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3_NOT_AVAIL;
 	}
 
 	return -EINVAL;
@@ -475,6 +489,7 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *
 		break;
 	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1:
 	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2:
+	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3:
 		val = get_kernel_wa_level(reg->id) & KVM_REG_FEATURE_LEVEL_MASK;
 		break;
 	default:
@@ -520,6 +535,7 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *
 	}
 
 	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1:
+	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3:
 		if (val & ~KVM_REG_FEATURE_LEVEL_MASK)
 			return -EINVAL;
 


