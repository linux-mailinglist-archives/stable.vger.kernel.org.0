Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E012110665E
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:31:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbfKVGaB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 01:30:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:53940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727198AbfKVFtn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:49:43 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8AD02070B;
        Fri, 22 Nov 2019 05:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401782;
        bh=MqOdMBcFN7cKpxoPq7s5s29VjuTXuCthvZFz0pCPqiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yb7yVyexYs61jZHaLuaoNUyj6cksjR08vb6qJgFkhWeJUzz4k/Ic4B39I7DdwiKPP
         Nu642lajGlQM8/v544cPsPwRbLa+Z4HHUAdnDGJd6/1za0m6VubkvasRrGxOxPr8x0
         lhmsbdQ84Cj78LgIsBB67SFQjELqQSQdrTPy4yk8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Will Deacon <will.deacon@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "kernelci.org bot" <bot@kernelci.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 031/219] arm64: preempt: Fix big-endian when checking preempt count in assembly
Date:   Fri, 22 Nov 2019 00:46:03 -0500
Message-Id: <20191122054911.1750-24-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

[ Upstream commit 7faa313f05cad184e8b17750f0cbe5216ac6debb ]

Commit 396244692232 ("arm64: preempt: Provide our own implementation of
asm/preempt.h") extended the preempt count field in struct thread_info
to 64 bits, so that it consists of a 32-bit count plus a 32-bit flag
indicating whether or not the current task needs rescheduling.

Whilst the asm-offsets definition of TSK_TI_PREEMPT was updated to point
to this new field, the assembly usage was left untouched meaning that a
32-bit load from TSK_TI_PREEMPT on a big-endian machine actually returns
the reschedule flag instead of the count.

Whilst we could fix this by pointing TSK_TI_PREEMPT at the count field,
we're actually better off reworking the two assembly users so that they
operate on the whole 64-bit value in favour of inspecting the thread
flags separately in order to determine whether a reschedule is needed.

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Reported-by: "kernelci.org bot" <bot@kernelci.org>
Tested-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/assembler.h | 8 +++-----
 arch/arm64/kernel/entry.S          | 6 ++----
 2 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index 5a97ac8531682..0c100506a29aa 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -683,11 +683,9 @@ USER(\label, ic	ivau, \tmp2)			// invalidate I line PoU
 	.macro		if_will_cond_yield_neon
 #ifdef CONFIG_PREEMPT
 	get_thread_info	x0
-	ldr		w1, [x0, #TSK_TI_PREEMPT]
-	ldr		x0, [x0, #TSK_TI_FLAGS]
-	cmp		w1, #PREEMPT_DISABLE_OFFSET
-	csel		x0, x0, xzr, eq
-	tbnz		x0, #TIF_NEED_RESCHED, .Lyield_\@	// needs rescheduling?
+	ldr		x0, [x0, #TSK_TI_PREEMPT]
+	sub		x0, x0, #PREEMPT_DISABLE_OFFSET
+	cbz		x0, .Lyield_\@
 	/* fall through to endif_yield_neon */
 	.subsection	1
 .Lyield_\@ :
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 5f800384cb9a8..bb68323530458 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -622,10 +622,8 @@ el1_irq:
 	irq_handler
 
 #ifdef CONFIG_PREEMPT
-	ldr	w24, [tsk, #TSK_TI_PREEMPT]	// get preempt count
-	cbnz	w24, 1f				// preempt count != 0
-	ldr	x0, [tsk, #TSK_TI_FLAGS]	// get flags
-	tbz	x0, #TIF_NEED_RESCHED, 1f	// needs rescheduling?
+	ldr	x24, [tsk, #TSK_TI_PREEMPT]	// get preempt count
+	cbnz	x24, 1f				// preempt count != 0
 	bl	el1_preempt
 1:
 #endif
-- 
2.20.1

