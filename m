Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDE6619C9BA
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388822AbgDBTRH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:17:07 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40076 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388761AbgDBTRH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:17:07 -0400
Received: by mail-wr1-f65.google.com with SMTP id s8so3459840wrt.7
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=BeyLphkFLnP4CTEflF/utnlR8G5qa5q59+49c7r8kS0=;
        b=H9rIX5St6Cpc0s13sla67hTjy0gu9/KMBi9l9yyxjUWgyVd+RkKIVUiQ6r6xdWTewq
         AHGJ9M5wOC681pQIAiewupxW6poqX5IKF+o7LQUKondRb8PmlaWzexY5vPP1VYcLix8N
         XsAXVOLxlD/4npfDf6ZiOLb8ds5m0DWuaGPg4HaPYZf+BTGijTGIM1OoOU/sK+K3xNTp
         jyUu3Ey0nBlIuKgGWSdcmiWttD7OO9GBpFjuAkemJSVjnbDKAk0dqgFwRQvHN2Yki5DX
         fwqRVsvPmV85lDHOIpBpPao0ZzTrkMmr5dZgVrqQNOv7yUu/4HWdVVIiebk93Nw3IZGs
         EaiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BeyLphkFLnP4CTEflF/utnlR8G5qa5q59+49c7r8kS0=;
        b=GJUDqXqmuH0JC5gVYq+BTK6zjcL//rk4outw5vwRu5SHQkRLMEZ7Jww/pQ0qnFOM8Z
         D/h9nX8RJ5Nojtr0GsjzUiUC15WWQgYuRoxKfMGsK/KWWGVdiFpxFe2DD6Wm/CPQQdf9
         HESg3G/GTWHIvdNrqQsZ5CTjUjlxTJPJiCysX0CJh+EIRzx4018PB7kAljuGof++4fL9
         /pna/rVhYKTh+LNAowoXvn9pE/kyz/2MXyV9pLbBINTmKRa5GU74EUFb85cqdkvies/B
         /QZkttD9l4GOCQsHeoSHTi9FNgxQSuVaWSKHUbmwqtkgdKWiiPOguIuf5x2c81cQw/BK
         yQlA==
X-Gm-Message-State: AGi0PuZsEHJYOAgnfAPCh09KJ1FCe+5Vx0muH38lufWrLlyOZPsQUjq3
        t6SitcKyw4ikDFvVPCiFAoaytDAHAhb51Q==
X-Google-Smtp-Source: APiQypIAyytBz78o0nSdrTAMzff/UMtf/Rwh17hChZaTZhUjbZj/2N28mduUI1BbqhNyOTEE1MZ3sQ==
X-Received: by 2002:adf:ff81:: with SMTP id j1mr4880611wrr.171.1585855023297;
        Thu, 02 Apr 2020 12:17:03 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id y1sm879050wmd.14.2020.04.02.12.17.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:17:02 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.9 09/24] arm64: traps: Don't print stack or raw PC/LR values in backtraces
Date:   Thu,  2 Apr 2020 20:17:32 +0100
Message-Id: <20200402191747.789097-9-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191747.789097-1-lee.jones@linaro.org>
References: <20200402191747.789097-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

[ Upstream commit a25ffd3a6302a67814280274d8f1aa4ae2ea4b59 ]

Printing raw pointer values in backtraces has potential security
implications and are of questionable value anyway.

This patch follows x86's lead and removes the "Exception stack:" dump
from kernel backtraces, as well as converting PC/LR values to symbols
such as "sysrq_handle_crash+0x20/0x30".

Tested-by: Laura Abbott <labbott@redhat.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm64/kernel/process.c |  8 ++--
 arch/arm64/kernel/traps.c   | 74 ++-----------------------------------
 2 files changed, 6 insertions(+), 76 deletions(-)

diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index e917d119490ce..6b073a31eec1c 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -182,11 +182,9 @@ void __show_regs(struct pt_regs *regs)
 	}
 
 	show_regs_print_info(KERN_DEFAULT);
