Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF7E5582C32
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239935AbiG0Qn2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239939AbiG0QnL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:43:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A01DDF40;
        Wed, 27 Jul 2022 09:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C5C76B821BD;
        Wed, 27 Jul 2022 16:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1278C433D6;
        Wed, 27 Jul 2022 16:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939409;
        bh=rl9oJJkvn58x9noV5z8eu/TMj6YowMSKLx4zoR0DB/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VV1LiiJvvhHExWd7tErduCYu5qzfbTURMzgqd/EQEIiXajjk8jxIS3aF6prtUPxx5
         XKtmbkHEebyrDAO/WXNqNpncITdwMA6h2s9UXkSwzLIUpGG+m6MopB2jxf3BjT462b
         enwrCQI0tTp7yq8qM7h3F/LmBMJsCF+/dqB5ZsxE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will Deacon <will@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Hanjun Guo <guohanjun@huawei.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Elena Reshetova <elena.reshetova@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 60/87] locking/refcount: Define constants for saturation and max refcount values
Date:   Wed, 27 Jul 2022 18:10:53 +0200
Message-Id: <20220727161011.488299605@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161008.993711844@linuxfoundation.org>
References: <20220727161008.993711844@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will@kernel.org>

[ Upstream commit 23e6b169c9917fbd77534f8c5f378cb073f548bd ]

The REFCOUNT_FULL implementation uses a different saturation point than
the x86 implementation, which means that the shared refcount code in
lib/refcount.c (e.g. refcount_dec_not_one()) needs to be aware of the
difference.

Rather than duplicate the definitions from the lkdtm driver, instead
move them into <linux/refcount.h> and update all references accordingly.

Signed-off-by: Will Deacon <will@kernel.org>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Tested-by: Hanjun Guo <guohanjun@huawei.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Elena Reshetova <elena.reshetova@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20191121115902.2551-2-will@kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/lkdtm/refcount.c |  8 --------
 include/linux/refcount.h      | 10 +++++++++-
 lib/refcount.c                | 37 +++++++++++++++++++----------------
 3 files changed, 29 insertions(+), 26 deletions(-)

diff --git a/drivers/misc/lkdtm/refcount.c b/drivers/misc/lkdtm/refcount.c
index 0a146b32da13..abf3b7c1f686 100644
--- a/drivers/misc/lkdtm/refcount.c
+++ b/drivers/misc/lkdtm/refcount.c
@@ -6,14 +6,6 @@
 #include "lkdtm.h"
 #include <linux/refcount.h>
 
-#ifdef CONFIG_REFCOUNT_FULL
-#define REFCOUNT_MAX		(UINT_MAX - 1)
-#define REFCOUNT_SATURATED	UINT_MAX
-#else
-#define REFCOUNT_MAX		INT_MAX
-#define REFCOUNT_SATURATED	(INT_MIN / 2)
-#endif
-
 static void overflow_check(refcount_t *ref)
 {
 	switch (refcount_read(ref)) {
diff --git a/include/linux/refcount.h b/include/linux/refcount.h
index e28cce21bad6..79f62e8d2256 100644
--- a/include/linux/refcount.h
+++ b/include/linux/refcount.h
@@ -4,6 +4,7 @@
 
 #include <linux/atomic.h>
 #include <linux/compiler.h>
+#include <linux/limits.h>
 #include <linux/spinlock_types.h>
 
 struct mutex;
@@ -12,7 +13,7 @@ struct mutex;
  * struct refcount_t - variant of atomic_t specialized for reference counts
  * @refs: atomic_t counter field
  *
- * The counter saturates at UINT_MAX and will not move once
+ * The counter saturates at REFCOUNT_SATURATED and will not move once
  * there. This avoids wrapping the counter and causing 'spurious'
  * use-after-free bugs.
  */
@@ -56,6 +57,9 @@ extern void refcount_dec_checked(refcount_t *r);
 
 #ifdef CONFIG_REFCOUNT_FULL
 
+#define REFCOUNT_MAX		(UINT_MAX - 1)
+#define REFCOUNT_SATURATED	UINT_MAX
+
 #define refcount_add_not_zero	refcount_add_not_zero_checked
 #define refcount_add		refcount_add_checked
 
@@ -68,6 +72,10 @@ extern void refcount_dec_checked(refcount_t *r);
 #define refcount_dec		refcount_dec_checked
 
 #else
+
+#define REFCOUNT_MAX		INT_MAX
+#define REFCOUNT_SATURATED	(INT_MIN / 2)
+
 # ifdef CONFIG_ARCH_HAS_REFCOUNT
 #  include <asm/refcount.h>
 # else
diff --git a/lib/refcount.c b/lib/refcount.c
index 6e904af0fb3e..48b78a423d7d 100644
--- a/lib/refcount.c
+++ b/lib/refcount.c
@@ -5,8 +5,8 @@
  * The interface matches the atomic_t interface (to aid in porting) but only
  * provides the few functions one should use for reference counting.
  *
- * It differs in that the counter saturates at UINT_MAX and will not move once
- * there. This avoids wrapping the counter and causing 'spurious'
+ * It differs in that the counter saturates at REFCOUNT_SATURATED and will not
+ * move once there. This avoids wrapping the counter and causing 'spurious'
  * use-after-free issues.
  *
  * Memory ordering rules are slightly relaxed wrt regular atomic_t functions
@@ -48,7 +48,7 @@
  * @i: the value to add to the refcount
  * @r: the refcount
  *
- * Will saturate at UINT_MAX and WARN.
+ * Will saturate at REFCOUNT_SATURATED and WARN.
  *
  * Provides no memory ordering, it is assumed the caller has guaranteed the
  * object memory to be stable (RCU, etc.). It does provide a control dependency
@@ -69,16 +69,17 @@ bool refcount_add_not_zero_checked(unsigned int i, refcount_t *r)
 		if (!val)
 			return false;
 
-		if (unlikely(val == UINT_MAX))
+		if (unlikely(val == REFCOUNT_SATURATED))
 			return true;
 
 		new = val + i;
 		if (new < val)
-			new = UINT_MAX;
+			new = REFCOUNT_SATURATED;
 
 	} while (!atomic_try_cmpxchg_relaxed(&r->refs, &val, new));
 
-	WARN_ONCE(new == UINT_MAX, "refcount_t: saturated; leaking memory.\n");
+	WARN_ONCE(new == REFCOUNT_SATURATED,
+		  "refcount_t: saturated; leaking memory.\n");
 
 	return true;
 }
