Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5FA106CA6
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729986AbfKVKxh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:53:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:38284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730224AbfKVKxg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:53:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DBED20656;
        Fri, 22 Nov 2019 10:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420015;
        bh=yK1zw7+ztDz/wY5Xfb41Gx3AS89+UUsmCgSojd7FXaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gztkh4BRYDKJwlaBLZOl+T9yYSbTWjpprOu1yoK/QZqYtBcSzwlz6d/sFpp3z7DDp
         oK0F2DNxzH1M0cgsKI9ItoneXBr5k4vCaWI8vbBvrfqmTfdoh9o6xkc+1J6IORuPRp
         K2GY1Otj0HeF2MTfKPag2a9spGsapEzcAdaeNi4w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Borislav Petkov <bp@alien8.de>,
        Brian Gerst <brgerst@gmail.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Markus T Metzger <markus.t.metzger@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ravi Shankar <ravi.v.shankar@intel.com>,
        Rik van Riel <riel@surriel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 087/122] x86/fsgsbase/64: Fix ptrace() to read the FS/GS base accurately
Date:   Fri, 22 Nov 2019 11:29:00 +0100
Message-Id: <20191122100826.017145675@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100722.177052205@linuxfoundation.org>
References: <20191122100722.177052205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Lutomirski <luto@kernel.org>

[ Upstream commit 07e1d88adaaeab247b300926f78cc3f950dbeda3 ]

On 64-bit kernels ptrace can read the FS/GS base using the register access
APIs (PTRACE_PEEKUSER, etc.) or PTRACE_ARCH_PRCTL.

Make both of these mechanisms return the actual FS/GS base.

This will improve debuggability by providing the correct information
to ptracer such as GDB.

[ chang: Rebased and revised patch description. ]
[ mingo: Revised the changelog some more. ]

Signed-off-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Markus T Metzger <markus.t.metzger@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ravi Shankar <ravi.v.shankar@intel.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/1537312139-5580-2-git-send-email-chang.seok.bae@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/ptrace.c | 62 +++++++++++++++++++++++++++++++++-------
 1 file changed, 52 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 584cdd475bb31..734549492a18b 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -40,6 +40,7 @@
 #include <asm/hw_breakpoint.h>
 #include <asm/traps.h>
 #include <asm/syscall.h>
+#include <asm/mmu_context.h>
 
 #include "tls.h"
 
@@ -343,6 +344,49 @@ static int set_segment_reg(struct task_struct *task,
 	return 0;
 }
 
+static unsigned long task_seg_base(struct task_struct *task,
+				   unsigned short selector)
+{
+	unsigned short idx = selector >> 3;
+	unsigned long base;
+
+	if (likely((selector & SEGMENT_TI_MASK) == 0)) {
+		if (unlikely(idx >= GDT_ENTRIES))
+			return 0;
+
+		/*
+		 * There are no user segments in the GDT with nonzero bases
+		 * other than the TLS segments.
+		 */
+		if (idx < GDT_ENTRY_TLS_MIN || idx > GDT_ENTRY_TLS_MAX)
+			return 0;
+
+		idx -= GDT_ENTRY_TLS_MIN;
+		base = get_desc_base(&task->thread.tls_array[idx]);
+	} else {
+#ifdef CONFIG_MODIFY_LDT_SYSCALL
+		struct ldt_struct *ldt;
+
+		/*
+		 * If performance here mattered, we could protect the LDT
+		 * with RCU.  This is a slow path, though, so we can just
+		 * take the mutex.
+		 */
+		mutex_lock(&task->mm->context.lock);
+		ldt = task->mm->context.ldt;
+		if (unlikely(idx >= ldt->nr_entries))
+			base = 0;
+		else
+			base = get_desc_base(ldt->entries + idx);
+		mutex_unlock(&task->mm->context.lock);
+#else
+		base = 0;
+#endif
+	}
+
+	return base;
+}
+
 #endif	/* CONFIG_X86_32 */
 
 static unsigned long get_flags(struct task_struct *task)
@@ -436,18 +480,16 @@ static unsigned long getreg(struct task_struct *task, unsigned long offset)
 
 #ifdef CONFIG_X86_64
 	case offsetof(struct user_regs_struct, fs_base): {
-		/*
-		 * XXX: This will not behave as expected if called on
-		 * current or if fsindex != 0.
-		 */
-		return task->thread.fsbase;
+		if (task->thread.fsindex == 0)
+			return task->thread.fsbase;
+		else
+			return task_seg_base(task, task->thread.fsindex);
 	}
 	case offsetof(struct user_regs_struct, gs_base): {
-		/*
-		 * XXX: This will not behave as expected if called on
-		 * current or if fsindex != 0.
-		 */
-		return task->thread.gsbase;
+		if (task->thread.gsindex == 0)
+			return task->thread.gsbase;
+		else
+			return task_seg_base(task, task->thread.gsindex);
 	}
 #endif
 	}
-- 
2.20.1



