Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 989E73830C0
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237406AbhEQOaa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:30:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:54856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239640AbhEQO2p (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:28:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A1906162B;
        Mon, 17 May 2021 14:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260871;
        bh=36nyn1CnhMES9ENY/LXJ93aq+G6k9QQAaQp5TxlZVPI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nc/FU5Zr/s3ZXCsIx3mlqN8D9M6oM23rlcjd7yi8CcFgrZRYJjKeWZr0ohBZNGZTv
         SBLcDwqhIz98oP2l0GyCp5b/upUh7fgtJaREVY+GyBvCssUbvbTPdNapOA85gTmPur
         3CcUhazhuoxMz/Yu3oCzLZSX/UfAjHriBTcdqTkE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Collingbourne <pcc@google.com>,
        Alexander Potapenko <glider@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        George Popescu <georgepope@android.com>,
        Elena Petrova <lenaptr@google.com>,
        Evgenii Stepanov <eugenis@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.12 257/363] kasan: fix unit tests with CONFIG_UBSAN_LOCAL_BOUNDS enabled
Date:   Mon, 17 May 2021 16:02:03 +0200
Message-Id: <20210517140311.287340895@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Collingbourne <pcc@google.com>

commit f649dc0e0d7b509c75570ee403723660f5b72ec7 upstream.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/test_kasan.c |   29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

--- a/lib/test_kasan.c
+++ b/lib/test_kasan.c
@@ -646,8 +646,20 @@ static char global_array[10];
 
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
@@ -695,8 +707,9 @@ static void ksize_uaf(struct kunit *test
 static void kasan_stack_oob(struct kunit *test)
 {
 	char stack_array[10];
-	volatile int i = OOB_TAG_OFF;
-	char *p = &stack_array[ARRAY_SIZE(stack_array) + i];
+	/* See comment in kasan_global_oob. */
+	char *volatile array = stack_array;
+	char *p = &array[ARRAY_SIZE(stack_array) + OOB_TAG_OFF];
 
 	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_STACK);
 
@@ -707,7 +720,9 @@ static void kasan_alloca_oob_left(struct
 {
 	volatile int i = 10;
 	char alloca_array[i];
-	char *p = alloca_array - 1;
+	/* See comment in kasan_global_oob. */
+	char *volatile array = alloca_array;
+	char *p = array - 1;
 
 	/* Only generic mode instruments dynamic allocas. */
 	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_GENERIC);
@@ -720,7 +735,9 @@ static void kasan_alloca_oob_right(struc
 {
 	volatile int i = 10;
 	char alloca_array[i];
-	char *p = alloca_array + i;
+	/* See comment in kasan_global_oob. */
+	char *volatile array = alloca_array;
+	char *p = array + i;
 
 	/* Only generic mode instruments dynamic allocas. */
 	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_GENERIC);


