Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3CB9134BD8
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 20:49:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727152AbgAHTrW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 14:47:22 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43820 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730479AbgAHTqF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jan 2020 14:46:05 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHE-0006oy-0m; Wed, 08 Jan 2020 19:46:00 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHD-007doO-1P; Wed, 08 Jan 2020 19:45:59 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "Ingo Molnar" <mingo@kernel.org>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Jesse Brandeburg" <jesse.brandeburg@intel.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>
Date:   Wed, 08 Jan 2020 19:43:47 +0000
Message-ID: <lsq.1578512578.12414166@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 49/63] locking,x86: Kill atomic_or_long()
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

From: Peter Zijlstra <peterz@infradead.org>

commit f6b4ecee0eb7bfa66ae8d5652105ed4da53209a3 upstream.

There are no users, kill it.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/20140508135851.768177189@infradead.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
[bwh: Backported to 3.16 because this function is broken after
 "x86/atomic: Fix smp_mb__{before,after}_atomic()"]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/include/asm/atomic.h | 15 ---------------
 1 file changed, 15 deletions(-)

--- a/arch/x86/include/asm/atomic.h
+++ b/arch/x86/include/asm/atomic.h
@@ -218,21 +218,6 @@ static inline short int atomic_inc_short
 	return *v;
 }
 
-#ifdef CONFIG_X86_64
-/**
- * atomic_or_long - OR of two long integers
- * @v1: pointer to type unsigned long
- * @v2: pointer to type unsigned long
- *
- * Atomically ORs @v1 and @v2
- * Returns the result of the OR
- */
-static inline void atomic_or_long(unsigned long *v1, unsigned long v2)
-{
-	asm(LOCK_PREFIX "orq %1, %0" : "+m" (*v1) : "r" (v2));
-}
-#endif
-
 /* These are x86-specific, used by some header files */
 #define atomic_clear_mask(mask, addr)				\
 	asm volatile(LOCK_PREFIX "andl %0,%1"			\

