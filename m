Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3B44D32CE
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 17:16:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbiCIQML (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 11:12:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235613AbiCIQJA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:09:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0A44140778;
        Wed,  9 Mar 2022 08:06:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C38BB82230;
        Wed,  9 Mar 2022 16:06:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FB92C340F3;
        Wed,  9 Mar 2022 16:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646841975;
        bh=CKv9siGuusoENM2DBRrXprlaYHpaPdR7ANqVe2dSUZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lzgiqys1dFXrrWy6iV2iZS0avdzpPRjPdaouyPUhukRZSKZyONJ0Uw907603tDBj6
         TBYFBSVv3Hfqvn5TZL7wyROQho8Dj6qFSlBd1strXdwLCBmVOpc8Pm2P83aelj1dTl
         JzOAQ4LUj5otzB9IdWdpeu9u4g/QI9SqmTbaytZ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 5.10 40/43] KVM: arm64: Allow SMCCC_ARCH_WORKAROUND_3 to be discovered and migrated
Date:   Wed,  9 Mar 2022 17:00:13 +0100
Message-Id: <20220309155900.399494105@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220309155859.239810747@linuxfoundation.org>
References: <20220309155859.239810747@linuxfoundation.org>
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
@@ -273,6 +273,11 @@ struct kvm_vcpu_events {
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
@@ -58,6 +58,18 @@ int kvm_hvc_call_handler(struct kvm_vcpu
 				break;
 			}
 			break;
+		case ARM_SMCCC_ARCH_WORKAROUND_3:
+			switch (arm64_get_spectre_bhb_state()) {
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
 		case ARM_SMCCC_HV_PV_TIME_FEATURES:
 			val = SMCCC_RET_SUCCESS;
 			break;
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -397,7 +397,7 @@ int kvm_psci_call(struct kvm_vcpu *vcpu)
 
 int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
 {
-	return 3;		/* PSCI version and two workaround registers */
+	return 4;		/* PSCI version and three workaround registers */
 }
 
 int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
@@ -411,6 +411,9 @@ int kvm_arm_copy_fw_reg_indices(struct k
 	if (put_user(KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2, uindices++))
 		return -EFAULT;
 
+	if (put_user(KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3, uindices++))
+		return -EFAULT;
+
 	return 0;
 }
 
@@ -450,6 +453,17 @@ static int get_kernel_wa_level(u64 regid
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
@@ -466,6 +480,7 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *
 		break;
 	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1:
 	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2:
+	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3:
 		val = get_kernel_wa_level(reg->id) & KVM_REG_FEATURE_LEVEL_MASK;
 		break;
 	default:
@@ -511,6 +526,7 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *
 	}
 
 	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1:
+	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3:
 		if (val & ~KVM_REG_FEATURE_LEVEL_MASK)
 			return -EINVAL;
 


