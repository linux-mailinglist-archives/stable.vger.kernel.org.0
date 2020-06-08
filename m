Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE8C1F2976
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731523AbgFIAAf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:00:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:47260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731334AbgFHXWf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:22:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E8CC208A7;
        Mon,  8 Jun 2020 23:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658555;
        bh=7MEs8mH5lq7ukU7R4BgPgqm8mW6mI4J84W5oXclRFJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ChFaNaiMHlEED7js2jFjIXG/MtAOIRd/a2KdL779KZSpPFgVVy/laJYHVEAyl8xrw
         /sPP2hNPReksoNXRZp3ozpO5tjpYKiyLqPU6qxSniKwVXPP/3HGT8lxEccrbUnNd4o
         dUTl1+a4HQHfyNuCUrndqsWysd57lQZO+geqFqBc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Axtens <dja@axtens.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Gow <davidgow@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Daniel Micay <danielmicay@gmail.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Alexander Potapenko <glider@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, kasan-dev@googlegroups.com
Subject: [PATCH AUTOSEL 5.4 174/175] kasan: stop tests being eliminated as dead code with FORTIFY_SOURCE
Date:   Mon,  8 Jun 2020 19:18:47 -0400
Message-Id: <20200608231848.3366970-174-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231848.3366970-1-sashal@kernel.org>
References: <20200608231848.3366970-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Axtens <dja@axtens.net>

[ Upstream commit adb72ae1915db28f934e9e02c18bfcea2f3ed3b7 ]

Patch series "Fix some incompatibilites between KASAN and FORTIFY_SOURCE", v4.

3 KASAN self-tests fail on a kernel with both KASAN and FORTIFY_SOURCE:
memchr, memcmp and strlen.

When FORTIFY_SOURCE is on, a number of functions are replaced with
fortified versions, which attempt to check the sizes of the operands.
However, these functions often directly invoke __builtin_foo() once they
have performed the fortify check.  The compiler can detect that the
results of these functions are not used, and knows that they have no other
side effects, and so can eliminate them as dead code.

Why are only memchr, memcmp and strlen affected?
================================================

Of string and string-like functions, kasan_test tests:

 * strchr  ->  not affected, no fortified version
 * strrchr ->  likewise
 * strcmp  ->  likewise
 * strncmp ->  likewise

 * strnlen ->  not affected, the fortify source implementation calls the
               underlying strnlen implementation which is instrumented, not
               a builtin

 * strlen  ->  affected, the fortify souce implementation calls a __builtin
               version which the compiler can determine is dead.

 * memchr  ->  likewise
 * memcmp  ->  likewise

 * memset ->   not affected, the compiler knows that memset writes to its
	       first argument and therefore is not dead.

Why does this not affect the functions normally?
================================================

In string.h, these functions are not marked as __pure, so the compiler
cannot know that they do not have side effects.  If relevant functions are
marked as __pure in string.h, we see the following warnings and the
functions are elided:

lib/test_kasan.c: In function `kasan_memchr':
lib/test_kasan.c:606:2: warning: statement with no effect [-Wunused-value]
  memchr(ptr, '1', size + 1);
  ^~~~~~~~~~~~~~~~~~~~~~~~~~
lib/test_kasan.c: In function `kasan_memcmp':
lib/test_kasan.c:622:2: warning: statement with no effect [-Wunused-value]
  memcmp(ptr, arr, size+1);
  ^~~~~~~~~~~~~~~~~~~~~~~~
