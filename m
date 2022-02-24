Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D8A64C208A
	for <lists+stable@lfdr.de>; Thu, 24 Feb 2022 01:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245229AbiBXAVO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Feb 2022 19:21:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232969AbiBXAVN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Feb 2022 19:21:13 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A0EA57B3C
        for <stable@vger.kernel.org>; Wed, 23 Feb 2022 16:20:45 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id b64-20020a256743000000b0061e169a5f19so306414ybc.11
        for <stable@vger.kernel.org>; Wed, 23 Feb 2022 16:20:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=d5dLzGHZ/03S2GwnSJZ7atIUIHBRbtyGlBVTRxvEnP4=;
        b=PGhrk29E4gaPK0VSM9m4SYYFNB8byuIYTyilg6iL8qEgAy+DUiTuwXd7DwWukyrYDH
         HODoiwtt41htHibpJCxw2SNj3gA/5wHQTPpT3FY7jUCgzKZFwnrFWiRL9etRFbbYwpfp
         ZDbOwmboFlG6R+8FIOeJ+SE1/iyRV9rtgNBcHSrJGs6nNbTJUdiNe3po+yiRM7lowpcT
         h4COXZ3g1PUUgIYa8UfcVw94kUnoARZHjSwXwBsmjFdxYXGPhHIdAPIgF6sIsUycN28Y
         10boTttMhEfGpNXIS6ZYFYT/yS3orWUjXjSdB4rQGZ32OgUftqMZwsu3cfw6kgEzQSKD
         G3iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=d5dLzGHZ/03S2GwnSJZ7atIUIHBRbtyGlBVTRxvEnP4=;
        b=xbpAhyny+TSGN6XQS/wBG4NGSjlMG4NOrGv2Hlk72XvMCQdD2OYdm3r4c4M+eVZUxw
         0tzNC0NPam4DS2idxIRqBlPXO+Ho1NGiJxNedP0eCYKYwO2wa4PmudSwdReOfJ89j48+
         V5dy7mnFDJ3tD4IcOA69SQyYm1C8mc0h0OQ2qaK0hfpeLoBAsUcBvg8cto9IR8s4rrhb
         lOIJNN6Z9vEtaxm13HcpM7Yh4PWnndKyWCilmC2SCfutIPsplUTjF+mOQ5V1z8V3Regj
         uieaktZUU2r6tA7HXi49fA3ypZKgyeOzcZLFdA8JKTeKeWMYAH3kr+it3sNRt9f3A6zN
         a+RQ==
X-Gm-Message-State: AOAM532m9Ag9++5F9CVUWMbzpXry4nPctu4nFXZggq+CRazj5rWGijdZ
        7NDyBf2UrU/WYCHLBLvcHCnClVk=
X-Google-Smtp-Source: ABdhPJzHJzd8T2fG9kRGkhwLudz98Mmh+GT6Rb7XdX1haa3CGWXiOCcOvzUyS8xw4PF3T70uQA4HBkA=
X-Received: from pcc-desktop.svl.corp.google.com ([2620:15c:2ce:200:ef38:18a6:8640:7dc1])
 (user=pcc job=sendgmr) by 2002:a25:7:0:b0:623:abbe:e6e9 with SMTP id
 7-20020a250007000000b00623abbee6e9mr200654yba.547.1645662044312; Wed, 23 Feb
 2022 16:20:44 -0800 (PST)
Date:   Wed, 23 Feb 2022 16:20:24 -0800
Message-Id: <20220224002024.429707-1-pcc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [PATCH v2] kasan: fix more unit tests with CONFIG_UBSAN_LOCAL_BOUNDS enabled
From:   Peter Collingbourne <pcc@google.com>
To:     Andrey Konovalov <andreyknvl@gmail.com>,
        Marco Elver <elver@google.com>
Cc:     Peter Collingbourne <pcc@google.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Daniel Micay <danielmicay@gmail.com>,
        kasan-dev@googlegroups.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
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
v2:
- use OPTIMIZER_HIDE_VAR instead of volatile

 lib/test_kasan.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/lib/test_kasan.c b/lib/test_kasan.c
index 26a5c9007653..7c3dfb569445 100644
--- a/lib/test_kasan.c
+++ b/lib/test_kasan.c
@@ -185,6 +185,7 @@ static void kmalloc_pagealloc_oob_right(struct kunit *test)
 	ptr = kmalloc(size, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
+	OPTIMIZER_HIDE_VAR(ptr);
 	KUNIT_EXPECT_KASAN_FAIL(test, ptr[size + OOB_TAG_OFF] = 0);
 
 	kfree(ptr);
@@ -295,6 +296,7 @@ static void krealloc_more_oob_helper(struct kunit *test,
 		KUNIT_EXPECT_KASAN_FAIL(test, ptr2[size2] = 'x');
 
 	/* For all modes first aligned offset after size2 must be inaccessible. */
+	OPTIMIZER_HIDE_VAR(ptr2);
 	KUNIT_EXPECT_KASAN_FAIL(test,
 		ptr2[round_up(size2, KASAN_GRANULE_SIZE)] = 'x');
 
@@ -319,6 +321,8 @@ static void krealloc_less_oob_helper(struct kunit *test,
 	/* Must be accessible for all modes. */
 	ptr2[size2 - 1] = 'x';
 
+	OPTIMIZER_HIDE_VAR(ptr2);
+
 	/* Generic mode is precise, so unaligned size2 must be inaccessible. */
 	if (IS_ENABLED(CONFIG_KASAN_GENERIC))
 		KUNIT_EXPECT_KASAN_FAIL(test, ptr2[size2] = 'x');
-- 
2.35.1.473.g83b2b277ed-goog

