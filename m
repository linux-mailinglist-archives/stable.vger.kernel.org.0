Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 971F6134BE0
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 20:49:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725844AbgAHTrl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 14:47:41 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43806 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730473AbgAHTqE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jan 2020 14:46:04 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHE-0006ot-Bz; Wed, 08 Jan 2020 19:46:00 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHD-007doT-2i; Wed, 08 Jan 2020 19:45:59 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Ingo Molnar" <mingo@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Andrey Ryabinin" <aryabinin@virtuozzo.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "Dmitry Vyukov" <dvyukov@google.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Thomas Gleixner" <tglx@linutronix.de>
Date:   Wed, 08 Jan 2020 19:43:48 +0000
Message-ID: <lsq.1578512578.228195979@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 50/63] locking/x86: Remove the unused atomic_inc_short()
 methd
In-Reply-To: <lsq.1578512578.117275639@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.81-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Vyukov <dvyukov@google.com>

commit 31b35f6b4d5285a311e10753f4eb17304326b211 upstream.

It is completely unused and implemented only on x86.
Remove it.

Suggested-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/20170526172900.91058-1-dvyukov@google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
[bwh: Backported to 3.16 because this function is broken after
 "x86/atomic: Fix smp_mb__{before,after}_atomic()":
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/tile/lib/atomic_asm_32.S |  3 +--
 arch/x86/include/asm/atomic.h | 13 -------------
 2 files changed, 1 insertion(+), 15 deletions(-)

--- a/arch/tile/lib/atomic_asm_32.S
+++ b/arch/tile/lib/atomic_asm_32.S
@@ -24,8 +24,7 @@
  * has an opportunity to return -EFAULT to the user if needed.
  * The 64-bit routines just return a "long long" with the value,
  * since they are only used from kernel space and don't expect to fault.
- * Support for 16-bit ops is included in the framework but we don't provide
- * any (x86_64 has an atomic_inc_short(), so we might want to some day).
+ * Support for 16-bit ops is included in the framework but we don't provide any.
  *
  * Note that the caller is advised to issue a suitable L1 or L2
  * prefetch on the address being manipulated to avoid extra stalls.
--- a/arch/x86/include/asm/atomic.h
+++ b/arch/x86/include/asm/atomic.h
@@ -205,19 +205,6 @@ static inline int __atomic_add_unless(at
 	return c;
 }
 
-/**
- * atomic_inc_short - increment of a short integer
- * @v: pointer to type int
- *
- * Atomically adds 1 to @v
- * Returns the new value of @u
- */
-static inline short int atomic_inc_short(short int *v)
-{
-	asm(LOCK_PREFIX "addw $1, %0" : "+m" (*v));
-	return *v;
-}
-
 /* These are x86-specific, used by some header files */
 #define atomic_clear_mask(mask, addr)				\
 	asm volatile(LOCK_PREFIX "andl %0,%1"			\

