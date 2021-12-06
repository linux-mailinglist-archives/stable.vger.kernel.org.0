Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1C7846A973
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 22:15:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350632AbhLFVRo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 16:17:44 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:47030 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350545AbhLFVRk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 16:17:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 487E0CE186A;
        Mon,  6 Dec 2021 21:14:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22D32C341C6;
        Mon,  6 Dec 2021 21:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638825247;
        bh=hZ5XpxQv44gj76Ca1/N1kBlnrk5LvYhDfct2h9hfBMk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xjb4P0xfBnqtsjhgF89ZxaMPqroHGGm7dTbF0CfYCp/L02qZzHJTKnV34Bu5LBHZX
         JKf4VgI4W+b53fm+iOdmWBmsCS3M5XUPYPCuC6eRQNCEOjSLtwXUwzILW6t7hPI1+d
         96/LY2Pfb8IHSZHUIb/pXrmoWPvGiyM/dH6eLIQ4IjEPHtCs7+PpgJmO8aPhi5R6WL
         vcsnlTvAaubxKO7/tZIBLAcY+Ujj1tMpOYMUZhrmkR2r9CR3GmLhslJCFoGktKIN/Y
         CbQHsqdVT6KAe9jIXBMM7FZ2Yjshzv1ELi4dTJjavXwqMjcYE3z5+WTGpNPEw4UOyr
         1kCqhAyjmPrIA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 13/24] tools: Fix math.h breakage
Date:   Mon,  6 Dec 2021 16:12:18 -0500
Message-Id: <20211206211230.1660072-13-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211206211230.1660072-1-sashal@kernel.org>
References: <20211206211230.1660072-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

[ Upstream commit d6e6a27d960f9f07aef0b979c49c6736ede28f75 ]

Commit 98e1385ef24b ("include/linux/radix-tree.h: replace kernel.h with
the necessary inclusions") broke the radix tree test suite in two
different ways; first by including math.h which didn't exist in the
tools directory, and second by removing an implicit include of
spinlock.h before lockdep.h.  Fix both issues.

Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/linux/kernel.h             | 22 +--------------------
 tools/include/linux/math.h               | 25 ++++++++++++++++++++++++
 tools/testing/radix-tree/linux/lockdep.h |  3 +++
 3 files changed, 29 insertions(+), 21 deletions(-)
 create mode 100644 tools/include/linux/math.h

diff --git a/tools/include/linux/kernel.h b/tools/include/linux/kernel.h
index a7e54a08fb54c..3e8df500cfbd4 100644
--- a/tools/include/linux/kernel.h
+++ b/tools/include/linux/kernel.h
@@ -7,6 +7,7 @@
 #include <assert.h>
 #include <linux/build_bug.h>
 #include <linux/compiler.h>
+#include <linux/math.h>
 #include <endian.h>
 #include <byteswap.h>
 
@@ -14,8 +15,6 @@
 #define UINT_MAX	(~0U)
 #endif
 
-#define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
-
 #define PERF_ALIGN(x, a)	__PERF_ALIGN_MASK(x, (typeof(x))(a)-1)
 #define __PERF_ALIGN_MASK(x, mask)	(((x)+(mask))&~(mask))
 
@@ -52,15 +51,6 @@
 	_min1 < _min2 ? _min1 : _min2; })
 #endif
 
-#ifndef roundup
-#define roundup(x, y) (                                \
-{                                                      \
-	const typeof(y) __y = y;		       \
-	(((x) + (__y - 1)) / __y) * __y;	       \
-}                                                      \
-)
-#endif
-
 #ifndef BUG_ON
 #ifdef NDEBUG
 #define BUG_ON(cond) do { if (cond) {} } while (0)
@@ -104,16 +94,6 @@ int scnprintf_pad(char * buf, size_t size, const char * fmt, ...);
 
 #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
 
-/*
- * This looks more complex than it should be. But we need to
- * get the type for the ~ right in round_down (it needs to be
- * as wide as the result!), and we want to evaluate the macro
- * arguments just once each.
- */
-#define __round_mask(x, y) ((__typeof__(x))((y)-1))
-#define round_up(x, y) ((((x)-1) | __round_mask(x, y))+1)
-#define round_down(x, y) ((x) & ~__round_mask(x, y))
-
 #define current_gfp_context(k) 0
 #define synchronize_rcu()
 
diff --git a/tools/include/linux/math.h b/tools/include/linux/math.h
new file mode 100644
index 0000000000000..4e7af99ec9eb4
--- /dev/null
+++ b/tools/include/linux/math.h
@@ -0,0 +1,25 @@
+#ifndef _TOOLS_MATH_H
+#define _TOOLS_MATH_H
+
+/*
+ * This looks more complex than it should be. But we need to
+ * get the type for the ~ right in round_down (it needs to be
+ * as wide as the result!), and we want to evaluate the macro
+ * arguments just once each.
+ */
+#define __round_mask(x, y) ((__typeof__(x))((y)-1))
+#define round_up(x, y) ((((x)-1) | __round_mask(x, y))+1)
+#define round_down(x, y) ((x) & ~__round_mask(x, y))
+
+#define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
+
+#ifndef roundup
+#define roundup(x, y) (                                \
+{                                                      \
+	const typeof(y) __y = y;		       \
+	(((x) + (__y - 1)) / __y) * __y;	       \
+}                                                      \
+)
+#endif
+
+#endif
diff --git a/tools/testing/radix-tree/linux/lockdep.h b/tools/testing/radix-tree/linux/lockdep.h
index 565fccdfe6e95..016cff473cfc4 100644
--- a/tools/testing/radix-tree/linux/lockdep.h
+++ b/tools/testing/radix-tree/linux/lockdep.h
@@ -1,5 +1,8 @@
 #ifndef _LINUX_LOCKDEP_H
 #define _LINUX_LOCKDEP_H
+
+#include <linux/spinlock.h>
+
 struct lock_class_key {
 	unsigned int a;
 };
-- 
2.33.0

