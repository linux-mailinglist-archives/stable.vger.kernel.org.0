Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 697B0109147
	for <lists+stable@lfdr.de>; Mon, 25 Nov 2019 16:50:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728658AbfKYPuv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Nov 2019 10:50:51 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:39607 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728592AbfKYPuv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Nov 2019 10:50:51 -0500
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1iZGdP-0008Sa-Ou; Mon, 25 Nov 2019 16:50:43 +0100
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 467F51C1AF2;
        Mon, 25 Nov 2019 16:50:43 +0100 (CET)
Date:   Mon, 25 Nov 2019 15:50:43 -0000
From:   "tip-bot2 for Andy Lutomirski" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/entry/32: Fix FIXUP_ESPFIX_STACK with user CR3
Cc:     Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        <stable@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <157469704311.21853.13499142066823391029.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     4a13b0e3e10996b9aa0b45a764ecfe49f6fcd360
Gitweb:        https://git.kernel.org/tip/4a13b0e3e10996b9aa0b45a764ecfe49f6fcd360
Author:        Andy Lutomirski <luto@kernel.org>
AuthorDate:    Sun, 24 Nov 2019 08:50:03 -08:00
Committer:     Ingo Molnar <mingo@kernel.org>
CommitterDate: Mon, 25 Nov 2019 09:36:47 +01:00

x86/entry/32: Fix FIXUP_ESPFIX_STACK with user CR3

UNWIND_ESPFIX_STACK needs to read the GDT, and the GDT mapping that
can be accessed via %fs is not mapped in the user pagetables.  Use
SGDT to find the cpu_entry_area mapping and read the espfix offset
from that instead.

Reported-and-tested-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/entry/entry_32.S | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
index 0b8c931..f07baf0 100644
--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -415,7 +415,8 @@
 
 .macro CHECK_AND_APPLY_ESPFIX
 #ifdef CONFIG_X86_ESPFIX32
-#define GDT_ESPFIX_SS PER_CPU_VAR(gdt_page) + (GDT_ENTRY_ESPFIX_SS * 8)
+#define GDT_ESPFIX_OFFSET (GDT_ENTRY_ESPFIX_SS * 8)
+#define GDT_ESPFIX_SS PER_CPU_VAR(gdt_page) + GDT_ESPFIX_OFFSET
 
 	ALTERNATIVE	"jmp .Lend_\@", "", X86_BUG_ESPFIX
 
@@ -1147,12 +1148,26 @@ ENDPROC(entry_INT80_32)
  * We can't call C functions using the ESPFIX stack. This code reads
  * the high word of the segment base from the GDT and swiches to the
  * normal stack and adjusts ESP with the matching offset.
+ *
+ * We might be on user CR3 here, so percpu data is not mapped and we can't
+ * access the GDT through the percpu segment.  Instead, use SGDT to find
+ * the cpu_entry_area alias of the GDT.
  */
 #ifdef CONFIG_X86_ESPFIX32
 	/* fixup the stack */
-	mov	GDT_ESPFIX_SS + 4, %al /* bits 16..23 */
-	mov	GDT_ESPFIX_SS + 7, %ah /* bits 24..31 */
+	pushl	%ecx
+	subl	$2*4, %esp
+	sgdt	(%esp)
+	movl	2(%esp), %ecx				/* GDT address */
+	/*
+	 * Careful: ECX is a linear pointer, so we need to force base
+	 * zero.  %cs is the only known-linear segment we have right now.
+	 */
+	mov	%cs:GDT_ESPFIX_OFFSET + 4(%ecx), %al	/* bits 16..23 */
+	mov	%cs:GDT_ESPFIX_OFFSET + 7(%ecx), %ah	/* bits 24..31 */
 	shl	$16, %eax
+	addl	$2*4, %esp
+	popl	%ecx
 	addl	%esp, %eax			/* the adjusted stack pointer */
 	pushl	$__KERNEL_DS
 	pushl	%eax
