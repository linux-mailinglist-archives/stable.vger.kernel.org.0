Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D660520C6E
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 18:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726937AbfEPQEg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 12:04:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42400 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726637AbfEPP6m (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 11:58:42 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImD-0006yq-5i; Thu, 16 May 2019 16:58:37 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImC-0001NC-Mx; Thu, 16 May 2019 16:58:36 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "Ingo Molnar" <mingo@kernel.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>
Date:   Thu, 16 May 2019 16:55:33 +0100
Message-ID: <lsq.1558022133.165179930@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 11/86] jump_label: Rename JUMP_LABEL_{EN,DIS}ABLE to
 JUMP_LABEL_{JMP,NOP}
In-Reply-To: <lsq.1558022132.52852998@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.68-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

commit 76b235c6bcb16062d663e2ee96db0b69f2e6bc14 upstream.

Since we've already stepped away from ENABLE is a JMP and DISABLE is a
NOP with the branch_default bits, and are going to make it even worse,
rename it to make it all clearer.

This way we don't mix multiple levels of logic attributes, but have a
plain 'physical' name for what the current instruction patching status
of a jump label is.

This is a first step in removing the naming confusion that has led to
a stream of avoidable bugs such as:

  a833581e372a ("x86, perf: Fix static_key bug in load_mm_cr4()")

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
[ Beefed up the changelog. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/kernel/jump_label.c     |  2 +-
 arch/arm64/kernel/jump_label.c   |  2 +-
 arch/mips/kernel/jump_label.c    |  2 +-
 arch/powerpc/kernel/jump_label.c |  2 +-
 arch/s390/kernel/jump_label.c    |  2 +-
 arch/sparc/kernel/jump_label.c   |  2 +-
 arch/x86/kernel/jump_label.c     |  2 +-
 include/linux/jump_label.h       |  4 ++--
 kernel/jump_label.c              | 18 +++++++++---------
 9 files changed, 18 insertions(+), 18 deletions(-)

--- a/arch/arm/kernel/jump_label.c
+++ b/arch/arm/kernel/jump_label.c
@@ -13,7 +13,7 @@ static void __arch_jump_label_transform(
 	void *addr = (void *)entry->code;
 	unsigned int insn;
 
-	if (type == JUMP_LABEL_ENABLE)
+	if (type == JUMP_LABEL_JMP)
 		insn = arm_gen_branch(entry->code, entry->target);
 	else
 		insn = arm_gen_nop();
--- a/arch/arm64/kernel/jump_label.c
+++ b/arch/arm64/kernel/jump_label.c
@@ -29,7 +29,7 @@ static void __arch_jump_label_transform(
 	void *addr = (void *)entry->code;
 	u32 insn;
 
-	if (type == JUMP_LABEL_ENABLE) {
+	if (type == JUMP_LABEL_JMP) {
 		insn = aarch64_insn_gen_branch_imm(entry->code,
 						   entry->target,
 						   AARCH64_INSN_BRANCH_NOLINK);
--- a/arch/mips/kernel/jump_label.c
+++ b/arch/mips/kernel/jump_label.c
@@ -51,7 +51,7 @@ void arch_jump_label_transform(struct ju
 	/* Target must have the right alignment and ISA must be preserved. */
 	BUG_ON((e->target & J_ALIGN_MASK) != J_ISA_BIT);
 
-	if (type == JUMP_LABEL_ENABLE) {
+	if (type == JUMP_LABEL_JMP) {
 		insn.j_format.opcode = J_ISA_BIT ? mm_j32_op : j_op;
 		insn.j_format.target = e->target >> J_RANGE_SHIFT;
 	} else {
--- a/arch/powerpc/kernel/jump_label.c
+++ b/arch/powerpc/kernel/jump_label.c
@@ -17,7 +17,7 @@ void arch_jump_label_transform(struct ju
 {
 	u32 *addr = (u32 *)(unsigned long)entry->code;
 
-	if (type == JUMP_LABEL_ENABLE)
+	if (type == JUMP_LABEL_JMP)
 		patch_branch(addr, entry->target, 0);
 	else
 		patch_instruction(addr, PPC_INST_NOP);
--- a/arch/s390/kernel/jump_label.c
+++ b/arch/s390/kernel/jump_label.c
@@ -60,7 +60,7 @@ static void __jump_label_transform(struc
 {
 	struct insn old, new;
 
-	if (type == JUMP_LABEL_ENABLE) {
+	if (type == JUMP_LABEL_JMP) {
 		jump_label_make_nop(entry, &old);
 		jump_label_make_branch(entry, &new);
 	} else {
--- a/arch/sparc/kernel/jump_label.c
+++ b/arch/sparc/kernel/jump_label.c
@@ -16,7 +16,7 @@ void arch_jump_label_transform(struct ju
 	u32 val;
 	u32 *insn = (u32 *) (unsigned long) entry->code;
 
-	if (type == JUMP_LABEL_ENABLE) {
+	if (type == JUMP_LABEL_JMP) {
 		s32 off = (s32)entry->target - (s32)entry->code;
 
 #ifdef CONFIG_SPARC64
--- a/arch/x86/kernel/jump_label.c
+++ b/arch/x86/kernel/jump_label.c
@@ -45,7 +45,7 @@ static void __jump_label_transform(struc
 	const unsigned char default_nop[] = { STATIC_KEY_INIT_NOP };
 	const unsigned char *ideal_nop = ideal_nops[NOP_ATOMIC5];
 
-	if (type == JUMP_LABEL_ENABLE) {
+	if (type == JUMP_LABEL_JMP) {
 		if (init) {
 			/*
 			 * Jump label is enabled for the first time.
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -86,8 +86,8 @@ struct static_key {
 #ifndef __ASSEMBLY__
 
 enum jump_label_type {
-	JUMP_LABEL_DISABLE = 0,
-	JUMP_LABEL_ENABLE,
+	JUMP_LABEL_NOP = 0,
+	JUMP_LABEL_JMP,
 };
 
 struct module;
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -65,9 +65,9 @@ void static_key_slow_inc(struct static_k
 	jump_label_lock();
 	if (atomic_read(&key->enabled) == 0) {
 		if (!jump_label_get_branch_default(key))
-			jump_label_update(key, JUMP_LABEL_ENABLE);
+			jump_label_update(key, JUMP_LABEL_JMP);
 		else
-			jump_label_update(key, JUMP_LABEL_DISABLE);
+			jump_label_update(key, JUMP_LABEL_NOP);
 	}
 	atomic_inc(&key->enabled);
 	jump_label_unlock();
@@ -88,9 +88,9 @@ static void __static_key_slow_dec(struct
 		schedule_delayed_work(work, rate_limit);
 	} else {
 		if (!jump_label_get_branch_default(key))
-			jump_label_update(key, JUMP_LABEL_DISABLE);
+			jump_label_update(key, JUMP_LABEL_NOP);
 		else
-			jump_label_update(key, JUMP_LABEL_ENABLE);
+			jump_label_update(key, JUMP_LABEL_JMP);
 	}
 	jump_label_unlock();
 }
@@ -191,9 +191,9 @@ static enum jump_label_type jump_label_t
 	bool state = static_key_enabled(key);
 
 	if ((!true_branch && state) || (true_branch && !state))
-		return JUMP_LABEL_ENABLE;
+		return JUMP_LABEL_JMP;
 
-	return JUMP_LABEL_DISABLE;
+	return JUMP_LABEL_NOP;
 }
 
 void __init jump_label_init(void)
@@ -283,7 +283,7 @@ void jump_label_apply_nops(struct module
 		return;
 
 	for (iter = iter_start; iter < iter_stop; iter++) {
-		arch_jump_label_transform_static(iter, JUMP_LABEL_DISABLE);
+		arch_jump_label_transform_static(iter, JUMP_LABEL_NOP);
 	}
 }
 
@@ -325,8 +325,8 @@ static int jump_label_add_module(struct
 		jlm->next = key->next;
 		key->next = jlm;
 
-		if (jump_label_type(key) == JUMP_LABEL_ENABLE)
-			__jump_label_update(key, iter, iter_stop, JUMP_LABEL_ENABLE);
+		if (jump_label_type(key) == JUMP_LABEL_JMP)
+			__jump_label_update(key, iter, iter_stop, JUMP_LABEL_JMP);
 	}
 
 	return 0;

