Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCF1F38EFEA
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234666AbhEXQAS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 12:00:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:40492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233126AbhEXP72 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:59:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 230C161973;
        Mon, 24 May 2021 15:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621871122;
        bh=pWEP2KSu5qBCjYQtK+BZ3ZnRIjvVR0OCYadDq5qMKQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LwHQ5iOCthxVHK2+xKWBhCnJdvAQTRsRiWbp4hmnidPltN00LpfNPdcOJA7mVHZ0h
         hZnrrqAbCFMw1+NV+nFN4iyJ99ahbU3C8aOSxbNKaYbUHLFFsEHoi+OcJ9dM58Upzm
         lFHUOl4xvBjQPG6ny0pwFv/x4CHlEeBV0utv3xvc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Dmitry V. Levin" <ldv@altlinux.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.12 083/127] powerpc/64s/syscall: Fix ptrace syscall info with scv syscalls
Date:   Mon, 24 May 2021 17:26:40 +0200
Message-Id: <20210524152337.656749585@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152334.857620285@linuxfoundation.org>
References: <20210524152334.857620285@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

commit d72500f992849d31ebae8f821a023660ddd0dcc2 upstream.

The scv implementation missed updating syscall return value and error
value get/set functions to deal with the changed register ABI. This
broke ptrace PTRACE_GET_SYSCALL_INFO as well as some kernel auditing
and tracing functions.

Fix. tools/testing/selftests/ptrace/get_syscall_info now passes when
scv is used.

Fixes: 7fa95f9adaee ("powerpc/64s: system call support for scv/rfscv instructions")
Cc: stable@vger.kernel.org # v5.9+
Reported-by: "Dmitry V. Levin" <ldv@altlinux.org>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Reviewed-by: Dmitry V. Levin <ldv@altlinux.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210520111931.2597127-2-npiggin@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/ptrace.h  |   45 +++++++++++++++++++++----------------
 arch/powerpc/include/asm/syscall.h |   42 +++++++++++++++++++++-------------
 2 files changed, 52 insertions(+), 35 deletions(-)

--- a/arch/powerpc/include/asm/ptrace.h
+++ b/arch/powerpc/include/asm/ptrace.h
@@ -19,6 +19,7 @@
 #ifndef _ASM_POWERPC_PTRACE_H
 #define _ASM_POWERPC_PTRACE_H
 
+#include <linux/err.h>
 #include <uapi/asm/ptrace.h>
 #include <asm/asm-const.h>
 
@@ -152,25 +153,6 @@ extern unsigned long profile_pc(struct p
 long do_syscall_trace_enter(struct pt_regs *regs);
 void do_syscall_trace_leave(struct pt_regs *regs);
 
-#define kernel_stack_pointer(regs) ((regs)->gpr[1])
-static inline int is_syscall_success(struct pt_regs *regs)
-{
-	return !(regs->ccr & 0x10000000);
-}
-
-static inline long regs_return_value(struct pt_regs *regs)
-{
-	if (is_syscall_success(regs))
-		return regs->gpr[3];
-	else
-		return -regs->gpr[3];
-}
-
-static inline void regs_set_return_value(struct pt_regs *regs, unsigned long rc)
-{
-	regs->gpr[3] = rc;
-}
-
 #ifdef __powerpc64__
 #define user_mode(regs) ((((regs)->msr) >> MSR_PR_LG) & 0x1)
 #else
@@ -252,6 +234,31 @@ static inline void set_trap_norestart(st
 	regs->trap |= 0x10;
 }
 
+#define kernel_stack_pointer(regs) ((regs)->gpr[1])
+static inline int is_syscall_success(struct pt_regs *regs)
+{
+	if (trap_is_scv(regs))
+		return !IS_ERR_VALUE((unsigned long)regs->gpr[3]);
+	else
+		return !(regs->ccr & 0x10000000);
+}
+
+static inline long regs_return_value(struct pt_regs *regs)
+{
+	if (trap_is_scv(regs))
+		return regs->gpr[3];
+
+	if (is_syscall_success(regs))
+		return regs->gpr[3];
+	else
+		return -regs->gpr[3];
+}
+
+static inline void regs_set_return_value(struct pt_regs *regs, unsigned long rc)
+{
+	regs->gpr[3] = rc;
+}
+
 #define arch_has_single_step()	(1)
 #define arch_has_block_step()	(true)
 #define ARCH_HAS_USER_SINGLE_STEP_REPORT
--- a/arch/powerpc/include/asm/syscall.h
+++ b/arch/powerpc/include/asm/syscall.h
@@ -41,11 +41,17 @@ static inline void syscall_rollback(stru
 static inline long syscall_get_error(struct task_struct *task,
 				     struct pt_regs *regs)
 {
-	/*
-	 * If the system call failed,
-	 * regs->gpr[3] contains a positive ERRORCODE.
-	 */
-	return (regs->ccr & 0x10000000UL) ? -regs->gpr[3] : 0;
+	if (trap_is_scv(regs)) {
+		unsigned long error = regs->gpr[3];
+
+		return IS_ERR_VALUE(error) ? error : 0;
+	} else {
+		/*
+		 * If the system call failed,
+		 * regs->gpr[3] contains a positive ERRORCODE.
+		 */
+		return (regs->ccr & 0x10000000UL) ? -regs->gpr[3] : 0;
+	}
 }
 
 static inline long syscall_get_return_value(struct task_struct *task,
@@ -58,18 +64,22 @@ static inline void syscall_set_return_va
 					    struct pt_regs *regs,
 					    int error, long val)
 {
-	/*
-	 * In the general case it's not obvious that we must deal with CCR
-	 * here, as the syscall exit path will also do that for us. However
-	 * there are some places, eg. the signal code, which check ccr to
-	 * decide if the value in r3 is actually an error.
-	 */
-	if (error) {
-		regs->ccr |= 0x10000000L;
-		regs->gpr[3] = error;
+	if (trap_is_scv(regs)) {
+		regs->gpr[3] = (long) error ?: val;
 	} else {
-		regs->ccr &= ~0x10000000L;
-		regs->gpr[3] = val;
+		/*
+		 * In the general case it's not obvious that we must deal with
+		 * CCR here, as the syscall exit path will also do that for us.
+		 * However there are some places, eg. the signal code, which
+		 * check ccr to decide if the value in r3 is actually an error.
+		 */
+		if (error) {
+			regs->ccr |= 0x10000000L;
+			regs->gpr[3] = error;
+		} else {
+			regs->ccr &= ~0x10000000L;
+			regs->gpr[3] = val;
+		}
 	}
 }
 


