Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 341C4582C39
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239795AbiG0Qnq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:43:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239588AbiG0QnR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:43:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CCE25C96F;
        Wed, 27 Jul 2022 09:30:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F234B821C2;
        Wed, 27 Jul 2022 16:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6398BC433D6;
        Wed, 27 Jul 2022 16:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939417;
        bh=demC+PeDmYDZI8/HOpE7owCl91LVUslvTxYxl8V8ZFs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WCcXdW03BKbuJ/oF+i4cezcXKTeQ89SXHSYGvAG/hB08oWz99lODERP2dTUFiydoI
         KytySlI6kDsn8Ch3Kdvg8TSZwCBsgDHT96jwudYa54/L/g5MiH+eUJ6vgn1T9UAeYm
         Mwjacax8LSO2GrZBUugOqu/8D5jDPNW3MsPxfRG4=
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
Subject: [PATCH 5.4 63/87] locking/refcount: Move the bulk of the REFCOUNT_FULL implementation into the <linux/refcount.h> header
Date:   Wed, 27 Jul 2022 18:10:56 +0200
Message-Id: <20220727161011.601518877@linuxfoundation.org>
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

[ Upstream commit 77e9971c79c29542ab7dd4140f9343bf2ff36158 ]

In an effort to improve performance of the REFCOUNT_FULL implementation,
move the bulk of its functions into linux/refcount.h. This allows them
to be inlined in the same way as if they had been provided via
CONFIG_ARCH_HAS_REFCOUNT.

Signed-off-by: Will Deacon <will@kernel.org>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Tested-by: Hanjun Guo <guohanjun@huawei.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Elena Reshetova <elena.reshetova@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20191121115902.2551-5-will@kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/refcount.h | 237 ++++++++++++++++++++++++++++++++++++--
 lib/refcount.c           | 238 +--------------------------------------
 2 files changed, 229 insertions(+), 246 deletions(-)

diff --git a/include/linux/refcount.h b/include/linux/refcount.h
index edd505d1a23b..e719b5b1220e 100644
--- a/include/linux/refcount.h
+++ b/include/linux/refcount.h
@@ -45,22 +45,241 @@ static inline unsigned int refcount_read(const refcount_t *r)
 }
 
 #ifdef CONFIG_REFCOUNT_FULL
+#include <linux/bug.h>
 
 #define REFCOUNT_MAX		(UINT_MAX - 1)
 #define REFCOUNT_SATURATED	UINT_MAX
 
