Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 740D510B832
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728589AbfK0Uk7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:40:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:45800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729108AbfK0Uk4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:40:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE135215A5;
        Wed, 27 Nov 2019 20:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887256;
        bh=nZxJ00STl8IMFOGnrMdWwzfFhRdOIpZHkd0P/ot4qpM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2O6y5+F4uJMZXc6dQTfNAwVwRLSGmFZZ51dnzdIS5gSW0/KQkJDQeP73TLQJ7XJ/o
         8JvTFKcDZquHbfeXoQPzV7dCVGntbQ3Hv0Itb+0hPiB/CHYYZQn1OrGk3jmY+joogY
         oeXQv+kba2mfV/ayQ0vz0RCG3dEZL3G5HAjTotpY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Borislav Petkov <bp@alien8.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 040/151] kprobes, x86/ptrace.h: Make regs_get_kernel_stack_nth() not fault on bad stack
Date:   Wed, 27 Nov 2019 21:30:23 +0100
Message-Id: <20191127203025.510308881@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203000.773542911@linuxfoundation.org>
References: <20191127203000.773542911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

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
index ea78a8438a8af..fb489cd848faa 100644
--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -199,24 +199,52 @@ static inline int regs_within_kernel_stack(struct pt_regs *regs,
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



