Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3288B4061C5
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241166AbhIJAnn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:43:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:45720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233080AbhIJATX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:19:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82719610A3;
        Fri, 10 Sep 2021 00:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233093;
        bh=qLMh2ILhuB7N7DzYi1DOB591d0xmf7CbQLqtx0HG6hs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J3qnWjPs6b/vf8+EQOLqTTNkckB2fVJ49TxRb4Ryq3N3CjYvhTnRh3SuAJAzhAbUE
         GwDmIV9pYE95sLZ/42pt6Er7UJhCEHrKaKqxOkoV0A0do+ojqZSeynNQ9BRq6MMAUl
         hYSL54Vaiy/kdSXJaMOpQ5CYVsM1YuE7Ycjddb0uxQHo2r68Xy9yg1ZNCHw/GxHkok
         DORVDTHawXOgVIRa0e+MwGYKvgeryRk/0ekIrmBsx3SL/CCQdhStEjllvC2K3q5pkL
         E9GM/kFL2tFWdkxB9CS22HzdeopkxHzppHZG8jPqAM3uKnKgITWIw8c15n62LaPk+x
         /Jlq4/xbsZUmg==
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
Subject: [PATCH AUTOSEL 5.14 96/99] kasan: test: only do kmalloc_uaf_memset for generic mode
Date:   Thu,  9 Sep 2021 20:15:55 -0400
Message-Id: <20210910001558.173296-96-sashal@kernel.org>
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
index c149675300bd..65adde0757a3 100644
--- a/lib/test_kasan.c
+++ b/lib/test_kasan.c
@@ -518,6 +518,12 @@ static void kmalloc_uaf_memset(struct kunit *test)
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