@@ -89,7 +90,7 @@ EXPORT_SYMBOL(refcount_add_not_zero_checked);
  * @i: the value to add to the refcount
  * @r: the refcount
  *
- * Similar to atomic_add(), but will saturate at UINT_MAX and WARN.
+ * Similar to atomic_add(), but will saturate at REFCOUNT_SATURATED and WARN.
  *
  * Provides no memory ordering, it is assumed the caller has guaranteed the
  * object memory to be stable (RCU, etc.). It does provide a control dependency
@@ -110,7 +111,8 @@ EXPORT_SYMBOL(refcount_add_checked);
  * refcount_inc_not_zero_checked - increment a refcount unless it is 0
  * @r: the refcount to increment
  *
- * Similar to atomic_inc_not_zero(), but will saturate at UINT_MAX and WARN.
+ * Similar to atomic_inc_not_zero(), but will saturate at REFCOUNT_SATURATED
+ * and WARN.
  *
  * Provides no memory ordering, it is assumed the caller has guaranteed the
  * object memory to be stable (RCU, etc.). It does provide a control dependency
@@ -133,7 +135,8 @@ bool refcount_inc_not_zero_checked(refcount_t *r)
 
 	} while (!atomic_try_cmpxchg_relaxed(&r->refs, &val, new));
 
-	WARN_ONCE(new == UINT_MAX, "refcount_t: saturated; leaking memory.\n");
+	WARN_ONCE(new == REFCOUNT_SATURATED,
+		  "refcount_t: saturated; leaking memory.\n");
 
 	return true;
 }
@@ -143,7 +146,7 @@ EXPORT_SYMBOL(refcount_inc_not_zero_checked);
  * refcount_inc_checked - increment a refcount
  * @r: the refcount to increment
  *
- * Similar to atomic_inc(), but will saturate at UINT_MAX and WARN.
+ * Similar to atomic_inc(), but will saturate at REFCOUNT_SATURATED and WARN.
  *
  * Provides no memory ordering, it is assumed the caller already has a
  * reference on the object.
@@ -164,7 +167,7 @@ EXPORT_SYMBOL(refcount_inc_checked);
  *
  * Similar to atomic_dec_and_test(), but it will WARN, return false and
  * ultimately leak on underflow and will fail to decrement when saturated
- * at UINT_MAX.
+ * at REFCOUNT_SATURATED.
  *
  * Provides release memory ordering, such that prior loads and stores are done
  * before, and provides an acquire ordering on success such that free()
@@ -182,7 +185,7 @@ bool refcount_sub_and_test_checked(unsigned int i, refcount_t *r)
 	unsigned int new, val = atomic_read(&r->refs);
 
 	do {
-		if (unlikely(val == UINT_MAX))
+		if (unlikely(val == REFCOUNT_SATURATED))
 			return false;
 
 		new = val - i;
@@ -207,7 +210,7 @@ EXPORT_SYMBOL(refcount_sub_and_test_checked);
  * @r: the refcount
  *
  * Similar to atomic_dec_and_test(), it will WARN on underflow and fail to
- * decrement when saturated at UINT_MAX.
+ * decrement when saturated at REFCOUNT_SATURATED.
  *
  * Provides release memory ordering, such that prior loads and stores are done
  * before, and provides an acquire ordering on success such that free()
@@ -226,7 +229,7 @@ EXPORT_SYMBOL(refcount_dec_and_test_checked);
  * @r: the refcount
  *
  * Similar to atomic_dec(), it will WARN on underflow and fail to decrement
- * when saturated at UINT_MAX.
+ * when saturated at REFCOUNT_SATURATED.
  *
  * Provides release memory ordering, such that prior loads and stores are done
  * before.
@@ -277,7 +280,7 @@ bool refcount_dec_not_one(refcount_t *r)
 	unsigned int new, val = atomic_read(&r->refs);
 
 	do {
-		if (unlikely(val == UINT_MAX))
+		if (unlikely(val == REFCOUNT_SATURATED))
 			return true;
 
 		if (val == 1)
@@ -302,7 +305,7 @@ EXPORT_SYMBOL(refcount_dec_not_one);
  * @lock: the mutex to be locked
  *
  * Similar to atomic_dec_and_mutex_lock(), it will WARN on underflow and fail
- * to decrement when saturated at UINT_MAX.
+ * to decrement when saturated at REFCOUNT_SATURATED.
  *
  * Provides release memory ordering, such that prior loads and stores are done
  * before, and provides a control dependency such that free() must come after.
@@ -333,7 +336,7 @@ EXPORT_SYMBOL(refcount_dec_and_mutex_lock);
  * @lock: the spinlock to be locked
  *
  * Similar to atomic_dec_and_lock(), it will WARN on underflow and fail to
- * decrement when saturated at UINT_MAX.
+ * decrement when saturated at REFCOUNT_SATURATED.
  *
  * Provides release memory ordering, such that prior loads and stores are done
  * before, and provides a control dependency such that free() must come after.
-- 
2.35.1



