Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 798F75955AA
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 10:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232285AbiHPI4q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 04:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233431AbiHPIzu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 04:55:50 -0400
Received: from mail.marcansoft.com (marcansoft.com [IPv6:2a01:298:fe:f::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56ACC10651D;
        Tue, 16 Aug 2022 00:03:31 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: hector@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id E22484195A;
        Tue, 16 Aug 2022 07:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=marcan.st; s=default;
        t=1660633407; bh=kUwKJCbfhFuqlbG5x8uMKMwiqOIdhALURpt/vstQk4s=;
        h=From:To:Cc:Subject:Date;
        b=oZugG863BdtFggJGMD5WWyU3O9TQMqUzQI0Q0opxDi9IBIIqfCX8bmf5N2YMyCiRZ
         2keRbaZtAzfI4XvjVQnFFtSCOUOYOXWaZyrqqG+ut2RkHO3zGaiMgjnKx2yzNSXjrY
         bL0tH7UpAmYsOIYiNTgRd5LkWG2+SpzNXCpk5BfDO7izM9Wj4UYSLYoFzMD3cpXTZ8
         ItJ56cokotDvC/wfZXdCqNw5B15pSrAFIdJqh7kKil/FvjbCbQlT+5659azbnI/9q9
         FIqW/hbHLrCYNw8X0r/KatC+tbn1Qx3TCxeSt4gV/vPUZv3KtMdasKqGbmccXcukE5
         vd9SMut5DVlkQ==
From:   Hector Martin <marcan@marcan.st>
To:     Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@kernel.org>
Cc:     Alan Stern <stern@rowland.harvard.edu>,
        Andrea Parri <parri.andrea@gmail.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Jade Alglave <j.alglave@ucl.ac.uk>,
        Luc Maranget <luc.maranget@inria.fr>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Akira Yokosawa <akiyks@gmail.com>,
        Daniel Lustig <dlustig@nvidia.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Jonathan Corbet <corbet@lwn.net>, Tejun Heo <tj@kernel.org>,
        jirislaby@kernel.org, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Oliver Neukum <oneukum@suse.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Asahi Linux <asahi@lists.linux.dev>,
        Hector Martin <marcan@marcan.st>, stable@vger.kernel.org
Subject: [PATCH] locking/atomic: Make test_and_*_bit() ordered on failure
Date:   Tue, 16 Aug 2022 16:03:11 +0900
Message-Id: <20220816070311.89186-1-marcan@marcan.st>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

These operations are documented as always ordered in
include/asm-generic/bitops/instrumented-atomic.h, and producer-consumer
type use cases where one side needs to ensure a flag is left pending
after some shared data was updated rely on this ordering, even in the
failure case.

This is the case with the workqueue code, which currently suffers from a
reproducible ordering violation on Apple M1 platforms (which are
notoriously out-of-order) that ends up causing the TTY layer to fail to
deliver data to userspace properly under the right conditions. This
change fixes that bug.

Change the documentation to restrict the "no order on failure" story to
the _lock() variant (for which it makes sense), and remove the
early-exit from the generic implementation, which is what causes the
missing barrier semantics in that case. Without this, the remaining
atomic op is fully ordered (including on ARM64 LSE, as of recent
versions of the architecture spec).

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: stable@vger.kernel.org
Fixes: e986a0d6cb36 ("locking/atomics, asm-generic/bitops/atomic.h: Rewrite using atomic_*() APIs")
Fixes: 61e02392d3c7 ("locking/atomic/bitops: Document and clarify ordering semantics for failed test_and_{}_bit()")
Signed-off-by: Hector Martin <marcan@marcan.st>
---
 Documentation/atomic_bitops.txt     | 2 +-
 include/asm-generic/bitops/atomic.h | 6 ------
 2 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/Documentation/atomic_bitops.txt b/Documentation/atomic_bitops.txt
index 093cdaefdb37..d8b101c97031 100644
--- a/Documentation/atomic_bitops.txt
+++ b/Documentation/atomic_bitops.txt
@@ -59,7 +59,7 @@ Like with atomic_t, the rule of thumb is:
  - RMW operations that have a return value are fully ordered.
 
  - RMW operations that are conditional are unordered on FAILURE,
-   otherwise the above rules apply. In the case of test_and_{}_bit() operations,
+   otherwise the above rules apply. In the case of test_and_set_bit_lock(),
    if the bit in memory is unchanged by the operation then it is deemed to have
    failed.
 
diff --git a/include/asm-generic/bitops/atomic.h b/include/asm-generic/bitops/atomic.h
index 3096f086b5a3..71ab4ba9c25d 100644
--- a/include/asm-generic/bitops/atomic.h
+++ b/include/asm-generic/bitops/atomic.h
@@ -39,9 +39,6 @@ arch_test_and_set_bit(unsigned int nr, volatile unsigned long *p)
 	unsigned long mask = BIT_MASK(nr);
 
 	p += BIT_WORD(nr);
-	if (READ_ONCE(*p) & mask)
-		return 1;
-
 	old = arch_atomic_long_fetch_or(mask, (atomic_long_t *)p);
 	return !!(old & mask);
 }
@@ -53,9 +50,6 @@ arch_test_and_clear_bit(unsigned int nr, volatile unsigned long *p)
 	unsigned long mask = BIT_MASK(nr);
 
 	p += BIT_WORD(nr);
-	if (!(READ_ONCE(*p) & mask))
-		return 0;
-
 	old = arch_atomic_long_fetch_andnot(mask, (atomic_long_t *)p);
 	return !!(old & mask);
 }
-- 
2.35.1