-extern __must_check bool refcount_add_not_zero(int i, refcount_t *r);
-extern void refcount_add(int i, refcount_t *r);
+/*
+ * Variant of atomic_t specialized for reference counts.
+ *
+ * The interface matches the atomic_t interface (to aid in porting) but only
+ * provides the few functions one should use for reference counting.
+ *
+ * It differs in that the counter saturates at REFCOUNT_SATURATED and will not
+ * move once there. This avoids wrapping the counter and causing 'spurious'
+ * use-after-free issues.
+ *
+ * Memory ordering rules are slightly relaxed wrt regular atomic_t functions
+ * and provide only what is strictly required for refcounts.
+ *
+ * The increments are fully relaxed; these will not provide ordering. The
+ * rationale is that whatever is used to obtain the object we're increasing the
+ * reference count on will provide the ordering. For locked data structures,
+ * its the lock acquire, for RCU/lockless data structures its the dependent
+ * load.
+ *
+ * Do note that inc_not_zero() provides a control dependency which will order
+ * future stores against the inc, this ensures we'll never modify the object
+ * if we did not in fact acquire a reference.
+ *
+ * The decrements will provide release order, such that all the prior loads and
+ * stores will be issued before, it also provides a control dependency, which
+ * will order us against the subsequent free().
+ *
+ * The control dependency is against the load of the cmpxchg (ll/sc) that
+ * succeeded. This means the stores aren't fully ordered, but this is fine
+ * because the 1->0 transition indicates no concurrency.
+ *
+ * Note that the allocator is responsible for ordering things between free()
+ * and alloc().
+ *
+ * The decrements dec_and_test() and sub_and_test() also provide acquire
+ * ordering on success.
+ *
+ */
+
+/**
+ * refcount_add_not_zero - add a value to a refcount unless it is 0
+ * @i: the value to add to the refcount
+ * @r: the refcount
+ *
+ * Will saturate at REFCOUNT_SATURATED and WARN.
+ *
+ * Provides no memory ordering, it is assumed the caller has guaranteed the
+ * object memory to be stable (RCU, etc.). It does provide a control dependency
+ * and thereby orders future stores. See the comment on top.
+ *
+ * Use of this function is not recommended for the normal reference counting
+ * use case in which references are taken and released one at a time.  In these
+ * cases, refcount_inc(), or one of its variants, should instead be used to
+ * increment a reference count.
+ *
+ * Return: false if the passed refcount is 0, true otherwise
+ */
+static inline __must_check bool refcount_add_not_zero(int i, refcount_t *r)
+{
+	unsigned int new, val = atomic_read(&r->refs);
+
+	do {
+		if (!val)
+			return false;
+
+		if (unlikely(val == REFCOUNT_SATURATED))
+			return true;
+
+		new = val + i;
+		if (new < val)
+			new = REFCOUNT_SATURATED;
+
+	} while (!atomic_try_cmpxchg_relaxed(&r->refs, &val, new));
+
+	WARN_ONCE(new == REFCOUNT_SATURATED,
+		  "refcount_t: saturated; leaking memory.\n");
+
+	return true;
+}
+
+/**
+ * refcount_add - add a value to a refcount
+ * @i: the value to add to the refcount
+ * @r: the refcount
+ *
+ * Similar to atomic_add(), but will saturate at REFCOUNT_SATURATED and WARN.
+ *
+ * Provides no memory ordering, it is assumed the caller has guaranteed the
+ * object memory to be stable (RCU, etc.). It does provide a control dependency
+ * and thereby orders future stores. See the comment on top.
+ *
+ * Use of this function is not recommended for the normal reference counting
+ * use case in which references are taken and released one at a time.  In these
+ * cases, refcount_inc(), or one of its variants, should instead be used to
+ * increment a reference count.
+ */
+static inline void refcount_add(int i, refcount_t *r)
+{
+	WARN_ONCE(!refcount_add_not_zero(i, r), "refcount_t: addition on 0; use-after-free.\n");
+}
+
+/**
+ * refcount_inc_not_zero - increment a refcount unless it is 0
+ * @r: the refcount to increment
+ *
+ * Similar to atomic_inc_not_zero(), but will saturate at REFCOUNT_SATURATED
+ * and WARN.
+ *
+ * Provides no memory ordering, it is assumed the caller has guaranteed the
+ * object memory to be stable (RCU, etc.). It does provide a control dependency
+ * and thereby orders future stores. See the comment on top.
+ *
+ * Return: true if the increment was successful, false otherwise
+ */
+static inline __must_check bool refcount_inc_not_zero(refcount_t *r)
+{
+	unsigned int new, val = atomic_read(&r->refs);
+
+	do {
+		new = val + 1;
 
-extern __must_check bool refcount_inc_not_zero(refcount_t *r);
-extern void refcount_inc(refcount_t *r);
+		if (!val)
+			return false;
 
-extern __must_check bool refcount_sub_and_test(int i, refcount_t *r);
+		if (unlikely(!new))
+			return true;
 
-extern __must_check bool refcount_dec_and_test(refcount_t *r);
-extern void refcount_dec(refcount_t *r);
+	} while (!atomic_try_cmpxchg_relaxed(&r->refs, &val, new));
+
+	WARN_ONCE(new == REFCOUNT_SATURATED,
+		  "refcount_t: saturated; leaking memory.\n");
+
+	return true;
+}
+
+/**
+ * refcount_inc - increment a refcount
+ * @r: the refcount to increment
+ *
+ * Similar to atomic_inc(), but will saturate at REFCOUNT_SATURATED and WARN.
+ *
+ * Provides no memory ordering, it is assumed the caller already has a
+ * reference on the object.
+ *
+ * Will WARN if the refcount is 0, as this represents a possible use-after-free
+ * condition.
+ */
+static inline void refcount_inc(refcount_t *r)
+{
+	WARN_ONCE(!refcount_inc_not_zero(r), "refcount_t: increment on 0; use-after-free.\n");
+}
+
+/**
+ * refcount_sub_and_test - subtract from a refcount and test if it is 0
+ * @i: amount to subtract from the refcount
+ * @r: the refcount
+ *
+ * Similar to atomic_dec_and_test(), but it will WARN, return false and
+ * ultimately leak on underflow and will fail to decrement when saturated
+ * at REFCOUNT_SATURATED.
+ *
+ * Provides release memory ordering, such that prior loads and stores are done
+ * before, and provides an acquire ordering on success such that free()
+ * must come after.
+ *
+ * Use of this function is not recommended for the normal reference counting
+ * use case in which references are taken and released one at a time.  In these
+ * cases, refcount_dec(), or one of its variants, should instead be used to
+ * decrement a reference count.
+ *
+ * Return: true if the resulting refcount is 0, false otherwise
+ */
+static inline __must_check bool refcount_sub_and_test(int i, refcount_t *r)
+{
+	unsigned int new, val = atomic_read(&r->refs);
+
+	do {
+		if (unlikely(val == REFCOUNT_SATURATED))
+			return false;
+
+		new = val - i;
+		if (new > val) {
+			WARN_ONCE(new > val, "refcount_t: underflow; use-after-free.\n");
+			return false;
+		}
+
+	} while (!atomic_try_cmpxchg_release(&r->refs, &val, new));
+
+	if (!new) {
+		smp_acquire__after_ctrl_dep();
+		return true;
+	}
+	return false;
+
+}
+
+/**
+ * refcount_dec_and_test - decrement a refcount and test if it is 0
+ * @r: the refcount
+ *
+ * Similar to atomic_dec_and_test(), it will WARN on underflow and fail to
+ * decrement when saturated at REFCOUNT_SATURATED.
+ *
+ * Provides release memory ordering, such that prior loads and stores are done
+ * before, and provides an acquire ordering on success such that free()
+ * must come after.
+ *
+ * Return: true if the resulting refcount is 0, false otherwise
+ */
+static inline __must_check bool refcount_dec_and_test(refcount_t *r)
+{
+	return refcount_sub_and_test(1, r);
+}
+
+/**
+ * refcount_dec - decrement a refcount
+ * @r: the refcount
+ *
+ * Similar to atomic_dec(), it will WARN on underflow and fail to decrement
+ * when saturated at REFCOUNT_SATURATED.
+ *
+ * Provides release memory ordering, such that prior loads and stores are done
+ * before.
+ */
+static inline void refcount_dec(refcount_t *r)
+{
+	WARN_ONCE(refcount_dec_and_test(r), "refcount_t: decrement hit 0; leaking memory.\n");
+}
 
