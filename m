Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8674246A9F3
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 22:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348215AbhLFVWL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 16:22:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbhLFVWL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 16:22:11 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC8ECC061746;
        Mon,  6 Dec 2021 13:18:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0B4DDCE1413;
        Mon,  6 Dec 2021 21:18:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28F06C341C6;
        Mon,  6 Dec 2021 21:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638825518;
        bh=/XhddiCg/wet9s+60SpDoxdJ+z6damAYn299MNsL6FI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A/ouPLIWL/83WriTs4viTr+X+GLFxVdnbD5C/vtlqEzDAGyC/7LZ7FEayyITOpx0o
         FL8O47Cke+o3k7Bojw80Rbj25uuGwyx7aoKSEkPc0bovAiIHM2B7/NodxFSksW+CLT
         lRAjuJ6suXCfO908N9BnUQRH1nPs6XLqEC2o5PrLIBevmBPyYZR8rj71YR/qKq6Dcr
         ejz5rMVvU0I6kVSaJk1Dif7eK0S4akzLmsJHiiLkxhyracxyWeUCY1zR+7bJiqTlkj
         BZCk73+53a0mdrPOPqhKiMLJzmpmCPsRVeRJ5+mxdiwFyi9nTGReDg1Ta5FElr8cAX
         MnpMnW/z+SpMg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 04/10] tools: Fix math.h breakage
Date:   Mon,  6 Dec 2021 16:17:23 -0500
Message-Id: <20211206211738.1661003-4-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211206211738.1661003-1-sashal@kernel.org>
References: <20211206211738.1661003-1-sashal@kernel.org>
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
index cba226948a0ce..c48bfcb03d57d 100644
--- a/tools/include/linux/kernel.h
+++ b/tools/include/linux/kernel.h
@@ -6,6 +6,7 @@
 #include <stddef.h>
 #include <assert.h>
 #include <linux/compiler.h>
+#include <linux/math.h>
 #include <endian.h>
 #include <byteswap.h>
 
@@ -13,8 +14,6 @@
 #define UINT_MAX	(~0U)
 #endif
 
-#define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
-
 #define PERF_ALIGN(x, a)	__PERF_ALIGN_MASK(x, (typeof(x))(a)-1)
 #define __PERF_ALIGN_MASK(x, mask)	(((x)+(mask))&~(mask))
 
@@ -54,15 +53,6 @@
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
@@ -106,16 +96,6 @@ int scnprintf_pad(char * buf, size_t size, const char * fmt, ...);
 
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

