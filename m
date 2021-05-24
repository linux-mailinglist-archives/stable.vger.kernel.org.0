Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1804538EEF0
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234895AbhEXPzj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:55:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:40476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235284AbhEXPzE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:55:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C64261437;
        Mon, 24 May 2021 15:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870853;
        bh=cwh7DaSZryp4iZV48+PWaVVyY6zjdaCZID7eLWEWHCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OgJDqIMmfPxkpIP3O6CfY2NOzAjIIy3LdIw9bqaCeM5nCtysX3ai8QXETVHhAUXLA
         wkFRkL0k9Y/I4mtHlPDvtNZ7HXNf4PReSR1HflTVdgDnEd2TMGhzoU33UAZtBucFkd
         DlRSiJx9659OlxWGzRcy96+a7M/wSIX0YgqkkVyQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Dmitry V. Levin" <ldv@altlinux.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.10 065/104] powerpc/64s/syscall: Fix ptrace syscall info with scv syscalls
Date:   Mon, 24 May 2021 17:26:00 +0200
Message-Id: <20210524152335.009434900@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152332.844251980@linuxfoundation.org>
References: <20210524152332.844251980@linuxfoundation.org>
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
 
@@ -144,25 +145,6 @@ extern unsigned long profile_pc(struct p
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
@@ -245,6 +227,31 @@ static inline void set_trap_norestart(st
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
 


