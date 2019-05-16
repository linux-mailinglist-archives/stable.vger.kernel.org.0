Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5B8E20C77
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 18:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbfEPQE4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 12:04:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42406 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726638AbfEPP6l (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 11:58:41 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImD-0006ys-63; Thu, 16 May 2019 16:58:37 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImC-0001NL-PG; Thu, 16 May 2019 16:58:36 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "Ingo Molnar" <mingo@kernel.org>
Date:   Thu, 16 May 2019 16:55:33 +0100
Message-ID: <lsq.1558022133.334738675@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 13/86] jump_label: Add jump_entry_key() helper
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

commit 7dcfd915bae51571bcc339d8e3dda027287880e5 upstream.

Avoid some casting with a helper, also prepares the way for
overloading the LSB of jump_entry::key.

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
 kernel/jump_label.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -195,6 +195,11 @@ static inline struct jump_entry *static_
 	return (struct jump_entry *)((unsigned long)key->entries & ~JUMP_TYPE_MASK);
 }
 
+static inline struct static_key *jump_entry_key(struct jump_entry *entry)
+{
+	return (struct static_key *)((unsigned long)entry->key);
+}
+
 static enum jump_label_type jump_label_type(struct static_key *key)
 {
 	bool enabled = static_key_enabled(key);
@@ -216,7 +221,7 @@ void __init jump_label_init(void)
 	for (iter = iter_start; iter < iter_stop; iter++) {
 		struct static_key *iterk;
 
-		iterk = (struct static_key *)(unsigned long)iter->key;
+		iterk = jump_entry_key(iter);
 		arch_jump_label_transform_static(iter, jump_label_type(iterk));
 		if (iterk == key)
 			continue;
@@ -311,7 +316,7 @@ static int jump_label_add_module(struct
 	for (iter = iter_start; iter < iter_stop; iter++) {
 		struct static_key *iterk;
 
-		iterk = (struct static_key *)(unsigned long)iter->key;
+		iterk = jump_entry_key(iter);
 		if (iterk == key)
 			continue;
 
@@ -348,10 +353,10 @@ static void jump_label_del_module(struct
 	struct static_key_mod *jlm, **prev;
 
 	for (iter = iter_start; iter < iter_stop; iter++) {
-		if (iter->key == (jump_label_t)(unsigned long)key)
+		if (jump_entry_key(iter) == key)
 			continue;
 
-		key = (struct static_key *)(unsigned long)iter->key;
+		key = jump_entry_key(iter);
 
 		if (within_module(iter->key, mod))
 			continue;

