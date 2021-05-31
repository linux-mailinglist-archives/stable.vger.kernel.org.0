Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A372396166
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233638AbhEaOkW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:40:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:33150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233870AbhEaOhh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:37:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 36A1261628;
        Mon, 31 May 2021 13:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469107;
        bh=6BOAp3DYobcfck+9QlbAzsXNTROTyJvER1dchpAUriE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HBLPqPiITG9iAhcaTiYuOw1lLC07AJd/J7NpaIW8QMvNh8xVy/M2gvRD+br74Pt6j
         ArBbzohLGKB8sCmSab0cTILAPJuVdZuGHn4X+ZA/udL+NEqbWd2LRcz/bAiTlvXRK9
         cTqkInqbxaN0QkZF+R15x+rqAERlh2UZyU8G8yn8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steven Price <steven.price@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 5.12 073/296] KVM: arm64: Prevent mixed-width VM creation
Date:   Mon, 31 May 2021 15:12:08 +0200
Message-Id: <20210531130706.302867410@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
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
@@ -463,4 +463,9 @@ static __always_inline void kvm_incr_pc(
 	vcpu->arch.flags |= KVM_ARM64_INCREMENT_PC;
 }
 
+static inline bool vcpu_has_feature(struct kvm_vcpu *vcpu, int feature)
+{
+	return test_bit(feature, vcpu->arch.features);
+}
+
 #endif /* __ARM64_KVM_EMULATE_H__ */
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -170,6 +170,25 @@ static int kvm_vcpu_enable_ptrauth(struc
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
@@ -221,13 +240,14 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu
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


