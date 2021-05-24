Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CDF438EA01
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 16:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233076AbhEXOwL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 10:52:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:55656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233798AbhEXOuL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 10:50:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0DB16140B;
        Mon, 24 May 2021 14:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867663;
        bh=HEYbWVopiiv8JhXlkj0mpt1+zBK4clPd/uzpkSwxRNY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FPaSSbVOZ+GIcVnwZolWZvK0z9T1yh+8KaUPDJNv/SVEOFGWbhfF/VwFubKW2Nv4d
         VNaRFXAX+Vfm1/wSl9DYucJ7NMcFGdBlDudjKdBp6nTytSGtr09Pl/w5D46gZJOfCx
         HECw26ULF/KLUqjPUXZZGuDprsdjQD+g+C5CfSpM98iESyZLtmqn8vLChCwrPlqY6G
         F9/fRrx3dZk3a9br6BCu1MLavjo/UytmfxNECuasQYeFeXwiiyFRUScuDOlTFMo2mb
         61zebPrWjmE+LbO43mBRxgX/AgeBIWyLZDnbK/c0uJ9tWcLRzF5hSS6jSHrKenyBBw
         W/EB4x4e/JtPA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Arnd Bergmann <arnd@arndb.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Yury Norov <yury.norov@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.12 63/63] linux/bits.h: fix compilation error with GENMASK
Date:   Mon, 24 May 2021 10:46:20 -0400
Message-Id: <20210524144620.2497249-63-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144620.2497249-1-sashal@kernel.org>
References: <20210524144620.2497249-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rikard Falkeborn <rikard.falkeborn@gmail.com>

[ Upstream commit f747e6667ebb2ffb8133486c9cd19800d72b0d98 ]

GENMASK() has an input check which uses __builtin_choose_expr() to
enable a compile time sanity check of its inputs if they are known at
compile time.

However, it turns out that __builtin_constant_p() does not always return
a compile time constant [0].  It was thought this problem was fixed with
gcc 4.9 [1], but apparently this is not the case [2].

Switch to use __is_constexpr() instead which always returns a compile time
constant, regardless of its inputs.

Link: https://lore.kernel.org/lkml/42b4342b-aefc-a16a-0d43-9f9c0d63ba7a@rasmusvillemoes.dk [0]
Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=19449 [1]
Link: https://lore.kernel.org/lkml/1ac7bbc2-45d9-26ed-0b33-bf382b8d858b@I-love.SAKURA.ne.jp [2]
Link: https://lkml.kernel.org/r/20210511203716.117010-1-rikard.falkeborn@gmail.com
Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Yury Norov <yury.norov@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bits.h        |  2 +-
 include/linux/const.h       |  8 ++++++++
 include/linux/minmax.h      | 10 ++--------
 tools/include/linux/bits.h  |  2 +-
 tools/include/linux/const.h |  8 ++++++++
 5 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/include/linux/bits.h b/include/linux/bits.h
index 7f475d59a097..87d112650dfb 100644
--- a/include/linux/bits.h
+++ b/include/linux/bits.h
@@ -22,7 +22,7 @@
 #include <linux/build_bug.h>
 #define GENMASK_INPUT_CHECK(h, l) \
 	(BUILD_BUG_ON_ZERO(__builtin_choose_expr( \
-		__builtin_constant_p((l) > (h)), (l) > (h), 0)))
+		__is_constexpr((l) > (h)), (l) > (h), 0)))
 #else
 /*
  * BUILD_BUG_ON_ZERO is not available in h files included from asm files,
diff --git a/include/linux/const.h b/include/linux/const.h
index 81b8aae5a855..435ddd72d2c4 100644
--- a/include/linux/const.h
+++ b/include/linux/const.h
@@ -3,4 +3,12 @@
 
 #include <vdso/const.h>
 
+/*
+ * This returns a constant expression while determining if an argument is
+ * a constant expression, most importantly without evaluating the argument.
+ * Glory to Martin Uecker <Martin.Uecker@med.uni-goettingen.de>
+ */
+#define __is_constexpr(x) \
+	(sizeof(int) == sizeof(*(8 ? ((void *)((long)(x) * 0l)) : (int *)8)))
+
 #endif /* _LINUX_CONST_H */
diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index c0f57b0c64d9..5433c08fcc68 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -2,6 +2,8 @@
 #ifndef _LINUX_MINMAX_H
 #define _LINUX_MINMAX_H
 
+#include <linux/const.h>
+
 /*
  * min()/max()/clamp() macros must accomplish three things:
  *
@@ -17,14 +19,6 @@
 #define __typecheck(x, y) \
 	(!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
 
-/*
- * This returns a constant expression while determining if an argument is
- * a constant expression, most importantly without evaluating the argument.
- * Glory to Martin Uecker <Martin.Uecker@med.uni-goettingen.de>
- */
-#define __is_constexpr(x) \
-	(sizeof(int) == sizeof(*(8 ? ((void *)((long)(x) * 0l)) : (int *)8)))
-
 #define __no_side_effects(x, y) \
 		(__is_constexpr(x) && __is_constexpr(y))
 
diff --git a/tools/include/linux/bits.h b/tools/include/linux/bits.h
index 7f475d59a097..87d112650dfb 100644
--- a/tools/include/linux/bits.h
+++ b/tools/include/linux/bits.h
@@ -22,7 +22,7 @@
 #include <linux/build_bug.h>
 #define GENMASK_INPUT_CHECK(h, l) \
 	(BUILD_BUG_ON_ZERO(__builtin_choose_expr( \
-		__builtin_constant_p((l) > (h)), (l) > (h), 0)))
+		__is_constexpr((l) > (h)), (l) > (h), 0)))
 #else
 /*
  * BUILD_BUG_ON_ZERO is not available in h files included from asm files,
diff --git a/tools/include/linux/const.h b/tools/include/linux/const.h
index 81b8aae5a855..435ddd72d2c4 100644
--- a/tools/include/linux/const.h
+++ b/tools/include/linux/const.h
@@ -3,4 +3,12 @@
 
 #include <vdso/const.h>
 
+/*
+ * This returns a constant expression while determining if an argument is
+ * a constant expression, most importantly without evaluating the argument.
+ * Glory to Martin Uecker <Martin.Uecker@med.uni-goettingen.de>
+ */
+#define __is_constexpr(x) \
+	(sizeof(int) == sizeof(*(8 ? ((void *)((long)(x) * 0l)) : (int *)8)))
+
 #endif /* _LINUX_CONST_H */
-- 
2.30.2

