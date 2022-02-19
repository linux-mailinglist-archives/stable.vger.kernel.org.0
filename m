Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CFB84BC490
	for <lists+stable@lfdr.de>; Sat, 19 Feb 2022 02:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239808AbiBSB1J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 20:27:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231910AbiBSB1I (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 20:27:08 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A5CC50E05
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 17:26:49 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-2d61f6c1877so60518197b3.15
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 17:26:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=GR0HxBHdu+1whCHjKpBJmBVcaIZPKqMpbWMwF7BnSY8=;
        b=fMEgejCbPgVKrgzNzH9q5GR2hVegi4vQ9kx5M/fxJ6Nzw+1qN0hW1Lb6fnpPo623y0
         z7BxNjM0rgrWN7APnP4lD1JmREkpk5+puqNSlC6gDkGwg414tKKXaY2IBznKXo9ceKhd
         353poi0NalP1IZYMBO7GR5DS56q1S6LCx/kxLwGKkmQ5AqCblRN5VCRjMBhfQSswc4jF
         6r24V/oUlFGUX+g2GQMgOpeWSSO3FZEOCRVKFzLWmXu/ANnzNQauOSEhByVpOwOYByyX
         7UGrJpjzyRecvgoKD1JayKBtRRwemonvnb2eGUSLth7C+4DaiEfXleVWyHZ3XNNUeTA8
         mo2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=GR0HxBHdu+1whCHjKpBJmBVcaIZPKqMpbWMwF7BnSY8=;
        b=UA/mtmJ4AMGyawb/fLeZDkTAzia5ZKxrn7MRvT5M/4xUCUt43ZaelwkKLfU6gv1j+9
         CCag92nqQivITNgHwuelPvih1Y3cq9u7n0koifazk73GGC/n+DjX7gTLGdrTjy3h5nO1
         BrsokRjG4tfDof4iZYLLRbwTcnldshDFY89Wnk8Yc1rX+rjZz+mt07+b/Fn47B5lkPvG
         Yo7bK1HbHFTkAT3wsUgIiMnijfUqCJERLOAHo2AY0a0COUucjds1zQpK6wd9j8qcI7iD
         3nt0JeuK31yoLGLKNS/vAzUiPY4gwmJ5xqRfVoW5ivq9C7vtnlylsXMEtE+O9W2pgDN6
         u7mQ==
X-Gm-Message-State: AOAM531rUqV9bUtOEemhSSIJhxl2dqPw2KoW8PcOL1h+tBZGxPf5hady
        WxO732NHF62/QhsHKnPHUHFnQz4=
X-Google-Smtp-Source: ABdhPJyKAv/S51NatxlTTYsdmi7kUKMFu2MgGGVbvpFKoRd7A29DxVM5ugfVroTyk9hFZTBctlyYI2c=
X-Received: from pcc-desktop.svl.corp.google.com ([2620:15c:2ce:200:4926:4660:7cdf:2d])
 (user=pcc job=sendgmr) by 2002:a25:ec01:0:b0:61d:917f:66f0 with SMTP id
 j1-20020a25ec01000000b0061d917f66f0mr10067213ybh.22.1645234008848; Fri, 18
 Feb 2022 17:26:48 -0800 (PST)
Date:   Fri, 18 Feb 2022 17:26:43 -0800
Message-Id: <20220219012643.892158-1-pcc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [PATCH] kasan: fix more unit tests with CONFIG_UBSAN_LOCAL_BOUNDS enabled
From:   Peter Collingbourne <pcc@google.com>
To:     Andrey Konovalov <andreyknvl@gmail.com>,
        Marco Elver <elver@google.com>
Cc:     Peter Collingbourne <pcc@google.com>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a followup to commit f649dc0e0d7b ("kasan: fix unit tests
with CONFIG_UBSAN_LOCAL_BOUNDS enabled") that fixes tests that fail
as a result of __alloc_size annotations being added to the kernel
allocator functions.

Link: https://linux-review.googlesource.com/id/I4334cafc5db600fda5cebb851b2ee9fd09fb46cc
Signed-off-by: Peter Collingbourne <pcc@google.com>
Cc: <stable@vger.kernel.org> # 5.16.x
Fixes: c37495d6254c ("slab: add __alloc_size attributes for better bounds checking")
---
 lib/test_kasan.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/lib/test_kasan.c b/lib/test_kasan.c
index 26a5c9007653..3bf8801d0e66 100644
--- a/lib/test_kasan.c
+++ b/lib/test_kasan.c
@@ -177,7 +177,8 @@ static void kmalloc_node_oob_right(struct kunit *test)
  */
 static void kmalloc_pagealloc_oob_right(struct kunit *test)
 {
-	char *ptr;
+	/* See comment in kasan_global_oob_right. */
+	char *volatile ptr;
 	size_t size = KMALLOC_MAX_CACHE_SIZE + 10;
 
 	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_SLUB);
@@ -272,7 +273,8 @@ static void kmalloc_large_oob_right(struct kunit *test)
 static void krealloc_more_oob_helper(struct kunit *test,
 					size_t size1, size_t size2)
 {
-	char *ptr1, *ptr2;
+	/* See comment in kasan_global_oob_right. */
+	char *ptr1, *volatile ptr2;
 	size_t middle;
 
 	KUNIT_ASSERT_LT(test, size1, size2);
@@ -304,7 +306,8 @@ static void krealloc_more_oob_helper(struct kunit *test,
 static void krealloc_less_oob_helper(struct kunit *test,
 					size_t size1, size_t size2)
 {
-	char *ptr1, *ptr2;
+	/* See comment in kasan_global_oob_right. */
+	char *ptr1, *volatile ptr2;
 	size_t middle;
 
 	KUNIT_ASSERT_LT(test, size2, size1);
-- 
2.35.1.473.g83b2b277ed-goog

