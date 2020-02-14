Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 590A315EC70
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390325AbgBNR1Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:27:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:60266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390907AbgBNQIX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:08:23 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CBA024685;
        Fri, 14 Feb 2020 16:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696503;
        bh=2PP+fPd+ZacIsgZN2bDcTOTTRzSnumjZn67dvgY/+0c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OfbR7KjH0JKLopCbBk1iiDBrROo8DRjkqMs9dRqhyVTD++QS3UBotZUA+MFNqcvzC
         F+NpG0MGopgc2xmvehrJlrxeGh4vVdIPVUYI2B+ZVim9aauBVleLVczAu8d2jC7JK0
         NEh/dSPck2KHlzOsgf1v+5HlDjsglYiMQDB0VX1k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 306/459] arm64: ptrace: nofpsimd: Fail FP/SIMD regset operations
Date:   Fri, 14 Feb 2020 10:59:16 -0500
Message-Id: <20200214160149.11681-306-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

[ Upstream commit c9d66999f064947e6b577ceacc1eb2fbca6a8d3c ]

When fp/simd is not supported on the system, fail the operations
of FP/SIMD regsets.

Fixes: 82e0191a1aa11abf ("arm64: Support systems without FP/ASIMD")
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/ptrace.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index 21176d02e21a1..9168c4f1a37f1 100644
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
-- 
2.20.1

