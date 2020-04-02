Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69C3619C991
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389214AbgDBTNL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:13:11 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39037 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389221AbgDBTNL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:13:11 -0400
Received: by mail-wr1-f65.google.com with SMTP id p10so5578621wrt.6
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:13:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=EHjyrMQsUuQiUgFwWgDuTXyjroZXXjWL+Ehklr4usZQ=;
        b=y0yccAGlYmi6Gi2tDDZNJK+hdlPLjFTjyK7Gicaos7Uy8SclbzCA1ggfwUmwi6GKvf
         1WyazXPVGAjnvrcl13yikAiF52t0CATVlBLfgVljpWzVx4ICqOBKTr3YW4+DzLVlT0yI
         20VgIkqPlTOVmqMjuG16YqsN1MT/JFaWQ3r5Ui/Jn7nQlVt6DQbqTh063b7XYE7k4GAP
         R8SHrhvE6uwndALY+oj+RyDJYenggKDmljfgzXs2ay4eq+j+hH6c8Dq2zG/r9K8bCow7
         OTAMQqozJ0T4g+yp5MaEY0z9fqGUfAzgo5cQFF81LOUIs14pYS3SiXZNPfVGsL6JRYU/
         so2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EHjyrMQsUuQiUgFwWgDuTXyjroZXXjWL+Ehklr4usZQ=;
        b=FDW2OXR9X4BjrxaYK5uJm9BhEErGEXFwdTHFJxE0JWfeUOdW5AspWIWSSqITZbCDKC
         NFj75CfgD1lgZcm34VElUV3FM6HjrgrVOcsf00920UlHsQmA8XpzN02hTPl5mB7FAaTs
         frZ9WeTcd3fwOMO2RupJ0aH3zb7u56FmLZlb2FyXoR409j+ar5tbaYtw1PNvjJhUglbT
         PFMUGhd2yW+/xOYsHeGojZHlNCSwByVyLeznP8LB3srWlIh77MJFTdOi2T9fQZBwjnl7
         JbAL9m6MxzIM1nfs6nxeei8reXgVdmlJAWZ10DXmrDAeZhXIh89tZ6ErNlvrwTxdXDJI
         sftg==
X-Gm-Message-State: AGi0PubQbTLscWFEffPtMFNnxPjbeS12IZ+z3JUzkeOw9V3xY5THhrqy
        X960Hs18QJov1lBQibfNL+tnqMPp8rsQfQ==
X-Google-Smtp-Source: APiQypLWh6M0XkTcXxzfX21ikP3NUPnNeaRcC5s5QCXKKvqe4a2C9dwVFC5dAMGvajDL4iCSkDbo1Q==
X-Received: by 2002:a05:6000:1090:: with SMTP id y16mr4634087wrw.281.1585854788423;
        Thu, 02 Apr 2020 12:13:08 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id y12sm5511514wrn.55.2020.04.02.12.13.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:13:07 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.14 09/33] arm64: traps: Don't print stack or raw PC/LR values in backtraces
Date:   Thu,  2 Apr 2020 20:13:29 +0100
Message-Id: <20200402191353.787836-9-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191353.787836-1-lee.jones@linaro.org>
References: <20200402191353.787836-1-lee.jones@linaro.org>
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
 arch/arm64/kernel/process.c |  8 ++---
 arch/arm64/kernel/traps.c   | 65 ++-----------------------------------
 2 files changed, 6 insertions(+), 67 deletions(-)

diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 243fd247d04e0..4cbf571f428cd 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -186,11 +186,9 @@ void __show_regs(struct pt_regs *regs)
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
index 5ae9c86c30d1d..b30d23431fe11 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -59,55 +59,9 @@ static const char *handler[]= {
 
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
@@ -177,10 +131,7 @@ void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk)
 #endif
 
 	printk("Call trace:\n");
-	while (1) {
-		unsigned long stack;
-		int ret;
-
+	do {
 		/* skip until specified stack frame */
 		if (!skip) {
 			dump_backtrace_entry(frame.pc);
@@ -195,17 +146,7 @@ void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk)
 			 */
 			dump_backtrace_entry(regs->pc);
 		}
-		ret = unwind_frame(tsk, &frame);
-		if (ret < 0)
-			break;
-		if (in_entry_text(frame.pc)) {
-			stack = frame.fp - offsetof(struct pt_regs, stackframe);
-
-			if (on_accessible_stack(tsk, stack))
-				dump_mem("", "Exception stack", stack,
-					 stack + sizeof(struct pt_regs));
-		}
-	}
+	} while (!unwind_frame(tsk, &frame));
 
 	put_task_stack(tsk);
 }
-- 
2.25.1

