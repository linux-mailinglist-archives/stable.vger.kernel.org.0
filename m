Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EBDD395E09
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbhEaNxX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:53:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:55126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232329AbhEaNvS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:51:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E36A261628;
        Mon, 31 May 2021 13:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467943;
        bh=RDIf4hY/d+ADhv0e77VKXgujZ2SI1Ojk0bcgz4mnung=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x4djyrZ8ti+UljVbBNVAHfZTws2V6B6BJMpaBnQO9bkf4229hP66lA4loNOkAllOB
         E8n70JdMW3TkJdXp7nap2q14wDZdcyDfJk8e4GnuXUlnurMK/4tPA06DajBfjbV3TP
         f64Jr+j2Ct5AL7EtvtvnICU2UnXoHBIzo7Qwhk8g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steven Price <steven.price@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 5.10 058/252] KVM: arm64: Prevent mixed-width VM creation
Date:   Mon, 31 May 2021 15:12:03 +0200
Message-Id: <20210531130659.947462896@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

commit 66e94d5cafd4decd4f92d16a022ea587d7f4094f upstream.

It looks like we have tolerated creating mixed-width VMs since...
forever. However, that was never the intention, and we'd rather
not have to support that pointless complexity.

Forbid such a setup by making sure all the vcpus have the same
register width.

Reported-by: Steven Price <steven.price@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Acked-by: Mark Rutland <mark.rutland@arm.com>
Link: https://lore.kernel.org/r/20210524170752.1549797-1-maz@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/kvm_emulate.h |    5 +++++
 arch/arm64/kvm/reset.c               |   28 ++++++++++++++++++++++++----
 2 files changed, 29 insertions(+), 4 deletions(-)

--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -505,4 +505,9 @@ static __always_inline void __kvm_skip_i
 	write_sysreg_el2(*vcpu_pc(vcpu), SYS_ELR);
 }
 
+static inline bool vcpu_has_feature(struct kvm_vcpu *vcpu, int feature)
+{
+	return test_bit(feature, vcpu->arch.features);
+}
+
 #endif /* __ARM64_KVM_EMULATE_H__ */
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -223,6 +223,25 @@ static int kvm_vcpu_enable_ptrauth(struc
 	return 0;
 }
 
+static bool vcpu_allowed_register_width(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu *tmp;
+	bool is32bit;
+	int i;
+
+	is32bit = vcpu_has_feature(vcpu, KVM_ARM_VCPU_EL1_32BIT);
+	if (!cpus_have_const_cap(ARM64_HAS_32BIT_EL1) && is32bit)
+		return false;
+
+	/* Check that the vcpus are either all 32bit or all 64bit */
+	kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
+		if (vcpu_has_feature(tmp, KVM_ARM_VCPU_EL1_32BIT) != is32bit)
+			return false;
+	}
+
+	return true;
+}
+
 /**
  * kvm_reset_vcpu - sets core registers and sys_regs to reset value
  * @vcpu: The VCPU pointer
@@ -274,13 +293,14 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu
 		}
 	}
 
+	if (!vcpu_allowed_register_width(vcpu)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	switch (vcpu->arch.target) {
 	default:
 		if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features)) {
-			if (!cpus_have_const_cap(ARM64_HAS_32BIT_EL1)) {
-				ret = -EINVAL;
-				goto out;
-			}
 			pstate = VCPU_RESET_PSTATE_SVC;
 		} else {
 			pstate = VCPU_RESET_PSTATE_EL1;


