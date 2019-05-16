Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBB2120C3F
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 18:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727255AbfEPQDN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 12:03:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42570 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726757AbfEPP6o (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 11:58:44 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImD-0006yn-6T; Thu, 16 May 2019 16:58:37 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImC-0001My-Ht; Thu, 16 May 2019 16:58:36 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        mgorman@suse.de, mpe@ellerman.id.au,
        "Ingo Molnar" <mingo@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>, catalin.marinas@arm.com,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, paulus@samba.org,
        benh@kernel.crashing.org, "Anton Blanchard" <anton@samba.org>,
        will.deacon@arm.com, davem@davemloft.net, mmarek@suse.cz,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        jbaron@akamai.com, linux@arm.linux.org.uk, ralf@linux-mips.org,
        schwidefsky@de.ibm.com, rostedt@goodmis.org,
        linuxppc-dev@lists.ozlabs.org, heiko.carstens@de.ibm.com,
        liuj97@gmail.com
Date:   Thu, 16 May 2019 16:55:32 +0100
Message-ID: <lsq.1558022132.722723753@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 08/86] jump_label: Allow asm/jump_label.h to be
 included in assembly
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

From: Anton Blanchard <anton@samba.org>

commit 55dd0df781e58ec23d218376ea4a676e7362a98c upstream.

Wrap asm/jump_label.h for all archs with #ifndef __ASSEMBLY__.
Since these are kernel only headers, we don't need #ifdef
__KERNEL__ so can simplify things a bit.

If an architecture wants to use jump labels in assembly, it
will still need to define a macro to create the __jump_table
entries (see ARCH_STATIC_BRANCH in the powerpc asm/jump_label.h
for an example).

Signed-off-by: Anton Blanchard <anton@samba.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: benh@kernel.crashing.org
Cc: catalin.marinas@arm.com
Cc: davem@davemloft.net
Cc: heiko.carstens@de.ibm.com
Cc: jbaron@akamai.com
Cc: linux@arm.linux.org.uk
Cc: linuxppc-dev@lists.ozlabs.org
Cc: liuj97@gmail.com
Cc: mgorman@suse.de
Cc: mmarek@suse.cz
Cc: mpe@ellerman.id.au
Cc: paulus@samba.org
Cc: ralf@linux-mips.org
Cc: rostedt@goodmis.org
Cc: schwidefsky@de.ibm.com
Cc: will.deacon@arm.com
Link: http://lkml.kernel.org/r/1428551492-21977-1-git-send-email-anton@samba.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/include/asm/jump_label.h   | 5 ++---
 arch/arm64/include/asm/jump_label.h | 8 ++++----
 arch/mips/include/asm/jump_label.h  | 7 +++----
 arch/s390/include/asm/jump_label.h  | 3 +++
 arch/sparc/include/asm/jump_label.h | 5 ++---
 arch/x86/include/asm/jump_label.h   | 5 ++---
 6 files changed, 16 insertions(+), 17 deletions(-)

--- a/arch/arm/include/asm/jump_label.h
+++ b/arch/arm/include/asm/jump_label.h
@@ -1,7 +1,7 @@
 #ifndef _ASM_ARM_JUMP_LABEL_H
 #define _ASM_ARM_JUMP_LABEL_H
 
-#ifdef __KERNEL__
+#ifndef __ASSEMBLY__
 
 #include <linux/types.h>
 
@@ -27,8 +27,6 @@ l_yes:
 	return true;
 }
 
-#endif /* __KERNEL__ */
-
 typedef u32 jump_label_t;
 
 struct jump_entry {
@@ -37,4 +35,5 @@ struct jump_entry {
 	jump_label_t key;
 };
 
+#endif  /* __ASSEMBLY__ */
 #endif
--- a/arch/arm64/include/asm/jump_label.h
+++ b/arch/arm64/include/asm/jump_label.h
@@ -18,11 +18,12 @@
  */
 #ifndef __ASM_JUMP_LABEL_H
 #define __ASM_JUMP_LABEL_H
+
+#ifndef __ASSEMBLY__
+
 #include <linux/types.h>
 #include <asm/insn.h>
 
-#ifdef __KERNEL__
-
 #define JUMP_LABEL_NOP_SIZE		AARCH64_INSN_SIZE
 
 static __always_inline bool arch_static_branch(struct static_key *key)
@@ -39,8 +40,6 @@ l_yes:
 	return true;
 }
 
