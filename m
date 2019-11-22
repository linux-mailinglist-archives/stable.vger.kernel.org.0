Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D314210650C
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:21:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728194AbfKVGV0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 01:21:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:58008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728495AbfKVFwU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:52:20 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 909C62071F;
        Fri, 22 Nov 2019 05:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401939;
        bh=JB48OivgvDkEPWzY0v698UMzPguwajsoOOPQ3FdxZNA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UxosI2BAfAA15tk6FXDMkw5CVhnEoGWj40Hd1b3q2wD79hGP8TOc60eIvtT7p4brE
         dJieOwClVRrVfvC+BHTKgZ6DByLBUjStcGn76l3yv2DsuZw0t6egxhEvZV+DeRQpMX
         khQB0Sct8Z42mNlo+cukYNvqRCfsCZtwkYVs+gso=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexey Skidanov <alexey.skidanov@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Logan Gunthorpe <logang@deltatee.com>,
        Daniel Mentz <danielmentz@google.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Laura Abbott <labbott@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 164/219] lib/genalloc.c: fix allocation of aligned buffer from non-aligned chunk
Date:   Fri, 22 Nov 2019 00:48:16 -0500
Message-Id: <20191122054911.1750-157-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Skidanov <alexey.skidanov@intel.com>

[ Upstream commit 52fbf1134d479234d7e64ba9dcbaea23405f229e ]

gen_pool_alloc_algo() uses different allocation functions implementing
different allocation algorithms.  With gen_pool_first_fit_align()
allocation function, the returned address should be aligned on the
requested boundary.

If chunk start address isn't aligned on the requested boundary, the
returned address isn't aligned too.  The only way to get properly
aligned address is to initialize the pool with chunks aligned on the
requested boundary.  If want to have an ability to allocate buffers
aligned on different boundaries (for example, 4K, 1MB, ...), the chunk
start address should be aligned on the max possible alignment.

This happens because gen_pool_first_fit_align() looks for properly
aligned memory block without taking into account the chunk start address
alignment.

To fix this, we provide chunk start address to
gen_pool_first_fit_align() and change its implementation such that it
starts looking for properly aligned block with appropriate offset
(exactly as is done in CMA).

Link: https://lkml.kernel.org/lkml/a170cf65-6884-3592-1de9-4c235888cc8a@intel.com
Link: http://lkml.kernel.org/r/1541690953-4623-1-git-send-email-alexey.skidanov@intel.com
Signed-off-by: Alexey Skidanov <alexey.skidanov@intel.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Daniel Mentz <danielmentz@google.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Laura Abbott <labbott@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/genalloc.h | 13 +++++++------
 lib/genalloc.c           | 20 ++++++++++++--------
 2 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/include/linux/genalloc.h b/include/linux/genalloc.h
