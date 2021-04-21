Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0813670C3
	for <lists+stable@lfdr.de>; Wed, 21 Apr 2021 18:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241267AbhDUQ7m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Apr 2021 12:59:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:32864 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238561AbhDUQ7j (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Apr 2021 12:59:39 -0400
Received: from mail-wm1-f70.google.com ([209.85.128.70])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lZGBt-0004yc-6s
        for stable@vger.kernel.org; Wed, 21 Apr 2021 16:59:05 +0000
Received: by mail-wm1-f70.google.com with SMTP id f134-20020a1c1f8c0000b029012e03286b7bso614688wmf.0
        for <stable@vger.kernel.org>; Wed, 21 Apr 2021 09:59:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JdDRghPVAAuYeHqiEWJQJzPWmE20gIuYSOL2mmfqPIw=;
        b=r1X+j08S44o/ItpSohmsmPV+ATsTUEt0ZCrT+BOafB5Pyikaq08Oi23hcV5VOFkTJP
         4JXAN7NI0P2w6wNemL0myDcMriu9Y0p9XIFfb3m0m5rWDH2wLUm6k7r6pXLPPkVOkg2b
         R9eHiKr2JC9B0fR5GzcRvJ6/WASReZ0SZTHKj2tkr0skMzXURYH9OJKU49/fcGXMMY1g
         EJdYkhSR+sZg0EblLOA3yKq18ZNP5D9Fbg30GK/DTcivBEAqZgFRfb7BisMHKgINteV0
         kyiogBjm9bsetCJd+1sZcRH93Gt/DVMGoZDIrA+0BoNuMcMw5Pi/JYNO8rSdKiRlQaa6
         c8BA==
X-Gm-Message-State: AOAM530wfMvUahviXBRgAxXu94Tmd5qwSyLGHpr5xEcq6NefHpsLoAPX
        7U1qZVCRP+27QXsm7exF9VhQ2Hoq/OOWebEXlEhgrvaE78UKAiBj3GdU0/YG4fmNF8V+EsLLLZb
        SLIc3B+uTOKs/b7IaXaIejfOmMHpx5q8dOg==
X-Received: by 2002:a7b:c2fa:: with SMTP id e26mr10907389wmk.118.1619024344712;
        Wed, 21 Apr 2021 09:59:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx2Zf7ujCbYe5OEnaHv9kG59Z3zFSgE7ftNZh3L6i6HhVS9ZycJMwOeLKHviY8tkHq3f9LK0w==
X-Received: by 2002:a7b:c2fa:: with SMTP id e26mr10907369wmk.118.1619024344509;
        Wed, 21 Apr 2021 09:59:04 -0700 (PDT)
Received: from localhost.localdomain (xdsl-188-155-180-75.adslplus.ch. [188.155.180.75])
        by smtp.gmail.com with ESMTPSA id w7sm8279wru.87.2021.04.21.09.59.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 09:59:04 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     stable@vger.kernel.org
Cc:     Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Dan Streetman <ddstreet@canonical.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: [PATCH stable v5.4+] s390/ptrace: return -ENOSYS when invalid syscall is supplied
Date:   Wed, 21 Apr 2021 18:58:53 +0200
Message-Id: <20210421165853.148822-1-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Schnelle <svens@linux.ibm.com>

commit cd29fa798001075a554b978df3a64e6656c25794 upstream.

The current code returns the syscall number which an invalid
syscall number is supplied and tracing is enabled. This makes
the strace testsuite fail.

Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Dan Streetman <ddstreet@canonical.com>
Link: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1895132
[krzysztof: adjusted the backport around missing ifdef CONFIG_SECCOMP,
 add Link and Fixes; apparently this should go with the referenced commit]
Fixes: 00332c16b160 ("s390/ptrace: pass invalid syscall numbers to tracing")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 arch/s390/kernel/ptrace.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/arch/s390/kernel/ptrace.c b/arch/s390/kernel/ptrace.c
index c6aef2ecf289..ad74472ce967 100644
--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -867,6 +867,7 @@ long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
 asmlinkage long do_syscall_trace_enter(struct pt_regs *regs)
 {
 	unsigned long mask = -1UL;
+	long ret = -1;
 
 	/*
 	 * The sysc_tracesys code in entry.S stored the system
@@ -878,27 +879,33 @@ asmlinkage long do_syscall_trace_enter(struct pt_regs *regs)
 		 * Tracing decided this syscall should not happen. Skip
 		 * the system call and the system call restart handling.
 		 */
-		clear_pt_regs_flag(regs, PIF_SYSCALL);
-		return -1;
+		goto skip;
 	}
 
 	/* Do the secure computing check after ptrace. */
 	if (secure_computing(NULL)) {
 		/* seccomp failures shouldn't expose any additional code. */
-		return -1;
+		goto skip;
 	}
 
 	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
-		trace_sys_enter(regs, regs->gprs[2]);
+		trace_sys_enter(regs, regs->int_code & 0xffff);
 
 	if (is_compat_task())
 		mask = 0xffffffff;
 
-	audit_syscall_entry(regs->gprs[2], regs->orig_gpr2 & mask,
+	audit_syscall_entry(regs->int_code & 0xffff, regs->orig_gpr2 & mask,
 			    regs->gprs[3] &mask, regs->gprs[4] &mask,
 			    regs->gprs[5] &mask);
 
+	if ((signed long)regs->gprs[2] >= NR_syscalls) {
+		regs->gprs[2] = -ENOSYS;
+		ret = -ENOSYS;
+	}
 	return regs->gprs[2];
+skip:
+	clear_pt_regs_flag(regs, PIF_SYSCALL);
+	return ret;
 }
 
 asmlinkage void do_syscall_trace_exit(struct pt_regs *regs)
-- 
2.25.1

