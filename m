Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0807E272F0B
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728429AbgIUQqH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:46:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:52076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727302AbgIUQp7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:45:59 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7875206B2;
        Mon, 21 Sep 2020 16:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706758;
        bh=zRnzcd8ZM9DjUcGJxi3Jq0JAUPtuMZiw6U8QenmZGaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mj/eBapIaXy6teW4glIWiayfLhz/2JBzXL59FRwgGJfG4WDZDS4JgRmiEs+fKokF1
         0vViPvxM50gAzTPM7OOcf4EaTmFgaQMG7GyfTEISMDAPiEJiW3kWvBOXnlpMHJmJxY
         /QhLq9aH06z9Sfjgz0iOi105boPxtpA7DU8+8o58=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naresh Kamboju <naresh.kamboju@linaro.org>,
        Logan Gunthorpe <logang@deltatee.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Borislav Petkov <bp@suse.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 082/118] x86/unwind/fp: Fix FP unwinding in ret_from_fork
Date:   Mon, 21 Sep 2020 18:28:14 +0200
Message-Id: <20200921162040.146732002@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@redhat.com>

[ Upstream commit 6f9885a36c006d798319661fa849f9c2922223b9 ]

There have been some reports of "bad bp value" warnings printed by the
frame pointer unwinder:

  WARNING: kernel stack regs at 000000005bac7112 in sh:1014 has bad 'bp' value 0000000000000000

This warning happens when unwinding from an interrupt in
ret_from_fork(). If entry code gets interrupted, the state of the
frame pointer (rbp) may be undefined, which can confuse the unwinder,
resulting in warnings like the above.

There's an in_entry_code() check which normally silences such
warnings for entry code. But in this case, ret_from_fork() is getting
interrupted. It recently got moved out of .entry.text, so the
in_entry_code() check no longer works.

It could be moved back into .entry.text, but that would break the
noinstr validation because of the call to schedule_tail().

Instead, initialize each new task's RBP to point to the task's entry
regs via an encoded frame pointer.  That will allow the unwinder to
reach the end of the stack gracefully.

Fixes: b9f6976bfb94 ("x86/entry/64: Move non entry code into .text section")
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Reported-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/f366bbf5a8d02e2318ee312f738112d0af74d16f.1600103007.git.jpoimboe@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/frame.h | 19 +++++++++++++++++++
 arch/x86/kernel/process.c    |  3 ++-
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/frame.h b/arch/x86/include/asm/frame.h
index 296b346184b27..fb42659f6e988 100644
--- a/arch/x86/include/asm/frame.h
+++ b/arch/x86/include/asm/frame.h
@@ -60,12 +60,26 @@
 #define FRAME_END "pop %" _ASM_BP "\n"
 
 #ifdef CONFIG_X86_64
+
 #define ENCODE_FRAME_POINTER			\
 	"lea 1(%rsp), %rbp\n\t"
+
+static inline unsigned long encode_frame_pointer(struct pt_regs *regs)
+{
+	return (unsigned long)regs + 1;
+}
+
 #else /* !CONFIG_X86_64 */
+
 #define ENCODE_FRAME_POINTER			\
 	"movl %esp, %ebp\n\t"			\
 	"andl $0x7fffffff, %ebp\n\t"
+
+static inline unsigned long encode_frame_pointer(struct pt_regs *regs)
+{
+	return (unsigned long)regs & 0x7fffffff;
+}
+
 #endif /* CONFIG_X86_64 */
 
 #endif /* __ASSEMBLY__ */
@@ -83,6 +97,11 @@
 
 #define ENCODE_FRAME_POINTER
 
+static inline unsigned long encode_frame_pointer(struct pt_regs *regs)
+{
+	return 0;
+}
+
 #endif
 
 #define FRAME_BEGIN
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index fe67dbd76e517..bff502e779e44 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -42,6 +42,7 @@
 #include <asm/spec-ctrl.h>
 #include <asm/io_bitmap.h>
 #include <asm/proto.h>
+#include <asm/frame.h>
 
 #include "process.h"
 
@@ -133,7 +134,7 @@ int copy_thread_tls(unsigned long clone_flags, unsigned long sp,
 	fork_frame = container_of(childregs, struct fork_frame, regs);
 	frame = &fork_frame->frame;
 
-	frame->bp = 0;
+	frame->bp = encode_frame_pointer(childregs);
 	frame->ret_addr = (unsigned long) ret_from_fork;
 	p->thread.sp = (unsigned long) fork_frame;
 	p->thread.io_bitmap = NULL;
-- 
2.25.1



