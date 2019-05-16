Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E13C820C62
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 18:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbfEPP6k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 11:58:40 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42328 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726409AbfEPP6k (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 11:58:40 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImC-0006yj-U0; Thu, 16 May 2019 16:58:37 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImC-0001Mg-ER; Thu, 16 May 2019 16:58:36 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Maciej W. Rozycki" <macro@codesourcery.com>,
        linux-mips@linux-mips.org, "Ralf Baechle" <ralf@linux-mips.org>
Date:   Thu, 16 May 2019 16:55:32 +0100
Message-ID: <lsq.1558022132.250828593@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 05/86] MIPS: jump_label.c: Handle the microMIPS J
 instruction encoding
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

From: "Maciej W. Rozycki" <macro@codesourcery.com>

commit 935c2dbec4d6d3163ee8e7409996904a734ad89a upstream.

Implement the microMIPS encoding of the J instruction for the purpose of
the static keys feature, fixing a crash early on in bootstrap as the
kernel is unhappy seeing the ISA bit set in jump table entries.  Make
sure the ISA bit correctly reflects the instruction encoding chosen for
the kernel, 0 for the standard MIPS and 1 for the microMIPS encoding.

Also make sure the instruction to patch is a 32-bit NOP in the microMIPS
mode as by default the 16-bit short encoding is assumed

Signed-off-by: Maciej W. Rozycki <macro@codesourcery.com>
Cc: linux-mips@linux-mips.org
Patchwork: https://patchwork.linux-mips.org/patch/8516/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/mips/include/asm/jump_label.h |  8 +++++-
 arch/mips/kernel/jump_label.c      | 40 +++++++++++++++++++++++-------
 2 files changed, 38 insertions(+), 10 deletions(-)

--- a/arch/mips/include/asm/jump_label.h
+++ b/arch/mips/include/asm/jump_label.h
@@ -20,9 +20,15 @@
 #define WORD_INSN ".word"
 #endif
 
+#ifdef CONFIG_CPU_MICROMIPS
+#define NOP_INSN "nop32"
+#else
+#define NOP_INSN "nop"
+#endif
+
 static __always_inline bool arch_static_branch(struct static_key *key)
 {
-	asm_volatile_goto("1:\tnop\n\t"
+	asm_volatile_goto("1:\t" NOP_INSN "\n\t"
 		"nop\n\t"
 		".pushsection __jump_table,  \"aw\"\n\t"
 		WORD_INSN " 1b, %l[l_yes], %0\n\t"
--- a/arch/mips/kernel/jump_label.c
+++ b/arch/mips/kernel/jump_label.c
@@ -18,31 +18,53 @@
 
 #ifdef HAVE_JUMP_LABEL
 
-#define J_RANGE_MASK ((1ul << 28) - 1)
+/*
+ * Define parameters for the standard MIPS and the microMIPS jump
+ * instruction encoding respectively:
+ *
+ * - the ISA bit of the target, either 0 or 1 respectively,
+ *
+ * - the amount the jump target address is shifted right to fit in the
+ *   immediate field of the machine instruction, either 2 or 1,
+ *
+ * - the mask determining the size of the jump region relative to the
+ *   delay-slot instruction, either 256MB or 128MB,
+ *
+ * - the jump target alignment, either 4 or 2 bytes.
+ */
+#define J_ISA_BIT	IS_ENABLED(CONFIG_CPU_MICROMIPS)
+#define J_RANGE_SHIFT	(2 - J_ISA_BIT)
+#define J_RANGE_MASK	((1ul << (26 + J_RANGE_SHIFT)) - 1)
+#define J_ALIGN_MASK	((1ul << J_RANGE_SHIFT) - 1)
 
 void arch_jump_label_transform(struct jump_entry *e,
 			       enum jump_label_type type)
 {
+	union mips_instruction *insn_p;
 	union mips_instruction insn;
-	union mips_instruction *insn_p =
-		(union mips_instruction *)(unsigned long)e->code;
 
-	/* Jump only works within a 256MB aligned region of its delay slot. */
+	insn_p = (union mips_instruction *)msk_isa16_mode(e->code);
+
+	/* Jump only works within an aligned region its delay slot is in. */
 	BUG_ON((e->target & ~J_RANGE_MASK) != ((e->code + 4) & ~J_RANGE_MASK));
 
-	/* Target must have 4 byte alignment. */
-	BUG_ON((e->target & 3) != 0);
+	/* Target must have the right alignment and ISA must be preserved. */
+	BUG_ON((e->target & J_ALIGN_MASK) != J_ISA_BIT);
 
 	if (type == JUMP_LABEL_ENABLE) {
-		insn.j_format.opcode = j_op;
-		insn.j_format.target = (e->target & J_RANGE_MASK) >> 2;
+		insn.j_format.opcode = J_ISA_BIT ? mm_j32_op : j_op;
+		insn.j_format.target = e->target >> J_RANGE_SHIFT;
 	} else {
 		insn.word = 0; /* nop */
 	}
 
 	get_online_cpus();
 	mutex_lock(&text_mutex);
-	*insn_p = insn;
+	if (IS_ENABLED(CONFIG_CPU_MICROMIPS)) {
+		insn_p->halfword[0] = insn.word >> 16;
+		insn_p->halfword[1] = insn.word;
+	} else
+		*insn_p = insn;
 
 	flush_icache_range((unsigned long)insn_p,
 			   (unsigned long)insn_p + sizeof(*insn_p));

