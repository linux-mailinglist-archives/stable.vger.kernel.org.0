Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9918C582C43
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235517AbiG0Qoo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:44:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239559AbiG0Qnp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:43:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C70A63D9;
        Wed, 27 Jul 2022 09:30:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 46854619FD;
        Wed, 27 Jul 2022 16:30:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25C01C433C1;
        Wed, 27 Jul 2022 16:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939426;
        bh=Qvf14IuKv1RKcZRvldurAQZascnOvDT/URMan2bY5GM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pyAz1WW/x61kyU9H2mgEdLHWBMjmJ8oqx/VFXTbx2oIdFETtIeDrjND2J9a38ww3B
         QjqO5dWt9DpNS3Hn6DHs+7CITJ18aBInHKlPX9apIGyfLcEgjHlSb8NQJjD8nzQBS0
         xsZdWS9KxyRv5GrqbC6hi0h5xqoc7LDjPSapH4wc=
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
Subject: [PATCH 5.4 65/87] locking/refcount: Move saturation warnings out of line
Date:   Wed, 27 Jul 2022 18:10:58 +0200
Message-Id: <20220727161011.681761418@linuxfoundation.org>
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

[ Upstream commit 1eb085d94256aaa69b00cf5a86e3c5f5bb2bc460 ]

Having the refcount saturation and warnings inline bloats the text,
despite the fact that these paths should never be executed in normal
operation.

Move the refcount saturation and warnings out of line to reduce the
image size when refcount_t checking is enabled. Relative to an x86_64
defconfig, the sizes reported by bloat-o-meter are:

 # defconfig+REFCOUNT_FULL, inline saturation (i.e. before this patch)
 Total: Before=14762076, After=14915442, chg +1.04%

 # defconfig+REFCOUNT_FULL, out-of-line saturation (i.e. after this patch)
 Total: Before=14762076, After=14835497, chg +0.50%

A side-effect of this change is that we now only get one warning per
refcount saturation type, rather than one per problematic call-site.

Signed-off-by: Will Deacon <will@kernel.org>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Tested-by: Hanjun Guo <guohanjun@huawei.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Elena Reshetova <elena.reshetova@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20191121115902.2551-7-will@kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/refcount.h | 39 ++++++++++++++++++++-------------------
 lib/refcount.c           | 28 ++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+), 19 deletions(-)

diff --git a/include/linux/refcount.h b/include/linux/refcount.h
index e3b218d669ce..1cd0a876a789 100644
--- a/include/linux/refcount.h
+++ b/include/linux/refcount.h
@@ -23,6 +23,16 @@ typedef struct refcount_struct {
 
 #define REFCOUNT_INIT(n)	{ .refs = ATOMIC_INIT(n), }
 
+enum refcount_saturation_type {
+	REFCOUNT_ADD_NOT_ZERO_OVF,
+	REFCOUNT_ADD_OVF,
+	REFCOUNT_ADD_UAF,
+	REFCOUNT_SUB_UAF,
+	REFCOUNT_DEC_LEAK,
+};
+
+void refcount_warn_saturate(refcount_t *r, enum refcount_saturation_type t);
+
 /**
  * refcount_set - set a refcount's value
  * @r: the refcount
@@ -154,10 +164,8 @@ static inline __must_check bool refcount_add_not_zero(int i, refcount_t *r)
 			break;
 	} while (!atomic_try_cmpxchg_relaxed(&r->refs, &old, old + i));
 
-	if (unlikely(old < 0 || old + i < 0)) {
-		refcount_set(r, REFCOUNT_SATURATED);
-		WARN_ONCE(1, "refcount_t: saturated; leaking memory.\n");
-	}
+	if (unlikely(old < 0 || old + i < 0))
+		refcount_warn_saturate(r, REFCOUNT_ADD_NOT_ZERO_OVF);
 
 	return old;
 }
@@ -182,11 +190,10 @@ static inline void refcount_add(int i, refcount_t *r)
 {
 	int old = atomic_fetch_add_relaxed(i, &r->refs);
 
-	WARN_ONCE(!old, "refcount_t: addition on 0; use-after-free.\n");
-	if (unlikely(old <= 0 || old + i <= 0)) {
-		refcount_set(r, REFCOUNT_SATURATED);
-		WARN_ONCE(old, "refcount_t: saturated; leaking memory.\n");
-	}
+	if (unlikely(!old))
+		refcount_warn_saturate(r, REFCOUNT_ADD_UAF);
+	else if (unlikely(old < 0 || old + i < 0))
+		refcount_warn_saturate(r, REFCOUNT_ADD_OVF);
 }
 
 /**
@@ -253,10 +260,8 @@ static inline __must_check bool refcount_sub_and_test(int i, refcount_t *r)
 		return true;
 	}
 
-	if (unlikely(old < 0 || old - i < 0)) {
-		refcount_set(r, REFCOUNT_SATURATED);
-		WARN_ONCE(1, "refcount_t: underflow; use-after-free.\n");
-	}
+	if (unlikely(old < 0 || old - i < 0))
+		refcount_warn_saturate(r, REFCOUNT_SUB_UAF);
 
 	return false;
 }
@@ -291,12 +296,8 @@ static inline __must_check bool refcount_dec_and_test(refcount_t *r)
  */
 static inline void refcount_dec(refcount_t *r)
 {
-	int old = atomic_fetch_sub_release(1, &r->refs);
-
-	if (unlikely(old <= 1)) {
-		refcount_set(r, REFCOUNT_SATURATED);
-		WARN_ONCE(1, "refcount_t: decrement hit 0; leaking memory.\n");
-	}
+	if (unlikely(atomic_fetch_sub_release(1, &r->refs) <= 1))
+		refcount_warn_saturate(r, REFCOUNT_DEC_LEAK);
 }
 #else /* CONFIG_REFCOUNT_FULL */
 
diff --git a/lib/refcount.c b/lib/refcount.c
index 3a534fbebdcc..8b7e249c0e10 100644
--- a/lib/refcount.c
+++ b/lib/refcount.c
@@ -8,6 +8,34 @@
 #include <linux/spinlock.h>
 #include <linux/bug.h>
 
+#define REFCOUNT_WARN(str)	WARN_ONCE(1, "refcount_t: " str ".\n")
+
+void refcount_warn_saturate(refcount_t *r, enum refcount_saturation_type t)
+{
+	refcount_set(r, REFCOUNT_SATURATED);
+
+	switch (t) {
+	case REFCOUNT_ADD_NOT_ZERO_OVF:
+		REFCOUNT_WARN("saturated; leaking memory");
+		break;
+	case REFCOUNT_ADD_OVF:
+		REFCOUNT_WARN("saturated; leaking memory");
+		break;
+	case REFCOUNT_ADD_UAF:
+		REFCOUNT_WARN("addition on 0; use-after-free");
+		break;
+	case REFCOUNT_SUB_UAF:
+		REFCOUNT_WARN("underflow; use-after-free");
+		break;
+	case REFCOUNT_DEC_LEAK:
+		REFCOUNT_WARN("decrement hit 0; leaking memory");
+		break;
+	default:
+		REFCOUNT_WARN("unknown saturation event!?");
+	}
+}
+EXPORT_SYMBOL(refcount_warn_saturate);
+
 /**
  * refcount_dec_if_one - decrement a refcount if it is 1
  * @r: the refcount
-- 
2.35.1



