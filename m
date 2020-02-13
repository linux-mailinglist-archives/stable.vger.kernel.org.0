Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A613615C48C
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:53:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727874AbgBMPsY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:48:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:47872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729295AbgBMP04 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:26:56 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFA0B206DB;
        Thu, 13 Feb 2020 15:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607615;
        bh=dVJglPzkGQNWLRZbvnUE/tGiFH6lQqO/45Lkw0Kd2MA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eI/shsGzg4Pn+ydIjDTWZSfig+al9DF8B8yJgI8IBFXpJNILRE55fvJd+RC+EmZCY
         drKSf2ZrTRM7gia74hc7JwOfHPZfrVeipKYC5V4a7oORy1wBNmiXj5KFQtAa53WgXR
         YZicYS2KYT3Mh0eNBhDe2Llb0UBRpbdPhpUKIOxA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Dmitry Safonov <dima@arista.com>
Subject: [PATCH 4.19 51/52] x86/stackframe: Move ENCODE_FRAME_POINTER to asm/frame.h
Date:   Thu, 13 Feb 2020 07:21:32 -0800
Message-Id: <20200213151830.764945877@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151810.331796857@linuxfoundation.org>
References: <20200213151810.331796857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit a9b3c6998d4a7d53a787cf4d0fd4a4c11239e517 upstream.

In preparation for wider use, move the ENCODE_FRAME_POINTER macros to
a common header and provide inline asm versions.

These macros are used to encode a pt_regs frame for the unwinder; see
unwind_frame.c:decode_frame_pointer().

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Dmitry Safonov <dima@arista.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/entry/calling.h     |   15 -------------
 arch/x86/entry/entry_32.S    |   16 --------------
 arch/x86/include/asm/frame.h |   49 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 49 insertions(+), 31 deletions(-)

--- a/arch/x86/entry/calling.h
+++ b/arch/x86/entry/calling.h
@@ -172,21 +172,6 @@ For 32-bit we have the following convent
 	.endif
 .endm
 
-/*
- * This is a sneaky trick to help the unwinder find pt_regs on the stack.  The
- * frame pointer is replaced with an encoded pointer to pt_regs.  The encoding
- * is just setting the LSB, which makes it an invalid stack address and is also
- * a signal to the unwinder that it's a pt_regs pointer in disguise.
- *
- * NOTE: This macro must be used *after* PUSH_AND_CLEAR_REGS because it corrupts
- * the original rbp.
- */
-.macro ENCODE_FRAME_POINTER ptregs_offset=0
-#ifdef CONFIG_FRAME_POINTER
-	leaq 1+\ptregs_offset(%rsp), %rbp
-#endif
-.endm
-
 #ifdef CONFIG_PAGE_TABLE_ISOLATION
 
 /*
--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -245,22 +245,6 @@
 .Lend_\@:
 .endm
 
-/*
- * This is a sneaky trick to help the unwinder find pt_regs on the stack.  The
- * frame pointer is replaced with an encoded pointer to pt_regs.  The encoding
- * is just clearing the MSB, which makes it an invalid stack address and is also
- * a signal to the unwinder that it's a pt_regs pointer in disguise.
- *
- * NOTE: This macro must be used *after* SAVE_ALL because it corrupts the
- * original rbp.
- */
-.macro ENCODE_FRAME_POINTER
-#ifdef CONFIG_FRAME_POINTER
-	mov %esp, %ebp
-	andl $0x7fffffff, %ebp
-#endif
-.endm
-
 .macro RESTORE_INT_REGS
 	popl	%ebx
 	popl	%ecx
--- a/arch/x86/include/asm/frame.h
+++ b/arch/x86/include/asm/frame.h
@@ -22,6 +22,35 @@
 	pop %_ASM_BP
 .endm
 
+#ifdef CONFIG_X86_64
+/*
+ * This is a sneaky trick to help the unwinder find pt_regs on the stack.  The
+ * frame pointer is replaced with an encoded pointer to pt_regs.  The encoding
+ * is just setting the LSB, which makes it an invalid stack address and is also
+ * a signal to the unwinder that it's a pt_regs pointer in disguise.
+ *
+ * NOTE: This macro must be used *after* PUSH_AND_CLEAR_REGS because it corrupts
+ * the original rbp.
+ */
+.macro ENCODE_FRAME_POINTER ptregs_offset=0
+	leaq 1+\ptregs_offset(%rsp), %rbp
+.endm
+#else /* !CONFIG_X86_64 */
+/*
+ * This is a sneaky trick to help the unwinder find pt_regs on the stack.  The
+ * frame pointer is replaced with an encoded pointer to pt_regs.  The encoding
+ * is just clearing the MSB, which makes it an invalid stack address and is also
+ * a signal to the unwinder that it's a pt_regs pointer in disguise.
+ *
+ * NOTE: This macro must be used *after* SAVE_ALL because it corrupts the
+ * original ebp.
+ */
+.macro ENCODE_FRAME_POINTER
+	mov %esp, %ebp
+	andl $0x7fffffff, %ebp
+.endm
+#endif /* CONFIG_X86_64 */
+
 #else /* !__ASSEMBLY__ */
 
 #define FRAME_BEGIN				\
@@ -30,12 +59,32 @@
 
 #define FRAME_END "pop %" _ASM_BP "\n"
 
+#ifdef CONFIG_X86_64
+#define ENCODE_FRAME_POINTER			\
+	"lea 1(%rsp), %rbp\n\t"
+#else /* !CONFIG_X86_64 */
+#define ENCODE_FRAME_POINTER			\
+	"movl %esp, %ebp\n\t"			\
+	"andl $0x7fffffff, %ebp\n\t"
+#endif /* CONFIG_X86_64 */
+
 #endif /* __ASSEMBLY__ */
 
 #define FRAME_OFFSET __ASM_SEL(4, 8)
 
 #else /* !CONFIG_FRAME_POINTER */
 
+#ifdef __ASSEMBLY__
+
+.macro ENCODE_FRAME_POINTER ptregs_offset=0
+.endm
+
+#else /* !__ASSEMBLY */
+
+#define ENCODE_FRAME_POINTER
+
+#endif
+
 #define FRAME_BEGIN
 #define FRAME_END
 #define FRAME_OFFSET 0


