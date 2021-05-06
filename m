Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09E2B375CCA
	for <lists+stable@lfdr.de>; Thu,  6 May 2021 23:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbhEFVVh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 May 2021 17:21:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbhEFVVg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 May 2021 17:21:36 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ED30C061574
        for <stable@vger.kernel.org>; Thu,  6 May 2021 14:20:37 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id u126-20020a3792840000b02902e769005fe1so4447155qkd.2
        for <stable@vger.kernel.org>; Thu, 06 May 2021 14:20:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=60xM6FWdjgElSCS5XWClKw4/NbcEaCXtD8Wn+llDojY=;
        b=lQEStBcfVEMc1yoXYY3MarTsg1SDQgI7Ny5pMmobhwnSaRgXYyNx1S0Dl0rl5b5dAa
         nT/I8Vjq/ZeXNEDv/4sX+62k4g1D8fQcPtXMbuM7U3vuEgWRUQSXNypzTRCs+IBPtjxF
         T3ZpkUvsH2mCFZlrVXxdtqZiIGCAM4z/mBsK5UaAbmxxOTODO56eB0q1Ra9/TvYNxpJH
         O1rXgKtLDW6azNO8+Ae5QxedZHz5vINgjhgzqeWJyqF/TIA/jzL2nE88f8DwT2bamPIL
         +kcjsRFwpBUdeZ5GU310OsJvH94W6px+GZE8vZEvF/4fEMwJzKriHBcthwYyMty0PIEV
         9Itw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=60xM6FWdjgElSCS5XWClKw4/NbcEaCXtD8Wn+llDojY=;
        b=YZ2W3yyuQ9sB8zYQcAc2lNgMyVZjxxSzhaVIC6V1txxgaAjTbxtKrBDnOUtYlq3wV7
         mDMbTKSd9jl6SbriChboTZmPo0o6Q8Xd5Nr4LYjFVdpfty3cutlDuNvK5ZU7QHdiNjSU
         PoyqqGO2GyaJVO9FiGwLFfNC1KbPxmxFN+0wBff7fnQp0kPWnFYNfuamvD+ZnNz6qIPt
         Si2QgN2R7TDuPB01eTP/WykZsdJYyuHuTUfX/Z3wy2VpSfJVnk64QtaLUP4hfegA3uvS
         deiKCY8REwXL/PAlQeF/6BLqY55CoLnOHo7IvHC18+d4vXo/BIG31S13ftmKf6rcB+fx
         0PpA==
X-Gm-Message-State: AOAM533UAEL4xoDIMsmzB1YQ9gMqd5TwQF5N2SFbmfVacc3sGX5YWHId
        z69yl171ga5FgVeMsuKiWQ/4apQ=
X-Google-Smtp-Source: ABdhPJyK3cHsHf2SfzmG8t5qd6qZxixqZ0bc7sahr+wiq+4gc81NS5Igtz3Ug+Mc7zcQ8iPn16RKwAA=
X-Received: from pcc-desktop.svl.corp.google.com ([2620:15c:2ce:200:c762:3d3c:b811:8e75])
 (user=pcc job=sendgmr) by 2002:ad4:4e69:: with SMTP id ec9mr6504032qvb.5.1620336036450;
 Thu, 06 May 2021 14:20:36 -0700 (PDT)
Date:   Thu,  6 May 2021 14:20:25 -0700
Message-Id: <20210506212025.815380-1-pcc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.607.g51e8a6a459-goog
Subject: [PATCH] kasan: fix unit tests with CONFIG_UBSAN_LOCAL_BOUNDS enabled
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

Signed-off-by: Peter Collingbourne <pcc@google.com>
Cc: stable@vger.kernel.org
Link: https://linux-review.googlesource.com/id/I90b1713fbfa1bf68ff895aef099ea77b98a7c3b9
---
 lib/test_kasan.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/lib/test_kasan.c b/lib/test_kasan.c
index dc05cfc2d12f..2a078e8e7b8e 100644
--- a/lib/test_kasan.c
+++ b/lib/test_kasan.c
@@ -654,8 +654,8 @@ static char global_array[10];
 
 static void kasan_global_oob(struct kunit *test)
 {
-	volatile int i = 3;
-	char *p = &global_array[ARRAY_SIZE(global_array) + i];
+	char *volatile array = global_array;
+	char *p = &array[ARRAY_SIZE(global_array) + 3];
 
 	/* Only generic mode instruments globals. */
 	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_GENERIC);
@@ -703,8 +703,8 @@ static void ksize_uaf(struct kunit *test)
 static void kasan_stack_oob(struct kunit *test)
 {
 	char stack_array[10];
-	volatile int i = OOB_TAG_OFF;
-	char *p = &stack_array[ARRAY_SIZE(stack_array) + i];
+	char *volatile array = stack_array;
+	char *p = &array[ARRAY_SIZE(stack_array) + OOB_TAG_OFF];
 
 	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_STACK);
 
@@ -715,7 +715,8 @@ static void kasan_alloca_oob_left(struct kunit *test)
 {
 	volatile int i = 10;
 	char alloca_array[i];
-	char *p = alloca_array - 1;
+	char *volatile array = alloca_array;
+	char *p = array - 1;
 
 	/* Only generic mode instruments dynamic allocas. */
 	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_GENERIC);
@@ -728,7 +729,8 @@ static void kasan_alloca_oob_right(struct kunit *test)
 {
 	volatile int i = 10;
 	char alloca_array[i];
-	char *p = alloca_array + i;
+	char *volatile array = alloca_array;
+	char *p = array + i;
 
 	/* Only generic mode instruments dynamic allocas. */
 	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_GENERIC);
-- 
2.31.1.607.g51e8a6a459-goog

