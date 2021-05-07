Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF3F375EF0
	for <lists+stable@lfdr.de>; Fri,  7 May 2021 04:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbhEGDAZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 May 2021 23:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbhEGDAZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 May 2021 23:00:25 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A797EC061574
        for <stable@vger.kernel.org>; Thu,  6 May 2021 19:59:26 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id r20-20020ac85c940000b02901bac34fa2eeso4848697qta.11
        for <stable@vger.kernel.org>; Thu, 06 May 2021 19:59:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=cappnXSYxw2cm3oj0HniWaga7Ba/fVZpdxdCRyQBgQI=;
        b=T0jAaNJ1iAgJbkofaf6NZ8gQJXENieNf1aT8TLKfVqsxI67fOWoQ4gxSXFqZT91Anw
         LAvOVIkrqnx6oKBhJMx+0Ds7w0CkYuuOuHOgzcR4VRW2ouXdVWxgp4YoHvs192eZTx9d
         jZpgTmH/8tmGpoIFCnqDKvCzbksTjMf4wGYYL4RGmxCA5YTVIupZEydwrjbrzI8ab2eg
         +0vBhVTtk7m+L/YSFjcsWrpXjrJ5ilW9fwvtb6Mvq/Tu1aIC5ri+0cgzQsBD/1PKa9ph
         MExdQGvt/kHvamngnsDL7ZvU96271OwFo2V1fq9PbwvabV1DuScYgiqK4n1HsbQ5ihms
         1sOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=cappnXSYxw2cm3oj0HniWaga7Ba/fVZpdxdCRyQBgQI=;
        b=e97NARBTbI7VlCNLn3hCDWkkZh7jxn2iTUBh1bZH8o65XnBiqS9kmU0+ZYiA/Ar5F3
         lCWPVP56VTnHjQ1UY7yljbQ0jWP4ahhktQ07OF+mMNrjScOzsAtjzgFHBv6GnohD5nrg
         tNEoXpEnQC0FPscPzfhrsFKyX4QSgxxkADtUyYBHc4XhY6gCqkCCh+kFd+GcE2V9z33k
         7hwCXPN9qShRgJJw85yf2KghxA6nsqMmWjy5TxsUsFcBvZ0wVup/toj831yJA3g0wKjv
         NkCbFq7yL6IXajK4Re+g37vClpZxLZ2zwV0+m4exNa7D4q634vr5PiP9N08qTXDzIB7r
         F6/A==
X-Gm-Message-State: AOAM532ARhCzt9jC/No9tkPgmzCDAn+LO8L8+lLzx50c3PdvsKJWbX2C
        tnJ8jRRZADle0M8GGvqvIjqqHNg=
X-Google-Smtp-Source: ABdhPJyC9KO0wmFxpHpvZ0fcEplOrP+wk9GwCVGQxtjM83Icbw9Ewq7in3PAKkxqqceUQ9fhuLypAzM=
X-Received: from pcc-desktop.svl.corp.google.com ([2620:15c:2ce:200:c762:3d3c:b811:8e75])
 (user=pcc job=sendgmr) by 2002:ad4:57a8:: with SMTP id g8mr7789052qvx.46.1620356365656;
 Thu, 06 May 2021 19:59:25 -0700 (PDT)
Date:   Thu,  6 May 2021 19:59:15 -0700
Message-Id: <20210507025915.1464056-1-pcc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.607.g51e8a6a459-goog
Subject: [PATCH v2] kasan: fix unit tests with CONFIG_UBSAN_LOCAL_BOUNDS enabled
From:   Peter Collingbourne <pcc@google.com>
To:     Andrey Konovalov <andreyknvl@gmail.com>,
        Alexander Potapenko <glider@google.com>
Cc:     Peter Collingbourne <pcc@google.com>,
        George Popescu <georgepope@android.com>,
        Elena Petrova <lenaptr@google.com>,
        Evgenii Stepanov <eugenis@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

These tests deliberately access these arrays out of bounds,
which will cause the dynamic local bounds checks inserted by
CONFIG_UBSAN_LOCAL_BOUNDS to fail and panic the kernel. To avoid this
problem, access the arrays via volatile pointers, which will prevent
the compiler from being able to determine the array bounds.

These accesses use volatile pointers to char (char *volatile) rather
than the more conventional pointers to volatile char (volatile char *)
because we want to prevent the compiler from making inferences about
the pointer itself (i.e. its array bounds), not the data that it
refers to.

Signed-off-by: Peter Collingbourne <pcc@google.com>
Cc: stable@vger.kernel.org
Link: https://linux-review.googlesource.com/id/I90b1713fbfa1bf68ff895aef099ea77b98a7c3b9
---
 lib/test_kasan.c | 29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/lib/test_kasan.c b/lib/test_kasan.c
index dc05cfc2d12f..cacbbbdef768 100644
--- a/lib/test_kasan.c
+++ b/lib/test_kasan.c
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
@@ -703,8 +715,9 @@ static void ksize_uaf(struct kunit *test)
 static void kasan_stack_oob(struct kunit *test)
 {
 	char stack_array[10];
-	volatile int i = OOB_TAG_OFF;
-	char *p = &stack_array[ARRAY_SIZE(stack_array) + i];
+	/* See comment in kasan_global_oob. */
+	char *volatile array = stack_array;
+	char *p = &array[ARRAY_SIZE(stack_array) + OOB_TAG_OFF];
 
 	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_STACK);
 
@@ -715,7 +728,9 @@ static void kasan_alloca_oob_left(struct kunit *test)
 {
 	volatile int i = 10;
 	char alloca_array[i];
-	char *p = alloca_array - 1;
+	/* See comment in kasan_global_oob. */
+	char *volatile array = alloca_array;
+	char *p = array - 1;
 
 	/* Only generic mode instruments dynamic allocas. */
 	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_GENERIC);
@@ -728,7 +743,9 @@ static void kasan_alloca_oob_right(struct kunit *test)
 {
 	volatile int i = 10;
 	char alloca_array[i];
-	char *p = alloca_array + i;
+	/* See comment in kasan_global_oob. */
+	char *volatile array = alloca_array;
+	char *p = array + i;
 
 	/* Only generic mode instruments dynamic allocas. */
 	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_GENERIC);
-- 
2.31.1.607.g51e8a6a459-goog

