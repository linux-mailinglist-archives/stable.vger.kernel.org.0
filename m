Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67A0124B32B
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 11:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728912AbgHTJmV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:42:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:36892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728876AbgHTJmR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:42:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5F8D207FB;
        Thu, 20 Aug 2020 09:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916536;
        bh=vxvjVRskRRfqYiS7lGjlXSeNqSaOj3GOptYFi73IQUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eCY43tw/h13Rva+qWq/oUBP7St+6dGoL2+DuG1dxW5wMEKR+92AcpbvX0Pb88QUD5
         OG5R0xjvNOcV319yG3nrMM/w+PM49rJscwIulZlrJ9ULCv4AaFoBcTHBO7pext9rxu
         lrxilsMOT+glsn+hH449Ywdft89neag6Q++l3yAo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stafford Horne <shorne@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 155/204] openrisc: Fix oops caused when dumping stack
Date:   Thu, 20 Aug 2020 11:20:52 +0200
Message-Id: <20200820091613.981058173@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091606.194320503@linuxfoundation.org>
References: <20200820091606.194320503@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stafford Horne <shorne@gmail.com>

[ Upstream commit 57b8e277c33620e115633cdf700a260b55095460 ]

When dumping a stack with 'cat /proc/#/stack' the kernel would oops.
For example:

    # cat /proc/690/stack
    Unable to handle kernel access
     at virtual address 0x7fc60f58

    Oops#: 0000
    CPU #: 0
       PC: c00097fc    SR: 0000807f    SP: d6f09b9c
    GPR00: 00000000 GPR01: d6f09b9c GPR02: d6f09bb8 GPR03: d6f09bc4
    GPR04: 7fc60f5c GPR05: c00099b4 GPR06: 00000000 GPR07: d6f09ba3
    GPR08: ffffff00 GPR09: c0009804 GPR10: d6f08000 GPR11: 00000000
    GPR12: ffffe000 GPR13: dbb86000 GPR14: 00000001 GPR15: dbb86250
    GPR16: 7fc60f63 GPR17: 00000f5c GPR18: d6f09bc4 GPR19: 00000000
    GPR20: c00099b4 GPR21: ffffffc0 GPR22: 00000000 GPR23: 00000000
    GPR24: 00000001 GPR25: 000002c6 GPR26: d78b6850 GPR27: 00000001
    GPR28: 00000000 GPR29: dbb86000 GPR30: ffffffff GPR31: dbb862fc
      RES: 00000000 oGPR11: ffffffff
    Process cat (pid: 702, stackpage=d79d6000)

    Stack:
    Call trace:
    [<598977f2>] save_stack_trace_tsk+0x40/0x74
    [<95063f0e>] stack_trace_save_tsk+0x44/0x58
    [<b557bfdd>] proc_pid_stack+0xd0/0x13c
    [<a2df8eda>] proc_single_show+0x6c/0xf0
    [<e5a737b7>] seq_read+0x1b4/0x688
    [<2d6c7480>] do_iter_read+0x208/0x248
    [<2182a2fb>] vfs_readv+0x64/0x90

This was caused by the stack trace code in save_stack_trace_tsk using
the wrong stack pointer.  It was using the user stack pointer instead of
the kernel stack pointer.  Fix this by using the right stack.

Also for good measure we add try_get_task_stack/put_task_stack to ensure
the task is not lost while we are walking it's stack.

Fixes: eecac38b0423a ("openrisc: support framepointers and STACKTRACE_SUPPORT")
Signed-off-by: Stafford Horne <shorne@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/openrisc/kernel/stacktrace.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/openrisc/kernel/stacktrace.c b/arch/openrisc/kernel/stacktrace.c
index 43f140a28bc72..54d38809e22cb 100644
--- a/arch/openrisc/kernel/stacktrace.c
+++ b/arch/openrisc/kernel/stacktrace.c
@@ -13,6 +13,7 @@
 #include <linux/export.h>
 #include <linux/sched.h>
 #include <linux/sched/debug.h>
+#include <linux/sched/task_stack.h>
 #include <linux/stacktrace.h>
 
 #include <asm/processor.h>
@@ -68,12 +69,25 @@ void save_stack_trace_tsk(struct task_struct *tsk, struct stack_trace *trace)
 {
 	unsigned long *sp = NULL;
 
+	if (!try_get_task_stack(tsk))
+		return;
+
 	if (tsk == current)
 		sp = (unsigned long *) &sp;
-	else
-		sp = (unsigned long *) KSTK_ESP(tsk);
+	else {
+		unsigned long ksp;
+
+		/* Locate stack from kernel context */
+		ksp = task_thread_info(tsk)->ksp;
+		ksp += STACK_FRAME_OVERHEAD;	/* redzone */
+		ksp += sizeof(struct pt_regs);
+
+		sp = (unsigned long *) ksp;
+	}
 
 	unwind_stack(trace, sp, save_stack_address_nosched);
+
+	put_task_stack(tsk);
 }
 EXPORT_SYMBOL_GPL(save_stack_trace_tsk);
 
-- 
2.25.1



