Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10EBF260188
	for <lists+stable@lfdr.de>; Mon,  7 Sep 2020 19:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730722AbgIGRGx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Sep 2020 13:06:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:46650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730536AbgIGQcw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Sep 2020 12:32:52 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CEB7208C7;
        Mon,  7 Sep 2020 16:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599496372;
        bh=gcI9M0cKFhQZxep1ek1FT+mVnZX+a0Y8DyH3bsT0iBw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uK7zvffNGr+E94dUXnqd21G7FOslJOK9vw8CtZPgEvp5CH2uox2lMQXlJroyw4dEF
         i6bh/DSugnf0Pa1bbvYmlCgI1fWueDuU1niZpStljcu4PgIp+6N8mEAke8dybqL4c6
         kFPbnC4T91UtbwQklGMGzAFhYUZiSl+2wS4Xb6/g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vineet Gupta <vgupta@synopsys.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-snps-arc@lists.infradead.org
Subject: [PATCH AUTOSEL 5.8 24/53] ARC: show_regs: fix r12 printing and simplify
Date:   Mon,  7 Sep 2020 12:31:50 -0400
Message-Id: <20200907163220.1280412-24-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200907163220.1280412-1-sashal@kernel.org>
References: <20200907163220.1280412-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vineet Gupta <vgupta@synopsys.com>

[ Upstream commit e5c388b4b967037a0e00b60194b0dbcf94881a9b ]

when working on ARC64, spotted an issue in ARCv2 reg file printing.
print_reg_file() assumes contiguous reg-file whereas in ARCv2 they are
not: r12 comes before r0-r11 due to hardware auto-save. Apparently this
issue has been present since v2 port submission.

To avoid bolting hacks for this discontinuity while looping through
pt_regs, just ditching the loop and print pt_regs directly.

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arc/kernel/troubleshoot.c | 77 +++++++++++++---------------------
 1 file changed, 30 insertions(+), 47 deletions(-)

diff --git a/arch/arc/kernel/troubleshoot.c b/arch/arc/kernel/troubleshoot.c
index 28e8bf04b253f..a331bb5d8319f 100644
--- a/arch/arc/kernel/troubleshoot.c
+++ b/arch/arc/kernel/troubleshoot.c
@@ -18,44 +18,37 @@
 
 #define ARC_PATH_MAX	256
 
-/*
- * Common routine to print scratch regs (r0-r12) or callee regs (r13-r25)
- *   -Prints 3 regs per line and a CR.
- *   -To continue, callee regs right after scratch, special handling of CR
- */
-static noinline void print_reg_file(long *reg_rev, int start_num)
+static noinline void print_regs_scratch(struct pt_regs *regs)
 {
-	unsigned int i;
-	char buf[512];
-	int n = 0, len = sizeof(buf);
-
-	for (i = start_num; i < start_num + 13; i++) {
-		n += scnprintf(buf + n, len - n, "r%02u: 0x%08lx\t",
-			       i, (unsigned long)*reg_rev);
-
-		if (((i + 1) % 3) == 0)
-			n += scnprintf(buf + n, len - n, "\n");
-
-		/* because pt_regs has regs reversed: r12..r0, r25..r13 */
-		if (is_isa_arcv2() && start_num == 0)
-			reg_rev++;
-		else
-			reg_rev--;
-	}
-
-	if (start_num != 0)
-		n += scnprintf(buf + n, len - n, "\n\n");
+	pr_cont("BTA: 0x%08lx\n SP: 0x%08lx  FP: 0x%08lx BLK: %pS\n",
+		regs->bta, regs->sp, regs->fp, (void *)regs->blink);
+	pr_cont("LPS: 0x%08lx\tLPE: 0x%08lx\tLPC: 0x%08lx\n",
+		regs->lp_start, regs->lp_end, regs->lp_count);
 
-	/* To continue printing callee regs on same line as scratch regs */
-	if (start_num == 0)
-		pr_info("%s", buf);
-	else
-		pr_cont("%s\n", buf);
+	pr_info("r00: 0x%08lx\tr01: 0x%08lx\tr02: 0x%08lx\n"	\
+		"r03: 0x%08lx\tr04: 0x%08lx\tr05: 0x%08lx\n"	\
+		"r06: 0x%08lx\tr07: 0x%08lx\tr08: 0x%08lx\n"	\
+		"r09: 0x%08lx\tr10: 0x%08lx\tr11: 0x%08lx\n"	\
+		"r12: 0x%08lx\t",
+		regs->r0, regs->r1, regs->r2,
+		regs->r3, regs->r4, regs->r5,
+		regs->r6, regs->r7, regs->r8,
+		regs->r9, regs->r10, regs->r11,
+		regs->r12);
 }
 
-static void show_callee_regs(struct callee_regs *cregs)
+static void print_regs_callee(struct callee_regs *regs)
 {
-	print_reg_file(&(cregs->r13), 13);
+	pr_cont("r13: 0x%08lx\tr14: 0x%08lx\n"			\
+		"r15: 0x%08lx\tr16: 0x%08lx\tr17: 0x%08lx\n"	\
+		"r18: 0x%08lx\tr19: 0x%08lx\tr20: 0x%08lx\n"	\
+		"r21: 0x%08lx\tr22: 0x%08lx\tr23: 0x%08lx\n"	\
+		"r24: 0x%08lx\tr25: 0x%08lx\n",
+		regs->r13, regs->r14,
+		regs->r15, regs->r16, regs->r17,
+		regs->r18, regs->r19, regs->r20,
+		regs->r21, regs->r22, regs->r23,
+		regs->r24, regs->r25);
 }
 
 static void print_task_path_n_nm(struct task_struct *tsk)
@@ -175,7 +168,7 @@ static void show_ecr_verbose(struct pt_regs *regs)
 void show_regs(struct pt_regs *regs)
 {
 	struct task_struct *tsk = current;
-	struct callee_regs *cregs;
+	struct callee_regs *cregs = (struct callee_regs *)tsk->thread.callee_reg;
 
 	/*
 	 * generic code calls us with preemption disabled, but some calls
@@ -204,25 +197,15 @@ void show_regs(struct pt_regs *regs)
 			STS_BIT(regs, A2), STS_BIT(regs, A1),
 			STS_BIT(regs, E2), STS_BIT(regs, E1));
 #else
-	pr_cont(" [%2s%2s%2s%2s]",
+	pr_cont(" [%2s%2s%2s%2s]   ",
 			STS_BIT(regs, IE),
 			(regs->status32 & STATUS_U_MASK) ? "U " : "K ",
 			STS_BIT(regs, DE), STS_BIT(regs, AE));
 #endif
-	pr_cont("  BTA: 0x%08lx\n  SP: 0x%08lx  FP: 0x%08lx BLK: %pS\n",
-		regs->bta, regs->sp, regs->fp, (void *)regs->blink);
-	pr_info("LPS: 0x%08lx\tLPE: 0x%08lx\tLPC: 0x%08lx\n",
-		regs->lp_start, regs->lp_end, regs->lp_count);
-
-	/* print regs->r0 thru regs->r12
-	 * Sequential printing was generating horrible code
-	 */
-	print_reg_file(&(regs->r0), 0);
 
-	/* If Callee regs were saved, display them too */
-	cregs = (struct callee_regs *)current->thread.callee_reg;
+	print_regs_scratch(regs);
 	if (cregs)
-		show_callee_regs(cregs);
+		print_regs_callee(cregs);
 
 	preempt_disable();
 }
-- 
2.25.1

