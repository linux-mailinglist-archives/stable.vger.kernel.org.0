Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D75AA4E9FD9
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 21:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235426AbiC1Tnm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 15:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbiC1Tnm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 15:43:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F42355C367;
        Mon, 28 Mar 2022 12:42:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 866BF6128E;
        Mon, 28 Mar 2022 19:42:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2B1BC340F0;
        Mon, 28 Mar 2022 19:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648496519;
        bh=yg6WkGRZiXN6RT05fbnMqWKZL4qp2s5qQM6TuONT29E=;
        h=From:To:Cc:Subject:Date:From;
        b=d4KmRhr/5+Lo1XwTMWcmhbz86qyi9hSu55um7j+cuygcpF7qVR82x92z8UL3hw/Bl
         2vRnE6RPlQJqfCfMuPZ/+C4ONARwuyjL8yyRWvyNbr8EQbG/GtyPB/yXSNGbrnH4a7
         6SxogLDvRcRemwxc4XII4JWyWwOw6BvWIAVq0io96eY7tvYjZ3Efp1zBJVrexMPrRo
         88v2GKRAkB2bJv1Iq8yT9he0mrOU3a/VvA5peWfbG0jU3s6p/Yzp1fNXhXpkKY330H
         Ut9/qhiVZw2BiT2gYj+xAgVT+pUxdW+D75IF/lY7TcWbWwuhICMnicSpmcK+tjC4Yw
         5eTwTIhnw9yEg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Rutland <mark.rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.17 01/21] atomics: Fix atomic64_{read_acquire,set_release} fallbacks
Date:   Mon, 28 Mar 2022 15:41:36 -0400
Message-Id: <20220328194157.1585642-1-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit dc1b4df09acdca7a89806b28f235cd6d8dcd3d24 ]

Arnd reports that on 32-bit architectures, the fallbacks for
atomic64_read_acquire() and atomic64_set_release() are broken as they
use smp_load_acquire() and smp_store_release() respectively, which do
not work on types larger than the native word size.

Since those contain compiletime_assert_atomic_type(), any attempt to use
those fallbacks will result in a build-time error. e.g. with the
following added to arch/arm/kernel/setup.c:

| void test_atomic64(atomic64_t *v)
| {
|        atomic64_set_release(v, 5);
|        atomic64_read_acquire(v);
| }

The compiler will complain as follows:

