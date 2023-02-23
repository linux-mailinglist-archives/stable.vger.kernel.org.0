Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DDD06A09B9
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 14:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234362AbjBWNJk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 08:09:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234373AbjBWNJj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 08:09:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08219193C4
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 05:09:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE5BDB818D7
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 13:09:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21923C4339C;
        Thu, 23 Feb 2023 13:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677157766;
        bh=r9syxf5aiAKtbuK0oJ1hhricUaUkPaAs+iCIhBEDjxk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YxBxk+wW5Bb2FC3WxnnCznAah9ObXxftqchxDeVy2WR6BYdbegLGWOcgNUtELLRqq
         LzokSGxpuy2kT2Kd4gy3R0whT2dueSrzSRfDxmWzQpHqDhvrICnRP4KVj45xaMBs2j
         61/C43CDJNuPd1MUEXk3KH2AmT9ijbtxU8Z5i2j8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 6.1 30/46] x86/alternatives: Introduce int3_emulate_jcc()
Date:   Thu, 23 Feb 2023 14:06:37 +0100
Message-Id: <20230223130432.979033527@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130431.553657459@linuxfoundation.org>
References: <20230223130431.553657459@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit db7adcfd1cec4e95155e37bc066fddab302c6340 upstream.

Move the kprobe Jcc emulation into int3_emulate_jcc() so it can be
used by more code -- specifically static_call() will need this.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Link: https://lore.kernel.org/r/20230123210607.057678245@infradead.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/text-patching.h |   31 ++++++++++++++++++++++++++++
 arch/x86/kernel/kprobes/core.c       |   38 +++++++----------------------------
 2 files changed, 39 insertions(+), 30 deletions(-)

--- a/arch/x86/include/asm/text-patching.h
+++ b/arch/x86/include/asm/text-patching.h
@@ -183,6 +183,37 @@ void int3_emulate_ret(struct pt_regs *re
 	unsigned long ip = int3_emulate_pop(regs);
 	int3_emulate_jmp(regs, ip);
 }
+
+static __always_inline
+void int3_emulate_jcc(struct pt_regs *regs, u8 cc, unsigned long ip, unsigned long disp)
+{
+	static const unsigned long jcc_mask[6] = {
+		[0] = X86_EFLAGS_OF,
+		[1] = X86_EFLAGS_CF,
+		[2] = X86_EFLAGS_ZF,
+		[3] = X86_EFLAGS_CF | X86_EFLAGS_ZF,
+		[4] = X86_EFLAGS_SF,
+		[5] = X86_EFLAGS_PF,
+	};
+
+	bool invert = cc & 1;
+	bool match;
+
+	if (cc < 0xc) {
+		match = regs->flags & jcc_mask[cc >> 1];
+	} else {
+		match = ((regs->flags & X86_EFLAGS_SF) >> X86_EFLAGS_SF_BIT) ^
+			((regs->flags & X86_EFLAGS_OF) >> X86_EFLAGS_OF_BIT);
+		if (cc >= 0xe)
+			match = match || (regs->flags & X86_EFLAGS_ZF);
+	}
+
+	if ((match && !invert) || (!match && invert))
+		ip += disp;
+
+	int3_emulate_jmp(regs, ip);
+}
+
 #endif /* !CONFIG_UML_X86 */
 
 #endif /* _ASM_X86_TEXT_PATCHING_H */
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -471,50 +471,26 @@ static void kprobe_emulate_call(struct k
 }
 NOKPROBE_SYMBOL(kprobe_emulate_call);
 
-static nokprobe_inline
-void __kprobe_emulate_jmp(struct kprobe *p, struct pt_regs *regs, bool cond)
+static void kprobe_emulate_jmp(struct kprobe *p, struct pt_regs *regs)
 {
 	unsigned long ip = regs->ip - INT3_INSN_SIZE + p->ainsn.size;
 
-	if (cond)
-		ip += p->ainsn.rel32;
+	ip += p->ainsn.rel32;
 	int3_emulate_jmp(regs, ip);
 }
-
-static void kprobe_emulate_jmp(struct kprobe *p, struct pt_regs *regs)
-{
-	__kprobe_emulate_jmp(p, regs, true);
-}
 NOKPROBE_SYMBOL(kprobe_emulate_jmp);
 
-static const unsigned long jcc_mask[6] = {
-	[0] = X86_EFLAGS_OF,
-	[1] = X86_EFLAGS_CF,
-	[2] = X86_EFLAGS_ZF,
-	[3] = X86_EFLAGS_CF | X86_EFLAGS_ZF,
-	[4] = X86_EFLAGS_SF,
-	[5] = X86_EFLAGS_PF,
-};
-
 static void kprobe_emulate_jcc(struct kprobe *p, struct pt_regs *regs)
 {
-	bool invert = p->ainsn.jcc.type & 1;
-	bool match;
+	unsigned long ip = regs->ip - INT3_INSN_SIZE + p->ainsn.size;
 
-	if (p->ainsn.jcc.type < 0xc) {
-		match = regs->flags & jcc_mask[p->ainsn.jcc.type >> 1];
-	} else {
-		match = ((regs->flags & X86_EFLAGS_SF) >> X86_EFLAGS_SF_BIT) ^
-			((regs->flags & X86_EFLAGS_OF) >> X86_EFLAGS_OF_BIT);
-		if (p->ainsn.jcc.type >= 0xe)
-			match = match || (regs->flags & X86_EFLAGS_ZF);
-	}
-	__kprobe_emulate_jmp(p, regs, (match && !invert) || (!match && invert));
+	int3_emulate_jcc(regs, p->ainsn.jcc.type, ip, p->ainsn.rel32);
 }
 NOKPROBE_SYMBOL(kprobe_emulate_jcc);
 
 static void kprobe_emulate_loop(struct kprobe *p, struct pt_regs *regs)
 {
+	unsigned long ip = regs->ip - INT3_INSN_SIZE + p->ainsn.size;
 	bool match;
 
 	if (p->ainsn.loop.type != 3) {	/* LOOP* */
@@ -542,7 +518,9 @@ static void kprobe_emulate_loop(struct k
 	else if (p->ainsn.loop.type == 1)	/* LOOPE */
 		match = match && (regs->flags & X86_EFLAGS_ZF);
 
-	__kprobe_emulate_jmp(p, regs, match);
+	if (match)
+		ip += p->ainsn.rel32;
+	int3_emulate_jmp(regs, ip);
 }
 NOKPROBE_SYMBOL(kprobe_emulate_loop);
 


