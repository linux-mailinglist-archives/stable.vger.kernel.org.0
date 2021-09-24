Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B0E1417494
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345399AbhIXNIb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:08:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:37276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345981AbhIXNFx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 09:05:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE00F61503;
        Fri, 24 Sep 2021 12:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488161;
        bh=+xbIGZgY7gMjXBOIZNlfIM+EXfYh5bbzyqDWqWvkUig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RuuCJ1MixQivLlMW8jDjHaA6Ak5xylFMAucicqRXLpn6HDZ8e9wK6dAeLj+xhTDab
         +qDNiGl4PyhNYW4eO2oCDR8ozew7+oRb1eCiTrH7cdDI/Ouj/ttuyuL+tzzXGCv21s
         3RslV0ucS5BydQlmSOV8Ck3oFLqirNwZimvznB+I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Marco Elver <elver@google.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 068/100] s390/unwind: use current_frame_address() to unwind current task
Date:   Fri, 24 Sep 2021 14:44:17 +0200
Message-Id: <20210924124343.719455996@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124341.214446495@linuxfoundation.org>
References: <20210924124341.214446495@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Gorbik <gor@linux.ibm.com>

[ Upstream commit 88b604263f3d6eedae0b1c2c3bbd602d1e2e8775 ]

current_stack_pointer() simply returns current value of %r15. If
current_stack_pointer() caller allocates stack (which is the case in
unwind code) %r15 points to a stack frame allocated for callees, meaning
current_stack_pointer() caller (e.g. stack_trace_save) will end up in
the stacktrace. This is not expected by stack_trace_save*() callers and
causes problems.

current_frame_address() on the other hand returns function stack frame
address, which matches %r15 upon function invocation. Using it in
get_stack_pointer() makes it more aligned with x86 implementation
(according to BACKTRACE_SELF_TEST output) and meets stack_trace_save*()
caller's expectations, notably KCSAN.

Also make sure unwind_start is always inlined.

Reported-by: Nathan Chancellor <nathan@kernel.org>
Suggested-by: Marco Elver <elver@google.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Tested-by: Marco Elver <elver@google.com>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lore.kernel.org/r/patch.git-04dd26be3043.your-ad-here.call-01630504868-ext-6188@work.hours
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/stacktrace.h | 20 ++++++++++----------
 arch/s390/include/asm/unwind.h     |  8 ++++----
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/s390/include/asm/stacktrace.h b/arch/s390/include/asm/stacktrace.h
index 3d8a4b94c620..dd00d98804ec 100644
--- a/arch/s390/include/asm/stacktrace.h
+++ b/arch/s390/include/asm/stacktrace.h
@@ -34,16 +34,6 @@ static inline bool on_stack(struct stack_info *info,
 	return addr >= info->begin && addr + len <= info->end;
 }
 
-static __always_inline unsigned long get_stack_pointer(struct task_struct *task,
-						       struct pt_regs *regs)
-{
-	if (regs)
-		return (unsigned long) kernel_stack_pointer(regs);
-	if (task == current)
-		return current_stack_pointer();
-	return (unsigned long) task->thread.ksp;
-}
-
 /*
  * Stack layout of a C stack frame.
  */
@@ -74,6 +64,16 @@ struct stack_frame {
 	((unsigned long)__builtin_frame_address(0) -			\
 	 offsetof(struct stack_frame, back_chain))
 
+static __always_inline unsigned long get_stack_pointer(struct task_struct *task,
+						       struct pt_regs *regs)
+{
+	if (regs)
+		return (unsigned long)kernel_stack_pointer(regs);
+	if (task == current)
+		return current_frame_address();
+	return (unsigned long)task->thread.ksp;
+}
+
 /*
  * To keep this simple mark register 2-6 as being changed (volatile)
  * by the called function, even though register 6 is saved/nonvolatile.
diff --git a/arch/s390/include/asm/unwind.h b/arch/s390/include/asm/unwind.h
index de9006b0cfeb..5ebf534ef753 100644
--- a/arch/s390/include/asm/unwind.h
+++ b/arch/s390/include/asm/unwind.h
@@ -55,10 +55,10 @@ static inline bool unwind_error(struct unwind_state *state)
 	return state->error;
 }
 
-static inline void unwind_start(struct unwind_state *state,
-				struct task_struct *task,
-				struct pt_regs *regs,
-				unsigned long first_frame)
+static __always_inline void unwind_start(struct unwind_state *state,
+					 struct task_struct *task,
+					 struct pt_regs *regs,
+					 unsigned long first_frame)
 {
 	task = task ?: current;
 	first_frame = first_frame ?: get_stack_pointer(task, regs);
-- 
2.33.0



