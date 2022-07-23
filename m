Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C72F57ED77
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 11:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237444AbiGWJ5u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 05:57:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237531AbiGWJ5Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 05:57:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49577459BE;
        Sat, 23 Jul 2022 02:57:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3488B82C1B;
        Sat, 23 Jul 2022 09:57:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24944C341C0;
        Sat, 23 Jul 2022 09:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570220;
        bh=k54y2zJbA/r6+ZajALij55gOxoHlB2/hOqkPpqVghB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K5P9WFsi8eX+Nt+lEScIUzDPTzhOL6A0NwUNpS/gnED8jwy9DGX6t1ESBW2kCJLBr
         dDdHcXJgN4/Eq+2Cz5GhUWgiA9OVc9CmCbDN9AZ8ijbjez1D0lX/RNEYfGyGc8qw/3
         kIm/do2FBPazwLue6eGlDxdYheyxWqTQ3HzaSZOo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>, Ingo Molnar <mingo@kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 021/148] x86/alternatives: Optimize optimize_nops()
Date:   Sat, 23 Jul 2022 11:53:53 +0200
Message-Id: <20220723095230.410843401@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220723095224.302504400@linuxfoundation.org>
References: <20220723095224.302504400@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit 23c1ad538f4f371bdb67d8a112314842d5db7e5a upstream.

Currently, optimize_nops() scans to see if the alternative starts with
NOPs. However, the emit pattern is:

  141:	\oldinstr
  142:	.skip (len-(142b-141b)), 0x90

That is, when 'oldinstr' is short, the tail is padded with NOPs. This case
never gets optimized.

Rewrite optimize_nops() to replace any trailing string of NOPs inside
the alternative to larger NOPs. Also run it irrespective of patching,
replacing NOPs in both the original and replaced code.

A direct consequence is that 'padlen' becomes superfluous, so remove it.

 [ bp:
   - Adjust commit message
   - remove a stale comment about needing to pad
   - add a comment in optimize_nops()
   - exit early if the NOP verif. loop catches a mismatch - function
     should not not add NOPs in that case
   - fix the "optimized NOPs" offsets output ]

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lkml.kernel.org/r/20210326151259.442992235@infradead.org
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/alternative.h            |   17 ++-------
 arch/x86/kernel/alternative.c                 |   49 ++++++++++++++++----------
 tools/objtool/arch/x86/include/arch_special.h |    2 -
 3 files changed, 37 insertions(+), 31 deletions(-)

--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -65,7 +65,6 @@ struct alt_instr {
 	u16 cpuid;		/* cpuid bit set for replacement */
 	u8  instrlen;		/* length of original instruction */
 	u8  replacementlen;	/* length of new instruction */
-	u8  padlen;		/* length of build-time padding */
 } __packed;
 
 /*
@@ -104,7 +103,6 @@ static inline int alternatives_text_rese
 
 #define alt_end_marker		"663"
 #define alt_slen		"662b-661b"
-#define alt_pad_len		alt_end_marker"b-662b"
 #define alt_total_slen		alt_end_marker"b-661b"
 #define alt_rlen(num)		e_replacement(num)"f-"b_replacement(num)"f"
 
@@ -151,8 +149,7 @@ static inline int alternatives_text_rese
 	" .long " b_replacement(num)"f - .\n"		/* new instruction */ \
 	" .word " __stringify(feature) "\n"		/* feature bit     */ \
 	" .byte " alt_total_slen "\n"			/* source len      */ \
-	" .byte " alt_rlen(num) "\n"			/* replacement len */ \
-	" .byte " alt_pad_len "\n"			/* pad len */
+	" .byte " alt_rlen(num) "\n"			/* replacement len */
 
 #define ALTINSTR_REPLACEMENT(newinstr, feature, num)	/* replacement */	\
 	"# ALT: replacement " #num "\n"						\
@@ -224,9 +221,6 @@ static inline int alternatives_text_rese
  * Peculiarities:
  * No memory clobber here.
  * Argument numbers start with 1.
- * Best is to use constraints that are fixed size (like (%1) ... "r")
- * If you use variable sized constraints like "m" or "g" in the
- * replacement make sure to pad to the worst case length.
  * Leaving an unused argument 0 to keep API compatibility.
  */
 #define alternative_input(oldinstr, newinstr, feature, input...)	\
@@ -315,13 +309,12 @@ static inline int alternatives_text_rese
  * enough information for the alternatives patching code to patch an
  * instruction. See apply_alternatives().
  */
-.macro altinstruction_entry orig alt feature orig_len alt_len pad_len
+.macro altinstruction_entry orig alt feature orig_len alt_len
 	.long \orig - .
 	.long \alt - .
 	.word \feature
 	.byte \orig_len
 	.byte \alt_len
