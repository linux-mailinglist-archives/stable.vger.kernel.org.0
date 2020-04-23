Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3351B659C
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 22:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726081AbgDWUk2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 16:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbgDWUk2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 16:40:28 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3F69C09B043
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 13:40:27 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id e26so8085998wmk.5
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 13:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vKfw9AfAdJ2YHMBV1ZmU+GPWL5F8lIGFXz5D5eCrsvU=;
        b=YImBtfcq0PAlko0Ad+nVxYzGVzAQD93VK+6nmduYv7zlR1SlswTlkBIGcbi/Fw2QXc
         z+mpWS3G3o6CRfc+ru2DwQKCJr4XSa+KN91dXle8U+BN7PBpR0AywcnD2vEKFasPpZqy
         x4EyBrI37hUQQGJEtuICf+diUF6Q151TJ8sftao5f3d0w0+ioi0P9QPI+NV0QtDu+RZ1
         uMPZ6m83WaVTv/pKtqH+0QE3xgZPvw49nKPI3iC92WA30we/m4+WmPmFKR+G7d1249Hu
         3UHlBPsLWQVJKx9QBX72M+DLE9UPhYS0s1h+hZTDIj66XkOHsj+hCQxui0pnVH2Kri2W
         c7xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vKfw9AfAdJ2YHMBV1ZmU+GPWL5F8lIGFXz5D5eCrsvU=;
        b=kPcwXqvHrqeDM9ntC8t+hWS9Vw9KpqdEXumN4DX7BStP4k/RAYdqiNmN0SReVkf6Fa
         WjNkYJINYPFXvv5rkElCf3XXrFDj44WhsW6xZxCSp1kk+ud3A+kWDU0QgJw3042o0R/2
         9dP9c4zhfAqeL3k/3jTwzxXckDEJO2FNTeWqBpcbnPhdCWafixrrAXNaExTkgcns4g8t
         /V5V5x9RT8sew3Na0ZCg7EsV1zDS1iaFhfklI1XLwnm+acVFQULZumGlE93D+CRNmz0M
         BjKkdEGH9t8E0W/BWE8j+mVRZLtrOmKdSaIseUjsRFM6Qdxs/kTQC25+L7l5itQjOZg0
         efAg==
X-Gm-Message-State: AGi0PuYuYTxepMottBtoB1J4OG+8wYb2aVYKgpHA3D+SFspWPKt1IgOK
        KyjGV9KQDZcejRTrxKPUsbtOHvY+RzQ=
X-Google-Smtp-Source: APiQypIBEOg3BxJe/eLukyBq6aW5bCup8jimw68sZgm3rk72K6y3xbD/TSGNuKcZnTBS6A45sW/jEA==
X-Received: by 2002:a1c:9a81:: with SMTP id c123mr5774079wme.115.1587674426197;
        Thu, 23 Apr 2020 13:40:26 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id u17sm5933726wra.63.2020.04.23.13.40.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2020 13:40:25 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Will Deacon <will.deacon@arm.com>,
        Laura Abbott <labbott@redhat.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.4 07/16] arm64: traps: Don't print stack or raw PC/LR values in backtraces
Date:   Thu, 23 Apr 2020 21:40:05 +0100
Message-Id: <20200423204014.784944-8-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200423204014.784944-1-lee.jones@linaro.org>
References: <20200423204014.784944-1-lee.jones@linaro.org>
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
 arch/arm64/kernel/process.c |  9 +++--
 arch/arm64/kernel/traps.c   | 72 ++-----------------------------------
 2 files changed, 7 insertions(+), 74 deletions(-)

diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 10d6627673cbf..2733b04900d1c 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -180,11 +180,10 @@ void __show_regs(struct pt_regs *regs)
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
+
 	for (i = top_reg; i >= 0; i--) {
 		printk("x%-2d: %016llx ", i, regs->regs[i]);
 		if (i % 2 == 0)
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index 02710f99c1374..0cc78d60dac33 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -51,63 +51,9 @@ static const char *handler[]= {
 
 int show_unhandled_signals = 0;
 
-/*
- * Dump out the contents of some memory nicely...
- */
-static void dump_mem(const char *lvl, const char *str, unsigned long bottom,
-		     unsigned long top, bool compat)
-{
-	unsigned long first;
-	mm_segment_t fs;
-	int i;
-	unsigned int width = compat ? 4 : 8;
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
-		for (p = first, i = 0; i < (32 / width)
-					&& p < top; i++, p += width) {
-			if (p >= bottom && p < top) {
-				unsigned long val;
-
-				if (width == 8) {
-					if (__get_user(val, (unsigned long *)p) == 0)
-						sprintf(str + i * 17, " %016lx", val);
-					else
-						sprintf(str + i * 17, " ????????????????");
-				} else {
-					if (__get_user(val, (unsigned int *)p) == 0)
-						sprintf(str + i * 9, " %08lx", val);
-					else
-						sprintf(str + i * 9, " ????????");
-				}
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
@@ -170,20 +116,11 @@ static void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk)
 	}
 
 	pr_emerg("Call trace:\n");
-	while (1) {
+	do {
 		unsigned long where = frame.pc;
-		unsigned long stack;
-		int ret;
 
 		dump_backtrace_entry(where);
-		ret = unwind_frame(&frame);
-		if (ret < 0)
-			break;
-		stack = frame.sp;
-		if (in_exception_text(where))
-			dump_mem("", "Exception stack", stack,
-				 stack + sizeof(struct pt_regs), false);
-	}
+	} while (!unwind_frame(&frame));
 }
 
 void show_stack(struct task_struct *tsk, unsigned long *sp)
@@ -220,9 +157,6 @@ static int __die(const char *str, int err, struct thread_info *thread,
 		 TASK_COMM_LEN, tsk->comm, task_pid_nr(tsk), thread + 1);
 
 	if (!user_mode(regs) || in_interrupt()) {
-		dump_mem(KERN_EMERG, "Stack: ", regs->sp,
-			 THREAD_SIZE + (unsigned long)task_stack_page(tsk),
-			 compat_user_mode(regs));
 		dump_backtrace(regs, tsk);
 		dump_instr(KERN_EMERG, regs);
 	}
-- 
2.25.1

