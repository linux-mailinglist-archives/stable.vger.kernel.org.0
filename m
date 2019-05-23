Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A244528A9A
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388625AbfEWTRG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:17:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:52038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389324AbfEWTRF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:17:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CCAE217D7;
        Thu, 23 May 2019 19:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639024;
        bh=XFhrtsUL1o+rolGZzldp8QSySivSoj1p9dgQVoD3BCY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JJgvWfCbv7lPii9++AH4mG9yjhBFopL27mHT3ZCagW5Z3vEZQ03i8xwnqbKuqBkHC
         j5rzp873KlA3BOuuqnJHuvVolyIBV/kcGCj+tu8nEJrWfYOAxGEMtPJAzhQSd3E1Fl
         iF261HqaczaByrflTGUNpDOkD/zhS38aUs8rYoUg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolai Stange <nstange@suse.de>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.19 051/114] x86_64: Add gap to int3 to allow for call emulation
Date:   Thu, 23 May 2019 21:05:50 +0200
Message-Id: <20190523181736.322629716@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181731.372074275@linuxfoundation.org>
References: <20190523181731.372074275@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@redhat.com>

commit 2700fefdb2d9751c416ad56897e27d41e409324a upstream.

To allow an int3 handler to emulate a call instruction, it must be able to
push a return address onto the stack. Add a gap to the stack to allow the
int3 handler to push the return address and change the return from int3 to
jump straight to the emulated called function target.

Link: http://lkml.kernel.org/r/20181130183917.hxmti5josgq4clti@treble
Link: http://lkml.kernel.org/r/20190502162133.GX2623@hirez.programming.kicks-ass.net

[
  Note, this is needed to allow Live Kernel Patching to not miss calling a
  patched function when tracing is enabled. -- Steven Rostedt
]

Cc: stable@vger.kernel.org
Fixes: b700e7f03df5 ("livepatch: kernel: add support for live patching")
Tested-by: Nicolai Stange <nstange@suse.de>
Reviewed-by: Nicolai Stange <nstange@suse.de>
Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/entry/entry_64.S |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -905,7 +905,7 @@ apicinterrupt IRQ_WORK_VECTOR			irq_work
  */
 #define CPU_TSS_IST(x) PER_CPU_VAR(cpu_tss_rw) + (TSS_ist + ((x) - 1) * 8)
 
-.macro idtentry sym do_sym has_error_code:req paranoid=0 shift_ist=-1
+.macro idtentry sym do_sym has_error_code:req paranoid=0 shift_ist=-1 create_gap=0
 ENTRY(\sym)
 	UNWIND_HINT_IRET_REGS offset=\has_error_code*8
 
@@ -925,6 +925,20 @@ ENTRY(\sym)
 	jnz	.Lfrom_usermode_switch_stack_\@
 	.endif
 
+	.if \create_gap == 1
+	/*
+	 * If coming from kernel space, create a 6-word gap to allow the
+	 * int3 handler to emulate a call instruction.
+	 */
+	testb	$3, CS-ORIG_RAX(%rsp)
+	jnz	.Lfrom_usermode_no_gap_\@
+	.rept	6
+	pushq	5*8(%rsp)
+	.endr
+	UNWIND_HINT_IRET_REGS offset=8
+.Lfrom_usermode_no_gap_\@:
+	.endif
+
 	.if \paranoid
 	call	paranoid_entry
 	.else
@@ -1154,7 +1168,7 @@ apicinterrupt3 HYPERV_STIMER0_VECTOR \
 #endif /* CONFIG_HYPERV */
 
 idtentry debug			do_debug		has_error_code=0	paranoid=1 shift_ist=DEBUG_STACK
-idtentry int3			do_int3			has_error_code=0
+idtentry int3			do_int3			has_error_code=0	create_gap=1
 idtentry stack_segment		do_stack_segment	has_error_code=1
 
 #ifdef CONFIG_XEN


