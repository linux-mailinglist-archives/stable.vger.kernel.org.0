Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B87F620BBE
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 17:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbfEPP6m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 11:58:42 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42420 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726677AbfEPP6m (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 11:58:42 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImD-0006yr-5r; Thu, 16 May 2019 16:58:37 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImC-0001NF-Oe; Thu, 16 May 2019 16:58:36 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Ingo Molnar" <mingo@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date:   Thu, 16 May 2019 16:55:33 +0100
Message-ID: <lsq.1558022133.802319170@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 12/86] jump_label, locking/static_keys: Rename
 JUMP_LABEL_TYPE_* and related helpers to the static_key* pattern
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

commit a1efb01feca597b2abbc89873b40ef8ec6690168 upstream.

Rename the JUMP_LABEL_TYPE_* macros to be JUMP_TYPE_* and move the
inline helpers into kernel/jump_label.c, since that's the only place
they're ever used.

Also rename the helpers where it's all about static keys.

This is the second step in removing the naming confusion that has led to
a stream of avoidable bugs such as:

  a833581e372a ("x86, perf: Fix static_key bug in load_mm_cr4()")

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/jump_label.h | 25 +++++--------------------
 kernel/jump_label.c        | 25 ++++++++++++++++---------
 2 files changed, 21 insertions(+), 29 deletions(-)

--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -101,24 +101,9 @@ static inline int static_key_count(struc
 
 #ifdef HAVE_JUMP_LABEL
 
-#define JUMP_LABEL_TYPE_FALSE_BRANCH	0UL
-#define JUMP_LABEL_TYPE_TRUE_BRANCH	1UL
-#define JUMP_LABEL_TYPE_MASK		1UL
-
-static
-inline struct jump_entry *jump_label_get_entries(struct static_key *key)
-{
-	return (struct jump_entry *)((unsigned long)key->entries
-						& ~JUMP_LABEL_TYPE_MASK);
-}
-
-static inline bool jump_label_get_branch_default(struct static_key *key)
-{
-	if (((unsigned long)key->entries & JUMP_LABEL_TYPE_MASK) ==
-	    JUMP_LABEL_TYPE_TRUE_BRANCH)
-		return true;
-	return false;
-}
+#define JUMP_TYPE_FALSE	0UL
+#define JUMP_TYPE_TRUE	1UL
+#define JUMP_TYPE_MASK	1UL
 
 static __always_inline bool static_key_false(struct static_key *key)
 {
@@ -147,10 +132,10 @@ extern void jump_label_apply_nops(struct
 
 #define STATIC_KEY_INIT_TRUE ((struct static_key)		\
 	{ .enabled = ATOMIC_INIT(1),				\
-	  .entries = (void *)JUMP_LABEL_TYPE_TRUE_BRANCH })
+	  .entries = (void *)JUMP_TYPE_TRUE })
 #define STATIC_KEY_INIT_FALSE ((struct static_key)		\
 	{ .enabled = ATOMIC_INIT(0),				\
-	  .entries = (void *)JUMP_LABEL_TYPE_FALSE_BRANCH })
+	  .entries = (void *)JUMP_TYPE_FALSE })
 
 #else  /* !HAVE_JUMP_LABEL */
 
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -56,6 +56,11 @@ jump_label_sort_entries(struct jump_entr
 
 static void jump_label_update(struct static_key *key, int enable);
 
+static inline bool static_key_type(struct static_key *key)
+{
+	return (unsigned long)key->entries & JUMP_TYPE_MASK;
+}
+
 void static_key_slow_inc(struct static_key *key)
 {
 	STATIC_KEY_CHECK_USE();
@@ -64,7 +69,7 @@ void static_key_slow_inc(struct static_k
 
 	jump_label_lock();
 	if (atomic_read(&key->enabled) == 0) {
-		if (!jump_label_get_branch_default(key))
+		if (!static_key_type(key))
 			jump_label_update(key, JUMP_LABEL_JMP);
 		else
 			jump_label_update(key, JUMP_LABEL_NOP);
@@ -87,7 +92,7 @@ static void __static_key_slow_dec(struct
 		atomic_inc(&key->enabled);
 		schedule_delayed_work(work, rate_limit);
 	} else {
-		if (!jump_label_get_branch_default(key))
+		if (!static_key_type(key))
 			jump_label_update(key, JUMP_LABEL_NOP);
 		else
 			jump_label_update(key, JUMP_LABEL_JMP);
@@ -185,15 +190,17 @@ static void __jump_label_update(struct s
 	}
 }
 
-static enum jump_label_type jump_label_type(struct static_key *key)
+static inline struct jump_entry *static_key_entries(struct static_key *key)
 {
-	bool true_branch = jump_label_get_branch_default(key);
-	bool state = static_key_enabled(key);
+	return (struct jump_entry *)((unsigned long)key->entries & ~JUMP_TYPE_MASK);
+}
 
-	if ((!true_branch && state) || (true_branch && !state))
-		return JUMP_LABEL_JMP;
+static enum jump_label_type jump_label_type(struct static_key *key)
+{
+	bool enabled = static_key_enabled(key);
+	bool type = static_key_type(key);
 
-	return JUMP_LABEL_NOP;
+	return enabled ^ type;
 }
 
 void __init jump_label_init(void)
@@ -449,7 +456,7 @@ int jump_label_text_reserved(void *start
 static void jump_label_update(struct static_key *key, int enable)
 {
 	struct jump_entry *stop = __stop___jump_table;
-	struct jump_entry *entry = jump_label_get_entries(key);
+	struct jump_entry *entry = static_key_entries(key);
 #ifdef CONFIG_MODULES
 	struct module *mod;
 

