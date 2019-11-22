Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A46B107027
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:20:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728016AbfKVLU3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:20:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:52558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727944AbfKVKpy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:45:54 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4EA320715;
        Fri, 22 Nov 2019 10:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419553;
        bh=cr3IUombf9EhZ71/I7ho4fT1dibD1bo/zsPTJKKMmA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yeyHu9jYJwigy7B3F99Wz2oytgOFIUcON5aQJDObFdyvScsqWe0usVWk/jfaZQrSG
         efuTaRqMKxLU/bd0qAkPa/h4H+b338Jtz0m5Hd2TMOsZCBTtLtVNcYIlPMalFMYAQi
         xKIefxytrPafGOEvxCMdaZLEXH4y3JPAUwbp0l7U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
        Francis Deslauriers <francis.deslauriers@efficios.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andy Lutomirski <luto@kernel.org>,
        "H . Peter Anvin" <hpa@zytor.com>, Yonghong Song <yhs@fb.com>,
        Borislav Petkov <bp@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 150/222] kprobes/x86: Prohibit probing on exception masking instructions
Date:   Fri, 22 Nov 2019 11:28:10 +0100
Message-Id: <20191122100913.582883301@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100830.874290814@linuxfoundation.org>
References: <20191122100830.874290814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

commit ee6a7354a3629f9b65bc18dbe393503e9440d6f5 upstream.

Since MOV SS and POP SS instructions will delay the exceptions until the
next instruction is executed, single-stepping on it by kprobes must be
prohibited.

However, kprobes usually executes those instructions directly on trampoline
buffer (a.k.a. kprobe-booster), except for the kprobes which has
post_handler. Thus if kprobe user probes MOV SS with post_handler, it will
do single-stepping on the MOV SS.

This means it is safe that if it is used via ftrace or perf/bpf since those
don't use the post_handler.

Anyway, since the stack switching is a rare case, it is safer just
rejecting kprobes on such instructions.

Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Cc: Francis Deslauriers <francis.deslauriers@efficios.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: "H . Peter Anvin" <hpa@zytor.com>
Cc: Yonghong Song <yhs@fb.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "David S . Miller" <davem@davemloft.net>
Link: https://lkml.kernel.org/r/152587069574.17316.3311695234863248641.stgit@devbox
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/insn.h    |   18 ++++++++++++++++++
 arch/x86/kernel/kprobes/core.c |    4 ++++
 2 files changed, 22 insertions(+)

--- a/arch/x86/include/asm/insn.h
+++ b/arch/x86/include/asm/insn.h
@@ -208,4 +208,22 @@ static inline int insn_offset_immediate(
 	return insn_offset_displacement(insn) + insn->displacement.nbytes;
 }
 
+#define POP_SS_OPCODE 0x1f
+#define MOV_SREG_OPCODE 0x8e
+
+/*
+ * Intel SDM Vol.3A 6.8.3 states;
+ * "Any single-step trap that would be delivered following the MOV to SS
+ * instruction or POP to SS instruction (because EFLAGS.TF is 1) is
+ * suppressed."
+ * This function returns true if @insn is MOV SS or POP SS. On these
+ * instructions, single stepping is suppressed.
+ */
+static inline int insn_masking_exception(struct insn *insn)
+{
+	return insn->opcode.bytes[0] == POP_SS_OPCODE ||
+		(insn->opcode.bytes[0] == MOV_SREG_OPCODE &&
+		 X86_MODRM_REG(insn->modrm.bytes[0]) == 2);
+}
+
 #endif /* _ASM_X86_INSN_H */
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -376,6 +376,10 @@ int __copy_instruction(u8 *dest, u8 *src
 		return 0;
 	memcpy(dest, insn.kaddr, length);
 
+	/* We should not singlestep on the exception masking instructions */
+	if (insn_masking_exception(&insn))
+		return 0;
+
 #ifdef CONFIG_X86_64
 	if (insn_rip_relative(&insn)) {
 		s64 newdisp;


