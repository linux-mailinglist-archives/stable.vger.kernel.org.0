Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2195B1021CA
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 11:12:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726170AbfKSKM3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 05:12:29 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:51839 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbfKSKM3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 05:12:29 -0500
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1iX0UX-0001XN-Bb; Tue, 19 Nov 2019 11:12:13 +0100
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id E47B11C19C7;
        Tue, 19 Nov 2019 11:12:12 +0100 (CET)
Date:   Tue, 19 Nov 2019 10:12:12 -0000
From:   "tip-bot2 for Jan Beulich" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/stackframe/32: Repair 32-bit Xen PV
Cc:     Jan Beulich <jbeulich@suse.com>, <stable@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Brian Gerst <brgerst@gmail.com>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Message-ID: <157415833282.12247.2847277914358020515.tip-bot2@tip-bot2>
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

Commit-ID:     189eb7f3d7ec70ceeaa195221ddfd95016e10ace
Gitweb:        https://git.kernel.org/tip/189eb7f3d7ec70ceeaa195221ddfd95016e10ace
Author:        Jan Beulich <jbeulich@suse.com>
AuthorDate:    Mon, 18 Nov 2019 16:21:12 +01:00
Committer:     Ingo Molnar <mingo@kernel.org>
CommitterDate: Tue, 19 Nov 2019 09:01:59 +01:00

x86/stackframe/32: Repair 32-bit Xen PV

Once again RPL checks have been introduced which don't account for a
32-bit kernel living in ring 1 when running in a PV Xen domain. The
case in FIXUP_FRAME has been preventing boot. Adjust BUG_IF_WRONG_CR3
as well to guard against future uses of the macro on a code path
reachable when running in PV mode under Xen; I have to admit that I
stopped at a certain point trying to figure out whether there are
present ones.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: <stable@vger.kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: xen-devel@lists.xenproject.org <xen-devel@lists.xenproject.org>
Fixes: 3c88c692c287 ("x86/stackframe/32: Provide consistent pt_regs")
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/entry/entry_32.S      |  4 ++--
 arch/x86/include/asm/segment.h | 12 ++++++++++++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
index f83ca5a..3f847d8 100644
--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -172,7 +172,7 @@
 	ALTERNATIVE "jmp .Lend_\@", "", X86_FEATURE_PTI
 	.if \no_user_check == 0
 	/* coming from usermode? */
-	testl	$SEGMENT_RPL_MASK, PT_CS(%esp)
+	testl	$USER_SEGMENT_RPL_MASK, PT_CS(%esp)
 	jz	.Lend_\@
 	.endif
 	/* On user-cr3? */
@@ -217,7 +217,7 @@
 	testl	$X86_EFLAGS_VM, 4*4(%esp)
 	jnz	.Lfrom_usermode_no_fixup_\@
 #endif
-	testl	$SEGMENT_RPL_MASK, 3*4(%esp)
+	testl	$USER_SEGMENT_RPL_MASK, 3*4(%esp)
 	jnz	.Lfrom_usermode_no_fixup_\@
 
 	orl	$CS_FROM_KERNEL, 3*4(%esp)
diff --git a/arch/x86/include/asm/segment.h b/arch/x86/include/asm/segment.h
index ac38929..6669164 100644
--- a/arch/x86/include/asm/segment.h
+++ b/arch/x86/include/asm/segment.h
@@ -31,6 +31,18 @@
  */
 #define SEGMENT_RPL_MASK	0x3
 
+/*
+ * When running on Xen PV, the actual privilege level of the kernel is 1,
+ * not 0. Testing the Requested Privilege Level in a segment selector to
+ * determine whether the context is user mode or kernel mode with
+ * SEGMENT_RPL_MASK is wrong because the PV kernel's privilege level
+ * matches the 0x3 mask.
+ *
+ * Testing with USER_SEGMENT_RPL_MASK is valid for both native and Xen PV
+ * kernels because privilege level 2 is never used.
+ */
+#define USER_SEGMENT_RPL_MASK	0x2
+
 /* User mode is privilege level 3: */
 #define USER_RPL		0x3
 
