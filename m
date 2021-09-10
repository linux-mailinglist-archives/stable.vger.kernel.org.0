Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AECE94061C6
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241189AbhIJAno (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:43:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:45750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233102AbhIJATZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:19:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26F7A6023D;
        Fri, 10 Sep 2021 00:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233095;
        bh=wos19fGOVa+dBPIMD4N+xn+iAzasPeFp9znejCE5SCE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iS3fSNBCjY0LQ/JXXWO3PBGaDXMWu9oVBfvm5Xx0a8A9ohoTSinsq4Tj1lkZpxaxR
         div1v+TuPd6jyIdS08+ocdrnqOWJo6HlheBqlhsxhQt6FHmHtCtEwm7YC+f9jkMmhv
         zss9qcbaCtcsfelLiPy2b5/5g8m+76EviOPckMdsDTNO76Iy1zQmkRzvwlBtreawoX
         c7KhwSVAz7mBKJbobOct6iC3gtMLR9Yzmt5TpuMKjIHR0GjMQ3eyDMLE71jo3y0bnu
         U76Rsb02RoKZXNFTSD69XFc3LYAvMjD2H32dy02l8xgvT18+hhLuHcMVRmKnwkob9x
         KawV9VtI9aXKw==
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
Subject: [PATCH AUTOSEL 5.14 97/99] kasan: test: clean up ksize_uaf
Date:   Thu,  9 Sep 2021 20:15:56 -0400
Message-Id: <20210910001558.173296-97-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001558.173296-1-sashal@kernel.org>
References: <20210910001558.173296-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Konovalov <andreyknvl@gmail.com>

[ Upstream commit b38fcca339dbcf680c9e43054502608fabc81508 ]

Some KASAN tests use global variables to store function returns values so
that the compiler doesn't optimize away these functions.

ksize_uaf() doesn't call any functions, so it doesn't need to use
kasan_int_result.  Use volatile accesses instead, to be consistent with
other similar tests.

Link: https://lkml.kernel.org/r/a1fc34faca4650f4a6e4dfb3f8d8d82c82eb953a.1628779805.git.andreyknvl@gmail.com
Signed-off-by: Andrey Konovalov <andreyknvl@gmail.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/test_kasan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/test_kasan.c b/lib/test_kasan.c
index 65adde0757a3..564bee50cfa8 100644
--- a/lib/test_kasan.c
+++ b/lib/test_kasan.c
@@ -721,8 +721,8 @@ static void ksize_uaf(struct kunit *test)
 	kfree(ptr);
 
 	KUNIT_EXPECT_KASAN_FAIL(test, ksize(ptr));
-	KUNIT_EXPECT_KASAN_FAIL(test, kasan_int_result = *ptr);
-	KUNIT_EXPECT_KASAN_FAIL(test, kasan_int_result = *(ptr + size));
+	KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[0]);
+	KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[size]);
 }
 
 static void kasan_stack_oob(struct kunit *test)
-- 
2.30.2