-#endif /* __KERNEL__ */
-
 typedef u64 jump_label_t;
 
 struct jump_entry {
@@ -49,4 +48,5 @@ struct jump_entry {
 	jump_label_t key;
 };
 
+#endif  /* __ASSEMBLY__ */
 #endif	/* __ASM_JUMP_LABEL_H */
--- a/arch/mips/include/asm/jump_label.h
+++ b/arch/mips/include/asm/jump_label.h
@@ -8,9 +8,9 @@
 #ifndef _ASM_MIPS_JUMP_LABEL_H
 #define _ASM_MIPS_JUMP_LABEL_H
 
-#include <linux/types.h>
+#ifndef __ASSEMBLY__
 
-#ifdef __KERNEL__
+#include <linux/types.h>
 
 #define JUMP_LABEL_NOP_SIZE 4
 
@@ -39,8 +39,6 @@ l_yes:
 	return true;
 }
 
-#endif /* __KERNEL__ */
-
 #ifdef CONFIG_64BIT
 typedef u64 jump_label_t;
 #else
@@ -53,4 +51,5 @@ struct jump_entry {
 	jump_label_t key;
 };
 
+#endif  /* __ASSEMBLY__ */
 #endif /* _ASM_MIPS_JUMP_LABEL_H */
--- a/arch/s390/include/asm/jump_label.h
+++ b/arch/s390/include/asm/jump_label.h
@@ -1,6 +1,8 @@
 #ifndef _ASM_S390_JUMP_LABEL_H
 #define _ASM_S390_JUMP_LABEL_H
 
+#ifndef __ASSEMBLY__
+
 #include <linux/types.h>
 
 #define JUMP_LABEL_NOP_SIZE 6
@@ -39,4 +41,5 @@ struct jump_entry {
 	jump_label_t key;
 };
 
+#endif  /* __ASSEMBLY__ */
 #endif
--- a/arch/sparc/include/asm/jump_label.h
+++ b/arch/sparc/include/asm/jump_label.h
@@ -1,7 +1,7 @@
 #ifndef _ASM_SPARC_JUMP_LABEL_H
 #define _ASM_SPARC_JUMP_LABEL_H
 
-#ifdef __KERNEL__
+#ifndef __ASSEMBLY__
 
 #include <linux/types.h>
 
@@ -22,8 +22,6 @@ l_yes:
 	return true;
 }
 
-#endif /* __KERNEL__ */
-
 typedef u32 jump_label_t;
 
 struct jump_entry {
@@ -32,4 +30,5 @@ struct jump_entry {
 	jump_label_t key;
 };
 
+#endif  /* __ASSEMBLY__ */
 #endif
--- a/arch/x86/include/asm/jump_label.h
+++ b/arch/x86/include/asm/jump_label.h
@@ -1,7 +1,7 @@
 #ifndef _ASM_X86_JUMP_LABEL_H
 #define _ASM_X86_JUMP_LABEL_H
 
-#ifdef __KERNEL__
+#ifndef __ASSEMBLY__
 
 #include <linux/stringify.h>
 #include <linux/types.h>
@@ -30,8 +30,6 @@ l_yes:
 	return true;
 }
 
-#endif /* __KERNEL__ */
-
 #ifdef CONFIG_X86_64
 typedef u64 jump_label_t;
 #else
@@ -44,4 +42,5 @@ struct jump_entry {
 	jump_label_t key;
 };
 
+#endif  /* __ASSEMBLY__ */
 #endif

