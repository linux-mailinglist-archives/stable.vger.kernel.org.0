Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C231D252D0B
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 13:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729165AbgHZLyd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 07:54:33 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:14884 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729257AbgHZLyU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Aug 2020 07:54:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1598442859; x=1629978859;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=pKEDmrAi0WeO5TQzAX1yLEmkHIToya6bTxO+48zPR1E=;
  b=VMH+xXtqI0CZEHZjoGD4ARMTq9dISHTNqjEUZg4tYv/wGA3Nv3H2FFA9
   PAP/T0Gbu/yH9V0exXfKq08nqC2iv15DNJ4cinn9tTMe/cCV29N/yv1I6
   O4j1aT+nRFPB2THduWVmQBrgFJS2p1MEXHI1E0GtbWiuTLCXfsaJ824Dw
   s=;
X-IronPort-AV: E=Sophos;i="5.76,355,1592870400"; 
   d="scan'208";a="50004992"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2a-119b4f96.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 26 Aug 2020 11:54:14 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-119b4f96.us-west-2.amazon.com (Postfix) with ESMTPS id 0CF4D1A0453;
        Wed, 26 Aug 2020 11:54:12 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 26 Aug 2020 11:54:11 +0000
Received: from u79c5a0a55de558.ant.amazon.com (10.43.160.6) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 26 Aug 2020 11:54:04 +0000
From:   Alexander Graf <graf@amazon.com>
To:     X86 ML <x86@kernel.org>
CC:     Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Sean Christopherson" <sean.j.christopherson@intel.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Petr Mladek <pmladek@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        "Boris Ostrovsky" <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Will Deacon <will@kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Wei Liu <wei.liu@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        Jason Chen CJ <jason.cj.chen@intel.com>,
        Zhao Yakui <yakui.zhao@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Avi Kivity" <avi@scylladb.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>, <robketr@amazon.de>,
        <amos@scylladb.com>, Brian Gerst <brgerst@gmail.com>,
        <stable@vger.kernel.org>
Subject: [PATCH] x86/irq: Preserve vector in orig_ax for APIC code
Date:   Wed, 26 Aug 2020 13:53:57 +0200
Message-ID: <20200826115357.3049-1-graf@amazon.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.6]
X-ClientProxiedBy: EX13D25UWB001.ant.amazon.com (10.43.161.245) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 633260fa143 ("x86/irq: Convey vector as argument and not in ptregs")
changed the handover logic of the vector identifier from ~vector in orig_ax
to purely register based. Unfortunately, this field has another consumer
in the APIC code which the commit did not touch. The net result was that
IRQ balancing did not work and instead resulted in interrupt storms, slowing
down the system.

This patch restores the original semantics that orig_ax contains the vector.
When we receive an interrupt now, the actual vector number stays stored in
the orig_ax field which then gets consumed by the APIC code.

To ensure that nobody else trips over this in the future, the patch also adds
comments at strategic places to warn anyone who would refactor the code that
there is another consumer of the field.

With this patch in place, IRQ balancing works as expected and performance
levels are restored to previous levels.

Reported-by: Alex bykov <alex.bykov@scylladb.com>
Reported-by: Avi Kivity <avi@scylladb.com>
Fixes: 633260fa143 ("x86/irq: Convey vector as argument and not in ptregs")
Cc: stable@vger.kernel.org
Signed-off-by: Alexander Graf <graf@amazon.com>
---
 arch/x86/entry/entry_32.S     |  2 +-
 arch/x86/entry/entry_64.S     | 17 +++++++++++------
 arch/x86/kernel/apic/vector.c |  2 +-
 3 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
index df8c017..22e829c 100644
--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -727,7 +727,7 @@ SYM_CODE_START_LOCAL(asm_\cfunc)
 	ENCODE_FRAME_POINTER
 	movl	%esp, %eax
 	movl	PT_ORIG_EAX(%esp), %edx		/* get the vector from stack */
-	movl	$-1, PT_ORIG_EAX(%esp)		/* no syscall to restart */
+	/* keep vector on stack for APIC's irq_complete_move() */
 	call	\cfunc
 	jmp	handle_exception_return
 SYM_CODE_END(asm_\cfunc)
diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 70dea93..d78fb1c 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -319,7 +319,7 @@ SYM_CODE_END(ret_from_fork)
  * @cfunc:		C function to be called
  * @has_error_code:	Hardware pushed error code on stack
  */
-.macro idtentry_body cfunc has_error_code:req
+.macro idtentry_body cfunc has_error_code:req preserve_error_code:req
 
 	call	error_entry
 	UNWIND_HINT_REGS
@@ -328,7 +328,9 @@ SYM_CODE_END(ret_from_fork)
 
 	.if \has_error_code == 1
 		movq	ORIG_RAX(%rsp), %rsi	/* get error code into 2nd argument*/
-		movq	$-1, ORIG_RAX(%rsp)	/* no syscall to restart */
+		.if \preserve_error_code == 0
+			movq	$-1, ORIG_RAX(%rsp)	/* no syscall to restart */
+		.endif
 	.endif
 
 	call	\cfunc
@@ -346,7 +348,7 @@ SYM_CODE_END(ret_from_fork)
  * The macro emits code to set up the kernel context for straight forward
  * and simple IDT entries. No IST stack, no paranoid entry checks.
  */
-.macro idtentry vector asmsym cfunc has_error_code:req
+.macro idtentry vector asmsym cfunc has_error_code:req preserve_error_code=0
 SYM_CODE_START(\asmsym)
 	UNWIND_HINT_IRET_REGS offset=\has_error_code*8
 	ASM_CLAC
@@ -369,7 +371,7 @@ SYM_CODE_START(\asmsym)
 .Lfrom_usermode_no_gap_\@:
 	.endif
 
-	idtentry_body \cfunc \has_error_code
+	idtentry_body \cfunc \has_error_code \preserve_error_code
 
 _ASM_NOKPROBE(\asmsym)
 SYM_CODE_END(\asmsym)
@@ -382,11 +384,14 @@ SYM_CODE_END(\asmsym)
  * position of idtentry exceptions, and jump to one of the two idtentry points
  * (common/spurious).
  *
+ * The original vector number on the stack has to stay untouched, so that the
+ * APIC irq_complete_move() code can access it later on IRQ ack.
+ *
  * common_interrupt is a hotpath, align it to a cache line
  */
 .macro idtentry_irq vector cfunc
 	.p2align CONFIG_X86_L1_CACHE_SHIFT
-	idtentry \vector asm_\cfunc \cfunc has_error_code=1
+	idtentry \vector asm_\cfunc \cfunc has_error_code=1 preserve_error_code=1
 .endm
 
 /*
@@ -440,7 +445,7 @@ SYM_CODE_START(\asmsym)
 
 	/* Switch to the regular task stack and use the noist entry point */
 .Lfrom_usermode_switch_stack_\@:
-	idtentry_body noist_\cfunc, has_error_code=0
+	idtentry_body noist_\cfunc, has_error_code=0, preserve_error_code=0
 
 _ASM_NOKPROBE(\asmsym)
 SYM_CODE_END(\asmsym)
diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index dae32d9..e81b835 100644
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -924,7 +924,7 @@ static void __irq_complete_move(struct irq_cfg *cfg, unsigned vector)
 
 void irq_complete_move(struct irq_cfg *cfg)
 {
-	__irq_complete_move(cfg, ~get_irq_regs()->orig_ax);
+	__irq_complete_move(cfg, (u8)get_irq_regs()->orig_ax);
 }
 
 /*
-- 
1.8.3.1




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



