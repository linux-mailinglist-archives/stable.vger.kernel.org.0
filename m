Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3824D4FE00
	for <lists+stable@lfdr.de>; Sun, 23 Jun 2019 22:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbfFWU33 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jun 2019 16:29:29 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:40181 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726290AbfFWU33 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jun 2019 16:29:29 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 776C322125;
        Sun, 23 Jun 2019 16:29:28 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 23 Jun 2019 16:29:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=8Zf/6v
        e7nu2MDg2FfpqKfnbznQn9p63UaKYxtkZHGOc=; b=KzOfeEHZm+Di4sBJWJgAQ/
        RJry0oJsOXqmc5R9wLzq+jUIJ0KrBFy6bjAmFmB9N9hM0tqsEKMxv1OaphI6QDF6
        OT5KybP8VhKVTySj65IewSj8B7Gc8v9m2DAn/SpU/vfFuxJQYqsvWe4RcyM1NMbD
        GwuHLrrtqxX6OZwkyhLeMr2m9rrPeY94j877pwdRHk1QtLU545x5Z8a7ZNC+RjD2
        h3YK0o8H+z+j2DmDMzp7UzJ08MpiqzR6+w/4K4pnsIVgGZa+mufPBQjV+n6pClrA
        AJbnf+JQtZam6OVt6MvVoNOXL17pi+ZHyFAWRqDYwlV+EWu0IyzmTqT1vDyO6apA
        ==
X-ME-Sender: <xms:KOEPXXLxpI8Vtpx7X61xeN0BwvAuSrt7V4iB6wtObTpy-4RrwlVx5Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddtgdduheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppedujedvrddutdegrddvgeekrdeggeenucfrrghrrghmpehmrghilhhfrh
    homhepghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepie
X-ME-Proxy: <xmx:KOEPXZXsbUWxN1PSciLSxXSO3AF1CG3WCmwdchhHWtT48O-gX3s60A>
    <xmx:KOEPXWB-JdQhaVeN48xjqYAVAxsYJWBSJ1f2ueM1n5Z_uUv9uydvrQ>
    <xmx:KOEPXUTUYadyxl1fVe3li_RZLTBiPwTRu97xT5agmZhXwFqg3Gaz_A>
    <xmx:KOEPXZayTKyS9KQvYvaya0Lp21y3JUndqRCTpwrea0yYn6-cII9PYA>
Received: from localhost (li1825-44.members.linode.com [172.104.248.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id A19BA380079;
        Sun, 23 Jun 2019 16:29:24 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: arm64: Filter out invalid core register IDs in" failed to apply to 4.9-stable tree
To:     Dave.Martin@arm.com, drjones@redhat.com, marc.zyngier@arm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Jun 2019 22:28:20 +0200
Message-ID: <1561321700234212@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From df205b5c63281e4f32caac22adda18fd68795e80 Mon Sep 17 00:00:00 2001
From: Dave Martin <Dave.Martin@arm.com>
Date: Wed, 12 Jun 2019 13:44:49 +0100
Subject: [PATCH] KVM: arm64: Filter out invalid core register IDs in
 KVM_GET_REG_LIST

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
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index ae734fcfd4ea..c8aa00179363 100644
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
 
@@ -447,19 +459,34 @@ static int copy_core_reg_indices(const struct kvm_vcpu *vcpu,
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

