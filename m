Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5388229B898
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:09:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368867AbgJ0PmN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:42:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:54910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1800525AbgJ0PgM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:36:12 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02CC422264;
        Tue, 27 Oct 2020 15:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812971;
        bh=G0WQuRLxXzFU4uOyQTdkr80X88kBuiyFy8XYBj1cn+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aahH+OHrLZV0PhLWIFtSSlPnC1m6vdALxujdAW8HC3BwwdP8dZJc82yt7jqDrG7F+
         GlyhQNg3MsYO/7/hBRBc7kVq5aMfPp0UuzJ1ILmfwI0woSWLUzsHSfDwQQpG0ZLNe4
         Orgj1NdwMYnFrBuBKtD20xWdy1wgYPKM9NBLmFOM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Nick Piggin <npiggin@gmail.com>,
        Hugh Dickins <hughd@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 393/757] mm/page_alloc.c: fix freeing non-compound pages
Date:   Tue, 27 Oct 2020 14:50:43 +0100
Message-Id: <20201027135508.992424257@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit e320d3012d25b1fb5f3df4edb7bd44a1c362ec10 ]

Here is a very rare race which leaks memory:

Page P0 is allocated to the page cache.  Page P1 is free.

Thread A                Thread B                Thread C
find_get_entry():
xas_load() returns P0
						Removes P0 from page cache
						P0 finds its buddy P1
			alloc_pages(GFP_KERNEL, 1) returns P0
			P0 has refcount 1
page_cache_get_speculative(P0)
P0 has refcount 2
			__free_pages(P0)
			P0 has refcount 1
put_page(P0)
P1 is not freed

Fix this by freeing all the pages in __free_pages() that won't be freed
by the call to put_page().  It's usually not a good idea to split a page,
but this is a very unlikely scenario.

Fixes: e286781d5f2e ("mm: speculative page references")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Nick Piggin <npiggin@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20200926213919.26642-1-willy@infradead.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/Kconfig.debug     |  9 +++++++++
 lib/Makefile          |  1 +
 lib/test_free_pages.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 mm/page_alloc.c       |  3 +++
 4 files changed, 55 insertions(+)
 create mode 100644 lib/test_free_pages.c

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 0c781f912f9f0..491789a793ae5 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -2367,6 +2367,15 @@ config TEST_HMM
 
 	  If unsure, say N.
 
+config TEST_FREE_PAGES
+	tristate "Test freeing pages"
+	help
+	  Test that a memory leak does not occur due to a race between
+	  freeing a block of pages and a speculative page reference.
+	  Loading this module is safe if your kernel has the bug fixed.
+	  If the bug is not fixed, it will leak gigabytes of memory and
+	  probably OOM your system.
+
 config TEST_FPU
 	tristate "Test floating point operations in kernel space"
 	depends on X86 && !KCOV_INSTRUMENT_ALL
diff --git a/lib/Makefile b/lib/Makefile
index a4a4c6864f518..071b687b7363f 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -99,6 +99,7 @@ obj-$(CONFIG_TEST_BLACKHOLE_DEV) += test_blackhole_dev.o
 obj-$(CONFIG_TEST_MEMINIT) += test_meminit.o
 obj-$(CONFIG_TEST_LOCKUP) += test_lockup.o
 obj-$(CONFIG_TEST_HMM) += test_hmm.o
+obj-$(CONFIG_TEST_FREE_PAGES) += test_free_pages.o
 
 #
 # CFLAGS for compiling floating point code inside the kernel. x86/Makefile turns
diff --git a/lib/test_free_pages.c b/lib/test_free_pages.c
new file mode 100644
index 0000000000000..074e76bd76b2b
--- /dev/null
+++ b/lib/test_free_pages.c
@@ -0,0 +1,42 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * test_free_pages.c: Check that free_pages() doesn't leak memory
+ * Copyright (c) 2020 Oracle
+ * Author: Matthew Wilcox <willy@infradead.org>
+ */
+
+#include <linux/gfp.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+
+static void test_free_pages(gfp_t gfp)
+{
+	unsigned int i;
+
+	for (i = 0; i < 1000 * 1000; i++) {
+		unsigned long addr = __get_free_pages(gfp, 3);
+		struct page *page = virt_to_page(addr);
+
+		/* Simulate page cache getting a speculative reference */
+		get_page(page);
+		free_pages(addr, 3);
+		put_page(page);
+	}
+}
+
+static int m_in(void)
+{
+	test_free_pages(GFP_KERNEL);
+	test_free_pages(GFP_KERNEL | __GFP_COMP);
+
+	return 0;
+}
+
+static void m_ex(void)
+{
+}
+
+module_init(m_in);
+module_exit(m_ex);
+MODULE_AUTHOR("Matthew Wilcox <willy@infradead.org>");
+MODULE_LICENSE("GPL");
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c449d74f55842..d99c2db7f254f 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4961,6 +4961,9 @@ void __free_pages(struct page *page, unsigned int order)
 {
 	if (put_page_testzero(page))
 		free_the_page(page, order);
+	else if (!PageHead(page))
+		while (order-- > 0)
+			free_the_page(page + (1 << order), order);
 }
 EXPORT_SYMBOL(__free_pages);
 
-- 
2.25.1



