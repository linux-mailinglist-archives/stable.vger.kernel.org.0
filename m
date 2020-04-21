Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA8E1B2658
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 14:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728890AbgDUMkx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 08:40:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728874AbgDUMkw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 08:40:52 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20725C061A10
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 05:40:52 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id y24so3495610wma.4
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 05:40:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m+/aHHzA7P1xYHmkYaS5NJbgJVCxVABFSZYdM1niH8Q=;
        b=atQxxuGYRMD5JWzZ9lDXiYAFhPj69ahwVTbl2ZpyP5oOsE6rmOtuRWQI7+evuZsb6Z
         TwqMi46lmu3/qP1uVOfwJNF+O5ycwfn5FOAY8E/A/Zv8L5Gs2izOSiwmp36OULqnX1iO
         XRi8EiUqyPvz9GhNCgBPZhdQeSf9FzK2VJsS4kFU2Etaw5VnGsSZbDUtiQLMWKBQmb2K
         ogE35qBXx+nYprie3dUFyC65OBlrys6WWNxiUmJUyyO9pMy2+ckJPRrw9A+9BEO4KzXz
         ung94/U98P+PkvYHRZTWVXn1CpJE/gp9Bcw0Btz1hd0TQTrBS0DyZ+g7vm/8Sb9zM1Pc
         sdKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m+/aHHzA7P1xYHmkYaS5NJbgJVCxVABFSZYdM1niH8Q=;
        b=Y4wJUdnSipq/4GHF+UKUrMrChPftiomcP+3BElnzKn3OjcbPHaGPtcOArttYXyVAPr
         sawlD1biZUNXbWBK3+0axq+QDTpDWU5XMduGR6WtaqoR9Omto5Np8ivtpOsu5s6W9Pvl
         13NtdTdpdKci3tWexztFFx4gkavoZJrTmMXB//fYBq4jxN3ISNoZu9wiy8mJnu1fCTAl
         1yb67QyZMikEXKr7p+P+oETU3blH+3Niw3b2v7WFTIQlJlm7T1mQ4uononi9zmJXJBqE
         kZnh2t6+v6TdposfIBh+F1lUVYKobfWDuFovN/YRWG3BZn6mPm62M3scq2vdZahLB/+q
         LS2A==
X-Gm-Message-State: AGi0PuYbNzPI5i5kI1KENHuVYgzjcytmuOTQXKZU8IENYnFENRq0mMdy
        sC7mhCJe1+CSNwqS/iL5P8JqxynNins=
X-Google-Smtp-Source: APiQypL4HHsensgoe2o2aPb18GcdzdD7ChqjkqlfXd4DUCVBQHAebfaJwVAgDUFj6wH0LtVR9zTO1Q==
X-Received: by 2002:a1c:1d4b:: with SMTP id d72mr4564052wmd.19.1587472850630;
        Tue, 21 Apr 2020 05:40:50 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id u3sm3408232wrt.93.2020.04.21.05.40.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 05:40:49 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Will Deacon <will.deacon@arm.com>,
        Laura Abbott <labbott@redhat.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.14 05/24] arm64: traps: Don't print stack or raw PC/LR values in backtraces
Date:   Tue, 21 Apr 2020 13:39:58 +0100
Message-Id: <20200421124017.272694-6-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200421124017.272694-1-lee.jones@linaro.org>
References: <20200421124017.272694-1-lee.jones@linaro.org>
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
index ee5ce03c9315d..2ff327651ebec 100644
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

