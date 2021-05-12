Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7FDA37C694
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232592AbhELPwX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:52:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:50190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236995AbhELPrr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:47:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7261861CA9;
        Wed, 12 May 2021 15:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833054;
        bh=KvxCS2r/sJ5fzOq8KQ8LJiK1GodnXnWwskqlWJAJwW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dw8CjQTBcWJdp5vjefFTKajhKtK8pv+VixJ5sZzENISvyAKTLH1YV8GwEKFhQ8yeK
         v4UNpEPJ8HLuoMsG30194Bhj+BJFBI44EtX92+JFShQgvxXj+Rrx+gViJSdnbdO9SK
         Eg06KEhKlMeuQq4wFV2cbtWiasIeKuEf2Wa2+Uco=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 517/530] mm/sl?b.c: remove ctor argument from kmem_cache_flags
Date:   Wed, 12 May 2021 16:50:27 +0200
Message-Id: <20210512144836.748442512@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolay Borisov <nborisov@suse.com>

[ Upstream commit 3754000872188e3e4713d9d847fe3c615a47c220 ]

This argument hasn't been used since e153362a50a3 ("slub: Remove objsize
check in kmem_cache_flags()") so simply remove it.

Link: https://lkml.kernel.org/r/20210126095733.974665-1-nborisov@suse.com
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Christoph Lameter <cl@linux.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/slab.c        | 3 +--
 mm/slab.h        | 6 ++----
 mm/slab_common.c | 2 +-
 mm/slub.c        | 9 +++------
 4 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index b1113561b98b..b2cc2cf7d8a3 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1789,8 +1789,7 @@ static int __ref setup_cpu_cache(struct kmem_cache *cachep, gfp_t gfp)
 }
 
 slab_flags_t kmem_cache_flags(unsigned int object_size,
-	slab_flags_t flags, const char *name,
-	void (*ctor)(void *))
+	slab_flags_t flags, const char *name)
 {
 	return flags;
 }
diff --git a/mm/slab.h b/mm/slab.h
index f9977d6613d6..e258ffcfb0ef 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -110,8 +110,7 @@ __kmem_cache_alias(const char *name, unsigned int size, unsigned int align,
 		   slab_flags_t flags, void (*ctor)(void *));
 
 slab_flags_t kmem_cache_flags(unsigned int object_size,
-	slab_flags_t flags, const char *name,
-	void (*ctor)(void *));
+	slab_flags_t flags, const char *name);
 #else
 static inline struct kmem_cache *
 __kmem_cache_alias(const char *name, unsigned int size, unsigned int align,
@@ -119,8 +118,7 @@ __kmem_cache_alias(const char *name, unsigned int size, unsigned int align,
 { return NULL; }
 
 static inline slab_flags_t kmem_cache_flags(unsigned int object_size,
-	slab_flags_t flags, const char *name,
-	void (*ctor)(void *))
+	slab_flags_t flags, const char *name)
 {
 	return flags;
 }
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 8d96679668b4..8f27ccf9f7f3 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -196,7 +196,7 @@ struct kmem_cache *find_mergeable(unsigned int size, unsigned int align,
 	size = ALIGN(size, sizeof(void *));
 	align = calculate_alignment(flags, align, size);
 	size = ALIGN(size, align);
-	flags = kmem_cache_flags(size, flags, name, NULL);
+	flags = kmem_cache_flags(size, flags, name);
 
 	if (flags & SLAB_NEVER_MERGE)
 		return NULL;
diff --git a/mm/slub.c b/mm/slub.c
index fbc415c34009..05a501b67cd5 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1397,7 +1397,6 @@ __setup("slub_debug", setup_slub_debug);
  * @object_size:	the size of an object without meta data
  * @flags:		flags to set
  * @name:		name of the cache
- * @ctor:		constructor function
  *
  * Debug option(s) are applied to @flags. In addition to the debug
  * option(s), if a slab name (or multiple) is specified i.e.
@@ -1405,8 +1404,7 @@ __setup("slub_debug", setup_slub_debug);
  * then only the select slabs will receive the debug option(s).
  */
 slab_flags_t kmem_cache_flags(unsigned int object_size,
-	slab_flags_t flags, const char *name,
-	void (*ctor)(void *))
+	slab_flags_t flags, const char *name)
 {
 	char *iter;
 	size_t len;
@@ -1471,8 +1469,7 @@ static inline void add_full(struct kmem_cache *s, struct kmem_cache_node *n,
 static inline void remove_full(struct kmem_cache *s, struct kmem_cache_node *n,
 					struct page *page) {}
 slab_flags_t kmem_cache_flags(unsigned int object_size,
-	slab_flags_t flags, const char *name,
-	void (*ctor)(void *))
+	slab_flags_t flags, const char *name)
 {
 	return flags;
 }
@@ -3782,7 +3779,7 @@ static int calculate_sizes(struct kmem_cache *s, int forced_order)
 
 static int kmem_cache_open(struct kmem_cache *s, slab_flags_t flags)
 {
-	s->flags = kmem_cache_flags(s->size, flags, s->name, s->ctor);
+	s->flags = kmem_cache_flags(s->size, flags, s->name);
 #ifdef CONFIG_SLAB_FREELIST_HARDENED
 	s->random = get_random_long();
 #endif
-- 
2.30.2



