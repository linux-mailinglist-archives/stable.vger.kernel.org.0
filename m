Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D33B52EF6E
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731823AbfE3DTL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:19:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:53900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730890AbfE3DTI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:19:08 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65F602474A;
        Thu, 30 May 2019 03:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186347;
        bh=ktULjbtGiu6USQiIsLXH9WoJV2uliWLQyEHGbCjaLcs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xRReyaqO62nHMc1l6UcizGOGusMwC5uTv7PD9ZYLPKBbno/2ltdmmcWRmlZa6dtyV
         0snfoWEtGGQBMycQPfmqe4cI5oS1WQvMkyJElw+OpBTe/bdw0k4cYSzhrJLIdUB7I0
         OcsS4xbLWauETMrShMJBzqLpSjoPd4bZ5OQ0Kpjk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, luto@kernel.org,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 082/193] mm/uaccess: Use unsigned long to placate UBSAN warnings on older GCC versions
Date:   Wed, 29 May 2019 20:05:36 -0700
Message-Id: <20190530030500.276161260@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030446.953835040@linuxfoundation.org>
References: <20190530030446.953835040@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