lib/test_kasan.c: In function `kasan_strings':
lib/test_kasan.c:645:2: warning: statement with no effect [-Wunused-value]
  strchr(ptr, '1');
  ^~~~~~~~~~~~~~~~
...

This annotation would make sense to add and could be added at any point,
so the behaviour of test_kasan.c should change.

The fix
=======

Make all the functions that are pure write their results to a global,
which makes them live.  The strlen and memchr tests now pass.

The memcmp test still fails to trigger, which is addressed in the next
patch.

[dja@axtens.net: drop patch 3]
  Link: http://lkml.kernel.org/r/20200424145521.8203-2-dja@axtens.net
Fixes: 0c96350a2d2f ("lib/test_kasan.c: add tests for several string/memory API functions")
Signed-off-by: Daniel Axtens <dja@axtens.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: David Gow <davidgow@google.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Daniel Micay <danielmicay@gmail.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Link: http://lkml.kernel.org/r/20200423154503.5103-1-dja@axtens.net
Link: http://lkml.kernel.org/r/20200423154503.5103-2-dja@axtens.net
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/test_kasan.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/lib/test_kasan.c b/lib/test_kasan.c
index bd3d9ef7d39e..83344c9c38f4 100644
--- a/lib/test_kasan.c
+++ b/lib/test_kasan.c
@@ -22,6 +22,14 @@
 
 #include <asm/page.h>
 
+/*
+ * We assign some test results to these globals to make sure the tests
+ * are not eliminated as dead code.
+ */
+
+int kasan_int_result;
+void *kasan_ptr_result;
+
 /*
  * Note: test functions are marked noinline so that their names appear in
  * reports.
@@ -603,7 +611,7 @@ static noinline void __init kasan_memchr(void)
 	if (!ptr)
 		return;
 
-	memchr(ptr, '1', size + 1);
+	kasan_ptr_result = memchr(ptr, '1', size + 1);
 	kfree(ptr);
 }
 
@@ -619,7 +627,7 @@ static noinline void __init kasan_memcmp(void)
 		return;
 
 	memset(arr, 0, sizeof(arr));
-	memcmp(ptr, arr, size+1);
+	kasan_int_result = memcmp(ptr, arr, size + 1);
 	kfree(ptr);
 }
 
@@ -642,22 +650,22 @@ static noinline void __init kasan_strings(void)
 	 * will likely point to zeroed byte.
 	 */
 	ptr += 16;
-	strchr(ptr, '1');
+	kasan_ptr_result = strchr(ptr, '1');
 
 	pr_info("use-after-free in strrchr\n");
-	strrchr(ptr, '1');
+	kasan_ptr_result = strrchr(ptr, '1');
 
 	pr_info("use-after-free in strcmp\n");
-	strcmp(ptr, "2");
+	kasan_int_result = strcmp(ptr, "2");
 
 	pr_info("use-after-free in strncmp\n");
-	strncmp(ptr, "2", 1);
+	kasan_int_result = strncmp(ptr, "2", 1);
 
 	pr_info("use-after-free in strlen\n");
-	strlen(ptr);
+	kasan_int_result = strlen(ptr);
 
 	pr_info("use-after-free in strnlen\n");
-	strnlen(ptr, 1);
+	kasan_int_result = strnlen(ptr, 1);
 }
 
 static noinline void __init kasan_bitops(void)
@@ -724,11 +732,12 @@ static noinline void __init kasan_bitops(void)
 	__test_and_change_bit(BITS_PER_LONG + BITS_PER_BYTE, bits);
 
 	pr_info("out-of-bounds in test_bit\n");
-	(void)test_bit(BITS_PER_LONG + BITS_PER_BYTE, bits);
+	kasan_int_result = test_bit(BITS_PER_LONG + BITS_PER_BYTE, bits);
 
 #if defined(clear_bit_unlock_is_negative_byte)
 	pr_info("out-of-bounds in clear_bit_unlock_is_negative_byte\n");
-	clear_bit_unlock_is_negative_byte(BITS_PER_LONG + BITS_PER_BYTE, bits);
+	kasan_int_result = clear_bit_unlock_is_negative_byte(BITS_PER_LONG +
+		BITS_PER_BYTE, bits);
 #endif
 	kfree(bits);
 }
-- 
2.25.1

