Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80E061D3B6E
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 21:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728729AbgENTCK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 15:02:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:55712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729328AbgENSzO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 May 2020 14:55:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB7A42074A;
        Thu, 14 May 2020 18:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589482514;
        bh=4xMj5rnI4Scg/R/q3gQ+zsinkyURzzXl/HRZSA+oI00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=18+tB5nvdv8JhRhLASdLcQU8O3y88nLIaNhg3tMSPI/MlYoZNsP49lo/3eoPRks1P
         EQDhEEXLFZSU2zVWOvuSSVnZyjEzi3x7eiEY/jxdEMI8w7BwQ5thnLIdpJG1yL9Jgp
         ZbOkkFvE8B0wwjeL7ZmRnSj58ujXM0BejgOy7c50=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Dave Jones <dsj@fb.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Joe Mario <jmario@redhat.com>, Jann Horn <jannh@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Ingo Molnar <mingo@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 12/39] x86/entry/64: Fix unwind hints in kernel exit path
Date:   Thu, 14 May 2020 14:54:29 -0400
Message-Id: <20200514185456.21060-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200514185456.21060-1-sashal@kernel.org>
References: <20200514185456.21060-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@redhat.com>

[ Upstream commit 1fb143634a38095b641a3a21220774799772dc4c ]

In swapgs_restore_regs_and_return_to_usermode, after the stack is
switched to the trampoline stack, the existing UNWIND_HINT_REGS hint is
no longer valid, which can result in the following ORC unwinder warning:

  WARNING: can't dereference registers at 000000003aeb0cdd for ip swapgs_restore_regs_and_return_to_usermode+0x93/0xa0

For full correctness, we could try to add complicated unwind hints so
the unwinder could continue to find the registers, but when when it's
this close to kernel exit, unwind hints aren't really needed anymore and
it's fine to just use an empty hint which tells the unwinder to stop.

For consistency, also move the UNWIND_HINT_EMPTY in
entry_SYSCALL_64_after_hwframe to a similar location.

Fixes: 3e3b9293d392 ("x86/entry/64: Return to userspace from the trampoline stack")
Reported-by: Vince Weaver <vincent.weaver@maine.edu>
Reported-by: Dave Jones <dsj@fb.com>
Reported-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Reported-by: Joe Mario <jmario@redhat.com>
Reported-by: Jann Horn <jannh@google.com>
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/60ea8f562987ed2d9ace2977502fe481c0d7c9a0.1587808742.git.jpoimboe@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/entry/entry_64.S | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 5ec66fafde4e4..d4d72c84d9eb4 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -302,7 +302,6 @@ GLOBAL(entry_SYSCALL_64_after_hwframe)
 	 */
 syscall_return_via_sysret:
 	/* rcx and r11 are already restored (see code above) */
-	UNWIND_HINT_EMPTY
 	POP_REGS pop_rdi=0 skip_r11rcx=1
 
 	/*
@@ -311,6 +310,7 @@ syscall_return_via_sysret:
 	 */
 	movq	%rsp, %rdi
 	movq	PER_CPU_VAR(cpu_tss_rw + TSS_sp0), %rsp
+	UNWIND_HINT_EMPTY
 
 	pushq	RSP-RDI(%rdi)	/* RSP */
 	pushq	(%rdi)		/* RDI */
@@ -606,6 +606,7 @@ GLOBAL(swapgs_restore_regs_and_return_to_usermode)
 	 */
 	movq	%rsp, %rdi
 	movq	PER_CPU_VAR(cpu_tss_rw + TSS_sp0), %rsp
+	UNWIND_HINT_EMPTY
 
 	/* Copy the IRET frame to the trampoline stack. */
 	pushq	6*8(%rdi)	/* SS */
-- 
2.20.1

