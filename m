Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC44691CB
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 16:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391218AbfGOObx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 10:31:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:46310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391211AbfGOObw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 10:31:52 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8061F212F5;
        Mon, 15 Jul 2019 14:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563201111;
        bh=a8gAMXbfCvS9ioZvi12BOqT1FDrW5gktrdUiyO4Ehe8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K2pM5kwDOf2s2sUF2peLt6rTtqEB+1HBgTYRAfl80mbzWOrcQkX0eDrbwdgjnKJYK
         4OXHf/75rhVwkrQEc/fstYG6ZCOYMsRemPyvNn7clUHsu/3OUMKMot42DvAuePINd3
         ZhKwKF3MABzjlZu4KOUxWeKAdZGq9YPJnby4WNdI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-arch@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 054/105] x86/atomic: Fix smp_mb__{before,after}_atomic()
Date:   Mon, 15 Jul 2019 10:27:48 -0400
Message-Id: <20190715142839.9896-54-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715142839.9896-1-sashal@kernel.org>
References: <20190715142839.9896-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 69d927bba39517d0980462efc051875b7f4db185 ]

Recent probing at the Linux Kernel Memory Model uncovered a
'surprise'. Strongly ordered architectures where the atomic RmW
primitive implies full memory ordering and
smp_mb__{before,after}_atomic() are a simple barrier() (such as x86)
fail for:

	*x = 1;
	atomic_inc(u);
	smp_mb__after_atomic();
	r0 = *y;

Because, while the atomic_inc() implies memory order, it
(surprisingly) does not provide a compiler barrier. This then allows
the compiler to re-order like so:

	atomic_inc(u);
	*x = 1;
	smp_mb__after_atomic();
	r0 = *y;

Which the CPU is then allowed to re-order (under TSO rules) like:

	atomic_inc(u);
	r0 = *y;
	*x = 1;

And this very much was not intended. Therefore strengthen the atomic
RmW ops to include a compiler barrier.

NOTE: atomic_{or,and,xor} and the bitops already had the compiler
barrier.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/atomic_t.txt         | 3 +++
 arch/x86/include/asm/atomic.h      | 8 ++++----
 arch/x86/include/asm/atomic64_64.h | 8 ++++----
 arch/x86/include/asm/barrier.h     | 4 ++--
 4 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/Documentation/atomic_t.txt b/Documentation/atomic_t.txt
index 913396ac5824..ed0d814df7e0 100644
--- a/Documentation/atomic_t.txt
+++ b/Documentation/atomic_t.txt
@@ -177,6 +177,9 @@ These helper barriers exist because architectures have varying implicit
 ordering on their SMP atomic primitives. For example our TSO architectures
 provide full ordered atomics and these barriers are no-ops.
 
+NOTE: when the atomic RmW ops are fully ordered, they should also imply a
+compiler barrier.
+
 Thus:
 
   atomic_fetch_add();
diff --git a/arch/x86/include/asm/atomic.h b/arch/x86/include/asm/atomic.h
index 72759f131cc5..d09dd91dd0b6 100644
--- a/arch/x86/include/asm/atomic.h
+++ b/arch/x86/include/asm/atomic.h
@@ -50,7 +50,7 @@ static __always_inline void atomic_add(int i, atomic_t *v)
 {
 	asm volatile(LOCK_PREFIX "addl %1,%0"
 		     : "+m" (v->counter)
-		     : "ir" (i));
+		     : "ir" (i) : "memory");
 }
 
 /**
@@ -64,7 +64,7 @@ static __always_inline void atomic_sub(int i, atomic_t *v)
 {
 	asm volatile(LOCK_PREFIX "subl %1,%0"
 		     : "+m" (v->counter)
-		     : "ir" (i));
+		     : "ir" (i) : "memory");
 }
 
 /**
@@ -90,7 +90,7 @@ static __always_inline bool atomic_sub_and_test(int i, atomic_t *v)
 static __always_inline void atomic_inc(atomic_t *v)
 {
 	asm volatile(LOCK_PREFIX "incl %0"
-		     : "+m" (v->counter));
+		     : "+m" (v->counter) :: "memory");
 }
 
 /**
@@ -102,7 +102,7 @@ static __always_inline void atomic_inc(atomic_t *v)
 static __always_inline void atomic_dec(atomic_t *v)
 {
 	asm volatile(LOCK_PREFIX "decl %0"
-		     : "+m" (v->counter));
+		     : "+m" (v->counter) :: "memory");
 }
 
 /**
diff --git a/arch/x86/include/asm/atomic64_64.h b/arch/x86/include/asm/atomic64_64.h
index 738495caf05f..e6fad6bbb2ee 100644
--- a/arch/x86/include/asm/atomic64_64.h
+++ b/arch/x86/include/asm/atomic64_64.h
@@ -45,7 +45,7 @@ static __always_inline void atomic64_add(long i, atomic64_t *v)
 {
 	asm volatile(LOCK_PREFIX "addq %1,%0"
 		     : "=m" (v->counter)
-		     : "er" (i), "m" (v->counter));
+		     : "er" (i), "m" (v->counter) : "memory");
 }
 
 /**
@@ -59,7 +59,7 @@ static inline void atomic64_sub(long i, atomic64_t *v)
 {
 	asm volatile(LOCK_PREFIX "subq %1,%0"
 		     : "=m" (v->counter)
-		     : "er" (i), "m" (v->counter));
+		     : "er" (i), "m" (v->counter) : "memory");
 }
 
 /**
@@ -86,7 +86,7 @@ static __always_inline void atomic64_inc(atomic64_t *v)
 {
 	asm volatile(LOCK_PREFIX "incq %0"
 		     : "=m" (v->counter)
-		     : "m" (v->counter));
+		     : "m" (v->counter) : "memory");
 }
 
 /**
@@ -99,7 +99,7 @@ static __always_inline void atomic64_dec(atomic64_t *v)
 {
 	asm volatile(LOCK_PREFIX "decq %0"
 		     : "=m" (v->counter)
-		     : "m" (v->counter));
+		     : "m" (v->counter) : "memory");
 }
 
 /**
diff --git a/arch/x86/include/asm/barrier.h b/arch/x86/include/asm/barrier.h
index a04f0c242a28..bc88797cfa61 100644
--- a/arch/x86/include/asm/barrier.h
+++ b/arch/x86/include/asm/barrier.h
@@ -106,8 +106,8 @@ do {									\
 #endif
 
 /* Atomic operations are already serializing on x86 */
-#define __smp_mb__before_atomic()	barrier()
-#define __smp_mb__after_atomic()	barrier()
+#define __smp_mb__before_atomic()	do { } while (0)
+#define __smp_mb__after_atomic()	do { } while (0)
 
 #include <asm-generic/barrier.h>
 
-- 
2.20.1

