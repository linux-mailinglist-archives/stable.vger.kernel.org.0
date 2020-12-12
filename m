Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 972842D871F
	for <lists+stable@lfdr.de>; Sat, 12 Dec 2020 15:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439190AbgLLOi7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Dec 2020 09:38:59 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:41716 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439184AbgLLOiu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Dec 2020 09:38:50 -0500
Date:   Sat, 12 Dec 2020 14:38:04 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1607783886;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ctoc9ZBF8Rtp6rNRB1dSMwhG6BZtNY2Za0ZLFtdoy2k=;
        b=hKVuucGP6bageM/i+G5OWrlD3jFannQmm+A7c+Cgr+9p8IGHgjiH+6zavai8iDmBSdGr2k
        NlT41mkhrFc1w96yJvKr1x5ohodGfUipoEZsLy9NNp0VjW/Vpe1Nwh2gRiPIqgcozN8hdG
        NKIL3fiX6Ai4gBaVNpBorAQGS2GSDsY1sfDHZa7mfJx8Yeb8qaTK76/4LM0R8rImpTiChB
        pmHa8eaRMnIzkXx6qX7PeuKlGHSIKBaUXvyTrecSeV+POD1XwsnGf4UCEkDsW9oYmu1RUS
        oTxPEoRHKl0Zj4yLcD/y3FBVCfFYnpc+0aMY7kQg8w8eYi5d9i1METLC6jO2jw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1607783886;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ctoc9ZBF8Rtp6rNRB1dSMwhG6BZtNY2Za0ZLFtdoy2k=;
        b=yfC/I915/0Z8RBZnvi3rLjsimCUyQFIa6vntpR7D6tm/90KvB3bu4Q8NX/bvyo9BpthXgD
        2+k6vnesi1GGu0CQ==
From:   "tip-bot2 for Masami Hiramatsu" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/kprobes: Fix optprobe to detect INT3 padding correctly
Cc:     Adam Zabrocki <pi3@pi3.com.pl>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Borislav Petkov <bp@suse.de>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Kees Cook <keescook@chromium.org>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <160767025681.3880685.16021570341428835411.stgit@devnote2>
References: <160767025681.3880685.16021570341428835411.stgit@devnote2>
MIME-Version: 1.0
Message-ID: <160778388491.3364.18100034608128839164.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     0d07c0ec4381f630c801539c79ad8dcc627f6e4a
Gitweb:        https://git.kernel.org/tip/0d07c0ec4381f630c801539c79ad8dcc627f6e4a
Author:        Masami Hiramatsu <mhiramat@kernel.org>
AuthorDate:    Fri, 11 Dec 2020 16:04:17 +09:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Sat, 12 Dec 2020 15:25:17 +01:00

x86/kprobes: Fix optprobe to detect INT3 padding correctly

Commit

  7705dc855797 ("x86/vmlinux: Use INT3 instead of NOP for linker fill bytes")

changed the padding bytes between functions from NOP to INT3. However,
when optprobe decodes a target function it finds INT3 and gives up the
jump optimization.

Instead of giving up any INT3 detection, check whether the rest of the
bytes to the end of the function are INT3. If all of them are INT3,
those come from the linker. In that case, continue the optprobe jump
optimization.

 [ bp: Massage commit message. ]

Fixes: 7705dc855797 ("x86/vmlinux: Use INT3 instead of NOP for linker fill bytes")
Reported-by: Adam Zabrocki <pi3@pi3.com.pl>
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/160767025681.3880685.16021570341428835411.stgit@devnote2
---
 arch/x86/kernel/kprobes/opt.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/kprobes/opt.c b/arch/x86/kernel/kprobes/opt.c
index 041f0b5..08eb230 100644
--- a/arch/x86/kernel/kprobes/opt.c
+++ b/arch/x86/kernel/kprobes/opt.c
@@ -272,6 +272,19 @@ static int insn_is_indirect_jump(struct insn *insn)
 	return ret;
 }
 
+static bool is_padding_int3(unsigned long addr, unsigned long eaddr)
+{
+	unsigned char ops;
+
+	for (; addr < eaddr; addr++) {
+		if (get_kernel_nofault(ops, (void *)addr) < 0 ||
+		    ops != INT3_INSN_OPCODE)
+			return false;
+	}
+
+	return true;
+}
+
 /* Decode whole function to ensure any instructions don't jump into target */
 static int can_optimize(unsigned long paddr)
 {
@@ -310,9 +323,14 @@ static int can_optimize(unsigned long paddr)
 			return 0;
 		kernel_insn_init(&insn, (void *)recovered_insn, MAX_INSN_SIZE);
 		insn_get_length(&insn);
-		/* Another subsystem puts a breakpoint */
+		/*
+		 * In the case of detecting unknown breakpoint, this could be
+		 * a padding INT3 between functions. Let's check that all the
+		 * rest of the bytes are also INT3.
+		 */
 		if (insn.opcode.bytes[0] == INT3_INSN_OPCODE)
-			return 0;
+			return is_padding_int3(addr, paddr - offset + size) ? 1 : 0;
+
 		/* Recover address */
 		insn.kaddr = (void *)addr;
 		insn.next_byte = (void *)(addr + insn.length);
