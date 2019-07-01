Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E11EE20C29
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 18:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbfEPQCR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 12:02:17 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42796 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726908AbfEPP6q (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 11:58:46 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImD-0006yu-EA; Thu, 16 May 2019 16:58:37 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImC-0001NX-QY; Thu, 16 May 2019 16:58:36 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Heiko Carstens" <heiko.carstens@de.ibm.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "Michael Ellerman" <mpe@ellerman.id.au>,
        "Rabin Vincent" <rabin@rab.in>, "Ingo Molnar" <mingo@kernel.org>
Date:   Thu, 16 May 2019 16:55:33 +0100
Message-ID: <lsq.1558022133.208452825@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 15/86] locking/static_keys: Add a new static_key
 interface
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

From: Peter Zijlstra <peterz@infradead.org>

commit 11276d5306b8e5b438a36bbff855fe792d7eaa61 upstream.

There are various problems and short-comings with the current
static_key interface:

 - static_key_{true,false}() read like a branch depending on the key
   value, instead of the actual likely/unlikely branch depending on
   init value.

 - static_key_{true,false}() are, as stated above, tied to the
   static_key init values STATIC_KEY_INIT_{TRUE,FALSE}.

 - we're limited to the 2 (out of 4) possible options that compile to
   a default NOP because that's what our arch_static_branch() assembly
   emits.

So provide a new static_key interface:

  DEFINE_STATIC_KEY_TRUE(name);
  DEFINE_STATIC_KEY_FALSE(name);

Which define a key of different types with an initial true/false
value.

Then allow:

   static_branch_likely()
   static_branch_unlikely()

to take a key of either type and emit the right instruction for the
case.

This means adding a second arch_static_branch_jump() assembly helper
which emits a JMP per default.

In order to determine the right instruction for the right state,
encode the branch type in the LSB of jump_entry::key.

This is the final step in removing the naming confusion that has led to
a stream of avoidable bugs such as:

  a833581e372a ("x86, perf: Fix static_key bug in load_mm_cr4()")

... but it also allows new static key combinations that will give us
performance enhancements in the subsequent patches.