index 872f930f1b06d..dd0a452373e71 100644
--- a/include/linux/genalloc.h
+++ b/include/linux/genalloc.h
@@ -51,7 +51,8 @@ typedef unsigned long (*genpool_algo_t)(unsigned long *map,
 			unsigned long size,
 			unsigned long start,
 			unsigned int nr,
-			void *data, struct gen_pool *pool);
+			void *data, struct gen_pool *pool,
+			unsigned long start_addr);
 
 /*
  *  General purpose special memory pool descriptor.
@@ -131,24 +132,24 @@ extern void gen_pool_set_algo(struct gen_pool *pool, genpool_algo_t algo,
 
 extern unsigned long gen_pool_first_fit(unsigned long *map, unsigned long size,
 		unsigned long start, unsigned int nr, void *data,
-		struct gen_pool *pool);
+		struct gen_pool *pool, unsigned long start_addr);
 
 extern unsigned long gen_pool_fixed_alloc(unsigned long *map,
 		unsigned long size, unsigned long start, unsigned int nr,
-		void *data, struct gen_pool *pool);
+		void *data, struct gen_pool *pool, unsigned long start_addr);
 
 extern unsigned long gen_pool_first_fit_align(unsigned long *map,
 		unsigned long size, unsigned long start, unsigned int nr,
-		void *data, struct gen_pool *pool);
+		void *data, struct gen_pool *pool, unsigned long start_addr);
 
 
 extern unsigned long gen_pool_first_fit_order_align(unsigned long *map,
 		unsigned long size, unsigned long start, unsigned int nr,
-		void *data, struct gen_pool *pool);
+		void *data, struct gen_pool *pool, unsigned long start_addr);
 
 extern unsigned long gen_pool_best_fit(unsigned long *map, unsigned long size,
 		unsigned long start, unsigned int nr, void *data,
-		struct gen_pool *pool);
+		struct gen_pool *pool, unsigned long start_addr);
 
 
 extern struct gen_pool *devm_gen_pool_create(struct device *dev,
diff --git a/lib/genalloc.c b/lib/genalloc.c
index ca06adc4f4451..5deb25c40a5a1 100644
--- a/lib/genalloc.c
+++ b/lib/genalloc.c
@@ -311,7 +311,7 @@ unsigned long gen_pool_alloc_algo(struct gen_pool *pool, size_t size,
 		end_bit = chunk_size(chunk) >> order;
 retry:
 		start_bit = algo(chunk->bits, end_bit, start_bit,
-				 nbits, data, pool);
+				 nbits, data, pool, chunk->start_addr);
 		if (start_bit >= end_bit)
 			continue;
 		remain = bitmap_set_ll(chunk->bits, start_bit, nbits);
@@ -525,7 +525,7 @@ EXPORT_SYMBOL(gen_pool_set_algo);
  */
 unsigned long gen_pool_first_fit(unsigned long *map, unsigned long size,
 		unsigned long start, unsigned int nr, void *data,
-		struct gen_pool *pool)
+		struct gen_pool *pool, unsigned long start_addr)
 {
 	return bitmap_find_next_zero_area(map, size, start, nr, 0);
 }
@@ -543,16 +543,19 @@ EXPORT_SYMBOL(gen_pool_first_fit);
  */
 unsigned long gen_pool_first_fit_align(unsigned long *map, unsigned long size,
 		unsigned long start, unsigned int nr, void *data,
-		struct gen_pool *pool)
+		struct gen_pool *pool, unsigned long start_addr)
 {
 	struct genpool_data_align *alignment;
-	unsigned long align_mask;
+	unsigned long align_mask, align_off;
 	int order;
 
 	alignment = data;
 	order = pool->min_alloc_order;
 	align_mask = ((alignment->align + (1UL << order) - 1) >> order) - 1;
-	return bitmap_find_next_zero_area(map, size, start, nr, align_mask);
+	align_off = (start_addr & (alignment->align - 1)) >> order;
+
+	return bitmap_find_next_zero_area_off(map, size, start, nr,
+					      align_mask, align_off);
 }
 EXPORT_SYMBOL(gen_pool_first_fit_align);
 
@@ -567,7 +570,7 @@ EXPORT_SYMBOL(gen_pool_first_fit_align);
  */
 unsigned long gen_pool_fixed_alloc(unsigned long *map, unsigned long size,
 		unsigned long start, unsigned int nr, void *data,
-		struct gen_pool *pool)
+		struct gen_pool *pool, unsigned long start_addr)
 {
 	struct genpool_data_fixed *fixed_data;
 	int order;
@@ -601,7 +604,8 @@ EXPORT_SYMBOL(gen_pool_fixed_alloc);
  */
 unsigned long gen_pool_first_fit_order_align(unsigned long *map,
 		unsigned long size, unsigned long start,
-		unsigned int nr, void *data, struct gen_pool *pool)
+		unsigned int nr, void *data, struct gen_pool *pool,
+		unsigned long start_addr)
 {
 	unsigned long align_mask = roundup_pow_of_two(nr) - 1;
 
@@ -624,7 +628,7 @@ EXPORT_SYMBOL(gen_pool_first_fit_order_align);
  */
 unsigned long gen_pool_best_fit(unsigned long *map, unsigned long size,
 		unsigned long start, unsigned int nr, void *data,
-		struct gen_pool *pool)
+		struct gen_pool *pool, unsigned long start_addr)
 {
 	unsigned long start_bit = size;
 	unsigned long len = size + 1;
-- 
2.20.1

