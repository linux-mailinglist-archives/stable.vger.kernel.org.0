Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 622DF20C6D
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 18:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbfEPQEg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 12:04:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42412 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726678AbfEPP6m (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 11:58:42 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImD-0006yt-CX; Thu, 16 May 2019 16:58:37 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImC-0001NS-Pt; Thu, 16 May 2019 16:58:36 +0100
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
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "Peter Zijlstra" <peterz@infradead.org>
Date:   Thu, 16 May 2019 16:55:33 +0100
Message-ID: <lsq.1558022133.477445986@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 14/86] locking/static_keys: Rework update logic
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

commit 706249c222f68471b6f8e9e8e9b77665c404b226 upstream.

Instead of spreading the branch_default logic all over the place,
concentrate it into the one jump_label_type() function.

This does mean we need to actually increment/decrement the enabled
count _before_ calling the update path, otherwise jump_label_type()
will not see the right state.

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
 kernel/jump_label.c | 88 ++++++++++++++++++++-------------------------
 1 file changed, 38 insertions(+), 50 deletions(-)

--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -54,12 +54,7 @@ jump_label_sort_entries(struct jump_entr
 	sort(start, size, sizeof(struct jump_entry), jump_label_cmp, NULL);
 }
 
-static void jump_label_update(struct static_key *key, int enable);
-
-static inline bool static_key_type(struct static_key *key)
-{
-	return (unsigned long)key->entries & JUMP_TYPE_MASK;
-}
+static void jump_label_update(struct static_key *key);
 
 void static_key_slow_inc(struct static_key *key)
 {
@@ -68,13 +63,8 @@ void static_key_slow_inc(struct static_k
 		return;
 
 	jump_label_lock();
-	if (atomic_read(&key->enabled) == 0) {
-		if (!static_key_type(key))
-			jump_label_update(key, JUMP_LABEL_JMP);
-		else
-			jump_label_update(key, JUMP_LABEL_NOP);
-	}
-	atomic_inc(&key->enabled);
+	if (atomic_inc_return(&key->enabled) == 1)
+		jump_label_update(key);
 	jump_label_unlock();
 }
 EXPORT_SYMBOL_GPL(static_key_slow_inc);
@@ -92,10 +82,7 @@ static void __static_key_slow_dec(struct
 		atomic_inc(&key->enabled);
 		schedule_delayed_work(work, rate_limit);
 	} else {
-		if (!static_key_type(key))
-			jump_label_update(key, JUMP_LABEL_NOP);
-		else
-			jump_label_update(key, JUMP_LABEL_JMP);
+		jump_label_update(key);
 	}
 	jump_label_unlock();
 }
@@ -161,7 +148,7 @@ static int __jump_label_text_reserved(st
 	return 0;
 }
 
-/* 
+/*
  * Update code which is definitely not currently executing.
  * Architectures which need heavyweight synchronization to modify
  * running code can override this to make the non-live update case
@@ -170,29 +157,17 @@ static int __jump_label_text_reserved(st
 void __weak __init_or_module arch_jump_label_transform_static(struct jump_entry *entry,
 					    enum jump_label_type type)
 {
-	arch_jump_label_transform(entry, type);	
+	arch_jump_label_transform(entry, type);
 }
 
-static void __jump_label_update(struct static_key *key,
-				struct jump_entry *entry,
-				struct jump_entry *stop, int enable)
+static inline struct jump_entry *static_key_entries(struct static_key *key)
 {
-	for (; (entry < stop) &&
-	      (entry->key == (jump_label_t)(unsigned long)key);
-	      entry++) {
-		/*
-		 * entry->code set to 0 invalidates module init text sections
-		 * kernel_text_address() verifies we are not in core kernel
-		 * init code, see jump_label_invalidate_module_init().
-		 */
-		if (entry->code && kernel_text_address(entry->code))
-			arch_jump_label_transform(entry, enable);
-	}
+	return (struct jump_entry *)((unsigned long)key->entries & ~JUMP_TYPE_MASK);
 }
 
-static inline struct jump_entry *static_key_entries(struct static_key *key)
+static inline bool static_key_type(struct static_key *key)
 {
-	return (struct jump_entry *)((unsigned long)key->entries & ~JUMP_TYPE_MASK);
+	return (unsigned long)key->entries & JUMP_TYPE_MASK;
 }
 
 static inline struct static_key *jump_entry_key(struct jump_entry *entry)