-	.byte \pad_len
 .endm
 
 /*
@@ -338,7 +331,7 @@ static inline int alternatives_text_rese
 142:
 
 	.pushsection .altinstructions,"a"
-	altinstruction_entry 140b,143f,\feature,142b-140b,144f-143f,142b-141b
+	altinstruction_entry 140b,143f,\feature,142b-140b,144f-143f
 	.popsection
 
 	.pushsection .altinstr_replacement,"ax"
@@ -375,8 +368,8 @@ static inline int alternatives_text_rese
 142:
 
 	.pushsection .altinstructions,"a"
-	altinstruction_entry 140b,143f,\feature1,142b-140b,144f-143f,142b-141b
-	altinstruction_entry 140b,144f,\feature2,142b-140b,145f-144f,142b-141b
+	altinstruction_entry 140b,143f,\feature1,142b-140b,144f-143f
+	altinstruction_entry 140b,144f,\feature2,142b-140b,145f-144f
 	.popsection
 
 	.pushsection .altinstr_replacement,"ax"
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -344,19 +344,35 @@ done:
 static void __init_or_module noinline optimize_nops(struct alt_instr *a, u8 *instr)
 {
 	unsigned long flags;
-	int i;
+	struct insn insn;
+	int nop, i = 0;
 
-	for (i = 0; i < a->padlen; i++) {
-		if (instr[i] != 0x90)
+	/*
+	 * Jump over the non-NOP insns, the remaining bytes must be single-byte
+	 * NOPs, optimize them.
+	 */
+	for (;;) {
+		if (insn_decode_kernel(&insn, &instr[i]))
+			return;
+
+		if (insn.length == 1 && insn.opcode.bytes[0] == 0x90)
+			break;
+
+		if ((i += insn.length) >= a->instrlen)
+			return;
+	}
+
+	for (nop = i; i < a->instrlen; i++) {
+		if (WARN_ONCE(instr[i] != 0x90, "Not a NOP at 0x%px\n", &instr[i]))
 			return;
 	}
 
 	local_irq_save(flags);
-	add_nops(instr + (a->instrlen - a->padlen), a->padlen);
+	add_nops(instr + nop, i - nop);
 	local_irq_restore(flags);
 
 	DUMP_BYTES(instr, a->instrlen, "%px: [%d:%d) optimized NOPs: ",
-		   instr, a->instrlen - a->padlen, a->padlen);
+		   instr, nop, a->instrlen);
 }
 
 /*
@@ -402,19 +418,15 @@ void __init_or_module noinline apply_alt
 		 * - feature not present but ALTINSTR_FLAG_INV is set to mean,
 		 *   patch if feature is *NOT* present.
 		 */
-		if (!boot_cpu_has(feature) == !(a->cpuid & ALTINSTR_FLAG_INV)) {
-			if (a->padlen > 1)
-				optimize_nops(a, instr);
-
-			continue;
-		}
+		if (!boot_cpu_has(feature) == !(a->cpuid & ALTINSTR_FLAG_INV))
+			goto next;
 
-		DPRINTK("feat: %s%d*32+%d, old: (%pS (%px) len: %d), repl: (%px, len: %d), pad: %d",
+		DPRINTK("feat: %s%d*32+%d, old: (%pS (%px) len: %d), repl: (%px, len: %d)",
 			(a->cpuid & ALTINSTR_FLAG_INV) ? "!" : "",
 			feature >> 5,
 			feature & 0x1f,
 			instr, instr, a->instrlen,
-			replacement, a->replacementlen, a->padlen);
+			replacement, a->replacementlen);
 
 		DUMP_BYTES(instr, a->instrlen, "%px: old_insn: ", instr);
 		DUMP_BYTES(replacement, a->replacementlen, "%px: rpl_insn: ", replacement);
@@ -438,14 +450,15 @@ void __init_or_module noinline apply_alt
 		if (a->replacementlen && is_jmp(replacement[0]))
 			recompute_jump(a, instr, replacement, insn_buff);
 
-		if (a->instrlen > a->replacementlen) {
-			add_nops(insn_buff + a->replacementlen,
-				 a->instrlen - a->replacementlen);
-			insn_buff_sz += a->instrlen - a->replacementlen;
-		}
+		for (; insn_buff_sz < a->instrlen; insn_buff_sz++)
+			insn_buff[insn_buff_sz] = 0x90;
+
 		DUMP_BYTES(insn_buff, insn_buff_sz, "%px: final_insn: ", instr);
 
 		text_poke_early(instr, insn_buff, insn_buff_sz);
+
+next:
+		optimize_nops(a, instr);
 	}
 }
 
--- a/tools/objtool/arch/x86/include/arch_special.h
+++ b/tools/objtool/arch/x86/include/arch_special.h
@@ -10,7 +10,7 @@
 #define JUMP_ORIG_OFFSET	0
 #define JUMP_NEW_OFFSET		4
 
-#define ALT_ENTRY_SIZE		13
+#define ALT_ENTRY_SIZE		12
 #define ALT_ORIG_OFFSET		0
 #define ALT_NEW_OFFSET		4
 #define ALT_FEATURE_OFFSET	8