Tested-by: Rabin Vincent <rabin@rab.in> # arm
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Michael Ellerman <mpe@ellerman.id.au> # ppc
Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com> # s390
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
[bwh: Backported to 3.16:
 - For s390, use the 31-bit-compatible macros in arch_static_branch_jump()
 - 
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/include/asm/jump_label.h     |  25 +++--
 arch/arm64/include/asm/jump_label.h   |  18 +++-
 arch/mips/include/asm/jump_label.h    |  19 +++-
 arch/powerpc/include/asm/jump_label.h |  19 +++-
 arch/s390/include/asm/jump_label.h    |  19 +++-
 arch/sparc/include/asm/jump_label.h   |  35 ++++--
 arch/x86/include/asm/jump_label.h     |  21 +++-
 include/linux/jump_label.h            | 149 ++++++++++++++++++++++++--
 kernel/jump_label.c                   |  37 +++++--
 9 files changed, 298 insertions(+), 44 deletions(-)

--- a/arch/arm/include/asm/jump_label.h
+++ b/arch/arm/include/asm/jump_label.h
@@ -4,23 +4,32 @@
 #ifndef __ASSEMBLY__
 
 #include <linux/types.h>
+#include <asm/unified.h>
 
 #define JUMP_LABEL_NOP_SIZE 4
 
-#ifdef CONFIG_THUMB2_KERNEL
-#define JUMP_LABEL_NOP	"nop.w"
-#else
-#define JUMP_LABEL_NOP	"nop"
-#endif
+static __always_inline bool arch_static_branch(struct static_key *key, bool branch)
+{
+	asm_volatile_goto("1:\n\t"
+		 WASM(nop) "\n\t"
+		 ".pushsection __jump_table,  \"aw\"\n\t"
+		 ".word 1b, %l[l_yes], %c0\n\t"
+		 ".popsection\n\t"
+		 : :  "i" (&((char *)key)[branch]) :  : l_yes);
+
+	return false;
+l_yes:
+	return true;
+}
 
-static __always_inline bool arch_static_branch(struct static_key *key)
+static __always_inline bool arch_static_branch_jump(struct static_key *key, bool branch)
 {
 	asm_volatile_goto("1:\n\t"
-		 JUMP_LABEL_NOP "\n\t"
+		 WASM(b) " %l[l_yes]\n\t"
 		 ".pushsection __jump_table,  \"aw\"\n\t"
 		 ".word 1b, %l[l_yes], %c0\n\t"
 		 ".popsection\n\t"
-		 : :  "i" (key) :  : l_yes);
+		 : :  "i" (&((char *)key)[branch]) :  : l_yes);
 
 	return false;
 l_yes:
--- a/arch/arm64/include/asm/jump_label.h
+++ b/arch/arm64/include/asm/jump_label.h
@@ -26,14 +26,28 @@
 
 #define JUMP_LABEL_NOP_SIZE		AARCH64_INSN_SIZE
 
-static __always_inline bool arch_static_branch(struct static_key *key)
+static __always_inline bool arch_static_branch(struct static_key *key, bool branch)
 {
 	asm goto("1: nop\n\t"
 		 ".pushsection __jump_table,  \"aw\"\n\t"
 		 ".align 3\n\t"
 		 ".quad 1b, %l[l_yes], %c0\n\t"
 		 ".popsection\n\t"
-		 :  :  "i"(key) :  : l_yes);
+		 :  :  "i"(&((char *)key)[branch]) :  : l_yes);
+
+	return false;
+l_yes:
+	return true;
+}
+
+static __always_inline bool arch_static_branch_jump(struct static_key *key, bool branch)
+{
+	asm goto("1: b %l[l_yes]\n\t"
+		 ".pushsection __jump_table,  \"aw\"\n\t"
+		 ".align 3\n\t"
+		 ".quad 1b, %l[l_yes], %c0\n\t"
+		 ".popsection\n\t"
+		 :  :  "i"(&((char *)key)[branch]) :  : l_yes);
 
 	return false;
 l_yes:
--- a/arch/mips/include/asm/jump_label.h
+++ b/arch/mips/include/asm/jump_label.h
@@ -26,14 +26,29 @@
 #define NOP_INSN "nop"
 #endif
 
-static __always_inline bool arch_static_branch(struct static_key *key)
+static __always_inline bool arch_static_branch(struct static_key *key, bool branch)
 {
 	asm_volatile_goto("1:\t" NOP_INSN "\n\t"
 		"nop\n\t"
 		".pushsection __jump_table,  \"aw\"\n\t"
 		WORD_INSN " 1b, %l[l_yes], %0\n\t"
 		".popsection\n\t"
-		: :  "i" (key) : : l_yes);
+		: :  "i" (&((char *)key)[branch]) : : l_yes);
+
+	return false;
+l_yes:
+	return true;
+}
+
+static __always_inline bool arch_static_branch_jump(struct static_key *key, bool branch)
+{
+	asm_volatile_goto("1:\tj %l[l_yes]\n\t"
+		"nop\n\t"
+		".pushsection __jump_table,  \"aw\"\n\t"
+		WORD_INSN " 1b, %l[l_yes], %0\n\t"
+		".popsection\n\t"
+		: :  "i" (&((char *)key)[branch]) : : l_yes);
+
 	return false;
 l_yes:
 	return true;
--- a/arch/powerpc/include/asm/jump_label.h
+++ b/arch/powerpc/include/asm/jump_label.h
@@ -17,14 +17,29 @@
 #define JUMP_ENTRY_TYPE		stringify_in_c(FTR_ENTRY_LONG)
 #define JUMP_LABEL_NOP_SIZE	4
 
-static __always_inline bool arch_static_branch(struct static_key *key)
+static __always_inline bool arch_static_branch(struct static_key *key, bool branch)
 {
 	asm_volatile_goto("1:\n\t"
 		 "nop\n\t"
 		 ".pushsection __jump_table,  \"aw\"\n\t"
 		 JUMP_ENTRY_TYPE "1b, %l[l_yes], %c0\n\t"
 		 ".popsection \n\t"
-		 : :  "i" (key) : : l_yes);
+		 : :  "i" (&((char *)key)[branch]) : : l_yes);
+
+	return false;
+l_yes:
+	return true;
+}
+
+static __always_inline bool arch_static_branch_jump(struct static_key *key, bool branch)
+{
+	asm_volatile_goto("1:\n\t"
+		 "b %l[l_yes]\n\t"
+		 ".pushsection __jump_table,  \"aw\"\n\t"
+		 JUMP_ENTRY_TYPE "1b, %l[l_yes], %c0\n\t"
+		 ".popsection \n\t"
+		 : :  "i" (&((char *)key)[branch]) : : l_yes);
+
 	return false;
 l_yes:
 	return true;
--- a/arch/s390/include/asm/jump_label.h
+++ b/arch/s390/include/asm/jump_label.h
@@ -20,14 +20,29 @@
  * We use a brcl 0,2 instruction for jump labels at compile time so it
  * can be easily distinguished from a hotpatch generated instruction.
  */
-static __always_inline bool arch_static_branch(struct static_key *key)
+static __always_inline bool arch_static_branch(struct static_key *key, bool branch)
 {
 	asm_volatile_goto("0:	brcl 0,"__stringify(JUMP_LABEL_NOP_OFFSET)"\n"
 		".pushsection __jump_table, \"aw\"\n"
 		ASM_ALIGN "\n"
 		ASM_PTR " 0b, %l[label], %0\n"
 		".popsection\n"
-		: : "X" (key) : : label);
+		: : "X" (&((char *)key)[branch]) : : label);
+
+	return false;
+label:
+	return true;
+}
+
+static __always_inline bool arch_static_branch_jump(struct static_key *key, bool branch)
+{
+	asm_volatile_goto("0:	brcl 15, %l[label]\n"
+		".pushsection __jump_table, \"aw\"\n"
+		ASM_ALIGN "\n"
+		ASM_PTR " 0b, %l[label], %0\n"
+		".popsection\n"
+		: : "X" (&((char *)key)[branch]) : : label);
+
 	return false;
 label:
 	return true;
--- a/arch/sparc/include/asm/jump_label.h
+++ b/arch/sparc/include/asm/jump_label.h
@@ -7,16 +7,33 @@
 
 #define JUMP_LABEL_NOP_SIZE 4
 
-static __always_inline bool arch_static_branch(struct static_key *key)
+static __always_inline bool arch_static_branch(struct static_key *key, bool branch)
 {
-		asm_volatile_goto("1:\n\t"
-			 "nop\n\t"
-			 "nop\n\t"
-			 ".pushsection __jump_table,  \"aw\"\n\t"
-			 ".align 4\n\t"
-			 ".word 1b, %l[l_yes], %c0\n\t"
-			 ".popsection \n\t"
-			 : :  "i" (key) : : l_yes);
+	asm_volatile_goto("1:\n\t"
+		 "nop\n\t"
+		 "nop\n\t"
+		 ".pushsection __jump_table,  \"aw\"\n\t"
+		 ".align 4\n\t"
+		 ".word 1b, %l[l_yes], %c0\n\t"
+		 ".popsection \n\t"
+		 : :  "i" (&((char *)key)[branch]) : : l_yes);
+
+	return false;
+l_yes:
+	return true;
+}
+
+static __always_inline bool arch_static_branch_jump(struct static_key *key, bool branch)
+{
+	asm_volatile_goto("1:\n\t"
+		 "b %l[l_yes]\n\t"
+		 "nop\n\t"
+		 ".pushsection __jump_table,  \"aw\"\n\t"
+		 ".align 4\n\t"
+		 ".word 1b, %l[l_yes], %c0\n\t"
+		 ".popsection \n\t"
+		 : :  "i" (&((char *)key)[branch]) : : l_yes);
+
 	return false;
 l_yes:
 	return true;
--- a/arch/x86/include/asm/jump_label.h
+++ b/arch/x86/include/asm/jump_label.h
@@ -16,7 +16,7 @@
 # define STATIC_KEY_INIT_NOP GENERIC_NOP5_ATOMIC
 #endif
 
-static __always_inline bool arch_static_branch(struct static_key *key)
+static __always_inline bool arch_static_branch(struct static_key *key, bool branch)
 {
 	asm_volatile_goto("1:"
 		".byte " __stringify(STATIC_KEY_INIT_NOP) "\n\t"
@@ -24,7 +24,24 @@ static __always_inline bool arch_static_
 		_ASM_ALIGN "\n\t"
 		_ASM_PTR "1b, %l[l_yes], %c0 \n\t"
 		".popsection \n\t"
-		: :  "i" (key) : : l_yes);
+		: :  "i" (&((char *)key)[branch]) : : l_yes);
+
+	return false;
+l_yes:
+	return true;
+}
+
+static __always_inline bool arch_static_branch_jump(struct static_key *key, bool branch)
+{
+	asm_volatile_goto("1:"
+		".byte 0xe9\n\t .long %l[l_yes] - 2f\n\t"
+		"2:\n\t"
+		".pushsection __jump_table,  \"aw\" \n\t"
+		_ASM_ALIGN "\n\t"
+		_ASM_PTR "1b, %l[l_yes], %c0 \n\t"
+		".popsection \n\t"
+		: :  "i" (&((char *)key)[branch]) : : l_yes);
+
 	return false;
 l_yes:
 	return true;
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -107,12 +107,12 @@ static inline int static_key_count(struc
 
 static __always_inline bool static_key_false(struct static_key *key)
 {
-	return arch_static_branch(key);
+	return arch_static_branch(key, false);
 }
 
 static __always_inline bool static_key_true(struct static_key *key)
 {
-	return !static_key_false(key);
+	return !arch_static_branch(key, true);
 }
 
 extern struct jump_entry __start___jump_table[];
@@ -130,12 +130,12 @@ extern void static_key_slow_inc(struct s
 extern void static_key_slow_dec(struct static_key *key);
 extern void jump_label_apply_nops(struct module *mod);
 
-#define STATIC_KEY_INIT_TRUE ((struct static_key)		\
+#define STATIC_KEY_INIT_TRUE					\
 	{ .enabled = ATOMIC_INIT(1),				\
-	  .entries = (void *)JUMP_TYPE_TRUE })
-#define STATIC_KEY_INIT_FALSE ((struct static_key)		\
+	  .entries = (void *)JUMP_TYPE_TRUE }
+#define STATIC_KEY_INIT_FALSE					\
 	{ .enabled = ATOMIC_INIT(0),				\
-	  .entries = (void *)JUMP_TYPE_FALSE })
+	  .entries = (void *)JUMP_TYPE_FALSE }
 
 #else  /* !HAVE_JUMP_LABEL */
 
