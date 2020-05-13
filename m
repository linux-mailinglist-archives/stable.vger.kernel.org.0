Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99D0B1D0F1C
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 12:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732847AbgEMJrY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:47:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:45282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732844AbgEMJrX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:47:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 037CF2078C;
        Wed, 13 May 2020 09:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363242;
        bh=RrYNDVF9HXul2vNPsToXe3YIBU4nNCaxQyFAzTw5/zQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Od+COt4W3NfFV/8L7ORGjZONFW7mAfJh6f6UPr7wCs4sLSfl5pIwMZloPsuLV+443
         JsHiVGOb/+kb6fDRoJVRKXrKfpAdOkuO+rsOBMpkglBVenH11ssW0BHqdQUF77ryyg
         xACoV6BFzvLASwmb8EhCWKlfml9G/QF1XZnO6j6s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Andy Lutomirski <luto@kernel.org>, Dave Jones <dsj@fb.com>,
        Jann Horn <jannh@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vincent.weaver@maine.edu>
Subject: [PATCH 4.19 43/48] x86/unwind/orc: Fix premature unwind stoppage due to IRET frames
Date:   Wed, 13 May 2020 11:45:09 +0200
Message-Id: <20200513094403.458754310@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094351.100352960@linuxfoundation.org>
References: <20200513094351.100352960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@redhat.com>

commit 81b67439d147677d844d492fcbd03712ea438f42 upstream.

The following execution path is possible:

  fsnotify()
    [ realign the stack and store previous SP in R10 ]
    <IRQ>
      [ only IRET regs saved ]
      common_interrupt()
        interrupt_entry()
	  <NMI>
	    [ full pt_regs saved ]
	    ...
	    [ unwind stack ]

When the unwinder goes through the NMI and the IRQ on the stack, and
then sees fsnotify(), it doesn't have access to the value of R10,
because it only has the five IRET registers.  So the unwind stops
prematurely.

However, because the interrupt_entry() code is careful not to clobber
R10 before saving the full regs, the unwinder should be able to read R10
from the previously saved full pt_regs associated with the NMI.

Handle this case properly.  When encountering an IRET regs frame
immediately after a full pt_regs frame, use the pt_regs as a backup
which can be used to get the C register values.

Also, note that a call frame resets the 'prev_regs' value, because a
function is free to clobber the registers.  For this fix to work, the
IRET and full regs frames must be adjacent, with no FUNC frames in
between.  So replace the FUNC hint in interrupt_entry() with an
IRET_REGS hint.

Fixes: ee9f8fce9964 ("x86/unwind: Add the ORC unwinder")
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Dave Jones <dsj@fb.com>
Cc: Jann Horn <jannh@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Link: https://lore.kernel.org/r/97a408167cc09f1cfa0de31a7b70dd88868d743f.1587808742.git.jpoimboe@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/entry/entry_64.S     |    4 +--
 arch/x86/include/asm/unwind.h |    2 -
 arch/x86/kernel/unwind_orc.c  |   51 ++++++++++++++++++++++++++++++++----------
 3 files changed, 43 insertions(+), 14 deletions(-)

--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -575,7 +575,7 @@ END(spurious_entries_start)
  * +----------------------------------------------------+
  */
 ENTRY(interrupt_entry)
-	UNWIND_HINT_FUNC
+	UNWIND_HINT_IRET_REGS offset=16
 	ASM_CLAC
 	cld
 
@@ -607,9 +607,9 @@ ENTRY(interrupt_entry)
 	pushq	5*8(%rdi)		/* regs->eflags */
 	pushq	4*8(%rdi)		/* regs->cs */
 	pushq	3*8(%rdi)		/* regs->ip */
+	UNWIND_HINT_IRET_REGS
 	pushq	2*8(%rdi)		/* regs->orig_ax */
 	pushq	8(%rdi)			/* return address */
-	UNWIND_HINT_FUNC
 
 	movq	(%rdi), %rdi
 	jmp	2f
