Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2934062A0
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232100AbhIJApl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:45:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:47332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233793AbhIJAVb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:21:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 954A6610E9;
        Fri, 10 Sep 2021 00:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233221;
        bh=lp3bMKc7ltMLGpiQkCruQ4lRADisdiY261mLg71PxM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sgRq1KEdhe+iyxt/uhvZ+AquLJl/qV7tbF0WAKm+RwvE+2/BU8Me6GQiTmO4K8vZZ
         e0FvUtPYpAVSD7X3GJsXRMIYGF7PyQNz3Y9/4GVGlhcxF2rOlRmU43auwlxvqzUprc
         Br4bhLQtLYWi07ta3NHn167PaOi1/r2mTgNixs+RTxNM3ekz3/KTfbommPw5o2ENkR
         eKg7rBVAF8OkrGWaQ+Yhet6ZpAN2giPL5l5llMVLLAVg0fxDtje1bUbSZVw3zebpSC
         mbTnpMdcwwrmGzmZLSZ6apnxpvH2XgjH6R2puxzbHPc2XetCEflcq7W94qLQLZPpRq
         ezGt46mAiDXqQ==
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
Subject: [PATCH AUTOSEL 5.13 85/88] kasan: test: only do kmalloc_uaf_memset for generic mode
Date:   Thu,  9 Sep 2021 20:18:17 -0400
Message-Id: <20210910001820.174272-85-sashal@kernel.org>
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

[ Upstream commit 25b12a58e848459ae2dbf2e7d318ef168bd1c5e2 ]

kmalloc_uaf_memset() writes to freed memory, which is only safe with the
GENERIC mode (as it uses quarantine).  For other modes, this test corrupts
kernel memory, which might result in a crash.

Only enable kmalloc_uaf_memset() for the GENERIC mode.

Link: https://lkml.kernel.org/r/2e1c87b607b1292556cde3cab2764f108542b60c.1628779805.git.andreyknvl@gmail.com
Signed-off-by: Andrey Konovalov <andreyknvl@gmail.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/test_kasan.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/lib/test_kasan.c b/lib/test_kasan.c
index 00b7061edf59..c8ca85fd5e16 100644
--- a/lib/test_kasan.c
+++ b/lib/test_kasan.c
@@ -523,6 +523,12 @@ static void kmalloc_uaf_memset(struct kunit *test)
 	char *ptr;
 	size_t size = 33;
 
+	/*
+	 * Only generic KASAN uses quarantine, which is required to avoid a
+	 * kernel memory corruption this test causes.
+	 */
+	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_GENERIC);
+
 	ptr = kmalloc(size, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
-- 
2.30.2

