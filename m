Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F51C299EFE
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440976AbgJ0ATZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 20:19:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:58480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394887AbgJ0AJ5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 20:09:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B7CB216FD;
        Tue, 27 Oct 2020 00:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603757396;
        bh=NPhNxzwe1WJS5/TdhHWf3oXhorjRFYxpsns3sKHgz4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B6saDXjao2DuOtBgpVRJS/+CIrEG0+xuI5tuNjLj3DXHK1IP/KYa8vkeYL/DRG1Zi
         vh2LCvPnVuuIKgISIx9CI9hOnlEIi2WjPAY0+vTjLJa+FqUX6tOLTjwpL0NSpu/h9g
         cKmZj9tG1nA8J19hi0iztqLxmJzCu4f/ZhiSIoec=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Douglas Anderson <dianders@chromium.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        Will Deacon <will@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 08/46] ARM: 8997/2: hw_breakpoint: Handle inexact watchpoint addresses
Date:   Mon, 26 Oct 2020 20:09:07 -0400
Message-Id: <20201027000946.1026923-8-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201027000946.1026923-1-sashal@kernel.org>
References: <20201027000946.1026923-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 22c9e58299e5f18274788ce54c03d4fb761e3c5d ]

This is commit fdfeff0f9e3d ("arm64: hw_breakpoint: Handle inexact
watchpoint addresses") but ported to arm32, which has the same
problem.

This problem was found by Android CTS tests, notably the
"watchpoint_imprecise" test [1].  I tested locally against a copycat
(simplified) version of the test though.

[1] https://android.googlesource.com/platform/bionic/+/master/tests/sys_ptrace_test.cpp

Link: https://lkml.kernel.org/r/20191019111216.1.I82eae759ca6dc28a245b043f485ca490e3015321@changeid

Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/kernel/hw_breakpoint.c | 100 +++++++++++++++++++++++---------
 1 file changed, 72 insertions(+), 28 deletions(-)

diff --git a/arch/arm/kernel/hw_breakpoint.c b/arch/arm/kernel/hw_breakpoint.c
index a30f656f791f3..e61697fb7efea 100644
--- a/arch/arm/kernel/hw_breakpoint.c
+++ b/arch/arm/kernel/hw_breakpoint.c
@@ -688,6 +688,40 @@ static void disable_single_step(struct perf_event *bp)
 	arch_install_hw_breakpoint(bp);
 }
 