| In file included from <command-line>:
| In function 'arch_atomic64_set_release',
|     inlined from 'test_atomic64' at ./include/linux/atomic/atomic-instrumented.h:669:2:
| ././include/linux/compiler_types.h:346:38: error: call to '__compiletime_assert_9' declared with attribute error: Need native word sized stores/loads for atomicity.
|   346 |  _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
|       |                                      ^
| ././include/linux/compiler_types.h:327:4: note: in definition of macro '__compiletime_assert'
|   327 |    prefix ## suffix();    \
|       |    ^~~~~~
| ././include/linux/compiler_types.h:346:2: note: in expansion of macro '_compiletime_assert'
|   346 |  _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
|       |  ^~~~~~~~~~~~~~~~~~~
| ././include/linux/compiler_types.h:349:2: note: in expansion of macro 'compiletime_assert'
|   349 |  compiletime_assert(__native_word(t),    \
|       |  ^~~~~~~~~~~~~~~~~~
| ./include/asm-generic/barrier.h:133:2: note: in expansion of macro 'compiletime_assert_atomic_type'
|   133 |  compiletime_assert_atomic_type(*p);    \
|       |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
| ./include/asm-generic/barrier.h:164:55: note: in expansion of macro '__smp_store_release'
|   164 | #define smp_store_release(p, v) do { kcsan_release(); __smp_store_release(p, v); } while (0)
|       |                                                       ^~~~~~~~~~~~~~~~~~~
| ./include/linux/atomic/atomic-arch-fallback.h:1270:2: note: in expansion of macro 'smp_store_release'
|  1270 |  smp_store_release(&(v)->counter, i);
|       |  ^~~~~~~~~~~~~~~~~
| make[2]: *** [scripts/Makefile.build:288: arch/arm/kernel/setup.o] Error 1
| make[1]: *** [scripts/Makefile.build:550: arch/arm/kernel] Error 2
| make: *** [Makefile:1831: arch/arm] Error 2

Fix this by only using smp_load_acquire() and smp_store_release() for
native atomic types, and otherwise falling back to the regular barriers
necessary for acquire/release semantics, as we do in the more generic
acquire and release fallbacks.

Since the fallback templates are used to generate the atomic64_*() and
atomic_*() operations, the __native_word() check is added to both. For
the atomic_*() operations, which are always 32-bit, the __native_word()
check is redundant but not harmful, as it is always true.

For the example above this works as expected on 32-bit, e.g. for arm
multi_v7_defconfig:

| <test_atomic64>:
|         push    {r4, r5}
|         dmb     ish
|         pldw    [r0]
|         mov     r2, #5
|         mov     r3, #0
|         ldrexd  r4, [r0]
|         strexd  r4, r2, [r0]
|         teq     r4, #0
|         bne     484 <test_atomic64+0x14>
|         ldrexd  r2, [r0]
|         dmb     ish
|         pop     {r4, r5}
|         bx      lr

... and also on 64-bit, e.g. for arm64 defconfig:

| <test_atomic64>:
|         bti     c
|         paciasp
|         mov     x1, #0x5
|         stlr    x1, [x0]
|         ldar    x0, [x0]
|         autiasp
|         ret

Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Boqun Feng <boqun.feng@gmail.com>
Link: https://lore.kernel.org/r/20220207101943.439825-1-mark.rutland@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/atomic/atomic-arch-fallback.h | 38 ++++++++++++++++++---
 scripts/atomic/fallbacks/read_acquire       | 11 +++++-
 scripts/atomic/fallbacks/set_release        |  7 +++-
 3 files changed, 49 insertions(+), 7 deletions(-)

diff --git a/include/linux/atomic/atomic-arch-fallback.h b/include/linux/atomic/atomic-arch-fallback.h
index a3dba31df01e..6db58d180866 100644
--- a/include/linux/atomic/atomic-arch-fallback.h
+++ b/include/linux/atomic/atomic-arch-fallback.h
@@ -151,7 +151,16 @@
 static __always_inline int
 arch_atomic_read_acquire(const atomic_t *v)
 {
-	return smp_load_acquire(&(v)->counter);
+	int ret;
+
+	if (__native_word(atomic_t)) {
+		ret = smp_load_acquire(&(v)->counter);
+	} else {
+		ret = arch_atomic_read(v);
+		__atomic_acquire_fence();
+	}
+
+	return ret;
 }
 #define arch_atomic_read_acquire arch_atomic_read_acquire
 #endif
@@ -160,7 +169,12 @@ arch_atomic_read_acquire(const atomic_t *v)
 static __always_inline void
 arch_atomic_set_release(atomic_t *v, int i)
 {
-	smp_store_release(&(v)->counter, i);
+	if (__native_word(atomic_t)) {
+		smp_store_release(&(v)->counter, i);
+	} else {
+		__atomic_release_fence();
+		arch_atomic_set(v, i);
+	}
 }
 #define arch_atomic_set_release arch_atomic_set_release
 #endif
@@ -1258,7 +1272,16 @@ arch_atomic_dec_if_positive(atomic_t *v)
 static __always_inline s64
 arch_atomic64_read_acquire(const atomic64_t *v)
 {
-	return smp_load_acquire(&(v)->counter);
+	s64 ret;
+
+	if (__native_word(atomic64_t)) {
+		ret = smp_load_acquire(&(v)->counter);
+	} else {
+		ret = arch_atomic64_read(v);
+		__atomic_acquire_fence();
+	}
+
+	return ret;
 }
 #define arch_atomic64_read_acquire arch_atomic64_read_acquire
 #endif
@@ -1267,7 +1290,12 @@ arch_atomic64_read_acquire(const atomic64_t *v)
 static __always_inline void
 arch_atomic64_set_release(atomic64_t *v, s64 i)
 {
-	smp_store_release(&(v)->counter, i);
+	if (__native_word(atomic64_t)) {
+		smp_store_release(&(v)->counter, i);
+	} else {
+		__atomic_release_fence();
+		arch_atomic64_set(v, i);
+	}
 }
 #define arch_atomic64_set_release arch_atomic64_set_release
 #endif
@@ -2358,4 +2386,4 @@ arch_atomic64_dec_if_positive(atomic64_t *v)
 #endif
 
 #endif /* _LINUX_ATOMIC_FALLBACK_H */
-// cca554917d7ea73d5e3e7397dd70c484cad9b2c4
+// 8e2cc06bc0d2c0967d2f8424762bd48555ee40ae
diff --git a/scripts/atomic/fallbacks/read_acquire b/scripts/atomic/fallbacks/read_acquire
index 803ba7561076..a0ea1d26e6b2 100755
--- a/scripts/atomic/fallbacks/read_acquire
+++ b/scripts/atomic/fallbacks/read_acquire
@@ -2,6 +2,15 @@ cat <<EOF
 static __always_inline ${ret}
 arch_${atomic}_read_acquire(const ${atomic}_t *v)
 {
-	return smp_load_acquire(&(v)->counter);
+	${int} ret;
+
+	if (__native_word(${atomic}_t)) {
+		ret = smp_load_acquire(&(v)->counter);
+	} else {
+		ret = arch_${atomic}_read(v);
+		__atomic_acquire_fence();
+	}
+
+	return ret;
 }
 EOF
diff --git a/scripts/atomic/fallbacks/set_release b/scripts/atomic/fallbacks/set_release
index 86ede759f24e..05cdb7f42477 100755
--- a/scripts/atomic/fallbacks/set_release
+++ b/scripts/atomic/fallbacks/set_release
@@ -2,6 +2,11 @@ cat <<EOF
 static __always_inline void
 arch_${atomic}_set_release(${atomic}_t *v, ${int} i)
 {
-	smp_store_release(&(v)->counter, i);
+	if (__native_word(${atomic}_t)) {
+		smp_store_release(&(v)->counter, i);
+	} else {
+		__atomic_release_fence();
+		arch_${atomic}_set(v, i);
+	}
 }
 EOF
-- 
2.34.1

