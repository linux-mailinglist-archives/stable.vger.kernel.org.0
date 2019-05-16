Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31C7320C76
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 18:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbfEPQEz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 12:04:55 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42426 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726666AbfEPP6l (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 11:58:41 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImD-0006zA-SW; Thu, 16 May 2019 16:58:37 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImD-0001O5-3H; Thu, 16 May 2019 16:58:37 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Brian Gerst" <brgerst@gmail.com>,
        "Frederic Weisbecker" <fweisbec@gmail.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Andy Lutomirski" <luto@kernel.org>,
        "Andy Lutomirski" <luto@amacapital.net>,
        "Denys Vlasenko" <dvlasenk@redhat.com>,
        "Ingo Molnar" <mingo@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Borislav Petkov" <bp@alien8.de>,
        "Peter Zijlstra" <peterz@infradead.org>
Date:   Thu, 16 May 2019 16:55:33 +0100
Message-ID: <lsq.1558022133.193580430@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 22/86] x86/asm: Add asm macros for static keys/jump
 labels
In-Reply-To: <lsq.1558022132.52852998@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.68-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Lutomirski <luto@kernel.org>

commit 2671c3e4fe2a34bd9bf2eecdf5d1149d4b55dbdf upstream.

Unfortunately, we can only do this if HAVE_JUMP_LABEL.  In
principle, we could do some serious surgery on the core jump
label infrastructure to keep the patch infrastructure available
on x86 on all builds, but that's probably not worth it.

Implementing the macros using a conditional branch as a fallback
seems like a bad idea: we'd have to clobber flags.

This limitation can't cause silent failures -- trying to include
asm/jump_label.h at all on a non-HAVE_JUMP_LABEL kernel will
error out.  The macro's users are responsible for handling this
issue themselves.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/63aa45c4b692e8469e1876d6ccbb5da707972990.1447361906.git.luto@kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/include/asm/jump_label.h | 52 ++++++++++++++++++++++++++-----
 1 file changed, 44 insertions(+), 8 deletions(-)

--- a/arch/x86/include/asm/jump_label.h
+++ b/arch/x86/include/asm/jump_label.h
@@ -14,13 +14,6 @@
 #error asm/jump_label.h included on a non-jump-label kernel
 #endif
 
-#ifndef __ASSEMBLY__
-
-#include <linux/stringify.h>
-#include <linux/types.h>
-#include <asm/nops.h>
-#include <asm/asm.h>
-
 #define JUMP_LABEL_NOP_SIZE 5
 
 #ifdef CONFIG_X86_64
@@ -29,6 +22,14 @@
 # define STATIC_KEY_INIT_NOP GENERIC_NOP5_ATOMIC
 #endif
 
+#include <asm/asm.h>
+#include <asm/nops.h>
+
+#ifndef __ASSEMBLY__
+
+#include <linux/stringify.h>
+#include <linux/types.h>
+
 static __always_inline bool arch_static_branch(struct static_key *key, bool branch)
 {
 	asm_volatile_goto("1:"
@@ -72,5 +73,40 @@ struct jump_entry {
 	jump_label_t key;
 };
 
-#endif  /* __ASSEMBLY__ */
+#else	/* __ASSEMBLY__ */
+
+.macro STATIC_JUMP_IF_TRUE target, key, def
+.Lstatic_jump_\@:
+	.if \def
+	/* Equivalent to "jmp.d32 \target" */
+	.byte		0xe9
+	.long		\target - .Lstatic_jump_after_\@
+.Lstatic_jump_after_\@:
+	.else
+	.byte		STATIC_KEY_INIT_NOP
+	.endif
+	.pushsection __jump_table, "aw"
+	_ASM_ALIGN
+	_ASM_PTR	.Lstatic_jump_\@, \target, \key
+	.popsection
+.endm
+
+.macro STATIC_JUMP_IF_FALSE target, key, def
+.Lstatic_jump_\@:
+	.if \def
+	.byte		STATIC_KEY_INIT_NOP
+	.else
+	/* Equivalent to "jmp.d32 \target" */
+	.byte		0xe9
+	.long		\target - .Lstatic_jump_after_\@
+.Lstatic_jump_after_\@:
+	.endif
+	.pushsection __jump_table, "aw"
+	_ASM_ALIGN
+	_ASM_PTR	.Lstatic_jump_\@, \target, \key + 1
+	.popsection
+.endm
+
+#endif	/* __ASSEMBLY__ */
+
 #endif

