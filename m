Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9A06452750
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348665AbhKPCUl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:20:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:57906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238388AbhKORnE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:43:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1A5C6326D;
        Mon, 15 Nov 2021 17:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997271;
        bh=vbDlyIVcrD4DuO6HOnWMvVM64vrgsGBC0nwOL0t7YW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IrCIO5cFRctyEyDywUq4b56oBY3V9KNhlFLwDfw4CAxXGj43C/c3k0JWr0Wb7XhW5
         tySCfky/9l1CiO7TwU59+Sm5JvtXJAkCUWP//K3xJwqdU8kaaR7AChfdg3EAFvy0UA
         YwWBQnuxBLzB9Ok1Av6sv9PYsppJJaIC7Ea8ybzQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, X86 ML <x86@kernel.org>,
        Daniel Xu <dxu@dxuuu.xyz>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Abhishek Sagar <sagar.abhishek@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Paul McKenney <paulmck@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.10 088/575] ia64: kprobes: Fix to pass correct trampoline address to the handler
Date:   Mon, 15 Nov 2021 17:56:53 +0100
Message-Id: <20211115165346.686379338@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

commit a7fe2378454cf46cd5e2776d05e72bbe8f0a468c upstream.

The following commit:

   Commit e792ff804f49 ("ia64: kprobes: Use generic kretprobe trampoline handler")

Passed the wrong trampoline address to __kretprobe_trampoline_handler(): it
passes the descriptor address instead of function entry address.

Pass the right parameter.

Also use correct symbol dereference function to get the function address
from 'kretprobe_trampoline' - an IA64 special.

Link: https://lkml.kernel.org/r/163163042696.489837.12551102356265354730.stgit@devnote2

Fixes: e792ff804f49 ("ia64: kprobes: Use generic kretprobe trampoline handler")
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: X86 ML <x86@kernel.org>
Cc: Daniel Xu <dxu@dxuuu.xyz>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Abhishek Sagar <sagar.abhishek@gmail.com>
Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: Paul McKenney <paulmck@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/ia64/kernel/kprobes.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/arch/ia64/kernel/kprobes.c
+++ b/arch/ia64/kernel/kprobes.c
@@ -398,7 +398,8 @@ static void kretprobe_trampoline(void)
 
 int __kprobes trampoline_probe_handler(struct kprobe *p, struct pt_regs *regs)
 {
-	regs->cr_iip = __kretprobe_trampoline_handler(regs, kretprobe_trampoline, NULL);
+	regs->cr_iip = __kretprobe_trampoline_handler(regs,
+		dereference_function_descriptor(kretprobe_trampoline), NULL);
 	/*
 	 * By returning a non-zero value, we are telling
 	 * kprobe_handler() that we don't want the post_handler
@@ -414,7 +415,7 @@ void __kprobes arch_prepare_kretprobe(st
 	ri->fp = NULL;
 
 	/* Replace the return addr with trampoline addr */
-	regs->b0 = ((struct fnptr *)kretprobe_trampoline)->ip;
+	regs->b0 = (unsigned long)dereference_function_descriptor(kretprobe_trampoline);
 }
 
 /* Check the instruction in the slot is break */
@@ -918,14 +919,14 @@ static struct kprobe trampoline_p = {
 int __init arch_init_kprobes(void)
 {
 	trampoline_p.addr =
-		(kprobe_opcode_t *)((struct fnptr *)kretprobe_trampoline)->ip;
+		dereference_function_descriptor(kretprobe_trampoline);
 	return register_kprobe(&trampoline_p);
 }
 
 int __kprobes arch_trampoline_kprobe(struct kprobe *p)
 {
 	if (p->addr ==
-		(kprobe_opcode_t *)((struct fnptr *)kretprobe_trampoline)->ip)
+		dereference_function_descriptor(kretprobe_trampoline))
 		return 1;
 
 	return 0;


