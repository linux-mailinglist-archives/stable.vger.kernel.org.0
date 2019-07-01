Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D27220C13
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 18:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727234AbfEPQBk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 12:01:40 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42874 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727015AbfEPP6q (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 11:58:46 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImD-0006yz-He; Thu, 16 May 2019 16:58:37 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImC-0001Nc-SF; Thu, 16 May 2019 16:58:36 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        ddaney@caviumnetworks.com, liuj97@gmail.com, rostedt@goodmis.org,
        luto@amacapital.net, heiko.carstens@de.ibm.com, vbabka@suse.cz,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Jason Baron" <jbaron@akamai.com>, ralf@linux-mips.org,
        benh@kernel.crashing.org, will.deacon@arm.com, davem@davemloft.net,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "Thomas Gleixner" <tglx@linutronix.de>, bp@alien8.de, rabin@rab.in,
        "Ingo Molnar" <mingo@kernel.org>, michael@ellerman.id.au
Date:   Thu, 16 May 2019 16:55:33 +0100
Message-ID: <lsq.1558022133.20874728@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 16/86] jump label, locking/static_keys: Update docs
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

From: Jason Baron <jbaron@akamai.com>

commit 412758cb26704e5087ca2976ec3b28fb2bdbfad4 upstream.

Signed-off-by: Jason Baron <jbaron@akamai.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: benh@kernel.crashing.org
Cc: bp@alien8.de
Cc: davem@davemloft.net
Cc: ddaney@caviumnetworks.com
Cc: heiko.carstens@de.ibm.com
Cc: linux-kernel@vger.kernel.org
Cc: liuj97@gmail.com
Cc: luto@amacapital.net
Cc: michael@ellerman.id.au
Cc: rabin@rab.in
Cc: ralf@linux-mips.org
Cc: rostedt@goodmis.org
Cc: vbabka@suse.cz
Cc: will.deacon@arm.com
Link: http://lkml.kernel.org/r/6b50f2f6423a2244f37f4b1d2d6c211b9dcdf4f8.1438227999.git.jbaron@akamai.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 Documentation/static-keys.txt | 99 ++++++++++++++++++-----------------
 include/linux/jump_label.h    | 67 ++++++++++++++++--------
 2 files changed, 98 insertions(+), 68 deletions(-)

--- a/Documentation/static-keys.txt
+++ b/Documentation/static-keys.txt
@@ -1,7 +1,22 @@
 			Static Keys
 			-----------
 
-By: Jason Baron <jbaron@redhat.com>
+DEPRECATED API:
+
+The use of 'struct static_key' directly, is now DEPRECATED. In addition
+static_key_{true,false}() is also DEPRECATED. IE DO NOT use the following:
+
+struct static_key false = STATIC_KEY_INIT_FALSE;
+struct static_key true = STATIC_KEY_INIT_TRUE;
+static_key_true()
+static_key_false()
+
+The updated API replacements are:
+
+DEFINE_STATIC_KEY_TRUE(key);
+DEFINE_STATIC_KEY_FALSE(key);
+static_key_likely()
+statick_key_unlikely()
 
 0) Abstract
 
@@ -9,22 +24,22 @@ Static keys allows the inclusion of seld
 performance-sensitive fast-path kernel code, via a GCC feature and a code
 patching technique. A quick example:
 
-	struct static_key key = STATIC_KEY_INIT_FALSE;
+	DEFINE_STATIC_KEY_FALSE(key);
 
 	...
 
-        if (static_key_false(&key))
+        if (static_branch_unlikely(&key))
                 do unlikely code
         else
                 do likely code
 
 	...
-	static_key_slow_inc();
+	static_branch_enable(&key);
 	...
-	static_key_slow_inc();
+	static_branch_disable(&key);
 	...
 
-The static_key_false() branch will be generated into the code with as little
+The static_branch_unlikely() branch will be generated into the code with as little
 impact to the likely code path as possible.
 
 
@@ -56,7 +71,7 @@ the branch site to change the branch dir
 
 For example, if we have a simple branch that is disabled by default:
 
-	if (static_key_false(&key))
+	if (static_branch_unlikely(&key))
 		printk("I am the true branch\n");
 
 Thus, by default the 'printk' will not be emitted. And the code generated will
