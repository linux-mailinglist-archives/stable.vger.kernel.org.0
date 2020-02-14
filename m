Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3AF215F035
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388530AbgBNP6O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:58:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:41928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388159AbgBNP6N (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:58:13 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D592C24676;
        Fri, 14 Feb 2020 15:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695892;
        bh=ooos8tpZKnXbpVHIh/6tszTvkd3+TRtE+CbR4oBMCBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Bm8+S1CngBdhyKK4Dg53HjGBIu6ZbM94/gJAAZsJWq7W9IHmfNSD9UhVtGaSI8St
         hvDGTrx8GJW6OdoLgzFSNTStyW+vq4KAyLiepEl6JYg9t85FPjrHzyCsupUPL7M00k
         9bsuYzvz7t060TPFBYBx8XqjmD9HCQa0oTvNznBE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sven Schnelle <svens@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 435/542] s390: fix __EMIT_BUG() macro
Date:   Fri, 14 Feb 2020 10:47:07 -0500
Message-Id: <20200214154854.6746-435-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Schnelle <svens@linux.ibm.com>

[ Upstream commit 17248ea0367465f4aaef728f6af661ed38e38cf1 ]

Setting a kprobe on getname_flags() failed:

$ echo 'p:tmr1 getname_flags +0(%r2):ustring' > kprobe_events
-bash: echo: write error: Invalid argument

Debugging the kprobes code showed that the address of
getname_flags() is contained in the __bug_table. Kprobes
doesn't allow to set probes at BUG() locations.

$ objdump -j  __bug_table -x build/fs/namei.o
[..]
0000000000000108 R_390_PC32        .text+0x00000000000075a8
000000000000010c R_390_PC32        .L223+0x0000000000000004

I was expecting getname_flags() to start with a BUG(), but:

7598:       e3 20 10 00 00 04       lg      %r2,0(%r1)
759e:       c0 f4 00 00 00 00       jg      759e <putname+0x7e>
75a0: R_390_PLT32DBL    kmem_cache_free+0x2
75a4:       a7 f4 00 01             j       75a6 <putname+0x86>

00000000000075a8 <getname_flags>:
75a8:       c0 04 00 00 00 00       brcl    0,75a8 <getname_flags>
75ae:       eb 6f f0 48 00 24       stmg    %r6,%r15,72(%r15)
75b4:       b9 04 00 ef             lgr     %r14,%r15
75b8:       e3 f0 ff a8 ff 71       lay     %r15,-88(%r15)

So the BUG() is actually the last opcode of the previous function.
Fix this by switching to using the MONITOR CALL (MC) instruction,
and set the entry in __bug_table to the beginning of that MC.

Reviewed-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/boot/head.S        |  2 +-
 arch/s390/include/asm/bug.h  | 16 ++++++--------
 arch/s390/kernel/entry.h     |  1 +
 arch/s390/kernel/pgm_check.S |  2 +-
 arch/s390/kernel/traps.c     | 41 +++++++++++++++++++++++++++++++-----
 5 files changed, 46 insertions(+), 16 deletions(-)

diff --git a/arch/s390/boot/head.S b/arch/s390/boot/head.S
index 4b86a8d3c1219..dae10961d0724 100644
--- a/arch/s390/boot/head.S
+++ b/arch/s390/boot/head.S
@@ -329,7 +329,7 @@ ENTRY(startup_kdump)
 	.quad	.Lduct			# cr5: primary-aste origin
 	.quad	0			# cr6:	I/O interrupts
 	.quad	0			# cr7:	secondary space segment table
-	.quad	0			# cr8:	access registers translation
+	.quad	0x0000000000008000	# cr8:	access registers translation
 	.quad	0			# cr9:	tracing off
 	.quad	0			# cr10: tracing off
 	.quad	0			# cr11: tracing off
