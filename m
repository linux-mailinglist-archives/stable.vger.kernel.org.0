Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78AF644C819
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 19:57:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233455AbhKJS6x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 13:58:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:54840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233985AbhKJS5b (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 13:57:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5158D61208;
        Wed, 10 Nov 2021 18:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636570209;
        bh=OC9AdtFl0Luu58+OSqyxM3cPfQMfJ0VYOQ+RvWBZb7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CargzpMmn96Y/x4wG3XLBpfEzbNSnaOtrvB+RO/BG8Cv00YLjE/5/XE5iNhVJB7Xb
         cA0m06u2dazpgfxNHeVaoDmOUHPx1DooSVlZKNY16OL7SJwSmln3r03AQXeklLNYDj
         E01opOqDC7wvFpVZ4VVVFznjN+UdpO+1SfFu6rEo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marco Elver <elver@google.com>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Jann Horn <jannh@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 12/26] kfence: always use static branches to guard kfence_alloc()
Date:   Wed, 10 Nov 2021 19:44:11 +0100
Message-Id: <20211110182004.092421111@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211110182003.700594531@linuxfoundation.org>
References: <20211110182003.700594531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Elver <elver@google.com>

commit 07e8481d3c38f461d7b79c1d5c9afe013b162b0c upstream.

Regardless of KFENCE mode (CONFIG_KFENCE_STATIC_KEYS: either using
static keys to gate allocations, or using a simple dynamic branch),
always use a static branch to avoid the dynamic branch in kfence_alloc()
if KFENCE was disabled at boot.

For CONFIG_KFENCE_STATIC_KEYS=n, this now avoids the dynamic branch if
KFENCE was disabled at boot.

To simplify, also unifies the location where kfence_allocation_gate is
read-checked to just be inline in kfence_alloc().

Link: https://lkml.kernel.org/r/20211019102524.2807208-1-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Jann Horn <jannh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/kfence.h |   21 +++++++++++----------
 mm/kfence/core.c       |   16 +++++++---------
 2 files changed, 18 insertions(+), 19 deletions(-)

--- a/include/linux/kfence.h
+++ b/include/linux/kfence.h
@@ -14,6 +14,9 @@
 
 #ifdef CONFIG_KFENCE
 
+#include <linux/atomic.h>
+#include <linux/static_key.h>
+
 /*
  * We allocate an even number of pages, as it simplifies calculations to map
  * address to metadata indices; effectively, the very first page serves as an
@@ -22,13 +25,8 @@
 #define KFENCE_POOL_SIZE ((CONFIG_KFENCE_NUM_OBJECTS + 1) * 2 * PAGE_SIZE)
 extern char *__kfence_pool;
 
-#ifdef CONFIG_KFENCE_STATIC_KEYS
-#include <linux/static_key.h>
 DECLARE_STATIC_KEY_FALSE(kfence_allocation_key);
-#else
-#include <linux/atomic.h>
 extern atomic_t kfence_allocation_gate;
-#endif
 
 /**
  * is_kfence_address() - check if an address belongs to KFENCE pool
@@ -116,13 +114,16 @@ void *__kfence_alloc(struct kmem_cache *
  */
 static __always_inline void *kfence_alloc(struct kmem_cache *s, size_t size, gfp_t flags)
 {
-#ifdef CONFIG_KFENCE_STATIC_KEYS
-	if (static_branch_unlikely(&kfence_allocation_key))
+#if defined(CONFIG_KFENCE_STATIC_KEYS) || CONFIG_KFENCE_SAMPLE_INTERVAL == 0
+	if (!static_branch_unlikely(&kfence_allocation_key))
+		return NULL;
 #else
-	if (unlikely(!atomic_read(&kfence_allocation_gate)))
+	if (!static_branch_likely(&kfence_allocation_key))
+		return NULL;
 #endif
-		return __kfence_alloc(s, size, flags);
-	return NULL;
+	if (likely(atomic_read(&kfence_allocation_gate)))
+		return NULL;
+	return __kfence_alloc(s, size, flags);
 }
 
 /**
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -97,10 +97,11 @@ struct kfence_metadata kfence_metadata[C
 static struct list_head kfence_freelist = LIST_HEAD_INIT(kfence_freelist);
 static DEFINE_RAW_SPINLOCK(kfence_freelist_lock); /* Lock protecting freelist. */
 
-#ifdef CONFIG_KFENCE_STATIC_KEYS
-/* The static key to set up a KFENCE allocation. */
+/*
+ * The static key to set up a KFENCE allocation; or if static keys are not used
+ * to gate allocations, to avoid a load and compare if KFENCE is disabled.
+ */
 DEFINE_STATIC_KEY_FALSE(kfence_allocation_key);
-#endif
 
 /* Gates the allocation, ensuring only one succeeds in a given period. */
 atomic_t kfence_allocation_gate = ATOMIC_INIT(1);
@@ -668,6 +669,8 @@ void __init kfence_init(void)
 		return;
 	}
 
+	if (!IS_ENABLED(CONFIG_KFENCE_STATIC_KEYS))
+		static_branch_enable(&kfence_allocation_key);
 	WRITE_ONCE(kfence_enabled, true);
 	queue_delayed_work(system_unbound_wq, &kfence_timer, 0);
 	pr_info("initialized - using %lu bytes for %d objects at 0x%p-0x%p\n", KFENCE_POOL_SIZE,
@@ -752,12 +755,7 @@ void *__kfence_alloc(struct kmem_cache *
 	    (s->flags & (SLAB_CACHE_DMA | SLAB_CACHE_DMA32)))
 		return NULL;
 
-	/*
-	 * allocation_gate only needs to become non-zero, so it doesn't make
-	 * sense to continue writing to it and pay the associated contention
-	 * cost, in case we have a large number of concurrent allocations.
-	 */
-	if (atomic_read(&kfence_allocation_gate) || atomic_inc_return(&kfence_allocation_gate) > 1)
+	if (atomic_inc_return(&kfence_allocation_gate) > 1)
 		return NULL;
 #ifdef CONFIG_KFENCE_STATIC_KEYS
 	/*


