Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3D3FEF75
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 16:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729783AbfKPP7G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:59:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:35564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731382AbfKPPyG (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:54:06 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 904382184B;
        Sat, 16 Nov 2019 15:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919645;
        bh=D8mCsiEzR6izmi+hn6DAU5ElQOyy8Jel0fWiOlabNYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r3lE1OWo9YXtP7CW2jqMKU6E6F0Gix8H5oThQZzRnNcyEI5kk/UQL8Jyrm5WKPNth
         W9dZkym4Td3z+bI1Z2bVVlmNTQjNmcM1vrSK3qommqSVByc8K7nHb471iTZyIIlAmc
         /uvDkP5CPg8Yc5v14GLzyzXB2Ih85u888CGWXQyI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Joel Fernandes <joel@joelfernandes.org>,
        Borislav Petkov <bp@alien8.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 23/77] kprobes, x86/ptrace.h: Make regs_get_kernel_stack_nth() not fault on bad stack
Date:   Sat, 16 Nov 2019 10:52:45 -0500
Message-Id: <20191116155339.11909-23-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116155339.11909-1-sashal@kernel.org>
References: <20191116155339.11909-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

[ Upstream commit c2712b858187f5bcd7b042fe4daa3ba3a12635c0 ]

Andy had some concerns about using regs_get_kernel_stack_nth() in a new
function regs_get_kernel_argument() as if there's any error in the stack
code, it could cause a bad memory access. To be on the safe side, call
probe_kernel_read() on the stack address to be extra careful in accessing
the memory. A helper function, regs_get_kernel_stack_nth_addr(), was added
to just return the stack address (or NULL if not on the stack), that will be
used to find the address (and could be used by other functions) and read the
address with kernel_probe_read().

Requested-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Reviewed-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/20181017165951.09119177@gandalf.local.home
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/ptrace.h | 42 +++++++++++++++++++++++++++++------
 1 file changed, 35 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
index 0d8e0831b1a07..3daec418c822f 100644
--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -205,24 +205,52 @@ static inline int regs_within_kernel_stack(struct pt_regs *regs,
 		(kernel_stack_pointer(regs) & ~(THREAD_SIZE - 1)));
 }
 
+/**
+ * regs_get_kernel_stack_nth_addr() - get the address of the Nth entry on stack
+ * @regs:	pt_regs which contains kernel stack pointer.
+ * @n:		stack entry number.
+ *
+ * regs_get_kernel_stack_nth() returns the address of the @n th entry of the
+ * kernel stack which is specified by @regs. If the @n th entry is NOT in
+ * the kernel stack, this returns NULL.
+ */
+static inline unsigned long *regs_get_kernel_stack_nth_addr(struct pt_regs *regs, unsigned int n)
+{
+	unsigned long *addr = (unsigned long *)kernel_stack_pointer(regs);
+
+	addr += n;
+	if (regs_within_kernel_stack(regs, (unsigned long)addr))
+		return addr;
+	else
+		return NULL;
+}
+
+/* To avoid include hell, we can't include uaccess.h */
+extern long probe_kernel_read(void *dst, const void *src, size_t size);
+
 /**
  * regs_get_kernel_stack_nth() - get Nth entry of the stack
  * @regs:	pt_regs which contains kernel stack pointer.
  * @n:		stack entry number.
  *
  * regs_get_kernel_stack_nth() returns @n th entry of the kernel stack which
- * is specified by @regs. If the @n th entry is NOT in the kernel stack,
+ * is specified by @regs. If the @n th entry is NOT in the kernel stack
  * this returns 0.
  */
 static inline unsigned long regs_get_kernel_stack_nth(struct pt_regs *regs,
 						      unsigned int n)
 {
-	unsigned long *addr = (unsigned long *)kernel_stack_pointer(regs);
-	addr += n;
-	if (regs_within_kernel_stack(regs, (unsigned long)addr))
-		return *addr;
-	else
-		return 0;
+	unsigned long *addr;
+	unsigned long val;
+	long ret;
+
+	addr = regs_get_kernel_stack_nth_addr(regs, n);
+	if (addr) {
+		ret = probe_kernel_read(&val, addr, sizeof(val));
+		if (!ret)
+			return val;
+	}
+	return 0;
 }
 
 #define arch_has_single_step()	(1)
-- 
2.20.1

