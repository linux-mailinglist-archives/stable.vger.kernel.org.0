Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99D682D9EA7
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 19:15:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408852AbgLNSGy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 13:06:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:50172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408604AbgLNRjT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:39:19 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Zabrocki <pi3@pi3.com.pl>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Borislav Petkov <bp@suse.de>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.9 104/105] x86/kprobes: Fix optprobe to detect INT3 padding correctly
Date:   Mon, 14 Dec 2020 18:29:18 +0100
Message-Id: <20201214172600.294754638@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214172555.280929671@linuxfoundation.org>
References: <20201214172555.280929671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

commit 0d07c0ec4381f630c801539c79ad8dcc627f6e4a upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/kprobes/opt.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/kprobes/opt.c
+++ b/arch/x86/kernel/kprobes/opt.c
@@ -271,6 +271,19 @@ static int insn_is_indirect_jump(struct
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
@@ -309,9 +322,14 @@ static int can_optimize(unsigned long pa
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