+/*
+ * Arm32 hardware does not always report a watchpoint hit address that matches
+ * one of the watchpoints set. It can also report an address "near" the
+ * watchpoint if a single instruction access both watched and unwatched
+ * addresses. There is no straight-forward way, short of disassembling the
+ * offending instruction, to map that address back to the watchpoint. This
+ * function computes the distance of the memory access from the watchpoint as a
+ * heuristic for the likelyhood that a given access triggered the watchpoint.
+ *
+ * See this same function in the arm64 platform code, which has the same
+ * problem.
+ *
+ * The function returns the distance of the address from the bytes watched by
+ * the watchpoint. In case of an exact match, it returns 0.
+ */
+static u32 get_distance_from_watchpoint(unsigned long addr, u32 val,
+					struct arch_hw_breakpoint_ctrl *ctrl)
+{
+	u32 wp_low, wp_high;
+	u32 lens, lene;
+
+	lens = __ffs(ctrl->len);
+	lene = __fls(ctrl->len);
+
+	wp_low = val + lens;
+	wp_high = val + lene;
+	if (addr < wp_low)
+		return wp_low - addr;
+	else if (addr > wp_high)
+		return addr - wp_high;
+	else
+		return 0;
+}
+
 static int watchpoint_fault_on_uaccess(struct pt_regs *regs,
 				       struct arch_hw_breakpoint *info)
 {
@@ -697,23 +731,25 @@ static int watchpoint_fault_on_uaccess(struct pt_regs *regs,
 static void watchpoint_handler(unsigned long addr, unsigned int fsr,
 			       struct pt_regs *regs)
 {
-	int i, access;
-	u32 val, ctrl_reg, alignment_mask;
+	int i, access, closest_match = 0;
+	u32 min_dist = -1, dist;
+	u32 val, ctrl_reg;
 	struct perf_event *wp, **slots;
 	struct arch_hw_breakpoint *info;
 	struct arch_hw_breakpoint_ctrl ctrl;
 
 	slots = this_cpu_ptr(wp_on_reg);
 
+	/*
+	 * Find all watchpoints that match the reported address. If no exact
+	 * match is found. Attribute the hit to the closest watchpoint.
+	 */
+	rcu_read_lock();
 	for (i = 0; i < core_num_wrps; ++i) {
-		rcu_read_lock();
-
 		wp = slots[i];
-
 		if (wp == NULL)
-			goto unlock;
+			continue;
 
-		info = counter_arch_bp(wp);
 		/*
 		 * The DFAR is an unknown value on debug architectures prior
 		 * to 7.1. Since we only allow a single watchpoint on these
@@ -722,33 +758,31 @@ static void watchpoint_handler(unsigned long addr, unsigned int fsr,
 		 */
 		if (debug_arch < ARM_DEBUG_ARCH_V7_1) {
 			BUG_ON(i > 0);
+			info = counter_arch_bp(wp);
 			info->trigger = wp->attr.bp_addr;
 		} else {
-			if (info->ctrl.len == ARM_BREAKPOINT_LEN_8)
-				alignment_mask = 0x7;
-			else
-				alignment_mask = 0x3;
-
-			/* Check if the watchpoint value matches. */
-			val = read_wb_reg(ARM_BASE_WVR + i);
-			if (val != (addr & ~alignment_mask))
-				goto unlock;
-
-			/* Possible match, check the byte address select. */
-			ctrl_reg = read_wb_reg(ARM_BASE_WCR + i);
-			decode_ctrl_reg(ctrl_reg, &ctrl);
-			if (!((1 << (addr & alignment_mask)) & ctrl.len))
-				goto unlock;
-
 			/* Check that the access type matches. */
 			if (debug_exception_updates_fsr()) {
 				access = (fsr & ARM_FSR_ACCESS_MASK) ?
 					  HW_BREAKPOINT_W : HW_BREAKPOINT_R;
 				if (!(access & hw_breakpoint_type(wp)))
-					goto unlock;
+					continue;
 			}
 
+			val = read_wb_reg(ARM_BASE_WVR + i);
+			ctrl_reg = read_wb_reg(ARM_BASE_WCR + i);
+			decode_ctrl_reg(ctrl_reg, &ctrl);
+			dist = get_distance_from_watchpoint(addr, val, &ctrl);
+			if (dist < min_dist) {
+				min_dist = dist;
+				closest_match = i;
+			}
+			/* Is this an exact match? */
+			if (dist != 0)
+				continue;
+
 			/* We have a winner. */
+			info = counter_arch_bp(wp);
 			info->trigger = addr;
 		}
 
@@ -770,13 +804,23 @@ static void watchpoint_handler(unsigned long addr, unsigned int fsr,
 		 * we can single-step over the watchpoint trigger.
 		 */
 		if (!is_default_overflow_handler(wp))
-			goto unlock;
-
+			continue;
 step:
 		enable_single_step(wp, instruction_pointer(regs));
-unlock:
-		rcu_read_unlock();
 	}
+
+	if (min_dist > 0 && min_dist != -1) {
+		/* No exact match found. */
+		wp = slots[closest_match];
+		info = counter_arch_bp(wp);
+		info->trigger = addr;
+		pr_debug("watchpoint fired: address = 0x%x\n", info->trigger);
+		perf_bp_event(wp, regs);
+		if (is_default_overflow_handler(wp))
+			enable_single_step(wp, instruction_pointer(regs));
+	}
+
+	rcu_read_unlock();
 }
 
 static void watchpoint_single_step_handler(unsigned long pc)
-- 
2.25.1

