Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0406B26D7D
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 21:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732587AbfEVT2h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 15:28:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:51278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732581AbfEVT2g (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 15:28:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FD6120675;
        Wed, 22 May 2019 19:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553315;
        bh=wZ0jozuRaDrYGCz/VJ43+6fxZgy24T+t1zY1SZi5jwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X3BhnRMrBLRUPcYzyP0CyZ0oFkMbkynTAfeN1YMuyCw0hraqcsITgvpRmt6CKwBzK
         jwsVxY+JvvqQPGqS/HI93jl2FzvuSjyhziSIoSO1rCarFYIdqGwKooqwVpbzZVk5ED
         o0+/TV2vr6tC6Jmn3e3H5pe4QQ7FEKMs3O/Sp3Ek=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, luto@kernel.org,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 078/244] mm/uaccess: Use 'unsigned long' to placate UBSAN warnings on older GCC versions
Date:   Wed, 22 May 2019 15:23:44 -0400
Message-Id: <20190522192630.24917-78-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192630.24917-1-sashal@kernel.org>
References: <20190522192630.24917-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 29da93fea3ea39ab9b12270cc6be1b70ef201c9e ]

Randy reported objtool triggered on his (GCC-7.4) build:

  lib/strncpy_from_user.o: warning: objtool: strncpy_from_user()+0x315: call to __ubsan_handle_add_overflow() with UACCESS enabled
  lib/strnlen_user.o: warning: objtool: strnlen_user()+0x337: call to __ubsan_handle_sub_overflow() with UACCESS enabled

This is due to UBSAN generating signed-overflow-UB warnings where it
should not. Prior to GCC-8 UBSAN ignored -fwrapv (which the kernel
uses through -fno-strict-overflow).

Make the functions use 'unsigned long' throughout.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: luto@kernel.org
Link: http://lkml.kernel.org/r/20190424072208.754094071@infradead.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/strncpy_from_user.c | 5 +++--
 lib/strnlen_user.c      | 4 ++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/lib/strncpy_from_user.c b/lib/strncpy_from_user.c
index b53e1b5d80f42..e304b54c9c7dd 100644
--- a/lib/strncpy_from_user.c
+++ b/lib/strncpy_from_user.c
@@ -23,10 +23,11 @@
  * hit it), 'max' is the address space maximum (and we return
  * -EFAULT if we hit it).
  */
-static inline long do_strncpy_from_user(char *dst, const char __user *src, long count, unsigned long max)
+static inline long do_strncpy_from_user(char *dst, const char __user *src,
+					unsigned long count, unsigned long max)
 {
 	const struct word_at_a_time constants = WORD_AT_A_TIME_CONSTANTS;
-	long res = 0;
+	unsigned long res = 0;
 
 	/*
 	 * Truncate 'max' to the user-specified limit, so that
diff --git a/lib/strnlen_user.c b/lib/strnlen_user.c
index 60d0bbda8f5e5..184f80f7bacfa 100644
--- a/lib/strnlen_user.c
+++ b/lib/strnlen_user.c
@@ -28,7 +28,7 @@
 static inline long do_strnlen_user(const char __user *src, unsigned long count, unsigned long max)
 {
 	const struct word_at_a_time constants = WORD_AT_A_TIME_CONSTANTS;
-	long align, res = 0;
+	unsigned long align, res = 0;
 	unsigned long c;
 
 	/*
@@ -42,7 +42,7 @@ static inline long do_strnlen_user(const char __user *src, unsigned long count,
 	 * Do everything aligned. But that means that we
 	 * need to also expand the maximum..
 	 */
-	align = (sizeof(long) - 1) & (unsigned long)src;
+	align = (sizeof(unsigned long) - 1) & (unsigned long)src;
 	src -= align;
 	max += align;
 
-- 
2.20.1

