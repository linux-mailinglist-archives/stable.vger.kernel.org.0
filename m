Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFC7D15DA82
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 16:19:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729475AbgBNPTu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:19:50 -0500
Received: from foss.arm.com ([217.140.110.172]:34294 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729380AbgBNPTu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:19:50 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 89849328;
        Fri, 14 Feb 2020 07:19:49 -0800 (PST)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 1E8D43F68E;
        Fri, 14 Feb 2020 07:19:48 -0800 (PST)
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, ard.biesheuvel@linaro.org,
        catalin.marinas@arm.com, mark.rutland@arm.com, maz@kernel.org,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>
Subject: [stable 4.14 PATCH 2/3] arm64: ptrace: nofpsimd: Fail FP/SIMD regset operations
Date:   Fri, 14 Feb 2020 15:19:36 +0000
Message-Id: <20200214151937.1950083-2-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200214151937.1950083-1-suzuki.poulose@arm.com>
References: <20200214151937.1950083-1-suzuki.poulose@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit c9d66999f064947e6b577ceacc1eb2fbca6a8d3c upstream

When fp/simd is not supported on the system, fail the operations
of FP/SIMD regsets.

Cc: stable@vger.kernel.org # v4.14
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/kernel/ptrace.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index 242527f29c41..e230b4dff960 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -624,6 +624,13 @@ static int gpr_set(struct task_struct *target, const struct user_regset *regset,
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
@@ -634,6 +641,9 @@ static int fpr_get(struct task_struct *target, const struct user_regset *regset,
 	struct user_fpsimd_state *uregs;
 	uregs = &target->thread.fpsimd_state.user_fpsimd;
 
+	if (!system_supports_fpsimd())
+		return -EINVAL;
+
 	if (target == current)
 		fpsimd_preserve_current_state();
 
@@ -648,6 +658,9 @@ static int fpr_set(struct task_struct *target, const struct user_regset *regset,
 	struct user_fpsimd_state newstate =
 		target->thread.fpsimd_state.user_fpsimd;
 
+	if (!system_supports_fpsimd())
+		return -EINVAL;
+
 	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, &newstate, 0, -1);
 	if (ret)
 		return ret;
@@ -740,6 +753,7 @@ static const struct user_regset aarch64_regsets[] = {
 		 */
 		.size = sizeof(u32),
 		.align = sizeof(u32),
+		.active = fpr_active,
 		.get = fpr_get,
 		.set = fpr_set
 	},
@@ -914,6 +928,9 @@ static int compat_vfp_get(struct task_struct *target,
 	compat_ulong_t fpscr;
 	int ret, vregs_end_pos;
 
+	if (!system_supports_fpsimd())
+		return -EINVAL;
+
 	uregs = &target->thread.fpsimd_state.user_fpsimd;
 
 	if (target == current)
@@ -947,6 +964,9 @@ static int compat_vfp_set(struct task_struct *target,
 	compat_ulong_t fpscr;
 	int ret, vregs_end_pos;
 
+	if (!system_supports_fpsimd())
+		return -EINVAL;
+
 	uregs = &target->thread.fpsimd_state.user_fpsimd;
 
 	vregs_end_pos = VFP_STATE_SIZE - sizeof(compat_ulong_t);
@@ -1004,6 +1024,7 @@ static const struct user_regset aarch32_regsets[] = {
 		.n = VFP_STATE_SIZE / sizeof(compat_ulong_t),
 		.size = sizeof(compat_ulong_t),
 		.align = sizeof(compat_ulong_t),
+		.active = fpr_active,
 		.get = compat_vfp_get,
 		.set = compat_vfp_set
 	},
-- 
2.24.1

