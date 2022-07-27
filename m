Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E601582C34
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239437AbiG0Qnc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:43:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239758AbiG0QnO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:43:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EEAE501A9;
        Wed, 27 Jul 2022 09:30:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C513561A09;
        Wed, 27 Jul 2022 16:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A57CBC433D7;
        Wed, 27 Jul 2022 16:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939415;
        bh=OUyJl/ofS2R449IpCtlkGA3fwfuxpMJvO0sO5mKjdLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b9zCi7rMpq6PrYMnvD1+M/T+QwWLVEysWobJzNDv8OaS1vuVFe7vphA2KgSvdDH3Q
         aOvpq1/EK2vWNEvwBGJsuR5lhaHuq26Knc6i9OAlqEmlcUbrkCJ17d+dPFcHd6yJ45
         +d4b2x/dby+MtJ/RcU3e5c11AakXOILfV5yEOSgM=
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
Subject: [PATCH 5.4 62/87] locking/refcount: Remove unused refcount_*_checked() variants
Date:   Wed, 27 Jul 2022 18:10:55 +0200
Message-Id: <20220727161011.561064175@linuxfoundation.org>
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

[ Upstream commit 7221762c48c6bbbcc6cc51d8b803c06930215e34 ]

The full-fat refcount implementation is exposed via a set of functions
suffixed with "_checked()", the idea being that code can choose to use
the more expensive, yet more secure implementation on a case-by-case
basis.

In reality, this hasn't happened, so with a grand total of zero users,
let's remove the checked variants for now by simply dropping the suffix
and predicating the out-of-line functions on CONFIG_REFCOUNT_FULL=y.

Signed-off-by: Will Deacon <will@kernel.org>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Tested-by: Hanjun Guo <guohanjun@huawei.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Elena Reshetova <elena.reshetova@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20191121115902.2551-4-will@kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/refcount.h | 25 ++++++-------------
 lib/refcount.c           | 54 +++++++++++++++++++++-------------------
 2 files changed, 36 insertions(+), 43 deletions(-)

diff --git a/include/linux/refcount.h b/include/linux/refcount.h
index 89066a1471dd..edd505d1a23b 100644
--- a/include/linux/refcount.h
+++ b/include/linux/refcount.h
@@ -44,32 +44,21 @@ static inline unsigned int refcount_read(const refcount_t *r)
 	return atomic_read(&r->refs);
 }
 
-extern __must_check bool refcount_add_not_zero_checked(int i, refcount_t *r);
-extern void refcount_add_checked(int i, refcount_t *r);
-
-extern __must_check bool refcount_inc_not_zero_checked(refcount_t *r);
-extern void refcount_inc_checked(refcount_t *r);
-
-extern __must_check bool refcount_sub_and_test_checked(int i, refcount_t *r);
-
-extern __must_check bool refcount_dec_and_test_checked(refcount_t *r);
-extern void refcount_dec_checked(refcount_t *r);
-
 #ifdef CONFIG_REFCOUNT_FULL
 
 #define REFCOUNT_MAX		(UINT_MAX - 1)
 #define REFCOUNT_SATURATED	UINT_MAX
 
-#define refcount_add_not_zero	refcount_add_not_zero_checked
-#define refcount_add		refcount_add_checked
+extern __must_check bool refcount_add_not_zero(int i, refcount_t *r);
+extern void refcount_add(int i, refcount_t *r);
 
-#define refcount_inc_not_zero	refcount_inc_not_zero_checked
-#define refcount_inc		refcount_inc_checked
+extern __must_check bool refcount_inc_not_zero(refcount_t *r);
+extern void refcount_inc(refcount_t *r);
 
-#define refcount_sub_and_test	refcount_sub_and_test_checked
+extern __must_check bool refcount_sub_and_test(int i, refcount_t *r);
 
-#define refcount_dec_and_test	refcount_dec_and_test_checked
-#define refcount_dec		refcount_dec_checked
+extern __must_check bool refcount_dec_and_test(refcount_t *r);
+extern void refcount_dec(refcount_t *r);
 
 #else
 
diff --git a/lib/refcount.c b/lib/refcount.c
index 719b0bc42ab1..a2f670998cee 100644
--- a/lib/refcount.c
+++ b/lib/refcount.c
@@ -43,8 +43,10 @@
 #include <linux/spinlock.h>
 #include <linux/bug.h>
 
+#ifdef CONFIG_REFCOUNT_FULL
+
 /**
- * refcount_add_not_zero_checked - add a value to a refcount unless it is 0
+ * refcount_add_not_zero - add a value to a refcount unless it is 0
  * @i: the value to add to the refcount
  * @r: the refcount
  *
@@ -61,7 +63,7 @@
  *
  * Return: false if the passed refcount is 0, true otherwise
  */
-bool refcount_add_not_zero_checked(int i, refcount_t *r)
+bool refcount_add_not_zero(int i, refcount_t *r)
 {
 	unsigned int new, val = atomic_read(&r->refs);
 
@@ -83,10 +85,10 @@ bool refcount_add_not_zero_checked(int i, refcount_t *r)
 
 	return true;
 }
-EXPORT_SYMBOL(refcount_add_not_zero_checked);
+EXPORT_SYMBOL(refcount_add_not_zero);
 
 /**
- * refcount_add_checked - add a value to a refcount
+ * refcount_add - add a value to a refcount
  * @i: the value to add to the refcount
  * @r: the refcount
  *
@@ -101,14 +103,14 @@ EXPORT_SYMBOL(refcount_add_not_zero_checked);
  * cases, refcount_inc(), or one of its variants, should instead be used to
  * increment a reference count.
  */
