Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 877243B5FE6
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232851AbhF1OVV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:21:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:54496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232732AbhF1OVN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:21:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9261761C7A;
        Mon, 28 Jun 2021 14:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624889926;
        bh=Y4vWzw/D3G8B0O/LDHcL0EADot7FEFYWGvq9NSIRZik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hykwrcXPMxK2c7lL2tB6TBt02ezdvNLU/YUQ0SBiFgMdSL5TyU6nW7mO3oYefBOVo
         h2MAUkcHvTCU6I5PfNDPlwLxZwYBKh0PykRpoNxJsU8zOT1lSlEnWN4p67MzTewnhA
         A7M23bxa+lPN0NtutMRYKcMUD33NI+/jz/4bxH6eYdlKn4XEPJZhCh9AMT96t06bBL
         h5yKKdycSBEWVCwb7V8hW7axVfW8h7abyG78Yai+S9+w7yGTHbA+esX22pFEvGs40Q
         bFgpQV1p/Jw2cfj+WqqxqHc50G7e9S9vIDB45UCSTeTQmFfOjWdwELKn2M0lNM//Jo
         84aTx+UytzBuQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 018/110] locking/lockdep: Improve noinstr vs errors
Date:   Mon, 28 Jun 2021 10:16:56 -0400
Message-Id: <20210628141828.31757-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628141828.31757-1-sashal@kernel.org>
References: <20210628141828.31757-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.14-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.12.14-rc1
X-KernelTest-Deadline: 2021-06-30T14:18+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 49faa77759b211fff344898edc23bb780707fff5 ]

Better handle the failure paths.

  vmlinux.o: warning: objtool: debug_locks_off()+0x23: call to console_verbose() leaves .noinstr.text section
  vmlinux.o: warning: objtool: debug_locks_off()+0x19: call to __kasan_check_write() leaves .noinstr.text section

  debug_locks_off+0x19/0x40:
  instrument_atomic_write at include/linux/instrumented.h:86
  (inlined by) __debug_locks_off at include/linux/debug_locks.h:17
  (inlined by) debug_locks_off at lib/debug_locks.c:41

Fixes: 6eebad1ad303 ("lockdep: __always_inline more for noinstr")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20210621120120.784404944@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/debug_locks.h | 2 ++
 kernel/locking/lockdep.c    | 4 +++-
 lib/debug_locks.c           | 2 +-
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/linux/debug_locks.h b/include/linux/debug_locks.h
index 2915f56ad421..edb5c186b0b7 100644
--- a/include/linux/debug_locks.h
+++ b/include/linux/debug_locks.h
@@ -27,8 +27,10 @@ extern int debug_locks_off(void);
 	int __ret = 0;							\
 									\
 	if (!oops_in_progress && unlikely(c)) {				\
+		instrumentation_begin();				\
 		if (debug_locks_off() && !debug_locks_silent)		\
 			WARN(1, "DEBUG_LOCKS_WARN_ON(%s)", #c);		\
+		instrumentation_end();					\
 		__ret = 1;						\
 	}								\
 	__ret;								\
diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index f39c383c7180..5bf6b1659215 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -842,7 +842,7 @@ static int count_matching_names(struct lock_class *new_class)
 }
 
 /* used from NMI context -- must be lockless */
-static __always_inline struct lock_class *
+static noinstr struct lock_class *
 look_up_lock_class(const struct lockdep_map *lock, unsigned int subclass)
 {
 	struct lockdep_subclass_key *key;
@@ -850,12 +850,14 @@ look_up_lock_class(const struct lockdep_map *lock, unsigned int subclass)
 	struct lock_class *class;
 
 	if (unlikely(subclass >= MAX_LOCKDEP_SUBCLASSES)) {
+		instrumentation_begin();
 		debug_locks_off();
 		printk(KERN_ERR
 			"BUG: looking up invalid subclass: %u\n", subclass);
 		printk(KERN_ERR
 			"turning off the locking correctness validator.\n");
 		dump_stack();
+		instrumentation_end();
 		return NULL;
 	}
 
diff --git a/lib/debug_locks.c b/lib/debug_locks.c
index 06d3135bd184..a75ee30b77cb 100644
--- a/lib/debug_locks.c
+++ b/lib/debug_locks.c
@@ -36,7 +36,7 @@ EXPORT_SYMBOL_GPL(debug_locks_silent);
 /*
  * Generic 'turn off all lock debugging' function:
  */
-noinstr int debug_locks_off(void)
+int debug_locks_off(void)
 {
 	if (debug_locks && __debug_locks_off()) {
 		if (!debug_locks_silent) {
-- 
2.30.2

