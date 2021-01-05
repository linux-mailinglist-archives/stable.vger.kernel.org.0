Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4422EA29F
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 02:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728554AbhAEBEb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 20:04:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:39222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728373AbhAEBBO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 20:01:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F2F222B37;
        Tue,  5 Jan 2021 01:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609808419;
        bh=iFnS+GBYEsw4jWMBlBq7NIkQVxEv6AgCU7oCMZz5DfY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qGbzzm7GEqvMEL2szIb/jrJCozca7/uajp3Egtc1OGVdcmQDhBeo1TN1LedjwUHdJ
         WhtaKPEEn0vYfoIzAfgy/5uD7dgOsCO1b2zAUfz/MWhSTQKBRjfRy+gXDQzgfVss1f
         yYOd3/SSwjmGnGZyXim5poqcr6TvWkiHr2TqnMH6svtMpW1Y1/VvI5gM3VuVp2s6cR
         piOgt+cfH/Hkm66Uks7QyTrBEKmioHO2dDIen0bDDIiuUa7B4F+LyBK1sAEYVXo3Xd
         yjq0rWzv/FY4gJ6d5qRkH/ybIfY227tsDbvIWjl2YfYq3eWCywJ6R74di5EQHMiKtI
         3nsnnbIOezyVg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Huang Shijie <sjhuang@iluvatar.ai>,
        Shi Jiasheng <jiasheng.shi@iluvatar.ai>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 5/6] lib/genalloc: fix the overflow when size is too big
Date:   Mon,  4 Jan 2021 20:00:11 -0500
Message-Id: <20210105010012.3954626-5-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210105010012.3954626-1-sashal@kernel.org>
References: <20210105010012.3954626-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huang Shijie <sjhuang@iluvatar.ai>

[ Upstream commit 36845663843fc59c5d794e3dc0641472e3e572da ]

Some graphic card has very big memory on chip, such as 32G bytes.

In the following case, it will cause overflow:

    pool = gen_pool_create(PAGE_SHIFT, NUMA_NO_NODE);
    ret = gen_pool_add(pool, 0x1000000, SZ_32G, NUMA_NO_NODE);

    va = gen_pool_alloc(pool, SZ_4G);

The overflow occurs in gen_pool_alloc_algo_owner():

		....
		size = nbits << order;
		....

The @nbits is "int" type, so it will overflow.
Then the gen_pool_avail() will return the wrong value.

This patch converts some "int" to "unsigned long", and
changes the compare code in while.

Link: https://lkml.kernel.org/r/20201229060657.3389-1-sjhuang@iluvatar.ai
Signed-off-by: Huang Shijie <sjhuang@iluvatar.ai>
Reported-by: Shi Jiasheng <jiasheng.shi@iluvatar.ai>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/genalloc.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/lib/genalloc.c b/lib/genalloc.c
index 7e85d1e37a6ea..0b8ee173cf3a6 100644
--- a/lib/genalloc.c
+++ b/lib/genalloc.c
@@ -83,14 +83,14 @@ static int clear_bits_ll(unsigned long *addr, unsigned long mask_to_clear)
  * users set the same bit, one user will return remain bits, otherwise
  * return 0.
  */
-static int bitmap_set_ll(unsigned long *map, int start, int nr)
+static int bitmap_set_ll(unsigned long *map, unsigned long start, unsigned long nr)
 {
 	unsigned long *p = map + BIT_WORD(start);
-	const int size = start + nr;
+	const unsigned long size = start + nr;
 	int bits_to_set = BITS_PER_LONG - (start % BITS_PER_LONG);
 	unsigned long mask_to_set = BITMAP_FIRST_WORD_MASK(start);
 
-	while (nr - bits_to_set >= 0) {
+	while (nr >= bits_to_set) {
 		if (set_bits_ll(p, mask_to_set))
 			return nr;
 		nr -= bits_to_set;
@@ -118,14 +118,15 @@ static int bitmap_set_ll(unsigned long *map, int start, int nr)
  * users clear the same bit, one user will return remain bits,
  * otherwise return 0.
  */
-static int bitmap_clear_ll(unsigned long *map, int start, int nr)
+static unsigned long
+bitmap_clear_ll(unsigned long *map, unsigned long start, unsigned long nr)
 {
 	unsigned long *p = map + BIT_WORD(start);
-	const int size = start + nr;
+	const unsigned long size = start + nr;
 	int bits_to_clear = BITS_PER_LONG - (start % BITS_PER_LONG);
 	unsigned long mask_to_clear = BITMAP_FIRST_WORD_MASK(start);
 
-	while (nr - bits_to_clear >= 0) {
+	while (nr >= bits_to_clear) {
 		if (clear_bits_ll(p, mask_to_clear))
 			return nr;
 		nr -= bits_to_clear;
@@ -184,8 +185,8 @@ int gen_pool_add_virt(struct gen_pool *pool, unsigned long virt, phys_addr_t phy
 		 size_t size, int nid)
 {
 	struct gen_pool_chunk *chunk;
-	int nbits = size >> pool->min_alloc_order;
-	int nbytes = sizeof(struct gen_pool_chunk) +
+	unsigned long nbits = size >> pool->min_alloc_order;
+	unsigned long nbytes = sizeof(struct gen_pool_chunk) +
 				BITS_TO_LONGS(nbits) * sizeof(long);
 
 	chunk = vzalloc_node(nbytes, nid);
@@ -242,7 +243,7 @@ void gen_pool_destroy(struct gen_pool *pool)
 	struct list_head *_chunk, *_next_chunk;
 	struct gen_pool_chunk *chunk;
 	int order = pool->min_alloc_order;
-	int bit, end_bit;
+	unsigned long bit, end_bit;
 
 	list_for_each_safe(_chunk, _next_chunk, &pool->chunks) {
 		chunk = list_entry(_chunk, struct gen_pool_chunk, next_chunk);
@@ -293,7 +294,7 @@ unsigned long gen_pool_alloc_algo(struct gen_pool *pool, size_t size,
 	struct gen_pool_chunk *chunk;
 	unsigned long addr = 0;
 	int order = pool->min_alloc_order;
-	int nbits, start_bit, end_bit, remain;
+	unsigned long nbits, start_bit, end_bit, remain;
 
 #ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
 	BUG_ON(in_nmi());
@@ -376,7 +377,7 @@ void gen_pool_free(struct gen_pool *pool, unsigned long addr, size_t size)
 {
 	struct gen_pool_chunk *chunk;
 	int order = pool->min_alloc_order;
-	int start_bit, nbits, remain;
+	unsigned long start_bit, nbits, remain;
 
 #ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
 	BUG_ON(in_nmi());
@@ -638,7 +639,7 @@ unsigned long gen_pool_best_fit(unsigned long *map, unsigned long size,
 	index = bitmap_find_next_zero_area(map, size, start, nr, 0);
 
 	while (index < size) {
-		int next_bit = find_next_bit(map, size, index + nr);
+		unsigned long next_bit = find_next_bit(map, size, index + nr);
 		if ((next_bit - index) < len) {
 			len = next_bit - index;
 			start_bit = index;
-- 
2.27.0