diff --git a/arch/s390/include/asm/bug.h b/arch/s390/include/asm/bug.h
index a2b11ac00f607..7725f8006fdfb 100644
--- a/arch/s390/include/asm/bug.h
+++ b/arch/s390/include/asm/bug.h
@@ -10,15 +10,14 @@
 
 #define __EMIT_BUG(x) do {					\
 	asm_inline volatile(					\
-		"0:	j	0b+2\n"				\
-		"1:\n"						\
+		"0:	mc	0,0\n"				\
 		".section .rodata.str,\"aMS\",@progbits,1\n"	\
-		"2:	.asciz	\""__FILE__"\"\n"		\
+		"1:	.asciz	\""__FILE__"\"\n"		\
 		".previous\n"					\
 		".section __bug_table,\"awM\",@progbits,%2\n"	\
-		"3:	.long	1b-3b,2b-3b\n"			\
+		"2:	.long	0b-2b,1b-2b\n"			\
 		"	.short	%0,%1\n"			\
-		"	.org	3b+%2\n"			\
+		"	.org	2b+%2\n"			\
 		".previous\n"					\
 		: : "i" (__LINE__),				\
 		    "i" (x),					\
@@ -29,12 +28,11 @@
 
 #define __EMIT_BUG(x) do {					\
 	asm_inline volatile(					\
-		"0:	j	0b+2\n"				\
-		"1:\n"						\
+		"0:	mc	0,0\n"				\
 		".section __bug_table,\"awM\",@progbits,%1\n"	\
-		"2:	.long	1b-2b\n"			\
+		"1:	.long	0b-1b\n"			\
 		"	.short	%0\n"				\
-		"	.org	2b+%1\n"			\
+		"	.org	1b+%1\n"			\
 		".previous\n"					\
 		: : "i" (x),					\
 		    "i" (sizeof(struct bug_entry)));		\
diff --git a/arch/s390/kernel/entry.h b/arch/s390/kernel/entry.h
index b2956d49b6ad7..1d3927e01a5fd 100644
--- a/arch/s390/kernel/entry.h
+++ b/arch/s390/kernel/entry.h
@@ -45,6 +45,7 @@ void specification_exception(struct pt_regs *regs);
 void transaction_exception(struct pt_regs *regs);
 void translation_exception(struct pt_regs *regs);
 void vector_exception(struct pt_regs *regs);
+void monitor_event_exception(struct pt_regs *regs);
 
 void do_per_trap(struct pt_regs *regs);
 void do_report_trap(struct pt_regs *regs, int si_signo, int si_code, char *str);
diff --git a/arch/s390/kernel/pgm_check.S b/arch/s390/kernel/pgm_check.S
index 59dee9d3bebf1..eee3a482195a6 100644
--- a/arch/s390/kernel/pgm_check.S
+++ b/arch/s390/kernel/pgm_check.S
@@ -81,7 +81,7 @@ PGM_CHECK_DEFAULT			/* 3c */
 PGM_CHECK_DEFAULT			/* 3d */
 PGM_CHECK_DEFAULT			/* 3e */
 PGM_CHECK_DEFAULT			/* 3f */
-PGM_CHECK_DEFAULT			/* 40 */
+PGM_CHECK(monitor_event_exception)	/* 40 */
 PGM_CHECK_DEFAULT			/* 41 */
 PGM_CHECK_DEFAULT			/* 42 */
 PGM_CHECK_DEFAULT			/* 43 */
diff --git a/arch/s390/kernel/traps.c b/arch/s390/kernel/traps.c
index 164c0282b41ae..dc75588d78943 100644
--- a/arch/s390/kernel/traps.c
+++ b/arch/s390/kernel/traps.c
@@ -53,11 +53,6 @@ void do_report_trap(struct pt_regs *regs, int si_signo, int si_code, char *str)
                 if (fixup)
 			regs->psw.addr = extable_fixup(fixup);
 		else {
-			enum bug_trap_type btt;
-
-			btt = report_bug(regs->psw.addr, regs);
-			if (btt == BUG_TRAP_TYPE_WARN)
-				return;
 			die(regs, str);
 		}
         }
@@ -245,6 +240,27 @@ void space_switch_exception(struct pt_regs *regs)
 	do_trap(regs, SIGILL, ILL_PRVOPC, "space switch event");
 }
 
+void monitor_event_exception(struct pt_regs *regs)
+{
+	const struct exception_table_entry *fixup;
+
+	if (user_mode(regs))
+		return;
+
+	switch (report_bug(regs->psw.addr - (regs->int_code >> 16), regs)) {
+	case BUG_TRAP_TYPE_NONE:
+		fixup = s390_search_extables(regs->psw.addr);
+		if (fixup)
+			regs->psw.addr = extable_fixup(fixup);
+		break;
+	case BUG_TRAP_TYPE_WARN:
+		break;
+	case BUG_TRAP_TYPE_BUG:
+		die(regs, "monitor event");
+		break;
+	}
+}
+
 void kernel_stack_overflow(struct pt_regs *regs)
 {
 	bust_spinlocks(1);
@@ -255,8 +271,23 @@ void kernel_stack_overflow(struct pt_regs *regs)
 }
 NOKPROBE_SYMBOL(kernel_stack_overflow);
 
+static void test_monitor_call(void)
+{
+	int val = 1;
+
+	asm volatile(
+		"	mc	0,0\n"
+		"0:	xgr	%0,%0\n"
+		"1:\n"
+		EX_TABLE(0b,1b)
+		: "+d" (val));
+	if (!val)
+		panic("Monitor call doesn't work!\n");
+}
+
 void __init trap_init(void)
 {
 	sort_extable(__start_dma_ex_table, __stop_dma_ex_table);
 	local_mcck_enable();
+	test_monitor_call();
 }
-- 
2.20.1

