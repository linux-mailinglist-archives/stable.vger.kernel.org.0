Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D320C582C38
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240095AbiG0Qnr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:43:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239732AbiG0QnT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:43:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2F715C97C;
        Wed, 27 Jul 2022 09:30:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A48661A24;
        Wed, 27 Jul 2022 16:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32264C433C1;
        Wed, 27 Jul 2022 16:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939420;
        bh=TpoqrBRFC0+2LkYOEAle4ckco5W4UsJldDv8v4posFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hS/j4OUkoXXGm96JsAcwMzmqkKqSE8XUcukXEx5XM8Mj5WntVkaMzZsacHz5oXZfp
         Cy45LVVivwhBFUZpJHHOxsoakTcq4JzsVOBrXJ057fB2x9mA9S72NaQ0g0BEIR+tAt
         R6PEt0LYvxI77Tf/IMNjYeD7BY/7lvtBvJUv5stU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will Deacon <will@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Hanjun Guo <guohanjun@huawei.com>,
        Jan Glauber <jglauber@marvell.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Elena Reshetova <elena.reshetova@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 64/87] locking/refcount: Improve performance of generic REFCOUNT_FULL code
Date:   Wed, 27 Jul 2022 18:10:57 +0200
Message-Id: <20220727161011.640999417@linuxfoundation.org>
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

[ Upstream commit dcb786493f3e48da3272b710028d42ec608cfda1 ]

Rewrite the generic REFCOUNT_FULL implementation so that the saturation
point is moved to INT_MIN / 2. This allows us to defer the sanity checks
until after the atomic operation, which removes many uses of cmpxchg()
in favour of atomic_fetch_{add,sub}().

Some crude perf results obtained from lkdtm show substantially less
overhead, despite the checking:

 $ perf stat -r 3 -B -- echo {ATOMIC,REFCOUNT}_TIMING >/sys/kernel/debug/provoke-crash/DIRECT

 # arm64
 ATOMIC_TIMING:                                      46.50451 +- 0.00134 seconds time elapsed  ( +-  0.00% )
 REFCOUNT_TIMING (REFCOUNT_FULL, mainline):          77.57522 +- 0.00982 seconds time elapsed  ( +-  0.01% )
 REFCOUNT_TIMING (REFCOUNT_FULL, this series):       48.7181  +- 0.0256  seconds time elapsed  ( +-  0.05% )

 # x86
 ATOMIC_TIMING:                                      31.6225 +- 0.0776 seconds time elapsed  ( +-  0.25% )
 REFCOUNT_TIMING (!REFCOUNT_FULL, mainline/x86 asm): 31.6689 +- 0.0901 seconds time elapsed  ( +-  0.28% )
 REFCOUNT_TIMING (REFCOUNT_FULL, mainline):          53.203  +- 0.138  seconds time elapsed  ( +-  0.26% )
 REFCOUNT_TIMING (REFCOUNT_FULL, this series):       31.7408 +- 0.0486 seconds time elapsed  ( +-  0.15% )

Signed-off-by: Will Deacon <will@kernel.org>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Tested-by: Hanjun Guo <guohanjun@huawei.com>
Tested-by: Jan Glauber <jglauber@marvell.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Elena Reshetova <elena.reshetova@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20191121115902.2551-6-will@kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/refcount.h | 131 ++++++++++++++++++++++-----------------
 1 file changed, 75 insertions(+), 56 deletions(-)

diff --git a/include/linux/refcount.h b/include/linux/refcount.h
index e719b5b1220e..e3b218d669ce 100644
--- a/include/linux/refcount.h
+++ b/include/linux/refcount.h
@@ -47,8 +47,8 @@ static inline unsigned int refcount_read(const refcount_t *r)
 #ifdef CONFIG_REFCOUNT_FULL
 #include <linux/bug.h>
 