-#else
+#else /* CONFIG_REFCOUNT_FULL */
 
 #define REFCOUNT_MAX		INT_MAX
 #define REFCOUNT_SATURATED	(INT_MIN / 2)
@@ -103,7 +322,7 @@ static inline void refcount_dec(refcount_t *r)
 	atomic_dec(&r->refs);
 }
 # endif /* !CONFIG_ARCH_HAS_REFCOUNT */
-#endif /* CONFIG_REFCOUNT_FULL */
+#endif /* !CONFIG_REFCOUNT_FULL */
 
 extern __must_check bool refcount_dec_if_one(refcount_t *r);
 extern __must_check bool refcount_dec_not_one(refcount_t *r);
diff --git a/lib/refcount.c b/lib/refcount.c
index a2f670998cee..3a534fbebdcc 100644
--- a/lib/refcount.c
+++ b/lib/refcount.c
@@ -1,41 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * Variant of atomic_t specialized for reference counts.
- *
- * The interface matches the atomic_t interface (to aid in porting) but only
- * provides the few functions one should use for reference counting.
- *
- * It differs in that the counter saturates at REFCOUNT_SATURATED and will not
- * move once there. This avoids wrapping the counter and causing 'spurious'
- * use-after-free issues.
- *
- * Memory ordering rules are slightly relaxed wrt regular atomic_t functions
- * and provide only what is strictly required for refcounts.
- *
- * The increments are fully relaxed; these will not provide ordering. The
- * rationale is that whatever is used to obtain the object we're increasing the
- * reference count on will provide the ordering. For locked data structures,
- * its the lock acquire, for RCU/lockless data structures its the dependent
- * load.
- *
- * Do note that inc_not_zero() provides a control dependency which will order
- * future stores against the inc, this ensures we'll never modify the object
- * if we did not in fact acquire a reference.
- *
- * The decrements will provide release order, such that all the prior loads and
- * stores will be issued before, it also provides a control dependency, which
- * will order us against the subsequent free().
- *
- * The control dependency is against the load of the cmpxchg (ll/sc) that
- * succeeded. This means the stores aren't fully ordered, but this is fine
- * because the 1->0 transition indicates no concurrency.
- *
- * Note that the allocator is responsible for ordering things between free()
- * and alloc().
- *
- * The decrements dec_and_test() and sub_and_test() also provide acquire
- * ordering on success.
- *
+ * Out-of-line refcount functions common to all refcount implementations.
  */
 
 #include <linux/mutex.h>
