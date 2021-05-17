Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C898C383763
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245463AbhEQPm0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:42:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:52166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343970AbhEQPkG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:40:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1D8861D04;
        Mon, 17 May 2021 14:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262503;
        bh=rT3wyvJlgHTyoEDQhF1w6rnDbcmpWsfqhSKDDCR+MFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ivDTUD2Fd1jq5kHDy5dh7gJsd+Ko4CSxVVCQXUCxxv5bFtJgb/I86FThuwxO+QAvc
         1rQRDHW0mvn/6f/wbfEDVkzqJfBNlBriYKJiejrBbeonnp92YomZtFmpaoLaGXhCID
         zCwZN5sNPEX555/pxFmO4tl/mVOYeFSy1vb3nQnk=
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
Subject: [PATCH 5.10 202/289] kasan: fix unit tests with CONFIG_UBSAN_LOCAL_BOUNDS enabled
Date:   Mon, 17 May 2021 16:02:07 +0200
Message-Id: <20210517140311.915794716@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
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
@@ -449,8 +449,20 @@ static char global_array[10];
 
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
 	if (!IS_ENABLED(CONFIG_KASAN_GENERIC)) {
@@ -479,8 +491,9 @@ static void ksize_unpoisons_memory(struc
 static void kasan_stack_oob(struct kunit *test)
 {
 	char stack_array[10];
-	volatile int i = OOB_TAG_OFF;
-	char *p = &stack_array[ARRAY_SIZE(stack_array) + i];
+	/* See comment in kasan_global_oob. */
+	char *volatile array = stack_array;
+	char *p = &array[ARRAY_SIZE(stack_array) + OOB_TAG_OFF];
 
 	if (!IS_ENABLED(CONFIG_KASAN_STACK)) {
 		kunit_info(test, "CONFIG_KASAN_STACK is not enabled");
@@ -494,7 +507,9 @@ static void kasan_alloca_oob_left(struct
 {
 	volatile int i = 10;
 	char alloca_array[i];
-	char *p = alloca_array - 1;
+	/* See comment in kasan_global_oob. */
+	char *volatile array = alloca_array;
+	char *p = array - 1;
 
 	/* Only generic mode instruments dynamic allocas. */
 	if (!IS_ENABLED(CONFIG_KASAN_GENERIC)) {
@@ -514,7 +529,9 @@ static void kasan_alloca_oob_right(struc
 {
 	volatile int i = 10;
 	char alloca_array[i];
-	char *p = alloca_array + i;
+	/* See comment in kasan_global_oob. */
+	char *volatile array = alloca_array;
+	char *p = array + i;
 
 	/* Only generic mode instruments dynamic allocas. */
 	if (!IS_ENABLED(CONFIG_KASAN_GENERIC)) {


