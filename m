Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1144A8DEA
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:34:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354497AbiBCUdv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:33:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354705AbiBCUcp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:32:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39209C06175B;
        Thu,  3 Feb 2022 12:32:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1314B835A4;
        Thu,  3 Feb 2022 20:32:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54A92C340E8;
        Thu,  3 Feb 2022 20:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920362;
        bh=eZzWSHHPhuyrfHRIaehmCfV5KOXZOFvWuve5S+I0rBA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H/gn1eWKHg9G1Jzh4vUTocRGn7/mfraGtDHA4ZJflfB8UDOpuTPU9M725XepjoYOC
         K7clCz01S7HWJbOnvHeyT7Un0Ag/d8g8XYN8MnsGlR3uzYtEKwooigznjypT6dqiKD
         om6QNVMQ6SNspT2slORS/t5xOgduqWyxYgg+jpvla3JPlqZNHeO56UsLxr7y1nrjSe
         uwXBfpSV3x6CVcFJ2V0J7GZyyxS6YDXbsfsHjsWN+Pz0VKvTFjxnYKymhO6wdtrjZy
         QQRIrHEsP/CdPWtThG82Z8cNMKDT8ehylQkNRSzWDc8tQZ9t1GVZ5rPsUSYqcgaNAT
         m1gGcHHfw8JnQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marco Elver <elver@google.com>, Nico Pache <npache@redhat.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Brendan Higgins <brendanhiggins@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, kasan-dev@googlegroups.com
Subject: [PATCH AUTOSEL 5.16 52/52] kasan: test: fix compatibility with FORTIFY_SOURCE
Date:   Thu,  3 Feb 2022 15:29:46 -0500
Message-Id: <20220203202947.2304-52-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203202947.2304-1-sashal@kernel.org>
References: <20220203202947.2304-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Elver <elver@google.com>

[ Upstream commit 09c6304e38e440b93a9ebf3f3cf75cd6cb529f91 ]

With CONFIG_FORTIFY_SOURCE enabled, string functions will also perform
dynamic checks using __builtin_object_size(ptr), which when failed will
panic the kernel.

Because the KASAN test deliberately performs out-of-bounds operations,
the kernel panics with FORTIFY_SOURCE, for example:

 | kernel BUG at lib/string_helpers.c:910!
 | invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
 | CPU: 1 PID: 137 Comm: kunit_try_catch Tainted: G    B             5.16.0-rc3+ #3
 | Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
 | RIP: 0010:fortify_panic+0x19/0x1b
 | ...
 | Call Trace:
 |  kmalloc_oob_in_memset.cold+0x16/0x16
 |  ...

Fix it by also hiding `ptr` from the optimizer, which will ensure that
__builtin_object_size() does not return a valid size, preventing
fortified string functions from panicking.

Link: https://lkml.kernel.org/r/20220124160744.1244685-1-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Reported-by: Nico Pache <npache@redhat.com>
Reviewed-by: Nico Pache <npache@redhat.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Brendan Higgins <brendanhiggins@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/test_kasan.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/lib/test_kasan.c b/lib/test_kasan.c
index 0643573f86862..2ef2948261bf8 100644
--- a/lib/test_kasan.c
+++ b/lib/test_kasan.c
@@ -492,6 +492,7 @@ static void kmalloc_oob_in_memset(struct kunit *test)
 	ptr = kmalloc(size, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
+	OPTIMIZER_HIDE_VAR(ptr);
 	OPTIMIZER_HIDE_VAR(size);
 	KUNIT_EXPECT_KASAN_FAIL(test,
 				memset(ptr, 0, size + KASAN_GRANULE_SIZE));
@@ -515,6 +516,7 @@ static void kmalloc_memmove_negative_size(struct kunit *test)
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
 	memset((char *)ptr, 0, 64);
+	OPTIMIZER_HIDE_VAR(ptr);
 	OPTIMIZER_HIDE_VAR(invalid_size);
 	KUNIT_EXPECT_KASAN_FAIL(test,
 		memmove((char *)ptr, (char *)ptr + 4, invalid_size));
@@ -531,6 +533,7 @@ static void kmalloc_memmove_invalid_size(struct kunit *test)
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
 	memset((char *)ptr, 0, 64);
+	OPTIMIZER_HIDE_VAR(ptr);
 	KUNIT_EXPECT_KASAN_FAIL(test,
 		memmove((char *)ptr, (char *)ptr + 4, invalid_size));
 	kfree(ptr);
@@ -869,6 +872,7 @@ static void kasan_memchr(struct kunit *test)
 	ptr = kmalloc(size, GFP_KERNEL | __GFP_ZERO);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
+	OPTIMIZER_HIDE_VAR(ptr);
 	OPTIMIZER_HIDE_VAR(size);
 	KUNIT_EXPECT_KASAN_FAIL(test,
 		kasan_ptr_result = memchr(ptr, '1', size + 1));
@@ -895,6 +899,7 @@ static void kasan_memcmp(struct kunit *test)
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 	memset(arr, 0, sizeof(arr));
 
+	OPTIMIZER_HIDE_VAR(ptr);
 	OPTIMIZER_HIDE_VAR(size);
 	KUNIT_EXPECT_KASAN_FAIL(test,
 		kasan_int_result = memcmp(ptr, arr, size+1));
-- 
2.34.1

