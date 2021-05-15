Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65ADD381493
	for <lists+stable@lfdr.de>; Sat, 15 May 2021 02:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234521AbhEOA2l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 May 2021 20:28:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:43912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230022AbhEOA2k (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 May 2021 20:28:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E13261176;
        Sat, 15 May 2021 00:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621038448;
        bh=bSGxouT3kOSPsbFK7LM4HYQDu0TSOgVamWpI66joQqU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=MVhk/ftv2XEmif8cs8Sat4o7zjUpCR2ILVcYrfeKc9E5br/mhkRUUZpXBxMu5D4zU
         BveyxaXhEoGZNwcoX5/IZiSgReUdTw3vMeCoDT6yNvG4pRnf+mUZidT/kGqJwZ3z2+
         xeMR1v+hQqRTj40aFyi8qRLjZrXsDKFkgz1x++qg=
Date:   Fri, 14 May 2021 17:27:27 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@gmail.com,
        eugenis@google.com, georgepope@android.com, glider@google.com,
        lenaptr@google.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        pcc@google.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 09/13] kasan: fix unit tests with
 CONFIG_UBSAN_LOCAL_BOUNDS enabled
Message-ID: <20210515002727.2LmnD7uG3%akpm@linux-foundation.org>
In-Reply-To: <20210514172634.9018621171d5334ceee97e95@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Collingbourne <pcc@google.com>
Subject: kasan: fix unit tests with CONFIG_UBSAN_LOCAL_BOUNDS enabled

These tests deliberately access these arrays out of bounds, which will
cause the dynamic local bounds checks inserted by
CONFIG_UBSAN_LOCAL_BOUNDS to fail and panic the kernel.  To avoid this
problem, access the arrays via volatile pointers, which will prevent the
compiler from being able to determine the array bounds.

These accesses use volatile pointers to char (char *volatile) rather than
the more conventional pointers to volatile char (volatile char *) because
we want to prevent the compiler from making inferences about the pointer
itself (i.e.  its array bounds), not the data that it refers to.

Link: https://lkml.kernel.org/r/20210507025915.1464056-1-pcc@google.com
Link: https://linux-review.googlesource.com/id/I90b1713fbfa1bf68ff895aef099ea77b98a7c3b9
Signed-off-by: Peter Collingbourne <pcc@google.com>
Tested-by: Alexander Potapenko <glider@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: George Popescu <georgepope@android.com>
Cc: Elena Petrova <lenaptr@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c |   29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

--- a/lib/test_kasan.c~kasan-fix-unit-tests-with-config_ubsan_local_bounds-enabled
+++ a/lib/test_kasan.c
@@ -654,8 +654,20 @@ static char global_array[10];
 
 static void kasan_global_oob(struct kunit *test)
 {
-	volatile int i = 3;
-	char *p = &global_array[ARRAY_SIZE(global_array) + i];
+	/*
+	 * Deliberate out-of-bounds access. To prevent CONFIG_UBSAN_LOCAL_BOUNDS
+	 * from failing here and panicing the kernel, access the array via a
+	 * volatile pointer, which will prevent the compiler from being able to
+	 * determine the array bounds.
+	 *
+	 * This access uses a volatile pointer to char (char *volatile) rather
+	 * than the more conventional pointer to volatile char (volatile char *)
+	 * because we want to prevent the compiler from making inferences about
+	 * the pointer itself (i.e. its array bounds), not the data that it
+	 * refers to.
+	 */
+	char *volatile array = global_array;
+	char *p = &array[ARRAY_SIZE(global_array) + 3];
 
 	/* Only generic mode instruments globals. */
 	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_GENERIC);
@@ -703,8 +715,9 @@ static void ksize_uaf(struct kunit *test
 static void kasan_stack_oob(struct kunit *test)
 {
 	char stack_array[10];
-	volatile int i = OOB_TAG_OFF;
-	char *p = &stack_array[ARRAY_SIZE(stack_array) + i];
+	/* See comment in kasan_global_oob. */
+	char *volatile array = stack_array;
+	char *p = &array[ARRAY_SIZE(stack_array) + OOB_TAG_OFF];
 
 	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_STACK);
 
@@ -715,7 +728,9 @@ static void kasan_alloca_oob_left(struct
 {
 	volatile int i = 10;
 	char alloca_array[i];
-	char *p = alloca_array - 1;
+	/* See comment in kasan_global_oob. */
+	char *volatile array = alloca_array;
+	char *p = array - 1;
 
 	/* Only generic mode instruments dynamic allocas. */
 	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_GENERIC);
@@ -728,7 +743,9 @@ static void kasan_alloca_oob_right(struc
 {
 	volatile int i = 10;
 	char alloca_array[i];
-	char *p = alloca_array + i;
+	/* See comment in kasan_global_oob. */
+	char *volatile array = alloca_array;
+	char *p = array + i;
 
 	/* Only generic mode instruments dynamic allocas. */
 	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_GENERIC);
_
