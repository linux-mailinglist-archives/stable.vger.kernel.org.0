Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF9A740628E
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231754AbhIJApf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:45:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:47270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233783AbhIJAV1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:21:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC20E610A3;
        Fri, 10 Sep 2021 00:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233216;
        bh=LhhkR4uPd915AzFFCf1emUMQkLDNsv4SmVumT09VmBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GvgyiBbZcw31KElU7C4AFkI4BD6RBO/VpIvGamQba5+TLuievYzpJN72I89fwVKTw
         y6TLik3uCeoAImr56tpi27i2mcIm67gtKWi0+Jjid5eGVGfzPuK2gmI9/xUucasEt+
         nKdQlp16HAu/G4i7OOz6Kz4gylWWw8ypqyfktTH42cl6tn3lb+gNRHeJRks3EgJZdm
         Pp7GsademkkzHe8jKseWFDgBCfQQ4nh6m8ICNMLVqzZ73MKX+lX7h13XKA6BNqDyqs
         oHbo5lKnobHHRrod84NI6AXNOirCqftAKyyzWW3LkSUF86Rbc9rVkDu2srMFwA3+w+
         6jjlRbQagFBCQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrey Konovalov <andreyknvl@gmail.com>,
        Marco Elver <elver@google.com>,
        Alexander Potapenko <glider@google.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, kasan-dev@googlegroups.com
Subject: [PATCH AUTOSEL 5.13 82/88] kasan: test: avoid writing invalid memory
Date:   Thu,  9 Sep 2021 20:18:14 -0400
Message-Id: <20210910001820.174272-82-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001820.174272-1-sashal@kernel.org>
References: <20210910001820.174272-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Konovalov <andreyknvl@gmail.com>

[ Upstream commit 8fbad19bdcb4b9be8131536e5bb9616ab2e4eeb3 ]

Multiple KASAN tests do writes past the allocated objects or writes to
freed memory.  Turn these writes into reads to avoid corrupting memory.
Otherwise, these tests might lead to crashes with the HW_TAGS mode, as it
neither uses quarantine nor redzones.

Link: https://lkml.kernel.org/r/c3cd2a383e757e27dd9131635fc7d09a48a49cf9.1628779805.git.andreyknvl@gmail.com
Signed-off-by: Andrey Konovalov <andreyknvl@gmail.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/test_kasan.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/lib/test_kasan.c b/lib/test_kasan.c
index cacbbbdef768..ba7ba3962949 100644
--- a/lib/test_kasan.c
+++ b/lib/test_kasan.c
@@ -156,7 +156,7 @@ static void kmalloc_node_oob_right(struct kunit *test)
 	ptr = kmalloc_node(size, GFP_KERNEL, 0);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
-	KUNIT_EXPECT_KASAN_FAIL(test, ptr[size] = 0);
+	KUNIT_EXPECT_KASAN_FAIL(test, ptr[0] = ptr[size]);
 	kfree(ptr);
 }
 
@@ -192,7 +192,7 @@ static void kmalloc_pagealloc_uaf(struct kunit *test)
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 	kfree(ptr);
 
-	KUNIT_EXPECT_KASAN_FAIL(test, ptr[0] = 0);
+	KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[0]);
 }
 
 static void kmalloc_pagealloc_invalid_free(struct kunit *test)
@@ -226,7 +226,7 @@ static void pagealloc_oob_right(struct kunit *test)
 	ptr = page_address(pages);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
-	KUNIT_EXPECT_KASAN_FAIL(test, ptr[size] = 0);
+	KUNIT_EXPECT_KASAN_FAIL(test, ptr[0] = ptr[size]);
 	free_pages((unsigned long)ptr, order);
 }
 
@@ -241,7 +241,7 @@ static void pagealloc_uaf(struct kunit *test)
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 	free_pages((unsigned long)ptr, order);
 
-	KUNIT_EXPECT_KASAN_FAIL(test, ptr[0] = 0);
+	KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[0]);
 }
 
 static void kmalloc_large_oob_right(struct kunit *test)
@@ -503,7 +503,7 @@ static void kmalloc_uaf(struct kunit *test)
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
 	kfree(ptr);
-	KUNIT_EXPECT_KASAN_FAIL(test, *(ptr + 8) = 'x');
+	KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[8]);
 }
 
 static void kmalloc_uaf_memset(struct kunit *test)
@@ -542,7 +542,7 @@ static void kmalloc_uaf2(struct kunit *test)
 		goto again;
 	}
 
-	KUNIT_EXPECT_KASAN_FAIL(test, ptr1[40] = 'x');
+	KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr1)[40]);
 	KUNIT_EXPECT_PTR_NE(test, ptr1, ptr2);
 
 	kfree(ptr2);
@@ -689,7 +689,7 @@ static void ksize_unpoisons_memory(struct kunit *test)
 	ptr[size] = 'x';
 
 	/* This one must. */
-	KUNIT_EXPECT_KASAN_FAIL(test, ptr[real_size] = 'y');
+	KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[real_size]);
 
 	kfree(ptr);
 }
-- 
2.30.2

