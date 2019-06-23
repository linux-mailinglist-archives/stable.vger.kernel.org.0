Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D8FA4FDFC
	for <lists+stable@lfdr.de>; Sun, 23 Jun 2019 22:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbfFWU2y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jun 2019 16:28:54 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:48669 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726290AbfFWU2y (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jun 2019 16:28:54 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 5D85222106;
        Sun, 23 Jun 2019 16:28:53 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 23 Jun 2019 16:28:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=xqY4X+
        GlMMwfID7B1nOZPNNKzDfbK1AVA5jeylOAsIw=; b=MfEUk34ViBo0qIbkkxdzPB
        bR1wWvnMLrquDLe2PFtmhmpAMM9yU+cuVLm3E2EN6wqYwX+sMJjZIW2CAJSQcW9P
        prLn4P6zHg3Suv02WelsZ0bHkiSgUjQsnBUO/Fe7wSn3zrL27eXwHUsXe3BoQUmx
        zTu7LlQmno3nZnYNKUyo2bFUDRzf7pErx9/ohfSQz3G9PCDSIBg/8mqNuwZ+rfaK
        gHSD7ONjFt+sFwwlQkN5diIcjgW2P4IdWevVdOSYVCG4X9ACZAbTzOLY8gOiUDwm
        LD1j0+iFf4J7N3hT4XWWTvwxA+r9Y0LpVLucbFcTlpbZCKcTVqtNHfV8pmWhkIdA
        ==
X-ME-Sender: <xms:BeEPXczvj9HLQ300G20_47PgHY9dWmnqySa0p_asLek4aDUczBW_Cg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddtgdduheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppedujedvrddutdegrddvgeekrdeggeenucfrrghrrghmpehmrghilhhfrh
    homhepghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepge
X-ME-Proxy: <xmx:BeEPXTZk7lbSVOo2neXdmZoigmfDyzEwATfFIzheIsaDNHLHo1-gWA>
    <xmx:BeEPXbzAkYvR6icRkaaa3KpbzyVbe5Umv1nzp0Xn2nR4v0wtV6uTUA>
    <xmx:BeEPXfF2qiSkCFdxMkJxr6jfs0Zpm4Lu1LU93fLF-KwVKaf4P9771g>
    <xmx:BeEPXVfbUjUoKOVJ7d9PuliMsY0pCOyxO7QwgZmtR6GWiHNP57Ulkg>
Received: from localhost (li1825-44.members.linode.com [172.104.248.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 79BBA380076;
        Sun, 23 Jun 2019 16:28:49 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: arm64: Filter out invalid core register IDs in" failed to apply to 5.19-stable tree
To:     Dave.Martin@arm.com, drjones@redhat.com, marc.zyngier@arm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Jun 2019 22:28:18 +0200
Message-ID: <15613216982252@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.19-stable tree.
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