@@ -75,68 +90,55 @@ the basis for the static keys facility.
 
 In order to make use of this optimization you must first define a key:
 
-	struct static_key key;
-
-Which is initialized as:
-
-	struct static_key key = STATIC_KEY_INIT_TRUE;
+	DEFINE_STATIC_KEY_TRUE(key);
 
 or:
 
-	struct static_key key = STATIC_KEY_INIT_FALSE;
+	DEFINE_STATIC_KEY_FALSE(key);
+
 
-If the key is not initialized, it is default false. The 'struct static_key',
-must be a 'global'. That is, it can't be allocated on the stack or dynamically
+The key must be global, that is, it can't be allocated on the stack or dynamically
 allocated at run-time.
 
 The key is then used in code as:
 
-        if (static_key_false(&key))
+        if (static_branch_unlikely(&key))
                 do unlikely code
         else
                 do likely code
 
 Or:
 
-        if (static_key_true(&key))
+        if (static_branch_likely(&key))
                 do likely code
         else
                 do unlikely code
 
-A key that is initialized via 'STATIC_KEY_INIT_FALSE', must be used in a
-'static_key_false()' construct. Likewise, a key initialized via
-'STATIC_KEY_INIT_TRUE' must be used in a 'static_key_true()' construct. A
-single key can be used in many branches, but all the branches must match the
-way that the key has been initialized.
+Keys defined via DEFINE_STATIC_KEY_TRUE(), or DEFINE_STATIC_KEY_FALSE, may
+be used in either static_branch_likely() or static_branch_unlikely()
+statemnts.
 
-The branch(es) can then be switched via:
+Branch(es) can be set true via:
 
-	static_key_slow_inc(&key);
+static_branch_enable(&key);
+
+or false via:
+
+static_branch_disable(&key);
+
+The branch(es) can then be switched via reference counts:
+
+	static_branch_inc(&key);
 	...
-	static_key_slow_dec(&key);
+	static_branch_dec(&key);
 
-Thus, 'static_key_slow_inc()' means 'make the branch true', and
-'static_key_slow_dec()' means 'make the branch false' with appropriate
+Thus, 'static_branch_inc()' means 'make the branch true', and
+'static_branch_dec()' means 'make the branch false' with appropriate
 reference counting. For example, if the key is initialized true, a
