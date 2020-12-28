Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66FEC2E68AC
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729328AbgL1Qjw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:39:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:56074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729189AbgL1M7y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 07:59:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B677D22583;
        Mon, 28 Dec 2020 12:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160353;
        bh=4RVsrHt+swWkgwGUunNrBplzgzeOI/Zp42aT6hjTzQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x7kN5M8vm/ZWk20t3ZUehIJNL7HgnyLgYEAtFg/5GdjNM7Fb9Trj1UQBaDGdMqKyC
         hKwD8VahcbrR7viq19ofAzkVy3UGNSOePCrHmst0yEsPx73sZascJ1X/SJDGV0BL1i
         6/LLMmJKRzSZo6//MftwQYZLi3jnFp6vardjBwiU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vineet Gupta <vgupta@synopsys.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 005/175] ARC: stack unwinding: dont assume non-current task is sleeping
Date:   Mon, 28 Dec 2020 13:47:38 +0100
Message-Id: <20201228124853.506539508@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vineet Gupta <vgupta@synopsys.com>

[ Upstream commit e42404fa10fd11fe72d0a0e149a321d10e577715 ]

To start stack unwinding (SP, PC and BLINK) are needed. When the
explicit execution context (pt_regs etc) is not available, unwinder
assumes the task is sleeping (in __switch_to()) and fetches SP and BLINK
from kernel mode stack.

But this assumption is not true, specially in a SMP system, when top
runs on 1 core, there may be active running processes on all cores.

So when unwinding non courrent tasks, ensure they are NOT running.

And while at it, handle the self unwinding case explicitly.

This came out of investigation of a customer reported hang with
rcutorture+top

Link: https://github.com/foss-for-synopsys-dwc-arc-processors/linux/issues/31
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arc/kernel/stacktrace.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/arch/arc/kernel/stacktrace.c b/arch/arc/kernel/stacktrace.c
index 165158735aa6b..3ee19b1e79be5 100644
--- a/arch/arc/kernel/stacktrace.c
+++ b/arch/arc/kernel/stacktrace.c
@@ -39,15 +39,15 @@
 
 #ifdef CONFIG_ARC_DW2_UNWIND
 
-static void seed_unwind_frame_info(struct task_struct *tsk,
-				   struct pt_regs *regs,
-				   struct unwind_frame_info *frame_info)
+static int
+seed_unwind_frame_info(struct task_struct *tsk, struct pt_regs *regs,
+		       struct unwind_frame_info *frame_info)
 {
 	/*
 	 * synchronous unwinding (e.g. dump_stack)
 	 *  - uses current values of SP and friends
 	 */
-	if (tsk == NULL && regs == NULL) {
+	if (regs == NULL && (tsk == NULL || tsk == current)) {
 		unsigned long fp, sp, blink, ret;
 		frame_info->task = current;
 
@@ -66,11 +66,15 @@ static void seed_unwind_frame_info(struct task_struct *tsk,
 		frame_info->call_frame = 0;
 	} else if (regs == NULL) {
 		/*
-		 * Asynchronous unwinding of sleeping task
-		 *  - Gets SP etc from task's pt_regs (saved bottom of kernel
-		 *    mode stack of task)
+		 * Asynchronous unwinding of a likely sleeping task
+		 *  - first ensure it is actually sleeping
+		 *  - if so, it will be in __switch_to, kernel mode SP of task
+		 *    is safe-kept and BLINK at a well known location in there
 		 */
 
+		if (tsk->state == TASK_RUNNING)
+			return -1;
+
 		frame_info->task = tsk;
 
 		frame_info->regs.r27 = TSK_K_FP(tsk);
@@ -104,6 +108,8 @@ static void seed_unwind_frame_info(struct task_struct *tsk,
 		frame_info->regs.r63 = regs->ret;
 		frame_info->call_frame = 0;
 	}
+
+	return 0;
 }
 
 #endif
@@ -117,7 +123,8 @@ arc_unwind_core(struct task_struct *tsk, struct pt_regs *regs,
 	unsigned int address;
 	struct unwind_frame_info frame_info;
 
-	seed_unwind_frame_info(tsk, regs, &frame_info);
+	if (seed_unwind_frame_info(tsk, regs, &frame_info))
+		return 0;
 
 	while (1) {
 		address = UNW_PC(&frame_info);
-- 
2.27.0



