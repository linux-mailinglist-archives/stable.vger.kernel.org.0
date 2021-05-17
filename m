Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 449A3382FFA
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238426AbhEQOWg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:22:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:36042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239513AbhEQOUi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:20:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1EEAF6144A;
        Mon, 17 May 2021 14:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260686;
        bh=H/UjSLWe2gKRKNd5bR/1Arj/5DEzJMyIMf14pVzdwN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BNJpKld1HKOEGpt8aMbZ3yUnHD6II6eRYx6s+oPEPKsI/WIIcIBdWznRblbcHjr2n
         yccFYG9LwMCM89vqjojMu8NlstQDW/BYxrFuDDuuIbWK+wuuUl8m4mJpYxRG9YudN3
         MnfYx4dRKmIelS22I3IAP54bygVkP0geBZmOXG8o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Leo Yan <leo.yan@linaro.org>, Will Deacon <will@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 195/363] arm64: stacktrace: restore terminal records
Date:   Mon, 17 May 2021 16:01:01 +0200
Message-Id: <20210517140309.174909250@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit 8533d5bfad41e74b7dd80d292fd484913cdfb374 ]

We removed the terminal frame records in commit:

   6106e1112cc69a36 ("arm64: remove EL0 exception frame record")

... on the assumption that as we no longer used them to find the pt_regs
at exception boundaries, they were no longer necessary.

However, Leo reports that as an unintended side-effect, this causes
traces which cross secondary_start_kernel to terminate one entry too
late, with a spurious "0" entry.

There are a few ways we could sovle this, but as we're planning to use
terminal records for RELIABLE_STACKTRACE, let's revert the logic change
for now, keeping the update comments and accounting for the changes in
commit:

  3c02600144bdb0a1 ("arm64: stacktrace: Report when we reach the end of the stack")

This is effectively a partial revert of commit:

  6106e1112cc69a36 ("arm64: remove EL0 exception frame record")

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Fixes: 6106e1112cc6 ("arm64: remove EL0 exception frame record")
Reported-by: Leo Yan <leo.yan@linaro.org>
Tested-by: Leo Yan <leo.yan@linaro.org>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Link: https://lore.kernel.org/r/20210429104813.GA33550@C02TD0UTHF1T.local
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/entry.S      |  6 +++---
 arch/arm64/kernel/stacktrace.c | 10 ++++++----
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 6acfc5e6b5e0..9b205744a233 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -263,16 +263,16 @@ alternative_else_nop_endif
 	stp	lr, x21, [sp, #S_LR]
 
 	/*
-	 * For exceptions from EL0, terminate the callchain here.
+	 * For exceptions from EL0, create a terminal frame record.
 	 * For exceptions from EL1, create a synthetic frame record so the
 	 * interrupted code shows up in the backtrace.
 	 */
 	.if \el == 0
-	mov	x29, xzr
+	stp	xzr, xzr, [sp, #S_STACKFRAME]
 	.else
 	stp	x29, x22, [sp, #S_STACKFRAME]
-	add	x29, sp, #S_STACKFRAME
 	.endif
+	add	x29, sp, #S_STACKFRAME
 
 #ifdef CONFIG_ARM64_SW_TTBR0_PAN
 alternative_if_not ARM64_HAS_PAN
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index d55bdfb7789c..7032a5f9e624 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -44,10 +44,6 @@ int notrace unwind_frame(struct task_struct *tsk, struct stackframe *frame)
 	unsigned long fp = frame->fp;
 	struct stack_info info;
 
-	/* Terminal record; nothing to unwind */
-	if (!fp)
-		return -ENOENT;
-
 	if (fp & 0xf)
 		return -EINVAL;
 
@@ -108,6 +104,12 @@ int notrace unwind_frame(struct task_struct *tsk, struct stackframe *frame)
 
 	frame->pc = ptrauth_strip_insn_pac(frame->pc);
 
+	/*
+	 * This is a terminal record, so we have finished unwinding.
+	 */
+	if (!frame->fp && !frame->pc)
+		return -ENOENT;
+
 	return 0;
 }
 NOKPROBE_SYMBOL(unwind_frame);
-- 
2.30.2



