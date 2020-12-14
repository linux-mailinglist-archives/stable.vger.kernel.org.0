Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89F882D9FC0
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 19:59:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731702AbgLNS7D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 13:59:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:46996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502244AbgLNRhh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:37:37 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vineet Gupta <vgupta@synopsys.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 048/105] ARC: stack unwinding: dont assume non-current task is sleeping
Date:   Mon, 14 Dec 2020 18:28:22 +0100
Message-Id: <20201214172557.592913321@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214172555.280929671@linuxfoundation.org>
References: <20201214172555.280929671@linuxfoundation.org>
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
index b23986f984509..b2557f581ea8c 100644
--- a/arch/arc/kernel/stacktrace.c
+++ b/arch/arc/kernel/stacktrace.c
@@ -38,15 +38,15 @@
 
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
 
@@ -65,11 +65,15 @@ static void seed_unwind_frame_info(struct task_struct *tsk,
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
@@ -103,6 +107,8 @@ static void seed_unwind_frame_info(struct task_struct *tsk,
 		frame_info->regs.r63 = regs->ret;
 		frame_info->call_frame = 0;
 	}
+
+	return 0;
 }
 
 #endif
@@ -116,7 +122,8 @@ arc_unwind_core(struct task_struct *tsk, struct pt_regs *regs,
 	unsigned int address;
 	struct unwind_frame_info frame_info;
 
-	seed_unwind_frame_info(tsk, regs, &frame_info);
+	if (seed_unwind_frame_info(tsk, regs, &frame_info))
+		return 0;
 
 	while (1) {
 		address = UNW_PC(&frame_info);
-- 
2.27.0



