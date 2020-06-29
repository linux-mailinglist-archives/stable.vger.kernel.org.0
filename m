Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB3320D837
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729731AbgF2Th0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:37:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:40564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733010AbgF2Tae (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:30:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED972252AD;
        Mon, 29 Jun 2020 15:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445020;
        bh=xpjyD0icNmbQsP4jgq6BMkGAy2DZjKD+QXh3hoMx0oA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jBZ6/bozrn+/rXxUZJ692DqIjmfRF51YtvoDvrTxrEM84QeGBde3sI+J2sYn7b5zt
         f69PolOLZzIfoLuPM4PPgjtorOGCo3IaJEKUYqQPAOjRB9e4K9IACg8VPfcRzTBKpT
         f+YG1f51QogB+AEXzXJiwi8Csxh9WlibxsDkQA+A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiping Ma <jiping.ma2@windriver.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.19 118/131] arm64: perf: Report the PC value in REGS_ABI_32 mode
Date:   Mon, 29 Jun 2020 11:34:49 -0400
Message-Id: <20200629153502.2494656-119-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629153502.2494656-1-sashal@kernel.org>
References: <20200629153502.2494656-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.131-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.131-rc1
X-KernelTest-Deadline: 2020-07-01T15:34+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiping Ma <jiping.ma2@windriver.com>

commit 8dfe804a4031ca6ba3a3efb2048534249b64f3a5 upstream.

A 32-bit perf querying the registers of a compat task using REGS_ABI_32
will receive zeroes from w15, when it expects to find the PC.

Return the PC value for register dwarf register 15 when returning register
values for a compat task to perf.

Cc: <stable@vger.kernel.org>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Jiping Ma <jiping.ma2@windriver.com>
Link: https://lore.kernel.org/r/1589165527-188401-1-git-send-email-jiping.ma2@windriver.com
[will: Shuffled code and added a comment]
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/perf_regs.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kernel/perf_regs.c b/arch/arm64/kernel/perf_regs.c
index 0bbac612146ea..666b225aeb3ad 100644
--- a/arch/arm64/kernel/perf_regs.c
+++ b/arch/arm64/kernel/perf_regs.c
@@ -15,15 +15,34 @@ u64 perf_reg_value(struct pt_regs *regs, int idx)
 		return 0;
 
 	/*
-	 * Compat (i.e. 32 bit) mode:
-	 * - PC has been set in the pt_regs struct in kernel_entry,
-	 * - Handle SP and LR here.
+	 * Our handling of compat tasks (PERF_SAMPLE_REGS_ABI_32) is weird, but
+	 * we're stuck with it for ABI compatability reasons.
+	 *
+	 * For a 32-bit consumer inspecting a 32-bit task, then it will look at
+	 * the first 16 registers (see arch/arm/include/uapi/asm/perf_regs.h).
+	 * These correspond directly to a prefix of the registers saved in our
+	 * 'struct pt_regs', with the exception of the PC, so we copy that down
+	 * (x15 corresponds to SP_hyp in the architecture).
+	 *
+	 * So far, so good.
+	 *
+	 * The oddity arises when a 64-bit consumer looks at a 32-bit task and
+	 * asks for registers beyond PERF_REG_ARM_MAX. In this case, we return
+	 * SP_usr, LR_usr and PC in the positions where the AArch64 SP, LR and
+	 * PC registers would normally live. The initial idea was to allow a
+	 * 64-bit unwinder to unwind a 32-bit task and, although it's not clear
+	 * how well that works in practice, somebody might be relying on it.
+	 *
+	 * At the time we make a sample, we don't know whether the consumer is
+	 * 32-bit or 64-bit, so we have to cater for both possibilities.
 	 */
 	if (compat_user_mode(regs)) {
 		if ((u32)idx == PERF_REG_ARM64_SP)
 			return regs->compat_sp;
 		if ((u32)idx == PERF_REG_ARM64_LR)
 			return regs->compat_lr;
+		if (idx == 15)
+			return regs->pc;
 	}
 
 	if ((u32)idx == PERF_REG_ARM64_SP)
-- 
2.25.1

