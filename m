Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA18C19C9D8
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388795AbgDBTSP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:18:15 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34432 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389416AbgDBTSO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:18:14 -0400
Received: by mail-wr1-f68.google.com with SMTP id 65so5638912wrl.1
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:18:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=vKfw9AfAdJ2YHMBV1ZmU+GPWL5F8lIGFXz5D5eCrsvU=;
        b=ApfhWh+R6ejO4CMFewnmH6gU6zxSSx/WfXMTDfIrCUHVAmtP/GlG0bEBz5CxjkR1V9
         /loUtLOWwGgQkyM3hPUeOyOCFy4y1MaQzw30WjFj/ciUKRyBu9ZfqB9Vg2YfIit+yfmf
         WhKFYnqUxDi9VY3qp/fiRSCB2BO7lgO2qLz1FOwDEbRdOSstJQGk/I+1GKytY7jdpxvH
         vAW6hkEQSJFfI4RdxNZzo4vuxij+vUAV8QbcgbOeKK37zCmhfgVp9CgCXxDQ4hEYQlX2
         QeYGQ8Em1adaJmG23mYEv469CU8vRf1TVSEM59tcsb5aKqSpE9ia17Z+J2jZEpqQkxAx
         /zIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vKfw9AfAdJ2YHMBV1ZmU+GPWL5F8lIGFXz5D5eCrsvU=;
        b=DuFEw70k+uUDKCypuJ9lfXqzs0JmLNY1zxo81wuYTLUVSnHay02GPz0nGr8nP+nqv6
         QqkzzFkTjbmilKYrvV0weu8r/GeTS6TohJAt9EP9d+Hp+JLs55qPTgH8PF43zSDfa8r8
         RplqigJtaP7ryxwteL0g0HmETogJ6GpXmzT6IhYKCTvXWUo64fpMJdR7QJOxlLF04Vg8
         CUIJW37A/3+uXWlU1lXaAlR5O2KSI+lA38Fhp9rTCbZhZfss2cA/xGeondXzSPB1np9H
         N511faHjXlyNw+RUZ/ymIKXLV1xwN5GDvKuTdtVwloeU/5FAMC9KirEMyEqGy/zGKZkL
         nXkQ==
X-Gm-Message-State: AGi0Pua3Wu6gsTZ1JQ8hFMN5aVOAmiwNiSEDmn9kbSfCVaCPiN2RBW6p
        t0Ia9XifIdP1pOzLoMhEUWvtT8PzpKNceQ==
X-Google-Smtp-Source: APiQypIpwWKaEDAKDy0KzpE9Uf6O/6UT0qt/JxSenoW3gGKzt+lg2gY23YHxCAsXwhujqOuhwf7z2Q==
X-Received: by 2002:a5d:61c2:: with SMTP id q2mr5278757wrv.152.1585855091443;
        Thu, 02 Apr 2020 12:18:11 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id l10sm8622707wrq.95.2020.04.02.12.18.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:18:10 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.4 09/20] arm64: traps: Don't print stack or raw PC/LR values in backtraces
Date:   Thu,  2 Apr 2020 20:18:45 +0100
Message-Id: <20200402191856.789622-9-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191856.789622-1-lee.jones@linaro.org>
References: <20200402191856.789622-1-lee.jones@linaro.org>
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

