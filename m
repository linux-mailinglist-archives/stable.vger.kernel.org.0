Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 937A512B6C
	for <lists+stable@lfdr.de>; Fri,  3 May 2019 12:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727589AbfECKXa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 May 2019 06:23:30 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34640 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727328AbfECKX3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 May 2019 06:23:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=yWINozWi4B8/0b+zeQRxYewAS+koeusVmFIImsL4ACM=; b=e3Z24GLl2UD/i7MtfoO9Zn+1s
        aOjqo4XYiaU6TA4EV7N+9AsJHT1zV27NytuQBr1YvJk6KUbqMVuYruylM99/m1WUuogmdZ/56St5b
        4dmoglSTjnQKMD8FuO8PU2p9eqckaGA3fsfa2GL1IN6EyCVKr1vUbgck9GTdg4dvIJmje97LlunJh
        7hYWE4A5NB1Ajh1PQ8h5bKtPEGwJ1sSQdUttdLPEm0WqLP8EnAN+3sVGhPhbHhQYu2MNod/SEGcp6
        jp7B8sDaoNH+JOzA8oC4AmS/UUeCHQ7BX+I7txb282udOd86t/J7BaBok6Q66wPX1KuZ/83fY21o3
        EEAvVY+cQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hMVL9-0003jO-J4; Fri, 03 May 2019 10:22:51 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 15C5E29B65EA1; Fri,  3 May 2019 12:22:47 +0200 (CEST)
Date:   Fri, 3 May 2019 12:22:47 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Nicolai Stange <nstange@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Shuah Khan <shuah@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Juergen Gross <jgross@suse.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nayna Jain <nayna@linux.ibm.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Joerg Roedel <jroedel@suse.de>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, stable <stable@vger.kernel.org>
Subject: [RFC][PATCH 1.5/2] x86: Add int3_emulate_call() selftest
Message-ID: <20190503102247.GC2623@hirez.programming.kicks-ass.net>
References: <20190501202830.347656894@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190501202830.347656894@goodmis.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Given that the entry_*.S changes for this functionality are somewhat
tricky, make sure the paths are tested every boot, instead of on the
rare occasion when we trip an INT3 while rewriting text.

Getting the INT3 frame setup even slightly wrong will make this come
unstuck something spectacular.

Requested-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/kernel/alternative.c | 81 ++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 77 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 4db9c0d29bc1..2b853c2ab894 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -613,11 +613,83 @@ extern struct paravirt_patch_site __start_parainstructions[],
 	__stop_parainstructions[];
 #endif	/* CONFIG_PARAVIRT */
 
+/*
+ * Self-test for the INT3 based CALL emulation code.
+ *
+ * This exercises int3_emulate_call() to make sure INT3 pt_regs are set up
+ * properly and that there is a stack gap between the INT3 frame and the
+ * previous context. Without this gap doing a virtual PUSH on the interrupted
+ * stack would corrupt the INT3 IRET frame.
+ *
+ * See entry_{32,64}.S for more details.
+ */
+static void __init int3_magic(unsigned int *ptr)
+{
+	*ptr = 1;
+}
+
+extern __initdata unsigned long int3_selftest_ip; /* defined in asm below */
+
+static int __init
+int3_exception_notify(struct notifier_block *self, unsigned long val, void *data)
+{
+	struct die_args *args = data;
+	struct pt_regs *regs = args->regs;
+
+	if (!regs || user_mode(regs))
+		return NOTIFY_DONE;
+
+	if (val != DIE_INT3)
+		return NOTIFY_DONE;
+
+	if (regs->ip - INT3_INSN_SIZE != int3_selftest_ip)
+		return NOTIFY_DONE;
+
+	int3_emulate_call(regs, (unsigned long)&int3_magic);
+	return NOTIFY_STOP;
+}
+
+static void __init int3_selftest(void)
+{
+	static __initdata struct notifier_block int3_exception_nb = {
+		.notifier_call	= int3_exception_notify,
+		.priority	= INT_MAX-1, /* last */
+	};
+	unsigned int val = 0;
+
+	BUG_ON(register_die_notifier(&int3_exception_nb));
+
+	/*
+	 * Basically: int3_magic(&val); but really complicated :-)
+	 *
+	 * Stick the address of the INT3 instruction into int3_selftest_ip,
+	 * then trigger the INT3, padded with NOPs to match a CALL instruction
+	 * length.
+	 */
+	asm volatile ("1: int3; nop; nop; nop; nop\n\t"
+		      ".pushsection .init.data,\"aw\"\n\t"
+		      ".align " __ASM_SEL(4, 8) "\n\t"
+		      ".type int3_selftest_ip, @object\n\t"
+		      ".size int3_selftest_ip, " __ASM_SEL(4, 8) "\n\t"
+		      "int3_selftest_ip:\n\t"
+		      __ASM_SEL(.long, .quad) " 1b\n\t"
+		      ".popsection\n\t"
+		      : : __ASM_SEL_RAW(a, D) (&val) : "memory");
+
+	BUG_ON(val != 1);
+
+	unregister_die_notifier(&int3_exception_nb);
+}
+
 void __init alternative_instructions(void)
 {
-	/* The patching is not fully atomic, so try to avoid local interruptions
-	   that might execute the to be patched code.
-	   Other CPUs are not running. */
+	int3_selftest();
+
+	/*
+	 * The patching is not fully atomic, so try to avoid local
+	 * interruptions that might execute the to be patched code.
+	 * Other CPUs are not running.
+	 */
 	stop_nmi();
 
 	/*
@@ -642,10 +714,11 @@ void __init alternative_instructions(void)
 					    _text, _etext);
 	}
 
-	if (!uniproc_patched || num_possible_cpus() == 1)
+	if (!uniproc_patched || num_possible_cpus() == 1) {
 		free_init_pages("SMP alternatives",
 				(unsigned long)__smp_locks,
 				(unsigned long)__smp_locks_end);
+	}
 #endif
 
 	apply_paravirt(__parainstructions, __parainstructions_end);