@@ -183,10 +183,8 @@ static inline int jump_label_apply_nops(
 	return 0;
 }
 
-#define STATIC_KEY_INIT_TRUE ((struct static_key) \
-		{ .enabled = ATOMIC_INIT(1) })
-#define STATIC_KEY_INIT_FALSE ((struct static_key) \
-		{ .enabled = ATOMIC_INIT(0) })
+#define STATIC_KEY_INIT_TRUE	{ .enabled = ATOMIC_INIT(1) }
+#define STATIC_KEY_INIT_FALSE	{ .enabled = ATOMIC_INIT(0) }
 
 #endif	/* HAVE_JUMP_LABEL */
 
@@ -218,6 +216,137 @@ static inline void static_key_disable(st
 		static_key_slow_dec(key);
 }
 
+/* -------------------------------------------------------------------------- */
+
+/*
+ * Two type wrappers around static_key, such that we can use compile time
+ * type differentiation to emit the right code.
+ *
+ * All the below code is macros in order to play type games.
+ */
+
+struct static_key_true {
+	struct static_key key;
+};
+
+struct static_key_false {
+	struct static_key key;
+};
+
+#define STATIC_KEY_TRUE_INIT  (struct static_key_true) { .key = STATIC_KEY_INIT_TRUE,  }
+#define STATIC_KEY_FALSE_INIT (struct static_key_false){ .key = STATIC_KEY_INIT_FALSE, }
+
+#define DEFINE_STATIC_KEY_TRUE(name)	\
+	struct static_key_true name = STATIC_KEY_TRUE_INIT
+
+#define DEFINE_STATIC_KEY_FALSE(name)	\
+	struct static_key_false name = STATIC_KEY_FALSE_INIT
+
+#ifdef HAVE_JUMP_LABEL
+
+/*
+ * Combine the right initial value (type) with the right branch order
+ * to generate the desired result.
+ *
+ *
+ * type\branch|	likely (1)	      |	unlikely (0)
+ * -----------+-----------------------+------------------
+ *            |                       |
+ *  true (1)  |	   ...		      |	   ...
+ *            |    NOP		      |	   JMP L
+ *            |    <br-stmts>	      |	1: ...
+ *            |	L: ...		      |
+ *            |			      |
+ *            |			      |	L: <br-stmts>
+ *            |			      |	   jmp 1b
+ *            |                       |
+ * -----------+-----------------------+------------------
+ *            |                       |
+ *  false (0) |	   ...		      |	   ...
+ *            |    JMP L	      |	   NOP
+ *            |    <br-stmts>	      |	1: ...
+ *            |	L: ...		      |
+ *            |			      |
+ *            |			      |	L: <br-stmts>
+ *            |			      |	   jmp 1b
+ *            |                       |
+ * -----------+-----------------------+------------------
+ *
+ * The initial value is encoded in the LSB of static_key::entries,
+ * type: 0 = false, 1 = true.
+ *
+ * The branch type is encoded in the LSB of jump_entry::key,
+ * branch: 0 = unlikely, 1 = likely.
+ *
+ * This gives the following logic table:
+ *
+ *	enabled	type	branch	  instuction
+ * -----------------------------+-----------
+ *	0	0	0	| NOP
+ *	0	0	1	| JMP
+ *	0	1	0	| NOP
+ *	0	1	1	| JMP
+ *
+ *	1	0	0	| JMP
+ *	1	0	1	| NOP
+ *	1	1	0	| JMP
+ *	1	1	1	| NOP
+ *
+ * Which gives the following functions:
+ *
+ *   dynamic: instruction = enabled ^ branch
+ *   static:  instruction = type ^ branch
+ *
+ * See jump_label_type() / jump_label_init_type().
+ */
+
+extern bool ____wrong_branch_error(void);
+
+#define static_branch_likely(x)							\
+({										\
+	bool branch;								\
+	if (__builtin_types_compatible_p(typeof(*x), struct static_key_true))	\
+		branch = !arch_static_branch(&(x)->key, true);			\
+	else if (__builtin_types_compatible_p(typeof(*x), struct static_key_false)) \
+		branch = !arch_static_branch_jump(&(x)->key, true);		\
+	else									\
+		branch = ____wrong_branch_error();				\
+	branch;									\
+})
+
+#define static_branch_unlikely(x)						\
+({										\
+	bool branch;								\
+	if (__builtin_types_compatible_p(typeof(*x), struct static_key_true))	\
+		branch = arch_static_branch_jump(&(x)->key, false);		\
+	else if (__builtin_types_compatible_p(typeof(*x), struct static_key_false)) \
+		branch = arch_static_branch(&(x)->key, false);			\
+	else									\
+		branch = ____wrong_branch_error();				\
+	branch;									\
+})
+
+#else /* !HAVE_JUMP_LABEL */
+
+#define static_branch_likely(x)		likely(static_key_enabled(&(x)->key))
+#define static_branch_unlikely(x)	unlikely(static_key_enabled(&(x)->key))
+
+#endif /* HAVE_JUMP_LABEL */
+
+/*
+ * Advanced usage; refcount, branch is enabled when: count != 0
+ */
+
+#define static_branch_inc(x)		static_key_slow_inc(&(x)->key)
+#define static_branch_dec(x)		static_key_slow_dec(&(x)->key)
+
+/*
+ * Normal usage; boolean enable/disable.
+ */
+
+#define static_branch_enable(x)		static_key_enable(&(x)->key)
+#define static_branch_disable(x)	static_key_disable(&(x)->key)
+
 #endif	/* _LINUX_JUMP_LABEL_H */
 
 #endif /* __ASSEMBLY__ */
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -172,16 +172,22 @@ static inline bool static_key_type(struc
 
 static inline struct static_key *jump_entry_key(struct jump_entry *entry)
 {
-	return (struct static_key *)((unsigned long)entry->key);
+	return (struct static_key *)((unsigned long)entry->key & ~1UL);
+}
+
+static bool jump_entry_branch(struct jump_entry *entry)
+{
+	return (unsigned long)entry->key & 1UL;
 }
 
 static enum jump_label_type jump_label_type(struct jump_entry *entry)
 {
 	struct static_key *key = jump_entry_key(entry);
 	bool enabled = static_key_enabled(key);
-	bool type = static_key_type(key);
+	bool branch = jump_entry_branch(entry);
 
-	return enabled ^ type;
+	/* See the comment in linux/jump_label.h */
+	return enabled ^ branch;
 }
 
 static void __jump_label_update(struct static_key *key,
@@ -212,7 +218,10 @@ void __init jump_label_init(void)
 	for (iter = iter_start; iter < iter_stop; iter++) {
 		struct static_key *iterk;
 
-		arch_jump_label_transform_static(iter, jump_label_type(iter));
+		/* rewrite NOPs */
+		if (jump_label_type(iter) == JUMP_LABEL_NOP)
+			arch_jump_label_transform_static(iter, JUMP_LABEL_NOP);
+
 		iterk = jump_entry_key(iter);
 		if (iterk == key)
 			continue;
@@ -232,6 +241,16 @@ void __init jump_label_init(void)
 
 #ifdef CONFIG_MODULES
 
+static enum jump_label_type jump_label_init_type(struct jump_entry *entry)
+{
+	struct static_key *key = jump_entry_key(entry);
+	bool type = static_key_type(key);
+	bool branch = jump_entry_branch(entry);
+
+	/* See the comment in linux/jump_label.h */
+	return type ^ branch;
+}
+
 struct static_key_mod {
 	struct static_key_mod *next;
 	struct jump_entry *entries;
@@ -283,8 +302,11 @@ void jump_label_apply_nops(struct module
 	if (iter_start == iter_stop)
 		return;
 
-	for (iter = iter_start; iter < iter_stop; iter++)
-		arch_jump_label_transform_static(iter, JUMP_LABEL_NOP);
+	for (iter = iter_start; iter < iter_stop; iter++) {
+		/* Only write NOPs for arch_branch_static(). */
+		if (jump_label_init_type(iter) == JUMP_LABEL_NOP)
+			arch_jump_label_transform_static(iter, JUMP_LABEL_NOP);
+	}
 }
 
 static int jump_label_add_module(struct module *mod)
@@ -325,7 +347,8 @@ static int jump_label_add_module(struct
 		jlm->next = key->next;
 		key->next = jlm;
 
-		if (jump_label_type(iter) == JUMP_LABEL_JMP)
+		/* Only update if we've changed from our initial state */
+		if (jump_label_type(iter) != jump_label_init_type(iter))
 			__jump_label_update(key, iter, iter_stop);
 	}
 

