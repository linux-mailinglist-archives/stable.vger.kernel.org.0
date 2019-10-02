Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7385FC91BD
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 21:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729193AbfJBTLe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Oct 2019 15:11:34 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35612 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729214AbfJBTIM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Oct 2019 15:08:12 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjyr-00036H-Pg; Wed, 02 Oct 2019 20:08:09 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjyo-0003eG-RI; Wed, 02 Oct 2019 20:08:06 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Marc Zyngier" <marc.zyngier@arm.com>,
        "Dave Martin" <Dave.Martin@arm.com>,
        "Andrew Jones" <drjones@redhat.com>
Date:   Wed, 02 Oct 2019 20:06:51 +0100
Message-ID: <lsq.1570043211.182854195@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 55/87] KVM: arm64: Filter out invalid core register
 IDs in KVM_GET_REG_LIST
In-Reply-To: <lsq.1570043210.379046399@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.75-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Martin <Dave.Martin@arm.com>

commit df205b5c63281e4f32caac22adda18fd68795e80 upstream.

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

Fixes: d26c25a9d19b ("arm64: KVM: Tighten guest core register access from userspace")
Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Tested-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
[bwh: Backported to 3.16:
 - Don't add unused vcpu parameter
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -46,9 +46,8 @@ static u64 core_reg_offset_from_id(u64 i
 	return id & ~(KVM_REG_ARCH_MASK | KVM_REG_SIZE_MASK | KVM_REG_ARM_CORE);
 }
 
-static int validate_core_offset(const struct kvm_one_reg *reg)
+static int core_reg_size_from_offset(u64 off)
 {
-	u64 off = core_reg_offset_from_id(reg->id);
 	int size;
 
 	switch (off) {
@@ -78,13 +77,26 @@ static int validate_core_offset(const st
 		return -EINVAL;
 	}
 
-	if (KVM_REG_SIZE(reg->id) == size &&
-	    IS_ALIGNED(off, size / sizeof(__u32)))
-		return 0;
+	if (IS_ALIGNED(off, size / sizeof(__u32)))
+		return size;
 
 	return -EINVAL;
 }
 
+static int validate_core_offset(const struct kvm_one_reg *reg)
+{
+	u64 off = core_reg_offset_from_id(reg->id);
+	int size = core_reg_size_from_offset(off);
+
+	if (size < 0)
+		return -EINVAL;
+
+	if (KVM_REG_SIZE(reg->id) != size)
+		return -EINVAL;
+
+	return 0;
+}
+
 static int get_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 {
 	/*
@@ -197,10 +209,33 @@ unsigned long kvm_arm_num_regs(struct kv
 int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 {
 	unsigned int i;
-	const u64 core_reg = KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE;
 
 	for (i = 0; i < sizeof(struct kvm_regs) / sizeof(__u32); i++) {
-		if (put_user(core_reg | i, uindices))
+		u64 reg = KVM_REG_ARM64 | KVM_REG_ARM_CORE | i;
+		int size = core_reg_size_from_offset(i);
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
+			continue;
+		}
+
+		if (put_user(reg, uindices))
 			return -EFAULT;
 		uindices++;
 	}