@@ -43,207 +8,6 @@
 #include <linux/spinlock.h>
 #include <linux/bug.h>
 
-#ifdef CONFIG_REFCOUNT_FULL
-
-/**
- * refcount_add_not_zero - add a value to a refcount unless it is 0
- * @i: the value to add to the refcount
- * @r: the refcount
- *
- * Will saturate at REFCOUNT_SATURATED and WARN.
- *
- * Provides no memory ordering, it is assumed the caller has guaranteed the
- * object memory to be stable (RCU, etc.). It does provide a control dependency
- * and thereby orders future stores. See the comment on top.
- *
- * Use of this function is not recommended for the normal reference counting
- * use case in which references are taken and released one at a time.  In these
- * cases, refcount_inc(), or one of its variants, should instead be used to
- * increment a reference count.
- *
- * Return: false if the passed refcount is 0, true otherwise
- */
-bool refcount_add_not_zero(int i, refcount_t *r)
-{
-	unsigned int new, val = atomic_read(&r->refs);
-
-	do {
-		if (!val)
-			return false;
-
-		if (unlikely(val == REFCOUNT_SATURATED))
-			return true;
-
-		new = val + i;
-		if (new < val)
-			new = REFCOUNT_SATURATED;
-
-	} while (!atomic_try_cmpxchg_relaxed(&r->refs, &val, new));
-
-	WARN_ONCE(new == REFCOUNT_SATURATED,
-		  "refcount_t: saturated; leaking memory.\n");
-
-	return true;
-}
-EXPORT_SYMBOL(refcount_add_not_zero);
-
-/**
- * refcount_add - add a value to a refcount
- * @i: the value to add to the refcount
- * @r: the refcount
- *
- * Similar to atomic_add(), but will saturate at REFCOUNT_SATURATED and WARN.
- *
- * Provides no memory ordering, it is assumed the caller has guaranteed the
- * object memory to be stable (RCU, etc.). It does provide a control dependency
- * and thereby orders future stores. See the comment on top.
- *
- * Use of this function is not recommended for the normal reference counting
- * use case in which references are taken and released one at a time.  In these
- * cases, refcount_inc(), or one of its variants, should instead be used to
- * increment a reference count.
- */
-void refcount_add(int i, refcount_t *r)
-{
-	WARN_ONCE(!refcount_add_not_zero(i, r), "refcount_t: addition on 0; use-after-free.\n");
-}
-EXPORT_SYMBOL(refcount_add);
-
-/**
- * refcount_inc_not_zero - increment a refcount unless it is 0
- * @r: the refcount to increment
- *
- * Similar to atomic_inc_not_zero(), but will saturate at REFCOUNT_SATURATED
- * and WARN.
- *
- * Provides no memory ordering, it is assumed the caller has guaranteed the
- * object memory to be stable (RCU, etc.). It does provide a control dependency
- * and thereby orders future stores. See the comment on top.
- *
- * Return: true if the increment was successful, false otherwise
- */
-bool refcount_inc_not_zero(refcount_t *r)
-{
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
-}
-EXPORT_SYMBOL(refcount_inc_not_zero);
-
-/**
- * refcount_inc - increment a refcount
- * @r: the refcount to increment
- *
- * Similar to atomic_inc(), but will saturate at REFCOUNT_SATURATED and WARN.
- *
- * Provides no memory ordering, it is assumed the caller already has a
- * reference on the object.
- *
- * Will WARN if the refcount is 0, as this represents a possible use-after-free
- * condition.
- */
-void refcount_inc(refcount_t *r)
-{
-	WARN_ONCE(!refcount_inc_not_zero(r), "refcount_t: increment on 0; use-after-free.\n");
-}
-EXPORT_SYMBOL(refcount_inc);
-
-/**
- * refcount_sub_and_test - subtract from a refcount and test if it is 0
- * @i: amount to subtract from the refcount
- * @r: the refcount
- *
- * Similar to atomic_dec_and_test(), but it will WARN, return false and
- * ultimately leak on underflow and will fail to decrement when saturated
- * at REFCOUNT_SATURATED.
- *
- * Provides release memory ordering, such that prior loads and stores are done
- * before, and provides an acquire ordering on success such that free()
- * must come after.
- *
- * Use of this function is not recommended for the normal reference counting
- * use case in which references are taken and released one at a time.  In these
- * cases, refcount_dec(), or one of its variants, should instead be used to
- * decrement a reference count.
- *
- * Return: true if the resulting refcount is 0, false otherwise
- */
-bool refcount_sub_and_test(int i, refcount_t *r)
-{
-	unsigned int new, val = atomic_read(&r->refs);
-
-	do {
-		if (unlikely(val == REFCOUNT_SATURATED))
-			return false;
-
-		new = val - i;
-		if (new > val) {
-			WARN_ONCE(new > val, "refcount_t: underflow; use-after-free.\n");
-			return false;
-		}
-
-	} while (!atomic_try_cmpxchg_release(&r->refs, &val, new));
-
-	if (!new) {
-		smp_acquire__after_ctrl_dep();
-		return true;
-	}
-	return false;
-
-}
-EXPORT_SYMBOL(refcount_sub_and_test);
-
-/**
- * refcount_dec_and_test - decrement a refcount and test if it is 0
- * @r: the refcount
- *
- * Similar to atomic_dec_and_test(), it will WARN on underflow and fail to
- * decrement when saturated at REFCOUNT_SATURATED.
- *
- * Provides release memory ordering, such that prior loads and stores are done
- * before, and provides an acquire ordering on success such that free()
- * must come after.
- *
- * Return: true if the resulting refcount is 0, false otherwise
- */
-bool refcount_dec_and_test(refcount_t *r)
-{
-	return refcount_sub_and_test(1, r);
-}
-EXPORT_SYMBOL(refcount_dec_and_test);
-
-/**
- * refcount_dec - decrement a refcount
- * @r: the refcount
- *
- * Similar to atomic_dec(), it will WARN on underflow and fail to decrement
- * when saturated at REFCOUNT_SATURATED.
- *
- * Provides release memory ordering, such that prior loads and stores are done
- * before.
- */
-void refcount_dec(refcount_t *r)
-{
-	WARN_ONCE(refcount_dec_and_test(r), "refcount_t: decrement hit 0; leaking memory.\n");
-}
-EXPORT_SYMBOL(refcount_dec);
-
-#endif /* CONFIG_REFCOUNT_FULL */
-
 /**
  * refcount_dec_if_one - decrement a refcount if it is 1
  * @r: the refcount
-- 
2.35.1