-void refcount_add_checked(int i, refcount_t *r)
+void refcount_add(int i, refcount_t *r)
 {
-	WARN_ONCE(!refcount_add_not_zero_checked(i, r), "refcount_t: addition on 0; use-after-free.\n");
+	WARN_ONCE(!refcount_add_not_zero(i, r), "refcount_t: addition on 0; use-after-free.\n");
 }
-EXPORT_SYMBOL(refcount_add_checked);
+EXPORT_SYMBOL(refcount_add);
 
 /**
- * refcount_inc_not_zero_checked - increment a refcount unless it is 0
+ * refcount_inc_not_zero - increment a refcount unless it is 0
  * @r: the refcount to increment
  *
  * Similar to atomic_inc_not_zero(), but will saturate at REFCOUNT_SATURATED
@@ -120,7 +122,7 @@ EXPORT_SYMBOL(refcount_add_checked);
  *
  * Return: true if the increment was successful, false otherwise
  */
-bool refcount_inc_not_zero_checked(refcount_t *r)
+bool refcount_inc_not_zero(refcount_t *r)
 {
 	unsigned int new, val = atomic_read(&r->refs);
 
@@ -140,10 +142,10 @@ bool refcount_inc_not_zero_checked(refcount_t *r)
 
 	return true;
 }
-EXPORT_SYMBOL(refcount_inc_not_zero_checked);
+EXPORT_SYMBOL(refcount_inc_not_zero);
 
 /**
- * refcount_inc_checked - increment a refcount
+ * refcount_inc - increment a refcount
  * @r: the refcount to increment
  *
  * Similar to atomic_inc(), but will saturate at REFCOUNT_SATURATED and WARN.
@@ -154,14 +156,14 @@ EXPORT_SYMBOL(refcount_inc_not_zero_checked);
  * Will WARN if the refcount is 0, as this represents a possible use-after-free
  * condition.
  */
-void refcount_inc_checked(refcount_t *r)
+void refcount_inc(refcount_t *r)
 {
-	WARN_ONCE(!refcount_inc_not_zero_checked(r), "refcount_t: increment on 0; use-after-free.\n");
+	WARN_ONCE(!refcount_inc_not_zero(r), "refcount_t: increment on 0; use-after-free.\n");
 }
-EXPORT_SYMBOL(refcount_inc_checked);
+EXPORT_SYMBOL(refcount_inc);
 
 /**
- * refcount_sub_and_test_checked - subtract from a refcount and test if it is 0
+ * refcount_sub_and_test - subtract from a refcount and test if it is 0
  * @i: amount to subtract from the refcount
  * @r: the refcount
  *
@@ -180,7 +182,7 @@ EXPORT_SYMBOL(refcount_inc_checked);
  *
  * Return: true if the resulting refcount is 0, false otherwise
  */
-bool refcount_sub_and_test_checked(int i, refcount_t *r)
+bool refcount_sub_and_test(int i, refcount_t *r)
 {
 	unsigned int new, val = atomic_read(&r->refs);
 
@@ -203,10 +205,10 @@ bool refcount_sub_and_test_checked(int i, refcount_t *r)
 	return false;
 
 }
-EXPORT_SYMBOL(refcount_sub_and_test_checked);
+EXPORT_SYMBOL(refcount_sub_and_test);
 
 /**
- * refcount_dec_and_test_checked - decrement a refcount and test if it is 0
+ * refcount_dec_and_test - decrement a refcount and test if it is 0
  * @r: the refcount
  *
  * Similar to atomic_dec_and_test(), it will WARN on underflow and fail to
@@ -218,14 +220,14 @@ EXPORT_SYMBOL(refcount_sub_and_test_checked);
  *
  * Return: true if the resulting refcount is 0, false otherwise
  */
-bool refcount_dec_and_test_checked(refcount_t *r)
+bool refcount_dec_and_test(refcount_t *r)
 {
-	return refcount_sub_and_test_checked(1, r);
+	return refcount_sub_and_test(1, r);
 }
-EXPORT_SYMBOL(refcount_dec_and_test_checked);
+EXPORT_SYMBOL(refcount_dec_and_test);
 
 /**
- * refcount_dec_checked - decrement a refcount
+ * refcount_dec - decrement a refcount
  * @r: the refcount
  *
  * Similar to atomic_dec(), it will WARN on underflow and fail to decrement
@@ -234,11 +236,13 @@ EXPORT_SYMBOL(refcount_dec_and_test_checked);
  * Provides release memory ordering, such that prior loads and stores are done
  * before.
  */
-void refcount_dec_checked(refcount_t *r)
+void refcount_dec(refcount_t *r)
 {
-	WARN_ONCE(refcount_dec_and_test_checked(r), "refcount_t: decrement hit 0; leaking memory.\n");
+	WARN_ONCE(refcount_dec_and_test(r), "refcount_t: decrement hit 0; leaking memory.\n");
 }
-EXPORT_SYMBOL(refcount_dec_checked);
+EXPORT_SYMBOL(refcount_dec);
+
+#endif /* CONFIG_REFCOUNT_FULL */
 
 /**
  * refcount_dec_if_one - decrement a refcount if it is 1
-- 
2.35.1



