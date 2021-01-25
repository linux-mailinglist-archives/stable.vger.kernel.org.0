Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D641B3033BE
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 06:05:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730848AbhAZFEm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 00:04:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:39786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731235AbhAYSxO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:53:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CCF5623109;
        Mon, 25 Jan 2021 18:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600778;
        bh=pE2/4ZCUNQS0GZDWJVO1JKT2qNL0UogyE9WcovNsNcs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2aNIynVbEegAjdaCOBOQQG9d9zvYsOKdkT4NMCLSNvldjoJH/yknr/KuyhZIXAiWD
         4igbZZMQ9+PNZ3yuBMMFE/09ruv/br7Lyj6hehhafBqFQapeMwraq/uWFxpLSeDzDg
         UVyHQdGK46JF4NzwN3LBdyaHTkhz/+uOdA0JniBI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.10 147/199] x86/entry: Fix noinstr fail
Date:   Mon, 25 Jan 2021 19:39:29 +0100
Message-Id: <20210125183222.420164398@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit 9caa7ff509add50959a793b811cc7c9339e281cd upstream.

  vmlinux.o: warning: objtool: __do_fast_syscall_32()+0x47: call to syscall_enter_from_user_mode_work() leaves .noinstr.text section

Fixes: 4facb95b7ada ("x86/entry: Unbreak 32bit fast syscall")
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20210106144017.472696632@infradead.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/entry/common.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/arch/x86/entry/common.c
+++ b/arch/x86/entry/common.c
@@ -73,10 +73,8 @@ static __always_inline void do_syscall_3
 						  unsigned int nr)
 {
 	if (likely(nr < IA32_NR_syscalls)) {
-		instrumentation_begin();
 		nr = array_index_nospec(nr, IA32_NR_syscalls);
 		regs->ax = ia32_sys_call_table[nr](regs);
-		instrumentation_end();
 	}
 }
 
@@ -91,8 +89,11 @@ __visible noinstr void do_int80_syscall_
 	 * or may not be necessary, but it matches the old asm behavior.
 	 */
 	nr = (unsigned int)syscall_enter_from_user_mode(regs, nr);
+	instrumentation_begin();
 
 	do_syscall_32_irqs_on(regs, nr);
+
+	instrumentation_end();
 	syscall_exit_to_user_mode(regs);
 }
 
@@ -121,11 +122,12 @@ static noinstr bool __do_fast_syscall_32
 		res = get_user(*(u32 *)&regs->bp,
 		       (u32 __user __force *)(unsigned long)(u32)regs->sp);
 	}
-	instrumentation_end();
 
 	if (res) {
 		/* User code screwed up. */
 		regs->ax = -EFAULT;
+
+		instrumentation_end();
 		syscall_exit_to_user_mode(regs);
 		return false;
 	}
@@ -135,6 +137,8 @@ static noinstr bool __do_fast_syscall_32
 
 	/* Now this is just like a normal syscall. */
 	do_syscall_32_irqs_on(regs, nr);
+
+	instrumentation_end();
 	syscall_exit_to_user_mode(regs);
 	return true;
 }