-	print_symbol("PC is at %s\n", instruction_pointer(regs));
-	print_symbol("LR is at %s\n", lr);
-	printk("pc : [<%016llx>] lr : [<%016llx>] pstate: %08llx\n",
-	       regs->pc, lr, regs->pstate);
-	printk("sp : %016llx\n", sp);
+	print_symbol("pc : %s\n", regs->pc);
+	print_symbol("lr : %s\n", lr);
+	printk("sp : %016llx pstate : %08llx\n", sp, regs->pstate);
 
 	i = top_reg;
 
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index 5962badb33462..ac73d8d8cd81d 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -52,55 +52,9 @@ static const char *handler[]= {
 
 int show_unhandled_signals = 0;
 
-/*
- * Dump out the contents of some kernel memory nicely...
- */
-static void dump_mem(const char *lvl, const char *str, unsigned long bottom,
-		     unsigned long top)
-{
-	unsigned long first;
-	mm_segment_t fs;
-	int i;
-
-	/*
-	 * We need to switch to kernel mode so that we can use __get_user
-	 * to safely read from kernel space.
-	 */
-	fs = get_fs();
-	set_fs(KERNEL_DS);
-
-	printk("%s%s(0x%016lx to 0x%016lx)\n", lvl, str, bottom, top);
-
-	for (first = bottom & ~31; first < top; first += 32) {
-		unsigned long p;
-		char str[sizeof(" 12345678") * 8 + 1];
-
-		memset(str, ' ', sizeof(str));
-		str[sizeof(str) - 1] = '\0';
-
-		for (p = first, i = 0; i < (32 / 8)
-					&& p < top; i++, p += 8) {
-			if (p >= bottom && p < top) {
-				unsigned long val;
-
-				if (__get_user(val, (unsigned long *)p) == 0)
-					sprintf(str + i * 17, " %016lx", val);
-				else
-					sprintf(str + i * 17, " ????????????????");
-			}
-		}
-		printk("%s%04lx:%s\n", lvl, first & 0xffff, str);
-	}
-
-	set_fs(fs);
-}
-
 static void dump_backtrace_entry(unsigned long where)
 {
-	/*
-	 * Note that 'where' can have a physical address, but it's not handled.
-	 */
-	print_ip_sym(where);
+	printk(" %pS\n", (void *)where);
 }
 
 static void __dump_instr(const char *lvl, struct pt_regs *regs)
@@ -174,10 +128,8 @@ static void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk)
 
 	skip = !!regs;
 	printk("Call trace:\n");
-	while (1) {
+	do {
 		unsigned long where = frame.pc;
-		unsigned long stack;
-		int ret;
 
 		/* skip until specified stack frame */
 		if (!skip) {
@@ -193,25 +145,7 @@ static void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk)
 			 */
 			dump_backtrace_entry(regs->pc);
 		}
-		ret = unwind_frame(tsk, &frame);
-		if (ret < 0)
-			break;
-		stack = frame.sp;
-		if (in_exception_text(where)) {
-			/*
-			 * If we switched to the irq_stack before calling this
-			 * exception handler, then the pt_regs will be on the
-			 * task stack. The easiest way to tell is if the large
-			 * pt_regs would overlap with the end of the irq_stack.
-			 */
-			if (stack < irq_stack_ptr &&
-			    (stack + sizeof(struct pt_regs)) > irq_stack_ptr)
-				stack = IRQ_STACK_TO_TASK_STACK(irq_stack_ptr);
-
-			dump_mem("", "Exception stack", stack,
-				 stack + sizeof(struct pt_regs));
-		}
-	}
+	} while (!unwind_frame(tsk, &frame));
 }
 
 void show_stack(struct task_struct *tsk, unsigned long *sp)
@@ -248,8 +182,6 @@ static int __die(const char *str, int err, struct thread_info *thread,
 		 TASK_COMM_LEN, tsk->comm, task_pid_nr(tsk), thread + 1);
 
 	if (!user_mode(regs)) {
-		dump_mem(KERN_EMERG, "Stack: ", regs->sp,
-			 THREAD_SIZE + (unsigned long)task_stack_page(tsk));
 		dump_backtrace(regs, tsk);
 		dump_instr(KERN_EMERG, regs);
 	}
-- 
2.25.1

