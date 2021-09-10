Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28F5840629B
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241806AbhIJApj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:45:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:47312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233791AbhIJAVa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:21:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0462661101;
        Fri, 10 Sep 2021 00:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233220;
        bh=YHMz/GzZ/sOA8EBo2z+1ojsF1Aj48VHu8iW5zVl8Cd4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iccTo1h6n3kh5SIo8W8ofAU5bqHfa5yNxJD5Mqq23q10Gti+fNz84sH9ZXtOHBjmn
         JcFkwIpP/Iy/u6XnaKu1nnKcSWu6jv3JdsK2KeydpjYH2MfkWQrqv6UGyFJheNU9vl
         XHveC80FGKOfntJt89WZWxOw7NSkZESvnJCWGL8YugsQxsV+uf2u0Z7M2C3D7zyOLE
         vudsbsVzTF7jiaBCo1peLFh3eI5f65SWOiDswehzngA6Ryg84Z0mU6VxJB4WXwmiQa
         uNfFTkSD9vsRRf5QAq8CEtER3Idj/rFMf5BlbURx8WV/vi9YbPMTBogs5fAepYrvsT
         vqGg/qYLlzBPQ==
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
Subject: [PATCH AUTOSEL 5.13 84/88] kasan: test: disable kmalloc_memmove_invalid_size for HW_TAGS
Date:   Thu,  9 Sep 2021 20:18:16 -0400
Message-Id: <20210910001820.174272-84-sashal@kernel.org>
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

[ Upstream commit 1b0668be62cfa394903bb368641c80533bf42d5a ]

The HW_TAGS mode doesn't check memmove for negative size.  As a result,
the kmalloc_memmove_invalid_size test corrupts memory, which can result in
a crash.

Disable this test with HW_TAGS KASAN.

Link: https://lkml.kernel.org/r/088733a06ac21eba29aa85b6f769d2abd74f9638.1628779805.git.andreyknvl@gmail.com
Signed-off-by: Andrey Konovalov <andreyknvl@gmail.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/test_kasan.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/lib/test_kasan.c b/lib/test_kasan.c
index 9a6eb3c9dc49..00b7061edf59 100644
--- a/lib/test_kasan.c
+++ b/lib/test_kasan.c
@@ -490,11 +490,17 @@ static void kmalloc_memmove_invalid_size(struct kunit *test)
 	size_t size = 64;
 	volatile size_t invalid_size = -2;
 
+	/*
+	 * Hardware tag-based mode doesn't check memmove for negative size.
+	 * As a result, this test introduces a side-effect memory corruption,
+	 * which can result in a crash.
+	 */
+	KASAN_TEST_NEEDS_CONFIG_OFF(test, CONFIG_KASAN_HW_TAGS);
+
 	ptr = kmalloc(size, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
 	memset((char *)ptr, 0, 64);
-
 	KUNIT_EXPECT_KASAN_FAIL(test,
 		memmove((char *)ptr, (char *)ptr + 4, invalid_size));
 	kfree(ptr);
-- 
2.30.2