-#define REFCOUNT_MAX		(UINT_MAX - 1)
-#define REFCOUNT_SATURATED	UINT_MAX
+#define REFCOUNT_MAX		INT_MAX
+#define REFCOUNT_SATURATED	(INT_MIN / 2)
 
 /*
  * Variant of atomic_t specialized for reference counts.
@@ -56,9 +56,47 @@ static inline unsigned int refcount_read(const refcount_t *r)
  * The interface matches the atomic_t interface (to aid in porting) but only
  * provides the few functions one should use for reference counting.
  *
- * It differs in that the counter saturates at REFCOUNT_SATURATED and will not
- * move once there. This avoids wrapping the counter and causing 'spurious'
- * use-after-free issues.
+ * Saturation semantics
+ * ====================
+ *
+ * refcount_t differs from atomic_t in that the counter saturates at
+ * REFCOUNT_SATURATED and will not move once there. This avoids wrapping the
+ * counter and causing 'spurious' use-after-free issues. In order to avoid the
+ * cost associated with introducing cmpxchg() loops into all of the saturating
+ * operations, we temporarily allow the counter to take on an unchecked value
+ * and then explicitly set it to REFCOUNT_SATURATED on detecting that underflow
+ * or overflow has occurred. Although this is racy when multiple threads
+ * access the refcount concurrently, by placing REFCOUNT_SATURATED roughly
+ * equidistant from 0 and INT_MAX we minimise the scope for error:
+ *
+ * 	                           INT_MAX     REFCOUNT_SATURATED   UINT_MAX
+ *   0                          (0x7fff_ffff)    (0xc000_0000)    (0xffff_ffff)
+ *   +--------------------------------+----------------+----------------+
+ *                                     <---------- bad value! ---------->
+ *
+ * (in a signed view of the world, the "bad value" range corresponds to
+ * a negative counter value).
+ *
+ * As an example, consider a refcount_inc() operation that causes the counter
+ * to overflow:
+ *
+ * 	int old = atomic_fetch_add_relaxed(r);
+ *	// old is INT_MAX, refcount now INT_MIN (0x8000_0000)
+ *	if (old < 0)
+ *		atomic_set(r, REFCOUNT_SATURATED);
+ *
+ * If another thread also performs a refcount_inc() operation between the two
+ * atomic operations, then the count will continue to edge closer to 0. If it
+ * reaches a value of 1 before /any/ of the threads reset it to the saturated
+ * value, then a concurrent refcount_dec_and_test() may erroneously free the
+ * underlying object. Given the precise timing details involved with the
+ * round-robin scheduling of each thread manipulating the refcount and the need
+ * to hit the race multiple times in succession, there doesn't appear to be a
+ * practical avenue of attack even if using refcount_add() operations with
+ * larger increments.
+ *
+ * Memory ordering
+ * ===============
  *
  * Memory ordering rules are slightly relaxed wrt regular atomic_t functions
  * and provide only what is strictly required for refcounts.
@@ -109,25 +147,19 @@ static inline unsigned int refcount_read(const refcount_t *r)
  */
 static inline __must_check bool refcount_add_not_zero(int i, refcount_t *r)
 {
-	unsigned int new, val = atomic_read(&r->refs);
+	int old = refcount_read(r);
 
 	do {
-		if (!val)
-			return false;
-
-		if (unlikely(val == REFCOUNT_SATURATED))
-			return true;
-
-		new = val + i;
-		if (new < val)
-			new = REFCOUNT_SATURATED;
+		if (!old)
+			break;
+	} while (!atomic_try_cmpxchg_relaxed(&r->refs, &old, old + i));
 
-	} while (!atomic_try_cmpxchg_relaxed(&r->refs, &val, new));
-
-	WARN_ONCE(new == REFCOUNT_SATURATED,
-		  "refcount_t: saturated; leaking memory.\n");
+	if (unlikely(old < 0 || old + i < 0)) {
+		refcount_set(r, REFCOUNT_SATURATED);
+		WARN_ONCE(1, "refcount_t: saturated; leaking memory.\n");
+	}
 
-	return true;
+	return old;
 }
 
 /**
@@ -148,7 +180,13 @@ static inline __must_check bool refcount_add_not_zero(int i, refcount_t *r)
  */
 static inline void refcount_add(int i, refcount_t *r)
 {
-	WARN_ONCE(!refcount_add_not_zero(i, r), "refcount_t: addition on 0; use-after-free.\n");
+	int old = atomic_fetch_add_relaxed(i, &r->refs);
+
+	WARN_ONCE(!old, "refcount_t: addition on 0; use-after-free.\n");
+	if (unlikely(old <= 0 || old + i <= 0)) {
+		refcount_set(r, REFCOUNT_SATURATED);
+		WARN_ONCE(old, "refcount_t: saturated; leaking memory.\n");
+	}
 }
 
 /**
@@ -166,23 +204,7 @@ static inline void refcount_add(int i, refcount_t *r)
  */
 static inline __must_check bool refcount_inc_not_zero(refcount_t *r)
 {
-	unsigned int new, val = atomic_read(&r->refs);
-
-	do {
-		new = val + 1;
-
-		if (!val)
-			return false;
-
-		if (unlikely(!new))
-			return true;
-
-	} while (!atomic_try_cmpxchg_relaxed(&r->refs, &val, new));
-
-	WARN_ONCE(new == REFCOUNT_SATURATED,
-		  "refcount_t: saturated; leaking memory.\n");
-
-	return true;
+	return refcount_add_not_zero(1, r);
 }
 
 /**
@@ -199,7 +221,7 @@ static inline __must_check bool refcount_inc_not_zero(refcount_t *r)
  */
 static inline void refcount_inc(refcount_t *r)
 {
-	WARN_ONCE(!refcount_inc_not_zero(r), "refcount_t: increment on 0; use-after-free.\n");
+	refcount_add(1, r);
 }
 
 /**
@@ -224,26 +246,19 @@ static inline void refcount_inc(refcount_t *r)
  */
 static inline __must_check bool refcount_sub_and_test(int i, refcount_t *r)
 {
-	unsigned int new, val = atomic_read(&r->refs);
-
-	do {
-		if (unlikely(val == REFCOUNT_SATURATED))
-			return false;
+	int old = atomic_fetch_sub_release(i, &r->refs);
 
-		new = val - i;
-		if (new > val) {
-			WARN_ONCE(new > val, "refcount_t: underflow; use-after-free.\n");
-			return false;
-		}
-
-	} while (!atomic_try_cmpxchg_release(&r->refs, &val, new));
-
-	if (!new) {
+	if (old == i) {
 		smp_acquire__after_ctrl_dep();
 		return true;
 	}
-	return false;
 
+	if (unlikely(old < 0 || old - i < 0)) {
+		refcount_set(r, REFCOUNT_SATURATED);
+		WARN_ONCE(1, "refcount_t: underflow; use-after-free.\n");
+	}
+
+	return false;
 }
 
 /**
@@ -276,9 +291,13 @@ static inline __must_check bool refcount_dec_and_test(refcount_t *r)
  */
 static inline void refcount_dec(refcount_t *r)
 {
-	WARN_ONCE(refcount_dec_and_test(r), "refcount_t: decrement hit 0; leaking memory.\n");
-}
+	int old = atomic_fetch_sub_release(1, &r->refs);
 
+	if (unlikely(old <= 1)) {
+		refcount_set(r, REFCOUNT_SATURATED);
+		WARN_ONCE(1, "refcount_t: decrement hit 0; leaking memory.\n");
+	}
+}
 #else /* CONFIG_REFCOUNT_FULL */
 
 #define REFCOUNT_MAX		INT_MAX
-- 
2.35.1



