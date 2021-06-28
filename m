Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5C8E3B60E2
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233935AbhF1ObH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:31:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:37162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234515AbhF1OaC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:30:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E873461CA5;
        Mon, 28 Jun 2021 14:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890386;
        bh=kPp9RXNXCDj6J3644beCoJ32D6kLvlczcu3yfOCMuQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MgkYyokMyYXTrC2LiIxK5o3/fonZr00TzvWw3W2gUW8NXVfSH6qF3SmstI9UBNBh7
         0Nt1UDHHaMYTcqs9NE6FNFVoTN4OhTOe0vtlqTUlYeaUA+XRYDhXwifwUfii5Q38M6
         OGsSvKnQtsYHOlOV27pdsPXidHI7ut2S9q60VFqNE4wY3QuBBthjh5IpFftymg1DOC
         UdkzeCciB3O5yLNN39COSFXSF7NzA+v2Zsb4LCmfnHZObNqfVvM3gIW6aHaICMwO/n
         e2BHLJqinlkaMvQydLe21tdK3/K/LCwm/M9/ExI7QKyGIrFpNjbu8qsEMbKJwRpfuZ
         2wWcKTJrDFV1A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 019/101] locking/lockdep: Improve noinstr vs errors
Date:   Mon, 28 Jun 2021 10:24:45 -0400
Message-Id: <20210628142607.32218-20-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628142607.32218-1-sashal@kernel.org>
References: <20210628142607.32218-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.47-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.47-rc1
X-KernelTest-Deadline: 2021-06-30T14:25+00:00
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
index 858b96b438ce..cdca007551e7 100644
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