-static_key_slow_dec(), will switch the branch to false. And a subsequent
-static_key_slow_inc(), will change the branch back to true. Likewise, if the
-key is initialized false, a 'static_key_slow_inc()', will change the branch to
-true. And then a 'static_key_slow_dec()', will again make the branch false.
-
-An example usage in the kernel is the implementation of tracepoints:
-
-        static inline void trace_##name(proto)                          \
-        {                                                               \
-                if (static_key_false(&__tracepoint_##name.key))		\
-                        __DO_TRACE(&__tracepoint_##name,                \
-                                TP_PROTO(data_proto),                   \
-                                TP_ARGS(data_args),                     \
-                                TP_CONDITION(cond));                    \
-        }
-
-Tracepoints are disabled by default, and can be placed in performance critical
-pieces of the kernel. Thus, by using a static key, the tracepoints can have
-absolutely minimal impact when not in use.
+static_branch_dec(), will switch the branch to false. And a subsequent
+static_branch_inc(), will change the branch back to true. Likewise, if the
+key is initialized false, a 'static_branch_inc()', will change the branch to
+true. And then a 'static_branch_dec()', will again make the branch false.
 
 
 4) Architecture level code patching interface, 'jump labels'
@@ -150,9 +152,12 @@ simply fall back to a traditional, load,
 
 * #define JUMP_LABEL_NOP_SIZE, see: arch/x86/include/asm/jump_label.h
 
-* __always_inline bool arch_static_branch(struct static_key *key), see:
+* __always_inline bool arch_static_branch(struct static_key *key, bool branch), see:
 					arch/x86/include/asm/jump_label.h
 
+* __always_inline bool arch_static_branch_jump(struct static_key *key, bool branch),
+					see: arch/x86/include/asm/jump_label.h
+
 * void arch_jump_label_transform(struct jump_entry *entry, enum jump_label_type type),
 					see: arch/x86/kernel/jump_label.c
 
@@ -173,7 +178,7 @@ SYSCALL_DEFINE0(getppid)
 {
         int pid;
 
-+       if (static_key_false(&key))
++       if (static_branch_unlikely(&key))
 +               printk("I am the true branch\n");
 
         rcu_read_lock();
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -7,17 +7,52 @@
  * Copyright (C) 2009-2012 Jason Baron <jbaron@redhat.com>
  * Copyright (C) 2011-2012 Peter Zijlstra <pzijlstr@redhat.com>
  *
+ * DEPRECATED API:
+ *
+ * The use of 'struct static_key' directly, is now DEPRECATED. In addition
+ * static_key_{true,false}() is also DEPRECATED. IE DO NOT use the following:
+ *
+ * struct static_key false = STATIC_KEY_INIT_FALSE;
+ * struct static_key true = STATIC_KEY_INIT_TRUE;
+ * static_key_true()
+ * static_key_false()
+ *
+ * The updated API replacements are:
+ *
+ * DEFINE_STATIC_KEY_TRUE(key);
+ * DEFINE_STATIC_KEY_FALSE(key);
+ * static_key_likely()
+ * statick_key_unlikely()
+ *
  * Jump labels provide an interface to generate dynamic branches using
- * self-modifying code. Assuming toolchain and architecture support, the result
- * of a "if (static_key_false(&key))" statement is an unconditional branch (which
- * defaults to false - and the true block is placed out of line).
- *
- * However at runtime we can change the branch target using
- * static_key_slow_{inc,dec}(). These function as a 'reference' count on the key
- * object, and for as long as there are references all branches referring to
- * that particular key will point to the (out of line) true block.
+ * self-modifying code. Assuming toolchain and architecture support, if we
+ * define a "key" that is initially false via "DEFINE_STATIC_KEY_FALSE(key)",
+ * an "if (static_branch_unlikely(&key))" statement is an unconditional branch
+ * (which defaults to false - and the true block is placed out of line).
+ * Similarly, we can define an initially true key via
+ * "DEFINE_STATIC_KEY_TRUE(key)", and use it in the same
+ * "if (static_branch_unlikely(&key))", in which case we will generate an
+ * unconditional branch to the out-of-line true branch. Keys that are
+ * initially true or false can be using in both static_branch_unlikely()
+ * and static_branch_likely() statements.
+ *
+ * At runtime we can change the branch target by setting the key
+ * to true via a call to static_branch_enable(), or false using
+ * static_branch_disable(). If the direction of the branch is switched by
+ * these calls then we run-time modify the branch target via a
+ * no-op -> jump or jump -> no-op conversion. For example, for an
+ * initially false key that is used in an "if (static_branch_unlikely(&key))"
+ * statement, setting the key to true requires us to patch in a jump
+ * to the out-of-line of true branch.
+ *
+ * In addtion to static_branch_{enable,disable}, we can also reference count
+ * the key or branch direction via static_branch_{inc,dec}. Thus,
+ * static_branch_inc() can be thought of as a 'make more true' and
+ * static_branch_dec() as a 'make more false'. The inc()/dec()
+ * interface is meant to be used exclusively from the inc()/dec() for a given
+ * key.
  *
- * Since this relies on modifying code, the static_key_slow_{inc,dec}() functions
+ * Since this relies on modifying code, the branch modifying functions
  * must be considered absolute slow paths (machine wide synchronization etc.).
  * OTOH, since the affected branches are unconditional, their runtime overhead
  * will be absolutely minimal, esp. in the default (off) case where the total
@@ -29,20 +64,10 @@
  * cause significant performance degradation. Struct static_key_deferred and
  * static_key_slow_dec_deferred() provide for this.
  *
- * Lacking toolchain and or architecture support, jump labels fall back to a simple
- * conditional branch.
- *
- * struct static_key my_key = STATIC_KEY_INIT_TRUE;
- *
- *   if (static_key_true(&my_key)) {
- *   }
- *
- * will result in the true case being in-line and starts the key with a single
- * reference. Mixing static_key_true() and static_key_false() on the same key is not
- * allowed.
+ * Lacking toolchain and or architecture support, static keys fall back to a
+ * simple conditional branch.
  *
- * Not initializing the key (static data is initialized to 0s anyway) is the
- * same as using STATIC_KEY_INIT_FALSE.
+ * Additional babbling in: Documentation/static-keys.txt
  */
 
 #if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_JUMP_LABEL)

