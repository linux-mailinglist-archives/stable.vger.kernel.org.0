Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAC8F15B862
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 05:14:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729538AbgBMENa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Feb 2020 23:13:30 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:42937 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729440AbgBMENa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Feb 2020 23:13:30 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 03F4021F34;
        Wed, 12 Feb 2020 23:13:30 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 12 Feb 2020 23:13:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ueBmcW
        ML6giUOBss6tCn8ywE+OMR6jQJqLUk4dc2hnA=; b=K/zV58sb4APq4uuVoaZFDT
        HN7AR0ayRjaH2OWMRYURwULgI2YvK9TRnyh5exs2ctY1oZRbzJkQdHMhAKh5XODU
        0xZYxJDxm4FXlxsReANFi18wcZojEjhNoUuFtpouHrmRoeXy6HSnw3rcE2qrbTPA
        UxoBImxul0ybKNyERcIInZsy7gBvt2Xl69nUf+M9+iLnEmnNXV9S7fC6uFQLzz6F
        SdIIP3paAwi0aeJvxHfP8y4wQHKeF6E4RxjrWX4WEuEhvAJHo7xjwJUAGNSlT574
        /Fqe4BCt2i7ap/2BLuGjiFE0ltDuUIyZjIN/8lpo3JxNqN4/FZVNnTPREkQr0s/g
        ==
X-ME-Sender: <xms:6cxEXm8sAV7A5QKvBWLYFvtWkjdyrmRcxyB3BSjenzl8gsbJRp2PIA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrieejgdejtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepvddtledrfeejrdeljedrudelgeenucevlhhushhtvghrufhiiigvpedvne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:6cxEXnUVo60VzoLQKB6se0XFCDfXtE3Mf2E0bUjTCMa2aK3Zocq3Pg>
    <xmx:6cxEXnIQJQg_49JE8VMIiLX41ZyC3DRzqyKVt5oIsQ62rwEpRLoU9A>
    <xmx:6cxEXjB3UeQq8m43SryJeLw3JiDwmACou1Q0w5RDSr5dinjl_Q4IGA>
    <xmx:6cxEXuDcva_drpKys3IZRILgUY7dORn73f_jqCJDRQ1vA4oPgh_MIw>
Received: from localhost (unknown [209.37.97.194])
        by mail.messagingengine.com (Postfix) with ESMTPA id A1D133280060;
        Wed, 12 Feb 2020 23:13:29 -0500 (EST)
Subject: FAILED: patch "[PATCH] arm64: ptrace: nofpsimd: Fail FP/SIMD regset operations" failed to apply to 4.14-stable tree
To:     suzuki.poulose@arm.com, ardb@kernel.org, catalin.marinas@arm.com,
        mark.rutland@arm.com, will@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 Feb 2020 20:13:28 -0800
Message-ID: <158156720821102@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c9d66999f064947e6b577ceacc1eb2fbca6a8d3c Mon Sep 17 00:00:00 2001
From: Suzuki K Poulose <suzuki.poulose@arm.com>
Date: Mon, 13 Jan 2020 23:30:21 +0000
Subject: [PATCH] arm64: ptrace: nofpsimd: Fail FP/SIMD regset operations

When fp/simd is not supported on the system, fail the operations
of FP/SIMD regsets.

Fixes: 82e0191a1aa11abf ("arm64: Support systems without FP/ASIMD")
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>

diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index 6771c399d40c..cd6e5fa48b9c 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -615,6 +615,13 @@ static int gpr_set(struct task_struct *target, const struct user_regset *regset,
 	return 0;
 }
 
+static int fpr_active(struct task_struct *target, const struct user_regset *regset)
+{
+	if (!system_supports_fpsimd())
+		return -ENODEV;
+	return regset->n;
+}
+
 /*
  * TODO: update fp accessors for lazy context switching (sync/flush hwstate)
  */
@@ -637,6 +644,9 @@ static int fpr_get(struct task_struct *target, const struct user_regset *regset,
 		   unsigned int pos, unsigned int count,
 		   void *kbuf, void __user *ubuf)
 {
+	if (!system_supports_fpsimd())
+		return -EINVAL;
+
 	if (target == current)
 		fpsimd_preserve_current_state();
 
@@ -676,6 +686,9 @@ static int fpr_set(struct task_struct *target, const struct user_regset *regset,
 {
 	int ret;
 
+	if (!system_supports_fpsimd())
+		return -EINVAL;
+
 	ret = __fpr_set(target, regset, pos, count, kbuf, ubuf, 0);
 	if (ret)
 		return ret;
@@ -1134,6 +1147,7 @@ static const struct user_regset aarch64_regsets[] = {
 		 */
 		.size = sizeof(u32),
 		.align = sizeof(u32),
+		.active = fpr_active,
 		.get = fpr_get,
 		.set = fpr_set
 	},
@@ -1348,6 +1362,9 @@ static int compat_vfp_get(struct task_struct *target,
 	compat_ulong_t fpscr;
 	int ret, vregs_end_pos;
 
+	if (!system_supports_fpsimd())
+		return -EINVAL;
+
 	uregs = &target->thread.uw.fpsimd_state;
 
 	if (target == current)
@@ -1381,6 +1398,9 @@ static int compat_vfp_set(struct task_struct *target,
 	compat_ulong_t fpscr;
 	int ret, vregs_end_pos;
 
+	if (!system_supports_fpsimd())
+		return -EINVAL;
+
 	uregs = &target->thread.uw.fpsimd_state;
 
 	vregs_end_pos = VFP_STATE_SIZE - sizeof(compat_ulong_t);
@@ -1438,6 +1458,7 @@ static const struct user_regset aarch32_regsets[] = {
 		.n = VFP_STATE_SIZE / sizeof(compat_ulong_t),
 		.size = sizeof(compat_ulong_t),
 		.align = sizeof(compat_ulong_t),
+		.active = fpr_active,
 		.get = compat_vfp_get,
 		.set = compat_vfp_set
 	},

