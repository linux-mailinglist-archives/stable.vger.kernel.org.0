Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44D6242632
	for <lists+stable@lfdr.de>; Wed, 12 Jun 2019 14:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728693AbfFLMoz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jun 2019 08:44:55 -0400
Received: from foss.arm.com ([217.140.110.172]:52552 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728606AbfFLMoy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 Jun 2019 08:44:54 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 525FD28;
        Wed, 12 Jun 2019 05:44:54 -0700 (PDT)
Received: from e103592.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 68A863F246;
        Wed, 12 Jun 2019 05:44:53 -0700 (PDT)
From:   Dave Martin <Dave.Martin@arm.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Marc Zyngier <marc.zyngier@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>, stable@vger.kernel.org
Subject: [PATCH v4 REPOST] KVM: arm64: Filter out invalid core register IDs in KVM_GET_REG_LIST
Date:   Wed, 12 Jun 2019 13:44:49 +0100
Message-Id: <1560343489-22906-1-git-send-email-Dave.Martin@arm.com>
X-Mailer: git-send-email 2.1.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since commit d26c25a9d19b ("arm64: KVM: Tighten guest core register
access from userspace"), KVM_{GET,SET}_ONE_REG rejects register IDs
that do not correspond to a single underlying architectural register.

KVM_GET_REG_LIST was not changed to match however: instead, it
simply yields a list of 32-bit register IDs that together cover the
whole kvm_regs struct.  This means that if userspace tries to use
the resulting list of IDs directly to drive calls to KVM_*_ONE_REG,
some of those calls will now fail.

This was not the intention.  Instead, iterating KVM_*_ONE_REG over
the list of IDs returned by KVM_GET_REG_LIST should be guaranteed
to work.

This patch fixes the problem by splitting validate_core_offset()
into a backend core_reg_size_from_offset() which does all of the
work except for checking that the size field in the register ID
matches, and kvm_arm_copy_reg_indices() and num_core_regs() are
converted to use this to enumerate the valid offsets.

kvm_arm_copy_reg_indices() now also sets the register ID size field
appropriately based on the value returned, so the register ID
supplied to userspace is fully qualified for use with the register
access ioctls.

Cc: stable@vger.kernel.org
Fixes: d26c25a9d19b ("arm64: KVM: Tighten guest core register access from userspace")
Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Tested-by: Andrew Jones <drjones@redhat.com>
---

This is just a repost of [1], with Andrew Jones' reviewer tags added.

[1] [PATCH] KVM: arm64: Filter out invalid core register IDs in KVM_GET_REG_LIST
https://lists.cs.columbia.edu/pipermail/kvmarm/2019-June/036093.html

 arch/arm64/kvm/guest.c | 53 +++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 40 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 3ae2f82..6527c76 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -70,10 +70,8 @@ static u64 core_reg_offset_from_id(u64 id)
 	return id & ~(KVM_REG_ARCH_MASK | KVM_REG_SIZE_MASK | KVM_REG_ARM_CORE);
 }
 
-static int validate_core_offset(const struct kvm_vcpu *vcpu,
-				const struct kvm_one_reg *reg)
+static int core_reg_size_from_offset(const struct kvm_vcpu *vcpu, u64 off)
 {
-	u64 off = core_reg_offset_from_id(reg->id);
 	int size;
 
 	switch (off) {
@@ -103,8 +101,7 @@ static int validate_core_offset(const struct kvm_vcpu *vcpu,
 		return -EINVAL;
 	}
 
-	if (KVM_REG_SIZE(reg->id) != size ||
-	    !IS_ALIGNED(off, size / sizeof(__u32)))
+	if (!IS_ALIGNED(off, size / sizeof(__u32)))
 		return -EINVAL;
 
 	/*
@@ -115,6 +112,21 @@ static int validate_core_offset(const struct kvm_vcpu *vcpu,
 	if (vcpu_has_sve(vcpu) && core_reg_offset_is_vreg(off))
 		return -EINVAL;
 
+	return size;
+}
+
+static int validate_core_offset(const struct kvm_vcpu *vcpu,
+				const struct kvm_one_reg *reg)
+{
+	u64 off = core_reg_offset_from_id(reg->id);
+	int size = core_reg_size_from_offset(vcpu, off);
+
+	if (size < 0)
+		return -EINVAL;
+
+	if (KVM_REG_SIZE(reg->id) != size)
+		return -EINVAL;
+
 	return 0;
 }
 
@@ -453,19 +465,34 @@ static int copy_core_reg_indices(const struct kvm_vcpu *vcpu,
 {
 	unsigned int i;
 	int n = 0;
-	const u64 core_reg = KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE;
 
 	for (i = 0; i < sizeof(struct kvm_regs) / sizeof(__u32); i++) {
-		/*
-		 * The KVM_REG_ARM64_SVE regs must be used instead of
-		 * KVM_REG_ARM_CORE for accessing the FPSIMD V-registers on
-		 * SVE-enabled vcpus:
-		 */
-		if (vcpu_has_sve(vcpu) && core_reg_offset_is_vreg(i))
+		u64 reg = KVM_REG_ARM64 | KVM_REG_ARM_CORE | i;
+		int size = core_reg_size_from_offset(vcpu, i);
+
+		if (size < 0)
+			continue;
+
+		switch (size) {
+		case sizeof(__u32):
+			reg |= KVM_REG_SIZE_U32;
+			break;
+
+		case sizeof(__u64):
+			reg |= KVM_REG_SIZE_U64;
+			break;
+
+		case sizeof(__uint128_t):
+			reg |= KVM_REG_SIZE_U128;
+			break;
+
+		default:
+			WARN_ON(1);
 			continue;
+		}
 
 		if (uindices) {
-			if (put_user(core_reg | i, uindices))
+			if (put_user(reg, uindices))
 				return -EFAULT;
 			uindices++;
 		}
-- 
2.1.4

