Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24D581D0E16
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732917AbgEMJ5X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:57:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:58460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387453AbgEMJzX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:55:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0744023129;
        Wed, 13 May 2020 09:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363722;
        bh=HUuxcwIIaZHtFP8sVWs/Uxy6r5Oy1N2xRE2mYB77S+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q/XnkhrKYVeJW9Fx0UCsvCPtLPGG+FsWfm6sopZdhxqsumEEJD4c/TGqVRO2ux17k
         89xjuIseVz+HSNzMqnegYAh+WRvn/Pbem8+48mTGFpuDmSp4sgzwCwUfyMMdOdx8AO
         /zZTgGZypnyGqmqVyPiznkwlp4lhip+r+FZR8TMo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vince Weaver <vincent.weaver@maine.edu>,
        Dave Jones <dsj@fb.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Joe Mario <jmario@redhat.com>, Jann Horn <jannh@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.6 098/118] x86/entry/64: Fix unwind hints in kernel exit path
Date:   Wed, 13 May 2020 11:45:17 +0200
Message-Id: <20200513094425.884881700@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094417.618129545@linuxfoundation.org>
References: <20200513094417.618129545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@redhat.com>

commit 1fb143634a38095b641a3a21220774799772dc4c upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/entry/entry_64.S |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -249,7 +249,6 @@ SYM_INNER_LABEL(entry_SYSCALL_64_after_h
 	 */
 syscall_return_via_sysret:
 	/* rcx and r11 are already restored (see code above) */
-	UNWIND_HINT_EMPTY
 	POP_REGS pop_rdi=0 skip_r11rcx=1
 
 	/*
@@ -258,6 +257,7 @@ syscall_return_via_sysret:
 	 */
 	movq	%rsp, %rdi
 	movq	PER_CPU_VAR(cpu_tss_rw + TSS_sp0), %rsp
+	UNWIND_HINT_EMPTY
 
 	pushq	RSP-RDI(%rdi)	/* RSP */
 	pushq	(%rdi)		/* RDI */
@@ -637,6 +637,7 @@ SYM_INNER_LABEL(swapgs_restore_regs_and_
 	 */
 	movq	%rsp, %rdi
 	movq	PER_CPU_VAR(cpu_tss_rw + TSS_sp0), %rsp
+	UNWIND_HINT_EMPTY
 
 	/* Copy the IRET frame to the trampoline stack. */
 	pushq	6*8(%rdi)	/* SS */