@@ -200,14 +175,30 @@ static inline struct static_key *jump_en
 	return (struct static_key *)((unsigned long)entry->key);
 }
 
-static enum jump_label_type jump_label_type(struct static_key *key)
+static enum jump_label_type jump_label_type(struct jump_entry *entry)
 {
+	struct static_key *key = jump_entry_key(entry);
 	bool enabled = static_key_enabled(key);
 	bool type = static_key_type(key);
 
 	return enabled ^ type;
 }
 
+static void __jump_label_update(struct static_key *key,
+				struct jump_entry *entry,
+				struct jump_entry *stop)
+{
+	for (; (entry < stop) && (jump_entry_key(entry) == key); entry++) {
+		/*
+		 * entry->code set to 0 invalidates module init text sections
+		 * kernel_text_address() verifies we are not in core kernel
+		 * init code, see jump_label_invalidate_module_init().
+		 */
+		if (entry->code && kernel_text_address(entry->code))
+			arch_jump_label_transform(entry, jump_label_type(entry));
+	}
+}
+
 void __init jump_label_init(void)
 {
 	struct jump_entry *iter_start = __start___jump_table;
@@ -221,8 +212,8 @@ void __init jump_label_init(void)
 	for (iter = iter_start; iter < iter_stop; iter++) {
 		struct static_key *iterk;
 
+		arch_jump_label_transform_static(iter, jump_label_type(iter));
 		iterk = jump_entry_key(iter);
-		arch_jump_label_transform_static(iter, jump_label_type(iterk));
 		if (iterk == key)
 			continue;
 
@@ -262,17 +253,15 @@ static int __jump_label_mod_text_reserve
 				start, end);
 }
 
-static void __jump_label_mod_update(struct static_key *key, int enable)
+static void __jump_label_mod_update(struct static_key *key)
 {
-	struct static_key_mod *mod = key->next;
+	struct static_key_mod *mod;
 
-	while (mod) {
+	for (mod = key->next; mod; mod = mod->next) {
 		struct module *m = mod->mod;
 
 		__jump_label_update(key, mod->entries,
-				    m->jump_entries + m->num_jump_entries,
-				    enable);
-		mod = mod->next;
+				    m->jump_entries + m->num_jump_entries);
 	}
 }
 
@@ -294,9 +283,8 @@ void jump_label_apply_nops(struct module
 	if (iter_start == iter_stop)
 		return;
 
-	for (iter = iter_start; iter < iter_stop; iter++) {
+	for (iter = iter_start; iter < iter_stop; iter++)
 		arch_jump_label_transform_static(iter, JUMP_LABEL_NOP);
-	}
 }
 
 static int jump_label_add_module(struct module *mod)
@@ -337,8 +325,8 @@ static int jump_label_add_module(struct
 		jlm->next = key->next;
 		key->next = jlm;
 
-		if (jump_label_type(key) == JUMP_LABEL_JMP)
-			__jump_label_update(key, iter, iter_stop, JUMP_LABEL_JMP);
+		if (jump_label_type(iter) == JUMP_LABEL_JMP)
+			__jump_label_update(key, iter, iter_stop);
 	}
 
 	return 0;
@@ -458,14 +446,14 @@ int jump_label_text_reserved(void *start
 	return ret;
 }
 
-static void jump_label_update(struct static_key *key, int enable)
+static void jump_label_update(struct static_key *key)
 {
 	struct jump_entry *stop = __stop___jump_table;
 	struct jump_entry *entry = static_key_entries(key);
 #ifdef CONFIG_MODULES
 	struct module *mod;
 
-	__jump_label_mod_update(key, enable);
+	__jump_label_mod_update(key);
 
 	preempt_disable();
 	mod = __module_address((unsigned long)key);
@@ -475,7 +463,7 @@ static void jump_label_update(struct sta
 #endif
 	/* if there are no users, entry can be NULL */
 	if (entry)
-		__jump_label_update(key, entry, stop, enable);
+		__jump_label_update(key, entry, stop);
 }
 
 #endif