--- a/arch/x86/include/asm/unwind.h
+++ b/arch/x86/include/asm/unwind.h
@@ -19,7 +19,7 @@ struct unwind_state {
 #if defined(CONFIG_UNWINDER_ORC)
 	bool signal, full_regs;
 	unsigned long sp, bp, ip;
-	struct pt_regs *regs;
+	struct pt_regs *regs, *prev_regs;
 #elif defined(CONFIG_UNWINDER_FRAME_POINTER)
 	bool got_irq;
 	unsigned long *bp, *orig_sp, ip;
--- a/arch/x86/kernel/unwind_orc.c
+++ b/arch/x86/kernel/unwind_orc.c
@@ -364,9 +364,38 @@ static bool deref_stack_iret_regs(struct
 	return true;
 }
 
+/*
+ * If state->regs is non-NULL, and points to a full pt_regs, just get the reg
+ * value from state->regs.
+ *
+ * Otherwise, if state->regs just points to IRET regs, and the previous frame
+ * had full regs, it's safe to get the value from the previous regs.  This can
+ * happen when early/late IRQ entry code gets interrupted by an NMI.
+ */
+static bool get_reg(struct unwind_state *state, unsigned int reg_off,
+		    unsigned long *val)
+{
+	unsigned int reg = reg_off/8;
+
+	if (!state->regs)
+		return false;
+
+	if (state->full_regs) {
+		*val = ((unsigned long *)state->regs)[reg];
+		return true;
+	}
+
+	if (state->prev_regs) {
+		*val = ((unsigned long *)state->prev_regs)[reg];
+		return true;
+	}
+
+	return false;
+}
+
 bool unwind_next_frame(struct unwind_state *state)
 {
-	unsigned long ip_p, sp, orig_ip = state->ip, prev_sp = state->sp;
+	unsigned long ip_p, sp, tmp, orig_ip = state->ip, prev_sp = state->sp;
 	enum stack_type prev_type = state->stack_info.type;
 	struct orc_entry *orc;
 	bool indirect = false;
@@ -420,39 +449,35 @@ bool unwind_next_frame(struct unwind_sta
 		break;
 
 	case ORC_REG_R10:
-		if (!state->regs || !state->full_regs) {
+		if (!get_reg(state, offsetof(struct pt_regs, r10), &sp)) {
 			orc_warn("missing regs for base reg R10 at ip %pB\n",
 				 (void *)state->ip);
 			goto err;
 		}
-		sp = state->regs->r10;
 		break;
 
 	case ORC_REG_R13:
-		if (!state->regs || !state->full_regs) {
+		if (!get_reg(state, offsetof(struct pt_regs, r13), &sp)) {
 			orc_warn("missing regs for base reg R13 at ip %pB\n",
 				 (void *)state->ip);
 			goto err;
 		}
-		sp = state->regs->r13;
 		break;
 
 	case ORC_REG_DI:
-		if (!state->regs || !state->full_regs) {
+		if (!get_reg(state, offsetof(struct pt_regs, di), &sp)) {
 			orc_warn("missing regs for base reg DI at ip %pB\n",
 				 (void *)state->ip);
 			goto err;
 		}
-		sp = state->regs->di;
 		break;
 
 	case ORC_REG_DX:
-		if (!state->regs || !state->full_regs) {
+		if (!get_reg(state, offsetof(struct pt_regs, dx), &sp)) {
 			orc_warn("missing regs for base reg DX at ip %pB\n",
 				 (void *)state->ip);
 			goto err;
 		}
-		sp = state->regs->dx;
 		break;
 
 	default:
@@ -479,6 +504,7 @@ bool unwind_next_frame(struct unwind_sta
 
 		state->sp = sp;
 		state->regs = NULL;
+		state->prev_regs = NULL;
 		state->signal = false;
 		break;
 
@@ -490,6 +516,7 @@ bool unwind_next_frame(struct unwind_sta
 		}
 
 		state->regs = (struct pt_regs *)sp;
+		state->prev_regs = NULL;
 		state->full_regs = true;
 		state->signal = true;
 		break;
@@ -501,6 +528,8 @@ bool unwind_next_frame(struct unwind_sta
 			goto err;
 		}
 
+		if (state->full_regs)
+			state->prev_regs = state->regs;
 		state->regs = (void *)sp - IRET_FRAME_OFFSET;
 		state->full_regs = false;
 		state->signal = true;
@@ -515,8 +544,8 @@ bool unwind_next_frame(struct unwind_sta
 	/* Find BP: */
 	switch (orc->bp_reg) {
 	case ORC_REG_UNDEFINED:
-		if (state->regs && state->full_regs)
-			state->bp = state->regs->bp;
+		if (get_reg(state, offsetof(struct pt_regs, bp), &tmp))
+			state->bp = tmp;
 		break;
 
 	case ORC_REG_PREV_SP:


